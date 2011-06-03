From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Subject: [PROBLEM] reproduceable storage errors on high IO load
Date: Fri, 3 Jun 2011 09:29:00 +0200
Message-ID: <20110603092900.62339171.taeuber@bbaw.de>
References: <20110531113452.4f234274.taeuber@bbaw.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.bbaw.de ([194.95.188.6]:58104 "EHLO mail.bbaw.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211Ab1FCH3D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jun 2011 03:29:03 -0400
Received: from mailhub.bbaw.de (unknown [192.168.4.1])
	by mail.bbaw.de (Postfix) with ESMTP id 68EB94A80C8
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jun 2011 09:29:00 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by mailhub.bbaw.de (Postfix) with ESMTP id 41D8693855
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jun 2011 09:29:00 +0200 (CEST)
Received: from taeuber (taeuber.bbaw.de [192.168.1.148])
	by mailhub.bbaw.de (Postfix) with SMTP id 32A1B9383D
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jun 2011 09:29:00 +0200 (CEST)
In-Reply-To: <20110531113452.4f234274.taeuber@bbaw.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

ok, I see. No one on the list feels cognizant.
Please tell me where to report this problem. linux-kernel@=E2=80=A6?

Thanks
Lars


Am Tue, 31 May 2011 11:34:52 +0200
Lars T=C3=A4uber <taeuber@bbaw.de> schrieb:

> Hi there,
>=20
> I have a problem with a SW-RAID6. It is reproduceable also after chan=
ging the hole hardware.
> I startet with a Suse 11.2. The problem occured during writing much d=
ata to the array (high io load).
> This is hopefully the right ML for my problem. Otherwise please excus=
e me and point me the the right ML.
>=20
>=20
> Then I changed the PSU. Still errors on high load.
> Then I changed the sata controller (Sil 3114 - sata_sil) with one wit=
h a different chipset (driver: sata_mv). Still errors on high load.
> Then I changed the disk enclosure and all cables. Still errors.
> Then I changed the mainboard (tyan opteron) with one from supermicro =
(H8SCM-F) with 6-core opteron. Still errors.
> Then I changed to ubuntu 10.04 -> 10.10. Still errors
> Then I tried different schedulars (noop,anticipatory,cfq,deadline). S=
till errors.
> Then I tried kernel options: noapic + acpi=3Doff without luck.
> Then I changed the sata controller with a areca sas (driver: mvsas). =
Still errors.
> Then I tried some different hdds (orig: Western Digital WDC WD2002FYP=
S + WDC WD2003FYYS; new: Seagate ST3320620NS). Still errors.
> Then I tried some different kernel versions from ubuntu without luck:
> 2.6.32-22-server
> 2.6.35-25-server
>=20
> Then I tried self compiled kernels without luck:
> 2.6.35.13
> 2.6.38.6
> 2.6.39: same problem occurs but later
>=20
> The current configuration:
> - tested only 64-bit kernels
> - Supermicro H8SCM-F (AMD SR5650+SP5100) with 6-core opteron
> - Areca (non-raid) ARC-1300ix-16 sas controller
> - SW-RAID6 over 8 Western Digital HDDs (sone WDC WD2002FYPS + some WD=
C WD2003FYYS)
> - redundant PSU
>=20
> How to reproduce my problem:
> mdadm -C /dev/md3 -l6 -n8 /dev/sd[c-h] missing missing
> (the two missing hdds prevent this raid from initial sync)
>=20
> Everything is just fine till yet.
> Now produce high io-load:
> mke2fs -j /dev/md3
>=20
> The detailed history (search for Lars to get my posts):
> https://bugs.launchpad.net/ubuntu/+bug/550559
>=20
> The error messages changed a bit during the kernel versions.
> The nearly complete dmesg output:
> https://launchpadlibrarian.net/72325163/20110524.dmesg.out
>=20
> Is there something I do wrong? Could someone help me to debug this?
> Thanks
> Lars
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
