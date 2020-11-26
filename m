Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44991C64E8A
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 13:30:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E089D21D46
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 13:30:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="sKTVyUux";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="We4izJOV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390051AbgKZNao (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Nov 2020 08:30:44 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:56528 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390110AbgKZNak (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Nov 2020 08:30:40 -0500
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1606397437;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qhnOM2CfVrqA4TBQ/HVK0oo98cbGQV8B2TbYW0wYyKY=;
        b=sKTVyUuxJqo9C6TV+M5wBxZvkuYFYG1jylAbLlzp5Wz+kya/Y+/K5K+iAt159OPEr4lKhp
        HazbO/U/d1ageW0OCvknpDEK2NekB+NGTlk0IMDDvym0ChJZVYtGlpFDSmFt4Y74xdRCmV
        WqRAy2/OpcZCgf7bZndAuPlGgyXkFWP27RsyD43+4/9m1zec3YnIsTfR7zflbfUEUmEO4F
        ICDoZ4yuafSk9gfqiSFlBmS/B5Vd/9hRDNYJv4LP2hWSWgjZE0apVFlTB5eK2zf1JkRame
        F0SyXuNfro3A3FEBu6VRm5wQDIHb1qY+6/D49F4aFKzQ9PnF7r4Jkvp8IEieMw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1606397437;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qhnOM2CfVrqA4TBQ/HVK0oo98cbGQV8B2TbYW0wYyKY=;
        b=We4izJOVUxZIi+9qI5ysH2VhQgVxXOYw0FZErkA9n3zqmzRsgQ7NREI3/DCT0UqWZUNl60
        VIMs3YrVKVI4WAAA==
To:     linux-scsi@vger.kernel.org
Cc:     Finn Thain <fthain@telegraphics.com.au>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Hannes Reinecke <hare@kernel.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        John Garry <john.garry@huawei.com>,
        linux-m68k@lists.linux-m68k.org,
        Manish Rangankar <mrangankar@marvell.com>,
        Michael Schmitz <schmitzmic@gmail.com>,
        MPT-FusionLinux.pdl@broadcom.com,
        Nilesh Javali <njavali@marvell.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Vikram Auradkar <auradkar@google.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Xiaofei Tan <tanxiaofei@huawei.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ahmed S . Darwish" <a.darwish@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 12/14] scsi: NCR5380: Remove in_interrupt().
Date:   Thu, 26 Nov 2020 14:29:50 +0100
Message-Id: <20201126132952.2287996-13-bigeasy@linutronix.de>
In-Reply-To: <20201126132952.2287996-1-bigeasy@linutronix.de>
References: <20201126132952.2287996-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: "Ahmed S. Darwish" <a.darwish@linutronix.de>

NCR5380_poll_politely2() uses in_interrupt() to check if it is safe to
sleep.

The usage of in_interrupt() in drivers is phased out and Linus clearly
requested that code which changes behaviour depending on context should
either be separated, or the context be explicitly conveyed in an
argument passed by the caller.

Below is a context analysis of NCR5380_poll_politely2() uppermost
callers:

  - NCR5380_maybe_reset_bus(), task, invoked during device probe.
    -> NCR5380_poll_politely()
    -> do_abort()

  - NCR5380_select(), task, but can only sleep in the "release, then
    re-acquire" regions of the spinlock held by its caller.
    Sleeping invocations (lock released):
    -> NCR5380_poll_politely2()

    Atomic invocations (lock acquired):
    -> NCR5380_reselect()
       -> NCR5380_poll_politely()
       -> do_abort()
       -> NCR5380_transfer_pio()

  - NCR5380_intr(), interrupt handler
    -> NCR5380_dma_complete()
       -> NCR5380_transfer_pio()
	  -> NCR5380_poll_politely()
    -> NCR5380_reselect() (see above)

  - NCR5380_information_transfer(), task, but can only sleep in the
    "release, then re-acquire" regions of the caller-held spinlock.
    Sleeping invocations (lock released):
      - NCR5380_transfer_pio() -> NCR5380_poll_politely()
      - NCR5380_poll_politely()

    Atomic invocations (lock acquired):
      - NCR5380_transfer_dma()
	-> NCR5380_dma_recv_setup()
           =3D> generic_NCR5380_precv() -> NCR5380_poll_politely()
	   =3D> macscsi_pread() -> NCR5380_poll_politely()

	-> NCR5380_dma_send_setup()
 	   =3D> generic_NCR5380_psend -> NCR5380_poll_politely2()
	   =3D> macscsi_pwrite() -> NCR5380_poll_politely()

	-> NCR5380_poll_politely2()
        -> NCR5380_dma_complete()
           -> NCR5380_transfer_pio()
	      -> NCR5380_poll_politely()
      - NCR5380_transfer_pio() -> NCR5380_poll_politely

  - NCR5380_reselect(), atomic, always called with hostdata spinlock
    held.

