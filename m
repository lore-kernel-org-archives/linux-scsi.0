From: Drunkard Zhang <gongfan193@gmail.com>
Subject: Re: mvsas regression since 3.5
Date: Mon, 24 Dec 2012 12:32:08 +0800
Message-ID: <CAJiejCSWL5j5cCykypzLD7g=ph-w9gwKiWfxkS9JuDJ_MeJeeQ@mail.gmail.com>
References: <CAJiejCRCXgCw957to0fWhQPS69doacY9DOaQMpfyxM4bm3igQw@mail.gmail.com>
 <00cd01cde179$049bbc60$0dd33520$@com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f172.google.com ([209.85.216.172]:40296 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423Ab2LXEca convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Dec 2012 23:32:30 -0500
In-Reply-To: <00cd01cde179$049bbc60$0dd33520$@com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jack Wang <jack_wang@usish.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Xi Wang <xi.wang@gmail.com>, Xiangliang Yu <yuxiangl@marvell.com>, linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, djbw@fb.com

2012/12/24 Jack Wang <jack_wang@usish.com>:
>
>
> [Jack Wang]
> Do you see bug51881, which may relate to what you see
> https://bugzilla.kernel.org/show_bug.cgi?id=3D51881
>
> btw: also correct Dan's mail address.
>
Thanks a lot. My bisecting got exactly the same result, here's my bisec=
t log:

log21 ~/linux-mvsas # git bisect log
git bisect start
# bad: [ddffeb8c4d0331609ef2581d84de4d763607bd37] Linux 3.7-rc1
git bisect bad ddffeb8c4d0331609ef2581d84de4d763607bd37
# good: [303694eeee5eacad5b84105a15afd9e351e1891b] [SCSI] libsas:
suspend / resume support
git bisect good 303694eeee5eacad5b84105a15afd9e351e1891b
# good: [aecdc33e111b2c447b622e287c6003726daa1426] Merge
git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next
git bisect good aecdc33e111b2c447b622e287c6003726daa1426
# bad: [7a2852908e37e20be065e7765806daf1df077496] ARM: OMAP2+: Round
of the carve out memory requested to section_size
git bisect bad 7a2852908e37e20be065e7765806daf1df077496
# bad: [ecefbd94b834fa32559d854646d777c56749ef1c] Merge tag
'kvm-3.7-1' of git://git.kernel.org/pub/scm/virt/kvm/kvm
git bisect bad ecefbd94b834fa32559d854646d777c56749ef1c
# bad: [56d92aa5cf7c96c70f81d0350c94faf46a9fb76d] Merge tag
'stable/for-linus-3.7-x86-tag' of
git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen
git bisect bad 56d92aa5cf7c96c70f81d0350c94faf46a9fb76d
# bad: [16642a2e7be23bbda013fc32d8f6c68982eab603] Merge tag
'pm-for-3.7-rc1' of
git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
git bisect bad 16642a2e7be23bbda013fc32d8f6c68982eab603
# good: [7a9a2970b5c1c2ce73d4bb84edaa7ebf13e0c841] Merge tag
'rdma-for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband
git bisect good 7a9a2970b5c1c2ce73d4bb84edaa7ebf13e0c841
# good: [c26d4114aac55b57078caf83e261621d22e4596d] Merge branch 'pm-qos=
'
git bisect good c26d4114aac55b57078caf83e261621d22e4596d
# good: [c09b890b763df3ccd79a2c34c2f1abeb73179caf] spi/imx: set the
inactive state of the clock according to the clock polarity
git bisect good c09b890b763df3ccd79a2c34c2f1abeb73179caf
# good: [7fe0b14b725d6d09a1d9e1409bd465cb88b587f9] Merge tag 'spi-3.7'
of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/misc
git bisect good 7fe0b14b725d6d09a1d9e1409bd465cb88b587f9
# bad: [f1e70c2c535923de253eea2021376a936eb8d478] ata/ahci_platform:
Add clock framework support
git bisect bad f1e70c2c535923de253eea2021376a936eb8d478
# good: [583661a89ed2e484bd295e7b4606099340478c38] ata: define enum
constants for IDENTIFY DEVICE
git bisect good 583661a89ed2e484bd295e7b4606099340478c38
# bad: [8996b89d6bc98ae2f6d6e6e624a42a3f89d06949] ata: add platform
driver for Calxeda AHCI controller
git bisect bad 8996b89d6bc98ae2f6d6e6e624a42a3f89d06949
# bad: [100f586bd0959fe0e52b8a0b8cb49a3df1c6b044] sata_fsl: add
workaround for data length mismatch on freescale V2 controller
git bisect bad 100f586bd0959fe0e52b8a0b8cb49a3df1c6b044
# bad: [65fe1f0f66a57380229a4ced844188103135f37b] ahci: implement
aggressive SATA device sleep support
git bisect bad 65fe1f0f66a57380229a4ced844188103135f37b


>
> I'm using Asus PIKE 6480 SAS card, whose chipset is "RAID bus
> controller: Marvell Technology Group Ltd. MV64460/64461/64462 System =
Controller, Revision B", with latest stable branch 3.7.1 only 1 of 8 po=
rts works, to get others works I got to pull & plug back. While with
> 3.5.7 it's all good, so it must be a regression.
>
> Here's corresponding boot time dmesg of 3.7.1 with debug compiled:
>
> [    5.967302] udevd[1212]: starting version 171
> [    6.568908] mvsas 0000:04:00.0: mvsas: driver version 0.8.16
> [    6.569431] mvsas 0000:04:00.0: mvsas: PCI-E x4, Bandwidth Usage: =
2.5 Gbps
> [   10.980331] drivers/scsi/mvsas/mv_sas.c 1174:phy 0 attach dev info=
 is 0
> [   10.980334] drivers/scsi/mvsas/mv_sas.c 1176:phy 0 attach sas addr=
 is 0
> [   11.180909] drivers/scsi/mvsas/mv_sas.c 1174:phy 1 attach dev info=
 is 0
> [   11.180912] drivers/scsi/mvsas/mv_sas.c 1176:phy 1 attach sas addr=
 is 1
> [   11.381501] drivers/scsi/mvsas/mv_sas.c 1174:phy 2 attach dev info=
 is 0
> [   11.381503] drivers/scsi/mvsas/mv_sas.c 1176:phy 2 attach sas addr=
 is 2
> [   11.582085] drivers/scsi/mvsas/mv_sas.c 1174:phy 3 attach dev info=
 is 0
> [   11.582088] drivers/scsi/mvsas/mv_sas.c 1176:phy 3 attach sas addr=
 is 3
> [   11.782673] drivers/scsi/mvsas/mv_sas.c 1174:phy 4 attach dev info=
 is 0
> [   11.782676] drivers/scsi/mvsas/mv_sas.c 1176:phy 4 attach sas addr=
 is 4
> [   11.983262] drivers/scsi/mvsas/mv_sas.c 1174:phy 5 attach dev info=
 is 800
> [   11.983265] drivers/scsi/mvsas/mv_sas.c 1176:phy 5 attach sas addr=
 is 5
> [   12.183856] drivers/scsi/mvsas/mv_sas.c 1174:phy 6 attach dev info=
 is 4
> [   12.183858] drivers/scsi/mvsas/mv_sas.c 1176:phy 6 attach sas addr=
 is 6
> [   12.384438] drivers/scsi/mvsas/mv_sas.c 1174:phy 7 attach dev info=
 is 0
> [   12.384441] drivers/scsi/mvsas/mv_sas.c 1176:phy 7 attach sas addr=
 is 7
> [   12.384447] scsi6 : mvsas
> [   12.385479] drivers/scsi/mvsas/mv_sas.c 277:phy 0 byte dmaded.
> [   12.385482] drivers/scsi/mvsas/mv_sas.c 277:phy 1 byte dmaded.
> [   12.385488] drivers/scsi/mvsas/mv_sas.c 277:phy 2 byte dmaded.
> [   12.385491] drivers/scsi/mvsas/mv_sas.c 277:phy 3 byte dmaded.
> [   12.385494] drivers/scsi/mvsas/mv_sas.c 277:phy 4 byte dmaded.
> [   12.385497] drivers/scsi/mvsas/mv_sas.c 277:phy 5 byte dmaded.
> [   12.385500] drivers/scsi/mvsas/mv_sas.c 277:phy 6 byte dmaded.
> [   12.385503] drivers/scsi/mvsas/mv_sas.c 277:phy 7 byte dmaded.
> [   12.385614] sas: phy-6:0 added to port-6:0, phy_mask:0x1 (        =
       0)
> [   12.385667] sas: phy-6:1 added to port-6:1, phy_mask:0x2 ( 1000000=
00000000)
> [   12.385716] sas: phy-6:2 added to port-6:2, phy_mask:0x4 ( 2000000=
00000000)
> [   12.385759] sas: phy-6:3 added to port-6:3, phy_mask:0x8 ( 3000000=
00000000)
> [   12.385801] sas: phy-6:4 added to port-6:4, phy_mask:0x10 ( 400000=
000000000)
> [   12.385851] sas: phy-6:5 added to port-6:5, phy_mask:0x20 ( 500000=
000000000)
> [   12.385895] sas: phy-6:6 added to port-6:6, phy_mask:0x40 ( 600000=
000000000)
> [   12.385942] sas: phy-6:7 added to port-6:7, phy_mask:0x80 ( 700000=
000000000)
> [   12.385967] sas: DOING DISCOVERY on port 0, pid:847
> [   12.385974] sas: DONE DISCOVERY on port 0, pid:847, result:0
> [   12.385986] sas: DOING DISCOVERY on port 1, pid:847
> [   12.385991] sas: DONE DISCOVERY on port 1, pid:847, result:0
> [   12.386003] sas: DOING DISCOVERY on port 2, pid:847
> [   12.386009] sas: DONE DISCOVERY on port 2, pid:847, result:0
> [   12.386020] sas: DOING DISCOVERY on port 3, pid:847
> [   12.386029] sas: DONE DISCOVERY on port 3, pid:847, result:0
> [   12.386041] sas: DOING DISCOVERY on port 4, pid:847
> [   12.386048] sas: DONE DISCOVERY on port 4, pid:847, result:0
> [   12.386060] sas: DOING DISCOVERY on port 5, pid:847
> [   12.386066] sas: DONE DISCOVERY on port 5, pid:847, result:0
> [   12.386077] sas: DOING DISCOVERY on port 6, pid:847
> [   12.386083] sas: DONE DISCOVERY on port 6, pid:847, result:0
> [   12.386095] sas: DOING DISCOVERY on port 7, pid:847
> [   12.386101] sas: DONE DISCOVERY on port 7, pid:847, result:0
> [   12.386188] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
> [   12.386281] sas: ata7: end_device-6:0: dev error handler
> [   12.537987] ata7.00: ATA-8: ST33000650NS, 0004, max UDMA/133
> [   12.537992] ata7.00: 5860533168 sectors, multi 0: LBA48 NCQ (depth=
 31/32)
> [   12.538227] drivers/scsi/mvsas/mv_sas.c 1857:port 0 slot 0 rx_desc
> 20000 has error info0000000081000000.
> [   12.538256] ata7.00: failed to get Identify Device Data, Emask 0x1
> [   12.539467] drivers/scsi/mvsas/mv_sas.c 1857:port 0 slot 0 rx_desc
> 20000 has error info0000000081000000.
> [   12.539496] ata7.00: failed to get Identify Device Data, Emask 0x1
> [   12.539504] ata7.00: configured for UDMA/133
> [   12.539611] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0=
 tries: 1
> [   12.550707] scsi 6:0:0:0: Direct-Access     ATA      ST33000650NS
>   0004 PQ: 0 ANSI: 5
> [   12.550800] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
> [   12.550893] sas: ata7: end_device-6:0: dev error handler
> [   12.550983] sas: ata8: end_device-6:1: dev error handler
> [   12.702637] drivers/scsi/mvsas/mv_sas.c 1857:port 1 slot 0 rx_desc
> 20000 has error info0000000081000000.
> [   12.702667] ata8.00: both IDENTIFYs aborted, assuming NODEV
> [   12.702766] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0=
 tries: 1
> [   12.714341] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
> [   12.714418] sas: ata7: end_device-6:0: dev error handler
> [   12.714435] sas: ata8: end_device-6:1: dev error handler
> [   12.714440] sas: ata9: end_device-6:2: dev error handler
> [   12.865290] drivers/scsi/mvsas/mv_sas.c 1857:port 2 slot 0 rx_desc
> 20000 has error info0000000081000000.
> [   12.865319] ata9.00: both IDENTIFYs aborted, assuming NODEV
> [   12.865423] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0=
 tries: 1
> [   12.876995] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
> [   12.877094] sas: ata7: end_device-6:0: dev error handler
> [   12.877111] sas: ata8: end_device-6:1: dev error handler
> [   12.877118] sas: ata9: end_device-6:2: dev error handler
> [   12.877123] sas: ata10: end_device-6:3: dev error handler
> [   13.027975] drivers/scsi/mvsas/mv_sas.c 1857:port 3 slot 0 rx_desc
> 20000 has error info0000000081000000.
> [   13.028004] ata10.00: both IDENTIFYs aborted, assuming NODEV
> [   13.028098] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0=
 tries: 1
> [   13.039653] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
> [   13.039731] sas: ata7: end_device-6:0: dev error handler
> [   13.039747] sas: ata8: end_device-6:1: dev error handler
> [   13.039754] sas: ata9: end_device-6:2: dev error handler
> [   13.039760] sas: ata10: end_device-6:3: dev error handler
> [   13.039765] sas: ata11: end_device-6:4: dev error handler
> [   13.195528] drivers/scsi/mvsas/mv_sas.c 1857:port 4 slot 0 rx_desc
> 20000 has error info0000000081000000.
> [   13.195557] ata11.00: both IDENTIFYs aborted, assuming NODEV
> [   13.195664] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0=
 tries: 1
> [   13.207297] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
> [   13.207392] sas: ata7: end_device-6:0: dev error handler
> [   13.207409] sas: ata8: end_device-6:1: dev error handler
> [   13.207417] sas: ata9: end_device-6:2: dev error handler
> [   13.207422] sas: ata10: end_device-6:3: dev error handler
> [   13.207427] sas: ata11: end_device-6:4: dev error handler
> [   13.207432] sas: ata12: end_device-6:5: dev error handler
> [   13.360919] drivers/scsi/mvsas/mv_sas.c 1857:port 5 slot 0 rx_desc
> 20000 has error info0000000081000000.
> [   13.360949] ata12.00: both IDENTIFYs aborted, assuming NODEV
> [   13.361059] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0=
 tries: 1
> [   13.371980] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
> [   13.372076] sas: ata7: end_device-6:0: dev error handler
> [   13.372092] sas: ata8: end_device-6:1: dev error handler
> [   13.372099] sas: ata9: end_device-6:2: dev error handler
> [   13.372105] sas: ata10: end_device-6:3: dev error handler
> [   13.372110] sas: ata11: end_device-6:4: dev error handler
> [   13.372115] sas: ata12: end_device-6:5: dev error handler
> [   13.372119] sas: ata13: end_device-6:6: dev error handler
> [   13.525785] drivers/scsi/mvsas/mv_sas.c 1857:port 6 slot 0 rx_desc
> 20000 has error info0000000081000000.
> [   13.525814] ata13.00: both IDENTIFYs aborted, assuming NODEV
> [   13.525919] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0=
 tries: 1
> [   13.537549] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
> [   13.537606] sas: ata7: end_device-6:0: dev error handler
> [   13.537623] sas: ata8: end_device-6:1: dev error handler
> [   13.537630] sas: ata9: end_device-6:2: dev error handler
> [   13.537635] sas: ata10: end_device-6:3: dev error handler
> [   13.537640] sas: ata11: end_device-6:4: dev error handler
> [   13.537645] sas: ata12: end_device-6:5: dev error handler
> [   13.537650] sas: ata13: end_device-6:6: dev error handler
> [   13.537655] sas: ata14: end_device-6:7: dev error handler
> [   13.692779] drivers/scsi/mvsas/mv_sas.c 1857:port 7 slot 0 rx_desc
> 20000 has error info0000000081000000.
> [   13.692808] ata14.00: both IDENTIFYs aborted, assuming NODEV
> [   13.692917] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0=
 tries: 1
> [   13.704396] sd 6:0:0:0: [sde] 5860533168 512-byte logical blocks:
> (3.00 TB/2.72 TiB)
> [   13.704461] sd 6:0:0:0: [sde] Write Protect is off
> [   13.704466] sd 6:0:0:0: [sde] Mode Sense: 00 3a 00 00
> [   13.704492] sd 6:0:0:0: [sde] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [   13.704589] sd 6:0:0:0: Attached scsi generic sg4 type 0
> [   13.742800]  sde: sde1
> [   13.743201] sd 6:0:0:0: [sde] Attached SCSI disk
> [   14.848140] bio: create slab <bio-1> at 1
>



--
=E5=BC=A0=E7=BB=8D=E6=96=87
gongfan193@gmail.com
zhangsw@gwbnsh.net.cn
18601633785
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
