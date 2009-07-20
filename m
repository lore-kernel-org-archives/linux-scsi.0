From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Possible memory leak via scsi_sysfs_initialize
Date: Mon, 20 Jul 2009 12:58:56 +0100
Message-ID: <1248091136.21585.45.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753123AbZGTL7D@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Kevin Winchester <kjwinchester@gmail.com>, Tony Jones <tonyj@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

Kevin (cc'ed) reported several kmemleak warnings like the one below (I
cc'ed a few others who seem to have pushed related patches in the past):

unreferenced object 0xffff88004e978b68 (size 8):
  comm "scsi_scan_2", pid 1003, jiffies 4294673552
  backtrace:
    [<ffffffff81098cfb>] create_object+0x188/0x25e
    [<ffffffff81098eb7>] kmemleak_alloc+0x26/0x4b
    [<ffffffff81096cb4>] __kmalloc+0x143/0x16d
    [<ffffffff81160939>] kvasprintf+0x45/0x6e
    [<ffffffff81159a6b>] kobject_set_name_vargs+0x23/0x58
    [<ffffffff811e3999>] dev_set_name+0x69/0x6b
    [<ffffffff811f7900>] scsi_sysfs_device_initialize+0xb3/0x10e
    [<ffffffff811f51b0>] scsi_alloc_sdev+0x189/0x1f7
    [<ffffffff811f54b4>] scsi_probe_and_add_lun+0xf4/0x9ff
    [<ffffffff811f5f82>] __scsi_scan_target+0xa2/0x4d8
    [<ffffffff811f640f>] scsi_scan_channel+0x57/0x7d
    [<ffffffff811f64dc>] scsi_scan_host_selected+0xa7/0xe9
    [<ffffffff811f658e>] do_scsi_scan_host+0x70/0x75
    [<ffffffff811f65af>] do_scan_async+0x1c/0x10e
    [<ffffffff81043593>] kthread+0x87/0x8f
    [<ffffffff8100bdea>] child_rip+0xa/0x20

At a first look, these seem to be the objects allocated via
dev_set_name(&sdev->sdev_dev) call in scsi_sysfs_device_initialize(). In
the past, it was only doing a snprintf() rather than dev_set_name so no
allocation occurred.

Now, there should be some put_device(&sdev->sdev_dev) in various places
like scsi_alloc_sdev() (the out_device_destroy path), maybe instead of
put_device(&sdev->sdev_gendev) as the former should be called from
scsi_device_cls_release() via put_device(&sdev->sdev_dev).

Any thoughts?

Thanks.

-- 
Catalin
