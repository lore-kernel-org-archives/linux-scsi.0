From: Dan Williams <dan.j.williams@intel.com>
Subject: Time to make dynamically allocated devt the default for scsi disks?
Date: Fri, 12 Aug 2016 14:29:30 -0700
Message-ID: <CAPcyv4jK8W52ss2FhJDa=95B_1q8Szv4AmH0f7p_jzyfEXv0Ag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Jens Axboe <axboe@fb.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>, Dave Hansen <dave.hansen@intel.com>, Jej B <James.Bottomley@hansenpartnership.com>
List-Id: linux-scsi@vger.kernel.org

...or, for that matter, any block device driver on a bus that supports hotplug?

In 4.8 Jens merged the following fix for a crash that was triggered by
repeatedly reconfiguring a libnvdimm namespace causing it to destroy
and create disks (rapid hotplug).

    df08c32ce3be block: fix bdi vs gendisk lifetime mismatch

At the time I realized that the fix only addressed block device
drivers that use a dynamic devt and theorized that we still have a
problem with static devt drivers like sd.  Lo and behold Dave was
bitten by this exact scenario:

 WARNING: CPU: 23 PID: 9672 at fs/sysfs/dir.c:31 sysfs_warn_dup+0x62/0x80
 sysfs: cannot create duplicate filename '/devices/virtual/bdi/8:16'
 [..]
 CPU: 23 PID: 9672 Comm: kworker/u66:2 Tainted: G          I
4.6.3-300.fc24.x86_64 #1
 Hardware name: Dell Inc. PowerEdge R710/00NH4P, BIOS 3.0.0 01/31/2011
 Workqueue: events_unbound async_run_entry_fn
  0000000000000286 000000009447a7a4 ffff88004b187a50 ffffffff813dbcff
  ffff88004b187aa0 0000000000000000 ffff88004b187a90 ffffffff810a740b
  0000001f0aa24000 ffff88080aa24000 ffff880809de2260 ffff880e131cbac8
 Call Trace:
  [<ffffffff813dbcff>] dump_stack+0x63/0x84
  [<ffffffff810a740b>] __warn+0xcb/0xf0
  [<ffffffff810a748f>] warn_slowpath_fmt+0x5f/0x80
  [<ffffffff812cd462>] sysfs_warn_dup+0x62/0x80
  [<ffffffff812cd547>] sysfs_create_dir_ns+0x77/0x90
  [<ffffffff813de677>] kobject_add_internal+0xa7/0x330
  [<ffffffff813e7fca>] ? vsnprintf+0x20a/0x500
  [<ffffffff813dee25>] kobject_add+0x75/0xd0
  [<ffffffff815174a3>] ? device_private_init+0x23/0x70
  [<ffffffff817db102>] ? mutex_lock+0x12/0x30
  [<ffffffff8151777b>] device_add+0x28b/0x670
  [<ffffffff81517d50>] device_create_groups_vargs+0xe0/0xf0
  [<ffffffff81517d7c>] device_create_vargs+0x1c/0x20
  [<ffffffff811dd82c>] bdi_register+0x8c/0x180
  [<ffffffff811dd945>] bdi_register_dev+0x25/0x30
  [<ffffffff813bd3b1>] add_disk+0x171/0x490
  [<ffffffff815270b1>] ? update_autosuspend+0x51/0x60
  [<ffffffff8156a7c2>] sd_probe_async+0x112/0x1c0
  [<ffffffff810c997a>] async_run_entry_fn+0x4a/0x140
  [<ffffffff810c0d54>] process_one_work+0x184/0x440
  [<ffffffff810c105e>] worker_thread+0x4e/0x480
  [<ffffffff810c1010>] ? process_one_work+0x440/0x440
  [<ffffffff810c6f48>] kthread+0xd8/0xf0
  [<ffffffff817dd602>] ret_from_fork+0x22/0x40
  [<ffffffff810c6e70>] ? kthread_worker_fn+0x180/0x180

Before spending effort trying to flush the destruction of old bdi
instances before new ones are registered, is it rather time to
complete the conversion of sd to only use dynamically allocated devt?
