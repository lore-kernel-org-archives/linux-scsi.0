From: Alan Stern <stern@rowland.harvard.edu>
Subject: WARNING in block layer triggered in 3.17-rc3
Date: Fri, 5 Sep 2014 13:45:03 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1409051340450.879-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@kernel.dk>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Kernel development list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

James and Jens:

I got a WARNING when unbinding the sd driver from a USB flash drive and
then binding it back again.  Here's where the flash drive gets probed 
initially:

[  143.300886] usb-storage 4-8:1.0: usb_probe_interface
[  143.300911] usb-storage 4-8:1.0: usb_probe_interface - got id
[  143.300930] usb-storage 4-8:1.0: USB Mass Storage device detected
[  143.318239] scsi host0: usb-storage 4-8:1.0
[  143.359979] scsi 0:0:0:0: Direct-Access     Ut165    USB2FlashStorage 0.00 PQ: 0 ANSI: 2
[  143.376366] usbcore: registered new interface driver usb-storage
[  143.468464] sd 0:0:0:0: [sda] 7892040 512-byte logical blocks: (4.04 GB/3.76 GiB)
[  143.481725] sd 0:0:0:0: [sda] Write Protect is off
[  143.485712] sd 0:0:0:0: [sda] Mode Sense: 00 00 00 00
[  143.487064] sd 0:0:0:0: [sda] Asking for cache data failed
[  143.498428] sd 0:0:0:0: [sda] Assuming drive cache: write through
[  143.656797]  sda: sda1
[  143.676922] sd 0:0:0:0: [sda] Attached SCSI removable disk

Then I did

	echo 0:0:0:0 >/sys/bus/scsi/drivers/sd_mod/unbind

followed by

	echo 0:0:0:0 >/sys/bus/scsi/drivers/sd_mod/bind

which resulted in:

[  165.079557] sd 0:0:0:0: [sda] 7892040 512-byte logical blocks: (4.04 GB/3.76 GiB)
[  165.093510] sd 0:0:0:0: [sda] Write Protect is off
[  165.104388] sd 0:0:0:0: [sda] Mode Sense: 00 00 00 00
[  165.105632] sd 0:0:0:0: [sda] Asking for cache data failed
[  165.115136] sd 0:0:0:0: [sda] Assuming drive cache: write through
[  165.142950]  sda: sda1
[  165.156480] ------------[ cut here ]------------
[  165.159912] WARNING: CPU: 0 PID: 29 at block/blk-core.c:473 blk_queue_bypass_end+0x4d/0x62()
[  165.160030] Modules linked in: sd_mod usb_storage scsi_mod hid_generic usbhid hid pcspkr evdev i915 cfbfillrect cfbimgblt i2c_algo_bit cfbcopyarea video fbcon backlight bitblit softcursor font ehci_pci drm_kms_helper uhci_hcd ehci_hcd ohci_pci ohci_hcd drm i2ccore usbcore e100 mii usb_common fb fbdev fan processor button thermal_sys
[  165.160030] CPU: 0 PID: 29 Comm: kworker/u4:1 Not tainted 3.17.0-rc3AS-dirty #12
[  165.160030] Hardware name: Hewlett-Packard HP dx2000 MT (EE004AA)/08FCh, BIOS 1.17    11/24/2005
[  165.160030] Workqueue: events_unbound async_run_entry_fn
[  165.160030]  c105d2ef 00000000 ea569e10 c12771c0 00000000 ea569e28 c102c5fb c114907d
[  165.160030]  ecc18000 ea619c20 ecc18000 ea569e38 c102c676 00000009 00000000 ea569e44
[  165.160030]  c114907d ea619c20 ea569e5c c114b97d ea569e5c ea619c20 ed74e400 ea619c2c
[  165.160030] Call Trace:
[  165.160030]  [<c105d2ef>] ? console_unlock+0x37e/0x3ab
[  165.160030]  [<c12771c0>] dump_stack+0x49/0x73
[  165.160030]  [<c102c5fb>] warn_slowpath_common+0x5c/0x73
[  165.160030]  [<c114907d>] ? blk_queue_bypass_end+0x4d/0x62
[  165.160030]  [<c102c676>] warn_slowpath_null+0xf/0x13
[  165.160030]  [<c114907d>] blk_queue_bypass_end+0x4d/0x62
[  165.160030]  [<c114b97d>] blk_register_queue+0x8f/0xc4
[  165.160030]  [<c11548a6>] add_disk+0x2bc/0x3a8
[  165.160030]  [<efff40a5>] sd_probe_async+0xf5/0x17b [sd_mod]
[  165.160030]  [<c103fc08>] async_run_entry_fn+0x59/0xf9
[  165.160030]  [<c103ab22>] process_one_work+0x187/0x2ac
[  165.160030]  [<c103aac4>] ? process_one_work+0x129/0x2ac
[  165.160030]  [<c103ae19>] worker_thread+0x1b1/0x26b
[  165.160030]  [<c103ac68>] ? process_scheduled_works+0x21/0x21
[  165.160030]  [<c103e4ee>] kthread+0x82/0x87
[  165.160030]  [<c127b074>] ? _raw_spin_unlock_irq+0x22/0x3f
[  165.160030]  [<c1160000>] ? radix_tree_tag_set+0x3f/0xa5
[  165.160030]  [<c127b781>] ret_from_kernel_thread+0x21/0x30
[  165.160030]  [<c103e46c>] ? __kthread_parkme+0x50/0x50
[  165.160030] ---[ end trace 31df765b6ea80892 ]---
[  165.308986] sd 0:0:0:0: [sda] Attached SCSI removable disk

I don't know what's going on here, but it looks like something doesn't 
get cleaned up properly during the unbind operation.

This was in vanilla 3.17-rc3.

Alan Stern
