Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8860AC4361B
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 07:53:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FE67230FA
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 07:53:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725779AbgLFHwo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Dec 2020 02:52:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725613AbgLFHwn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Dec 2020 02:52:43 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BE11C0613D0;
        Sat,  5 Dec 2020 23:52:03 -0800 (PST)
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1607241118;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cDbvtih+ViszaxYkRgQCFhYOjmKmZiCXaWXYXIOWsiU=;
        b=WsPmHhOQADsGWVzWrB2nnczM8X5A5OQSrfH/6EKru5zqf073JUFKUZQF8uqRvk6/2WSEVT
        68W8bLHfsVRCpIogeLuSw6N9GBVyPE83VTI8RP7/oqUrcIFsJ9Gb43Ot+61d0RHAKtZFdq
        6JI1tZHcd/L9tJ16NV7Iuc+RqqNruaNf+CbHWEAMeQU1WTQruz9DT1y1QY6cnIk4KunsdU
        xo5PbEJGdX45KahLZc0Qg5eAEQG5Gf15CErrfRhYj5dVSRJPQoyFCMRlru612shEnRB/na
        S0pqrW0f1x63/r/DoYDvJpW4fi1UjTE7JT0cK3xiWXTZWXpIETWcajFZpf8BLw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1607241118;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cDbvtih+ViszaxYkRgQCFhYOjmKmZiCXaWXYXIOWsiU=;
        b=MVl1WYayOJI+YeobzTt7xiBnOP9mDw330uTg5STbWQKdaizyDjTVkrRaMkDuMFzugWoj78
        7gjSNFT1yXXzrgDA==
To:     Finn Thain <fthain@telegraphics.com.au>
Cc:     Michael Schmitz <schmitzmic@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>
Subject: [PATCH v3] scsi: NCR5380: Remove context check
Date:   Sun,  6 Dec 2020 08:51:57 +0100
Message-Id: <20201206075157.19067-1-a.darwish@linutronix.de>
In-Reply-To: <alpine.LNX.2.23.453.2012051512300.6@nippy.intranet>
References: <alpine.LNX.2.23.453.2012051512300.6@nippy.intranet>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

NCR5380_poll_politely2() uses in_interrupt() and irqs_disabled() to
check if it is safe to sleep.

Such usage in drivers is phased out and Linus clearly requested that
code which changes behaviour depending on context should either be
separated, or the context be explicitly conveyed in an argument passed
by the caller.

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
           => generic_NCR5380_precv() -> NCR5380_poll_politely()
	   => macscsi_pread() -> NCR5380_poll_politely()

	-> NCR5380_dma_send_setup()
 	   => generic_NCR5380_psend -> NCR5380_poll_politely2()
	   => macscsi_pwrite() -> NCR5380_poll_politely()

	-> NCR5380_poll_politely2()
        -> NCR5380_dma_complete()
           -> NCR5380_transfer_pio()
	      -> NCR5380_poll_politely()
      - NCR5380_transfer_pio() -> NCR5380_poll_politely

  - NCR5380_reselect(), atomic, always called with hostdata spinlock
    held.

Since NCR5380_poll_politely2() already takes a "wait" argument in
jiffies, use it to determine if the function can sleep. Modify atomic
callers, which passed an unused wait value in terms of HZ, to pass zero.

Suggested-by: Finn Thain <fthain@telegraphics.com.au>
Co-developed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Cc: Michael Schmitz <schmitzmic@gmail.com>
Cc: <linux-m68k@lists.linux-m68k.org>
---
 drivers/scsi/NCR5380.c   | 74 ++++++++++++++++++++++------------------
 drivers/scsi/NCR5380.h   |  3 +-
 drivers/scsi/g_NCR5380.c | 12 +++----
 drivers/scsi/mac_scsi.c  | 10 +++---
 4 files changed, 53 insertions(+), 46 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index d654a6cc4162..448cd22214c0 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -132,7 +132,7 @@
 static unsigned int disconnect_mask = ~0;
 module_param(disconnect_mask, int, 0444);
 
-static int do_abort(struct Scsi_Host *);
+static int do_abort(struct Scsi_Host *, unsigned int);
 static void do_reset(struct Scsi_Host *);
 static void bus_reset_cleanup(struct Scsi_Host *);
 
