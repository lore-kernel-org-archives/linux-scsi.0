From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.14-rc5
Date: Tue, 17 Oct 2017 08:22:10 -0700
Message-ID: <1508253730.3129.19.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51348 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933923AbdJQPWL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Oct 2017 11:22:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

Four mostly error leg fixes and one more important regression in a
prior commit (the qla2xxx one).

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Hannes Reinecke (1):
      scsi: fixup kernel warning during rmmod()

Johannes Thumshirn (2):
      scsi: fc: check for rport presence in fc_block_scsi_eh
      scsi: libiscsi: fix shifting of DID_REQUEUE host byte

Quinn Tran (1):
      scsi: qla2xxx: Fix uninitialized work element

Satish Kharat (1):
      scsi: libfc: fix a deadlock in fc_rport_work

And the diffstat:

 drivers/scsi/libfc/fc_rport.c    |  2 +-
 drivers/scsi/libiscsi.c          |  2 +-
 drivers/scsi/qla2xxx/qla_os.c    |  3 ++-
 drivers/scsi/scsi_sysfs.c        | 10 ++++++++--
 drivers/scsi/scsi_transport_fc.c |  3 +++
 5 files changed, 15 insertions(+), 5 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 520325867e2b..31d31aad3de1 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -383,11 +383,11 @@ static void fc_rport_work(struct work_struct *work)
 				fc_rport_enter_flogi(rdata);
 				mutex_unlock(&rdata->rp_mutex);
 			} else {
+				mutex_unlock(&rdata->rp_mutex);
 				FC_RPORT_DBG(rdata, "work delete\n");
 				mutex_lock(&lport->disc.disc_mutex);
 				list_del_rcu(&rdata->peers);
 				mutex_unlock(&lport->disc.disc_mutex);
-				mutex_unlock(&rdata->rp_mutex);
 				kref_put(&rdata->kref, fc_rport_destroy);
 			}
 		} else {
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index c62e8d111fd9..f8dc1601efd5 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1728,7 +1728,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 
 	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx)) {
 		reason = FAILURE_SESSION_IN_RECOVERY;
-		sc->result = DID_REQUEUE;
+		sc->result = DID_REQUEUE << 16;
 		goto fault;
 	}
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 5b2437a5ea44..937209805baf 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3175,6 +3175,8 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	    host->can_queue, base_vha->req,
 	    base_vha->mgmt_svr_loop_id, host->sg_tablesize);
 
+	INIT_WORK(&base_vha->iocb_work, qla2x00_iocb_work_fn);
+
 	if (ha->mqenable) {
 		bool mq = false;
 		bool startit = false;
@@ -3223,7 +3225,6 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	 */
 	qla2xxx_wake_dpc(base_vha);
 
-	INIT_WORK(&base_vha->iocb_work, qla2x00_iocb_work_fn);
 	INIT_WORK(&ha->board_disable, qla2x00_disable_board_on_pci_error);
 
 	if (IS_QLA8031(ha) || IS_MCTP_CAPABLE(ha)) {
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index bf53356f41f0..f796bd61f3f0 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1376,13 +1376,19 @@ static void __scsi_remove_target(struct scsi_target *starget)
 	spin_lock_irqsave(shost->host_lock, flags);
  restart:
 	list_for_each_entry(sdev, &shost->__devices, siblings) {
+		/*
+		 * We cannot call scsi_device_get() here, as
+		 * we might've been called from rmmod() causing
+		 * scsi_device_get() to fail the module_is_live()
+		 * check.
+		 */
 		if (sdev->channel != starget->channel ||
 		    sdev->id != starget->id ||
-		    scsi_device_get(sdev))
+		    !get_device(&sdev->sdev_gendev))
 			continue;
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		scsi_remove_device(sdev);
-		scsi_device_put(sdev);
+		put_device(&sdev->sdev_gendev);
 		spin_lock_irqsave(shost->host_lock, flags);
 		goto restart;
 	}
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index cbd4495d0ff9..8c46a6d536af 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3320,6 +3320,9 @@ int fc_block_scsi_eh(struct scsi_cmnd *cmnd)
 {
 	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
 
+	if (WARN_ON_ONCE(!rport))
+		return FAST_IO_FAIL;
+
 	return fc_block_rport(rport);
 }
 EXPORT_SYMBOL(fc_block_scsi_eh);