If direct callers are purely atomic, or purely task context, change
their specifications accordingly and mark them with "Context: " tags.

For the mixed ones, trickle-down context from upper layers.

Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Finn Thain <fthain@telegraphics.com.au>
Cc: Michael Schmitz <schmitzmic@gmail.com>
Cc: <linux-m68k@lists.linux-m68k.org>
---
 drivers/scsi/NCR5380.c   | 115 ++++++++++++++++++++++-----------------
 drivers/scsi/NCR5380.h   |   9 +--
 drivers/scsi/g_NCR5380.c |  26 ++++++---
 drivers/scsi/mac_scsi.c  |  10 ++--
 4 files changed, 93 insertions(+), 67 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index d597d7493a627..51a80f3330faa 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -132,7 +132,7 @@
 static unsigned int disconnect_mask =3D ~0;
 module_param(disconnect_mask, int, 0444);
=20
-static int do_abort(struct Scsi_Host *);
+static int do_abort(struct Scsi_Host *, bool);
 static void do_reset(struct Scsi_Host *);
 static void bus_reset_cleanup(struct Scsi_Host *);
=20
@@ -198,6 +198,7 @@ static inline void set_resid_from_SCp(struct scsi_cmnd =
*cmd)
  * @bit2: Second bitmask to check
  * @val2: Second expected value
  * @wait: Time-out in jiffies
+ * @can_sleep: True if the function can sleep
  *
  * Polls the chip in a reasonably efficient manner waiting for an
  * event to occur. After a short quick poll we begin to yield the CPU