@@ -197,7 +197,7 @@ static inline void set_resid_from_SCp(struct scsi_cmnd *cmd)
  * @reg2: Second 5380 register to poll
  * @bit2: Second bitmask to check
  * @val2: Second expected value
- * @wait: Time-out in jiffies
+ * @wait: Time-out in jiffies, 0 if sleeping is not allowed
  *
  * Polls the chip in a reasonably efficient manner waiting for an
  * event to occur. After a short quick poll we begin to yield the CPU
@@ -223,7 +223,7 @@ static int NCR5380_poll_politely2(struct NCR5380_hostdata *hostdata,
 		cpu_relax();
 	} while (n--);
 
-	if (irqs_disabled() || in_interrupt())
+	if (!wait)
 		return -ETIMEDOUT;
 
 	/* Repeatedly sleep for 1 ms until deadline */
@@ -486,7 +486,7 @@ static int NCR5380_maybe_reset_bus(struct Scsi_Host *instance)
 			break;
 		case 2:
 			shost_printk(KERN_ERR, instance, "bus busy, attempting abort\n");
-			do_abort(instance);
+			do_abort(instance, 1);
 			break;
 		case 4:
 			shost_printk(KERN_ERR, instance, "bus busy, attempting reset\n");
@@ -818,7 +818,7 @@ static void NCR5380_dma_complete(struct Scsi_Host *instance)
 			if (toPIO > 0) {
 				dsprintk(NDEBUG_DMA, instance,
 				         "Doing %d byte PIO to 0x%p\n", cnt, *data);
-				NCR5380_transfer_pio(instance, &p, &cnt, data);
+				NCR5380_transfer_pio(instance, &p, &cnt, data, 0);
 				*count -= toPIO - cnt;
 			}
 		}
@@ -1185,7 +1185,7 @@ static bool NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
 		goto out;
 	}
 	if (!hostdata->selecting) {
-		do_abort(instance);
+		do_abort(instance, 0);
 		return false;
 	}
 
@@ -1196,7 +1196,7 @@ static bool NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
 	len = 1;
 	data = tmp;
 	phase = PHASE_MSGOUT;
-	NCR5380_transfer_pio(instance, &phase, &len, &data);
+	NCR5380_transfer_pio(instance, &phase, &len, &data, 0);
 	if (len) {
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 		cmd->result = DID_ERROR << 16;
@@ -1234,7 +1234,8 @@ static bool NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
  *
  * Inputs : instance - instance of driver, *phase - pointer to
  * what phase is expected, *count - pointer to number of
- * bytes to transfer, **data - pointer to data pointer.
+ * bytes to transfer, **data - pointer to data pointer,
+ * can_sleep - 1 or 0 when sleeping is permitted or not, respectively.
  *
  * Returns : -1 when different phase is entered without transferring
  * maximum number of bytes, 0 if all bytes are transferred or exit
@@ -1253,7 +1254,7 @@ static bool NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
 
 static int NCR5380_transfer_pio(struct Scsi_Host *instance,
 				unsigned char *phase, int *count,
-				unsigned char **data)
+				unsigned char **data, unsigned int can_sleep)
 {
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	unsigned char p = *phase, tmp;
@@ -1274,7 +1275,8 @@ static int NCR5380_transfer_pio(struct Scsi_Host *instance,
 		 * valid
 		 */
 
-		if (NCR5380_poll_politely(hostdata, STATUS_REG, SR_REQ, SR_REQ, HZ) < 0)
+		if (NCR5380_poll_politely(hostdata, STATUS_REG, SR_REQ, SR_REQ,
+					  HZ * can_sleep) < 0)
 			break;
 
 		dsprintk(NDEBUG_HANDSHAKE, instance, "REQ asserted\n");
@@ -1320,7 +1322,7 @@ static int NCR5380_transfer_pio(struct Scsi_Host *instance,
 		}
 
 		if (NCR5380_poll_politely(hostdata,
-		                          STATUS_REG, SR_REQ, 0, 5 * HZ) < 0)
+		                          STATUS_REG, SR_REQ, 0, 5 * HZ * can_sleep) < 0)
 			break;
 
 		dsprintk(NDEBUG_HANDSHAKE, instance, "REQ negated, handshake complete\n");
