From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 09/13] aha1542: Use BIT() macro
Date: Mon, 19 Jan 2015 23:37:53 +0100
Message-ID: <1421707077-25291-10-git-send-email-linux@rainbow-software.org>
References: <1421707077-25291-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:44256 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752025AbbASWiL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2015 17:38:11 -0500
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1YDKxV-0006A4-Nv
	for linux-scsi@vger.kernel.org; Mon, 19 Jan 2015 23:38:09 +0100
In-Reply-To: <1421707077-25291-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/aha1542.h |   37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/aha1542.h b/drivers/scsi/aha1542.h
index f0b862b..1333a23 100644
--- a/drivers/scsi/aha1542.h
+++ b/drivers/scsi/aha1542.h
@@ -36,29 +36,30 @@
 /* I/O Port interface 4.2 */
 /* READ */
 #define STATUS(base) base
-#define STST	0x80		/* Self Test in Progress */
-#define DIAGF	0x40		/* Internal Diagnostic Failure */
-#define INIT	0x20		/* Mailbox Initialization Required */
-#define IDLE	0x10		/* SCSI Host Adapter Idle */
-#define CDF	0x08		/* Command/Data Out Port Full */
-#define DF	0x04		/* Data In Port Full */
-#define INVDCMD	0x01		/* Invalid H A Command */
-#define STATMASK 0xfd		/* 0x02 is reserved */
+#define STST	BIT(7)		/* Self Test in Progress */
+#define DIAGF	BIT(6)		/* Internal Diagnostic Failure */
+#define INIT	BIT(5)		/* Mailbox Initialization Required */
+#define IDLE	BIT(4)		/* SCSI Host Adapter Idle */
+#define CDF	BIT(3)		/* Command/Data Out Port Full */
+#define DF	BIT(2)		/* Data In Port Full */
+/* BIT(1) is reserved */
+#define INVDCMD	BIT(0)		/* Invalid H A Command */
+#define STATMASK (STST | DIAGF | INIT | IDLE | CDF | DF | INVDCMD)
 
 #define INTRFLAGS(base) (STATUS(base)+2)
-#define ANYINTR	0x80		/* Any Interrupt */
-#define SCRD	0x08		/* SCSI Reset Detected */
-#define HACC	0x04		/* HA Command Complete */
-#define MBOA	0x02		/* MBO Empty */
-#define MBIF	0x01		/* MBI Full */
-#define INTRMASK 0x8f
+#define ANYINTR	BIT(7)		/* Any Interrupt */
+#define SCRD	BIT(3)		/* SCSI Reset Detected */
+#define HACC	BIT(2)		/* HA Command Complete */
+#define MBOA	BIT(1)		/* MBO Empty */
+#define MBIF	BIT(0)		/* MBI Full */
+#define INTRMASK (ANYINTR | SCRD | HACC | MBOA | MBIF)
 
 /* WRITE */
 #define CONTROL(base) STATUS(base)
-#define HRST	0x80		/* Hard Reset */
-#define SRST	0x40		/* Soft Reset */
-#define IRST	0x20		/* Interrupt Reset */
-#define SCRST	0x10		/* SCSI Bus Reset */
+#define HRST	BIT(7)		/* Hard Reset */
+#define SRST	BIT(6)		/* Soft Reset */
+#define IRST	BIT(5)		/* Interrupt Reset */
+#define SCRST	BIT(4)		/* SCSI Bus Reset */
 
 /* READ/WRITE */
 #define DATA(base) (STATUS(base)+1)
-- 
Ondrej Zary

