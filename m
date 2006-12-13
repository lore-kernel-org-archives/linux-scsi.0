From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] seagate: remove BROKEN tag
Date: Wed, 13 Dec 2006 09:19:49 -0600
Message-ID: <1166023189.2790.11.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:44924 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964993AbWLMPTv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Dec 2006 10:19:51 -0500
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id kBDFJox00649
	for <linux-scsi@vger.kernel.org>; Wed, 13 Dec 2006 10:19:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Apparently the driver compiles and runs, so tidy up some macro warnings
and bring it back as unBROKEN.

James

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 60f5827..adf1639 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1303,7 +1303,7 @@ config SCSI_LPFC
 
 config SCSI_SEAGATE
 	tristate "Seagate ST-02 and Future Domain TMC-8xx SCSI support"
-	depends on X86 && ISA && SCSI && BROKEN
+	depends on X86 && ISA && SCSI 
 	---help---
 	  These are 8-bit SCSI controllers; the ST-01 is also supported by
 	  this driver.  It is explained in section 3.9 of the SCSI-HOWTO,
diff --git a/drivers/scsi/seagate.c b/drivers/scsi/seagate.c
index 5ffec27..ff62e97 100644
--- a/drivers/scsi/seagate.c
+++ b/drivers/scsi/seagate.c
@@ -114,6 +114,7 @@
 #define DPRINTK( when, msg... ) do { if ( (DEBUG & (when)) == (when) ) printk( msg ); } while (0)
 #else
 #define DPRINTK( when, msg... ) do { } while (0)
+#define DEBUG 0
 #endif
 #define DANY( msg... ) DPRINTK( 0xffff, msg );
 
@@ -523,7 +524,7 @@ int __init seagate_st0x_detect (struct s
 #ifdef ARBITRATE
 		" ARBITRATE"
 #endif
-#ifdef DEBUG
+#if DEBUG
 		" DEBUG"
 #endif
 #ifdef FAST
@@ -733,7 +734,7 @@ static int internal_command (unsigned ch
 	unsigned char *data = NULL;
 	struct scatterlist *buffer = NULL;
 	int clock, temp, nobuffs = 0, done = 0, len = 0;
-#ifdef DEBUG
+#if DEBUG
 	int transfered = 0, phase = 0, newphase;
 #endif
 	register unsigned char status_read;


