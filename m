From: Drunkard Zhang <gongfan193@gmail.com>
Subject: mvsas regression since 3.5
Date: Sat, 22 Dec 2012 23:33:39 +0800
Message-ID: <CAJiejCRCXgCw957to0fWhQPS69doacY9DOaQMpfyxM4bm3igQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=20cf302efa686ae1d504d172b1e9
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:39294 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab2LVPkD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Dec 2012 10:40:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, Dan Williams <dan.j.williams@intel.com>, Jack Wang <jack_wang@usish.com>, Xi Wang <xi.wang@gmail.com>, Xiangliang Yu <yuxiangl@marvell.com>, linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>

--20cf302efa686ae1d504d172b1e9
Content-Type: text/plain; charset=UTF-8

I'm using Asus PIKE 6480 SAS card, whose chipset is "RAID bus
controller: Marvell Technology Group Ltd. MV64460/64461/64462 System
Controller, Revision B", with latest stable branch 3.7.1 only 1 of 8
ports works, to get others works I got to pull & plug back. While with
3.5.7 it's all good, so it must be a regression.

Here's corresponding boot time dmesg of 3.7.1 with debug compiled:

[    5.967302] udevd[1212]: starting version 171
[    6.568908] mvsas 0000:04:00.0: mvsas: driver version 0.8.16
[    6.569431] mvsas 0000:04:00.0: mvsas: PCI-E x4, Bandwidth Usage: 2.5 Gbps
[   10.980331] drivers/scsi/mvsas/mv_sas.c 1174:phy 0 attach dev info is 0
[   10.980334] drivers/scsi/mvsas/mv_sas.c 1176:phy 0 attach sas addr is 0
[   11.180909] drivers/scsi/mvsas/mv_sas.c 1174:phy 1 attach dev info is 0
[   11.180912] drivers/scsi/mvsas/mv_sas.c 1176:phy 1 attach sas addr is 1
[   11.381501] drivers/scsi/mvsas/mv_sas.c 1174:phy 2 attach dev info is 0
[   11.381503] drivers/scsi/mvsas/mv_sas.c 1176:phy 2 attach sas addr is 2
[   11.582085] drivers/scsi/mvsas/mv_sas.c 1174:phy 3 attach dev info is 0
[   11.582088] drivers/scsi/mvsas/mv_sas.c 1176:phy 3 attach sas addr is 3
[   11.782673] drivers/scsi/mvsas/mv_sas.c 1174:phy 4 attach dev info is 0
[   11.782676] drivers/scsi/mvsas/mv_sas.c 1176:phy 4 attach sas addr is 4
[   11.983262] drivers/scsi/mvsas/mv_sas.c 1174:phy 5 attach dev info is 800
[   11.983265] drivers/scsi/mvsas/mv_sas.c 1176:phy 5 attach sas addr is 5
[   12.183856] drivers/scsi/mvsas/mv_sas.c 1174:phy 6 attach dev info is 4
[   12.183858] drivers/scsi/mvsas/mv_sas.c 1176:phy 6 attach sas addr is 6
[   12.384438] drivers/scsi/mvsas/mv_sas.c 1174:phy 7 attach dev info is 0
[   12.384441] drivers/scsi/mvsas/mv_sas.c 1176:phy 7 attach sas addr is 7
[   12.384447] scsi6 : mvsas
[   12.385479] drivers/scsi/mvsas/mv_sas.c 277:phy 0 byte dmaded.
[   12.385482] drivers/scsi/mvsas/mv_sas.c 277:phy 1 byte dmaded.
[   12.385488] drivers/scsi/mvsas/mv_sas.c 277:phy 2 byte dmaded.
[   12.385491] drivers/scsi/mvsas/mv_sas.c 277:phy 3 byte dmaded.
[   12.385494] drivers/scsi/mvsas/mv_sas.c 277:phy 4 byte dmaded.
[   12.385497] drivers/scsi/mvsas/mv_sas.c 277:phy 5 byte dmaded.
[   12.385500] drivers/scsi/mvsas/mv_sas.c 277:phy 6 byte dmaded.
[   12.385503] drivers/scsi/mvsas/mv_sas.c 277:phy 7 byte dmaded.
[   12.385614] sas: phy-6:0 added to port-6:0, phy_mask:0x1 (               0)
[   12.385667] sas: phy-6:1 added to port-6:1, phy_mask:0x2 ( 100000000000000)
[   12.385716] sas: phy-6:2 added to port-6:2, phy_mask:0x4 ( 200000000000000)
[   12.385759] sas: phy-6:3 added to port-6:3, phy_mask:0x8 ( 300000000000000)
[   12.385801] sas: phy-6:4 added to port-6:4, phy_mask:0x10 ( 400000000000000)
[   12.385851] sas: phy-6:5 added to port-6:5, phy_mask:0x20 ( 500000000000000)
[   12.385895] sas: phy-6:6 added to port-6:6, phy_mask:0x40 ( 600000000000000)
[   12.385942] sas: phy-6:7 added to port-6:7, phy_mask:0x80 ( 700000000000000)
[   12.385967] sas: DOING DISCOVERY on port 0, pid:847
[   12.385974] sas: DONE DISCOVERY on port 0, pid:847, result:0
[   12.385986] sas: DOING DISCOVERY on port 1, pid:847
[   12.385991] sas: DONE DISCOVERY on port 1, pid:847, result:0
[   12.386003] sas: DOING DISCOVERY on port 2, pid:847
[   12.386009] sas: DONE DISCOVERY on port 2, pid:847, result:0
[   12.386020] sas: DOING DISCOVERY on port 3, pid:847
[   12.386029] sas: DONE DISCOVERY on port 3, pid:847, result:0
[   12.386041] sas: DOING DISCOVERY on port 4, pid:847
[   12.386048] sas: DONE DISCOVERY on port 4, pid:847, result:0
[   12.386060] sas: DOING DISCOVERY on port 5, pid:847
[   12.386066] sas: DONE DISCOVERY on port 5, pid:847, result:0
[   12.386077] sas: DOING DISCOVERY on port 6, pid:847
[   12.386083] sas: DONE DISCOVERY on port 6, pid:847, result:0
[   12.386095] sas: DOING DISCOVERY on port 7, pid:847
[   12.386101] sas: DONE DISCOVERY on port 7, pid:847, result:0
[   12.386188] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
[   12.386281] sas: ata7: end_device-6:0: dev error handler
[   12.537987] ata7.00: ATA-8: ST33000650NS, 0004, max UDMA/133
[   12.537992] ata7.00: 5860533168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[   12.538227] drivers/scsi/mvsas/mv_sas.c 1857:port 0 slot 0 rx_desc
20000 has error info0000000081000000.
[   12.538256] ata7.00: failed to get Identify Device Data, Emask 0x1
[   12.539467] drivers/scsi/mvsas/mv_sas.c 1857:port 0 slot 0 rx_desc
20000 has error info0000000081000000.
[   12.539496] ata7.00: failed to get Identify Device Data, Emask 0x1
[   12.539504] ata7.00: configured for UDMA/133
[   12.539611] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
[   12.550707] scsi 6:0:0:0: Direct-Access     ATA      ST33000650NS
  0004 PQ: 0 ANSI: 5
