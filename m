From: "Cameron, Steve" <Steve.Cameron@hp.com>
Subject: RE: linux-2.6.17.1: cciss.c:(.text+0x81594): undefined referenceto`scsi_device_types'
Date: Thu, 22 Jun 2006 14:29:39 -0500
Message-ID: <5CCF5F0F2514664CBE20FD24BCE17614044D64@cceexc17.americas.cpqcorp.net>
References: <200606221905.00505.toralf.foerster@gmx.de><5CCF5F0F2514664CBE20FD24BCE17614044D62@cceexc17.americas.cpqcorp.net><1150998479.7868.26.camel@mulgrave.il.steeleye.com><5CCF5F0F2514664CBE20FD24BCE17614044D63@cceexc17.americas.cpqcorp.net> <1151002295.7868.37.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ccerelbas04.cce.hp.com ([161.114.21.107]:65486 "EHLO
	ccerelbas04.cce.hp.com") by vger.kernel.org with ESMTP
	id S932630AbWFVTcN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jun 2006 15:32:13 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: =?iso-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>, ISS StorageDev <iss_storagedev@hp.com>, linux-scsi@vger.kernel.org


Yeah, I think that looks ok to me.  (Was a little confused
trying it out, as I had USB storage as "y" as well
as the cciss tape support being turned on and my
scsi ended up displaying in make menuconfig as "---"
rather than "m" or "y".

Maybe that means it was selected by multiple other things?

-- steve



-----Original Message-----
=46rom: James Bottomley [mailto:James.Bottomley@SteelEye.com]
Sent: Thu 6/22/2006 1:51 PM
To: Cameron, Steve
Cc: Toralf F=F6rster; ISS StorageDev; linux-scsi@vger.kernel.org
Subject: RE: linux-2.6.17.1: cciss.c:(.text+0x81594): undefined referen=
ceto`scsi_device_types'
=20
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
=20
 config CISS_SCSI_TAPE
 	bool "SCSI tape drive support for Smart Array 5xxx"
-	depends on BLK_CPQ_CISS_DA && SCSI && PROC_FS
+	depends on BLK_CPQ_CISS_DA && PROC_FS
 	help
 	  When enabled (Y), this option allows SCSI tape drives and SCSI medi=
um
 	  changers (tape robots) to be accessed via a Compaq 5xxx array=20
@@ -178,6 +178,11 @@ config CISS_SCSI_TAPE
 	  When this option is disabled (N), the SCSI portion of the driver=20
 	  is not compiled.
=20
+config CISS_FORCE_SCSI
+	tristate
+	default BLK_CPQ_CISS_DA
+	select SCSI if CISS_SCSI_TAPE
+
 config BLK_DEV_DAC960
 	tristate "Mylex DAC960/DAC1100 PCI RAID Controller support"
 	depends on PCI



-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
