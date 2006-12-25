From: tsbogend@alpha.franken.de (Thomas Bogendoerfer)
Subject: PATCH: Allow setting burst length for 53C700
Date: Mon, 25 Dec 2006 21:30:08 +0100
Message-ID: <20061225203008.GA3293@alpha.franken.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from elvis.franken.de ([193.175.24.41]:32799 "EHLO elvis.franken.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754409AbWLYV7y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Dec 2006 16:59:54 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

This is a patch, which allows not only disabling bursting but to specify
different burst lenghts. This feature is needed to get the 53c700 driver
working for the onboard SCSI controller of SNI RM machines, which only
work reliable with a 4 word burst length.

Thomas.

>From eb46a70296fd0615ac7d8ee036d0554e8d30c1f2 Mon Sep 17 00:00:00 2001
From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Date: Mon, 25 Dec 2006 20:48:34 +0100
Subject: [PATCH] change burst_disable to burst_length to allow setting of different burst
lengths
---
 drivers/scsi/53c700.c  |   24 +++++++++++++++++++++---
 drivers/scsi/53c700.h  |    2 +-
 drivers/scsi/lasi700.c |    1 +
 drivers/scsi/sim710.c  |    1 +
 4 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index 68103e5..92030fa 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -667,12 +667,30 @@ NCR_700_chip_setup(struct Scsi_Host *hos
 	__u8 min_xferp = (hostdata->chip710 ? NCR_710_MIN_XFERP : NCR_700_MIN_XFERP);
 
 	if(hostdata->chip710) {
-		__u8 burst_disable = hostdata->burst_disable
-			? BURST_DISABLE : 0;
+		__u8 burst_disable = 0;
+		__u8 burst_length = 0;
+		
+		switch (hostdata->burst_length) {
+			case 1:
+			        burst_length = BURST_LENGTH_1;
+			        break;
+			case 2:
+			        burst_length = BURST_LENGTH_2;
+			        break;
+			case 4:
+			        burst_length = BURST_LENGTH_4;
+			        break;
+			case 8:
+			        burst_length = BURST_LENGTH_8;
+			        break;
+			default:
+			        burst_disable = BURST_DISABLE;
+			        break;
+		}
 		dcntl_extra = COMPAT_700_MODE;
 
 		NCR_700_writeb(dcntl_extra, host, DCNTL_REG);
-		NCR_700_writeb(BURST_LENGTH_8  | hostdata->dmode_extra,
+		NCR_700_writeb(burst_length | hostdata->dmode_extra,
 			       host, DMODE_710_REG);
 		NCR_700_writeb(burst_disable | (hostdata->differential ? 
 						DIFF : 0), host, CTEST7_REG);
diff --git a/drivers/scsi/53c700.h b/drivers/scsi/53c700.h
index f38822d..0292410 100644
--- a/drivers/scsi/53c700.h
+++ b/drivers/scsi/53c700.h
@@ -203,7 +203,7 @@ #ifdef CONFIG_53C700_LE_ON_BE
 	__u32	force_le_on_be:1;
 #endif
 	__u32	chip710:1;	/* set if really a 710 not 700 */
-	__u32	burst_disable:1;	/* set to 1 to disable 710 bursting */
+	__u32	burst_length:4;	/* set to 0 to disable 710 bursting */
 
 	/* NOTHING BELOW HERE NEEDS ALTERING */
 	__u32	fast:1;		/* if we can alter the SCSI bus clock
diff --git a/drivers/scsi/lasi700.c b/drivers/scsi/lasi700.c
index f0871c3..2aae1b0 100644
--- a/drivers/scsi/lasi700.c
+++ b/drivers/scsi/lasi700.c
@@ -123,6 +123,7 @@ lasi700_probe(struct parisc_device *dev)
 		hostdata->force_le_on_be = 0;
 		hostdata->chip710 = 1;
 		hostdata->dmode_extra = DMODE_FC2;
+		hostdata->burst_length = 8;
 	}
 
 	host = NCR_700_detect(&lasi700_template, hostdata, &dev->dev);
diff --git a/drivers/scsi/sim710.c b/drivers/scsi/sim710.c
index 551bacc..018c65f 100644
--- a/drivers/scsi/sim710.c
+++ b/drivers/scsi/sim710.c
@@ -123,6 +123,7 @@ sim710_probe_common(struct device *dev,
 	hostdata->differential = differential;
 	hostdata->clock = clock;
 	hostdata->chip710 = 1;
+	hostdata->burst_length = 8;
 
 	/* and register the chip */
 	if((host = NCR_700_detect(&sim710_driver_template, hostdata, dev))
-- 
1.4.3.2


-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessary a
good idea.                                                [ RFC1925, 2.3 ]
