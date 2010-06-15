From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 22/23] bfa: vport fixes
Date: Tue, 15 Jun 2010 11:52:31 -0700
Message-ID: <1276627951-13611-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:42599 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758271Ab0FOSwg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2010 14:52:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: vravindr@brocade.com, rvadivel@brocade.com, kgudipat@brocade.com, amathur@brocade.com, Jing Huang <huangj@brocade.com>

This patch fixes 3 bugs in vport create/delete.
1) Replace scsi_add_host() with scsi_add_host_with_dma()
2) Fix rmmod hang when there are vports configured. This is due to a race
condition between the workqueue destroy in pci remove context and the vport
delete works being handled. The fix is to use a counter to track the
vport delete work, so that workqueue destroy will not be called until all
configured vports are deleted from workqueue.
3) Fix rmmmod crash when there are PBC vport configured. PBC is not allowed
to be deleted dynamically. However, if someone try to delete it, it leaves the
vport is wrong state. The fix is to restore the vport back to original state
when the attempt to delete pbc vport delete is failed.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/bfad_attr.c |    5 ++++-
 drivers/scsi/bfa/bfad_drv.h  |    1 +
 drivers/scsi/bfa/bfad_im.c   |   15 +++++++++++++--
 3 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_attr.c b/drivers/scsi/bfa/bfad_attr.c
index 2b5d5c2..8aa23e9 100644
--- a/drivers/scsi/bfa/bfad_attr.c
+++ b/drivers/scsi/bfa/bfad_attr.c
@@ -862,8 +862,11 @@ bfad_im_vport_delete(struct fc_vport *fc_vport)
 	rc = bfa_fcs_vport_delete(&vport->fcs_vport);
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 
-	if (rc == BFA_STATUS_PBC)
+	if (rc == BFA_STATUS_PBC) {
+		vport->drv_port.flags &= ~BFAD_PORT_DELETE;
+		vport->comp_del = NULL;
 		return -1;
+	}
 
 	wait_for_completion(vport->comp_del);
 
diff --git a/drivers/scsi/bfa/bfad_drv.h b/drivers/scsi/bfa/bfad_drv.h
index 0d3bfba..11b0c1c 100644
--- a/drivers/scsi/bfa/bfad_drv.h
+++ b/drivers/scsi/bfa/bfad_drv.h
@@ -189,6 +189,7 @@ struct bfad_s {
 	char *fwtrc;
 	u32 reglen;
 	char *regdata;
+	atomic_t wq_reqcnt;
 };
 
 struct bfad_pcfg_s {
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index ffbec9b..678120b 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -554,7 +554,7 @@ bfad_im_scsi_host_alloc(struct bfad_s *bfad, struct bfad_im_port_s *im_port,
 		im_port->shost->transportt =
 				bfad_im_scsi_vport_transport_template;
 
-	error = scsi_add_host(im_port->shost, dev);
+	error = scsi_add_host_with_dma(im_port->shost, dev, &bfad->pcidev->dev);
 	if (error) {
 		printk(KERN_WARNING "scsi_add_host failure %d\n", error);
 		goto out_fc_rel;
@@ -598,10 +598,12 @@ bfad_im_port_delete_handler(struct work_struct *work)
 {
 	struct bfad_im_port_s *im_port =
 		container_of(work, struct bfad_im_port_s, port_delete_work);
+	struct bfad_s *bfad = im_port->bfad;
 
 	if (im_port->port->pvb_type != BFAD_PORT_PHYS_BASE) {
 		im_port->flags |= BFAD_PORT_DELETE;
 		fc_vport_terminate(im_port->fc_vport);
+		atomic_dec(&bfad->wq_reqcnt);
 	}
 
 }
@@ -634,8 +636,11 @@ bfad_im_port_delete(struct bfad_s *bfad, struct bfad_port_s *port)
 {
 	struct bfad_im_port_s *im_port = port->im_port;
 
-	queue_work(bfad->im->drv_workq,
+	if (im_port->port->pvb_type != BFAD_PORT_PHYS_BASE) {
+		atomic_inc(&bfad->wq_reqcnt);
+		queue_work(bfad->im->drv_workq,
 				&im_port->port_delete_work);
+	}
 }
 
 void
@@ -696,6 +701,12 @@ void
 bfad_im_probe_undo(struct bfad_s *bfad)
 {
 	if (bfad->im) {
+		while (atomic_read(&bfad->wq_reqcnt)) {
+			printk(KERN_INFO "bfa %s: waiting workq processing,"
+				" wq_reqcnt:%x\n", bfad->pci_name,
+				atomic_read(&bfad->wq_reqcnt));
+			schedule_timeout_uninterruptible(HZ);
+		}
 		bfad_os_destroy_workq(bfad->im);
 		kfree(bfad->im);
 		bfad->im = NULL;
-- 
1.6.5.2

