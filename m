From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 14/36] aha1542: remove useless code from aha1542_test_port
Date: Fri,  6 Feb 2015 23:11:35 +0100
Message-ID: <1423260717-15944-15-git-send-email-linux@rainbow-software.org>
References: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56954 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758037AbbBFWPj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2015 17:15:39 -0500
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1YJr8F-0006fF-ED
	for linux-scsi@vger.kernel.org; Fri, 06 Feb 2015 23:12:11 +0100
In-Reply-To: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/aha1542.c |   15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index af2c69e..29ddcc9 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -271,7 +271,6 @@ static int aha1542_test_port(int bse, struct Scsi_Host *shpnt)
 	u8 inquiry_result[4];
 	u8 *cmdp;
 	int len;
-	volatile int debug = 0;
 
 	/* Quick and dirty test for presence of the card. */
 	if (inb(STATUS(bse)) == 0xff)
@@ -279,8 +278,6 @@ static int aha1542_test_port(int bse, struct Scsi_Host *shpnt)
 
 	/* Reset the adapter. I ought to make a hard reset, but it's not really necessary */
 
-	/*  DEB(printk("aha1542_test_port called \n")); */
-
 	/* In case some other card was probing here, reset interrupts */
 	aha1542_intr_reset(bse);	/* reset interrupts, so they don't block */
 
@@ -288,23 +285,19 @@ static int aha1542_test_port(int bse, struct Scsi_Host *shpnt)
 
 	mdelay(20);		/* Wait a little bit for things to settle down. */
 
-	debug = 1;
 	/* Expect INIT and IDLE, any of the others are bad */
 	if (!wait_mask(STATUS(bse), STATMASK, INIT | IDLE, STST | DIAGF | INVDCMD | DF | CDF, 0))
 		return 0;
 
-	debug = 2;
 	/* Shouldn't have generated any interrupts during reset */
 	if (inb(INTRFLAGS(bse)) & INTRMASK)
 		return 0;
 
-
 	/* Perform a host adapter inquiry instead so we do not need to set
 	   up the mailboxes ahead of time */
 
 	aha1542_outb(bse, CMD_INQUIRY);
 
-	debug = 3;
 	len = 4;
 	cmdp = &inquiry_result[0];
 
@@ -314,24 +307,18 @@ static int aha1542_test_port(int bse, struct Scsi_Host *shpnt)
 		*cmdp++ = inb(DATA(bse));
 	}
 
-	debug = 8;
 	/* Reading port should reset DF */
 	if (inb(STATUS(bse)) & DF)
 		return 0;
 
-	debug = 9;
 	/* When HACC, command is completed, and we're though testing */
 	if (!wait_mask(INTRFLAGS(bse), HACC, HACC, 0, 0))
 		return 0;
-	/* now initialize adapter */
 
-	debug = 10;
 	/* Clear interrupts */
 	outb(IRST, CONTROL(bse));
 
-	debug = 11;
-
-	return debug;		/* 1 = ok */
+	return 1;
 }
 
 static int aha1542_restart(struct Scsi_Host *shost)
-- 
Ondrej Zary

