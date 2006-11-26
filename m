From: "roland" <devzero@web.de>
Subject: Disable SCSI-Reservation at the driver level ?
Date: Sun, 26 Nov 2006 17:31:26 +0100
Message-ID: <0ca701c71178$528eb3a0$eeeea8c0@aldipc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1;
	format=flowed	reply-type=original
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:52168 "EHLO
	fmmailgate03.web.de") by vger.kernel.org with ESMTP id S935437AbWKZQbg
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Nov 2006 11:31:36 -0500
Received: from smtp08.web.de (fmsmtp08.dlan.cinetic.de [172.20.5.216])
	by fmmailgate03.web.de (Postfix) with ESMTP id 7F4CD3DCE354
	for <linux-scsi@vger.kernel.org>; Sun, 26 Nov 2006 17:29:58 +0100 (CET)
Received: from [82.141.46.150] (helo=aldipc)
	by smtp08.web.de with smtp (WEB.DE 4.107 #114)
	id 1GoMtC-0000kx-00
	for linux-scsi@vger.kernel.org; Sun, 26 Nov 2006 17:29:58 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello !

i have a "problem" with VMWare ESX (not big one, but interesting one - =
at=20
least for me).

If you don`t know VMware ESX - ESX is sort of it`s own operating system=
 with=20
Linux as a management console OS on top of a hypervisor (vmkernel), jus=
t=20
similar to XEN hypervisor with and attached dom0. Besides the drivers i=
n the=20
console OS, the vmkernel loads it=B4s own drivers, which are derived fr=
om=20
Linux drivers.

VMWare ESX refuses to create VMFS Filesystem on SATA disk, attached to =
a=20
onBoard SAS controller (lsi1068).
When i raid1 two SATA disks, it works, if i use a single SATA disk, the=
=20
controller seems to "expose" the disk differently to the operating syst=
em=20
and creation of a VMFS fails due to missing ability to issue SCSI=20
reservation command.

Ok there is no official SATA support for now, but some controllers work=
 with=20
SATA,  because you can either attach SAS and SATA disks to that (LSI106=
8).=20
=46urthermore there are SATA-controllers which can be used with the dri=
ver of=20
some SCSI-model (LSI Megaraid 150-4)

Afaik, SCSI reservations being used/needed in shared storage environmen=
t=20
(SAN, Shared local attached storage), so i wonder, why it's also being =
used=20
on local attached disk. Only vmware may give an answer here.

Maybe i can can "workaround" this somehow ?
I couldn`t find a way to stop the vmkfstools (which is used to format=20
blockdevice with VMFS) issueing a SCSI reservation command, but i assum=
e=20
this can probably be done via filtering some syscall (ioctl?) via LD_PR=
ELOAD=20
library - i.e. wrapping vmkfstools - or maybe i can hack this at the dr=
iver=20
level, since source of the ESX storage drivers is available for downloa=
d and=20
can be recompiled. :)

if somebody like to help hacking this -  there is a thread at:
http://www.vmware.com/community/thread.jspa?messageID=3D518182&#518182
thread begins with some related iSCSI issues and discusses SATA issues =
later=20
on.

regards
Roland

ps:
yes, i know this is somhow "evil" and i shouldn`t do that, because some=
thing=20
could badly fail -  but it`s for private purpose, for proof of concept =
and=20
for personal satisfaction. :) i=B4m not going to use such hack on any=20
production system.=20

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
