From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [lkp-robot] [rcu] b332151a29: kernel_BUG_at_mm/slab.c
Date: Fri, 20 Jan 2017 17:23:54 +0100
Message-ID: <20170120162354.776bf2j75o247mzu@linutronix.de>
References: <20170119010216.GA8287@yexl-desktop>
 <20170120160123.z4llgm4qaaemkp52@linutronix.de>
 <32585b54-c2fd-66ea-e636-bdbd387133c1@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <32585b54-c2fd-66ea-e636-bdbd387133c1@kernel.dk>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: kernel test robot <xiaolong.ye@intel.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, LKML <linux-kernel@vger.kernel.org>, lkp@01.org, linux-scsi@vger.kernel.org, tglx@linutronix.de, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2017-01-20 08:09:36 [-0800], Jens Axboe wrote:
> Is there a full trace of this?

[    3.654003] scsi host0: scsi_debug: version 1.86 [20160430]
[    3.654003]   dev_size_mb=8, opts=0x0, submit_queues=1, statistics=0
[    3.660755] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       0186 PQ: 0 ANSI: 7
[    3.711231] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.39 MB/8.00 MiB)
[    3.716202] sd 0:0:0:0: [sda] Write Protect is off
[    3.717244] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    3.725059] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    3.795093] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.796686] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[    3.804770] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.39 MB/8.00 MiB)
[    3.809748] sd 0:0:0:0: [sda] Write Protect is off
[    3.810806] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    3.818599] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    3.830894] kobject (be01a5fc): tried to init an initialized object, something is seriously wrong.
[    3.832820] CPU: 6 PID: 6 Comm: kworker/u14:0 Not tainted 4.9.0 #86
[    3.834172] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.1-1 04/01/2014
[    3.835886] Workqueue: events_unbound async_run_entry_fn
[    3.837028]  80079da8 83a5f6cc be01a5fc be01a5fc 80079dc4 83a61e33 842a883c be01a5fc
[    3.838802]  ffffffff 84397488 be01a108 80079dec 83a46afa be01a5d8 840670a0 be01a5d8
[    3.840570]  be01a108 bd983468 be01a108 bd983470 be01a5d8 80079e14 83a3c857 be01a5d8
[    3.842350] Call Trace:
[    3.842884]  [<83a5f6cc>] dump_stack+0x58/0x7c
[    3.843834]  [<83a61e33>] kobject_init+0x73/0x80
[    3.844828]  [<83a46afa>] blk_mq_register_dev+0x2a/0x110
[    3.845971]  [<83a3c857>] blk_register_queue+0x87/0x140
[    3.847085]  [<83a49c7e>] device_add_disk+0x1ce/0x470
[    3.848170]  [<83c3d328>] sd_probe_async+0xe8/0x1b0
[    3.849207]  [<83672347>] async_run_entry_fn+0x37/0xe0
[    3.850313]  [<836694f7>] process_one_work+0x1b7/0x3e0
[    3.851414]  [<8366947c>] ? process_one_work+0x13c/0x3e0
[    3.852552]  [<83669759>] worker_thread+0x39/0x460
[    3.853569]  [<83669720>] ? process_one_work+0x3e0/0x3e0
[    3.854717]  [<8366f394>] kthread+0xb4/0xd0
[    3.855611]  [<83f8cb4d>] ? _raw_spin_unlock_irq+0x2d/0x50
[    3.856775]  [<8366f2e0>] ? __kthread_create_on_node+0x160/0x160
[    3.858066]  [<8366f2e0>] ? __kthread_create_on_node+0x160/0x160
[    3.859340]  [<83f8d363>] ret_from_fork+0x1b/0x28
[    3.863951] kobject (ff0ca36c): tried to init an initialized object, something is seriously wrong.
[    3.865875] CPU: 6 PID: 6 Comm: kworker/u14:0 Not tainted 4.9.0 #86
[    3.867202] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.1-1 04/01/2014
[    3.868924] Workqueue: events_unbound async_run_entry_fn
[    3.870079]  80079da8 83a5f6cc ff0ca36c be01a5fc 80079dc4 83a61e33 842a883c ff0ca36c
[    3.871846]  80079dc4 84397474 be01a108 80079dec 83a46b1c be01a5d8 840670a0 be01a5d8
[    3.873605]  be01a108 bd983468 be01a108 bd983470 be01a5d8 80079e14 83a3c857 be01a5d8
[    3.875395] Call Trace:
[    3.875928]  [<83a5f6cc>] dump_stack+0x58/0x7c
[    3.876878]  [<83a61e33>] kobject_init+0x73/0x80
[    3.877884]  [<83a46b1c>] blk_mq_register_dev+0x4c/0x110
[    3.879018]  [<83a3c857>] blk_register_queue+0x87/0x140
[    3.880136]  [<83a49c7e>] device_add_disk+0x1ce/0x470
[    3.881227]  [<83c3d328>] sd_probe_async+0xe8/0x1b0
[    3.882283]  [<83672347>] async_run_entry_fn+0x37/0xe0
[    3.883381]  [<836694f7>] process_one_work+0x1b7/0x3e0
[    3.884481]  [<8366947c>] ? process_one_work+0x13c/0x3e0
[    3.885613]  [<83669759>] worker_thread+0x39/0x460
[    3.886658]  [<83669720>] ? process_one_work+0x3e0/0x3e0
[    3.887791]  [<8366f394>] kthread+0xb4/0xd0
[    3.888680]  [<83f8cb4d>] ? _raw_spin_unlock_irq+0x2d/0x50
[    3.889881]  [<8366f2e0>] ? __kthread_create_on_node+0x160/0x160
[    3.891189]  [<8366f2e0>] ? __kthread_create_on_node+0x160/0x160
[    3.892506]  [<83f8d363>] ret_from_fork+0x1b/0x28
[    3.893563] kobject (ff21b36c): tried to init an initialized object, something is seriously wrong.
[    3.895559] CPU: 6 PID: 6 Comm: kworker/u14:0 Not tainted 4.9.0 #86
[    3.896938] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.1-1 04/01/2014
[    3.898741] Workqueue: events_unbound async_run_entry_fn
[    3.899911]  80079da8 83a5f6cc ff21b36c be01a5fc 80079dc4 83a61e33 842a883c ff21b36c
[    3.901739]  80079dc4 84397474 be01a108 80079dec 83a46b1c be01a5d8 840670a0 be01a5d8
[    3.903558]  be01a108 bd983468 be01a108 bd983470 be01a5d8 80079e14 83a3c857 be01a5d8
[    3.905381] Call Trace:
[    3.905936]  [<83a5f6cc>] dump_stack+0x58/0x7c
[    3.906913]  [<83a61e33>] kobject_init+0x73/0x80
[    3.907931]  [<83a46b1c>] blk_mq_register_dev+0x4c/0x110
[    3.909108]  [<83a3c857>] blk_register_queue+0x87/0x140
[    3.910267]  [<83a49c7e>] device_add_disk+0x1ce/0x470
[    3.911387]  [<83c3d328>] sd_probe_async+0xe8/0x1b0
[    3.912466]  [<83672347>] async_run_entry_fn+0x37/0xe0
[    3.913596]  [<836694f7>] process_one_work+0x1b7/0x3e0
[    3.914735]  [<8366947c>] ? process_one_work+0x13c/0x3e0
[    3.915916]  [<83669759>] worker_thread+0x39/0x460
[    3.916977]  [<83669720>] ? process_one_work+0x3e0/0x3e0
[    3.918159]  [<8366f394>] kthread+0xb4/0xd0
[    3.919097]  [<83f8cb4d>] ? _raw_spin_unlock_irq+0x2d/0x50
[    3.920322]  [<8366f2e0>] ? __kthread_create_on_node+0x160/0x160
[    3.921656]  [<8366f2e0>] ? __kthread_create_on_node+0x160/0x160
[    3.922992]  [<83f8d363>] ret_from_fork+0x1b/0x28
[    3.924045] kobject (ff36c36c): tried to init an initialized object, something is seriously wrong.
[    3.926026] CPU: 6 PID: 6 Comm: kworker/u14:0 Not tainted 4.9.0 #86
[    3.927408] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.1-1 04/01/2014
[    3.929193] Workqueue: events_unbound async_run_entry_fn
[    3.930404]  80079da8 83a5f6cc ff36c36c be01a5fc 80079dc4 83a61e33 842a883c ff36c36c
[    3.932214]  80079dc4 84397474 be01a108 80079dec 83a46b1c be01a5d8 840670a0 be01a5d8
[    3.934042]  be01a108 bd983468 be01a108 bd983470 be01a5d8 80079e14 83a3c857 be01a5d8
[    3.935857] Call Trace:
[    3.936401]  [<83a5f6cc>] dump_stack+0x58/0x7c
[    3.937382]  [<83a61e33>] kobject_init+0x73/0x80
[    3.938412]  [<83a46b1c>] blk_mq_register_dev+0x4c/0x110
[    3.939579]  [<83a3c857>] blk_register_queue+0x87/0x140
[    3.940731]  [<83a49c7e>] device_add_disk+0x1ce/0x470
[    3.941848]  [<83c3d328>] sd_probe_async+0xe8/0x1b0
[    3.942929]  [<83672347>] async_run_entry_fn+0x37/0xe0
[    3.944063]  [<836694f7>] process_one_work+0x1b7/0x3e0
[    3.945193]  [<8366947c>] ? process_one_work+0x13c/0x3e0
[    3.946371]  [<83669759>] worker_thread+0x39/0x460
[    3.947430]  [<83669720>] ? process_one_work+0x3e0/0x3e0
[    3.948599]  [<8366f394>] kthread+0xb4/0xd0
[    3.949522]  [<83f8cb4d>] ? _raw_spin_unlock_irq+0x2d/0x50
[    3.950733]  [<8366f2e0>] ? __kthread_create_on_node+0x160/0x160
[    3.952053]  [<8366f2e0>] ? __kthread_create_on_node+0x160/0x160
[    3.953372]  [<83f8d363>] ret_from_fork+0x1b/0x28
[    3.954436] kobject (ff4bd36c): tried to init an initialized object, something is seriously wrong.
[    3.956391] CPU: 6 PID: 6 Comm: kworker/u14:0 Not tainted 4.9.0 #86
[    3.957774] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.1-1 04/01/2014
[    3.959548] Workqueue: events_unbound async_run_entry_fn
[    3.960737]  80079da8 83a5f6cc ff4bd36c be01a5fc 80079dc4 83a61e33 842a883c ff4bd36c
[    3.962558]  80079dc4 84397474 be01a108 80079dec 83a46b1c be01a5d8 840670a0 be01a5d8
[    3.964369]  be01a108 bd983468 be01a108 bd983470 be01a5d8 80079e14 83a3c857 be01a5d8
[    3.966196] Call Trace:
[    3.966740]  [<83a5f6cc>] dump_stack+0x58/0x7c
[    3.967738]  [<83a61e33>] kobject_init+0x73/0x80
[    3.968754]  [<83a46b1c>] blk_mq_register_dev+0x4c/0x110
[    3.969934]  [<83a3c857>] blk_register_queue+0x87/0x140
[    3.971079]  [<83a49c7e>] device_add_disk+0x1ce/0x470
[    3.972194]  [<83c3d328>] sd_probe_async+0xe8/0x1b0
[    3.973268]  [<83672347>] async_run_entry_fn+0x37/0xe0
[    3.974407]  [<836694f7>] process_one_work+0x1b7/0x3e0
[    3.975531]  [<8366947c>] ? process_one_work+0x13c/0x3e0
[    3.976695]  [<83669759>] worker_thread+0x39/0x460
[    3.977768]  [<83669720>] ? process_one_work+0x3e0/0x3e0
[    3.978932]  [<8366f394>] kthread+0xb4/0xd0
[    3.979844]  [<83f8cb4d>] ? _raw_spin_unlock_irq+0x2d/0x50
[    3.981057]  [<8366f2e0>] ? __kthread_create_on_node+0x160/0x160
[    3.982395]  [<8366f2e0>] ? __kthread_create_on_node+0x160/0x160
[    3.983714]  [<83f8d363>] ret_from_fork+0x1b/0x28
[    3.984762] kobject (ff60e36c): tried to init an initialized object, something is seriously wrong.
[    3.986726] CPU: 6 PID: 6 Comm: kworker/u14:0 Not tainted 4.9.0 #86
[    3.988103] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.1-1 04/01/2014
[    3.989879] Workqueue: events_unbound async_run_entry_fn
[    3.991076]  80079da8 83a5f6cc ff60e36c be01a5fc 80079dc4 83a61e33 842a883c ff60e36c
[    3.992896]  80079dc4 84397474 be01a108 80079dec 83a46b1c be01a5d8 840670a0 be01a5d8
[    3.994719]  be01a108 bd983468 be01a108 bd983470 be01a5d8 80079e14 83a3c857 be01a5d8
[    3.996516] Call Trace:
[    3.997057]  [<83a5f6cc>] dump_stack+0x58/0x7c
[    3.998047]  [<83a61e33>] kobject_init+0x73/0x80
[    3.999058]  [<83a46b1c>] blk_mq_register_dev+0x4c/0x110
[    4.000233]  [<83a3c857>] blk_register_queue+0x87/0x140
[    4.001399]  [<83a49c7e>] device_add_disk+0x1ce/0x470
[    4.002516]  [<83c3d328>] sd_probe_async+0xe8/0x1b0
[    4.003578]  [<83672347>] async_run_entry_fn+0x37/0xe0
[    4.004707]  [<836694f7>] process_one_work+0x1b7/0x3e0
[    4.005835]  [<8366947c>] ? process_one_work+0x13c/0x3e0
[    4.006950]  [<83669759>] worker_thread+0x39/0x460
[    4.007965]  [<83669720>] ? process_one_work+0x3e0/0x3e0
[    4.009076]  [<8366f394>] kthread+0xb4/0xd0
[    4.009963]  [<83f8cb4d>] ? _raw_spin_unlock_irq+0x2d/0x50
[    4.011120]  [<8366f2e0>] ? __kthread_create_on_node+0x160/0x160
[    4.012379]  [<8366f2e0>] ? __kthread_create_on_node+0x160/0x160
[    4.013655]  [<83f8d363>] ret_from_fork+0x1b/0x28
[    4.014676] kobject (ff75f36c): tried to init an initialized object, something is seriously wrong.
[    4.016562] CPU: 6 PID: 6 Comm: kworker/u14:0 Not tainted 4.9.0 #86
[    4.017923] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.1-1 04/01/2014
[    4.019768] Workqueue: events_unbound async_run_entry_fn
[    4.020980]  80079da8 83a5f6cc ff75f36c be01a5fc 80079dc4 83a61e33 842a883c ff75f36c
[    4.022862]  80079dc4 84397474 be01a108 80079dec 83a46b1c be01a5d8 840670a0 be01a5d8
[    4.024742]  be01a108 bd983468 be01a108 bd983470 be01a5d8 80079e14 83a3c857 be01a5d8
[    4.026624] Call Trace:
[    4.027185]  [<83a5f6cc>] dump_stack+0x58/0x7c
[    4.028181]  [<83a61e33>] kobject_init+0x73/0x80
[    4.029199]  [<83a46b1c>] blk_mq_register_dev+0x4c/0x110
[    4.030390]  [<83a3c857>] blk_register_queue+0x87/0x140
[    4.031550]  [<83a49c7e>] device_add_disk+0x1ce/0x470
[    4.032672]  [<83c3d328>] sd_probe_async+0xe8/0x1b0
[    4.033755]  [<83672347>] async_run_entry_fn+0x37/0xe0
[    4.034895]  [<836694f7>] process_one_work+0x1b7/0x3e0
[    4.036027]  [<8366947c>] ? process_one_work+0x13c/0x3e0
[    4.037197]  [<83669759>] worker_thread+0x39/0x460
[    4.038275]  [<83669720>] ? process_one_work+0x3e0/0x3e0
[    4.039444]  [<8366f394>] kthread+0xb4/0xd0
[    4.040379]  [<83f8cb4d>] ? _raw_spin_unlock_irq+0x2d/0x50
[    4.041625]  [<8366f2e0>] ? __kthread_create_on_node+0x160/0x160
[    4.042951]  [<8366f2e0>] ? __kthread_create_on_node+0x160/0x160
[    4.044271]  [<83f8d363>] ret_from_fork+0x1b/0x28
[    4.045327] kobject (ff8b036c): tried to init an initialized object, something is seriously wrong.
[    4.047323] CPU: 6 PID: 6 Comm: kworker/u14:0 Not tainted 4.9.0 #86
[    4.048707] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.1-1 04/01/2014
[    4.050501] Workqueue: events_unbound async_run_entry_fn
[    4.051689]  80079da8 83a5f6cc ff8b036c be01a5fc 80079dc4 83a61e33 842a883c ff8b036c
[    4.053517]  80079dc4 84397474 be01a108 80079dec 83a46b1c be01a5d8 840670a0 be01a5d8
[    4.055352]  be01a108 bd983468 be01a108 bd983470 be01a5d8 80079e14 83a3c857 be01a5d8
[    4.057173] Call Trace:
[    4.057732]  [<83a5f6cc>] dump_stack+0x58/0x7c
[    4.058722]  [<83a61e33>] kobject_init+0x73/0x80
[    4.059738]  [<83a46b1c>] blk_mq_register_dev+0x4c/0x110
[    4.060907]  [<83a3c857>] blk_register_queue+0x87/0x140
[    4.062073]  [<83a49c7e>] device_add_disk+0x1ce/0x470
[    4.063205]  [<83c3d328>] sd_probe_async+0xe8/0x1b0
[    4.064286]  [<83672347>] async_run_entry_fn+0x37/0xe0
[    4.065427]  [<836694f7>] process_one_work+0x1b7/0x3e0
[    4.066569]  [<8366947c>] ? process_one_work+0x13c/0x3e0
[    4.067749]  [<83669759>] worker_thread+0x39/0x460
[    4.068805]  [<83669720>] ? process_one_work+0x3e0/0x3e0
[    4.070001]  [<8366f394>] kthread+0xb4/0xd0
[    4.070946]  [<83f8cb4d>] ? _raw_spin_unlock_irq+0x2d/0x50
[    4.072153]  [<8366f2e0>] ? __kthread_create_on_node+0x160/0x160
[    4.073487]  [<8366f2e0>] ? __kthread_create_on_node+0x160/0x160
[    4.074829]  [<83f8d363>] ret_from_fork+0x1b/0x28
[    4.075943] ------------[ cut here ]------------
[    4.076984] WARNING: CPU: 6 PID: 6 at include/linux/kref.h:46 kobject_get+0x7f/0x90
[    4.079356] CPU: 6 PID: 6 Comm: kworker/u14:0 Not tainted 4.9.0 #86
[    4.080746] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.1-1 04/01/2014
[    4.082548] Workqueue: events_unbound async_run_entry_fn
[    4.083731]  80079ce8 83a5f6cc 00000000 84268d0c 80079d18 83654c82 84268e68 00000006
[    4.085551]  00000006 84268d0c 0000002e 83a61ebf 0000002e bd917554 00000000 bd917400
[    4.087383]  80079d2c 83654d41 00000009 00000000 00000000 80079d4c 83a61ebf 3b1c2000
[    4.089206] Call Trace:
[    4.089765]  [<83a5f6cc>] dump_stack+0x58/0x7c
[    4.090772]  [<83654c82>] __warn+0xe2/0x100
[    4.091695]  [<83a61ebf>] ? kobject_get+0x7f/0x90
[    4.092748]  [<83654d41>] warn_slowpath_null+0x21/0x30
[    4.093907]  [<83a61ebf>] kobject_get+0x7f/0x90
[    4.094933]  [<83a624ae>] kobject_add_internal+0x2e/0x2d0
[    4.096131]  [<83713de8>] ? kfree_const+0x18/0x20
[    4.097163]  [<83a61d7b>] ? kobject_set_name_vargs+0x6b/0x90
[    4.098434]  [<83a62785>] kobject_add+0x35/0x80
[    4.099435]  [<83a46951>] blk_mq_register_hctx+0x91/0xb0
[    4.100626]  [<83a46b97>] blk_mq_register_dev+0xc7/0x110
[    4.101819]  [<83a3c857>] blk_register_queue+0x87/0x140
[    4.102963]  [<83a49c7e>] device_add_disk+0x1ce/0x470
[    4.104081]  [<83c3d328>] sd_probe_async+0xe8/0x1b0
[    4.105167]  [<83672347>] async_run_entry_fn+0x37/0xe0
[    4.106309]  [<836694f7>] process_one_work+0x1b7/0x3e0
[    4.107448]  [<8366947c>] ? process_one_work+0x13c/0x3e0
[    4.108629]  [<83669759>] worker_thread+0x39/0x460
[    4.109696]  [<83669720>] ? process_one_work+0x3e0/0x3e0
[    4.110886]  [<8366f394>] kthread+0xb4/0xd0
[    4.111813]  [<83f8cb4d>] ? _raw_spin_unlock_irq+0x2d/0x50
[    4.113022]  [<8366f2e0>] ? __kthread_create_on_node+0x160/0x160
[    4.114360]  [<8366f2e0>] ? __kthread_create_on_node+0x160/0x160
[    4.115688]  [<83f8d363>] ret_from_fork+0x1b/0x28
[    4.117286] ---[ end trace 0425d358b6d5b2f0 ]---
[    4.145499] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.147003] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[    4.177323] scsi host0: scsi_debug: version 1.86 [20160430]
[    4.177323]   dev_size_mb=8, opts=0x0, submit_queues=1, statistics=0
[    4.180742] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       0186 PQ: 0 ANSI: 7
[    4.254491] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.39 MB/8.00 MiB)
[    4.259480] sd 0:0:0:0: [sda] Write Protect is off
[    4.260536] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    4.268380] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    4.311266] Slab corruption (Tainted: G        W      ): kmalloc-32 start=803d3420, len=32
[    4.313051] 000: 73 64 61 00 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  sda.ZZZZZZZZZZZZ
[    4.314719] 010: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a a5  ZZZZZZZZZZZZZZZ.
[    4.316351] Prev obj: start=803d3400, len=32
[    4.317265] 000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    4.318920] 010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    4.320546] Next obj: start=803d3440, len=32
[    4.321482] 000: 72 65 71 75 65 73 74 5f 73 6f 63 6b 5f 54 43 50  request_sock_TCP
[    4.323133] 010: 00 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a a5  .ZZZZZZZZZZZZZZ.
[    4.351856] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.353307] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[    4.355710] Slab corruption (Tainted: G        W      ): kmalloc-32 start=803d36e0, len=32
[    4.357519] 000: 32 35 30 3a 30 00 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  250:0.ZZZZZZZZZZ
[    4.359148] 010: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a a5  ZZZZZZZZZZZZZZZ.
[    4.360790] Prev obj: start=803d36c0, len=32
[    4.361390] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.39 MB/8.00 MiB)
[    4.363279] 000: 30 30 3a 30 31 00 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  00:01.ZZZZZZZZZZ
[    4.364780] sd 0:0:0:0: [sda] Write Protect is off
[    4.364782] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    4.367051] 010: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a a5  ZZZZZZZZZZZZZZZ.
[    4.368712] Next obj: start=803d3700, len=32
[    4.369642] 000: 30 3a 30 3a 30 3a 30 00 5a 5a 5a 5a 5a 5a 5a 5a  0:0:0:0.ZZZZZZZZ
[    4.371290] 010: [    4.371499] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    4.373485] 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a a5  ZZZZZZZZZZZZZZZ.
[    4.377287] Slab corruption (Tainted: G        W      ): kmalloc-32 start=be7f4d80, len=32
[    4.379068] 000: 30 3a 30 3a 30 3a 30 00 5a 5a 5a 5a 5a 5a 5a 5a  0:0:0:0.ZZZZZZZZ
[    4.380719] 010: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a a5  ZZZZZZZZZZZZZZZ.
[    4.381641] ------------[ cut here ]------------
[    4.381646] WARNING: CPU: 6 PID: 6 at fs/sysfs/dir.c:31 sysfs_warn_dup+0x60/0x80
[    4.381647] sysfs: cannot create duplicate filename '/class/block/sda'
[    4.381649] CPU: 6 PID: 6 Comm: kworker/u14:0 Tainted: G        W       4.9.0 #86
[    4.381650] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.1-1 04/01/2014
[    4.381653] Workqueue: events_unbound async_run_entry_fn
[    4.381657]  80079d34 83a5f6cc 80079d78 842785c8 80079d64 83654c82 84278594 80079d94
[    4.381662]  00000006 842785c8 0000001f 837b89e0 0000001f be427000 be7f4040 8027ef80
[    4.381666]  80079d80 83654cd4 00000009 00000000 80079d78 84278594 80079d94 80079da8
[    4.381666] Call Trace:
[    4.381669]  [<83a5f6cc>] dump_stack+0x58/0x7c
[    4.381673]  [<83654c82>] __warn+0xe2/0x100
[    4.381675]  [<837b89e0>] ? sysfs_warn_dup+0x60/0x80
[    4.381676]  [<83654cd4>] warn_slowpath_fmt+0x34/0x40
[    4.381678]  [<837b89e0>] sysfs_warn_dup+0x60/0x80
[    4.381680]  [<837b8cb6>] sysfs_do_create_link_sd.isra.0+0xb6/0xd0
[    4.381682]  [<837b8d10>] sysfs_create_link+0x20/0x40
[    4.381686]  [<83b8469f>] device_add+0x1df/0x5d0
[    4.381688]  [<83713eb8>] ? kstrdup_const+0x18/0x20
[    4.381690]  [<83a6eb49>] ? kvasprintf_const+0x59/0x90
[    4.381692]  [<83713de8>] ? kfree_const+0x18/0x20
[    4.381694]  [<83a61d7b>] ? kobject_set_name_vargs+0x6b/0x90
[    4.381696]  [<83a49c6f>] device_add_disk+0x1bf/0x470
[    4.381699]  [<83b92c06>] ? __pm_runtime_use_autosuspend+0x56/0x70
[    4.381703]  [<83c3d328>] sd_probe_async+0xe8/0x1b0
[    4.381704]  [<83672347>] async_run_entry_fn+0x37/0xe0
[    4.381707]  [<836694f7>] process_one_work+0x1b7/0x3e0
[    4.381708]  [<8366947c>] ? process_one_work+0x13c/0x3e0
[    4.381710]  [<83669759>] worker_thread+0x39/0x460
[    4.381712]  [<83669720>] ? process_one_work+0x3e0/0x3e0
[    4.381713]  [<8366f394>] kthread+0xb4/0xd0
[    4.381716]  [<83f8cb4d>] ? _raw_spin_unlock_irq+0x2d/0x50
[    4.381718]  [<8366f2e0>] ? __kthread_create_on_node+0x160/0x160
[    4.381719]  [<8366f2e0>] ? __kthread_create_on_node+0x160/0x160
[    4.381721]  [<83f8d363>] ret_from_fork+0x1b/0x28
[    4.381722] ---[ end trace 0425d358b6d5b2f1 ]---
[    4.381738] ------------[ cut here ]------------
[    4.381740] WARNING: CPU: 6 PID: 6 at lib/kobject.c:244 kobject_add_internal+0xf0/0x2d0
[    4.381741] kobject_add_internal failed for queue (error: -2 parent: sda)
[    4.381742] CPU: 6 PID: 6 Comm: kworker/u14:0 Tainted: G        W       4.9.0 #86
[    4.381743] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.1-1 04/01/2014
[    4.381745] Workqueue: events_unbound async_run_entry_fn
[    4.381749]  80079d4c 83a5f6cc 80079d90 842a88e0 80079d7c 83654c82 842a8a40 80079dac
[    4.381753]  00000006 842a88e0 000000f4 83a62570 000000f4 be01ade0 00000000 bd983870
[    4.381757]  80079d98 83654cd4 00000009 00000000 80079d90 842a8a40 80079dac 80079dd0
[    4.381758] Call Trace:
[    4.381760]  [<83a5f6cc>] dump_stack+0x58/0x7c
[    4.381761]  [<83654c82>] __warn+0xe2/0x100
[    4.381763]  [<83a62570>] ? kobject_add_internal+0xf0/0x2d0
[    4.381765]  [<83654cd4>] warn_slowpath_fmt+0x34/0x40
[    4.381767]  [<83a62570>] kobject_add_internal+0xf0/0x2d0
[    4.381768]  [<83a62785>] kobject_add+0x35/0x80
[    4.381770]  [<83713eb8>] ? kstrdup_const+0x18/0x20
[    4.381773]  [<83a3c834>] blk_register_queue+0x64/0x140
[    4.381775]  [<83a49c7e>] device_add_disk+0x1ce/0x470
[    4.381777]  [<83b92c06>] ? __pm_runtime_use_autosuspend+0x56/0x70
[    4.381779]  [<83c3d328>] sd_probe_async+0xe8/0x1b0
[    4.381780]  [<83672347>] async_run_entry_fn+0x37/0xe0
[    4.381782]  [<836694f7>] process_one_work+0x1b7/0x3e0
[    4.381784]  [<8366947c>] ? process_one_work+0x13c/0x3e0
[    4.381785]  [<83669759>] worker_thread+0x39/0x460
[    4.381787]  [<83669720>] ? process_one_work+0x3e0/0x3e0
[    4.381788]  [<8366f394>] kthread+0xb4/0xd0
[    4.381790]  [<83f8cb4d>] ? _raw_spin_unlock_irq+0x2d/0x50
[    4.381792]  [<8366f2e0>] ? __kthread_create_on_node+0x160/0x160
[    4.381793]  [<8366f2e0>] ? __kthread_create_on_node+0x160/0x160
[    4.381795]  [<83f8d363>] ret_from_fork+0x1b/0x28
[    4.381795] ---[ end trace 0425d358b6d5b2f2 ]---
[    4.381796] ------------[ cut here ]------------
[    4.381798] WARNING: CPU: 6 PID: 6 at block/genhd.c:632 device_add_disk+0x3ef/0x470
[    4.381800] CPU: 6 PID: 6 Comm: kworker/u14:0 Tainted: G        W       4.9.0 #86
[    4.381800] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.1-1 04/01/2014
[    4.381802] Workqueue: events_unbound async_run_entry_fn
[    4.381806]  80079dd0 83a5f6cc 00000000 842a6920 80079e00 83654c82 84268e68 00000006
[    4.381810]  00000006 842a6920 00000278 83a49e9f 00000278 bd983800 bd983868 bd983870
[    4.381814]  80079e14 83654d41 00000009 00000000 00000000 80079e54 83a49e9f bd983868
[    4.381814] Call Trace:
[    4.381816]  [<83a5f6cc>] dump_stack+0x58/0x7c
[    4.381818]  [<83654c82>] __warn+0xe2/0x100
[    4.381819]  [<83a49e9f>] ? device_add_disk+0x3ef/0x470
[    4.381821]  [<83654d41>] warn_slowpath_null+0x21/0x30
[    4.381823]  [<83a49e9f>] device_add_disk+0x3ef/0x470
[    4.381825]  [<83b92c06>] ? __pm_runtime_use_autosuspend+0x56/0x70
[    4.381827]  [<83c3d328>] sd_probe_async+0xe8/0x1b0
[    4.381828]  [<83672347>] async_run_entry_fn+0x37/0xe0
[    4.381830]  [<836694f7>] process_one_work+0x1b7/0x3e0
[    4.381831]  [<8366947c>] ? process_one_work+0x13c/0x3e0
[    4.381833]  [<83669759>] worker_thread+0x39/0x460
[    4.381835]  [<83669720>] ? process_one_work+0x3e0/0x3e0
[    4.381836]  [<8366f394>] kthread+0xb4/0xd0
[    4.381838]  [<83f8cb4d>] ? _raw_spin_unlock_irq+0x2d/0x50
[    4.381839]  [<8366f2e0>] ? __kthread_create_on_node+0x160/0x160
[    4.381841]  [<8366f2e0>] ? __kthread_create_on_node+0x160/0x160
[    4.381842]  [<83f8d363>] ret_from_fork+0x1b/0x28
[    4.381843] ---[ end trace 0425d358b6d5b2f3 ]---
[    4.381851] ------------[ cut here ]------------
[    4.381852] kernel BUG at fs/sysfs/file.c:330!
[    4.381853] invalid opcode: 0000 [#1] PREEMPT SMP
[    4.381854] CPU: 6 PID: 6 Comm: kworker/u14:0 Tainted: G        W       4.9.0 #86
[    4.381855] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.1-1 04/01/2014
[    4.381856] Workqueue: events_unbound async_run_entry_fn
[    4.381857] task: 80076300 task.stack: 80078000
[    4.381858] EIP: 0060:[<837b86b0>] EFLAGS: 00210246 CPU: 6
[    4.381860] EIP is at sysfs_create_file_ns+0x30/0x40
[    4.381861] EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 84026764
[    4.381862] ESI: bd983870 EDI: 84397640 EBP: 80079e14 ESP: 80079dfc
[    4.381863]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[    4.381864] CR0: 80050033 CR2: ffffffff CR3: 04617000 CR4: 000006b0
[    4.381867] Stack:
[    4.381871]  837b87cf 80079e14 bd983870 bd983800 bd983868 bd983870 80079e54 83a49cc7
[    4.381874]  bd983868 8429adcd bd98380c bd983800 be01a910 bd98380c 00800000 83b92c06
[    4.381878]  be01a910 bd925800 bd983800 be429400 bd925800 bd983800 80079e80 83c3d328
[    4.381878] Call Trace:
[    4.381880]  [<837b87cf>] ? sysfs_create_files+0x2f/0x90
[    4.381882]  [<83a49cc7>] device_add_disk+0x217/0x470
[    4.381884]  [<83b92c06>] ? __pm_runtime_use_autosuspend+0x56/0x70
[    4.381885]  [<83c3d328>] sd_probe_async+0xe8/0x1b0
[    4.381887]  [<83672347>] async_run_entry_fn+0x37/0xe0
[    4.381888]  [<836694f7>] process_one_work+0x1b7/0x3e0
[    4.381890]  [<8366947c>] ? process_one_work+0x13c/0x3e0
[    4.381891]  [<83669759>] worker_thread+0x39/0x460
[    4.381893]  [<83669720>] ? process_one_work+0x3e0/0x3e0
[    4.381894]  [<8366f394>] kthread+0xb4/0xd0
[    4.381896]  [<83f8cb4d>] ? _raw_spin_unlock_irq+0x2d/0x50
[    4.381897]  [<8366f2e0>] ? __kthread_create_on_node+0x160/0x160
[    4.381898]  [<8366f2e0>] ? __kthread_create_on_node+0x160/0x160
[    4.381900]  [<83f8d363>] ret_from_fork+0x1b/0x28
[    4.381921] Code: 40 18 85 c0 74 25 85 d2 74 21 55 89 e5 83 ec 08 89 4c 24 04 0f b7 4a 04 89 0c 24 31 c9 e8 99 fd ff ff c9 c3 8d b4 26 00 00 00 00 <0f> 0b 8d b4 26 00 00 00 00 8d bc 27 00 00 00 00 55 89 e5 56 89
[    4.381923] EIP: [<837b86b0>] 
[    4.381924] sysfs_create_file_ns+0x30/0x40
[    4.381924]  SS:ESP 0068:80079dfc
[    4.381928] ---[ end trace 0425d358b6d5b2f4 ]---
[    4.381929] Kernel panic - not syncing: Fatal exception
[    4.382334] Kernel Offset: 0x2600000 from 0x81000000 (relocation range: 0x80000000-0xc07d4fff)
[    4.439732] ---[ end Kernel panic - not syncing: Fatal exception

> > yes. With and without the patch there is a lot of wrong stuff like
> > complains about a kobject initialized again. This leads to a double free
> > at some point.
> 
> And what patch are we talking about? I don't mind being CC'ed into a thread,
> but some context and background would be immensely helpful here...

The patch is irrelevant. lkp-robot found a bug which was there before
the patch in question but the pattern changed so it blamed the Author.
It triggers even v4.9 with
  CONFIG_SCSI_DEBUG
  CONFIG_DEBUG_TEST_DRIVER_REMOVE
  CONFIG_SCSI_MQ_DEFAULT
enabled and CONFIG_SCSI_DEBUG is simply a SCSI host controller which is
always there. I can send you a complete config against current HEAD
which boots in kvm if you want.

Sebastian
