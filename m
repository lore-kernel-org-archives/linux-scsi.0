From: Jason Baron <jbaron@akamai.com>
Subject: [PATCH] scsi: mpt3sas: fix hang on ata passthru commands
Date: Wed, 28 Dec 2016 23:30:24 -0500
Message-ID: <1482985824-7270-1-git-send-email-jbaron@akamai.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Sagi Grimberg <sagi@grimberg.me>, James Bottomley <jejb@linux.vnet.ibm.com>, Christoph Hellwig <hch@lst.de>, Doug Ledford <dledford@redhat.com>, David Miller <davem@davemloft.net>
List-Id: linux-scsi@vger.kernel.org

On ata passthru commands scsih_qcmd() ends up spinning in
scsi_wait_for_queuecommand() indefinitely. scsih_qcmd() is called from
__blk_run_queue_uncond() which first increments request_fn_active to a
non-zero value. Thus, scsi_wait_for_queuecommand() never completes because
its spinning waiting for request_fn_active to become 0.

Two patches interact here. The first:

commit 18f6084a989b ("scsi: mpt3sas: Fix secure erase premature
termination") calls scsi_internal_device_block() for ata passthru commands.

The second patch:

commit 669f044170d8 ("scsi: srp_transport: Move queuecommand() wait code
to SCSI core") adds a call to scsi_wait_for_queuecommand() from
scsi_internal_device_block().

Add a new parameter to scsi_internal_device_block() to decide whether
or not to invoke scsi_wait_for_queuecommand().

Signed-off-by: Jason Baron <jbaron@akamai.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Chaitra P B <chaitra.basappa@broadcom.com>
Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Doug Ledford <dledford@redhat.com>
Cc: David Miller <davem@davemloft.net>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |  6 +++---
 drivers/scsi/scsi_lib.c              | 11 +++++++----
 drivers/scsi/scsi_priv.h             |  2 +-
 4 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 394fe13..5da3427 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1431,7 +1431,7 @@ void mpt3sas_transport_update_links(struct MPT3SAS_ADAPTER *ioc,
 	u64 sas_address, u16 handle, u8 phy_number, u8 link_rate);
 extern struct sas_function_template mpt3sas_transport_functions;
 extern struct scsi_transport_template *mpt3sas_transport_template;
-extern int scsi_internal_device_block(struct scsi_device *sdev);
+extern int scsi_internal_device_block(struct scsi_device *sdev, bool flush);
 extern int scsi_internal_device_unblock(struct scsi_device *sdev,
 				enum scsi_device_state new_state);
 /* trigger data externs */
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index b5c966e..509ef8a 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2839,7 +2839,7 @@ _scsih_internal_device_block(struct scsi_device *sdev,
 	    sas_device_priv_data->sas_target->handle);
 	sas_device_priv_data->block = 1;
 
-	r = scsi_internal_device_block(sdev);
+	r = scsi_internal_device_block(sdev, true);
 	if (r == -EINVAL)
 		sdev_printk(KERN_WARNING, sdev,
 		    "device_block failed with return(%d) for handle(0x%04x)\n",
@@ -2875,7 +2875,7 @@ _scsih_internal_device_unblock(struct scsi_device *sdev,
 		    "performing a block followed by an unblock\n",
 		    r, sas_device_priv_data->sas_target->handle);
 		sas_device_priv_data->block = 1;
-		r = scsi_internal_device_block(sdev);
+		r = scsi_internal_device_block(sdev, true);
 		if (r)
 			sdev_printk(KERN_WARNING, sdev, "retried device_block "
 			    "failed with return(%d) for handle(0x%04x)\n",
@@ -4068,7 +4068,7 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 	 * done.
 	 */
 	if (ata_12_16_cmd(scmd))
-		scsi_internal_device_block(scmd->device);
+		scsi_internal_device_block(scmd->device, false);
 
 	sas_device_priv_data = scmd->device->hostdata;
 	if (!sas_device_priv_data || !sas_device_priv_data->sas_target) {
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c35b6de..2ee2db9 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2856,9 +2856,11 @@ EXPORT_SYMBOL(scsi_target_resume);
 /**
  * scsi_internal_device_block - internal function to put a device temporarily into the SDEV_BLOCK state
  * @sdev:	device to block
+ * @flush:	wait for oustanding queuecommand calls to finish
  *
  * Block request made by scsi lld's to temporarily stop all
- * scsi commands on the specified device. May sleep.
+ * scsi commands on the specified device. May sleep if
+ * flush is set
  *
  * Returns zero if successful or error if not
  *
@@ -2873,7 +2875,7 @@ EXPORT_SYMBOL(scsi_target_resume);
  * remove the rport mutex lock and unlock calls from srp_queuecommand().
  */
 int
-scsi_internal_device_block(struct scsi_device *sdev)
+scsi_internal_device_block(struct scsi_device *sdev, bool flush)
 {
 	struct request_queue *q = sdev->request_queue;
 	unsigned long flags;
@@ -2898,7 +2900,8 @@ scsi_internal_device_block(struct scsi_device *sdev)
 		spin_lock_irqsave(q->queue_lock, flags);
 		blk_stop_queue(q);
 		spin_unlock_irqrestore(q->queue_lock, flags);
-		scsi_wait_for_queuecommand(sdev);
+		if (flush)
+			scsi_wait_for_queuecommand(sdev);
 	}
 
 	return 0;
@@ -2960,7 +2963,7 @@ EXPORT_SYMBOL_GPL(scsi_internal_device_unblock);
 static void
 device_block(struct scsi_device *sdev, void *data)
 {
-	scsi_internal_device_block(sdev);
+	scsi_internal_device_block(sdev, true);
 }
 
 static int
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 193636a..c0f79b8 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -189,7 +189,7 @@ static inline void scsi_dh_remove_device(struct scsi_device *sdev) { }
  */
 
 #define SCSI_DEVICE_BLOCK_MAX_TIMEOUT	600	/* units in seconds */
-extern int scsi_internal_device_block(struct scsi_device *sdev);
+extern int scsi_internal_device_block(struct scsi_device *sdev, bool flush);
 extern int scsi_internal_device_unblock(struct scsi_device *sdev,
 					enum scsi_device_state new_state);
 
-- 
2.6.1
