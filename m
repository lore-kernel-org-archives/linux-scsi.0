From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons-ud5FBsm0p/xEiooADzr8i9i2O/JbrIOy@public.gmane.org>
Subject: Kernel crash on usb-storage disconnect, multiqueue in use
Date: Wed, 11 Feb 2015 22:25:52 +0100
Message-ID: <20150211222552.625882f6@neptune.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "James E.J. Bottomley" <JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi,

Since 3.19-rcX kernel crashes when I disconnect an external
HDD drive (not sure since which kernel revision tough early
3.19-rcs possibly are not affected).

To reproduce I do:
- connect my disk
- use disk with LUKS (luksOpen)
- stop using disk (luksClose)
- sdparm -C stop /dev/sgX    (sg device corresponding to disk)
- disconnect drive


It looks like this crash is related to the fact that I enable
multiqueue (CONFIG_SCSI_MQ_DEFAULT=y).


Cheers,
Bruno


Trace I get:
[ 8480.692286] usb 4-1: USB disconnect, device number 2
[ 8480.696339] sd 6:0:0:0: [sdd] Synchronizing SCSI cache
[ 8480.696387] general protection fault: 0000 [#1] SMP 
[ 8480.696548] Modules linked in:
[ 8480.696646] CPU: 1 PID: 2745 Comm: kworker/1:2 Not tainted 3.19.0-rc7-kvm+ #9
[ 8480.696778] Hardware name: Gigabyte Technology Co., Ltd. GA-A75M-UD2H/GA-A75M-UD2H, BIOS F6 09/28/2012
[ 8480.696950] Workqueue: usb_hub_wq hub_event
[ 8480.697039] task: ffff8800cea45e00 ti: ffff8801dafa8000 task.ti: ffff8801dafa8000
[ 8480.697170] RIP: 0010:[<ffffffff8134c7ee>]  [<ffffffff8134c7ee>] __bt_get+0x2e/0x1a0
[ 8480.697322] RSP: 0018:ffff8801dafab668  EFLAGS: 00010202
[ 8480.697418] RAX: 6b6b6b6b6b6b6b6b RBX: ffff8800c9f3c9b0 RCX: ffffe8ffffc41980
[ 8480.697546] RDX: ffffe8ffffc41980 RSI: 6b6b6b6b6b6b6b7b RDI: ffff8800c9f3c9b0
[ 8480.697680] RBP: ffff8801dafab6c8 R08: 0000000000000000 R09: ffff8800c1b808e8
[ 8480.697813] R10: ffff8800c1b808e8 R11: ffff88020ec55b40 R12: ffff8801dafab7c8
[ 8480.697942] R13: 0000000000000010 R14: ffffe8ffffc41980 R15: 6b6b6b6b6b6b6b7b
[ 8480.698078] FS:  00007fa8b45dc7c0(0000) GS:ffff88020ec40000(0000) knlGS:00000000f7227700
[ 8480.698230] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 8480.698334] CR2: 00007fa8b5d78410 CR3: 00000000bf328000 CR4: 00000000000007e0
[ 8480.698458] Stack:
[ 8480.698502]  0000000000000000 0000000000000087 ffffe8ffffc41980 ffff8801fe1e6610
[ 8480.698671]  000000000000003a 0000000100220014 0000000000000246 ffff8800c9f3c9b0
[ 8480.698834]  ffff8801dafab7c8 0000000000000010 ffffe8ffffc41980 6b6b6b6b6b6b6b7b
[ 8480.699004] Call Trace:
[ 8480.699066]  [<ffffffff8134c9b5>] bt_get+0x55/0x1a0
[ 8480.699165]  [<ffffffff810fd170>] ? prepare_to_wait_event+0x100/0x100
[ 8480.699294]  [<ffffffff8134ce37>] blk_mq_get_tag+0x97/0xc0
[ 8480.699401]  [<ffffffff81348c36>] __blk_mq_alloc_request+0x16/0x1c0
[ 8480.699517]  [<ffffffff8134a326>] blk_mq_alloc_request+0xa6/0x160
[ 8480.699635]  [<ffffffff8133fd82>] blk_get_request+0x32/0xe0
[ 8480.699743]  [<ffffffff81584ff2>] scsi_execute+0x42/0x170
[ 8480.699847]  [<ffffffff81587114>] scsi_execute_req_flags+0x94/0x100
[ 8480.699965]  [<ffffffff8158ffe1>] sd_sync_cache+0xa1/0x180
[ 8480.700341]  [<ffffffff815904f1>] sd_shutdown+0xe1/0x150
[ 8480.700445]  [<ffffffff815905d1>] sd_remove+0x71/0xd0
[ 8480.700545]  [<ffffffff815662ba>] __device_release_driver+0x7a/0xf0
[ 8480.700663]  [<ffffffff81566357>] device_release_driver+0x27/0x40
[ 8480.700777]  [<ffffffff81565ce7>] bus_remove_device+0xf7/0x140
[ 8480.700887]  [<ffffffff81562909>] device_del+0x139/0x260
[ 8480.700989]  [<ffffffff8135afb0>] ? kobject_put+0x30/0x60
[ 8480.701093]  [<ffffffff8158cc05>] __scsi_remove_device+0xc5/0xd0
[ 8480.701205]  [<ffffffff8158b214>] scsi_forget_host+0x64/0x70
[ 8480.701313]  [<ffffffff8157ffa6>] scsi_remove_host+0x76/0x120
[ 8480.701423]  [<ffffffff8162df0b>] uas_disconnect+0x8b/0xb0
[ 8480.701527]  [<ffffffff815fc720>] usb_unbind_interface+0x1f0/0x2c0
[ 8480.701643]  [<ffffffff815662ba>] __device_release_driver+0x7a/0xf0
[ 8480.701758]  [<ffffffff81566357>] device_release_driver+0x27/0x40
[ 8480.701870]  [<ffffffff81565ce7>] bus_remove_device+0xf7/0x140
[ 8480.701979]  [<ffffffff81562909>] device_del+0x139/0x260
[ 8480.702079]  [<ffffffff815fa13d>] usb_disable_device+0x9d/0x200
[ 8480.702188]  [<ffffffff815f1282>] usb_disconnect+0x82/0x250
[ 8480.702292]  [<ffffffff815f316e>] hub_event+0x82e/0x1170
[ 8480.702391]  [<ffffffff810f5e51>] ? dequeue_task_fair+0x7d1/0x980
[ 8480.702505]  [<ffffffff810ddd98>] process_one_work+0x148/0x400
[ 8480.702612]  [<ffffffff810de168>] worker_thread+0x118/0x440
[ 8480.702715]  [<ffffffff810de050>] ? process_one_work+0x400/0x400
[ 8480.702824]  [<ffffffff810e2db4>] kthread+0xc4/0xe0
[ 8480.702915]  [<ffffffff810e2cf0>] ? kthread_create_on_node+0x190/0x190
[ 8480.703033]  [<ffffffff81860cac>] ret_from_fork+0x7c/0xb0
[ 8480.703131]  [<ffffffff810e2cf0>] ? kthread_create_on_node+0x190/0x190
[ 8480.703244] Code: e5 41 57 49 89 f7 41 56 41 55 41 54 53 48 83 ec 38 48 85 ff 48 89 55 b0 74 4c f6 87 58 01 00 00 02 74 43 48 8b 47 40 a8 02 74 3b <8b>
[ 8480.704507] RIP  [<ffffffff8134c7ee>] __bt_get+0x2e/0x1a0
[ 8480.704863]  RSP <ffff8801dafab668>
[ 8480.732718] ---[ end trace 3b9aeae6798c3642 ]---
[ 8480.751037] BUG: unable to handle kernel paging request at ffffffffffffffd8
[ 8480.751213] IP: [<ffffffff810e335b>] kthread_data+0xb/0x20
[ 8480.751332] PGD 2013067 PUD 2015067 PMD 0 
[ 8480.756048] Oops: 0000 [#2] SMP 
[ 8480.760685] Modules linked in:
[ 8480.765252] CPU: 1 PID: 2745 Comm: kworker/1:2 Tainted: G      D        3.19.0-rc7-kvm+ #9
[ 8480.769857] Hardware name: Gigabyte Technology Co., Ltd. GA-A75M-UD2H/GA-A75M-UD2H, BIOS F6 09/28/2012
[ 8480.774496] task: ffff8800cea45e00 ti: ffff8801dafa8000 task.ti: ffff8801dafa8000
[ 8480.779121] RIP: 0010:[<ffffffff810e335b>]  [<ffffffff810e335b>] kthread_data+0xb/0x20
[ 8480.783766] RSP: 0018:ffff8801dafab3f8  EFLAGS: 00010092
[ 8480.788362] RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000002
[ 8480.792981] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff8800cea45e00
[ 8480.797561] RBP: ffff8801dafab3f8 R08: 0000000000000001 R09: 000000010020000c
[ 8480.802136] R10: ffff880206196800 R11: ffffea0007e20ac0 R12: ffff88020ec52a80
[ 8480.806724] R13: 0000000000000000 R14: 0000000000000001 R15: 6b6b6b6b6b6b6b7b
[ 8480.811317] FS:  00007fa8b45dc7c0(0000) GS:ffff88020ec40000(0000) knlGS:00000000f7227700
[ 8480.815927] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 8480.820501] CR2: 0000000000000028 CR3: 00000000bf328000 CR4: 00000000000007e0
[ 8480.825093] Stack:
[ 8480.829607]  ffff8801dafab418 ffffffff810de990 ffff8801dafab418 ffff8800cea45e00
[ 8480.834250]  ffff8801dafab488 ffffffff8185d1c9 ffff8800cea45e00 0000000000012a80
[ 8480.838884]  ffff8801dafabfd8 0000000000012a80 ffff8801dafab478 ffff8800cea45e00
[ 8480.843506] Call Trace:
[ 8480.848023]  [<ffffffff810de990>] wq_worker_sleeping+0x10/0xa0
[ 8480.852610]  [<ffffffff8185d1c9>] __schedule+0x3e9/0x710
[ 8480.857424]  [<ffffffff8185d514>] schedule+0x24/0x60
[ 8480.861976]  [<ffffffff810ca545>] do_exit+0x685/0xaf0
[ 8480.866512]  [<ffffffff8104937f>] oops_end+0x8f/0xd0
[ 8480.871026]  [<ffffffff81049503>] die+0x53/0x80
[ 8480.875521]  [<ffffffff81046732>] do_general_protection+0xd2/0x160
[ 8480.880049]  [<ffffffff81862602>] general_protection+0x22/0x30
[ 8480.884590]  [<ffffffff8134c7ee>] ? __bt_get+0x2e/0x1a0
[ 8480.889121]  [<ffffffff815b6f74>] ? write_msg+0xe4/0x100
[ 8480.893650]  [<ffffffff8134c9b5>] bt_get+0x55/0x1a0
[ 8480.898184]  [<ffffffff810fd170>] ? prepare_to_wait_event+0x100/0x100
[ 8480.902750]  [<ffffffff8134ce37>] blk_mq_get_tag+0x97/0xc0
[ 8480.907312]  [<ffffffff81348c36>] __blk_mq_alloc_request+0x16/0x1c0
[ 8480.911891]  [<ffffffff8134a326>] blk_mq_alloc_request+0xa6/0x160
[ 8480.916477]  [<ffffffff8133fd82>] blk_get_request+0x32/0xe0
[ 8480.921057]  [<ffffffff81584ff2>] scsi_execute+0x42/0x170
[ 8480.925626]  [<ffffffff81587114>] scsi_execute_req_flags+0x94/0x100
[ 8480.930197]  [<ffffffff8158ffe1>] sd_sync_cache+0xa1/0x180
[ 8480.934784]  [<ffffffff815904f1>] sd_shutdown+0xe1/0x150
[ 8480.939359]  [<ffffffff815905d1>] sd_remove+0x71/0xd0
[ 8480.943911]  [<ffffffff815662ba>] __device_release_driver+0x7a/0xf0
[ 8480.948485]  [<ffffffff81566357>] device_release_driver+0x27/0x40
[ 8480.953058]  [<ffffffff81565ce7>] bus_remove_device+0xf7/0x140
[ 8480.957627]  [<ffffffff81562909>] device_del+0x139/0x260
[ 8480.962190]  [<ffffffff8135afb0>] ? kobject_put+0x30/0x60
[ 8480.966754]  [<ffffffff8158cc05>] __scsi_remove_device+0xc5/0xd0
[ 8480.971341]  [<ffffffff8158b214>] scsi_forget_host+0x64/0x70
[ 8480.975934]  [<ffffffff8157ffa6>] scsi_remove_host+0x76/0x120
[ 8480.980504]  [<ffffffff8162df0b>] uas_disconnect+0x8b/0xb0
[ 8480.985066]  [<ffffffff815fc720>] usb_unbind_interface+0x1f0/0x2c0
[ 8480.989649]  [<ffffffff815662ba>] __device_release_driver+0x7a/0xf0
[ 8480.994240]  [<ffffffff81566357>] device_release_driver+0x27/0x40
[ 8480.998836]  [<ffffffff81565ce7>] bus_remove_device+0xf7/0x140
[ 8481.003422]  [<ffffffff81562909>] device_del+0x139/0x260
[ 8481.007995]  [<ffffffff815fa13d>] usb_disable_device+0x9d/0x200
[ 8481.012569]  [<ffffffff815f1282>] usb_disconnect+0x82/0x250
[ 8481.016996]  [<ffffffff815f316e>] hub_event+0x82e/0x1170
[ 8481.021267]  [<ffffffff810f5e51>] ? dequeue_task_fair+0x7d1/0x980
[ 8481.025532]  [<ffffffff810ddd98>] process_one_work+0x148/0x400
[ 8481.029786]  [<ffffffff810de168>] worker_thread+0x118/0x440
[ 8481.033991]  [<ffffffff810de050>] ? process_one_work+0x400/0x400
[ 8481.038169]  [<ffffffff810e2db4>] kthread+0xc4/0xe0
[ 8481.042317]  [<ffffffff810e2cf0>] ? kthread_create_on_node+0x190/0x190
[ 8481.046507]  [<ffffffff81860cac>] ret_from_fork+0x7c/0xb0
[ 8481.050706]  [<ffffffff810e2cf0>] ? kthread_create_on_node+0x190/0x190
[ 8481.054891] Code: 00 48 89 e5 5d 48 8b 40 c8 48 c1 e8 02 83 e0 01 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 48 8b 87 f0 07 00 00 55 48 89 e5 <48>
[ 8481.064702] RIP  [<ffffffff810e335b>] kthread_data+0xb/0x20
[ 8481.068992]  RSP <ffff8801dafab3f8>
[ 8481.073204] CR2: ffffffffffffffd8
[ 8481.077364] ---[ end trace 3b9aeae6798c3643 ]---
[ 8481.097083] Fixing recursive fault but reboot is needed!
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
