From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 4/5] bfa: protect idr using bfad_mutex
Date: Fri, 19 Mar 2010 11:07:09 -0700
Message-ID: <1269022029-12658-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:55209 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751013Ab0CSS1T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Mar 2010 14:27:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, huangj@brocade.com

idr is a global resource, protect it with global bfad_mutex. 

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/bfad.c     |    2 +-
 drivers/scsi/bfa/bfad_drv.h |    1 +
 drivers/scsi/bfa/bfad_im.c  |   13 +++++++++----
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index 23b28d3..8f4a00f 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -32,7 +32,7 @@
 #include <fcb/bfa_fcb.h>
 
 BFA_TRC_FILE(LDRV, BFAD);
-static DEFINE_MUTEX(bfad_mutex);
+DEFINE_MUTEX(bfad_mutex);
 LIST_HEAD(bfad_list);
 static int      bfad_inst;
 int bfad_supported_fc4s;
diff --git a/drivers/scsi/bfa/bfad_drv.h b/drivers/scsi/bfa/bfad_drv.h
index 0639aed..6c920c1 100644
--- a/drivers/scsi/bfa/bfad_drv.h
+++ b/drivers/scsi/bfa/bfad_drv.h
@@ -293,5 +293,6 @@ extern struct list_head bfad_list;
 extern int bfa_lun_queue_depth;
 extern int bfad_supported_fc4s;
 extern int bfa_linkup_delay;
+extern struct mutex bfad_mutex;
 
 #endif /* __BFAD_DRV_H__ */
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index a4676a7..8be7c6e 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -518,7 +518,9 @@ bfad_im_scsi_host_alloc(struct bfad_s *bfad, struct bfad_im_port_s *im_port,
 {
 	int error = 1;
 
+	mutex_lock(&bfad_mutex);
 	if (!idr_pre_get(&bfad_im_port_index, GFP_KERNEL)) {
+		mutex_unlock(&bfad_mutex);
 		printk(KERN_WARNING "idr_pre_get failure\n");
 		goto out;
 	}
@@ -526,10 +528,13 @@ bfad_im_scsi_host_alloc(struct bfad_s *bfad, struct bfad_im_port_s *im_port,
 	error = idr_get_new(&bfad_im_port_index, im_port,
 					 &im_port->idr_id);
 	if (error) {
+		mutex_unlock(&bfad_mutex);
 		printk(KERN_WARNING "idr_get_new failure\n");
 		goto out;
 	}
 
+	mutex_unlock(&bfad_mutex);
+
 	im_port->shost = bfad_os_scsi_host_alloc(im_port, bfad);
 	if (!im_port->shost) {
 		error = 1;
@@ -563,7 +568,9 @@ bfad_im_scsi_host_alloc(struct bfad_s *bfad, struct bfad_im_port_s *im_port,
 out_fc_rel:
 	scsi_host_put(im_port->shost);
 out_free_idr:
+	mutex_lock(&bfad_mutex);
 	idr_remove(&bfad_im_port_index, im_port->idr_id);
+	mutex_unlock(&bfad_mutex);
 out:
 	return error;
 }
@@ -571,8 +578,6 @@ out:
 void
 bfad_im_scsi_host_free(struct bfad_s *bfad, struct bfad_im_port_s *im_port)
 {
-	unsigned long flags;
-
 	bfa_trc(bfad, bfad->inst_no);
 	bfa_log(bfad->logmod, BFA_LOG_LINUX_SCSI_HOST_FREE,
 			im_port->shost->host_no);
@@ -582,9 +587,9 @@ bfad_im_scsi_host_free(struct bfad_s *bfad, struct bfad_im_port_s *im_port)
 	scsi_remove_host(im_port->shost);
 	scsi_host_put(im_port->shost);
 
-	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	mutex_lock(&bfad_mutex);
 	idr_remove(&bfad_im_port_index, im_port->idr_id);
-	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+	mutex_unlock(&bfad_mutex);
 }
 
 static void
-- 
1.6.5.2