@@ -210,7 +211,7 @@ static inline void set_resid_from_SCp(struct scsi_cmnd =
*cmd)
 static int NCR5380_poll_politely2(struct NCR5380_hostdata *hostdata,
                                   unsigned int reg1, u8 bit1, u8 val1,
                                   unsigned int reg2, u8 bit2, u8 val2,
-                                  unsigned long wait)
+                                  unsigned long wait, bool can_sleep)
 {
 	unsigned long n =3D hostdata->poll_loops;
 	unsigned long deadline =3D jiffies + wait;
@@ -223,7 +224,7 @@ static int NCR5380_poll_politely2(struct NCR5380_hostda=
ta *hostdata,
 		cpu_relax();
 	} while (n--);
=20
-	if (irqs_disabled() || in_interrupt())
+	if (!can_sleep)
 		return -ETIMEDOUT;
=20
 	/* Repeatedly sleep for 1 ms until deadline */
@@ -467,9 +468,10 @@ static int NCR5380_init(struct Scsi_Host *instance, in=
t flags)
  *
  * Note that a bus reset will cause the chip to assert IRQ.
  *
+ * Context: task, can sleep
+ *
  * Returns 0 if successful, otherwise -ENXIO.
  */
-
 static int NCR5380_maybe_reset_bus(struct Scsi_Host *instance)
 {
 	struct NCR5380_hostdata *hostdata =3D shost_priv(instance);
@@ -482,11 +484,11 @@ static int NCR5380_maybe_reset_bus(struct Scsi_Host *=
instance)
 		case 5:
 			shost_printk(KERN_ERR, instance, "SCSI bus busy, waiting up to five sec=
onds\n");
 			NCR5380_poll_politely(hostdata,
-			                      STATUS_REG, SR_BSY, 0, 5 * HZ);
+			                      STATUS_REG, SR_BSY, 0, 5 * HZ, true);
 			break;
 		case 2:
 			shost_printk(KERN_ERR, instance, "bus busy, attempting abort\n");
-			do_abort(instance);
+			do_abort(instance, true);
 			break;
 		case 4:
 			shost_printk(KERN_ERR, instance, "bus busy, attempting reset\n");
@@ -690,7 +692,6 @@ static void requeue_cmd(struct Scsi_Host *instance, str=
uct scsi_cmnd *cmd)
  * NCR5380_queue_command() and NCR5380_intr() will try to start it
  * in case it is not running.
  */
-
 static void NCR5380_main(struct work_struct *work)
 {
 	struct NCR5380_hostdata *hostdata =3D
@@ -750,10 +751,9 @@ static void NCR5380_main(struct work_struct *work)
  * NCR5380_dma_complete - finish DMA transfer
  * @instance: the scsi host instance
  *
- * Called by the interrupt handler when DMA finishes or a phase
- * mismatch occurs (which would end the DMA transfer).
+ * Context: atomic. Called by the interrupt handler when DMA finishes
+ * or a phase mismatch occurs (which would end the DMA transfer).
  */
-
 static void NCR5380_dma_complete(struct Scsi_Host *instance)
 {
 	struct NCR5380_hostdata *hostdata =3D shost_priv(instance);
@@ -822,7 +822,7 @@ static void NCR5380_dma_complete(struct Scsi_Host *inst=
ance)
 			if (toPIO > 0) {
 				dsprintk(NDEBUG_DMA, instance,
 				         "Doing %d byte PIO to 0x%p\n", cnt, *data);
-				NCR5380_transfer_pio(instance, &p, &cnt, data);
+				NCR5380_transfer_pio(instance, &p, &cnt, data, false);
 				*count -=3D toPIO - cnt;
 			}
 		}
@@ -962,8 +962,11 @@ static irqreturn_t __maybe_unused NCR5380_intr(int irq=
, void *dev_id)
  *
  * If failed (no target) : cmd->scsi_done() will be called, and the
  * cmd->result host byte set to DID_BAD_TARGET.
+ *
+ * Context: task context, with @instance hostdata spinlock held by
+ * caller.  That is, this function can sleep in the areas between
+ * releasing and re-acquring that spinlock.
  */
-
 static bool NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *c=
md)
 	__releases(&hostdata->lock) __acquires(&hostdata->lock)
 {
@@ -1010,8 +1013,10 @@ static bool NCR5380_select(struct Scsi_Host *instanc=
e, struct scsi_cmnd *cmd)
=20
 	spin_unlock_irq(&hostdata->lock);
 	err =3D NCR5380_poll_politely2(hostdata, MODE_REG, MR_ARBITRATE, 0,
-	                INITIATOR_COMMAND_REG, ICR_ARBITRATION_PROGRESS,
-	                                       ICR_ARBITRATION_PROGRESS, HZ);
+				     INITIATOR_COMMAND_REG,
+				     ICR_ARBITRATION_PROGRESS,
+				     ICR_ARBITRATION_PROGRESS,
+				     HZ, true);
 	spin_lock_irq(&hostdata->lock);
 	if (!(NCR5380_read(MODE_REG) & MR_ARBITRATE)) {
 		/* Reselection interrupt */
@@ -1136,7 +1141,7 @@ static bool NCR5380_select(struct Scsi_Host *instance=
, struct scsi_cmnd *cmd)
 	 */
=20
 	err =3D NCR5380_poll_politely(hostdata, STATUS_REG, SR_BSY, SR_BSY,
-	                            msecs_to_jiffies(250));
+	                            msecs_to_jiffies(250), true);
=20
 	if ((NCR5380_read(STATUS_REG) & (SR_SEL | SR_IO)) =3D=3D (SR_SEL | SR_IO)=
) {
 		spin_lock_irq(&hostdata->lock);
@@ -1181,7 +1186,7 @@ static bool NCR5380_select(struct Scsi_Host *instance=
, struct scsi_cmnd *cmd)
=20
 	/* Wait for start of REQ/ACK handshake */
=20
-	err =3D NCR5380_poll_politely(hostdata, STATUS_REG, SR_REQ, SR_REQ, HZ);
+	err =3D NCR5380_poll_politely(hostdata, STATUS_REG, SR_REQ, SR_REQ, HZ, t=
rue);
 	spin_lock_irq(&hostdata->lock);
 	if (err < 0) {
 		shost_printk(KERN_ERR, instance, "select: REQ timeout\n");
@@ -1189,7 +1194,7 @@ static bool NCR5380_select(struct Scsi_Host *instance=
, struct scsi_cmnd *cmd)
 		goto out;
 	}
 	if (!hostdata->selecting) {
-		do_abort(instance);
+		do_abort(instance, false);
 		return false;
 	}
=20
@@ -1200,7 +1205,7 @@ static bool NCR5380_select(struct Scsi_Host *instance=
, struct scsi_cmnd *cmd)
 	len =3D 1;
 	data =3D tmp;
 	phase =3D PHASE_MSGOUT;
-	NCR5380_transfer_pio(instance, &phase, &len, &data);
+	NCR5380_transfer_pio(instance, &phase, &len, &data, false);
 	if (len) {
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 		cmd->result =3D DID_ERROR << 16;
@@ -1238,7 +1243,8 @@ static bool NCR5380_select(struct Scsi_Host *instance=
, struct scsi_cmnd *cmd)
  *
  * Inputs : instance - instance of driver, *phase - pointer to
  * what phase is expected, *count - pointer to number of
- * bytes to transfer, **data - pointer to data pointer.
+ * bytes to transfer, **data - pointer to data pointer,
+ * can_sleep - whether it is safe to sleep.
  *
  * Returns : -1 when different phase is entered without transferring
  * maximum number of bytes, 0 if all bytes are transferred or exit
@@ -1257,7 +1263,7 @@ static bool NCR5380_select(struct Scsi_Host *instance=
, struct scsi_cmnd *cmd)
=20
 static int NCR5380_transfer_pio(struct Scsi_Host *instance,
 				unsigned char *phase, int *count,
-				unsigned char **data)
+				unsigned char **data, bool can_sleep)
 {
 	struct NCR5380_hostdata *hostdata =3D shost_priv(instance);
 	unsigned char p =3D *phase, tmp;
@@ -1278,7 +1284,8 @@ static int NCR5380_transfer_pio(struct Scsi_Host *ins=
tance,
 		 * valid
 		 */
=20
-		if (NCR5380_poll_politely(hostdata, STATUS_REG, SR_REQ, SR_REQ, HZ) < 0)
+		if (NCR5380_poll_politely(hostdata, STATUS_REG, SR_REQ, SR_REQ,
+					  HZ, can_sleep) < 0)
 			break;
=20
 		dsprintk(NDEBUG_HANDSHAKE, instance, "REQ asserted\n");
@@ -1324,7 +1331,7 @@ static int NCR5380_transfer_pio(struct Scsi_Host *ins=
tance,
 		}
=20
 		if (NCR5380_poll_politely(hostdata,
-		                          STATUS_REG, SR_REQ, 0, 5 * HZ) < 0)
+		                          STATUS_REG, SR_REQ, 0, 5 * HZ, can_sleep) < 0)
 			break;
=20
 		dsprintk(NDEBUG_HANDSHAKE, instance, "REQ negated, handshake complete\n"=
);
@@ -1399,11 +1406,12 @@ static void do_reset(struct Scsi_Host *instance)
  * do_abort - abort the currently established nexus by going to
  * MESSAGE OUT phase and sending an ABORT message.
  * @instance: relevant scsi host instance
+ * @can_sleep: true if the function can sleep
  *
  * Returns 0 on success, negative error code on failure.
  */
=20
-static int do_abort(struct Scsi_Host *instance)
+static int do_abort(struct Scsi_Host *instance, bool can_sleep)
 {
 	struct NCR5380_hostdata *hostdata =3D shost_priv(instance);
 	unsigned char *msgptr, phase, tmp;
@@ -1423,7 +1431,8 @@ static int do_abort(struct Scsi_Host *instance)
 	 * the target sees, so we just handshake.
 	 */
=20
-	rc =3D NCR5380_poll_politely(hostdata, STATUS_REG, SR_REQ, SR_REQ, 10 * H=
Z);
+	rc =3D NCR5380_poll_politely(hostdata, STATUS_REG, SR_REQ, SR_REQ,
+				   10 * HZ, can_sleep);
 	if (rc < 0)
 		goto out;
=20
@@ -1434,7 +1443,8 @@ static int do_abort(struct Scsi_Host *instance)
 	if (tmp !=3D PHASE_MSGOUT) {
 		NCR5380_write(INITIATOR_COMMAND_REG,
 		              ICR_BASE | ICR_ASSERT_ATN | ICR_ASSERT_ACK);
-		rc =3D NCR5380_poll_politely(hostdata, STATUS_REG, SR_REQ, 0, 3 * HZ);
+		rc =3D NCR5380_poll_politely(hostdata, STATUS_REG, SR_REQ, 0,
+					   3 * HZ, can_sleep);
 		if (rc < 0)
 			goto out;
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ATN);
@@ -1444,7 +1454,7 @@ static int do_abort(struct Scsi_Host *instance)
 	msgptr =3D &tmp;
 	len =3D 1;
 	phase =3D PHASE_MSGOUT;
-	NCR5380_transfer_pio(instance, &phase, &len, &msgptr);
+	NCR5380_transfer_pio(instance, &phase, &len, &msgptr, can_sleep);
 	if (len)
 		rc =3D -ENXIO;
=20
@@ -1474,9 +1484,9 @@ static int do_abort(struct Scsi_Host *instance)
  * is in same phase.
  *
  * Also, *phase, *count, *data are modified in place.
+ *
+ * Context: atomic, @instance hostdata spinlock held
  */
-
-
 static int NCR5380_transfer_dma(struct Scsi_Host *instance,
 				unsigned char *phase, int *count,
 				unsigned char **data)
@@ -1623,12 +1633,12 @@ static int NCR5380_transfer_dma(struct Scsi_Host *i=
nstance,
 			 */
=20
 			if (NCR5380_poll_politely(hostdata, BUS_AND_STATUS_REG,
-			                          BASR_DRQ, BASR_DRQ, HZ) < 0) {
+			                          BASR_DRQ, BASR_DRQ, HZ, false) < 0) {
 				result =3D -1;
 				shost_printk(KERN_ERR, instance, "PDMA read: DRQ timeout\n");
 			}
 			if (NCR5380_poll_politely(hostdata, STATUS_REG,
-			                          SR_REQ, 0, HZ) < 0) {
+			                          SR_REQ, 0, HZ, false) < 0) {
 				result =3D -1;
 				shost_printk(KERN_ERR, instance, "PDMA read: !REQ timeout\n");
 			}
@@ -1640,7 +1650,7 @@ static int NCR5380_transfer_dma(struct Scsi_Host *ins=
tance,
 			 */
 			if (NCR5380_poll_politely2(hostdata,
 			     BUS_AND_STATUS_REG, BASR_DRQ, BASR_DRQ,
-			     BUS_AND_STATUS_REG, BASR_PHASE_MATCH, 0, HZ) < 0) {
+			     BUS_AND_STATUS_REG, BASR_PHASE_MATCH, 0, HZ, false) < 0) {
 				result =3D -1;
 				shost_printk(KERN_ERR, instance, "PDMA write: DRQ and phase timeout\n"=
);
 			}
@@ -1666,8 +1676,11 @@ static int NCR5380_transfer_dma(struct Scsi_Host *in=
stance,
  *
  * XXX Note : we need to watch for bus free or a reset condition here
  * to recover from an unexpected bus free condition.
+ *
+ * Context: task context, with @instance hostdata spinlock held by
+ * caller.  That is, this function can sleep in the areas between
+ * releasing and re-acquring that spinlock.
  */
-
 static void NCR5380_information_transfer(struct Scsi_Host *instance)
 	__releases(&hostdata->lock) __acquires(&hostdata->lock)
 {
@@ -1737,7 +1750,7 @@ static void NCR5380_information_transfer(struct Scsi_=
Host *instance)
 #if (NDEBUG & NDEBUG_NO_DATAOUT)
 				shost_printk(KERN_DEBUG, instance, "NDEBUG_NO_DATAOUT set, attempted D=
ATAOUT aborted\n");
 				sink =3D 1;
-				do_abort(instance);
+				do_abort(instance, false);
 				cmd->result =3D DID_ERROR << 16;
 				complete_cmd(instance, cmd);
 				hostdata->connected =3D NULL;
@@ -1793,7 +1806,8 @@ static void NCR5380_information_transfer(struct Scsi_=
Host *instance)
 							   NCR5380_PIO_CHUNK_SIZE);
 					len =3D transfersize;
 					NCR5380_transfer_pio(instance, &phase, &len,
-					                     (unsigned char **)&cmd->SCp.ptr);
+					                     (unsigned char **)&cmd->SCp.ptr,
+							     false);
 					cmd->SCp.this_residual -=3D transfersize - len;
 				}
 #ifdef CONFIG_SUN3
@@ -1804,7 +1818,7 @@ static void NCR5380_information_transfer(struct Scsi_=
Host *instance)
 			case PHASE_MSGIN:
 				len =3D 1;
 				data =3D &tmp;
-				NCR5380_transfer_pio(instance, &phase, &len, &data);
+				NCR5380_transfer_pio(instance, &phase, &len, &data, false);
 				cmd->SCp.Message =3D tmp;
=20
 				switch (tmp) {
@@ -1910,7 +1924,7 @@ static void NCR5380_information_transfer(struct Scsi_=
Host *instance)
 					len =3D 2;
 					data =3D extended_msg + 1;
 					phase =3D PHASE_MSGIN;
-					NCR5380_transfer_pio(instance, &phase, &len, &data);
+					NCR5380_transfer_pio(instance, &phase, &len, &data, true);
 					dsprintk(NDEBUG_EXTENDED, instance, "length %d, code 0x%02x\n",
 					         (int)extended_msg[1],
 					         (int)extended_msg[2]);
@@ -1923,7 +1937,7 @@ static void NCR5380_information_transfer(struct Scsi_=
Host *instance)
 						data =3D extended_msg + 3;
 						phase =3D PHASE_MSGIN;
=20
-						NCR5380_transfer_pio(instance, &phase, &len, &data);
+						NCR5380_transfer_pio(instance, &phase, &len, &data, true);
 						dsprintk(NDEBUG_EXTENDED, instance, "message received, residual %d\n=
",
 						         len);
=20
@@ -1970,7 +1984,7 @@ static void NCR5380_information_transfer(struct Scsi_=
Host *instance)
 				len =3D 1;
 				data =3D &msgout;
 				hostdata->last_message =3D msgout;
-				NCR5380_transfer_pio(instance, &phase, &len, &data);
+				NCR5380_transfer_pio(instance, &phase, &len, &data, false);
 				if (msgout =3D=3D ABORT) {
 					hostdata->connected =3D NULL;
 					hostdata->busy[scmd_id(cmd)] &=3D ~(1 << cmd->device->lun);
@@ -1988,12 +2002,12 @@ static void NCR5380_information_transfer(struct Scs=
i_Host *instance)
 				 * PSEUDO-DMA architecture we should probably
 				 * use the dma transfer function.
 				 */
-				NCR5380_transfer_pio(instance, &phase, &len, &data);
+				NCR5380_transfer_pio(instance, &phase, &len, &data, false);
 				break;
 			case PHASE_STATIN:
 				len =3D 1;
 				data =3D &tmp;
-				NCR5380_transfer_pio(instance, &phase, &len, &data);
+				NCR5380_transfer_pio(instance, &phase, &len, &data, false);
 				cmd->SCp.Status =3D tmp;
 				break;
 			default:
@@ -2002,7 +2016,7 @@ static void NCR5380_information_transfer(struct Scsi_=
Host *instance)
 			} /* switch(phase) */
 		} else {
 			spin_unlock_irq(&hostdata->lock);
-			NCR5380_poll_politely(hostdata, STATUS_REG, SR_REQ, SR_REQ, HZ);
+			NCR5380_poll_politely(hostdata, STATUS_REG, SR_REQ, SR_REQ, HZ, true);
 			spin_lock_irq(&hostdata->lock);
 		}
 	}
@@ -2016,8 +2030,9 @@ static void NCR5380_information_transfer(struct Scsi_=
Host *instance)
  * nexus has been reestablished,
  *
  * Inputs : instance - this instance of the NCR5380.
+ *
+ * Context: atomic, with @instance hostdata spinlock held
  */
-
 static void NCR5380_reselect(struct Scsi_Host *instance)
 {
 	struct NCR5380_hostdata *hostdata =3D shost_priv(instance);
@@ -2052,7 +2067,7 @@ static void NCR5380_reselect(struct Scsi_Host *instan=
ce)
=20
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_BSY);
 	if (NCR5380_poll_politely(hostdata,
-	                          STATUS_REG, SR_SEL, 0, 2 * HZ) < 0) {
+	                          STATUS_REG, SR_SEL, 0, 2 * HZ, false) < 0) {
 		shost_printk(KERN_ERR, instance, "reselect: !SEL timeout\n");
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 		return;
@@ -2064,12 +2079,12 @@ static void NCR5380_reselect(struct Scsi_Host *inst=
ance)
 	 */
=20
 	if (NCR5380_poll_politely(hostdata,
-	                          STATUS_REG, SR_REQ, SR_REQ, 2 * HZ) < 0) {
+	                          STATUS_REG, SR_REQ, SR_REQ, 2 * HZ, false) < 0)=
 {
 		if ((NCR5380_read(STATUS_REG) & (SR_BSY | SR_SEL)) =3D=3D 0)
 			/* BUS FREE phase */
 			return;
 		shost_printk(KERN_ERR, instance, "reselect: REQ timeout\n");
-		do_abort(instance);
+		do_abort(instance, false);
 		return;
 	}
=20
@@ -2085,10 +2100,10 @@ static void NCR5380_reselect(struct Scsi_Host *inst=
ance)
 		unsigned char *data =3D msg;
 		unsigned char phase =3D PHASE_MSGIN;
=20
-		NCR5380_transfer_pio(instance, &phase, &len, &data);
+		NCR5380_transfer_pio(instance, &phase, &len, &data, false);
=20
 		if (len) {
-			do_abort(instance);
+			do_abort(instance, false);
 			return;
 		}
 	}