[   12.550800] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
[   12.550893] sas: ata7: end_device-6:0: dev error handler
[   12.550983] sas: ata8: end_device-6:1: dev error handler
[   12.702637] drivers/scsi/mvsas/mv_sas.c 1857:port 1 slot 0 rx_desc
20000 has error info0000000081000000.
[   12.702667] ata8.00: both IDENTIFYs aborted, assuming NODEV
[   12.702766] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
[   12.714341] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
[   12.714418] sas: ata7: end_device-6:0: dev error handler
[   12.714435] sas: ata8: end_device-6:1: dev error handler
[   12.714440] sas: ata9: end_device-6:2: dev error handler
[   12.865290] drivers/scsi/mvsas/mv_sas.c 1857:port 2 slot 0 rx_desc
20000 has error info0000000081000000.
[   12.865319] ata9.00: both IDENTIFYs aborted, assuming NODEV
[   12.865423] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
[   12.876995] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
[   12.877094] sas: ata7: end_device-6:0: dev error handler
[   12.877111] sas: ata8: end_device-6:1: dev error handler
[   12.877118] sas: ata9: end_device-6:2: dev error handler
[   12.877123] sas: ata10: end_device-6:3: dev error handler
[   13.027975] drivers/scsi/mvsas/mv_sas.c 1857:port 3 slot 0 rx_desc
20000 has error info0000000081000000.
[   13.028004] ata10.00: both IDENTIFYs aborted, assuming NODEV
[   13.028098] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
[   13.039653] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
[   13.039731] sas: ata7: end_device-6:0: dev error handler
[   13.039747] sas: ata8: end_device-6:1: dev error handler
[   13.039754] sas: ata9: end_device-6:2: dev error handler
[   13.039760] sas: ata10: end_device-6:3: dev error handler
[   13.039765] sas: ata11: end_device-6:4: dev error handler
[   13.195528] drivers/scsi/mvsas/mv_sas.c 1857:port 4 slot 0 rx_desc
20000 has error info0000000081000000.
[   13.195557] ata11.00: both IDENTIFYs aborted, assuming NODEV
[   13.195664] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
[   13.207297] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
[   13.207392] sas: ata7: end_device-6:0: dev error handler
[   13.207409] sas: ata8: end_device-6:1: dev error handler
[   13.207417] sas: ata9: end_device-6:2: dev error handler
[   13.207422] sas: ata10: end_device-6:3: dev error handler
[   13.207427] sas: ata11: end_device-6:4: dev error handler
[   13.207432] sas: ata12: end_device-6:5: dev error handler
[   13.360919] drivers/scsi/mvsas/mv_sas.c 1857:port 5 slot 0 rx_desc
20000 has error info0000000081000000.
[   13.360949] ata12.00: both IDENTIFYs aborted, assuming NODEV
[   13.361059] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
[   13.371980] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
[   13.372076] sas: ata7: end_device-6:0: dev error handler
[   13.372092] sas: ata8: end_device-6:1: dev error handler
[   13.372099] sas: ata9: end_device-6:2: dev error handler
[   13.372105] sas: ata10: end_device-6:3: dev error handler
[   13.372110] sas: ata11: end_device-6:4: dev error handler
[   13.372115] sas: ata12: end_device-6:5: dev error handler
[   13.372119] sas: ata13: end_device-6:6: dev error handler
[   13.525785] drivers/scsi/mvsas/mv_sas.c 1857:port 6 slot 0 rx_desc
20000 has error info0000000081000000.
[   13.525814] ata13.00: both IDENTIFYs aborted, assuming NODEV
[   13.525919] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
[   13.537549] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
[   13.537606] sas: ata7: end_device-6:0: dev error handler
[   13.537623] sas: ata8: end_device-6:1: dev error handler
[   13.537630] sas: ata9: end_device-6:2: dev error handler
[   13.537635] sas: ata10: end_device-6:3: dev error handler
[   13.537640] sas: ata11: end_device-6:4: dev error handler
[   13.537645] sas: ata12: end_device-6:5: dev error handler
[   13.537650] sas: ata13: end_device-6:6: dev error handler
[   13.537655] sas: ata14: end_device-6:7: dev error handler
[   13.692779] drivers/scsi/mvsas/mv_sas.c 1857:port 7 slot 0 rx_desc
20000 has error info0000000081000000.
[   13.692808] ata14.00: both IDENTIFYs aborted, assuming NODEV
[   13.692917] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
[   13.704396] sd 6:0:0:0: [sde] 5860533168 512-byte logical blocks:
(3.00 TB/2.72 TiB)
[   13.704461] sd 6:0:0:0: [sde] Write Protect is off
[   13.704466] sd 6:0:0:0: [sde] Mode Sense: 00 3a 00 00
[   13.704492] sd 6:0:0:0: [sde] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   13.704589] sd 6:0:0:0: Attached scsi generic sg4 type 0
[   13.742800]  sde: sde1
[   13.743201] sd 6:0:0:0: [sde] Attached SCSI disk
[   14.848140] bio: create slab <bio-1> at 1

--20cf302efa686ae1d504d172b1e9
Content-Type: application/x-gzip; name="config-3.7.1-gentoo.gz"
Content-Disposition: attachment; filename="config-3.7.1-gentoo.gz"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hb0wlid40

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
--20cf302efa686ae1d504d172b1e9--
