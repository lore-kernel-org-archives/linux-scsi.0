From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [lkp-robot] [scsi, block] 0dba1314d4:
 WARNING:at_fs/sysfs/dir.c:#sysfs_warn_dup
Date: Mon, 06 Feb 2017 16:14:27 -0800
Message-ID: <1486426467.2474.122.camel@HansenPartnership.com>
References: <20170204070936.GE12121@yexl-desktop>
         <CAPcyv4j0syAsinM-KbeefKysJhM9zt6kvrX=0c2HrtPV_tRAHQ@mail.gmail.com>
         <CAPcyv4gBQDuj65KRmFvP2q4Qt3d3xycM8L_TypAzYkvhmUSh6A@mail.gmail.com>
         <20170205091314.GA3042@lst.de>
         <CAPcyv4gE0+3pZQV=V75wxddFVhWeAz1abfJ=q8D1Zi+8Oi17rA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAPcyv4gE0+3pZQV=V75wxddFVhWeAz1abfJ=q8D1Zi+8Oi17rA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, Christoph Hellwig <hch@lst.de>
Cc: kernel test robot <xiaolong.ye@intel.com>, Jens Axboe <axboe@fb.com>, Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jan Kara <jack@suse.cz>, Omar Sandoval <osandov@osandov.com>, Omar Sandoval <osandov@fb.com>, LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, LKP <lkp@01.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 2017-02-05 at 21:13 -0800, Dan Williams wrote:
> On Sun, Feb 5, 2017 at 1:13 AM, Christoph Hellwig <hch@lst.de> wrote:
> > Dan,
> > 
> > can you please quote your emails?  I can't find any content 
> > inbetween all these quotes.
> 
> Sorry, I'm using gmail, but I'll switch to attaching the logs.
> 
> So with help from Xiaolong I was able to reproduce this, and it does
> not appear to be a regression. We simply change the failure output of
> an existing bug. Attached is a log of the same test on v4.10-rc7 
> (i.e. without the recent block/scsi fixes), and it shows sda being
> registered twice.
> 
> "[    6.647077] kobject (d5078ca4): tried to init an initialized
> object, something is seriously wrong."
> 
> The change that "scsi, block: fix duplicate bdi name registration
> crashes" makes is to properly try to register sdb since the sda devt
> is still alive. However that's not a fix because we've managed to 
> call blk_register_queue() twice on the same queue.

OK, time to involve others: linux-scsi and linux-block cc'd and I've
inserted the log below.

James

---

