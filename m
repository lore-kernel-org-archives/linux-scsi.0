From: =?UTF-8?B?RMSBdmlzIE1vc8SBbnM=?= <davispuh@gmail.com>
Subject: Re: How to increase RAID/HBA controller's timeout?
Date: Tue, 4 Oct 2016 20:08:53 +0300
Message-ID: <CAOE4rSzM8pkR8Dex-cEJ6Oaym4RU47Vb3mFbZDTUnPCQE6bGoQ@mail.gmail.com>
References: <CAOE4rSwrEBPHqXoyHbd2a6PTYp9ZnP=KXB7chOCfj0Q1MJfy2A@mail.gmail.com>
 <1a59730f-e489-86ce-b01a-fcb3c85a4b4d@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:33017 "EHLO
        mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753935AbcJDRJA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Oct 2016 13:09:00 -0400
Received: by mail-io0-f176.google.com with SMTP id r145so159759161ior.0
        for <linux-scsi@vger.kernel.org>; Tue, 04 Oct 2016 10:08:54 -0700 (PDT)
In-Reply-To: <1a59730f-e489-86ce-b01a-fcb3c85a4b4d@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> Well, this looks more like the ATA error recovery not working properly;
> libata-eh is trying to reset the link (that's the 'hard resetting link'
> message), but after that the device doesn't respond (that's the 'failed
> to IDENTIFY' message).
> So it's not so much a wrong timeout, it's a wrong EH implementation.
> We would need to check why mvsas hard reset is not working; I've seen a
> similar issue on isci, but haven't been able to debug things properly.
> So it might even be a generic libsas EH issue, and not related to mvsas
> at all.
>

