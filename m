From: "Cameron, Steve" <Steve.Cameron@hp.com>
Subject: RE: linux-2.6.17.1: cciss.c:(.text+0x81594): undefined referenceto `scsi_device_types'
Date: Thu, 22 Jun 2006 13:27:45 -0500
Message-ID: <5CCF5F0F2514664CBE20FD24BCE17614044D63@cceexc17.americas.cpqcorp.net>
References: <200606221905.00505.toralf.foerster@gmx.de><5CCF5F0F2514664CBE20FD24BCE17614044D62@cceexc17.americas.cpqcorp.net> <1150998479.7868.26.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ccerelbas01.cce.hp.com ([161.114.21.104]:1001 "EHLO
	ccerelbas01.cce.hp.com") by vger.kernel.org with ESMTP
	id S1751860AbWFVS1u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jun 2006 14:27:50 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: =?iso-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>, ISS StorageDev <iss_storagedev@hp.com>, linux-scsi@vger.kernel.org


Thanks James...

Does that "select SCSI" make SCSI a "y" or an "m", or...?

The documentations says...

- reverse dependencies: "select" <symbol> ["if" <expr>]
  While normal dependencies reduce the upper limit of a symbol (see
  below), reverse dependencies can be used to force a lower limit of
  another symbol. The value of the current menu symbol is used as the
  minimal value <symbol> can be set to. If <symbol> is selected multipl=
e
  times, the limit is set to the largest selection.
  Reverse dependencies can only be used with boolean or tristate
  symbols.

This makes me think that if CISS_SCSI_TAPE is y, it will force
SCSI to be y?  That's quite not correct.

CISS_SCSI_TAPE can only be set to "y"=20
if SCSI >=3D BLK_CPQ_CISS_DA (where "y" > "m" > "n")

That is, if CISS_SCSI_TAPE is to be "y" and BLK_CPQ_CISS_DA =3D=3D "m",
then SCSI can be either "m" or "y". =20

If CISS_SCSI_TAPE is to be "y" and BLK_CPQ_CISS_DA =3D=3D "y",
then SCSI must be "y".

Does "select" do that?  Or do I misunderstand the docs?

-- steve


-----Original Message-----
=46rom: James Bottomley [mailto:James.Bottomley@SteelEye.com]
Sent: Thu 6/22/2006 12:47 PM
To: Cameron, Steve
Cc: Toralf F=F6rster; ISS StorageDev; linux-scsi@vger.kernel.org
Subject: RE: linux-2.6.17.1: cciss.c:(.text+0x81594): undefined referen=
ceto `scsi_device_types'
=20
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
=20
 config CISS_SCSI_TAPE
 	bool "SCSI tape drive support for Smart Array 5xxx"
-	depends on BLK_CPQ_CISS_DA && SCSI && PROC_FS
+	depends on BLK_CPQ_CISS_DA && PROC_FS
+	select SCSI
 	help
 	  When enabled (Y), this option allows SCSI tape drives and SCSI medi=
um
 	  changers (tape robots) to be accessed via a Compaq 5xxx array=20



-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