@@ -1395,11 +1397,12 @@ static void do_reset(struct Scsi_Host *instance)
  * do_abort - abort the currently established nexus by going to
  * MESSAGE OUT phase and sending an ABORT message.
  * @instance: relevant scsi host instance
+ * @can_sleep: 1 or 0 when sleeping is permitted or not, respectively
  *
  * Returns 0 on success, negative error code on failure.
  */
 
-static int do_abort(struct Scsi_Host *instance)
+static int do_abort(struct Scsi_Host *instance, unsigned int can_sleep)
 {
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	unsigned char *msgptr, phase, tmp;
@@ -1419,7 +1422,8 @@ static int do_abort(struct Scsi_Host *instance)
 	 * the target sees, so we just handshake.
 	 */
 
-	rc = NCR5380_poll_politely(hostdata, STATUS_REG, SR_REQ, SR_REQ, 10 * HZ);
+	rc = NCR5380_poll_politely(hostdata, STATUS_REG, SR_REQ, SR_REQ,
+				   10 * HZ * can_sleep);
 	if (rc < 0)
 		goto out;
 
@@ -1430,7 +1434,8 @@ static int do_abort(struct Scsi_Host *instance)
 	if (tmp != PHASE_MSGOUT) {
 		NCR5380_write(INITIATOR_COMMAND_REG,
 		              ICR_BASE | ICR_ASSERT_ATN | ICR_ASSERT_ACK);
-		rc = NCR5380_poll_politely(hostdata, STATUS_REG, SR_REQ, 0, 3 * HZ);
+		rc = NCR5380_poll_politely(hostdata, STATUS_REG, SR_REQ, 0,
+					   3 * HZ * can_sleep);
 		if (rc < 0)
 			goto out;
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ATN);
@@ -1440,7 +1445,7 @@ static int do_abort(struct Scsi_Host *instance)
 	msgptr = &tmp;
 	len = 1;
 	phase = PHASE_MSGOUT;
-	NCR5380_transfer_pio(instance, &phase, &len, &msgptr);
+	NCR5380_transfer_pio(instance, &phase, &len, &msgptr, can_sleep);
 	if (len)
 		rc = -ENXIO;
 
@@ -1619,12 +1624,12 @@ static int NCR5380_transfer_dma(struct Scsi_Host *instance,
 			 */
 
 			if (NCR5380_poll_politely(hostdata, BUS_AND_STATUS_REG,
-			                          BASR_DRQ, BASR_DRQ, HZ) < 0) {
+			                          BASR_DRQ, BASR_DRQ, 0) < 0) {
 				result = -1;
 				shost_printk(KERN_ERR, instance, "PDMA read: DRQ timeout\n");
 			}
 			if (NCR5380_poll_politely(hostdata, STATUS_REG,
-			                          SR_REQ, 0, HZ) < 0) {
+			                          SR_REQ, 0, 0) < 0) {
 				result = -1;
 				shost_printk(KERN_ERR, instance, "PDMA read: !REQ timeout\n");
 			}
@@ -1636,7 +1641,7 @@ static int NCR5380_transfer_dma(struct Scsi_Host *instance,
 			 */
 			if (NCR5380_poll_politely2(hostdata,
 			     BUS_AND_STATUS_REG, BASR_DRQ, BASR_DRQ,
-			     BUS_AND_STATUS_REG, BASR_PHASE_MATCH, 0, HZ) < 0) {
+			     BUS_AND_STATUS_REG, BASR_PHASE_MATCH, 0, 0) < 0) {
 				result = -1;
 				shost_printk(KERN_ERR, instance, "PDMA write: DRQ and phase timeout\n");
 			}
@@ -1733,7 +1738,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 #if (NDEBUG & NDEBUG_NO_DATAOUT)
 				shost_printk(KERN_DEBUG, instance, "NDEBUG_NO_DATAOUT set, attempted DATAOUT aborted\n");
 				sink = 1;
-				do_abort(instance);
+				do_abort(instance, 0);
 				cmd->result = DID_ERROR << 16;
 				complete_cmd(instance, cmd);
 				hostdata->connected = NULL;
