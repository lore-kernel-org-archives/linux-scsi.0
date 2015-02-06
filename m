From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 06/36] aha1542: Use u8 instead of unchar
Date: Fri,  6 Feb 2015 23:11:27 +0100
Message-ID: <1423260717-15944-7-git-send-email-linux@rainbow-software.org>
References: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56935 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756868AbbBFWMM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2015 17:12:12 -0500
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1YJr8E-0006fF-2M
	for linux-scsi@vger.kernel.org; Fri, 06 Feb 2015 23:12:10 +0100
In-Reply-To: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/aha1542.c |   50 ++++++++++++++++++++++++------------------------
 drivers/scsi/aha1542.h |   42 ++++++++++++++++++++--------------------
 2 files changed, 46 insertions(+), 46 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 2a6308f..8851719 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -168,7 +168,7 @@ static void aha1542_stat(void)
    routine does not send something out while we are in the middle of this.
    Fortunately, it is only at boot time that multi-byte messages
    are ever sent. */
-static int aha1542_out(unsigned int base, unchar * cmdp, int len)
+static int aha1542_out(unsigned int base, u8 *cmdp, int len)
 {
 	unsigned long flags = 0;
 	int got_lock;
@@ -207,7 +207,7 @@ fail:
 /* Only used at boot time, so we do not need to worry about latency as much
    here */
 
-static int aha1542_in(unsigned int base, unchar *cmdp, int len)
+static int aha1542_in(unsigned int base, u8 *cmdp, int len)
 {
 	unsigned long flags;
 
@@ -228,7 +228,7 @@ fail:
 /* Similar to aha1542_in, except that we wait a very short period of time.
    We use this if we know the board is alive and awake, but we are not sure
    if the board will respond to the command we are about to send or not */
-static int aha1542_in1(unsigned int base, unchar *cmdp, int len)
+static int aha1542_in1(unsigned int base, u8 *cmdp, int len)
 {
 	unsigned long flags;
 
@@ -302,9 +302,9 @@ static int makecode(unsigned hosterr, unsigned scsierr)
 
 static int aha1542_test_port(int bse, struct Scsi_Host *shpnt)
 {
-	unchar inquiry_cmd[] = {CMD_INQUIRY};
-	unchar inquiry_result[4];
-	unchar *cmdp;
+	u8 inquiry_cmd[] = {CMD_INQUIRY};
+	u8 inquiry_result[4];
+	u8 *cmdp;
 	int len;
 	volatile int debug = 0;
 
@@ -542,11 +542,11 @@ static void aha1542_intr_handle(struct Scsi_Host *shost)
 static int aha1542_queuecommand_lck(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 {
 	struct aha1542_hostdata *aha1542 = shost_priv(SCpnt->device->host);
-	unchar ahacmd = CMD_START_SCSI;
-	unchar direction;
-	unchar *cmd = (unchar *) SCpnt->cmnd;
-	unchar target = SCpnt->device->id;
-	unchar lun = SCpnt->device->lun;
+	u8 ahacmd = CMD_START_SCSI;
+	u8 direction;
+	u8 *cmd = (u8 *) SCpnt->cmnd;
+	u8 target = SCpnt->device->id;
+	u8 lun = SCpnt->device->lun;
 	unsigned long flags;
 	int bufflen = scsi_bufflen(SCpnt);
 	int mbo;
@@ -674,7 +674,7 @@ static int aha1542_queuecommand_lck(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *
 		int i;
 		printk(KERN_DEBUG "aha1542_command: sending.. ");
 		for (i = 0; i < sizeof(ccb[mbo]) - 10; i++)
-			printk("%02x ", ((unchar *) & ccb[mbo])[i]);
+			printk("%02x ", ((u8 *) &ccb[mbo])[i]);
 	};
 #endif
 
@@ -701,7 +701,7 @@ static void setup_mailboxes(int bse, struct Scsi_Host *shpnt)
 	struct mailbox *mb = aha1542->mb;
 	struct ccb *ccb = aha1542->ccb;
 
-	unchar cmd[5] = { CMD_MBINIT, AHA1542_MAILBOXES, 0, 0, 0};
+	u8 cmd[5] = { CMD_MBINIT, AHA1542_MAILBOXES, 0, 0, 0};
 
 	for (i = 0; i < AHA1542_MAILBOXES; i++) {
 		mb[i].status = mb[AHA1542_MAILBOXES + i].status = 0;
@@ -720,8 +720,8 @@ fail:
 
 static int aha1542_getconfig(int base_io, unsigned char *irq_level, unsigned char *dma_chan, unsigned char *scsi_id)
 {
-	unchar inquiry_cmd[] = {CMD_RETCONF};
-	unchar inquiry_result[3];
+	u8 inquiry_cmd[] = {CMD_RETCONF};
+	u8 inquiry_result[3];
 	int i;
 	i = inb(STATUS(base_io));
 	if (i & DF) {
@@ -789,8 +789,8 @@ fail:
 
 static int aha1542_mbenable(int base)
 {
-	static unchar mbenable_cmd[3];
-	static unchar mbenable_result[2];
+	static u8 mbenable_cmd[3];
+	static u8 mbenable_result[2];
 	int retval;
 
 	retval = BIOS_TRANSLATION_6432;
@@ -824,8 +824,8 @@ fail:
 /* Query the board to find out if it is a 1542 or a 1740, or whatever. */
 static int aha1542_query(int base_io, int *transl)
 {
-	unchar inquiry_cmd[] = {CMD_INQUIRY};
-	unchar inquiry_result[4];
+	u8 inquiry_cmd[] = {CMD_INQUIRY};
+	u8 inquiry_result[4];
 	int i;
 	i = inb(STATUS(base_io));
 	if (i & DF) {
@@ -968,8 +968,8 @@ static struct Scsi_Host *aha1542_hw_init(struct scsi_host_template *tpnt, struct
 
 			/* Set the Bus on/off-times as not to ruin floppy performance */
 			{
-				unchar oncmd[] = {CMD_BUSON_TIME, 7};
-				unchar offcmd[] = {CMD_BUSOFF_TIME, 5};
+				u8 oncmd[] = {CMD_BUSON_TIME, 7};
+				u8 offcmd[] = {CMD_BUSOFF_TIME, 5};
 
 				if (setup_called[indx]) {
 					oncmd[1] = setup_buson[indx];
@@ -982,7 +982,7 @@ static struct Scsi_Host *aha1542_hw_init(struct scsi_host_template *tpnt, struct
 				aha1542_out(base_io, offcmd, 2);
 				WAIT(INTRFLAGS(base_io), INTRMASK, HACC, 0);
 				if (setup_dmaspeed[indx] >= 0) {
-					unchar dmacmd[] = {CMD_DMASPEED, 0};
+					u8 dmacmd[] = {CMD_DMASPEED, 0};
 					dmacmd[1] = setup_dmaspeed[indx];
 					aha1542_intr_reset(base_io);
 					aha1542_out(base_io, dmacmd, 2);
@@ -1103,11 +1103,11 @@ static int aha1542_dev_reset(Scsi_Cmnd * SCpnt)
 	struct aha1542_hostdata *aha1542 = shost_priv(SCpnt->device->host);
 	unsigned long flags;
 	struct mailbox *mb = aha1542->mb;
-	unchar target = SCpnt->device->id;
-	unchar lun = SCpnt->device->lun;
+	u8 target = SCpnt->device->id;
+	u8 lun = SCpnt->device->lun;
 	int mbo;
 	struct ccb *ccb = aha1542->ccb;
-	unchar ahacmd = CMD_START_SCSI;
+	u8 ahacmd = CMD_START_SCSI;
 
 	spin_lock_irqsave(&aha1542_lock, flags);
 	mbo = aha1542->aha1542_last_mbo_used + 1;
diff --git a/drivers/scsi/aha1542.h b/drivers/scsi/aha1542.h
index 812a406..6b418bb 100644
--- a/drivers/scsi/aha1542.h
+++ b/drivers/scsi/aha1542.h
@@ -80,14 +80,14 @@
 
 /* Mailbox Definition 5.2.1 and 5.2.2 */
 struct mailbox {
-  unchar status;		/* Command/Status */
-  unchar ccbptr[3];		/* msb, .., lsb */
+	u8 status;	/* Command/Status */
+	u8 ccbptr[3];	/* msb, .., lsb */
 };
 
 /* This is used with scatter-gather */
 struct chain {
-  unchar datalen[3];		/* Size of this part of chain */
-  unchar dataptr[3];		/* Location of data */
+	u8 datalen[3];	/* Size of this part of chain */
+	u8 dataptr[3];	/* Location of data */
 };
 
 /* These belong in scsi.h also */
@@ -106,23 +106,23 @@ static inline void any2scsi(u8 *p, u32 v)
 #define MAX_CDB 12
 #define MAX_SENSE 14
 
-struct ccb {			/* Command Control Block 5.3 */
-  unchar op;			/* Command Control Block Operation Code */
-  unchar idlun;			/* op=0,2:Target Id, op=1:Initiator Id */
-				/* Outbound data transfer, length is checked*/
-				/* Inbound data transfer, length is checked */
-				/* Logical Unit Number */
-  unchar cdblen;		/* SCSI Command Length */
-  unchar rsalen;		/* Request Sense Allocation Length/Disable */
-  unchar datalen[3];		/* Data Length (msb, .., lsb) */
-  unchar dataptr[3];		/* Data Pointer */
-  unchar linkptr[3];		/* Link Pointer */
-  unchar commlinkid;		/* Command Linking Identifier */
-  unchar hastat;		/* Host Adapter Status (HASTAT) */
-  unchar tarstat;		/* Target Device Status */
-  unchar reserved[2];
-  unchar cdb[MAX_CDB+MAX_SENSE];/* SCSI Command Descriptor Block */
-				/* REQUEST SENSE */
+struct ccb {		/* Command Control Block 5.3 */
+	u8 op;		/* Command Control Block Operation Code */
+	u8 idlun;	/* op=0,2:Target Id, op=1:Initiator Id */
+			/* Outbound data transfer, length is checked*/
+			/* Inbound data transfer, length is checked */
+			/* Logical Unit Number */
+	u8 cdblen;	/* SCSI Command Length */
+	u8 rsalen;	/* Request Sense Allocation Length/Disable */
+	u8 datalen[3];	/* Data Length (msb, .., lsb) */
+	u8 dataptr[3];	/* Data Pointer */
+	u8 linkptr[3];	/* Link Pointer */
+	u8 commlinkid;	/* Command Linking Identifier */
+	u8 hastat;	/* Host Adapter Status (HASTAT) */
+	u8 tarstat;	/* Target Device Status */
+	u8 reserved[2];
+	u8 cdb[MAX_CDB+MAX_SENSE];	/* SCSI Command Descriptor Block */
+					/* REQUEST SENSE */
 };
 
 static struct Scsi_Host *aha1542_hw_init(struct scsi_host_template *tpnt, struct device *pdev, int indx);
-- 
Ondrej Zary

