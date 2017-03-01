From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: mpt3sas sleep from atomic context on v4.10
Date: Wed, 1 Mar 2017 01:07:12 +0000
Message-ID: <1488330334.2370.23.camel@sandisk.com>
References: <20170301002533.GA12292@vader.DHCP.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:44957 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751492AbdCACxq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Feb 2017 21:53:46 -0500
In-Reply-To: <20170301002533.GA12292@vader.DHCP.thefacebook.com>
Content-Language: en-US
Content-ID: <1A7327DCC128A041BBDC83E593C06205@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "osandov@osandov.com" <osandov@osandov.com>
Cc: "chaitra.basappa@broadcom.com" <chaitra.basappa@broadcom.com>, "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>, "suganath-prabu.subramani@broadcom.com" <suganath-prabu.subramani@broadcom.com>, "Sreekanth.Reddy@broadcom.com" <Sreekanth.Reddy@broadcom.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "kernel-team@fb.com" <kernel-team@fb.com>

On Tue, 2017-02-28 at 16:25 -0800, Omar Sandoval wrote:
> I'm seeing this while testing on Linus' current master:
>=20
> [  427.814466] WARNING: CPU: 0 PID: 0 at kernel/irq/handle.c:149 __handle=
_irq_event_percpu+0x187/0x190
> [  427.832552] irq 116 handler _base_interrupt+0x0/0x9e0 [mpt3sas] enable=
d interrupts
>=20
> I tracked it down to commit 669f044170d8 ("scsi: srp_transport: Move
> queuecommand() wait code to SCSI core"). That commit made it so
> scsi_internal_device_block() can sleep, but mpt3sas calls this from an
> interrupt handler:
>=20
> _base_interrupt
> -> _base_async_event
>    -> mpt3sas_scsih_event_callback
>       -> _scsih_check_topo_delete_events
>          -> _scsih_block_io_to_children_attached_directly
> 	    -> _scsih_block_io_device
> 	       -> _scsih_internal_device_block
> 	          -> scsi_internal_device_block
>=20
> This change was made in 4.10. Bart, can you take a look?

How about the (entirely untested) patch below?

---
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  3 ---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |  4 ++--
 drivers/scsi/scsi_lib.c              | 32 ++++++++++++++++++--------------
 drivers/scsi/scsi_priv.h             |  3 ---
 include/scsi/scsi_device.h           |  4 ++++
 5 files changed, 24 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt=
3sas_base.h
index 4ab634fc27df..1aa7f97613ab 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1444,9 +1444,6 @@ void mpt3sas_transport_update_links(struct MPT3SAS_AD=
APTER *ioc,
 	u64 sas_address, u16 handle, u8 phy_number, u8 link_rate);
 extern struct sas_function_template mpt3sas_transport_functions;
 extern struct scsi_transport_template *mpt3sas_transport_template;
-extern int scsi_internal_device_block(struct scsi_device *sdev);
-extern int scsi_internal_device_unblock(struct scsi_device *sdev,
-				enum scsi_device_state new_state);
 /* trigger data externs */
 void mpt3sas_send_trigger_data_event(struct MPT3SAS_ADAPTER *ioc,
 	struct SL_WH_TRIGGERS_EVENT_DATA_T *event_data);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mp=
t3sas_scsih.c
index 46e866c36c8a..16d34a4bdc2e 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2859,7 +2859,7 @@ _scsih_internal_device_block(struct scsi_device *sdev=
,
 	    sas_device_priv_data->sas_target->handle);
 	sas_device_priv_data->block =3D 1;
=20
-	r =3D scsi_internal_device_block(sdev);
+	r =3D scsi_internal_device_block(sdev, false);
 	if (r =3D=3D -EINVAL)
 		sdev_printk(KERN_WARNING, sdev,
 		    "device_block failed with return(%d) for handle(0x%04x)\n",
@@ -2895,7 +2895,7 @@ _scsih_internal_device_unblock(struct scsi_device *sd=
ev,
 		    "performing a block followed by an unblock\n",
 		    r, sas_device_priv_data->sas_target->handle);
 		sas_device_priv_data->block =3D 1;
-		r =3D scsi_internal_device_block(sdev);
+		r =3D scsi_internal_device_block(sdev, false);
 		if (r)
 			sdev_printk(KERN_WARNING, sdev, "retried device_block "
 			    "failed with return(%d) for handle(0x%04x)\n",
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 3e32dc954c3c..77851697f130 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2945,6 +2945,8 @@ EXPORT_SYMBOL(scsi_target_resume);
 /**
  * scsi_internal_device_block - internal function to put a device temporar=
ily into the SDEV_BLOCK state
  * @sdev:	device to block
+ * @wait:       Whether or not to wait until ongoing .queuecommand() /
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
 	struct request_queue *q =3D sdev->request_queue;
 	unsigned long flags;
@@ -2976,18 +2978,20 @@ scsi_internal_device_block(struct scsi_device *sdev=
)
 			return err;
 	}
=20
-	/*=20
-	 * The device has transitioned to SDEV_BLOCK.  Stop the
-	 * block layer from calling the midlayer with this device's
-	 * request queue.=20
-	 */
-	if (q->mq_ops) {
-		blk_mq_quiesce_queue(q);
-	} else {
-		spin_lock_irqsave(q->queue_lock, flags);
-		blk_stop_queue(q);
-		spin_unlock_irqrestore(q->queue_lock, flags);
-		scsi_wait_for_queuecommand(sdev);
+	if (wait) {
+		/*
+		 * The device has transitioned to SDEV_BLOCK.  Stop the
+		 * block layer from calling the midlayer with this device's
+		 * request queue.
+		 */
+		if (q->mq_ops) {
+			blk_mq_quiesce_queue(q);
+		} else {
+			spin_lock_irqsave(q->queue_lock, flags);
+			blk_stop_queue(q);
+			spin_unlock_irqrestore(q->queue_lock, flags);
+			scsi_wait_for_queuecommand(sdev);
+		}
 	}
=20
 	return 0;
@@ -3049,7 +3053,7 @@ EXPORT_SYMBOL_GPL(scsi_internal_device_unblock);
 static void
 device_block(struct scsi_device *sdev, void *data)
 {
-	scsi_internal_device_block(sdev);
+	scsi_internal_device_block(sdev, true);
 }
=20
 static int
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 99bfc985e190..f11bd102d6d5 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -188,8 +188,5 @@ static inline void scsi_dh_remove_device(struct scsi_de=
vice *sdev) { }
  */
=20
 #define SCSI_DEVICE_BLOCK_MAX_TIMEOUT	600	/* units in seconds */
-extern int scsi_internal_device_block(struct scsi_device *sdev);
-extern int scsi_internal_device_unblock(struct scsi_device *sdev,
-					enum scsi_device_state new_state);
=20
 #endif /* _SCSI_PRIV_H */
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 8990e580b278..b5018df7ad54 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -474,6 +474,10 @@ static inline int scsi_device_created(struct scsi_devi=
ce *sdev)
 		sdev->sdev_state =3D=3D SDEV_CREATED_BLOCK;
 }
=20
+int scsi_internal_device_block(struct scsi_device *sdev, bool wait);
+int scsi_internal_device_unblock(struct scsi_device *sdev,
+				 enum scsi_device_state new_state);
+
 /* accessor functions for the SCSI parameters */
 static inline int scsi_device_sync(struct scsi_device *sdev)
 {
--=20
2.12.0