@@ -1789,7 +1794,8 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 							   NCR5380_PIO_CHUNK_SIZE);
 					len = transfersize;
 					NCR5380_transfer_pio(instance, &phase, &len,
-					                     (unsigned char **)&cmd->SCp.ptr);
+					                     (unsigned char **)&cmd->SCp.ptr,
+							     0);
 					cmd->SCp.this_residual -= transfersize - len;
 				}
 #ifdef CONFIG_SUN3
@@ -1800,7 +1806,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 			case PHASE_MSGIN:
 				len = 1;
 				data = &tmp;
-				NCR5380_transfer_pio(instance, &phase, &len, &data);
+				NCR5380_transfer_pio(instance, &phase, &len, &data, 0);
 				cmd->SCp.Message = tmp;
 
 				switch (tmp) {
@@ -1907,7 +1913,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 					len = 2;
 					data = extended_msg + 1;
 					phase = PHASE_MSGIN;
-					NCR5380_transfer_pio(instance, &phase, &len, &data);
+					NCR5380_transfer_pio(instance, &phase, &len, &data, 1);
 					dsprintk(NDEBUG_EXTENDED, instance, "length %d, code 0x%02x\n",
 					         (int)extended_msg[1],
 					         (int)extended_msg[2]);
@@ -1920,7 +1926,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 						data = extended_msg + 3;
 						phase = PHASE_MSGIN;
 
-						NCR5380_transfer_pio(instance, &phase, &len, &data);
+						NCR5380_transfer_pio(instance, &phase, &len, &data, 1);
 						dsprintk(NDEBUG_EXTENDED, instance, "message received, residual %d\n",
 						         len);
 
@@ -1967,7 +1973,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 				len = 1;
 				data = &msgout;
 				hostdata->last_message = msgout;
-				NCR5380_transfer_pio(instance, &phase, &len, &data);
+				NCR5380_transfer_pio(instance, &phase, &len, &data, 0);
 				if (msgout == ABORT) {
 					hostdata->connected = NULL;
 					hostdata->busy[scmd_id(cmd)] &= ~(1 << cmd->device->lun);
@@ -1986,12 +1992,12 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 				 * PSEUDO-DMA architecture we should probably
 				 * use the dma transfer function.
 				 */
-				NCR5380_transfer_pio(instance, &phase, &len, &data);
+				NCR5380_transfer_pio(instance, &phase, &len, &data, 0);
 				break;
 			case PHASE_STATIN:
 				len = 1;
 				data = &tmp;
-				NCR5380_transfer_pio(instance, &phase, &len, &data);
+				NCR5380_transfer_pio(instance, &phase, &len, &data, 0);
 				cmd->SCp.Status = tmp;
 				break;
 			default:
@@ -2050,7 +2056,7 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
 
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_BSY);
 	if (NCR5380_poll_politely(hostdata,
-	                          STATUS_REG, SR_SEL, 0, 2 * HZ) < 0) {
+	                          STATUS_REG, SR_SEL, 0, 0) < 0) {
 		shost_printk(KERN_ERR, instance, "reselect: !SEL timeout\n");
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 		return;
@@ -2062,12 +2068,12 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
 	 */
 
 	if (NCR5380_poll_politely(hostdata,
-	                          STATUS_REG, SR_REQ, SR_REQ, 2 * HZ) < 0) {
+	                          STATUS_REG, SR_REQ, SR_REQ, 0) < 0) {
 		if ((NCR5380_read(STATUS_REG) & (SR_BSY | SR_SEL)) == 0)
 			/* BUS FREE phase */
 			return;
 		shost_printk(KERN_ERR, instance, "reselect: REQ timeout\n");
-		do_abort(instance);
+		do_abort(instance, 0);
 		return;
 	}
 
@@ -2083,10 +2089,10 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
 		unsigned char *data = msg;
 		unsigned char phase = PHASE_MSGIN;
 
-		NCR5380_transfer_pio(instance, &phase, &len, &data);
+		NCR5380_transfer_pio(instance, &phase, &len, &data, 0);
 
 		if (len) {
-			do_abort(instance);
+			do_abort(instance, 0);
 			return;
 		}
 	}
@@ -2096,7 +2102,7 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
 		shost_printk(KERN_ERR, instance, "expecting IDENTIFY message, got ");
 		spi_print_msg(msg);
 		printk("\n");
