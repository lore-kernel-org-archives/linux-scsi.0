From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 12/13] aha1542: Split aha1542_out
Date: Mon, 19 Jan 2015 23:37:56 +0100
Message-ID: <1421707077-25291-13-git-send-email-linux@rainbow-software.org>
References: <1421707077-25291-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:44280 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623AbbASWnf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2015 17:43:35 -0500
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1YDKxW-0006A4-7f
	for linux-scsi@vger.kernel.org; Mon, 19 Jan 2015 23:38:10 +0100
In-Reply-To: <1421707077-25291-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

aha1542_out are in fact two separate functions.
Split them into aha1542_out and aha1542_outb to simplify the code.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/aha1542.c |   75 ++++++++++++++++++++++--------------------------
 1 file changed, 35 insertions(+), 40 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index b4ada24..7bf4604 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -151,41 +151,42 @@ static inline bool wait_mask(u16 port, u8 mask, u8 allof, u8 noneof, int timeout
    routine does not send something out while we are in the middle of this.
    Fortunately, it is only at boot time that multi-byte messages
    are ever sent. */
-static int aha1542_out(unsigned int base, u8 *cmdp, int len)
+static int aha1542_outb(unsigned int base, u8 cmd)
 {
-	unsigned long flags = 0;
-	int got_lock;
-
-	if (len == 1) {
-		got_lock = 0;
-		while (1 == 1) {
-			if (!wait_mask(STATUS(base), CDF, 0, CDF, 0))
-				goto fail;
-			spin_lock_irqsave(&aha1542_lock, flags);
-			if (inb(STATUS(base)) & CDF) {
-				spin_unlock_irqrestore(&aha1542_lock, flags);
-				continue;
-			}
-			outb(*cmdp, DATA(base));
-			spin_unlock_irqrestore(&aha1542_lock, flags);
-			return 0;
+	unsigned long flags;
+
+	while (1) {
+		if (!wait_mask(STATUS(base), CDF, 0, CDF, 0)) {
+			printk(KERN_ERR "aha1542_outb failed");
+			return 1;
 		}
-	} else {
 		spin_lock_irqsave(&aha1542_lock, flags);
-		got_lock = 1;
-		while (len--) {
-			if (!wait_mask(STATUS(base), CDF, 0, CDF, 0))
-				goto fail;
-			outb(*cmdp++, DATA(base));
+		if (inb(STATUS(base)) & CDF) {
+			spin_unlock_irqrestore(&aha1542_lock, flags);
+			continue;
 		}
+		outb(cmd, DATA(base));
 		spin_unlock_irqrestore(&aha1542_lock, flags);
+		return 0;
 	}
+}
+
+static int aha1542_out(unsigned int base, u8 *cmdp, int len)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&aha1542_lock, flags);
+	while (len--) {
+		if (!wait_mask(STATUS(base), CDF, 0, CDF, 0)) {
+			spin_unlock_irqrestore(&aha1542_lock, flags);
+			printk(KERN_ERR "aha1542_out failed(%d): ", len + 1);
+			return 1;
+		}
+		outb(*cmdp++, DATA(base));
+	}
+	spin_unlock_irqrestore(&aha1542_lock, flags);
+
 	return 0;
-fail:
-	if (got_lock)
-		spin_unlock_irqrestore(&aha1542_lock, flags);
-	printk(KERN_ERR "aha1542_out failed(%d): ", len + 1);
-	return 1;
 }
 
 /* Only used at boot time, so we do not need to worry about latency as much
@@ -268,7 +269,6 @@ static int makecode(unsigned hosterr, unsigned scsierr)
 
 static int aha1542_test_port(int bse, struct Scsi_Host *shpnt)
 {
-	u8 inquiry_cmd[] = {CMD_INQUIRY};
 	u8 inquiry_result[4];
 	u8 *cmdp;
 	int len;
@@ -303,7 +303,7 @@ static int aha1542_test_port(int bse, struct Scsi_Host *shpnt)
 	/* Perform a host adapter inquiry instead so we do not need to set
 	   up the mailboxes ahead of time */
 
-	aha1542_out(bse, inquiry_cmd, 1);
+	aha1542_outb(bse, CMD_INQUIRY);
 
 	debug = 3;
 	len = 4;
@@ -527,7 +527,6 @@ static irqreturn_t do_aha1542_intr_handle(int dummy, void *dev_id)
 static int aha1542_queuecommand_lck(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 {
 	struct aha1542_hostdata *aha1542 = shost_priv(SCpnt->device->host);
-	u8 ahacmd = CMD_START_SCSI;
 	u8 direction;
 	u8 *cmd = (u8 *) SCpnt->cmnd;
 	u8 target = SCpnt->device->id;
@@ -666,7 +665,7 @@ static int aha1542_queuecommand_lck(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *
 		DEB(printk("aha1542_queuecommand: now waiting for interrupt "));
 		SCpnt->scsi_done = done;
 		mb[mbo].status = 1;
-		aha1542_out(SCpnt->device->host->io_port, &ahacmd, 1);	/* start scsi command */
+		aha1542_outb(SCpnt->device->host->io_port, CMD_START_SCSI);
 	} else
 		printk("aha1542_queuecommand: done can't be NULL\n");
 
@@ -703,14 +702,13 @@ fail:
 
 static int aha1542_getconfig(int base_io, unsigned char *irq_level, unsigned char *dma_chan, unsigned char *scsi_id)
 {
-	u8 inquiry_cmd[] = {CMD_RETCONF};
 	u8 inquiry_result[3];
 	int i;
 	i = inb(STATUS(base_io));
 	if (i & DF) {
 		i = inb(DATA(base_io));
 	};
-	aha1542_out(base_io, inquiry_cmd, 1);
+	aha1542_outb(base_io, CMD_RETCONF);
 	aha1542_in(base_io, inquiry_result, 3, 0);
 	if (!wait_mask(INTRFLAGS(base_io), INTRMASK, HACC, 0, 0))
 		goto fail;
@@ -779,8 +777,7 @@ static int aha1542_mbenable(int base)
 
 	retval = BIOS_TRANSLATION_6432;
 
-	mbenable_cmd[0] = CMD_EXTBIOS;
-	aha1542_out(base, mbenable_cmd, 1);
+	aha1542_outb(base, CMD_EXTBIOS);
 	if (aha1542_in(base, mbenable_result, 2, 100))
 		return retval;
 	if (!wait_mask(INTRFLAGS(base), INTRMASK, HACC, 0, 100))
@@ -810,14 +807,13 @@ fail:
 /* Query the board to find out if it is a 1542 or a 1740, or whatever. */
 static int aha1542_query(int base_io, int *transl)
 {
-	u8 inquiry_cmd[] = {CMD_INQUIRY};
 	u8 inquiry_result[4];
 	int i;
 	i = inb(STATUS(base_io));
 	if (i & DF) {
 		i = inb(DATA(base_io));
 	};
-	aha1542_out(base_io, inquiry_cmd, 1);
+	aha1542_outb(base_io, CMD_INQUIRY);
 	aha1542_in(base_io, inquiry_result, 4, 0);
 	if (!wait_mask(INTRFLAGS(base_io), INTRMASK, HACC, 0, 0))
 		goto fail;
@@ -1079,7 +1075,6 @@ static int aha1542_dev_reset(Scsi_Cmnd * SCpnt)
 	u8 lun = SCpnt->device->lun;
 	int mbo;
 	struct ccb *ccb = aha1542->ccb;
-	u8 ahacmd = CMD_START_SCSI;
 
 	spin_lock_irqsave(&aha1542_lock, flags);
 	mbo = aha1542->aha1542_last_mbo_used + 1;
@@ -1119,7 +1114,7 @@ static int aha1542_dev_reset(Scsi_Cmnd * SCpnt)
 	 * Now tell the 1542 to flush all pending commands for this 
 	 * target 
 	 */
-	aha1542_out(SCpnt->device->host->io_port, &ahacmd, 1);
+	aha1542_outb(SCpnt->device->host->io_port, CMD_START_SCSI);
 
 	scmd_printk(KERN_WARNING, SCpnt,
 		"Trying device reset for target\n");
-- 
Ondrej Zary