[    5.969672] scsi host0: scsi_debug: version 1.86 [20160430]
[    5.969672]   dev_size_mb=8, opts=0x0, submit_queues=1, statistics=0
[    5.971895] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       0186 PQ: 0 ANSI: 7
[    6.006983] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.39 MB/8.00 MiB)
[    6.026965] sd 0:0:0:0: [sda] Write Protect is off
[    6.027870] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    6.066962] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    6.486962] sd 0:0:0:0: [sda] Attached SCSI disk
[    6.488377] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[    6.489455] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    6.526982] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.39 MB/8.00 MiB)
[    6.546964] sd 0:0:0:0: [sda] Write Protect is off
[    6.547873] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    6.586963] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    6.647077] kobject (d5078ca4): tried to init an initialized object, something is seriously wrong.
[    6.648723] CPU: 0 PID: 99 Comm: kworker/u2:1 Not tainted 4.10.0-rc7 #932
[    6.649811] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.1-1.fc24 04/01/2014
[    6.651418] Workqueue: events_unbound async_run_entry_fn
[    6.652347] Call Trace:
[    6.652987]  dump_stack+0x79/0xa4
[    6.653716]  kobject_init+0x75/0x90
[    6.654452]  blk_mq_register_dev+0x2a/0x110
[    6.655269]  blk_register_queue+0x7b/0x130
[    6.656080]  device_add_disk+0x1c6/0x460
[    6.656866]  sd_probe_async+0xf1/0x1c0
[    6.657634]  ? __lock_acquire.isra.14+0x43b/0x940
[    6.658501]  async_run_entry_fn+0x30/0x190
[    6.659311]  ? process_one_work+0x12f/0x430
[    6.660113]  process_one_work+0x1aa/0x430
[    6.660901]  ? process_one_work+0x12f/0x430
[    6.661716]  worker_thread+0x1dd/0x470
[    6.662479]  kthread+0xd4/0x100
[    6.663175]  ? process_one_work+0x430/0x430
[    6.663984]  ? __kthread_create_on_node+0x180/0x180
[    6.664869]  ret_from_fork+0x21/0x2c
[    6.665638] kobject (ffab51ec): tried to init an initialized object, something is seriously wrong.
[    6.667290] CPU: 0 PID: 99 Comm: kworker/u2:1 Not tainted 4.10.0-rc7 #932
[    6.668372] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.1-1.fc24 04/01/2014
[    6.669984] Workqueue: events_unbound async_run_entry_fn
[    6.670909] Call Trace:
[    6.671540]  dump_stack+0x79/0xa4
[    6.672266]  kobject_init+0x75/0x90
[    6.673011]  blk_mq_register_dev+0x4c/0x110
[    6.673832]  blk_register_queue+0x7b/0x130
[    6.674633]  device_add_disk+0x1c6/0x460
[    6.675413]  sd_probe_async+0xf1/0x1c0
[    6.676191]  ? __lock_acquire.isra.14+0x43b/0x940
[    6.677057]  async_run_entry_fn+0x30/0x190
[    6.677860]  ? process_one_work+0x12f/0x430
[    6.678667]  process_one_work+0x1aa/0x430
[    6.679455]  ? process_one_work+0x12f/0x430
[    6.680269]  worker_thread+0x1dd/0x470
[    6.681036]  kthread+0xd4/0x100
[    6.681737]  ? process_one_work+0x430/0x430
[    6.682540]  ? __kthread_create_on_node+0x180/0x180
[    6.683420]  ret_from_fork+0x21/0x2c
[    6.684207] ------------[ cut here ]------------
[    6.685067] WARNING: CPU: 0 PID: 99 at ./include/linux/kref.h:46 kobject_get+0x7f/0x90
[    6.686592] CPU: 0 PID: 99 Comm: kworker/u2:1 Not tainted 4.10.0-rc7 #932
[    6.687680] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.1-1.fc24 04/01/2014
[    6.689280] Workqueue: events_unbound async_run_entry_fn
[    6.690208] Call Trace:
[    6.690843]  dump_stack+0x79/0xa4
[    6.691563]  __warn+0xd2/0xf0
[    6.692246]  ? kobject_get+0x7f/0x90
[    6.692992]  warn_slowpath_null+0x25/0x30
[    6.693787]  kobject_get+0x7f/0x90
[    6.694505]  kobject_add_internal+0x2e/0x360
[    6.695322]  ? kfree_const+0x18/0x20
[    6.696071]  ? kobject_set_name_vargs+0x62/0x80
[    6.696914]  kobject_add+0x35/0x80
[    6.697642]  blk_mq_register_hctx+0x95/0xc0
[    6.698447]  blk_mq_register_dev+0xc9/0x110
[    6.699255]  blk_register_queue+0x7b/0x130
[    6.700059]  device_add_disk+0x1c6/0x460
[    6.700849]  sd_probe_async+0xf1/0x1c0
[    6.701628]  ? __lock_acquire.isra.14+0x43b/0x940
[    6.702484]  async_run_entry_fn+0x30/0x190
[    6.703284]  ? process_one_work+0x12f/0x430
[    6.704098]  process_one_work+0x1aa/0x430
[    6.704894]  ? process_one_work+0x12f/0x430
[    6.705704]  worker_thread+0x1dd/0x470
[    6.706488]  kthread+0xd4/0x100
[    6.707198]  ? process_one_work+0x430/0x430
[    6.708016]  ? __kthread_create_on_node+0x180/0x180
[    6.708909]  ret_from_fork+0x21/0x2c
[    6.709676] ---[ end trace 1a7726d7c3d3c8d0 ]---
[    5.969672] scsi host0: scsi_debug: version 1.86 [20160430]
[    5.969672]   dev_size_mb=8, opts=0x0, submit_queues=1, statistics=0
[    5.971895] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       0186 PQ: 0 ANSI: 7
[    6.006983] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.39 MB/8.00 MiB)
[    6.026965] sd 0:0:0:0: [sda] Write Protect is off
[    6.027870] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    6.066962] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    6.486962] sd 0:0:0:0: [sda] Attached SCSI disk
[    6.488377] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[    6.489455] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    6.526982] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.39 MB/8.00 MiB)
[    6.546964] sd 0:0:0:0: [sda] Write Protect is off
[    6.547873] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    6.586963] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    6.647077] kobject (d5078ca4): tried to init an initialized object, something is seriously wrong.
[    6.648723] CPU: 0 PID: 99 Comm: kworker/u2:1 Not tainted 4.10.0-rc7 #932
[    6.649811] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.1-1.fc24 04/01/2014
[    6.651418] Workqueue: events_unbound async_run_entry_fn
[    6.652347] Call Trace:
[    6.652987]  dump_stack+0x79/0xa4
[    6.653716]  kobject_init+0x75/0x90
[    6.654452]  blk_mq_register_dev+0x2a/0x110
[    6.655269]  blk_register_queue+0x7b/0x130
[    6.656080]  device_add_disk+0x1c6/0x460
[    6.656866]  sd_probe_async+0xf1/0x1c0
[    6.657634]  ? __lock_acquire.isra.14+0x43b/0x940
[    6.658501]  async_run_entry_fn+0x30/0x190
[    6.659311]  ? process_one_work+0x12f/0x430
[    6.660113]  process_one_work+0x1aa/0x430
[    6.660901]  ? process_one_work+0x12f/0x430
[    6.661716]  worker_thread+0x1dd/0x470
[    6.662479]  kthread+0xd4/0x100
[    6.663175]  ? process_one_work+0x430/0x430
[    6.663984]  ? __kthread_create_on_node+0x180/0x180
[    6.664869]  ret_from_fork+0x21/0x2c
[    6.665638] kobject (ffab51ec): tried to init an initialized object, something is seriously wrong.
[    6.667290] CPU: 0 PID: 99 Comm: kworker/u2:1 Not tainted 4.10.0-rc7 #932
[    6.668372] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.1-1.fc24 04/01/2014
[    6.669984] Workqueue: events_unbound async_run_entry_fn
[    6.670909] Call Trace:
[    6.671540]  dump_stack+0x79/0xa4
[    6.672266]  kobject_init+0x75/0x90
[    6.673011]  blk_mq_register_dev+0x4c/0x110
[    6.673832]  blk_register_queue+0x7b/0x130
[    6.674633]  device_add_disk+0x1c6/0x460
[    6.675413]  sd_probe_async+0xf1/0x1c0
[    6.676191]  ? __lock_acquire.isra.14+0x43b/0x940
[    6.677057]  async_run_entry_fn+0x30/0x190
[    6.677860]  ? process_one_work+0x12f/0x430
[    6.678667]  process_one_work+0x1aa/0x430
[    6.679455]  ? process_one_work+0x12f/0x430
[    6.680269]  worker_thread+0x1dd/0x470
[    6.681036]  kthread+0xd4/0x100
[    6.681737]  ? process_one_work+0x430/0x430
[    6.682540]  ? __kthread_create_on_node+0x180/0x180
[    6.683420]  ret_from_fork+0x21/0x2c
[    6.684207] ------------[ cut here ]------------
[    6.685067] WARNING: CPU: 0 PID: 99 at ./include/linux/kref.h:46 kobject_get+0x7f/0x90
[    6.686592] CPU: 0 PID: 99 Comm: kworker/u2:1 Not tainted 4.10.0-rc7 #932
[    6.687680] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.1-1.fc24 04/01/2014
[    6.689280] Workqueue: events_unbound async_run_entry_fn
[    6.690208] Call Trace:
[    6.690843]  dump_stack+0x79/0xa4
[    6.691563]  __warn+0xd2/0xf0
[    6.692246]  ? kobject_get+0x7f/0x90
[    6.692992]  warn_slowpath_null+0x25/0x30
[    6.693787]  kobject_get+0x7f/0x90
[    6.694505]  kobject_add_internal+0x2e/0x360
[    6.695322]  ? kfree_const+0x18/0x20
[    6.696071]  ? kobject_set_name_vargs+0x62/0x80
[    6.696914]  kobject_add+0x35/0x80
[    6.697642]  blk_mq_register_hctx+0x95/0xc0
[    6.698447]  blk_mq_register_dev+0xc9/0x110
[    6.699255]  blk_register_queue+0x7b/0x130
[    6.700059]  device_add_disk+0x1c6/0x460
[    6.700849]  sd_probe_async+0xf1/0x1c0
[    6.701628]  ? __lock_acquire.isra.14+0x43b/0x940
[    6.702484]  async_run_entry_fn+0x30/0x190
[    6.703284]  ? process_one_work+0x12f/0x430
[    6.704098]  process_one_work+0x1aa/0x430
[    6.704894]  ? process_one_work+0x12f/0x430
[    6.705704]  worker_thread+0x1dd/0x470
[    6.706488]  kthread+0xd4/0x100
[    6.707198]  ? process_one_work+0x430/0x430
[    6.708016]  ? __kthread_create_on_node+0x180/0x180
[    6.708909]  ret_from_fork+0x21/0x2c
[    6.709676] ---[ end trace 1a7726d7c3d3c8d0 ]---
[    5.969672] scsi host0: scsi_debug: version 1.86 [20160430]
[    5.969672]   dev_size_mb=8, opts=0x0, submit_queues=1, statistics=0
[    5.971895] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       0186 PQ: 0 ANSI: 7
[    6.006983] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.39 MB/8.00 MiB)
[    6.026965] sd 0:0:0:0: [sda] Write Protect is off
[    6.027870] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    6.066962] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    6.486962] sd 0:0:0:0: [sda] Attached SCSI disk
[    6.488377] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[    6.489455] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    6.526982] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.39 MB/8.00 MiB)
[    6.546964] sd 0:0:0:0: [sda] Write Protect is off
[    6.547873] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    6.586963] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    6.647077] kobject (d5078ca4): tried to init an initialized object, something is seriously wrong.
[    6.648723] CPU: 0 PID: 99 Comm: kworker/u2:1 Not tainted 4.10.0-rc7 #932
[    6.649811] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.1-1.fc24 04/01/2014
[    6.651418] Workqueue: events_unbound async_run_entry_fn
[    6.652347] Call Trace:
[    6.652987]  dump_stack+0x79/0xa4
[    6.653716]  kobject_init+0x75/0x90
[    6.654452]  blk_mq_register_dev+0x2a/0x110
[    6.655269]  blk_register_queue+0x7b/0x130
[    6.656080]  device_add_disk+0x1c6/0x460
[    6.656866]  sd_probe_async+0xf1/0x1c0
[    6.657634]  ? __lock_acquire.isra.14+0x43b/0x940
[    6.658501]  async_run_entry_fn+0x30/0x190
[    6.659311]  ? process_one_work+0x12f/0x430
[    6.660113]  process_one_work+0x1aa/0x430
[    6.660901]  ? process_one_work+0x12f/0x430
[    6.661716]  worker_thread+0x1dd/0x470
[    6.662479]  kthread+0xd4/0x100
[    6.663175]  ? process_one_work+0x430/0x430
[    6.663984]  ? __kthread_create_on_node+0x180/0x180
[    6.664869]  ret_from_fork+0x21/0x2c
[    6.665638] kobject (ffab51ec): tried to init an initialized object, something is seriously wrong.
[    6.667290] CPU: 0 PID: 99 Comm: kworker/u2:1 Not tainted 4.10.0-rc7 #932
[    6.668372] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.1-1.fc24 04/01/2014
[    6.669984] Workqueue: events_unbound async_run_entry_fn
[    6.670909] Call Trace:
[    6.671540]  dump_stack+0x79/0xa4
[    6.672266]  kobject_init+0x75/0x90
[    6.673011]  blk_mq_register_dev+0x4c/0x110
[    6.673832]  blk_register_queue+0x7b/0x130
[    6.674633]  device_add_disk+0x1c6/0x460
[    6.675413]  sd_probe_async+0xf1/0x1c0
[    6.676191]  ? __lock_acquire.isra.14+0x43b/0x940
[    6.677057]  async_run_entry_fn+0x30/0x190
[    6.677860]  ? process_one_work+0x12f/0x430
[    6.678667]  process_one_work+0x1aa/0x430
[    6.679455]  ? process_one_work+0x12f/0x430
[    6.680269]  worker_thread+0x1dd/0x470
[    6.681036]  kthread+0xd4/0x100
[    6.681737]  ? process_one_work+0x430/0x430
[    6.682540]  ? __kthread_create_on_node+0x180/0x180
[    6.683420]  ret_from_fork+0x21/0x2c
[    6.684207] ------------[ cut here ]------------
[    6.685067] WARNING: CPU: 0 PID: 99 at ./include/linux/kref.h:46 kobject_get+0x7f/0x90
[    6.686592] CPU: 0 PID: 99 Comm: kworker/u2:1 Not tainted 4.10.0-rc7 #932
[    6.687680] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.1-1.fc24 04/01/2014
[    6.689280] Workqueue: events_unbound async_run_entry_fn
[    6.690208] Call Trace:
[    6.690843]  dump_stack+0x79/0xa4
[    6.691563]  __warn+0xd2/0xf0
[    6.692246]  ? kobject_get+0x7f/0x90
[    6.692992]  warn_slowpath_null+0x25/0x30
[    6.693787]  kobject_get+0x7f/0x90
[    6.694505]  kobject_add_internal+0x2e/0x360
[    6.695322]  ? kfree_const+0x18/0x20
[    6.696071]  ? kobject_set_name_vargs+0x62/0x80
[    6.696914]  kobject_add+0x35/0x80
[    6.697642]  blk_mq_register_hctx+0x95/0xc0
[    6.698447]  blk_mq_register_dev+0xc9/0x110
[    6.699255]  blk_register_queue+0x7b/0x130
[    6.700059]  device_add_disk+0x1c6/0x460
[    6.700849]  sd_probe_async+0xf1/0x1c0
[    6.701628]  ? __lock_acquire.isra.14+0x43b/0x940
[    6.702484]  async_run_entry_fn+0x30/0x190
[    6.703284]  ? process_one_work+0x12f/0x430
[    6.704098]  process_one_work+0x1aa/0x430
[    6.704894]  ? process_one_work+0x12f/0x430
[    6.705704]  worker_thread+0x1dd/0x470
[    6.706488]  kthread+0xd4/0x100
[    6.707198]  ? process_one_work+0x430/0x430
[    6.708016]  ? __kthread_create_on_node+0x180/0x180
[    6.708909]  ret_from_fork+0x21/0x2c
[    6.709676] ---[ end trace 1a7726d7c3d3c8d0 ]---
[    5.969672] scsi host0: scsi_debug: version 1.86 [20160430]
[    5.969672]   dev_size_mb=8, opts=0x0, submit_queues=1, statistics=0
[    5.971895] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       0186 PQ: 0 ANSI: 7
[    6.006983] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.39 MB/8.00 MiB)
[    6.026965] sd 0:0:0:0: [sda] Write Protect is off
[    6.027870] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    6.066962] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    6.486962] sd 0:0:0:0: [sda] Attached SCSI disk
[    6.488377] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[    6.489455] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    6.526982] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.39 MB/8.00 MiB)
[    6.546964] sd 0:0:0:0: [sda] Write Protect is off
[    6.547873] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    6.586963] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    6.647077] kobject (d5078ca4): tried to init an initialized object, something is seriously wrong.
[    6.648723] CPU: 0 PID: 99 Comm: kworker/u2:1 Not tainted 4.10.0-rc7 #932
[    6.649811] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.1-1.fc24 04/01/2014
[    6.651418] Workqueue: events_unbound async_run_entry_fn
[    6.652347] Call Trace:
[    6.652987]  dump_stack+0x79/0xa4
[    6.653716]  kobject_init+0x75/0x90
[    6.654452]  blk_mq_register_dev+0x2a/0x110
[    6.655269]  blk_register_queue+0x7b/0x130
[    6.656080]  device_add_disk+0x1c6/0x460
[    6.656866]  sd_probe_async+0xf1/0x1c0
[    6.657634]  ? __lock_acquire.isra.14+0x43b/0x940
[    6.658501]  async_run_entry_fn+0x30/0x190
[    6.659311]  ? process_one_work+0x12f/0x430
[    6.660113]  process_one_work+0x1aa/0x430
[    6.660901]  ? process_one_work+0x12f/0x430
[    6.661716]  worker_thread+0x1dd/0x470
[    6.662479]  kthread+0xd4/0x100
[    6.663175]  ? process_one_work+0x430/0x430
[    6.663984]  ? __kthread_create_on_node+0x180/0x180
[    6.664869]  ret_from_fork+0x21/0x2c
[    6.665638] kobject (ffab51ec): tried to init an initialized object, something is seriously wrong.
[    6.667290] CPU: 0 PID: 99 Comm: kworker/u2:1 Not tainted 4.10.0-rc7 #932
[    6.668372] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.1-1.fc24 04/01/2014
[    6.669984] Workqueue: events_unbound async_run_entry_fn
[    6.670909] Call Trace:
[    6.671540]  dump_stack+0x79/0xa4
[    6.672266]  kobject_init+0x75/0x90
[    6.673011]  blk_mq_register_dev+0x4c/0x110
[    6.673832]  blk_register_queue+0x7b/0x130
[    6.674633]  device_add_disk+0x1c6/0x460
[    6.675413]  sd_probe_async+0xf1/0x1c0
[    6.676191]  ? __lock_acquire.isra.14+0x43b/0x940
[    6.677057]  async_run_entry_fn+0x30/0x190
[    6.677860]  ? process_one_work+0x12f/0x430
[    6.678667]  process_one_work+0x1aa/0x430
[    6.679455]  ? process_one_work+0x12f/0x430
[    6.680269]  worker_thread+0x1dd/0x470
[    6.681036]  kthread+0xd4/0x100
[    6.681737]  ? process_one_work+0x430/0x430
[    6.682540]  ? __kthread_create_on_node+0x180/0x180
[    6.683420]  ret_from_fork+0x21/0x2c
[    6.684207] ------------[ cut here ]------------
[    6.685067] WARNING: CPU: 0 PID: 99 at ./include/linux/kref.h:46 kobject_get+0x7f/0x90
[    6.686592] CPU: 0 PID: 99 Comm: kworker/u2:1 Not tainted 4.10.0-rc7 #932
[    6.687680] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.1-1.fc24 04/01/2014
[    6.689280] Workqueue: events_unbound async_run_entry_fn
[    6.690208] Call Trace:
[    6.690843]  dump_stack+0x79/0xa4
[    6.691563]  __warn+0xd2/0xf0
[    6.692246]  ? kobject_get+0x7f/0x90
[    6.692992]  warn_slowpath_null+0x25/0x30
[    6.693787]  kobject_get+0x7f/0x90
[    6.694505]  kobject_add_internal+0x2e/0x360
[    6.695322]  ? kfree_const+0x18/0x20
[    6.696071]  ? kobject_set_name_vargs+0x62/0x80
[    6.696914]  kobject_add+0x35/0x80
[    6.697642]  blk_mq_register_hctx+0x95/0xc0
[    6.698447]  blk_mq_register_dev+0xc9/0x110
[    6.699255]  blk_register_queue+0x7b/0x130
[    6.700059]  device_add_disk+0x1c6/0x460
[    6.700849]  sd_probe_async+0xf1/0x1c0
[    6.701628]  ? __lock_acquire.isra.14+0x43b/0x940
[    6.702484]  async_run_entry_fn+0x30/0x190
[    6.703284]  ? process_one_work+0x12f/0x430
[    6.704098]  process_one_work+0x1aa/0x430
[    6.704894]  ? process_one_work+0x12f/0x430
[    6.705704]  worker_thread+0x1dd/0x470
[    6.706488]  kthread+0xd4/0x100
[    6.707198]  ? process_one_work+0x430/0x430
[    6.708016]  ? __kthread_create_on_node+0x180/0x180
[    6.708909]  ret_from_fork+0x21/0x2c
[    6.709676] ---[ end trace 1a7726d7c3d3c8d0 ]---
[    5.969672] scsi host0: scsi_debug: version 1.86 [20160430]
[    5.969672]   dev_size_mb=8, opts=0x0, submit_queues=1, statistics=0
[    5.971895] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       0186 PQ: 0 ANSI: 7
[    6.006983] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.39 MB/8.00 MiB)
[    6.026965] sd 0:0:0:0: [sda] Write Protect is off
[    6.027870] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    6.066962] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    6.486962] sd 0:0:0:0: [sda] Attached SCSI disk
[    6.488377] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[    6.489455] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    6.526982] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.39 MB/8.00 MiB)
[    6.546964] sd 0:0:0:0: [sda] Write Protect is off
[    6.547873] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    6.586963] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    6.647077] kobject (d5078ca4): tried to init an initialized object, something is seriously wrong.
[    6.648723] CPU: 0 PID: 99 Comm: kworker/u2:1 Not tainted 4.10.0-rc7 #932
[    6.649811] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.1-1.fc24 04/01/2014
[    6.651418] Workqueue: events_unbound async_run_entry_fn
[    6.652347] Call Trace:
[    6.652987]  dump_stack+0x79/0xa4
[    6.653716]  kobject_init+0x75/0x90
[    6.654452]  blk_mq_register_dev+0x2a/0x110
[    6.655269]  blk_register_queue+0x7b/0x130
[    6.656080]  device_add_disk+0x1c6/0x460
[    6.656866]  sd_probe_async+0xf1/0x1c0
[    6.657634]  ? __lock_acquire.isra.14+0x43b/0x940
[    6.658501]  async_run_entry_fn+0x30/0x190
[    6.659311]  ? process_one_work+0x12f/0x430
[    6.660113]  process_one_work+0x1aa/0x430
[    6.660901]  ? process_one_work+0x12f/0x430
[    6.661716]  worker_thread+0x1dd/0x470
[    6.662479]  kthread+0xd4/0x100
[    6.663175]  ? process_one_work+0x430/0x430
[    6.663984]  ? __kthread_create_on_node+0x180/0x180
[    6.664869]  ret_from_fork+0x21/0x2c
[    6.665638] kobject (ffab51ec): tried to init an initialized object, something is seriously wrong.
[    6.667290] CPU: 0 PID: 99 Comm: kworker/u2:1 Not tainted 4.10.0-rc7 #932
[    6.668372] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.1-1.fc24 04/01/2014
[    6.669984] Workqueue: events_unbound async_run_entry_fn
[    6.670909] Call Trace:
[    6.671540]  dump_stack+0x79/0xa4
[    6.672266]  kobject_init+0x75/0x90
[    6.673011]  blk_mq_register_dev+0x4c/0x110
[    6.673832]  blk_register_queue+0x7b/0x130
[    6.674633]  device_add_disk+0x1c6/0x460
[    6.675413]  sd_probe_async+0xf1/0x1c0
[    6.676191]  ? __lock_acquire.isra.14+0x43b/0x940
[    6.677057]  async_run_entry_fn+0x30/0x190
[    6.677860]  ? process_one_work+0x12f/0x430
[    6.678667]  process_one_work+0x1aa/0x430
[    6.679455]  ? process_one_work+0x12f/0x430
[    6.680269]  worker_thread+0x1dd/0x470
[    6.681036]  kthread+0xd4/0x100
[    6.681737]  ? process_one_work+0x430/0x430
[    6.682540]  ? __kthread_create_on_node+0x180/0x180
[    6.683420]  ret_from_fork+0x21/0x2c
[    6.684207] ------------[ cut here ]------------
[    6.685067] WARNING: CPU: 0 PID: 99 at ./include/linux/kref.h:46 kobject_get+0x7f/0x90
[    6.686592] CPU: 0 PID: 99 Comm: kworker/u2:1 Not tainted 4.10.0-rc7 #932
[    6.687680] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.1-1.fc24 04/01/2014
[    6.689280] Workqueue: events_unbound async_run_entry_fn
[    6.690208] Call Trace:
[    6.690843]  dump_stack+0x79/0xa4
[    6.691563]  __warn+0xd2/0xf0
[    6.692246]  ? kobject_get+0x7f/0x90
[    6.692992]  warn_slowpath_null+0x25/0x30
[    6.693787]  kobject_get+0x7f/0x90
[    6.694505]  kobject_add_internal+0x2e/0x360
[    6.695322]  ? kfree_const+0x18/0x20
[    6.696071]  ? kobject_set_name_vargs+0x62/0x80
[    6.696914]  kobject_add+0x35/0x80
[    6.697642]  blk_mq_register_hctx+0x95/0xc0
[    6.698447]  blk_mq_register_dev+0xc9/0x110
[    6.699255]  blk_register_queue+0x7b/0x130
[    6.700059]  device_add_disk+0x1c6/0x460
[    6.700849]  sd_probe_async+0xf1/0x1c0
[    6.701628]  ? __lock_acquire.isra.14+0x43b/0x940
[    6.702484]  async_run_entry_fn+0x30/0x190
[    6.703284]  ? process_one_work+0x12f/0x430
[    6.704098]  process_one_work+0x1aa/0x430
[    6.704894]  ? process_one_work+0x12f/0x430
[    6.705704]  worker_thread+0x1dd/0x470
[    6.706488]  kthread+0xd4/0x100
[    6.707198]  ? process_one_work+0x430/0x430
[    6.708016]  ? __kthread_create_on_node+0x180/0x180
[    6.708909]  ret_from_fork+0x21/0x2c
[    6.709676] ---[ end trace 1a7726d7c3d3c8d0 ]---
csi host0: scsi_debug: version 1.86 [20160430]
[    5.969672]   dev_size_mb=8, opts=0x0, submit_queues=1, statistics=0
[    5.971895] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       0186 PQ: 0 ANSI: 7
[    6.006983] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.39 MB/8.00 MiB)
[    6.026965] sd 0:0:0:0: [sda] Write Protect is off
[    6.027870] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    6.066962] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    6.486962] sd 0:0:0:0: [sda] Attached SCSI disk
[    6.488377] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[    6.489455] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    6.526982] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.39 MB/8.00 MiB)
[    6.546964] sd 0:0:0:0: [sda] Write Protect is off
[    6.547873] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    6.586963] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    6.647077] kobject (d5078ca4): tried to init an initialized object, something is seriously wrong.
[    6.648723] CPU: 0 PID: 99 Comm: kworker/u2:1 Not tainted 4.10.0-rc7 #932
[    6.649811] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.1-1.fc24 04/01/2014
[    6.651418] Workqueue: events_unbound async_run_entry_fn
[    6.652347] Call Trace:
[    6.652987]  dump_stack+0x79/0xa4
[    6.653716]  kobject_init+0x75/0x90
[    6.654452]  blk_mq_register_dev+0x2a/0x110
[    6.655269]  blk_register_queue+0x7b/0x130
[    6.656080]  device_add_disk+0x1c6/0x460
[    6.656866]  sd_probe_async+0xf1/0x1c0
[    6.657634]  ? __lock_acquire.isra.14+0x43b/0x940
[    6.658501]  async_run_entry_fn+0x30/0x190
[    6.659311]  ? process_one_work+0x12f/0x430
[    6.660113]  process_one_work+0x1aa/0x430
[    6.660901]  ? process_one_work+0x12f/0x430
[    6.661716]  worker_thread+0x1dd/0x470
[    6.662479]  kthread+0xd4/0x100
[    6.663175]  ? process_one_work+0x430/0x430
[    6.663984]  ? __kthread_create_on_node+0x180/0x180
[    6.664869]  ret_from_fork+0x21/0x2c
[    6.665638] kobject (ffab51ec): tried to init an initialized object, something is seriously wrong.
[    6.667290] CPU: 0 PID: 99 Comm: kworker/u2:1 Not tainted 4.10.0-rc7 #932
[    6.668372] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.1-1.fc24 04/01/2014
[    6.669984] Workqueue: events_unbound async_run_entry_fn
[    6.670909] Call Trace:
[    6.671540]  dump_stack+0x79/0xa4
[    6.672266]  kobject_init+0x75/0x90
[    6.673011]  blk_mq_register_dev+0x4c/0x110
[    6.673832]  blk_register_queue+0x7b/0x130
[    6.674633]  device_add_disk+0x1c6/0x460
[    6.675413]  sd_probe_async+0xf1/0x1c0
[    6.676191]  ? __lock_acquire.isra.14+0x43b/0x940
[    6.677057]  async_run_entry_fn+0x30/0x190
[    6.677860]  ? process_one_work+0x12f/0x430
[    6.678667]  process_one_work+0x1aa/0x430
[    6.679455]  ? process_one_work+0x12f/0x430
[    6.680269]  worker_thread+0x1dd/0x470
[    6.681036]  kthread+0xd4/0x100
[    6.681737]  ? process_one_work+0x430/0x430
[    6.682540]  ? __kthread_create_on_node+0x180/0x180
[    6.683420]  ret_from_fork+0x21/0x2c
[    6.684207] ------------[ cut here ]------------
[    6.685067] WARNING: CPU: 0 PID: 99 at ./include/linux/kref.h:46 kobject_get+0x7f/0x90
[    6.686592] CPU: 0 PID: 99 Comm: kworker/u2:1 Not tainted 4.10.0-rc7 #932
[    6.687680] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.1-1.fc24 04/01/2014
[    6.689280] Workqueue: events_unbound async_run_entry_fn
[    6.690208] Call Trace:
[    6.690843]  dump_stack+0x79/0xa4
[    6.691563]  __warn+0xd2/0xf0
[    6.692246]  ? kobject_get+0x7f/0x90
[    6.692992]  warn_slowpath_null+0x25/0x30
[    6.693787]  kobject_get+0x7f/0x90
[    6.694505]  kobject_add_internal+0x2e/0x360
[    6.695322]  ? kfree_const+0x18/0x20
[    6.696071]  ? kobject_set_name_vargs+0x62/0x80
[    6.696914]  kobject_add+0x35/0x80
[    6.697642]  blk_mq_register_hctx+0x95/0xc0
[    6.698447]  blk_mq_register_dev+0xc9/0x110
[    6.699255]  blk_register_queue+0x7b/0x130
[    6.700059]  device_add_disk+0x1c6/0x460
[    6.700849]  sd_probe_async+0xf1/0x1c0
[    6.701628]  ? __lock_acquire.isra.14+0x43b/0x940
[    6.702484]  async_run_entry_fn+0x30/0x190
[    6.703284]  ? process_one_work+0x12f/0x430
[    6.704098]  process_one_work+0x1aa/0x430
[    6.704894]  ? process_one_work+0x12f/0x430
[    6.705704]  worker_thread+0x1dd/0x470
[    6.706488]  kthread+0xd4/0x100
[    6.707198]  ? process_one_work+0x430/0x430
[    6.708016]  ? __kthread_create_on_node+0x180/0x180
[    6.708909]  ret_from_fork+0x21/0x2c
[    6.709676] ---[ end trace 1a7726d7c3d3c8d0 ]---
