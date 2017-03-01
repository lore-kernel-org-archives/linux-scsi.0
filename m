From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH] mpt3sas: Avoid sleeping in interrupt context
Date: Wed, 1 Mar 2017 09:00:36 -0800
Message-ID: <20170301170036.11540-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Omar Sandoval <osandov@osandov.com>, Hannes Reinecke <hare@suse.com>, Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>, "# v4 . 10+" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Commit 669f044170d8 ("scsi: srp_transport: Move queuecommand() wait
code to SCSI core") can make scsi_internal_device_block() sleep.
However, the mpt3sas driver can call this function from an interrupt
handler. Hence add a second argument to scsi_internal_device_block()
that restores the old behavior of this function for the mpt3sas
handler.

The call chain that triggered an "IRQ handler enabled interrupts"
complaint is as follows:

_base_interrupt()
-> _base_async_event()
   -> mpt3sas_scsih_event_callback()
      -> _scsih_check_topo_delete_events()
         -> _scsih_block_io_to_children_attached_directly()
            -> _scsih_block_io_device()
               -> _scsih_internal_device_block()
                  -> scsi_internal_device_block()

Reported-by: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Omar Sandoval <osandov@osandov.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Chaitra P B <chaitra.basappa@broadcom.com>
Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>
Cc: <stable@vger.kernel.org> # v4.10+
---
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  3 ---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |  4 ++--
 drivers/scsi/scsi_lib.c              | 14 ++++++++++----
 drivers/scsi/scsi_priv.h             |  3 ---
 include/scsi/scsi_device.h           |  4 ++++
 5 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 4ab634fc27df..1aa7f97613ab 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1444,9 +1444,6 @@ void mpt3sas_transport_update_links(struct MPT3SAS_ADAPTER *ioc,
 	u64 sas_address, u16 handle, u8 phy_number, u8 link_rate);
 extern struct sas_function_template mpt3sas_transport_functions;
 extern struct scsi_transport_template *mpt3sas_transport_template;
-extern int scsi_internal_device_block(struct scsi_device *sdev);
-extern int scsi_internal_device_unblock(struct scsi_device *sdev,
-				enum scsi_device_state new_state);
 /* trigger data externs */
 void mpt3sas_send_trigger_data_event(struct MPT3SAS_ADAPTER *ioc,
 	struct SL_WH_TRIGGERS_EVENT_DATA_T *event_data);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 46e866c36c8a..16d34a4bdc2e 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2859,7 +2859,7 @@ _scsih_internal_device_block(struct scsi_device *sdev,
 	    sas_device_priv_data->sas_target->handle);
 	sas_device_priv_data->block = 1;
 
-	r = scsi_internal_device_block(sdev);
+	r = scsi_internal_device_block(sdev, false);
 	if (r == -EINVAL)
 		sdev_printk(KERN_WARNING, sdev,
 		    "device_block failed with return(%d) for handle(0x%04x)\n",
@@ -2895,7 +2895,7 @@ _scsih_internal_device_unblock(struct scsi_device *sdev,
 		    "performing a block followed by an unblock\n",
 		    r, sas_device_priv_data->sas_target->handle);
 		sas_device_priv_data->block = 1;
-		r = scsi_internal_device_block(sdev);
+		r = scsi_internal_device_block(sdev, false);
 		if (r)
 			sdev_printk(KERN_WARNING, sdev, "retried device_block "
 			    "failed with return(%d) for handle(0x%04x)\n",
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 3e32dc954c3c..f20313b20029 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2945,6 +2945,8 @@ EXPORT_SYMBOL(scsi_target_resume);
 /**
  * scsi_internal_device_block - internal function to put a device temporarily into the SDEV_BLOCK state
  * @sdev:	device to block
+ * @wait:	Whether or not to wait until ongoing .queuecommand() /
+ *		.queue_rq() calls have finished.
  *
  * Block request made by scsi lld's to temporarily stop all
  * scsi commands on the specified device. May sleep.
@@ -2962,7 +2964,7 @@ EXPORT_SYMBOL(scsi_target_resume);
  * remove the rport mutex lock and unlock calls from srp_queuecommand().
  */
 int
-scsi_internal_device_block(struct scsi_device *sdev)
+scsi_internal_device_block(struct scsi_device *sdev, bool wait)
 {
 	struct request_queue *q = sdev->request_queue;
 	unsigned long flags;
@@ -2982,12 +2984,16 @@ scsi_internal_device_block(struct scsi_device *sdev)
 	 * request queue. 
 	 */
 	if (q->mq_ops) {
-		blk_mq_quiesce_queue(q);
+		if (wait)
+			blk_mq_quiesce_queue(q);
+		else
+			blk_mq_stop_hw_queues(q);
 	} else {
 		spin_lock_irqsave(q->queue_lock, flags);
 		blk_stop_queue(q);
 		spin_unlock_irqrestore(q->queue_lock, flags);
-		scsi_wait_for_queuecommand(sdev);
+		if (wait)
+			scsi_wait_for_queuecommand(sdev);
 	}
 
 	return 0;
@@ -3049,7 +3055,7 @@ EXPORT_SYMBOL_GPL(scsi_internal_device_unblock);
 static void
 device_block(struct scsi_device *sdev, void *data)
 {
-	scsi_internal_device_block(sdev);
+	scsi_internal_device_block(sdev, true);
 }
 
 static int
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 99bfc985e190..f11bd102d6d5 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -188,8 +188,5 @@ static inline void scsi_dh_remove_device(struct scsi_device *sdev) { }
  */
 
 #define SCSI_DEVICE_BLOCK_MAX_TIMEOUT	600	/* units in seconds */
-extern int scsi_internal_device_block(struct scsi_device *sdev);
-extern int scsi_internal_device_unblock(struct scsi_device *sdev,
-					enum scsi_device_state new_state);
 
 #endif /* _SCSI_PRIV_H */
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 8990e580b278..b5018df7ad54 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -474,6 +474,10 @@ static inline int scsi_device_created(struct scsi_device *sdev)
 		sdev->sdev_state == SDEV_CREATED_BLOCK;
 }
 
+int scsi_internal_device_block(struct scsi_device *sdev, bool wait);
+int scsi_internal_device_unblock(struct scsi_device *sdev,
+				 enum scsi_device_state new_state);
+
 /* accessor functions for the SCSI parameters */
 static inline int scsi_device_sync(struct scsi_device *sdev)
 {
-- 
2.12.0
