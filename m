From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 10/36] aha1542: Remove WAIT and WAITd macros
Date: Fri,  6 Feb 2015 23:11:31 +0100
Message-ID: <1423260717-15944-11-git-send-email-linux@rainbow-software.org>
References: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56958 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755521AbbBFWPq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2015 17:15:46 -0500
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1YJr8E-0006fF-NL
	for linux-scsi@vger.kernel.org; Fri, 06 Feb 2015 23:12:10 +0100
In-Reply-To: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Convert the ugly WAIT and WAITd macros into wait_mask function.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/aha1542.c |  104 ++++++++++++++++++++++++++----------------------
 1 file changed, 57 insertions(+), 47 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index ebc5476..0e58cef 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -120,39 +120,32 @@ struct aha1542_hostdata {
 
 static DEFINE_SPINLOCK(aha1542_lock);
 
-
-
-#define WAITnexttimeout 3000000
-
 static inline void aha1542_intr_reset(u16 base)
 {
 	outb(IRST, CONTROL(base));
 }
 
-#define WAIT(port, mask, allof, noneof)					\
- { register int WAITbits;						\
-   register int WAITtimeout = WAITnexttimeout;				\
-   while (1) {								\
-     WAITbits = inb(port) & (mask);					\
-     if ((WAITbits & (allof)) == (allof) && ((WAITbits & (noneof)) == 0)) \
-       break;                                                         	\
-     if (--WAITtimeout == 0) goto fail;					\
-   }									\
- }
-
-/* Similar to WAIT, except we use the udelay call to regulate the
-   amount of time we wait.  */
-#define WAITd(port, mask, allof, noneof, timeout)			\
- { register int WAITbits;						\
-   register int WAITtimeout = timeout;					\
-   while (1) {								\
-     WAITbits = inb(port) & (mask);					\
-     if ((WAITbits & (allof)) == (allof) && ((WAITbits & (noneof)) == 0)) \
-       break;                                                         	\
-     mdelay(1);							\
-     if (--WAITtimeout == 0) goto fail;					\
-   }									\
- }
+static inline bool wait_mask(u16 port, u8 mask, u8 allof, u8 noneof, int timeout)
+{
+	bool delayed = true;
+
+	if (timeout == 0) {
+		timeout = 3000000;
+		delayed = false;
+	}
+
+	while (1) {
+		u8 bits = inb(port) & mask;
+		if ((bits & allof) == allof && ((bits & noneof) == 0))
+			break;
+		if (delayed)
+			mdelay(1);
+		if (--timeout == 0)
+			return false;
+	}
+
+	return true;
+}
 
 /* This is a bit complicated, but we need to make sure that an interrupt
    routine does not send something out while we are in the middle of this.
@@ -166,7 +159,8 @@ static int aha1542_out(unsigned int base, u8 *cmdp, int len)
 	if (len == 1) {
 		got_lock = 0;
 		while (1 == 1) {
-			WAIT(STATUS(base), CDF, 0, CDF);
+			if (!wait_mask(STATUS(base), CDF, 0, CDF, 0))
+				goto fail;
 			spin_lock_irqsave(&aha1542_lock, flags);
 			if (inb(STATUS(base)) & CDF) {
 				spin_unlock_irqrestore(&aha1542_lock, flags);
@@ -180,7 +174,8 @@ static int aha1542_out(unsigned int base, u8 *cmdp, int len)
 		spin_lock_irqsave(&aha1542_lock, flags);
 		got_lock = 1;
 		while (len--) {
-			WAIT(STATUS(base), CDF, 0, CDF);
+			if (!wait_mask(STATUS(base), CDF, 0, CDF, 0))
+				goto fail;
 			outb(*cmdp++, DATA(base));
 		}
 		spin_unlock_irqrestore(&aha1542_lock, flags);
@@ -202,7 +197,8 @@ static int aha1542_in(unsigned int base, u8 *cmdp, int len)
 
 	spin_lock_irqsave(&aha1542_lock, flags);
 	while (len--) {
-		WAIT(STATUS(base), DF, DF, 0);
+		if (!wait_mask(STATUS(base), DF, DF, 0, 0))
+			goto fail;
 		*cmdp++ = inb(DATA(base));
 	}
 	spin_unlock_irqrestore(&aha1542_lock, flags);
@@ -222,7 +218,8 @@ static int aha1542_in1(unsigned int base, u8 *cmdp, int len)
 
 	spin_lock_irqsave(&aha1542_lock, flags);
 	while (len--) {
-		WAITd(STATUS(base), DF, DF, 0, 100);
+		if (!wait_mask(STATUS(base), DF, DF, 0, 100))
+			goto fail;
 		*cmdp++ = inb(DATA(base));
 	}
 	spin_unlock_irqrestore(&aha1542_lock, flags);
@@ -313,7 +310,8 @@ static int aha1542_test_port(int bse, struct Scsi_Host *shpnt)
 
 	debug = 1;
 	/* Expect INIT and IDLE, any of the others are bad */
-	WAIT(STATUS(bse), STATMASK, INIT | IDLE, STST | DIAGF | INVDCMD | DF | CDF);
+	if (!wait_mask(STATUS(bse), STATMASK, INIT | IDLE, STST | DIAGF | INVDCMD | DF | CDF, 0))
+		goto fail;
 
 	debug = 2;
 	/* Shouldn't have generated any interrupts during reset */
@@ -331,7 +329,8 @@ static int aha1542_test_port(int bse, struct Scsi_Host *shpnt)
 	cmdp = &inquiry_result[0];
 
 	while (len--) {
-		WAIT(STATUS(bse), DF, DF, 0);
+		if (!wait_mask(STATUS(bse), DF, DF, 0, 0))
+			goto fail;
 		*cmdp++ = inb(DATA(bse));
 	}
 
@@ -342,7 +341,8 @@ static int aha1542_test_port(int bse, struct Scsi_Host *shpnt)
 
 	debug = 9;
 	/* When HACC, command is completed, and we're though testing */
-	WAIT(INTRFLAGS(bse), HACC, HACC, 0);
+	if (!wait_mask(INTRFLAGS(bse), HACC, HACC, 0, 0))
+		goto fail;
 	/* now initialize adapter */
 
 	debug = 10;
@@ -711,7 +711,8 @@ static void setup_mailboxes(int bse, struct Scsi_Host *shpnt)
 	aha1542_intr_reset(bse);	/* reset interrupts, so they don't block */
 	any2scsi((cmd + 2), isa_virt_to_bus(mb));
 	aha1542_out(bse, cmd, 5);
-	WAIT(INTRFLAGS(bse), INTRMASK, HACC, 0);
+	if (!wait_mask(INTRFLAGS(bse), INTRMASK, HACC, 0, 0))
+		goto fail;
 	while (0) {
 fail:
 		printk(KERN_ERR "aha1542_detect: failed setting up mailboxes\n");
@@ -730,7 +731,8 @@ static int aha1542_getconfig(int base_io, unsigned char *irq_level, unsigned cha
 	};
 	aha1542_out(base_io, inquiry_cmd, 1);
 	aha1542_in(base_io, inquiry_result, 3);
-	WAIT(INTRFLAGS(base_io), INTRMASK, HACC, 0);
+	if (!wait_mask(INTRFLAGS(base_io), INTRMASK, HACC, 0, 0))
+		goto fail;
 	while (0) {
 fail:
 		printk(KERN_ERR "aha1542_detect: query board settings\n");
@@ -800,7 +802,8 @@ static int aha1542_mbenable(int base)
 	aha1542_out(base, mbenable_cmd, 1);
 	if (aha1542_in1(base, mbenable_result, 2))
 		return retval;
-	WAITd(INTRFLAGS(base), INTRMASK, HACC, 0, 100);
+	if (!wait_mask(INTRFLAGS(base), INTRMASK, HACC, 0, 100))
+		goto fail;
 	aha1542_intr_reset(base);
 
 	if ((mbenable_result[0] & 0x08) || mbenable_result[1]) {
@@ -812,7 +815,8 @@ static int aha1542_mbenable(int base)
 			retval = BIOS_TRANSLATION_25563;
 
 		aha1542_out(base, mbenable_cmd, 3);
-		WAIT(INTRFLAGS(base), INTRMASK, HACC, 0);
+		if (!wait_mask(INTRFLAGS(base), INTRMASK, HACC, 0, 0))
+			goto fail;
 	};
 	while (0) {
 fail:
@@ -834,7 +838,8 @@ static int aha1542_query(int base_io, int *transl)
 	};
 	aha1542_out(base_io, inquiry_cmd, 1);
 	aha1542_in(base_io, inquiry_result, 4);
-	WAIT(INTRFLAGS(base_io), INTRMASK, HACC, 0);
+	if (!wait_mask(INTRFLAGS(base_io), INTRMASK, HACC, 0, 0))
+		goto fail;
 	while (0) {
 fail:
 		printk(KERN_ERR "aha1542_detect: query card type\n");
@@ -978,16 +983,19 @@ static struct Scsi_Host *aha1542_hw_init(struct scsi_host_template *tpnt, struct
 				}
 				aha1542_intr_reset(base_io);
 				aha1542_out(base_io, oncmd, 2);
-				WAIT(INTRFLAGS(base_io), INTRMASK, HACC, 0);
+				if (!wait_mask(INTRFLAGS(base_io), INTRMASK, HACC, 0, 0))
+					goto fail;
 				aha1542_intr_reset(base_io);
 				aha1542_out(base_io, offcmd, 2);
-				WAIT(INTRFLAGS(base_io), INTRMASK, HACC, 0);
+				if (!wait_mask(INTRFLAGS(base_io), INTRMASK, HACC, 0, 0))
+					goto fail;
 				if (setup_dmaspeed[indx] >= 0) {
 					u8 dmacmd[] = {CMD_DMASPEED, 0};
 					dmacmd[1] = setup_dmaspeed[indx];
 					aha1542_intr_reset(base_io);
 					aha1542_out(base_io, dmacmd, 2);
-					WAIT(INTRFLAGS(base_io), INTRMASK, HACC, 0);
+					if (!wait_mask(INTRFLAGS(base_io), INTRMASK, HACC, 0, 0))
+						goto fail;
 				}
 				while (0) {
 fail:
@@ -1162,8 +1170,9 @@ static int aha1542_bus_reset(Scsi_Cmnd * SCpnt)
 
 	spin_lock_irq(SCpnt->device->host->host_lock);
 
-	WAIT(STATUS(SCpnt->device->host->io_port),
-	     STATMASK, INIT | IDLE, STST | DIAGF | INVDCMD | DF | CDF);
+	if (!wait_mask(STATUS(SCpnt->device->host->io_port),
+	     STATMASK, INIT | IDLE, STST | DIAGF | INVDCMD | DF | CDF, 0))
+		goto fail;
 
 	/*
 	 * Now try to pick up the pieces.  For all pending commands,
@@ -1226,8 +1235,9 @@ static int aha1542_host_reset(Scsi_Cmnd * SCpnt)
 	ssleep(4);
 	spin_lock_irq(SCpnt->device->host->host_lock);
 
-	WAIT(STATUS(SCpnt->device->host->io_port),
-	     STATMASK, INIT | IDLE, STST | DIAGF | INVDCMD | DF | CDF);
+	if (!wait_mask(STATUS(SCpnt->device->host->io_port),
+	     STATMASK, INIT | IDLE, STST | DIAGF | INVDCMD | DF | CDF, 0))
+		goto fail;
 
 	/*
 	 * We need to do this too before the 1542 can interact with
-- 
Ondrej Zary