@@ -2098,7 +2113,7 @@ static void NCR5380_reselect(struct Scsi_Host *instan=
ce)
 		shost_printk(KERN_ERR, instance, "expecting IDENTIFY message, got ");
 		spi_print_msg(msg);
 		printk("\n");
-		do_abort(instance);
+		do_abort(instance, false);
 		return;
 	}
 	lun =3D msg[0] & 0x07;
@@ -2138,7 +2153,7 @@ static void NCR5380_reselect(struct Scsi_Host *instan=
ce)
 		 * Since we have an established nexus that we can't do anything
 		 * with, we must abort it.
 		 */
-		if (do_abort(instance) =3D=3D 0)
+		if (do_abort(instance, false) =3D=3D 0)
 			hostdata->busy[target] &=3D ~(1 << lun);
 		return;
 	}
@@ -2285,7 +2300,7 @@ static int NCR5380_abort(struct scsi_cmnd *cmd)
 		dsprintk(NDEBUG_ABORT, instance, "abort: cmd %p is connected\n", cmd);
 		hostdata->connected =3D NULL;
 		hostdata->dma_len =3D 0;
-		if (do_abort(instance) < 0) {
+		if (do_abort(instance, false) < 0) {
 			set_host_byte(cmd, DID_ERROR);
 			complete_cmd(instance, cmd);
 			result =3D FAILED;
diff --git a/drivers/scsi/NCR5380.h b/drivers/scsi/NCR5380.h
index 5935fd6d1a058..7c569e92ca58e 100644
--- a/drivers/scsi/NCR5380.h
+++ b/drivers/scsi/NCR5380.h
@@ -277,20 +277,21 @@ static const char *NCR5380_info(struct Scsi_Host *ins=
tance);
 static void NCR5380_reselect(struct Scsi_Host *instance);
 static bool NCR5380_select(struct Scsi_Host *, struct scsi_cmnd *);
 static int NCR5380_transfer_dma(struct Scsi_Host *instance, unsigned char =
*phase, int *count, unsigned char **data);
-static int NCR5380_transfer_pio(struct Scsi_Host *instance, unsigned char =
*phase, int *count, unsigned char **data);
+static int NCR5380_transfer_pio(struct Scsi_Host *instance, unsigned char =
*phase,
+				int *count, unsigned char **data, bool can_sleep);
 static int NCR5380_poll_politely2(struct NCR5380_hostdata *,
                                   unsigned int, u8, u8,
-                                  unsigned int, u8, u8, unsigned long);
+                                  unsigned int, u8, u8, unsigned long, boo=
l);
=20
 static inline int NCR5380_poll_politely(struct NCR5380_hostdata *hostdata,
                                         unsigned int reg, u8 bit, u8 val,
-                                        unsigned long wait)
+                                        unsigned long wait, bool can_sleep)
 {
 	if ((NCR5380_read(reg) & bit) =3D=3D val)
 		return 0;
=20
 	return NCR5380_poll_politely2(hostdata, reg, bit, val,
-						reg, bit, val, wait);
+				      reg, bit, val, wait, can_sleep);
 }
