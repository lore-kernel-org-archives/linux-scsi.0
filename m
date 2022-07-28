Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BFEBC04A68
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jul 2022 19:03:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232879AbiG1TDZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jul 2022 15:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231520AbiG1TDY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jul 2022 15:03:24 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 869987393A
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jul 2022 12:03:20 -0700 (PDT)
Received: from fraeml707-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Lv0Lk0ddCz67xFD;
        Fri, 29 Jul 2022 02:59:26 +0800 (CST)
Received: from lhrpeml500003.china.huawei.com (7.191.162.67) by
 fraeml707-chm.china.huawei.com (10.206.15.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 28 Jul 2022 21:03:17 +0200
Received: from [10.126.174.188] (10.126.174.188) by
 lhrpeml500003.china.huawei.com (7.191.162.67) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 28 Jul 2022 20:03:16 +0100
Message-ID: <64826481-8b07-d81c-2482-ce7edc5b377a@huawei.com>
Date:   Thu, 28 Jul 2022 20:03:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [BUG] pm80xx crashing during SATA discovery
To:     Michal Grzedzicki <mge@fb.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
References: <658BED74-1C07-44E8-B1FA-2FBB5E3F5DF2@fb.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <658BED74-1C07-44E8-B1FA-2FBB5E3F5DF2@fb.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.174.188]
X-ClientProxiedBy: lhreml724-chm.china.huawei.com (10.201.108.75) To
 lhrpeml500003.china.huawei.com (7.191.162.67)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 28/07/2022 18:25, Michal Grzedzicki wrote:
> Hi,
> 
> I'm having trouble getting the pm80xx driver to discover SATA drives.
> Enclosure has both SAS and SATA drives and the controller is Adaptec Device 8074 (rev 06) on x86_64 machine.
> 
> Without ATA support in libsas, SAS drives alone are working correctly on 5.18.
> 
> After enabling ATA support the driver started crashing.
> With scsi_mod.scan=sync and high loglevel for pm80xx I was able to perform a couple
> of commands before the kernel crashed.
> 