-		do_abort(instance);
+		do_abort(instance, 0);
 		return;
 	}
 	lun = msg[0] & 0x07;
@@ -2136,7 +2142,7 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
 		 * Since we have an established nexus that we can't do anything
 		 * with, we must abort it.
 		 */
-		if (do_abort(instance) == 0)
+		if (do_abort(instance, 0) == 0)
 			hostdata->busy[target] &= ~(1 << lun);
 		return;
 	}
@@ -2283,7 +2289,7 @@ static int NCR5380_abort(struct scsi_cmnd *cmd)
 		dsprintk(NDEBUG_ABORT, instance, "abort: cmd %p is connected\n", cmd);
 		hostdata->connected = NULL;
 		hostdata->dma_len = 0;
-		if (do_abort(instance) < 0) {
+		if (do_abort(instance, 0) < 0) {
 			set_host_byte(cmd, DID_ERROR);
 			complete_cmd(instance, cmd);
 			result = FAILED;
diff --git a/drivers/scsi/NCR5380.h b/drivers/scsi/NCR5380.h
index 5935fd6d1a05..8a3b41932288 100644
--- a/drivers/scsi/NCR5380.h
+++ b/drivers/scsi/NCR5380.h
@@ -277,7 +277,8 @@ static const char *NCR5380_info(struct Scsi_Host *instance);
 static void NCR5380_reselect(struct Scsi_Host *instance);
 static bool NCR5380_select(struct Scsi_Host *, struct scsi_cmnd *);
 static int NCR5380_transfer_dma(struct Scsi_Host *instance, unsigned char *phase, int *count, unsigned char **data);
-static int NCR5380_transfer_pio(struct Scsi_Host *instance, unsigned char *phase, int *count, unsigned char **data);
+static int NCR5380_transfer_pio(struct Scsi_Host *instance, unsigned char *phase, int *count, unsigned char **data,
+				unsigned int can_sleep);
 static int NCR5380_poll_politely2(struct NCR5380_hostdata *,
                                   unsigned int, u8, u8,
                                   unsigned int, u8, u8, unsigned long);
diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 29e4cdcade72..2df2f38a9b12 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -529,14 +529,14 @@ static inline int generic_NCR5380_precv(struct NCR5380_hostdata *hostdata,
 		if (start == len - 128) {
 			/* Ignore End of DMA interrupt for the final buffer */
 			if (NCR5380_poll_politely(hostdata, hostdata->c400_ctl_status,
-			                          CSR_HOST_BUF_NOT_RDY, 0, HZ / 64) < 0)
+			                          CSR_HOST_BUF_NOT_RDY, 0, 0) < 0)
 				break;
 		} else {
 			if (NCR5380_poll_politely2(hostdata, hostdata->c400_ctl_status,
 			                           CSR_HOST_BUF_NOT_RDY, 0,
 			                           hostdata->c400_ctl_status,
 			                           CSR_GATED_53C80_IRQ,
-			                           CSR_GATED_53C80_IRQ, HZ / 64) < 0 ||
+			                           CSR_GATED_53C80_IRQ, 0) < 0 ||
 			    NCR5380_read(hostdata->c400_ctl_status) & CSR_HOST_BUF_NOT_RDY)
 				break;
 		}
@@ -565,7 +565,7 @@ static inline int generic_NCR5380_precv(struct NCR5380_hostdata *hostdata,
 	if (residual == 0 && NCR5380_poll_politely(hostdata, BUS_AND_STATUS_REG,
 	                                           BASR_END_DMA_TRANSFER,
 	                                           BASR_END_DMA_TRANSFER,
-	                                           HZ / 64) < 0)
+						   0) < 0)
 		scmd_printk(KERN_ERR, hostdata->connected, "%s: End of DMA timeout\n",
 		            __func__);
 