Thanks! Sadly I'm not familiar at all with this logic, what should I
read up to be able to understand and investigate it more? When I'll
have time I'll look into it. For now, I'll read from
Documentation/scsi/*
Also I need to update kernel first because this here right now is
quite old one 4.6.2, maybe it's already fixed, but I've had seen this
since atleast 4.2

Here a bit different log, but still same issue.

[33537.921685] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[33537.921693] sas: trying to find task 0xffff880423288700
[33537.921697] sas: sas_scsi_find_task: aborting task 0xffff880423288700
[33537.921702] /mnt/linux/drivers/scsi/mvsas/mv_sas.c
1540:mvs_abort_task() mvi=ffff880607840000 task=ffff880423288700
slot=ffff8806078655b8 slot_idx=x0
[33537.921708] sas: sas_scsi_find_task: task 0xffff880423288700 is aborted
[33537.921710] sas: sas_eh_handle_sas_errors: task 0xffff880423288700 is aborted
[33537.921717] sas: ata23: end_device-7:4: cmd error handler
[33537.921755] sas: ata7: end_device-7:0: dev error handler
[33537.921779] sas: ata8: end_device-7:1: dev error handler
[33537.921794] sas: ata22: end_device-7:2: dev error handler
[33537.921807] sas: ata10: end_device-7:3: dev error handler
[33537.921833] sas: ata23: end_device-7:4: dev error handler
[33537.921835] sas: ata12: end_device-7:5: dev error handler
[33537.921846] sas: ata21: end_device-7:7: dev error handler
[33537.921852] sas: ata13: end_device-7:6: dev error handler
[33537.921870] ata23.00: exception Emask 0x0 SAct 0x4000 SErr 0x0
action 0x6 frozen
[33537.921877] ata23.00: failed command: READ FPDMA QUEUED
[33537.921886] ata23.00: cmd 60/00:00:80:9f:ab/02:00:43:01:00/40 tag
14 ncq 262144 in
                        res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[33537.921892] ata23.00: status: { DRDY }
[33537.921898] ata23: hard resetting link
[33537.931932] /mnt/linux/drivers/scsi/mvsas/mv_sas.c 1975:phy 4 ctrl
sts=0x00000000.
[33537.931936] /mnt/linux/drivers/scsi/mvsas/mv_sas.c 1977:phy 4 irq
sts = 0x00000001
[33537.931972] /mnt/linux/drivers/scsi/mvsas/mv_sas.c 1975:phy 4 ctrl
sts=0x00122000.
[33537.931984] /mnt/linux/drivers/scsi/mvsas/mv_sas.c 1977:phy 4 irq
sts = 0x00000081
[33537.949987] /mnt/linux/drivers/scsi/mvsas/mv_sas.c 1975:phy 4 ctrl
sts=0x00122000.
[33537.950000] /mnt/linux/drivers/scsi/mvsas/mv_sas.c 1977:phy 4 irq
sts = 0x00010000
[33537.950007] /mnt/linux/drivers/scsi/mvsas/mv_sas.c 2026:notify plug
in on phy[0]
[33537.970026] /mnt/linux/drivers/scsi/mvsas/mv_94xx.c 884:get all reg
link rate is 0x122000
[33537.970035] /mnt/linux/drivers/scsi/mvsas/mv_94xx.c 889:get link rate is 10
[33538.090081] /mnt/linux/drivers/scsi/mvsas/mv_sas.c 1079:phy 4
attach dev info is 20001
[33538.090089] /mnt/linux/drivers/scsi/mvsas/mv_sas.c 1081:phy 4
attach sas addr is 4
[33538.090111] /mnt/linux/drivers/scsi/mvsas/mv_sas.c 277:phy 4 byte dmaded.
[33538.090196] sas: sas_form_port: phy0 belongs to port4 already(1)!
[33540.138362] /mnt/linux/drivers/scsi/mvsas/mv_sas.c
1430:mvs_I_T_nexus_reset for device[0]:rc= 0
[33540.291688] /mnt/linux/drivers/scsi/mvsas/mv_sas.c 1771:port 4 slot
0 rx_desc 30000 has error info8000000080000000.
[33545.291735] ata23.00: qc timeout (cmd 0x27)
[33545.291746] /mnt/linux/drivers/scsi/mvsas/mv_sas.c
1540:mvs_abort_task() mvi=ffff880607840000 task=ffff88027c093600
slot=ffff8806078655b8 slot_idx=x0
[33545.291755] ata23.00: failed to read native max address (err_mask=0x4)
[33545.291758] ata23.00: HPA support seems broken, skipping HPA handling
[33545.291762] ata23.00: revalidation failed (errno=-5)
[33545.291770] ata23: hard resetting link
[33545.301800] /mnt/linux/drivers/scsi/mvsas/mv_sas.c 1975:phy 4 ctrl
sts=0x00000000.
[33545.301808] /mnt/linux/drivers/scsi/mvsas/mv_sas.c 1977:phy 4 irq
sts = 0x00000001
[33545.301840] /mnt/linux/drivers/scsi/mvsas/mv_sas.c 1975:phy 4 ctrl
sts=0x00122000.
[33545.301846] /mnt/linux/drivers/scsi/mvsas/mv_sas.c 1977:phy 4 irq
sts = 0x00000081
[33545.353623] /mnt/linux/drivers/scsi/mvsas/mv_sas.c 1975:phy 4 ctrl
sts=0x00122000.
[33545.353638] /mnt/linux/drivers/scsi/mvsas/mv_sas.c 1977:phy 4 irq
sts = 0x00010000
[33545.353644] /mnt/linux/drivers/scsi/mvsas/mv_sas.c 2026:notify plug
in on phy[0]
[33545.373664] /mnt/linux/drivers/scsi/mvsas/mv_94xx.c 884:get all reg
link rate is 0x122000
[33545.373672] /mnt/linux/drivers/scsi/mvsas/mv_94xx.c 889:get link rate is 10
[33545.493717] /mnt/linux/drivers/scsi/mvsas/mv_sas.c 1079:phy 4
attach dev info is 20001
[33545.493722] /mnt/linux/drivers/scsi/mvsas/mv_sas.c 1081:phy 4
attach sas addr is 4
[33545.493734] /mnt/linux/drivers/scsi/mvsas/mv_sas.c 277:phy 4 byte dmaded.
[33545.493757] sas: sas_form_port: phy0 belongs to port4 already(1)!
[33547.508415] /mnt/linux/drivers/scsi/mvsas/mv_sas.c
1430:mvs_I_T_nexus_reset for device[0]:rc= 0
[33547.661805] /mnt/linux/drivers/scsi/mvsas/mv_sas.c 1771:port 4 slot
0 rx_desc 30000 has error info8000000080000000.
[33562.662110] ata23.00: qc timeout (cmd 0xef)
[33562.662121] /mnt/linux/drivers/scsi/mvsas/mv_sas.c
1540:mvs_abort_task() mvi=ffff880607840000 task=ffff88060ef85600
slot=ffff8806078655b8 slot_idx=x0
[33562.662130] ata23.00: failed to set xfermode (err_mask=0x4)
[33562.662136] ata23.00: limiting speed to UDMA/133:PIO3
[33562.662142] ata23: hard resetting link
[33562.672285] /mnt/linux/drivers/scsi/mvsas/mv_sas.c 1975:phy 4 ctrl
sts=0x00000000.
[33562.672295] /mnt/linux/drivers/scsi/mvsas/mv_sas.c 1977:phy 4 irq
sts = 0x00000001
[33562.672327] /mnt/linux/drivers/scsi/mvsas/mv_sas.c 1975:phy 4 ctrl
sts=0x00122000.
[33562.672334] /mnt/linux/drivers/scsi/mvsas/mv_sas.c 1977:phy 4 irq
sts = 0x00000081
[33562.698584] /mnt/linux/drivers/scsi/mvsas/mv_sas.c 1975:phy 4 ctrl
sts=0x00122000.
[33562.698599] /mnt/linux/drivers/scsi/mvsas/mv_sas.c 1977:phy 4 irq
sts = 0x00010000
[33562.698606] /mnt/linux/drivers/scsi/mvsas/mv_sas.c 2026:notify plug
in on phy[0]
[33562.718624] /mnt/linux/drivers/scsi/mvsas/mv_94xx.c 884:get all reg
link rate is 0x122000
[33562.718633] /mnt/linux/drivers/scsi/mvsas/mv_94xx.c 889:get link rate is 10
[33562.838683] /mnt/linux/drivers/scsi/mvsas/mv_sas.c 1079:phy 4
attach dev info is 20001
[33562.838692] /mnt/linux/drivers/scsi/mvsas/mv_sas.c 1081:phy 4
attach sas addr is 4
[33562.838704] /mnt/linux/drivers/scsi/mvsas/mv_sas.c 277:phy 4 byte dmaded.
[33562.838725] sas: sas_form_port: phy0 belongs to port4 already(1)!
[33564.878817] /mnt/linux/drivers/scsi/mvsas/mv_sas.c
1430:mvs_I_T_nexus_reset for device[0]:rc= 0
[33565.032192] /mnt/linux/drivers/scsi/mvsas/mv_sas.c 1771:port 4 slot
0 rx_desc 30000 has error info8000000080000000.
[33580.032378] ata23.00: qc timeout (cmd 0xef)
[33580.032387] /mnt/linux/drivers/scsi/mvsas/mv_sas.c
1540:mvs_abort_task() mvi=ffff880607840000 task=ffff88004678ab00
slot=ffff8806078655b8 slot_idx=x0
[33580.032394] ata23.00: failed to set xfermode (err_mask=0x4)
[33580.032399] ata23.00: disabled
[33580.032416] ata23.00: device reported invalid CHS sector 0
[33580.032425] ata23: hard resetting link
[33580.042467] /mnt/linux/drivers/scsi/mvsas/mv_sas.c 1975:phy 4 ctrl
sts=0x00000000.
[33580.042486] /mnt/linux/drivers/scsi/mvsas/mv_sas.c 1977:phy 4 irq
sts = 0x00000001
[33580.042513] /mnt/linux/drivers/scsi/mvsas/mv_sas.c 1975:phy 4 ctrl
sts=0x00122000.
[33580.042518] /mnt/linux/drivers/scsi/mvsas/mv_sas.c 1977:phy 4 irq
sts = 0x00000081
[33580.063180] /mnt/linux/drivers/scsi/mvsas/mv_sas.c 1975:phy 4 ctrl
sts=0x00122000.
[33580.063186] /mnt/linux/drivers/scsi/mvsas/mv_sas.c 1977:phy 4 irq
sts = 0x00010000
[33580.063190] /mnt/linux/drivers/scsi/mvsas/mv_sas.c 2026:notify plug
in on phy[0]
[33580.083201] /mnt/linux/drivers/scsi/mvsas/mv_94xx.c 884:get all reg
link rate is 0x122000
[33580.083204] /mnt/linux/drivers/scsi/mvsas/mv_94xx.c 889:get link rate is 10
[33580.203236] /mnt/linux/drivers/scsi/mvsas/mv_sas.c 1079:phy 4
attach dev info is 20001
[33580.203240] /mnt/linux/drivers/scsi/mvsas/mv_sas.c 1081:phy 4
attach sas addr is 4
[33580.203248] /mnt/linux/drivers/scsi/mvsas/mv_sas.c 277:phy 4 byte dmaded.
[33580.203281] sas: sas_form_port: phy0 belongs to port4 already(1)!
[33582.249047] /mnt/linux/drivers/scsi/mvsas/mv_sas.c
1430:mvs_I_T_nexus_reset for device[0]:rc= 0
[33582.402448] ata23: EH complete
[33582.402477] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
[33582.402538] sd 7:0:10:0: [sdp] tag#0 UNKNOWN(0x2003) Result:
hostbyte=0x04 driverbyte=0x00
[33582.402545] sd 7:0:10:0: [sdp] tag#0 CDB: opcode=0x88 88 00 00 00
00 01 43 ab 9f 80 00 00 02 00 00 00
[33582.402550] blk_update_request: I/O error, dev sdp, sector 5430288256
[33582.402698] sd 7:0:10:0: [sdp] Read Capacity(16) failed: Result:
hostbyte=0x04 driverbyte=0x00
[33582.402704] sd 7:0:10:0: [sdp] Sense not available.
[33582.402745] sd 7:0:10:0: [sdp] tag#0 UNKNOWN(0x2003) Result:
hostbyte=0x04 driverbyte=0x00
[33582.402755] sd 7:0:10:0: [sdp] tag#0 CDB: opcode=0x88 88 00 00 00
00 01 43 ab 9f 80 00 00 00 08 00 00
[33582.402760] blk_update_request: I/O error, dev sdp, sector 5430288256
[33582.402778] sd 7:0:10:0: [sdp] Read Capacity(10) failed: Result:
hostbyte=0x04 driverbyte=0x00
[33582.402784] sd 7:0:10:0: [sdp] Sense not available.
[33582.402903] sd 7:0:10:0: [sdp] tag#0 UNKNOWN(0x2003) Result:
hostbyte=0x04 driverbyte=0x00
[33582.402910] sdp: detected capacity change from 3000592982016 to 0
[33582.402913] sd 7:0:10:0: [sdp] tag#0 CDB: opcode=0x88 88 00 00 00
00 01 43 ab 9f 88 00 00 00 08 00 00
[33582.402918] blk_update_request: I/O error, dev sdp, sector 5430288264
[33585.106351] sd 7:0:10:0: [sdp] Read Capacity(16) failed: Result:
hostbyte=0x04 driverbyte=0x00
[33585.106357] sd 7:0:10:0: [sdp] Sense not available.
[33585.106423] sd 7:0:10:0: [sdp] Read Capacity(10) failed: Result:
hostbyte=0x04 driverbyte=0x00
[33585.106427] sd 7:0:10:0: [sdp] Sense not available.
