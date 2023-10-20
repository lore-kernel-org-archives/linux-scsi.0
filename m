Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1821C0032E
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Oct 2023 21:23:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231875AbjJTVXK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Oct 2023 17:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231652AbjJTVXJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Oct 2023 17:23:09 -0400
Received: from vps.thesusis.net (vps.thesusis.net [34.202.238.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02EF8D70;
        Fri, 20 Oct 2023 14:23:01 -0700 (PDT)
Received: by vps.thesusis.net (Postfix, from userid 1000)
        id CF9B6145963; Fri, 20 Oct 2023 17:23:00 -0400 (EDT)
From:   Phillip Susi <phill@thesusis.net>
To:     Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
Subject: Re: [PATCH v8 04/23] scsi: sd: Differentiate system and runtime
 start/stop management
In-Reply-To: <e5a256fa-f1f6-4474-8e9e-b9f4bd6dced7@kernel.org>
References: <20230927141828.90288-1-dlemoal@kernel.org>
 <20230927141828.90288-5-dlemoal@kernel.org>
 <87v8b73lsh.fsf@vps.thesusis.net>
 <0177ab41-6a7b-42ff-bf84-97d173efb838@kernel.org>
 <87r0luspvx.fsf@vps.thesusis.net>
 <1a6f1768-fd48-42df-9f1a-4b203baf6ddf@kernel.org>
 <87y1g1unwg.fsf@vps.thesusis.net>
 <e5a256fa-f1f6-4474-8e9e-b9f4bd6dced7@kernel.org>
Date:   Fri, 20 Oct 2023 17:23:00 -0400
Message-ID: <87lebxrnt7.fsf@vps.thesusis.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Damien Le Moal <dlemoal@kernel.org> writes:

> On my system, I see:
>
> cat /sys/class/ata_port/ata1/power/runtime_active_kids
> 0

I see a 1 there, which is the single scsi_host.  The scsi_host has 2
active kids; the two disks.  When I enabled runtime pm, only when the
second disk was suspended did that allow the scsi_host to suspend, which
then allowed the port to suspend.  Everything looked fine there so far.
Then I tried:

echo 1 > /sys/block/sdf/device/delete

And the SCSI EH appears to have tried to wake up the disk, and hung in
the process.

[  314.246282] sd 7:0:0:0: [sde] Synchronizing SCSI cache
[  314.246445] sd 7:0:0:0: [sde] Stopping disk

First disk suspends.

[  388.518295] sd 7:1:0:0: [sdf] Synchronizing SCSI cache
[  388.518519] sd 7:1:0:0: [sdf] Stopping disk

Second disk suspends some time later.

[  388.930428] ata8.00: Entering standby power mode
[  389.330651] ata8.01: Entering standby power mode

That allowed the port to suspend.  This is when I tried to detach the
disk driver, which I think tried to resume the disk before detaching,
which resumed the port.

[  467.511878] ata8.15: SATA link down (SStatus 0 SControl 310)
[  468.142726] ata8.15: failed to read PMP GSCR[0] (Emask=0x100)
[  468.142741] ata8.15: PMP revalidation failed (errno=-5)

I ran hdparm -C on the other disk at this point.  I just noticed that
the ata8.15 that represents the PMP itself was NOT suspended along with
the two drive links, and then maybe was not resumed before trying to
revalidate the PMP?  And that's why it failed?

[  473.172792] ata8.15: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[  473.486860] ata8.00: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[  473.802139] ata8.01: SATA link up 1.5 Gbps (SStatus 113 SControl 310)

It seems like it ended up recovering here though?  And yet the scsi_eh
remained hung, as did the hdparm -C:

[  605.566814] INFO: task scsi_eh_7:173 blocked for more than 120 seconds.
[  605.566829]       Not tainted 6.6.0-rc5+ #5
[  605.566834] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  605.566838] task:scsi_eh_7       state:D stack:0     pid:173   ppid:2      flags:0x00004000
[  605.566850] Call Trace:
[  605.566853]  <TASK>
[  605.566860]  __schedule+0x37c/0xb70
[  605.566878]  schedule+0x61/0xd0
[  605.566888]  rpm_resume+0x156/0x760
[  605.566896]  ? sched_energy_aware_handler+0xb0/0xb0
[  605.566907]  rpm_resume+0x255/0x760
[  605.566915]  rpm_resume+0x255/0x760
[  605.566923]  rpm_resume+0x255/0x760
[  605.566931]  __pm_runtime_resume+0x4e/0x80
[  605.566941]  ata_eh_recover+0x695/0x1060 [libata]
[  605.567001]  ? ata_port_pm_suspend+0x50/0x50 [libata]
[  605.567048]  ? ahci_do_softreset+0x2d0/0x2d0 [libahci]
[  605.567067]  ? ata_host_release+0x80/0x80 [libata]
[  605.567108]  ? ata_port_runtime_idle+0x110/0x110 [libata]
[  605.567151]  ? sata_pmp_configure+0x72/0x210 [libata]
[  605.567204]  sata_pmp_error_handler+0x357/0xac0 [libata]
[  605.567249]  ? ata_port_pm_suspend+0x50/0x50 [libata]
[  605.567291]  ? ahci_stop_engine+0xe0/0xe0 [libahci]
[  605.567309]  ? ahci_do_hardreset+0x140/0x140 [libahci]
[  605.567325]  ? ahci_do_softreset+0x2d0/0x2d0 [libahci]
[  605.567344]  ? _raw_spin_unlock_irqrestore+0x27/0x40
[  605.567355]  ahci_error_handler+0x36/0x60 [libahci]
[  605.567373]  ata_scsi_port_error_handler+0x3de/0x8a0 [libata]
[  605.567424]  ? scsi_eh_get_sense+0x250/0x250 [scsi_mod]
[  605.567464]  ata_scsi_error+0x95/0xc0 [libata]
[  605.567511]  scsi_error_handler+0xb9/0x580 [scsi_mod]
[  605.567547]  ? preempt_count_add+0x6c/0xa0
[  605.567556]  ? scsi_eh_get_sense+0x250/0x250 [scsi_mod]
[  605.567587]  kthread+0xf2/0x120
[  605.567594]  ? kthread_complete_and_exit+0x20/0x20
[  605.567602]  ret_from_fork+0x31/0x50
[  605.567611]  ? kthread_complete_and_exit+0x20/0x20
[  605.567617]  ret_from_fork_asm+0x11/0x20
[  605.567630]  </TASK>
[  605.567663] INFO: task bash:1305 blocked for more than 120 seconds.
[  605.567670]       Not tainted 6.6.0-rc5+ #5
[  605.567675] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  605.567678] task:bash            state:D stack:0     pid:1305  ppid:1300   flags:0x00004004
[  605.567687] Call Trace:
[  605.567689]  <TASK>
[  605.567693]  __schedule+0x37c/0xb70
[  605.567703]  ? try_to_wake_up+0xb2/0x5e0
[  605.567715]  schedule+0x61/0xd0
[  605.567725]  ata_port_wait_eh+0x7c/0xf0 [libata]
[  605.567776]  ? sched_energy_aware_handler+0xb0/0xb0
[  605.567784]  ? ata_sas_port_resume+0x30/0x30 [libata]
[  605.567829]  ata_port_runtime_resume+0x27/0x30 [libata]
[  605.567870]  __rpm_callback+0x41/0x110
[  605.567879]  ? ata_sas_port_resume+0x30/0x30 [libata]
[  605.567917]  rpm_callback+0x35/0x70
[  605.567925]  rpm_resume+0x513/0x760
[  605.567931]  ? _raw_read_lock_irqsave+0x28/0x50
[  605.567938]  ? _raw_read_unlock_irqrestore+0x2a/0x40
[  605.567944]  ? ep_poll_callback+0x269/0x2d0
[  605.567955]  rpm_resume+0x255/0x760
[  605.567962]  ? __slab_free+0xc7/0x320
[  605.567972]  rpm_resume+0x255/0x760
[  605.567978]  ? kernfs_should_drain_open_files+0x38/0x50
[  605.567989]  rpm_resume+0x255/0x760
[  605.567994]  ? kernfs_should_drain_open_files+0x38/0x50
[  605.568002]  ? kernfs_drain+0xec/0x120
[  605.568010]  __pm_runtime_resume+0x4e/0x80
[  605.568018]  device_release_driver_internal+0xa8/0x200
[  605.568028]  bus_remove_device+0xc0/0x120
[  605.568035]  device_del+0x158/0x3d0
[  605.568045]  ? mutex_lock+0x12/0x30
[  605.568051]  __scsi_remove_device+0x12b/0x180 [scsi_mod]
[  605.568095]  sdev_store_delete+0x6a/0xd0 [scsi_mod]
[  605.568132]  kernfs_fop_write_iter+0x129/0x1c0
[  605.568141]  vfs_write+0x2d3/0x3f0
[  605.568155]  ksys_write+0x63/0xe0
[  605.568165]  do_syscall_64+0x5a/0xb0
[  605.568173]  ? syscall_exit_to_user_mode+0x2b/0x40
[  605.568178]  ? do_syscall_64+0x67/0xb0
[  605.568184]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
[  605.568193] RIP: 0033:0x7f0c1e9b6473
[  605.568200] RSP: 002b:00007ffe01b0bd28 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[  605.568208] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f0c1e9b6473
[  605.568213] RDX: 0000000000000002 RSI: 000056115e4b86f0 RDI: 0000000000000001
[  605.568216] RBP: 000056115e4b86f0 R08: 000000000000000a R09: 00007f0c1ea5a0c0
[  605.568220] R10: 00007f0c1ea59fc0 R11: 0000000000000246 R12: 0000000000000002
[  605.568224] R13: 00007f0c1ea9a6a0 R14: 0000000000000002 R15: 00007f0c1ea95880
[  605.568232]  </TASK>
