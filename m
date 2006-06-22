From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: linux-2.6.17.1: cciss.c:(.text+0x81594): undefined referenceto
	`scsi_device_types'
Date: Thu, 22 Jun 2006 13:51:35 -0500
Message-ID: <1151002295.7868.37.camel@mulgrave.il.steeleye.com>
References: <200606221905.00505.toralf.foerster@gmx.de>
	 <5CCF5F0F2514664CBE20FD24BCE17614044D62@cceexc17.americas.cpqcorp.net>
	 <1150998479.7868.26.camel@mulgrave.il.steeleye.com>
	 <5CCF5F0F2514664CBE20FD24BCE17614044D63@cceexc17.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:28579 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1161187AbWFVSvo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jun 2006 14:51:44 -0400
In-Reply-To: <5CCF5F0F2514664CBE20FD24BCE17614044D63@cceexc17.americas.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Cameron, Steve" <Steve.Cameron@hp.com>
Cc: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>, ISS StorageDev <iss_storagedev@hp.com>, linux-scsi@vger.kernel.org

On Thu, 2006-06-22 at 13:27 -0500, Cameron, Steve wrote:
> This makes me think that if CISS_SCSI_TAPE is y, it will force
> SCSI to be y?  That's quite not correct.

Hmm, yes, this will have to be done via a dummy variable.  How about
this?

James

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index ae0949b..a1108fa 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -166,7 +166,7 @@ config BLK_CPQ_CISS_DA
 
 config CISS_SCSI_TAPE
 	bool "SCSI tape drive support for Smart Array 5xxx"
-	depends on BLK_CPQ_CISS_DA && SCSI && PROC_FS
+	depends on BLK_CPQ_CISS_DA && PROC_FS
 	help
 	  When enabled (Y), this option allows SCSI tape drives and SCSI medium
 	  changers (tape robots) to be accessed via a Compaq 5xxx array 
@@ -178,6 +178,11 @@ config CISS_SCSI_TAPE
 	  When this option is disabled (N), the SCSI portion of the driver 
 	  is not compiled.
 
+config CISS_FORCE_SCSI
+	tristate
+	default BLK_CPQ_CISS_DA
+	select SCSI if CISS_SCSI_TAPE
+
 config BLK_DEV_DAC960
 	tristate "Mylex DAC960/DAC1100 PCI RAID Controller support"
 	depends on PCI