=20
 static int NCR5380_dma_xfer_len(struct NCR5380_hostdata *,
diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 29e4cdcade720..06b1fcfd33cc9 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -513,9 +513,11 @@ static void wait_for_53c80_access(struct NCR5380_hostd=
ata *hostdata)
  * @dst: buffer to write into
  * @len: transfer size
  *
+ * Context: atomic. This implements NCR5380.c NCR5380_dma_recv_setup(),
+ * which is always called with @hostdata spinlock held.
+ *
  * Perform a pseudo DMA mode receive from a 53C400 or equivalent device.
  */
-
 static inline int generic_NCR5380_precv(struct NCR5380_hostdata *hostdata,
                                         unsigned char *dst, int len)
 {
@@ -529,14 +531,16 @@ static inline int generic_NCR5380_precv(struct NCR538=
0_hostdata *hostdata,
 		if (start =3D=3D len - 128) {
 			/* Ignore End of DMA interrupt for the final buffer */
 			if (NCR5380_poll_politely(hostdata, hostdata->c400_ctl_status,
-			                          CSR_HOST_BUF_NOT_RDY, 0, HZ / 64) < 0)
+			                          CSR_HOST_BUF_NOT_RDY, 0, HZ / 64,
+						  false) < 0)
 				break;
 		} else {
 			if (NCR5380_poll_politely2(hostdata, hostdata->c400_ctl_status,
 			                           CSR_HOST_BUF_NOT_RDY, 0,
 			                           hostdata->c400_ctl_status,
 			                           CSR_GATED_53C80_IRQ,
-			                           CSR_GATED_53C80_IRQ, HZ / 64) < 0 ||
+			                           CSR_GATED_53C80_IRQ, HZ / 64,
+						   false) < 0 ||
 			    NCR5380_read(hostdata->c400_ctl_status) & CSR_HOST_BUF_NOT_RDY)
 				break;
 		}