@@ -597,7 +597,7 @@ static inline int generic_NCR5380_psend(struct NCR5380_hostdata *hostdata,
 		                           CSR_HOST_BUF_NOT_RDY, 0,
 		                           hostdata->c400_ctl_status,
 		                           CSR_GATED_53C80_IRQ,
-		                           CSR_GATED_53C80_IRQ, HZ / 64) < 0 ||
+		                           CSR_GATED_53C80_IRQ, 0) < 0 ||
 		    NCR5380_read(hostdata->c400_ctl_status) & CSR_HOST_BUF_NOT_RDY) {
 			/* Both 128 B buffers are in use */
 			if (start >= 128)
@@ -644,13 +644,13 @@ static inline int generic_NCR5380_psend(struct NCR5380_hostdata *hostdata,
 	if (residual == 0) {
 		if (NCR5380_poll_politely(hostdata, TARGET_COMMAND_REG,
 		                          TCR_LAST_BYTE_SENT, TCR_LAST_BYTE_SENT,
-		                          HZ / 64) < 0)
+					  0) < 0)
 			scmd_printk(KERN_ERR, hostdata->connected,
 			            "%s: Last Byte Sent timeout\n", __func__);
 
 		if (NCR5380_poll_politely(hostdata, BUS_AND_STATUS_REG,
 		                          BASR_END_DMA_TRANSFER, BASR_END_DMA_TRANSFER,
-		                          HZ / 64) < 0)
+					  0) < 0)
 			scmd_printk(KERN_ERR, hostdata->connected, "%s: End of DMA timeout\n",
 			            __func__);
 	}
diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
index b5dde9d0d054..5c808fbc6ce2 100644
--- a/drivers/scsi/mac_scsi.c
+++ b/drivers/scsi/mac_scsi.c
@@ -285,7 +285,7 @@ static inline int macscsi_pread(struct NCR5380_hostdata *hostdata,
 
 	while (!NCR5380_poll_politely(hostdata, BUS_AND_STATUS_REG,
 	                              BASR_DRQ | BASR_PHASE_MATCH,
-	                              BASR_DRQ | BASR_PHASE_MATCH, HZ / 64)) {
+	                              BASR_DRQ | BASR_PHASE_MATCH, 0)) {
 		int bytes;
 
 		if (macintosh_config->ident == MAC_MODEL_IIFX)
@@ -304,7 +304,7 @@ static inline int macscsi_pread(struct NCR5380_hostdata *hostdata,
 
 		if (NCR5380_poll_politely2(hostdata, STATUS_REG, SR_REQ, SR_REQ,
 		                           BUS_AND_STATUS_REG, BASR_ACK,
-		                           BASR_ACK, HZ / 64) < 0)
+		                           BASR_ACK, 0) < 0)
 			scmd_printk(KERN_DEBUG, hostdata->connected,
 			            "%s: !REQ and !ACK\n", __func__);
 		if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_PHASE_MATCH))
@@ -344,7 +344,7 @@ static inline int macscsi_pwrite(struct NCR5380_hostdata *hostdata,
 
 	while (!NCR5380_poll_politely(hostdata, BUS_AND_STATUS_REG,
 	                              BASR_DRQ | BASR_PHASE_MATCH,
-	                              BASR_DRQ | BASR_PHASE_MATCH, HZ / 64)) {
+	                              BASR_DRQ | BASR_PHASE_MATCH, 0)) {
 		int bytes;
 
 		if (macintosh_config->ident == MAC_MODEL_IIFX)
@@ -362,7 +362,7 @@ static inline int macscsi_pwrite(struct NCR5380_hostdata *hostdata,
 			if (NCR5380_poll_politely(hostdata, TARGET_COMMAND_REG,
 			                          TCR_LAST_BYTE_SENT,
 			                          TCR_LAST_BYTE_SENT,
-			                          HZ / 64) < 0) {
+			                          0) < 0) {
 				scmd_printk(KERN_ERR, hostdata->connected,
 				            "%s: Last Byte Sent timeout\n", __func__);
 				result = -1;
@@ -372,7 +372,7 @@ static inline int macscsi_pwrite(struct NCR5380_hostdata *hostdata,
 
 		if (NCR5380_poll_politely2(hostdata, STATUS_REG, SR_REQ, SR_REQ,
 		                           BUS_AND_STATUS_REG, BASR_ACK,
-		                           BASR_ACK, HZ / 64) < 0)
+		                           BASR_ACK, 0) < 0)
 			scmd_printk(KERN_DEBUG, hostdata->connected,
 			            "%s: !REQ and !ACK\n", __func__);
 		if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_PHASE_MATCH))
-- 
2.29.2

