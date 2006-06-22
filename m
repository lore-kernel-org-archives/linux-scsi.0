From: "Cameron, Steve" <Steve.Cameron@hp.com>
Subject: RE: linux-2.6.17.1: cciss.c:(.text+0x81594): undefined reference to `scsi_device_types'
Date: Thu, 22 Jun 2006 12:26:05 -0500
Message-ID: <5CCF5F0F2514664CBE20FD24BCE17614044D62@cceexc17.americas.cpqcorp.net>
References: <200606221905.00505.toralf.foerster@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ccerelbas02.cce.hp.com ([161.114.21.105]:43486 "EHLO
	ccerelbas02.cce.hp.com") by vger.kernel.org with ESMTP
	id S1751848AbWFVR2m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jun 2006 13:28:42 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?iso-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>, ISS StorageDev <iss_storagedev@hp.com>
Cc: linux-scsi@vger.kernel.org


We've seen this before...

CONFIG_BLK_CPQ_CISS_DA=3Dy
CONFIG_CISS_SCSI_TAPE=3Dy

CONFIG_SCSI=3Dm

you've selected build cciss into the kernel,
and build the scsi midlayer as a module, and
build scsi tape support into cciss.   You
should not be able to select cciss scsi tape
support unless cciss is a module AND scsi
is a module or built in, or if cciss is built
in, then scsi must also be built in for tape
support.

I don't know how to enforce that in the config
file.

-- steve

-----Original Message-----
=46rom: Toralf F=F6rster [mailto:toralf.foerster@gmx.de]
Sent: Thu 6/22/2006 12:04 PM
To: ISS StorageDev
Cc: linux-scsi@vger.kernel.org
Subject: linux-2.6.17.1: cciss.c:(.text+0x81594): undefined reference t=
o `scsi_device_types'
=20
I get:
=2E..
  UPD     include/linux/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
drivers/built-in.o: In function `cciss_scsi_add_entry':
cciss.c:(.text+0x81594): undefined reference to `scsi_device_types'
drivers/built-in.o: In function `cciss_scsi_remove_entry':
cciss.c:(.text+0x816e7): undefined reference to `scsi_device_types'
drivers/built-in.o: In function `adjust_cciss_scsi_table':
cciss.c:(.text+0x817ab): undefined reference to `scsi_device_types'
drivers/built-in.o: In function `cciss_scsi_detect':
cciss.c:(.text+0x81d4a): undefined reference to `scsi_host_alloc'
cciss.c:(.text+0x81db2): undefined reference to `scsi_add_host'
cciss.c:(.text+0x81dbe): undefined reference to `scsi_scan_host'
cciss.c:(.text+0x81dd4): undefined reference to `scsi_host_put'
drivers/built-in.o: In function `cciss_update_non_disk_devices':
cciss.c:(.text+0x82530): undefined reference to `scsi_device_types'
drivers/built-in.o: In function `cciss_unregister_scsi':
cciss.c:(.text+0x82dad): undefined reference to `scsi_remove_host'
cciss.c:(.text+0x82db7): undefined reference to `scsi_host_put'
make: *** [.tmp_vmlinux1] Error 1

with the config attahed onto this mail.

--=20
MfG/Sincerely
Toralf F=F6rster

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