@@ -565,7 +569,8 @@ static inline int generic_NCR5380_precv(struct NCR5380_=
hostdata *hostdata,
 	if (residual =3D=3D 0 && NCR5380_poll_politely(hostdata, BUS_AND_STATUS_R=
EG,
 	                                           BASR_END_DMA_TRANSFER,
 	                                           BASR_END_DMA_TRANSFER,
-	                                           HZ / 64) < 0)
+	                                           HZ / 64,
+						   false) < 0)
 		scmd_printk(KERN_ERR, hostdata->connected, "%s: End of DMA timeout\n",
 		            __func__);
=20
@@ -580,9 +585,11 @@ static inline int generic_NCR5380_precv(struct NCR5380=
_hostdata *hostdata,
  * @src: buffer to read from
  * @len: transfer size
  *
+ * Context: atomic. This implements NCR5380.c NCR5380_dma_send_setup(),
+ * which is always called with @hostdata spinlock held.
+ *
  * Perform a pseudo DMA mode send to a 53C400 or equivalent device.
  */
-
 static inline int generic_NCR5380_psend(struct NCR5380_hostdata *hostdata,
                                         unsigned char *src, int len)
 {
@@ -597,7 +604,8 @@ static inline int generic_NCR5380_psend(struct NCR5380_=
hostdata *hostdata,
 		                           CSR_HOST_BUF_NOT_RDY, 0,
 		                           hostdata->c400_ctl_status,
 		                           CSR_GATED_53C80_IRQ,
-		                           CSR_GATED_53C80_IRQ, HZ / 64) < 0 ||
+		                           CSR_GATED_53C80_IRQ, HZ / 64,
+					   false) < 0 ||
 		    NCR5380_read(hostdata->c400_ctl_status) & CSR_HOST_BUF_NOT_RDY) {
 			/* Both 128 B buffers are in use */
 			if (start >=3D 128)
@@ -644,13 +652,15 @@ static inline int generic_NCR5380_psend(struct NCR538=
0_hostdata *hostdata,
 	if (residual =3D=3D 0) {
 		if (NCR5380_poll_politely(hostdata, TARGET_COMMAND_REG,
 		                          TCR_LAST_BYTE_SENT, TCR_LAST_BYTE_SENT,
-		                          HZ / 64) < 0)
+		                          HZ / 64,
+					  false) < 0)
 			scmd_printk(KERN_ERR, hostdata->connected,
 			            "%s: Last Byte Sent timeout\n", __func__);
=20
 		if (NCR5380_poll_politely(hostdata, BUS_AND_STATUS_REG,
 		                          BASR_END_DMA_TRANSFER, BASR_END_DMA_TRANSFER,
-		                          HZ / 64) < 0)
+		                          HZ / 64,
+					  false) < 0)
 			scmd_printk(KERN_ERR, hostdata->connected, "%s: End of DMA timeout\n",
 			            __func__);
 	}
diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
index b5dde9d0d0545..3c39db74fd847 100644
--- a/drivers/scsi/mac_scsi.c
+++ b/drivers/scsi/mac_scsi.c
@@ -285,7 +285,7 @@ static inline int macscsi_pread(struct NCR5380_hostdata=
 *hostdata,
=20
 	while (!NCR5380_poll_politely(hostdata, BUS_AND_STATUS_REG,
 	                              BASR_DRQ | BASR_PHASE_MATCH,
-	                              BASR_DRQ | BASR_PHASE_MATCH, HZ / 64)) {
+	                              BASR_DRQ | BASR_PHASE_MATCH, HZ / 64, false=
)) {
 		int bytes;
=20
 		if (macintosh_config->ident =3D=3D MAC_MODEL_IIFX)
@@ -304,7 +304,7 @@ static inline int macscsi_pread(struct NCR5380_hostdata=
 *hostdata,
=20
 		if (NCR5380_poll_politely2(hostdata, STATUS_REG, SR_REQ, SR_REQ,
 		                           BUS_AND_STATUS_REG, BASR_ACK,
-		                           BASR_ACK, HZ / 64) < 0)
+		                           BASR_ACK, HZ / 64, false) < 0)
 			scmd_printk(KERN_DEBUG, hostdata->connected,
 			            "%s: !REQ and !ACK\n", __func__);
 		if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_PHASE_MATCH))
