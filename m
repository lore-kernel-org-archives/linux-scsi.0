From: =?ISO-8859-1?Q?Hajo_M=F6ller?= <dasjoe@gmail.com>
Subject: Can not see/access devices on Marvell 88SE9485 + SiI 3726 PMP
Date: Mon, 01 Jul 2013 16:09:42 +0200
Message-ID: <51D18DA6.8000502@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:36265 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159Ab3GAOJp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Jul 2013 10:09:45 -0400
Received: by mail-bk0-f44.google.com with SMTP id 6so145395bkj.3
        for <linux-scsi@vger.kernel.org>; Mon, 01 Jul 2013 07:09:43 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: yuxiangl@marvell.com

Hi,

I've got a box which recently got a Marvell 88SE9485 PCIe card
(Supermicro AOC-SAS2LP-MV8), which is connected by a mSAS->4x SATA-cable
to some 5 HDD backplanes (CFI-B53PM, chip is a SiI 3726).

The HBA's BIOS can see and access the HDDs through the backplanes, which
various Linux distributions could not.
I tried Ubuntu 12.04.2, Ubuntu 13.04, Debian 7.0 and a current Arch Linux.
All logs in this mail are from a fresh Ubuntu 12.04.2 install.

lspci shows the controller as:
01:00.0 RAID bus controller: Marvell Technology Group Ltd. Device 9485
(rev 03)

lshw does not show the attached disks, nor are there device nodes in
/dev/ for those disks.

Unplugging a disk results in this (/var/log/kern.log):
kernel: [  276.995910]
/build/buildd/linux-lts-quantal-3.5.0/drivers/scsi/mvsas/mv_sas.c
2062:phy 4 ctrl sts=0x00000000.
kernel: [  276.995914]
/build/buildd/linux-lts-quantal-3.5.0/drivers/scsi/mvsas/mv_sas.c
2064:phy 4 irq sts = 0x01201001
kernel: [  278.950547]
/build/buildd/linux-lts-quantal-3.5.0/drivers/scsi/mvsas/mv_sas.c
2062:phy 4 ctrl sts=0x00111000.
kernel: [  278.950551]
/build/buildd/linux-lts-quantal-3.5.0/drivers/scsi/mvsas/mv_sas.c
2064:phy 4 irq sts = 0x00000081
kernel: [  279.502757]
/build/buildd/linux-lts-quantal-3.5.0/drivers/scsi/mvsas/mv_94xx.c
838:get all reg link rate is 0x111000
kernel: [  279.502760]
/build/buildd/linux-lts-quantal-3.5.0/drivers/scsi/mvsas/mv_94xx.c
843:get link rate is 9
kernel: [  279.582118] mvsas 0000:01:00.0: Phy0 : No sig fis
kernel: [  279.582121]
/build/buildd/linux-lts-quantal-3.5.0/drivers/scsi/mvsas/mv_sas.c
2006:phy0 Attached Device
kernel: [  283.953502]
/build/buildd/linux-lts-quantal-3.5.0/drivers/scsi/mvsas/mv_sas.c
2048:Get signature time out, reset phy 4
kernel: [  283.953517]
/build/buildd/linux-lts-quantal-3.5.0/drivers/scsi/mvsas/mv_sas.c
2062:phy 4 ctrl sts=0x00000000.
kernel: [  283.953519]
/build/buildd/linux-lts-quantal-3.5.0/drivers/scsi/mvsas/mv_sas.c
2064:phy 4 irq sts = 0x00001001
kernel: [  284.449485]
/build/buildd/linux-lts-quantal-3.5.0/drivers/scsi/mvsas/mv_sas.c
2062:phy 4 ctrl sts=0x00111000.
kernel: [  284.449488]
/build/buildd/linux-lts-quantal-3.5.0/drivers/scsi/mvsas/mv_sas.c
2064:phy 4 irq sts = 0x00000081
kernel: [  286.445635]
/build/buildd/linux-lts-quantal-3.5.0/drivers/scsi/mvsas/mv_94xx.c
838:get all reg link rate is 0x111000
kernel: [  286.445638]
/build/buildd/linux-lts-quantal-3.5.0/drivers/scsi/mvsas/mv_94xx.c
843:get link rate is 9
kernel: [  286.524997] mvsas 0000:01:00.0: Phy0 : No sig fis
kernel: [  286.525000]
/build/buildd/linux-lts-quantal-3.5.0/drivers/scsi/mvsas/mv_sas.c
2006:phy0 Attached Device

Replugging the disk:
kernel: [  310.738784]
/build/buildd/linux-lts-quantal-3.5.0/drivers/scsi/mvsas/mv_sas.c
2062:phy 4 ctrl sts=0x00111000.
kernel: [  310.738788]
/build/buildd/linux-lts-quantal-3.5.0/drivers/scsi/mvsas/mv_sas.c
2064:phy 4 irq sts = 0x00010000
kernel: [  310.738791]
/build/buildd/linux-lts-quantal-3.5.0/drivers/scsi/mvsas/mv_sas.c
2113:notify plug in on phy[0]
kernel: [  310.758632]
/build/buildd/linux-lts-quantal-3.5.0/drivers/scsi/mvsas/mv_94xx.c
838:get all reg link rate is 0x111000
kernel: [  310.758634]
/build/buildd/linux-lts-quantal-3.5.0/drivers/scsi/mvsas/mv_94xx.c
843:get link rate is 9
kernel: [  310.877669]
/build/buildd/linux-lts-quantal-3.5.0/drivers/scsi/mvsas/mv_sas.c
1175:phy 4 attach dev info is 20001
kernel: [  310.877671]
/build/buildd/linux-lts-quantal-3.5.0/drivers/scsi/mvsas/mv_sas.c
1177:phy 4 attach sas addr is 4
kernel: [  310.877678]
/build/buildd/linux-lts-quantal-3.5.0/drivers/scsi/mvsas/mv_sas.c
277:phy 4 byte dmaded.
kernel: [  310.877689] sas: sas_form_port: phy0 belongs to port0 already(1)!

According to Marvell's product brief the controller has "Built-in
support for SATA Port Multipliers with FIS-based switching", which its
BIOS seems to confirm.

The PMPs used to work when connected via a Syba SY-PEX40008 (SiI3124)
controller, which has bugs on its own when more than three drives per
PMP are concurrently active.

Any help is greatly appreciated,

Hajo
