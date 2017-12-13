From: "chenxiang (M)" <chenxiang66@hisilicon.com>
Subject: Re: [bug report] A race between device_resume and removing disk
Date: Wed, 13 Dec 2017 08:48:31 +0800
Message-ID: <a743fe93-4e4f-6690-f5b4-1b229e0ef7c2@hisilicon.com>
References: <44c1bcaf-8cb4-50e6-b18f-1feb9c438614@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:11975 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753134AbdLMAtQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Dec 2017 19:49:16 -0500
In-Reply-To: <44c1bcaf-8cb4-50e6-b18f-1feb9c438614@hisilicon.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sre@kernel.org, rjw@rjwysocki.net, rafael@kernel.org, will.deacon@arm.com, martin.petersen@oracle.com, Bart Van Assche <Bart.VanAssche@wdc.com>, james.bottomley@hansenpartnership.com, arnd@arndb.de
Cc: John Garry <john.garry@huawei.com>, jonathan.cameron@huawei.com, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, Linuxarm <linuxarm@huawei.com>

Ping...    Does anyone has some idea about this issue?

在 2017/11/16 11:54, chenxiang (M) 写道:
> Hi all,
>
> When debugging suspend and resume of hisi_sas, I find a issue: use 
> commands (echo freeze > /sys/power/state) to
> suspend, after 5s system will be resumed as i enable TEST_DEVICES. But if
> I plug one disks during suspend, system will be blocked all the time 
> and it seems that there is a deadlock.
>
> I suspect that when device resume, it will acquire dev->mutex 
> (device_lock(dev)) during almost the
> whole device resume process, but if remove a disk, it also tries to 
> acquire dev->mutex when device_del.
> So it causes a deadlock. Do you have any idea about this issue?
>
> Follows are part of the log of normal print and exception print. In my 
> environment, there are 11 disks on expander
> (5 SATA disks and 6 SAS disks).
>
> regards,
> shawn
>
>
> Normal log of suspend as follows:
>
> [  189.789974] PM: suspend entry (s2idle)
> [  189.798045] PM: Syncing filesystems ... done.
> [  189.935324] Freezing user space processes ... (elapsed 0.009 
> seconds) done.
> [  189.955044] OOM killer disabled.
> [  189.959111] Freezing remaining freezable tasks ... (elapsed 0.012 
> seconds) done.
> [  190.065399] sd 0:0:10:0: [sdk] Synchronizing SCSI cache
> [  190.090948] sd 0:0:10:0: [sdk] Stopping disk
> [  190.113157] sd 0:0:9:0: [sdj] Synchronizing SCSI cache
> [  190.139116] sd 0:0:8:0: [sdi] Synchronizing SCSI cache
> [  190.160252] sd 0:0:7:0: [sdh] Synchronizing SCSI cache
> [  190.175968] sd 0:0:7:0: [sdh] Stopping disk
> [  191.401325] sd 0:0:5:0: [sdf] Synchronizing SCSI cache
> [  191.429529] sd 0:0:3:0: [sdd] Synchronizing SCSI cache
> [  191.452532] sd 0:0:2:0: [sdc] Synchronizing SCSI cache
> [  191.752248] sd 0:0:2:0: [sdc] Stopping disk
> [  192.045536] sd 0:0:1:0: [sdb] Synchronizing SCSI cache
> [  192.072078] sd 0:0:1:0: [sdb] Stopping disk
> [  192.744386] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> [  192.760704] sd 0:0:0:0: [sda] Stopping disk
> [  193.397060] hisi_sas_v3_suspend
> [  194.587783] PM: suspend devices took 4.604 seconds
> [  194.594688] PM: suspend debug: Waiting for 5 second(s).
> [  199.687272] hisi_sas_v3_resume
> [  199.740433] hisi_sas_v3_hw 0000:74:02.0: phyup: phy0 link_rate=8
> [  199.747979] hisi_sas_v3_hw 0000:74:02.0: phyup: phy1 link_rate=8
> [  199.754995] hisi_sas_v3_hw 0000:74:02.0: phyup: phy2 link_rate=8
> [  199.787405] hisi_sas_v3_hw 0000:74:02.0: phyup: phy3 link_rate=8
> [  199.820411] sas: sas_form_port: phy0 belongs to port0 already(4)!
> [  199.831008] sas: sas_form_port: phy1 belongs to port0 already(4)!
> [  199.839963] sas: sas_form_port: phy2 belongs to port0 already(4)!
> [  199.849237] sas: sas_form_port: phy3 belongs to port0 already(4)!
> [  200.366863] ata7: SATA link down (SStatus 0 SControl 300)
> [  200.379220] ata6: SATA link down (SStatus 0 SControl 300)
> [  200.828384] sas: broadcast received: 0
> [  200.838602] sas: REVALIDATING DOMAIN on port 0, pid:1454
> [  200.862876] sd 0:0:0:0: [sda] Starting disk
> [  200.881098] sd 0:0:1:0: [sdb] Starting disk
> [  200.891951] sd 0:0:2:0: [sdc] Starting disk
> [  200.949758] sd 0:0:7:0: [sdh] Starting disk
> [  200.990573] sd 0:0:10:0: [sdk] Starting disk
> [  201.114636] sas: Expander phy change count has changed
> [  201.188709] sas: ex 500e004aaaaaaa1f phy16 originated 
> BROADCAST(CHANGE)
> [  201.197145] sas: phy16 part of wide port with phy17
> [  201.211154] sas: ex 500e004aaaaaaa1f phy 0x10 broadcast flutter
> [  201.222900] sas: ex 500e004aaaaaaa1f phy17 originated 
> BROADCAST(CHANGE)
> [  201.231045] sas: phy17 part of wide port with phy16
> [  201.244352] sas: ex 500e004aaaaaaa1f phy 0x11 broadcast flutter
> [  201.258344] sas: ex 500e004aaaaaaa1f phy18 originated 
> BROADCAST(CHANGE)
> [  201.268344] sas: phy18 part of wide port with phy16
> [  201.283102] sas: ex 500e004aaaaaaa1f phy 0x12 broadcast flutter
> [  201.294168] sas: ex 500e004aaaaaaa1f phy19 originated 
> BROADCAST(CHANGE)
> [  201.302386] sas: phy19 part of wide port with phy16
> [  201.315813] sas: ex 500e004aaaaaaa1f phy 0x13 broadcast flutter
> [  201.346615] sas: done REVALIDATING DOMAIN on port 0, pid:1454, res 0x0
> [  203.640641] PM: resume devices took 3.984 seconds
> [  203.648996] OOM killer enabled.
> [  203.655016] Restarting tasks ... done.
> [  203.690494] PM: suspend exit
>
> The log of removing disk when suspend is as follows:
>
> [44750.653222] PM: suspend entry (s2idle)
> [44750.658991] PM: Syncing filesystems ... done.
> [44750.699868] Freezing user space processes ... (elapsed 0.015 
> seconds) done.
> [44750.725734] OOM killer disabled.
> [44750.729711] Freezing remaining freezable tasks ... (elapsed 0.018 
> seconds) done.
> [44750.820672] sd 0:0:13:0: [sdk] Synchronizing SCSI cache
> [44750.844056] sd 0:0:13:0: [sdk] Stopping disk
> [44750.917433] sd 0:0:9:0: [sdj] Synchronizing SCSI cache
> [44750.949032] sd 0:0:8:0: [sdi] Synchronizing SCSI cache
> [44750.972730] sd 0:0:7:0: [sdh] Synchronizing SCSI cache
> [44750.989813] sd 0:0:7:0: [sdh] Stopping disk
> [44752.207539] sd 0:0:5:0: [sdf] Synchronizing SCSI cache
> [44752.239773] sd 0:0:3:0: [sdd] Synchronizing SCSI cache
> [44752.264202] sd 0:0:2:0: [sdc] Synchronizing SCSI cache
> [44752.283091] sd 0:0:2:0: [sdc] Stopping disk
> [44752.857859] sd 0:0:1:0: [sdb] Synchronizing SCSI cache
> [44752.884278] sd 0:0:1:0: [sdb] Stopping disk
> [44753.547281] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> [44753.563534] sd 0:0:0:0: [sda] Stopping disk
> [44754.186119] hisi_sas_v3_suspend
> [44755.380615] PM: suspend devices took 4.620 seconds
> [44755.387566] PM: suspend debug: Waiting for 5 second(s).
> [44760.481947] hisi_sas_v3_resume
> [44760.545002] hisi_sas_v3_hw 0000:74:02.0: phyup: phy0 link_rate=8
> [44760.553511] hisi_sas_v3_hw 0000:74:02.0: phyup: phy1 link_rate=8
> [44760.560449] hisi_sas_v3_hw 0000:74:02.0: phyup: phy2 link_rate=8
> [44760.569585] sas: broadcast received: 0
> [44760.575273] sas: REVALIDATING DOMAIN on port 0, pid:2543
> [44760.586836] hisi_sas_v3_hw 0000:74:02.0: phyup: phy3 link_rate=8
> [44760.667425] sas: Expander phy change count has changed
> [44760.720375] sas: ex 500e004aaaaaaa1f phy11 originated 
> BROADCAST(CHANGE)
> [44760.766008] sas: ex 500e004aaaaaaa1f phy16 originated 
> BROADCAST(CHANGE)
> [44760.775866] sas: phy16 part of wide port with phy17
> [44760.791094] sas: ex 500e004aaaaaaa1f phy 0x10 broadcast flutter
> [44760.808368] sas: ex 500e004aaaaaaa1f phy17 originated 
> BROADCAST(CHANGE)
> [44760.817757] sas: phy17 part of wide port with phy16
> [44760.824945] ata6: SATA link down (SStatus 0 SControl 300)
> [44760.829942] ata7: SATA link down (SStatus 0 SControl 300)
> [44760.855445] sas: ex 500e004aaaaaaa1f phy 0x11 broadcast flutter
> [44760.870484] sas: ex 500e004aaaaaaa1f phy18 originated 
> BROADCAST(CHANGE)
> [44760.880241] sas: phy18 part of wide port with phy16
> [44760.895521] sas: ex 500e004aaaaaaa1f phy 0x12 broadcast flutter
> [44760.906639] sas: ex 500e004aaaaaaa1f phy19 originated 
> BROADCAST(CHANGE)
> [44760.914870] sas: phy19 part of wide port with phy16
> [44760.929393] sas: ex 500e004aaaaaaa1f phy 0x13 broadcast flutter
> [44760.957832] sas: done REVALIDATING DOMAIN on port 0, pid:2543, res 0x0
> [44761.642204] sd 0:0:0:0: [sda] Starting disk
> [44761.653165] sd 0:0:1:0: [sdb] Starting disk
> [44761.663506] sd 0:0:2:0: [sdc] Starting disk
> [44761.715975] sd 0:0:7:0: [sdh] Starting disk
> [44911.477779] INFO: task kworker/u2:7:1054 blocked for more than 120 
> seconds.
> [44911.491820]       Not tainted 4.14.0-rc5-29338-g01140e9-dirty #802
> [44911.499782] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
> disables this message.
> [44911.511059] kworker/u2:7    D    0  1054      2 0x00000020
> [44911.518771] Workqueue: events_unbound async_run_entry_fn
> [44911.526803] Call trace:
> [44911.531809] [<ffff000008085fa4>] __switch_to+0x94/0xa8
> [44911.538319] [<ffff0000089764c0>] __schedule+0x1a8/0x5c4
> [44911.545501] [<ffff000008976914>] schedule+0x38/0x9c
> [44911.552086] [<ffff000008976d20>] schedule_preempt_disabled+0x20/0x38
> [44911.559195] [<ffff000008977920>] __mutex_lock.isra.9+0x138/0x4bc
> [44911.566663] [<ffff000008977cb4>] __mutex_lock_slowpath+0x10/0x18
> [44911.574891] [<ffff000008977cec>] mutex_lock+0x30/0x38
> [44911.581204] [<ffff00000858a2b4>] device_resume+0x48/0x124
> [44911.589741] [<ffff00000858a3b4>] async_resume+0x24/0x54
> [44911.596747] [<ffff0000080e837c>] async_run_entry_fn+0x44/0x108
> [44911.604873] [<ffff0000080df0c0>] process_one_work+0x128/0x2b0
> [44911.611419] [<ffff0000080df29c>] worker_thread+0x54/0x3c8
> [44911.618406] [<ffff0000080e4f90>] kthread+0x100/0x12c
> [44911.625448] [<ffff000008085314>] ret_from_fork+0x10/0x18
> [44911.632049] INFO: task kworker/u2:14:1486 blocked for more than 120 
> seconds.
> [44911.640715]       Not tainted 4.14.0-rc5-29338-g01140e9-dirty #802
> [44911.648270] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
> disables this message.
> [44911.657506] kworker/u2:14   D    0  1486      2 0x00000020
> [44911.664647] Workqueue: 0000:74:02.0_event_q sas_port_event_worker
> [44911.672501] Call trace:
> [44911.675840] [<ffff000008085fa4>] __switch_to+0x94/0xa8
> [44911.683374] [<ffff0000089764c0>] __schedule+0x1a8/0x5c4
> [44911.691057] [<ffff000008976914>] schedule+0x38/0x9c
> [44911.699536] [<ffff000008979bfc>] schedule_timeout+0x198/0x338
> [44911.706251] [<ffff000008977488>] wait_for_common+0x9c/0x140
> [44911.713251] [<ffff000008977540>] wait_for_completion+0x14/0x1c
> [44911.720605] [<ffff0000080dcea8>] flush_workqueue+0xf4/0x3cc
> [44911.726993] [<ffff0000085c71dc>] sas_porte_broadcast_rcvd+0x5c/0x68
> [44911.734834] [<ffff0000085c79d0>] sas_port_event_worker+0x24/0x38
> [44911.742815] [<ffff0000080df0c0>] process_one_work+0x128/0x2b0
> [44911.751780] [<ffff0000080df29c>] worker_thread+0x54/0x3c8
> [44911.757989] [<ffff0000080e4f90>] kthread+0x100/0x12c
> [44911.764699] [<ffff000008085314>] ret_from_fork+0x10/0x18
> [44911.773153] INFO: task kworker/u2:18:2543 blocked for more than 120 
> seconds.
> [44911.781630]       Not tainted 4.14.0-rc5-29338-g01140e9-dirty #802
> [44911.790194] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
> disables this message.
> [44911.799406] kworker/u2:18   D    0  2543      2 0x00000000
> [44911.806845] Workqueue: 0000:74:02.0_disco_q sas_revalidate_domain
> [44911.814980] Call trace:
> [44911.817940] [<ffff000008085fa4>] __switch_to+0x94/0xa8
> [44911.825266] [<ffff0000089764c0>] __schedule+0x1a8/0x5c4
> [44911.831290] [<ffff000008976914>] schedule+0x38/0x9c
> [44911.837629] [<ffff000008979bfc>] schedule_timeout+0x198/0x338
> [44911.844803] [<ffff000008977488>] wait_for_common+0x9c/0x140
> [44911.852655] [<ffff000008977540>] wait_for_completion+0x14/0x1c
> [44911.860032] [<ffff0000080dea8c>] flush_work+0xe4/0x1cc
> [44911.867769] [<ffff0000080dec74>] flush_delayed_work+0x3c/0x48
> [44911.874563] [<ffff0000081a4154>] wb_shutdown+0xcc/0x130
> [44911.881259] [<ffff0000081a4cb4>] bdi_unregister+0x5c/0x1e4
> [44911.888554] [<ffff000008395fa4>] del_gendisk+0x114/0x1ec
> [44911.894687] [<ffff0000085d20b4>] sd_remove+0x60/0xb8
> [44911.901552] [<ffff00000857d220>] 
> device_release_driver_internal+0x148/0x1d4
> [44911.910347] [<ffff00000857d2c0>] device_release_driver+0x14/0x1c
> [44911.917140] [<ffff00000857c110>] bus_remove_device+0xc8/0x104
> [44911.925918] [<ffff000008578d80>] device_del+0x1f8/0x300
> [44911.933151] [<ffff0000085c0dd4>] __scsi_remove_device+0xec/0x118
> [44911.940840] [<ffff0000085c0e28>] scsi_remove_device+0x28/0x3c
> [44911.947373] [<ffff0000085c0ff4>] scsi_remove_target+0x180/0x1b4
> [44911.954787] [<ffff0000085c4238>] sas_rphy_remove+0x60/0x64
> [44911.961743] [<ffff0000085c4250>] sas_rphy_delete+0x14/0x28
> [44911.968317] [<ffff0000085c8484>] sas_destruct_devices+0x58/0x8c
> [44911.975717] [<ffff0000085c8774>] sas_revalidate_domain+0x5c/0xe8
> [44911.983196] [<ffff0000080df0c0>] process_one_work+0x128/0x2b0
> [44911.989661] [<ffff0000080df29c>] worker_thread+0x54/0x3c8
> [44911.996605] [<ffff0000080e4f90>] kthread+0x100/0x12c
> [44912.003599] [<ffff000008085314>] ret_from_fork+0x10/0x18
> [44912.009820] INFO: task freeze.sh:2761 blocked for more than 120 
> seconds.
> [44912.018287]       Not tainted 4.14.0-rc5-29338-g01140e9-dirty #802
> [44912.026127] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
> disables this message.
> [44912.035360] freeze.sh       D    0  2761   1434 0x00000000
> [44912.041716] Call trace:
> [44912.045665] [<ffff000008085fa4>] __switch_to+0x94/0xa8
> [44912.051671] [<ffff0000089764c0>] __schedule+0x1a8/0x5c4
> [44912.058440] [<ffff000008976914>] schedule+0x38/0x9c
> [44912.064082] [<ffff0000080e87d0>] 
> async_synchronize_cookie_domain+0x88/0xd4
> [44912.072441] [<ffff0000080e884c>] async_synchronize_full+0x14/0x1c
> [44912.080206] [<ffff00000858b248>] dpm_resume+0x1f4/0x22c
> [44912.087688] [<ffff00000858b43c>] dpm_resume_end+0x14/0x28
> [44912.093984] [<ffff00000810aa6c>] suspend_devices_and_enter+0x174/0x59c
> [44912.102216] [<ffff00000810b0d4>] pm_suspend+0x240/0x310
> [44912.109190] [<ffff000008109aac>] state_store+0x84/0x108
> [44912.115240] [<ffff000008966da0>] kobj_attr_store+0x14/0x24
> [44912.122681] [<ffff00000827c108>] sysfs_kf_write+0x40/0x48
> [44912.129844] [<ffff00000827b424>] kernfs_fop_write+0xc0/0x1d0
> [44912.137099] [<ffff00000820440c>] __vfs_write+0x28/0x124
> [44912.143863] [<ffff0000082046f0>] vfs_write+0xa0/0x198
> [44912.151844] [<ffff00000820496c>] SyS_write+0x44/0xa0
> [44912.157628] Exception stack(0xffff00000ad0bec0 to 0xffff00000ad0c000)
> [44912.165651] bec0: 0000000000000001 000000002e7ca808 
> 0000000000000007 0000000000000000
> [44912.175136] bee0: 0000000000000000 0000ffff90b56140 
> 000000002e7ca80e fefefefefefefefe
> [44912.184489] bf00: 0000000000000040 0000000000000006 
> 7f7f7f7f7f7f7f7f 0101010101010101
> [44912.193820] bf20: 0000000000000030 0000000000000018 
> ffffffffffffffff 00000ab180000000
> [44912.203422] bf40: 0000000000000000 0000ffff90b77644 
> 0000ffffd0175190 0000000000000007
> [44912.214156] bf60: 000000002e7ca808 0000ffff90c544f8 
> 0000000000000007 0000000000000000
> [44912.224106] bf80: 0000000000000001 00000000004c7e28 
> 00000000004ea000 00000000004c8620
> [44912.233362] bfa0: 0000000000000000 0000ffffd0175430 
> 0000ffff90b7e844 0000ffffd0175430
> [44912.245409] bfc0: 0000ffff90bcc108 0000000020000000 
> 0000000000000001 0000000000000040
> [44912.256310] bfe0: 0000000000000000 0000000000000000 
> 0000000000000000 0000000000000000
> [44912.266743] [<ffff0000080837b0>] el0_svc_naked+0x24/0x28
> ^[OP^[OP^[OP[45032.312301] INFO: task kworker/u2:7:1054 blocked for 
> more than 120 seconds.
> [45032.323340]       Not tainted 4.14.0-rc5-29338-g01140e9-dirty #802
> [45032.331329] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
> disables this message.
> [45032.341433] kworker/u2:7    D    0  1054      2 0x00000020
> [45032.348849] Workqueue: events_unbound async_run_entry_fn
> [45032.355787] Call trace:
> [45032.359246] [<ffff000008085fa4>] __switch_to+0x94/0xa8
> [45032.366311] [<ffff0000089764c0>] __schedule+0x1a8/0x5c4
> [45032.373419] [<ffff000008976914>] schedule+0x38/0x9c
> [45032.379019] [<ffff000008976d20>] schedule_preempt_disabled+0x20/0x38
> [45032.386834] [<ffff000008977920>] __mutex_lock.isra.9+0x138/0x4bc
> [45032.395203] [<ffff000008977cb4>] __mutex_lock_slowpath+0x10/0x18
> [45032.403043] [<ffff000008977cec>] mutex_lock+0x30/0x38
> [45032.410578] [<ffff00000858a2b4>] device_resume+0x48/0x124
> [45032.417488] [<ffff00000858a3b4>] async_resume+0x24/0x54
> [45032.424180] [<ffff0000080e837c>] async_run_entry_fn+0x44/0x108
> [45032.431883] [<ffff0000080df0c0>] process_one_work+0x128/0x2b0
> [45032.439096] [<ffff0000080df29c>] worker_thread+0x54/0x3c8
> [45032.447480] [<ffff0000080e4f90>] kthread+0x100/0x12c
> [45032.453284] [<ffff000008085314>] ret_from_fork+0x10/0x18
> [45032.460493] INFO: task kworker/u2:14:1486 blocked for more than 120 
> seconds.
> [45032.469003]       Not tainted 4.14.0-rc5-29338-g01140e9-dirty #802
> [45032.476389] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
> disables this message.
> [45032.485551] kworker/u2:14   D    0  1486      2 0x00000020
> [45032.494109] Workqueue: 0000:74:02.0_event_q sas_port_event_worker
> [45032.502144] Call trace:
> [45032.505058] [<ffff000008085fa4>] __switch_to+0x94/0xa8
> [45032.511818] [<ffff0000089764c0>] __schedule+0x1a8/0x5c4
> [45032.520320] [<ffff000008976914>] schedule+0x38/0x9c
> [45032.526305] [<ffff000008979bfc>] schedule_timeout+0x198/0x338
> [45032.533498] [<ffff000008977488>] wait_for_common+0x9c/0x140
> [45032.541105] [<ffff000008977540>] wait_for_completion+0x14/0x1c
> [45032.547716] [<ffff0000080dcea8>] flush_workqueue+0xf4/0x3cc
> [45032.554855] [<ffff0000085c71dc>] sas_porte_broadcast_rcvd+0x5c/0x68
> [45032.563156] [<ffff0000085c79d0>] sas_port_event_worker+0x24/0x38
> [45032.569943] [<ffff0000080df0c0>] process_one_work+0x128/0x2b0
> [45032.578263] [<ffff0000080df29c>] worker_thread+0x54/0x3c8
> [45032.585164] [<ffff0000080e4f90>] kthread+0x100/0x12c
> [45032.590837] [<ffff000008085314>] ret_from_fork+0x10/0x18
> [45032.598410] INFO: task kworker/u2:18:2543 blocked for more than 120 
> seconds.
> [45032.606936]       Not tainted 4.14.0-rc5-29338-g01140e9-dirty #802
> [45032.615045] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
> disables this message.
> [45032.624952] kworker/u2:18   D    0  2543      2 0x00000000
> [45032.631577] Workqueue: 0000:74:02.0_disco_q sas_revalidate_domain
> [45032.639213] Call trace:
> [45032.642438] [<ffff000008085fa4>] __switch_to+0x94/0xa8
> [45032.649234] [<ffff0000089764c0>] __schedule+0x1a8/0x5c4
> [45032.656581] [<ffff000008976914>] schedule+0x38/0x9c
> [45032.662359] [<ffff000008979bfc>] schedule_timeout+0x198/0x338
> [45032.669503] [<ffff000008977488>] wait_for_common+0x9c/0x140
> [45032.677661] [<ffff000008977540>] wait_for_completion+0x14/0x1c
> [45032.684200] [<ffff0000080dea8c>] flush_work+0xe4/0x1cc
> [45032.690820] [<ffff0000080dec74>] flush_delayed_work+0x3c/0x48
> [45032.699376] [<ffff0000081a4154>] wb_shutdown+0xcc/0x130
> [45032.705368] [<ffff0000081a4cb4>] bdi_unregister+0x5c/0x1e4
> [45032.712611] [<ffff000008395fa4>] del_gendisk+0x114/0x1ec
> [45032.719691] [<ffff0000085d20b4>] sd_remove+0x60/0xb8
> [45032.725770] [<ffff00000857d220>] 
> device_release_driver_internal+0x148/0x1d4
> [45032.734592] [<ffff00000857d2c0>] device_release_driver+0x14/0x1c
> [45032.742680] [<ffff00000857c110>] bus_remove_device+0xc8/0x104
> [45032.749871] [<ffff000008578d80>] device_del+0x1f8/0x300
> [45032.757028] [<ffff0000085c0dd4>] __scsi_remove_device+0xec/0x118
> [45032.764582] [<ffff0000085c0e28>] scsi_remove_device+0x28/0x3c
> [45032.772051] [<ffff0000085c0ff4>] scsi_remove_target+0x180/0x1b4
> [45032.778688] [<ffff0000085c4238>] sas_rphy_remove+0x60/0x64
> [45032.785643] [<ffff0000085c4250>] sas_rphy_delete+0x14/0x28
> [45032.793256] [<ffff0000085c8484>] sas_destruct_devices+0x58/0x8c
> [45032.799922] [<ffff0000085c8774>] sas_revalidate_domain+0x5c/0xe8
> [45032.807405] [<ffff0000080df0c0>] process_one_work+0x128/0x2b0
> [45032.815090] [<ffff0000080df29c>] worker_thread+0x54/0x3c8
> [45032.821273] [<ffff0000080e4f90>] kthread+0x100/0x12c
> [45032.827761] [<ffff000008085314>] ret_from_fork+0x10/0x18
> [45032.835821] INFO: task freeze.sh:2761 blocked for more than 120 
> seconds.
> [45032.845691]       Not tainted 4.14.0-rc5-29338-g01140e9-dirty #802
> [45032.852448] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
> disables this message.
> [45032.861643] freeze.sh       D    0  2761   1434 0x00000000
> [45032.869003] Call trace:
> [45032.872184] [<ffff000008085fa4>] __switch_to+0x94/0xa8
> [45032.879406] [<ffff0000089764c0>] __schedule+0x1a8/0x5c4
> [45032.887821] [<ffff000008976914>] schedule+0x38/0x9c
> [45032.893536] [<ffff0000080e87d0>] 
> async_synchronize_cookie_domain+0x88/0xd4
> [45032.901929] [<ffff0000080e884c>] async_synchronize_full+0x14/0x1c
> [45032.909939] [<ffff00000858b248>] dpm_resume+0x1f4/0x22c
> [45032.916211] [<ffff00000858b43c>] dpm_resume_end+0x14/0x28
> [45032.923147] [<ffff00000810aa6c>] suspend_devices_and_enter+0x174/0x59c
> [45032.931149] [<ffff00000810b0d4>] pm_suspend+0x240/0x310
> [45032.937332] [<ffff000008109aac>] state_store+0x84/0x108
> [45032.944213] [<ffff000008966da0>] kobj_attr_store+0x14/0x24
> [45032.951530] [<ffff00000827c108>] sysfs_kf_write+0x40/0x48
> [45032.957715] [<ffff00000827b424>] kernfs_fop_write+0xc0/0x1d0
> [45032.965180] [<ffff00000820440c>] __vfs_write+0x28/0x124
> [45032.971969] [<ffff0000082046f0>] vfs_write+0xa0/0x198
> [45032.977888] [<ffff00000820496c>] SyS_write+0x44/0xa0
> [45032.984551] Exception stack(0xffff00000ad0bec0 to 0xffff00000ad0c000)
> [45032.992697] bec0: 0000000000000001 000000002e7ca808 
> 0000000000000007 0000000000000000
> [45033.003467] bee0: 0000000000000000 0000ffff90b56140 
> 000000002e7ca80e fefefefefefefefe
> [45033.014204] bf00: 0000000000000040 0000000000000006 
> 7f7f7f7f7f7f7f7f 0101010101010101
> [45033.024031] bf20: 0000000000000030 0000000000000018 
> ffffffffffffffff 00000ab180000000
> [45033.034896] bf40: 0000000000000000 0000ffff90b77644 
> 0000ffffd0175190 0000000000000007
> [45033.045329] bf60: 000000002e7ca808 0000ffff90c544f8 
> 0000000000000007 0000000000000000
> [45033.055841] bf80: 0000000000000001 00000000004c7e28 
> 00000000004ea000 00000000004c8620
> [45033.066824] bfa0: 0000000000000000 0000ffffd0175430 
> 0000ffff90b7e844 0000ffffd0175430
> [45033.076757] bfc0: 0000ffff90bcc108 0000000020000000 
> 0000000000000001 0000000000000040
> [45033.087472] bfe0: 0000000000000000 0000000000000000 
> 0000000000000000 0000000000000000
> [45033.097927] [<ffff0000080837b0>] el0_svc_naked+0x24/0x28