@@ -344,7 +344,7 @@ static inline int macscsi_pwrite(struct NCR5380_hostdat=
a *hostdata,
=20
 	while (!NCR5380_poll_politely(hostdata, BUS_AND_STATUS_REG,
 	                              BASR_DRQ | BASR_PHASE_MATCH,
-	                              BASR_DRQ | BASR_PHASE_MATCH, HZ / 64)) {
+	                              BASR_DRQ | BASR_PHASE_MATCH, HZ / 64, false=
)) {
 		int bytes;
=20
 		if (macintosh_config->ident =3D=3D MAC_MODEL_IIFX)
@@ -362,7 +362,7 @@ static inline int macscsi_pwrite(struct NCR5380_hostdat=
a *hostdata,
 			if (NCR5380_poll_politely(hostdata, TARGET_COMMAND_REG,
 			                          TCR_LAST_BYTE_SENT,
 			                          TCR_LAST_BYTE_SENT,
-			                          HZ / 64) < 0) {
+			                          HZ / 64, false) < 0) {
 				scmd_printk(KERN_ERR, hostdata->connected,
 				            "%s: Last Byte Sent timeout\n", __func__);
 				result =3D -1;
@@ -372,7 +372,7 @@ static inline int macscsi_pwrite(struct NCR5380_hostdat=
a *hostdata,
=20
 		if (NCR5380_poll_politely2(hostdata, STATUS_REG, SR_REQ, SR_REQ,
 		                           BUS_AND_STATUS_REG, BASR_ACK,
-		                           BASR_ACK, HZ / 64) < 0)
+		                           BASR_ACK, HZ / 64, false) < 0)
 			scmd_printk(KERN_DEBUG, hostdata->connected,
 			            "%s: !REQ and !ACK\n", __func__);
 		if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_PHASE_MATCH))
--=20
2.29.2

