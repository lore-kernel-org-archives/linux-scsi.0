From: Adrian Bunk <bunk@fs.tum.de>
Subject: [2.6 patch] SCSI dc395x.c: fix inline compile errors
Date: Fri, 16 Jul 2004 00:26:53 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040715222653.GO25633@fs.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hermes.fachschaften.tu-muenchen.de ([129.187.202.12]:27609 "HELO
	hermes.fachschaften.tu-muenchen.de") by vger.kernel.org with SMTP
	id S266247AbUGOW1B (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jul 2004 18:27:01 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>, Oliver Neukum <oliver@neukum.name>, Ali Akcaagac <aliakc@web.de>, Jamie Lenehan <lenehan@twibble.org>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

Trying to compile drivers/scsi/dc395x.c in 2.6.8-rc1-mm1 using gcc 3.4 
results in compile errors starting with the following:

<--  snip  -->

...
  CC      drivers/scsi/dc395x.o
drivers/scsi/dc395x.c: In function `dc395x_handle_interrupt':
drivers/scsi/dc395x.c:388: sorry, unimplemented: inlining failed in call 
to 'enable_msgout_abort': function body not available
drivers/scsi/dc395x.c:1740: sorry, unimplemented: called from here
make[2]: *** [drivers/scsi/dc395x.o] Error 1

<--  snip  -->


The patch below moves enable_msgout_abort above the place where it is 
called the first time and removes the bogus inline from the prototype of 
set_xfer_rate (the function itself isn't marked as inline).

An alternative approach would be to remove the inline from 
enable_msgout_abort.


diffstat output:
 drivers/scsi/dc395x.c |   40 ++++++++++++++++++++--------------------
 1 files changed, 20 insertions(+), 20 deletions(-)


Signed-off-by: Adrian Bunk <bunk@fs.tum.de>

--- linux-2.6.8-rc1-mm1-full-3.4/drivers/scsi/dc395x.c.old	2004-07-16 00:19:23.000000000 +0200
+++ linux-2.6.8-rc1-mm1-full-3.4/drivers/scsi/dc395x.c	2004-07-16 00:21:32.000000000 +0200
@@ -376,6 +376,8 @@
 static void reselect(struct AdapterCtlBlk *acb);
 static u8 start_scsi(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 		struct ScsiReqBlk *srb);
+static inline void enable_msgout_abort(struct AdapterCtlBlk *acb,
+		struct ScsiReqBlk *srb);
 static void build_srb(struct scsi_cmnd *cmd, struct DeviceCtlBlk *dcb,
 		struct ScsiReqBlk *srb);
 static void doing_srb_done(struct AdapterCtlBlk *acb, u8 did_code,
@@ -384,13 +386,11 @@
 static void pci_unmap_srb(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb);
 static void pci_unmap_srb_sense(struct AdapterCtlBlk *acb,
 		struct ScsiReqBlk *srb);
-static inline void enable_msgout_abort(struct AdapterCtlBlk *acb,
-		struct ScsiReqBlk *srb);
 static void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 		struct ScsiReqBlk *srb);
 static void request_sense(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 		struct ScsiReqBlk *srb);
-static inline void set_xfer_rate(struct AdapterCtlBlk *acb,
+static void set_xfer_rate(struct AdapterCtlBlk *acb,
 		struct DeviceCtlBlk *dcb);
 static void waiting_timeout(unsigned long ptr);
 
@@ -1676,6 +1676,23 @@
 }
 
 
+#define DC395x_ENABLE_MSGOUT \
+ DC395x_write16 (acb, TRM_S1040_SCSI_CONTROL, DO_SETATN); \
+ srb->state |= SRB_MSGOUT
+
+
+/* abort command */
+static inline void enable_msgout_abort(struct AdapterCtlBlk *acb,
+		struct ScsiReqBlk *srb)
+{
+	srb->msgout_buf[0] = ABORT;
+	srb->msg_count = 1;
+	DC395x_ENABLE_MSGOUT;
+	srb->state &= ~SRB_MSGIN;
+	srb->state |= SRB_MSGOUT;
+}
+
+
 /**
  * dc395x_handle_interrupt - Handle an interrupt that has been confirmed to
  *                           have been triggered for this card.
@@ -2583,11 +2600,6 @@
 	return 1;
 }
 
-#define DC395x_ENABLE_MSGOUT \
- DC395x_write16 (acb, TRM_S1040_SCSI_CONTROL, DO_SETATN); \
- srb->state |= SRB_MSGOUT
-
-
 /* reject_msg */
 static inline void msgin_reject(struct AdapterCtlBlk *acb,
 		struct ScsiReqBlk *srb)
@@ -2603,18 +2615,6 @@
 }
 
 
-/* abort command */
-static inline void enable_msgout_abort(struct AdapterCtlBlk *acb,
-		struct ScsiReqBlk *srb)
-{
-	srb->msgout_buf[0] = ABORT;
-	srb->msg_count = 1;
-	DC395x_ENABLE_MSGOUT;
-	srb->state &= ~SRB_MSGIN;
-	srb->state |= SRB_MSGOUT;
-}
-
-
 static struct ScsiReqBlk *msgin_qtag(struct AdapterCtlBlk *acb,
 		struct DeviceCtlBlk *dcb, u8 tag)
 {

