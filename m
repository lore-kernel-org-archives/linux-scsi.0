From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: linux-2.6.17.1: cciss.c:(.text+0x81594): undefined reference
	to `scsi_device_types'
Date: Thu, 22 Jun 2006 12:47:59 -0500
Message-ID: <1150998479.7868.26.camel@mulgrave.il.steeleye.com>
References: <200606221905.00505.toralf.foerster@gmx.de>
	 <5CCF5F0F2514664CBE20FD24BCE17614044D62@cceexc17.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:61595 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932621AbWFVRsG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jun 2006 13:48:06 -0400
In-Reply-To: <5CCF5F0F2514664CBE20FD24BCE17614044D62@cceexc17.americas.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Cameron, Steve" <Steve.Cameron@hp.com>
Cc: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>, ISS StorageDev <iss_storagedev@hp.com>, linux-scsi@vger.kernel.org

On Thu, 2006-06-22 at 12:26 -0500, Cameron, Steve wrote:
> I don't know how to enforce that in the config
> file.

Try this.

James

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index ae0949b..79e0a16 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -166,7 +166,8 @@ config BLK_CPQ_CISS_DA
 
 config CISS_SCSI_TAPE
 	bool "SCSI tape drive support for Smart Array 5xxx"
-	depends on BLK_CPQ_CISS_DA && SCSI && PROC_FS
+	depends on BLK_CPQ_CISS_DA && PROC_FS
+	select SCSI
 	help
 	  When enabled (Y), this option allows SCSI tape drives and SCSI medium
 	  changers (tape robots) to be accessed via a Compaq 5xxx array 