Has this worked ok for any other recent kernel version? It seems that 
5.18 and 5.19-rcX are broken for you, but it would be good to know if 
your setup ever worked without issue. Damien (cc'ed) and I have been 
making changes to this driver and libsas recently but don't experience 
these sorts of problems.

> Applying "libsas and drivers: NCQ error handling" (https://patchwork.kernel.org/project/linux-scsi/list/?series=662216)
> series of patches prevents the driver from crashing but all operations are timing out.

That could be related to patch 1/6, where I think that you might 
experience a use-after-free (which that patch attempts to fix). Turning 
KASAN on should help detect (without my patch).

> 
> Bellow dmesg from the crashes.
> 
> Thanks,
> Michal
> 
> 5.19.0-rc8 with async scanning scsi_mod.scan=async
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> pm80xx 0000:06:00.0: pm80xx: driver version 0.1.40
> :: pm8001_pci_alloc 532: Setting link rate to default value
> scsi host6: pm80xx
> sas: phy-6:0 added to port-6:0, phy_mask:0x1 (500e004abbbbbb7f)
> sas: DOING DISCOVERY on port 0, pid:38
> sas: ex 500e004abbbbbb7f phy00:U:A attached: 500e004abbbbbb00 (stp)
> sas: ex 500e004abbbbbb7f phy01:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy02:U:A attached: 500e004abbbbbb02 (stp)
> sas: ex 500e004abbbbbb7f phy03:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy04:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy05:U:A attached: 500e004abbbbbb05 (stp)
> sas: ex 500e004abbbbbb7f phy06:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy07:U:A attached: 500e004abbbbbb07 (stp)
> sas: ex 500e004abbbbbb7f phy08:U:A attached: 500e004abbbbbb08 (stp)
> sas: ex 500e004abbbbbb7f phy09:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy10:U:A attached: 500e004abbbbbb0a (stp)
> sas: ex 500e004abbbbbb7f phy11:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy12:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy13:U:A attached: 500e004abbbbbb0d (stp)
> sas: ex 500e004abbbbbb7f phy14:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy15:U:A attached: 500e004abbbbbb0f (stp)
> sas: ex 500e004abbbbbb7f phy16:U:A attached: 500e004abbbbbb10 (stp)
> sas: ex 500e004abbbbbb7f phy17:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy18:U:A attached: 500e004abbbbbb12 (stp)
> sas: ex 500e004abbbbbb7f phy19:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy20:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy21:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy22:U:B attached: ffffffffffffffff (host)
> sas: ex 500e004abbbbbb7f phy23:U:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy24:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy25:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy26:U:1 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy27:U:1 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy28:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy29:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy30:U:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy31:U:1 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy32:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy33:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy34:U:1 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy35:U:1 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy36:D:B attached: 500e004abbbbbb7e (host+target)
> sas: Enter sas_scsi_recover_host busy: 0 failed: 0
> sas: ata7: end_device-6:0:0: dev error handler
> sas: ata8: end_device-6:0:2: dev error handler
> sas: ata9: end_device-6:0:5: dev error handler
> sas: ata10: end_device-6:0:7: dev error handler
> sas: ata11: end_device-6:0:8: dev error handler
> sas: ata12: end_device-6:0:10: dev error handler
> sas: ata13: end_device-6:0:13: dev error handler
> sas: ata14: end_device-6:0:15: dev error handler
> sas: ata15: end_device-6:0:16: dev error handler
> sas: ata16: end_device-6:0:18: dev error handler

looks ok so far

> ata11.00: ATA-9: HUH721010ALN600, LHGNT290, max UDMA/133
> ata8.00: ATA-9: HUH721010ALN600, LHGNT290, max UDMA/133
> ata7.00: ATA-9: HUH721010ALN600, LHGNT290, max UDMA/133
> ata9.00: ATA-9: HUH721010ALN600, LHGNT290, max UDMA/133
> ata10.00: ATA-9: HUH721010ALN600, LHGNT290, max UDMA/133
> ata15.00: ATA-9: HUH721010ALN600, LHGNT290, max UDMA/133
> ata15.00: 2441609216 sectors, multi 0: LBA48 NCQ (depth 32)
> ata15.00: Features: NCQ-sndrcv NCQ-prio
> ata15.00: configured for UDMA/133
> ata16.00: qc timeout (cmd 0xec)

this obviously doesn't look ok...

> ata14.00: qc timeout (cmd 0x27)
> ata12.00: qc timeout (cmd 0xec)
> ata13.00: qc timeout (cmd 0xec)
> ata12.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> ata13.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> pm80xx0:: mpi_sata_completion 2399: task or dev null
> ata16.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> pm80xx0:: mpi_sata_completion 2408: IO failed device_id 16395 status 0x1 tag 7
> pm80xx0:: mpi_sata_completion 2408: IO failed device_id 16393 status 0x1 tag 8
> pm80xx0:: mpi_sata_completion 2449: SAS Address of IO Failure Drive:500e004abbbbbb0f
> pm80xx0:: mpi_sata_completion 2765: task 0x00000000feaea166 done with io_status 0x1 resp 0x0 stat 0x8c but aborted by upper layer!
> ata14.00: failed to read native max address (err_mask=0x4)
> ata14.00: HPA support seems broken, skipping HPA handling
> pm80xx0:: mpi_sata_completion 2408: IO failed device_id 16392 status 0x1 tag 6
> pm80xx0:: mpi_sata_completion 2449: SAS Address of IO Failure Drive:500e004abbbbbb12
> pm80xx0:: mpi_sata_completion 2449: SAS Address of IO Failure Drive:500e004abbbbbb0d
> pm80xx0:: mpi_sata_completion 2765: task 0x0000000092c2ba1c done with io_status 0x1 resp 0x0 stat 0x8c but aborted by upper layer!
> pm80xx0:: mpi_sata_completion 2765: task 0x000000000861b6cc done with io_status 0x1 resp 0x0 stat 0x8c but aborted by upper layer!
> ata16.00: ATA-9: HUH721010ALN600, LHGNT290, max UDMA/133
> ata14.00: ATA-9: HUH721010ALN600, LHGNT290, max UDMA/133
> ata13.00: ATA-9: HUH721010ALN600, LHGNT290, max UDMA/133
> ata16.00: 2441609216 sectors, multi 0: LBA48 NCQ (depth 32)
> ata16.00: Features: NCQ-sndrcv NCQ-prio
> ata14.00: 2441609216 sectors, multi 0: LBA48 NCQ (depth 32)
> ata14.00: Features: NCQ-sndrcv NCQ-prio
> ata13.00: 2441609216 sectors, multi 0: LBA48 NCQ (depth 32)
> ata13.00: Features: NCQ-sndrcv NCQ-prio
> ata14.00: configured for UDMA/133
> ata13.00: configured for UDMA/133
> ata11.00: qc timeout (cmd 0x2f)
> ata8.00: qc timeout (cmd 0x2f)
> ata9.00: qc timeout (cmd 0x2f)
> ata7.00: qc timeout (cmd 0x2f)
> ata10.00: qc timeout (cmd 0x2f)
> ata11.00: Read log 0x00 page 0x00 failed, Emask 0x4
> ata11.00: NCQ Send/Recv Log not supported
> ata11.00: Read log 0x00 page 0x00 failed, Emask 0x40
> ata11.00: failed to set xfermode (err_mask=0x40)
> ata7.00: Read log 0x13 page 0x00 failed, Emask 0x4
> ata8.00: Read log 0x00 page 0x00 failed, Emask 0x4
> ata9.00: Read log 0x00 page 0x00 failed, Emask 0x4
> ata8.00: NCQ Send/Recv Log not supported
> ata8.00: Read log 0x00 page 0x00 failed, Emask 0x40
> ata8.00: NCQ Send/Recv Log not supported
> ata8.00: Read log 0x00 page 0x00 failed, Emask 0x40
> ata8.00: failed to set xfermode (err_mask=0x40)
> ata10.00: Read log 0x00 page 0x00 failed, Emask 0x4
> ata10.00: NCQ Send/Recv Log not supported
> ata10.00: Read log 0x00 page 0x00 failed, Emask 0x40
> ata10.00: NCQ Send/Recv Log not supported
> ata10.00: Read log 0x00 page 0x00 failed, Emask 0x40
> ata10.00: failed to set xfermode (err_mask=0x40)
> ata7.00: Read log 0x00 page 0x00 failed, Emask 0x40
> ata9.00: NCQ Send/Recv Log not supported
> ata9.00: Read log 0x00 page 0x00 failed, Emask 0x40
> ata7.00: NCQ Send/Recv Log not supported
> ata7.00: Read log 0x00 page 0x00 failed, Emask 0x40
> ata9.00: NCQ Send/Recv Log not supported
> ata9.00: Read log 0x00 page 0x00 failed, Emask 0x40
> ata7.00: failed to set xfermode (err_mask=0x40)
> ata9.00: failed to set xfermode (err_mask=0x40)
> ata12.00: qc timeout (cmd 0xec)
> ata12.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> ata11.00: qc timeout (cmd 0x2f)
> ata8.00: qc timeout (cmd 0x2f)
> ata9.00: qc timeout (cmd 0x2f)
> ata7.00: qc timeout (cmd 0x2f)
> ata10.00: qc timeout (cmd 0x2f)
> pm80xx0:: mpi_sata_completion 2408: IO failed device_id 16390 status 0x1 tag 2
> pm80xx0:: mpi_sata_completion 2449: SAS Address of IO Failure Drive:500e004abbbbbb08
> pm80xx0:: mpi_sata_completion 2765: task 0x0000000022cdc277 done with io_status 0x1 resp 0x0 stat 0x8c but aborted by upper layer!
> pm80xx0:: mpi_sata_completion 2408: IO failed device_id 16387 status 0x1 tag 3
> pm80xx0:: mpi_sata_completion 2408: IO failed device_id 16388 status 0x1 tag 4
> pm80xx0:: mpi_sata_completion 2449: SAS Address of IO Failure Drive:500e004abbbbbb05
> pm80xx0:: mpi_sata_completion 2765: task 0x000000006b9bef9f done with io_status 0x1 resp 0x0 stat 0x8c but aborted by upper layer!
> pm80xx0:: mpi_sata_completion 2408: IO failed device_id 16386 status 0x1 tag 5
> ata11.00: Read log 0x00 page 0x00 failed, Emask 0x4
> ata11.00: NCQ Send/Recv Log not supported
> ata11.00: Read log 0x00 page 0x00 failed, Emask 0x40
> ata11.00: 2441609216 sectors, multi 0: LBA48 NCQ (depth 32)
> ata11.00: Features: NCQ-sndrcv
> pm80xx0:: mpi_sata_completion 2408: IO failed device_id 16389 status 0x1 tag 1
> pm80xx0:: mpi_sata_completion 2449: SAS Address of IO Failure Drive:500e004abbbbbb07
> pm80xx0:: mpi_sata_completion 2765: task 0x00000000a19c8b91 done with io_status 0x1 resp 0x0 stat 0x8c but aborted by upper layer!
> ata11.00: failed to set xfermode (err_mask=0x40)
> pm80xx0:: mpi_sata_completion 2449: SAS Address of IO Failure Drive:500e004abbbbbb02
> pm80xx0:: mpi_sata_completion 2449: SAS Address of IO Failure Drive:500e004abbbbbb00
> pm80xx0:: mpi_sata_completion 2765: task 0x00000000bfb098ed done with io_status 0x1 resp 0x0 stat 0x8c but aborted by upper layer!
> pm80xx0:: mpi_sata_completion 2765: task 0x00000000c5b5a866 done with io_status 0x1 resp 0x0 stat 0x8c but aborted by upper layer!
> ata7.00: Read log 0x13 page 0x00 failed, Emask 0x4
> ata8.00: Read log 0x00 page 0x00 failed, Emask 0x4
> ata9.00: Read log 0x00 page 0x00 failed, Emask 0x4
> ata8.00: NCQ Send/Recv Log not supported
> ata8.00: Read log 0x00 page 0x00 failed, Emask 0x40
> ata8.00: NCQ Send/Recv Log not supported
> ata8.00: Read log 0x00 page 0x00 failed, Emask 0x40
> ata8.00: 2441609216 sectors, multi 0: LBA48 NCQ (depth 32)
> ata8.00: failed to set xfermode (err_mask=0x40)
> ata10.00: Read log 0x00 page 0x00 failed, Emask 0x4
> ata10.00: NCQ Send/Recv Log not supported
> ata10.00: Read log 0x00 page 0x00 failed, Emask 0x40
> ata10.00: NCQ Send/Recv Log not supported
> ata10.00: Read log 0x00 page 0x00 failed, Emask 0x40
> ata10.00: 2441609216 sectors, multi 0: LBA48 NCQ (depth 32)
> ata10.00: failed to set xfermode (err_mask=0x40)
> ata7.00: Read log 0x00 page 0x00 failed, Emask 0x40
> ata9.00: NCQ Send/Recv Log not supported
> ata9.00: Read log 0x00 page 0x00 failed, Emask 0x40
> ata7.00: NCQ Send/Recv Log not supported
> ata7.00: Read log 0x00 page 0x00 failed, Emask 0x40
> ata7.00: 2441609216 sectors, multi 0: LBA48 NCQ (depth 32)
> ata9.00: NCQ Send/Recv Log not supported
> ata9.00: Read log 0x00 page 0x00 failed, Emask 0x40
> ata7.00: failed to set xfermode (err_mask=0x40)
> ata9.00: 2441609216 sectors, multi 0: LBA48 NCQ (depth 32)
> ata9.00: failed to set xfermode (err_mask=0x40)
> ata12.00: qc timeout (cmd 0xec)
> pm80xx0:: mpi_sata_completion 2408: IO failed device_id 16391 status 0x1 tag 10
> ata12.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> pm80xx0:: mpi_sata_completion 2449: SAS Address of IO Failure Drive:500e004abbbbbb0a
> pm80xx0:: mpi_sata_completion 2765: task 0x00000000b1e970f8 done with io_status 0x1 resp 0x0 stat 0x8c but aborted by upper layer!
> ata10.00: configured for UDMA/133
> ata7.00: configured for UDMA/133
> ata9.00: configured for UDMA/133
> ata16.00: qc timeout (cmd 0xef)        root@(none)
> ata16.00: failed to set xfermode (err_mask=0x4)
> ata16.00: limiting speed to UDMA/133:PIO3
> ata12.00: ATA-9: HUH721010ALN600, LHGNT290, max UDMA/133
> ata12.00: 2441609216 sectors, multi 0: LBA48 NCQ (depth 32)
> ata12.00: Features: NCQ-sndrcv NCQ-prio
> ata12.00: configured for UDMA/133
> ata16.00: qc timeout (cmd 0xef)
> pm80xx0:: mpi_sata_completion 2408: IO failed device_id 16395 status 0x1 tag 7
> pm80xx0:: mpi_sata_completion 2449: SAS Address of IO Failure Drive:500e004abbbbbb12
> pm80xx0:: mpi_sata_completion 2765: task 0x000000008b36b8fe done with io_status 0x1 resp 0x0 stat 0x8c but aborted by upper layer!
> ata16.00: failed to set xfermode (err_mask=0x4)
> ata16.00: limiting speed to UDMA/133:PIO3
> ata8.00: qc timeout (cmd 0xec)
> ata11.00: qc timeout (cmd 0x27)
> ata8.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> ata11.00: failed to read native max address (err_mask=0x4)
> ata11.00: HPA support seems broken, skipping HPA handling
> ata11.00: revalidation failed (errno=-5)
> ata8.00: revalidation failed (errno=-5)
> general protection fault, probably for non-canonical address 0xfec03cb3fec337d7: 0000 [#1] PREEMPT SMP
> CPU: 3 PID: 62 Comm: kworker/3:2 Not tainted 5.19.0-rc8 #1
> Workqueue: events_power_efficient neigh_periodic_work
> RIP: 0010:queued_spin_lock_slowpath+0x24d/0x290
> Code: 8b 0a 48 85 c9 74 f6 e9 ed fe ff ff c1 e9 12 83 e0 03 83 e9 01 48 c1 e0 04 48 63 c9 48 05 80 fc 02 00 48 03 04 cd 80 d8 79 82 <48> 89 10 8b 42 08 85 c0 75 09 f3 90 8b 42 08 85 a
> RSP: 0018:ffffc90000174e50 EFLAGS: 00010086
> RAX: fec03cb3fec337d7 RBX: ffff888436c74330 RCX: 0000000000000db0
> RDX: ffff88843fdafc80 RSI: ffffffff826b1de1 RDI: ffffffff826bcf6d
> RBP: ffff88843fdafc80 R08: 0000000000000020 R09: 0000000436c79380
> R10: 000000000000002c R11: ffffc90000174cf0 R12: 0000000000100000
> R13: 0000000000100000 R14: 0000000000000000 R15: ffff888436063c00
> FS:  0000000000000000(0000) GS:ffff88843fd80000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000c000241000 CR3: 0000000102a1e001 CR4: 00000000003706e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>   <IRQ>
>   _raw_spin_lock_irqsave+0x34/0x40
>   complete+0x18/0x50
>   process_oq+0x901/0x1fa0 [pm80xx]
>   ? enqueue_task_fair+0x93/0x5d0
>   pm80xx_chip_isr+0x2d/0x90 [pm80xx]
>   tasklet_action_common.isra.22+0x12d/0x130
>   __do_softirq+0xe2/0x2c3
>   do_softirq+0x79/0x90
>   </IRQ>
>   <TASK>
>   __local_bh_enable_ip+0x66/0x70
>   process_one_work+0x1ee/0x3c0
>   ? process_one_work+0x3c0/0x3c0
>   worker_thread+0x2a/0x3b0
>   ? process_one_work+0x3c0/0x3c0
>   kthread+0xe6/0x110
>   ? kthread_complete_and_exit+0x20/0x20
>   ret_from_fork+0x1f/0x30
>   </TASK>
> Modules linked in: pm80xx(+) libsas scsi_transport_sas loop tg3 virtio_rng virtio_net net_failover failover
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:queued_spin_lock_slowpath+0x24d/0x290
> Code: 8b 0a 48 85 c9 74 f6 e9 ed fe ff ff c1 e9 12 83 e0 03 83 e9 01 48 c1 e0 04 48 63 c9 48 05 80 fc 02 00 48 03 04 cd 80 d8 79 82 <48> 89 10 8b 42 08 85 c0 75 09 f3 90 8b 42 08 85 a
> RSP: 0018:ffffc90000174e50 EFLAGS: 00010086
> RAX: fec03cb3fec337d7 RBX: ffff888436c74330 RCX: 0000000000000db0
> RDX: ffff88843fdafc80 RSI: ffffffff826b1de1 RDI: ffffffff826bcf6d
> RBP: ffff88843fdafc80 R08: 0000000000000020 R09: 0000000436c79380
> R10: 000000000000002c R11: ffffc90000174cf0 R12: 0000000000100000
> R13: 0000000000100000 R14: 0000000000000000 R15: ffff888436063c00
> FS:  0000000000000000(0000) GS:ffff88843fd80000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000c000241000 CR3: 0000000102a1e001 CR4: 00000000003706e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> 
> 5.19.0-rc8 scsi_mod.scan=sync
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> pm80xx0:: mpi_sata_completion 2765: task 0x000000002e58d403 done with io_status 0x1 resp 0x0 stat 0x8c but aborted by upper layer!
> ata14.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> pm80xx0:: mpi_sata_completion 2408: IO failed device_id 16390 status 0x1 tag 2
> ata11.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> pm80xx0:: mpi_sata_completion 2444: SAS Address of IO Failure Drive:ffffffff0000001e
> pm80xx0:: mpi_sata_completion 2449: SAS Address of IO Failure Drive:500e004abbbbbb08
> pm80xx0:: mpi_sata_completion 2765: task 0x00000000ee89111a done with io_status 0x1 resp 0x0 stat 0x8c but aborted by upper layer!
> BUG: unable to handle page fault for address: ffffffff8107b530
> #PF: supervisor write access in kernel mode
> #PF: error_code(0x0003) - permissions violation
> PGD 43de0b067 P4D 43de0b067 PUD 43de0c063 PMD 43c0001e1
> Oops: 0003 [#1] PREEMPT SMP
> CPU: 3 PID: 0 Comm: swapper/3 Not tainted 5.19.0-rc8 #1
> RIP: 0010:queued_spin_lock_slowpath+0x24d/0x290
> Code: 8b 0a 48 85 c9 74 f6 e9 ed fe ff ff c1 e9 12 83 e0 03 83 e9 01 48 c1 e0 04 48 63 c9 48 05 80 fc 02 00 48 03 04 cd 80 d8 79 82 <48> 89 10 8b 42 08 85 c0 75 09 f3 90 8b 42 08 85 a
> RSP: 0018:ffffc90000174de8 EFLAGS: 00010086
> RAX: ffffffff8107b530 RBX: ffff888102a62630 RCX: 00000000000000a8
> RDX: ffff88843fdafc80 RSI: ffffffff826b1de1 RDI: ffffffff826bcf6d
> RBP: ffff88843fdafc80 R08: 0000000000000020 R09: 000000043792cac0
> R10: 000000000000002c R11: 0000000000000000 R12: 0000000000100000
> R13: 0000000000100000 R14: 0000000000000001 R15: ffff888436003c00
> FS:  0000000000000000(0000) GS:ffff88843fd80000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffffff8107b530 CR3: 0000000436f2d005 CR4: 00000000003706e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>   <IRQ>
>   _raw_spin_lock_irqsave+0x34/0x40
>   complete+0x18/0x50
>   mpi_sata_completion+0x12d/0x780 [pm80xx]
>   process_oq+0x901/0x1fa0 [pm80xx]
>   ? _raw_spin_unlock_irqrestore+0x1b/0x30
>   ? try_to_wake_up+0x93/0x590
>   pm80xx_chip_isr+0x2d/0x90 [pm80xx]
>   tasklet_action_common.isra.22+0x12d/0x130
>   __do_softirq+0xe2/0x2c3
>   irq_exit_rcu+0x8d/0xc0
>   common_interrupt+0xb9/0xd0
>   </IRQ>
>   <TASK>
>   asm_common_interrupt+0x22/0x40
> RIP: 0010:cpuidle_enter_state+0xc2/0x370
> Code: 48 89 c5 0f 1f 44 00 00 31 ff e8 a9 5f 6e ff 45 84 ff 74 12 9c 58 f6 c4 02 0f 85 6a 02 00 00 31 ff e8 c2 9a 73 ff fb 45 85 f6 <0f> 88 1a 01 00 00 49 63 d6 48 2b 2c 24 48 6b ca 8
> RSP: 0018:ffffc900000efe90 EFLAGS: 00000202
> RAX: ffff88843fd80000 RBX: ffffe8ffffd81700 RCX: 000000000000001f
> RDX: 00000014a764207f RSI: ffffffff826b1de1 RDI: ffffffff826bcf6d
> RBP: 00000014a764207f R08: 0000000000000004 R09: 000000000002e840
> R10: 0003fcb078c01faf R11: ffff88843fdadf84 R12: 0000000000000002
> R13: ffffffff8361ee60 R14: 0000000000000002 R15: 0000000000000000
>   cpuidle_enter+0x29/0x40
>   do_idle+0x1cd/0x210
>   cpu_startup_entry+0x19/0x20
>   start_secondary+0xf5/0x120
>   secondary_startup_64_no_verify+0xd3/0xdb
>   </TASK>
> Modules linked in: pm80xx(+) libsas scsi_transport_sas loop tg3 virtio_rng virtio_net net_failover failover
> CR2: ffffffff8107b530
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:queued_spin_lock_slowpath+0x24d/0x290
> Code: 8b 0a 48 85 c9 74 f6 e9 ed fe ff ff c1 e9 12 83 e0 03 83 e9 01 48 c1 e0 04 48 63 c9 48 05 80 fc 02 00 48 03 04 cd 80 d8 79 82 <48> 89 10 8b 42 08 85 c0 75 09 f3 90 8b 42 08 85 a
> RSP: 0018:ffffc90000174de8 EFLAGS: 00010086
> RAX: ffffffff8107b530 RBX: ffff888102a62630 RCX: 00000000000000a8
> RDX: ffff88843fdafc80 RSI: ffffffff826b1de1 RDI: ffffffff826bcf6d
> RBP: ffff88843fdafc80 R08: 0000000000000020 R09: 000000043792cac0
> R10: 000000000000002c R11: 0000000000000000 R12: 0000000000100000
> R13: 0000000000100000 R14: 0000000000000001 R15: ffff888436003c00
> FS:  0000000000000000(0000) GS:ffff88843fd80000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffffff8107b530 CR3: 0000000436f2d005 CR4: 00000000003706e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Kernel panic - not syncing: Fatal exception in interrupt
> 
> 
> 5.19 + libsas and drivers: NCQ error handling patchset
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> pm80xx 0000:06:00.0: pm80xx: driver version 0.1.40
> :: pm8001_pci_alloc 532: Setting link rate to default value
> scsi host6: pm80xx
> sas: phy-6:0 added to port-6:0, phy_mask:0x1 (500e004abbbbbb7f)
> sas: DOING DISCOVERY on port 0, pid:39
> sas: ex 500e004abbbbbb7f phy00:U:A attached: 500e004abbbbbb00 (stp)
> sas: ex 500e004abbbbbb7f phy01:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy02:U:A attached: 500e004abbbbbb02 (stp)
> sas: ex 500e004abbbbbb7f phy03:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy04:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy05:U:A attached: 500e004abbbbbb05 (stp)
> sas: ex 500e004abbbbbb7f phy06:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy07:U:A attached: 500e004abbbbbb07 (stp)
> sas: ex 500e004abbbbbb7f phy08:U:A attached: 500e004abbbbbb08 (stp)
> sas: ex 500e004abbbbbb7f phy09:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy10:U:A attached: 500e004abbbbbb0a (stp)
> sas: ex 500e004abbbbbb7f phy11:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy12:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy13:U:A attached: 500e004abbbbbb0d (stp)
> sas: ex 500e004abbbbbb7f phy14:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy15:U:A attached: 500e004abbbbbb0f (stp)
> sas: ex 500e004abbbbbb7f phy16:U:A attached: 500e004abbbbbb10 (stp)
> sas: ex 500e004abbbbbb7f phy17:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy18:U:A attached: 500e004abbbbbb12 (stp)
> sas: ex 500e004abbbbbb7f phy19:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy20:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy21:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy22:U:B attached: ffffffffffffffff (host)
> sas: ex 500e004abbbbbb7f phy23:U:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy24:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy25:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy26:U:1 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy27:U:1 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy28:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy29:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy30:U:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy31:U:1 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy32:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy33:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy34:U:1 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy35:U:1 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy36:D:B attached: 500e004abbbbbb7e (host+target)
> sas: Enter sas_scsi_recover_host busy: 0 failed: 0
> sas: ata7: end_device-6:0:0: dev error handler
> sas: ata8: end_device-6:0:2: dev error handler
> sas: ata9: end_device-6:0:5: dev error handler
> sas: ata10: end_device-6:0:7: dev error handler
> sas: ata11: end_device-6:0:8: dev error handler
> sas: ata12: end_device-6:0:10: dev error handler
> sas: ata13: end_device-6:0:13: dev error handler
> sas: ata14: end_device-6:0:15: dev error handler
> sas: ata15: end_device-6:0:16: dev error handler
> sas: ata16: end_device-6:0:18: dev error handler
> ata11.00: ATA-9: HUH721010ALN600, LHGNT290, max UDMA/133
> ata13.00: ATA-9: HUH721010ALN600, LHGNT290, max UDMA/133
> ata9.00: ATA-9: HUH721010ALN600, LHGNT290, max UDMA/133
> ata11.00: 2441609216 sectors, multi 0: LBA48 NCQ (depth 32)
> ata11.00: Features: NCQ-sndrcv NCQ-prio
> ata9.00: 2441609216 sectors, multi 0: LBA48 NCQ (depth 32)
> ata9.00: Features: NCQ-sndrcv NCQ-prio
> ata9.00: configured for UDMA/133
> ata7.00: ATA-9: HUH721010ALN600, LHGNT290, max UDMA/133
> ata7.00: 2441609216 sectors, multi 0: LBA48 NCQ (depth 32)
> ata7.00: Features: NCQ-sndrcv NCQ-prio
> ata15.00: ATA-9: HUH721010ALN600, LHGNT290, max UDMA/133
> ata15.00: 2441609216 sectors, multi 0: LBA48 NCQ (depth 32)
> ata15.00: Features: NCQ-sndrcv NCQ-prio
> ata7.00: configured for UDMA/133
> ata15.00: configured for UDMA/133
> ata13.00: 2441609216 sectors, multi 0: LBA48 NCQ (depth 32)
> ata13.00: Features: NCQ-sndrcv NCQ-prio
> ata11.00: configured for UDMA/133
> ata13.00: configured for UDMA/133
> ata8.00: qc timeout (cmd 0x27)
> ata12.00: qc timeout (cmd 0xec)
> ata14.00: qc timeout (cmd 0xec)
> ata16.00: qc timeout (cmd 0x27)
> ata10.00: qc timeout (cmd 0xec)
> pm80xx0:: mpi_sata_completion 2287: task null, freeing CCB tag 6
> pm80xx0:: mpi_sata_completion 2287: task null, freeing CCB tag 3
> ata16.00: failed to read native max address (err_mask=0x4)
> pm80xx0:: mpi_sata_completion 2287: task null, freeing CCB tag 4
> ata12.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> ata10.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> ata14.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> ata8.00: failed to read native max address (err_mask=0x4)
> pm80xx0:: mpi_sata_completion 2287: task null, freeing CCB tag 7
> ata8.00: HPA support seems broken, skipping HPA handling
> pm80xx0:: mpi_sata_completion 2287: task null, freeing CCB tag 2
> ata16.00: HPA support seems broken, skipping HPA handling
> ata8.00: ATA-9: HUH721010ALN600, LHGNT290, max UDMA/133
> ata14.00: ATA-9: HUH721010ALN600, LHGNT290, max UDMA/133
> ata10.00: ATA-9: HUH721010ALN600, LHGNT290, max UDMA/133
> ata14.00: 2441609216 sectors, multi 0: LBA48 NCQ (depth 32)
> ata14.00: Features: NCQ-sndrcv NCQ-prio
> ata10.00: 2441609216 sectors, multi 0: LBA48 NCQ (depth 32)
> ata10.00: Features: NCQ-sndrcv NCQ-prio
> ata14.00: configured for UDMA/133
> ata16.00: ATA-9: HUH721010ALN600, LHGNT290, max UDMA/133
> ata16.00: 2441609216 sectors, multi 0: LBA48 NCQ (depth 32)
> ata16.00: Features: NCQ-sndrcv NCQ-prio
> ata12.00: ATA-9: HUH721010ALN600, LHGNT290, max UDMA/133
> ata12.00: 2441609216 sectors, multi 0: LBA48 NCQ (depth 32)
> ata12.00: Features: NCQ-sndrcv NCQ-prio
> ata16.00: configured for UDMA/133
> ata8.00: 2441609216 sectors, multi 0: LBA48 NCQ (depth 32)
> ata8.00: Features: NCQ-sndrcv NCQ-prio
> ata12.00: configured for UDMA/133
> ata8.00: configured for UDMA/133
> ata10.00: qc timeout (cmd 0x2f)
> pm80xx0:: mpi_sata_completion 2287: task null, freeing CCB tag 2
> ata10.00: Read log 0x12 page 0x00 failed, Emask 0x4
> ata10.00: Read log 0x00 page 0x00 failed, Emask 0x40
> ata10.00: configured for UDMA/133
> ata10.00: configured for UDMA/133
> sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
> scsi 6:0:0:0: Direct-Access     ATA      HUH721010ALN600  T290 PQ: 0 ANSI: 5
> sd 6:0:0:0: [sdb] 2441609216 4096-byte logical blocks: (10.0 TB/9.10 TiB)
> sd 6:0:0:0: [sdb] Write Protect is off
> sd 6:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> sd 6:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
> sd 6:0:0:0: [sdb] Preferred minimum I/O size 4096 bytes
> scsi 6:0:1:0: Direct-Access     ATA      HUH721010ALN600  T290 PQ: 0 ANSI: 5
> sd 6:0:1:0: [sdc] 2441609216 4096-byte logical blocks: (10.0 TB/9.10 TiB)
> sd 6:0:1:0: [sdc] Write Protect is off
> sd 6:0:1:0: [sdc] Mode Sense: 00 3a 00 00
> sd 6:0:1:0: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
> scsi 6:0:2:0: Direct-Access     ATA      HUH721010ALN600  T290 PQ: 0 ANSI: 5
> sd 6:0:1:0: [sdc] Preferred minimum I/O size 4096 bytes
> sd 6:0:2:0: [sdd] 2441609216 4096-byte logical blocks: (10.0 TB/9.10 TiB)
> sd 6:0:2:0: [sdd] Write Protect is off
> sd 6:0:2:0: [sdd] Mode Sense: 00 3a 00 00
> sd 6:0:2:0: [sdd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
> sd 6:0:2:0: [sdd] Preferred minimum I/O size 4096 bytes
> scsi 6:0:3:0: Direct-Access     ATA      HUH721010ALN600  T290 PQ: 0 ANSI: 5
> sd 6:0:3:0: [sde] 2441609216 4096-byte logical blocks: (10.0 TB/9.10 TiB)
> sd 6:0:3:0: [sde] Write Protect is off
> sd 6:0:3:0: [sde] Mode Sense: 00 3a 00 00
> sd 6:0:3:0: [sde] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
> sd 6:0:3:0: [sde] Preferred minimum I/O size 4096 bytes
> scsi 6:0:4:0: Direct-Access     ATA      HUH721010ALN600  T290 PQ: 0 ANSI: 5
> sd 6:0:4:0: [sdf] 2441609216 4096-byte logical blocks: (10.0 TB/9.10 TiB)
> sd 6:0:4:0: [sdf] Write Protect is off
> sd 6:0:4:0: [sdf] Mode Sense: 00 3a 00 00
> sd 6:0:4:0: [sdf] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
> sd 6:0:4:0: [sdf] Preferred minimum I/O size 4096 bytes
> scsi 6:0:5:0: Direct-Access     ATA      HUH721010ALN600  T290 PQ: 0 ANSI: 5
> sd 6:0:5:0: [sdg] 2441609216 4096-byte logical blocks: (10.0 TB/9.10 TiB)
> sd 6:0:5:0: [sdg] Write Protect is off
> sd 6:0:5:0: [sdg] Mode Sense: 00 3a 00 00
> sd 6:0:5:0: [sdg] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
> sd 6:0:5:0: [sdg] Preferred minimum I/O size 4096 bytes
> scsi 6:0:6:0: Direct-Access     ATA      HUH721010ALN600  T290 PQ: 0 ANSI: 5
> sd 6:0:6:0: [sdh] 2441609216 4096-byte logical blocks: (10.0 TB/9.10 TiB)
> sd 6:0:6:0: [sdh] Write Protect is off
> sd 6:0:6:0: [sdh] Mode Sense: 00 3a 00 00
> sd 6:0:6:0: [sdh] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
> sd 6:0:6:0: [sdh] Preferred minimum I/O size 4096 bytes
> scsi 6:0:7:0: Direct-Access     ATA      HUH721010ALN600  T290 PQ: 0 ANSI: 5
> sd 6:0:7:0: [sdi] 2441609216 4096-byte logical blocks: (10.0 TB/9.10 TiB)
> sd 6:0:7:0: [sdi] Write Protect is off
> sd 6:0:7:0: [sdi] Mode Sense: 00 3a 00 00
> sd 6:0:7:0: [sdi] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
> sd 6:0:7:0: [sdi] Preferred minimum I/O size 4096 bytes
> scsi 6:0:8:0: Direct-Access     ATA      HUH721010ALN600  T290 PQ: 0 ANSI: 5
> sd 6:0:8:0: [sdj] 2441609216 4096-byte logical blocks: (10.0 TB/9.10 TiB)
> sd 6:0:8:0: [sdj] Write Protect is off
> sd 6:0:8:0: [sdj] Mode Sense: 00 3a 00 00
> sd 6:0:8:0: [sdj] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
> sd 6:0:8:0: [sdj] Preferred minimum I/O size 4096 bytes
> scsi 6:0:9:0: Direct-Access     ATA      HUH721010ALN600  T290 PQ: 0 ANSI: 5
> sd 6:0:9:0: [sdk] 2441609216 4096-byte logical blocks: (10.0 TB/9.10 TiB)
> sd 6:0:9:0: [sdk] Write Protect is off
> sd 6:0:9:0: [sdk] Mode Sense: 00 3a 00 00
> sd 6:0:9:0: [sdk] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
> sd 6:0:9:0: [sdk] Preferred minimum I/O size 4096 bytes
> scsi 6:0:10:0: Enclosure         EMC      ESES Enclosure   0001 PQ: 0 ANSI: 6
> scsi 6:0:10:0: Power-on or device reset occurred
> sas: DONE DISCOVERY on port 0, pid:39, result:0
> sas: broadcast received: 9
> sas: REVALIDATING DOMAIN on port 0, pid:39
> sas: ex 500e004abbbbbb7f phy00 change count has changed
> sas: ex 500e004abbbbbb7f phy00 originated BROADCAST(CHANGE)
> sas: ex 500e004abbbbbb7f rediscovering phy00
> sas: ex 500e004abbbbbb7f phy00 broadcast flutter
> sas: ex 500e004abbbbbb7f phy02 originated BROADCAST(CHANGE)
> sas: ex 500e004abbbbbb7f rediscovering phy02
> sas: ex 500e004abbbbbb7f phy02 broadcast flutter
> sas: ex 500e004abbbbbb7f phy05 originated BROADCAST(CHANGE)
> sas: ex 500e004abbbbbb7f rediscovering phy05
> sas: ex 500e004abbbbbb7f phy05 broadcast flutter
> sas: ex 500e004abbbbbb7f phy07 originated BROADCAST(CHANGE)
> sas: ex 500e004abbbbbb7f rediscovering phy07
> sas: ex 500e004abbbbbb7f phy07 broadcast flutter
> sas: ex 500e004abbbbbb7f phy08 originated BROADCAST(CHANGE)
> sas: ex 500e004abbbbbb7f rediscovering phy08
> sas: ex 500e004abbbbbb7f phy08 broadcast flutter
> sas: ex 500e004abbbbbb7f phy10 originated BROADCAST(CHANGE)
> sas: ex 500e004abbbbbb7f rediscovering phy10
> sas: ex 500e004abbbbbb7f phy10 broadcast flutter
> sas: ex 500e004abbbbbb7f phy13 originated BROADCAST(CHANGE)
> sas: ex 500e004abbbbbb7f rediscovering phy13
> sas: ex 500e004abbbbbb7f phy13 broadcast flutter
> sas: ex 500e004abbbbbb7f phy15 originated BROADCAST(CHANGE)
> sas: ex 500e004abbbbbb7f rediscovering phy15
> sas: ex 500e004abbbbbb7f phy15 broadcast flutter
> sas: ex 500e004abbbbbb7f phy16 originated BROADCAST(CHANGE)
> sas: ex 500e004abbbbbb7f rediscovering phy16
> sas: ex 500e004abbbbbb7f phy16 broadcast flutter
> sas: ex 500e004abbbbbb7f phy18 originated BROADCAST(CHANGE)
> sas: ex 500e004abbbbbb7f rediscovering phy18
> sas: ex 500e004abbbbbb7f phy18 broadcast flutter
> sas: ex 500e004abbbbbb7f phy23 originated BROADCAST(CHANGE)
> sas: ex 500e004abbbbbb7f phy23 new device attached
> sas: ex 500e004abbbbbb7f phy23:U:B attached: ffffffffffffffff (host)
> sas: YOLO ignoring (0x1) attached to ex 500e004abbbbbb7f phy23
> sas: ex 500e004abbbbbb7f phy30 originated BROADCAST(CHANGE)
> sas: ex 500e004abbbbbb7f phy30 new device attached
> sas: ex 500e004abbbbbb7f phy30:U:B attached: ffffffffffffffff (host)
> sas: done REVALIDATING DOMAIN on port 0, pid:39, res 0x0
> sas: broadcast received: 9
> sas: REVALIDATING DOMAIN on port 0, pid:39
> sas: done REVALIDATING DOMAIN on port 0, pid:39, res 0x0
> sas: phy1 matched wide port0
> sas: phy-6:1 added to port-6:0, phy_mask:0x3 (500e004abbbbbb7f)
> sas: REVALIDATING DOMAIN on port 0, pid:39
> sas: ex 500e004abbbbbb7f phys DID NOT change
> sas: done REVALIDATING DOMAIN on port 0, pid:39, res 0x0
> sas: broadcast received: 9
> sas: REVALIDATING DOMAIN on port 0, pid:39
> sas: ex 500e004abbbbbb7f phys DID NOT change
> sas: done REVALIDATING DOMAIN on port 0, pid:39, res 0x0
> sas: broadcast received: 9
> sas: REVALIDATING DOMAIN on port 0, pid:39
> sas: ex 500e004abbbbbb7f phys DID NOT change
> sas: done REVALIDATING DOMAIN on port 0, pid:39, res 0x0
> sas: broadcast received: 9
> sas: REVALIDATING DOMAIN on port 0, pid:39
> sas: ex 500e004abbbbbb7f phys DID NOT change
> sas: done REVALIDATING DOMAIN on port 0, pid:39, res 0x0
> sas: broadcast received: 9
> sas: REVALIDATING DOMAIN on port 0, pid:39
> sas: ex 500e004abbbbbb7f phys DID NOT change
> sas: done REVALIDATING DOMAIN on port 0, pid:39, res 0x0
> sas: phy-6:2 added to port-6:1, phy_mask:0x4 (5002538a67b05e82)
> sas: DOING DISCOVERY on port 1, pid:39
> scsi 6:0:11:0: Direct-Access     SAMSUNG  PA35N400 EMC400  EQL3 PQ: 0 ANSI: 6
> scsi 6:0:11:0: Power-on or device reset occurred
> sas: DONE DISCOVERY on port 1, pid:39, result:0
> sas: phy3 matched wide port0
> sas: phy-6:3 added to port-6:0, phy_mask:0xb (500e004abbbbbb7f)
> sas: REVALIDATING DOMAIN on port 0, pid:39
> sd 6:0:11:0: [sdl] 781250000 512-byte logical blocks: (400 GB/373 GiB)
> sd 6:0:11:0: [sdl] 4096-byte physical blocks
> sd 6:0:11:0: [sdl] Write Protect is off
> sd 6:0:11:0: [sdl] Mode Sense: b7 00 10 08
> sd 6:0:11:0: [sdl] Write cache: disabled, read cache: enabled, supports DPO and FUA
> sd 6:0:11:0: [sdl] Preferred minimum I/O size 8192 bytes
> sd 6:0:11:0: [sdl] Optimal transfer size 8192 bytes
> sas: ex 500e004abbbbbb7f phys DID NOT change
> sas: done REVALIDATING DOMAIN on port 0, pid:39, res 0x0
> sas: broadcast received: 9
> sas: REVALIDATING DOMAIN on port 0, pid:39
>   sdl: sdl1 sdl2 sdl3
> sd 6:0:11:0: [sdl] Attached SCSI disk
> sas: ex 500e004abbbbbb7f phys DID NOT change
> sas: done REVALIDATING DOMAIN on port 0, pid:39, res 0x0
> sas: phy-6:4 added to port-6:2, phy_mask:0x10 (500e004abbbbbb7f)
> sas: DOING DISCOVERY on port 2, pid:39
> sas: ex 500e004abbbbbb7f phy00:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy01:U:A attached: 500e004abbbbbb01 (stp)
> sas: ex 500e004abbbbbb7f phy02:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy03:U:A attached: 500e004abbbbbb03 (stp)
> sas: ex 500e004abbbbbb7f phy04:U:A attached: 500e004abbbbbb04 (stp)
> sas: ex 500e004abbbbbb7f phy05:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy06:U:A attached: 500e004abbbbbb06 (stp)
> sas: ex 500e004abbbbbb7f phy07:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy08:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy09:U:A attached: 500e004abbbbbb09 (stp)
> sas: ex 500e004abbbbbb7f phy10:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy11:U:A attached: 500e004abbbbbb0b (stp)
> sas: ex 500e004abbbbbb7f phy12:U:A attached: 500e004abbbbbb0c (stp)
> sas: ex 500e004abbbbbb7f phy13:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy14:U:A attached: 500e004abbbbbb0e (stp)
> sas: ex 500e004abbbbbb7f phy15:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy16:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy17:U:A attached: 500e004abbbbbb11 (stp)
> sas: ex 500e004abbbbbb7f phy18:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy19:U:A attached: 500e004abbbbbb13 (stp)
> sas: ex 500e004abbbbbb7f phy20:U:B attached: ffffffffffffffff (host)
> sas: ex 500e004abbbbbb7f phy21:U:B attached: ffffffffffffffff (host)
> sas: ex 500e004abbbbbb7f phy22:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy23:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy24:U:1 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy25:U:1 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy26:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy27:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy28:U:1 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy29:U:B attached: ffffffffffffffff (host)
> sas: ex 500e004abbbbbb7f phy30:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy31:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy32:U:1 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy33:U:1 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy34:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy35:D:0 attached: 0000000000000000 (no device)
> sas: ex 500e004abbbbbb7f phy36:D:B attached: 500e004abbbbbb7e (host+target)
> sas: Enter sas_scsi_recover_host busy: 10 failed: 10
> sas: trying to find task 0x000000006ab59d02
> sas: sas_scsi_find_task: aborting task 0x000000006ab59d02
> pm80xx0:: mpi_sata_completion 2287: task null, freeing CCB tag 10
> sas: sas_scsi_find_task: task 0x000000006ab59d02 is aborted
> sas: sas_eh_handle_sas_errors: task 0x000000006ab59d02 is aborted
> sas: trying to find task 0x00000000ad5c9920
> sas: sas_scsi_find_task: aborting task 0x00000000ad5c9920
> pm80xx0:: mpi_sata_completion 2287: task null, freeing CCB tag 9
> sas: sas_scsi_find_task: task 0x00000000ad5c9920 is aborted
> sas: sas_eh_handle_sas_errors: task 0x00000000ad5c9920 is aborted
> sas: trying to find task 0x0000000016de78fe
> sas: sas_scsi_find_task: aborting task 0x0000000016de78fe
> pm80xx0:: mpi_sata_completion 2287: task null, freeing CCB tag 8
> sas: sas_scsi_find_task: task 0x0000000016de78fe is aborted
> sas: sas_eh_handle_sas_errors: task 0x0000000016de78fe is aborted
> sas: trying to find task 0x000000003941a640
> sas: sas_scsi_find_task: aborting task 0x000000003941a640
> pm80xx0:: mpi_sata_completion 2287: task null, freeing CCB tag 4
> sas: sas_scsi_find_task: task 0x000000003941a640 is aborted
> sas: sas_eh_handle_sas_errors: task 0x000000003941a640 is aborted
> sas: trying to find task 0x000000005ee644eb
> sas: sas_scsi_find_task: aborting task 0x000000005ee644eb
> pm80xx0:: mpi_sata_completion 2287: task null, freeing CCB tag 6
> sas: sas_scsi_find_task: task 0x000000005ee644eb is aborted
> sas: sas_eh_handle_sas_errors: task 0x000000005ee644eb is aborted
> sas: trying to find task 0x0000000031596591
> sas: sas_scsi_find_task: aborting task 0x0000000031596591
> sas: sas_scsi_find_task: task 0x0000000031596591 is aborted
> pm80xx0:: mpi_sata_completion 2287: task null, freeing CCB tag 7
> sas: sas_eh_handle_sas_errors: task 0x0000000031596591 is aborted
> sas: trying to find task 0x00000000e44cf332
> sas: sas_scsi_find_task: aborting task 0x00000000e44cf332
> pm80xx0:: mpi_sata_completion 2287: task null, freeing CCB tag 5
> sas: sas_scsi_find_task: task 0x00000000e44cf332 is aborted
> sas: sas_eh_handle_sas_errors: task 0x00000000e44cf332 is aborted
> sas: trying to find task 0x0000000079c3e651
> sas: sas_scsi_find_task: aborting task 0x0000000079c3e651
> sas: sas_scsi_find_task: task 0x0000000079c3e651 is aborted
> pm80xx0:: mpi_sata_completion 2287: task null, freeing CCB tag 3
> sas: sas_eh_handle_sas_errors: task 0x0000000079c3e651 is aborted
> sas: trying to find task 0x000000006c04ed70
> sas: sas_scsi_find_task: aborting task 0x000000006c04ed70
> sas: sas_scsi_find_task: task 0x000000006c04ed70 is aborted
> pm80xx0:: mpi_sata_completion 2287: task null, freeing CCB tag 2
> sas: sas_eh_handle_sas_errors: task 0x000000006c04ed70 is aborted
> sas: trying to find task 0x00000000f1ab9a49
> sas: sas_scsi_find_task: aborting task 0x00000000f1ab9a49
> pm80xx0:: mpi_sata_completion 2287: task null, freeing CCB tag 1
> sas: sas_scsi_find_task: task 0x00000000f1ab9a49 is aborted
> sas: sas_eh_handle_sas_errors: task 0x00000000f1ab9a49 is aborted
> sas: ata16: end_device-6:0:18: cmd error handler
> sas: ata15: end_device-6:0:16: cmd error handler
> sas: ata14: end_device-6:0:15: cmd error handler
> sas: ata10: end_device-6:0:7: cmd error handler
> sas: ata12: end_device-6:0:10: cmd error handler
> sas: ata13: end_device-6:0:13: cmd error handler
> sas: ata11: end_device-6:0:8: cmd error handler
> sas: ata9: end_device-6:0:5: cmd error handler
> sas: ata8: end_device-6:0:2: cmd error handler
> sas: ata7: end_device-6:0:0: cmd error handler
> sas: ata7: end_device-6:0:0: dev error handler
> sas: ata8: end_device-6:0:2: dev error handler
> ata7.00: exception Emask 0x0 SAct 0x2000000 SErr 0x0 action 0x6 frozen
> ata8.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x6 frozen
> sas: ata9: end_device-6:0:5: dev error handler
> ata9.00: exception Emask 0x0 SAct 0x2000000 SErr 0x0 action 0x6 frozen
> ata9.00: failed command: READ FPDMA QUEUED
> ata9.00: cmd 60/01:00:00:00:00/00:00:00:00:00/40 tag 25 ncq dma 4096 in
>           res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata9.00: status: { DRDY }
> ata9: hard resetting link
> sas: ata10: end_device-6:0:7: dev error handler
> ata10.00: exception Emask 0x0 SAct 0x100 SErr 0x0 action 0x6 frozen
> ata10.00: failed command: READ FPDMA QUEUED
> ata10.00: cmd 60/01:00:00:00:00/00:00:00:00:00/40 tag 8 ncq dma 4096 in
>           res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata10.00: status: { DRDY }
> ata10: hard resetting link
> sas: ata11: end_device-6:0:8: dev error handler
> ata11.00: exception Emask 0x0 SAct 0x4000 SErr 0x0 action 0x6 frozen
> ata11.00: failed command: READ FPDMA QUEUED
> ata11.00: cmd 60/01:00:00:00:00/00:00:00:00:00/40 tag 14 ncq dma 4096 in
>           res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata11.00: status: { DRDY }
> ata11: hard resetting link
> sas: ata12: end_device-6:0:10: dev error handler
> ata12.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x6 frozen
> ata12.00: failed command: READ FPDMA QUEUED
> ata12.00: cmd 60/01:00:00:00:00/00:00:00:00:00/40 tag 0 ncq dma 4096 in
>           res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata12.00: status: { DRDY }
> ata12: hard resetting link
> sas: ata13: end_device-6:0:13: dev error handler
> ata13.00: exception Emask 0x0 SAct 0x10000000 SErr 0x0 action 0x6 frozen
> ata13.00: failed command: READ FPDMA QUEUED
> ata13.00: cmd 60/01:00:00:00:00/00:00:00:00:00/40 tag 28 ncq dma 4096 in
>           res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata13.00: status: { DRDY }
> ata13: hard resetting link
> .

