From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Subject: Re: WARNING in block layer triggered in 3.17-rc3
Date: Sun, 7 Sep 2014 17:59:53 -0500
Message-ID: <CADT32eLJOd5AuFSkg34gOJx-7GXe3Lz1xNe3SzCBv9U1F1ikbA@mail.gmail.com>
References: <Pine.LNX.4.44L0.1409051340450.879-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1409051340450.879-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Jens Axboe <axboe@kernel.dk>, SCSI development list <linux-scsi@vger.kernel.org>, Kernel development list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

I think the problem is, when a gendisk is detached, its request queue
is not put in bypass mode
cause when it is re-attached, code tries to put it out of bypass mode,
hence the warning.

So either of these should work, I have not tested it, just coded it up.

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 4db5abf..f94c7ba 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -600,6 +600,8 @@ void blk_unregister_queue(struct gendisk *disk)
  if (q->request_fn)
  elv_unregister_queue(q);

+ blk_queue_bypss_start(q);
+
  kobject_uevent(&q->kobj, KOBJ_REMOVE);
  kobject_del(&q->kobj);
  blk_trace_remove_sysfs(disk_to_dev(disk));





diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 2c2041c..1c7ef55f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3054,15 +3054,26 @@ static int sd_probe(struct device *dev)
 static int sd_remove(struct device *dev)
 {
  struct scsi_disk *sdkp;
+ struct request_queue *q;
+ struct scsi_device *sdp;
  dev_t devt;

  sdkp = dev_get_drvdata(dev);
+ q = sdkp->disk->queue;
  devt = disk_devt(sdkp->disk);
  scsi_autopm_get_device(sdkp->device);

  async_synchronize_full_domain(&scsi_sd_pm_domain);
  async_synchronize_full_domain(&scsi_sd_probe_domain);
  device_del(&sdkp->dev);
+
+ if (q) {
+ spin_lock_irq(q->queue_lock);
+ q->bypass_depth++;
+ queue_flag_set(QUEUE_FLAG_BYPASS, q);
+ spin_unlock_irq(q->queue_lock);
+ }
+
  del_gendisk(sdkp->disk);
  sd_shutdown(dev);



On Fri, Sep 5, 2014 at 12:45 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> James and Jens:
>
> I got a WARNING when unbinding the sd driver from a USB flash drive and
> then binding it back again.  Here's where the flash drive gets probed
> initially:
>
> [  143.300886] usb-storage 4-8:1.0: usb_probe_interface
> [  143.300911] usb-storage 4-8:1.0: usb_probe_interface - got id
> [  143.300930] usb-storage 4-8:1.0: USB Mass Storage device detected
> [  143.318239] scsi host0: usb-storage 4-8:1.0
> [  143.359979] scsi 0:0:0:0: Direct-Access     Ut165    USB2FlashStorage 0.00 PQ: 0 ANSI: 2
> [  143.376366] usbcore: registered new interface driver usb-storage
> [  143.468464] sd 0:0:0:0: [sda] 7892040 512-byte logical blocks: (4.04 GB/3.76 GiB)
> [  143.481725] sd 0:0:0:0: [sda] Write Protect is off
> [  143.485712] sd 0:0:0:0: [sda] Mode Sense: 00 00 00 00
> [  143.487064] sd 0:0:0:0: [sda] Asking for cache data failed
> [  143.498428] sd 0:0:0:0: [sda] Assuming drive cache: write through
> [  143.656797]  sda: sda1
> [  143.676922] sd 0:0:0:0: [sda] Attached SCSI removable disk
>
> Then I did
>
>         echo 0:0:0:0 >/sys/bus/scsi/drivers/sd_mod/unbind
>
> followed by
>
>         echo 0:0:0:0 >/sys/bus/scsi/drivers/sd_mod/bind
>
> which resulted in:
>
> [  165.079557] sd 0:0:0:0: [sda] 7892040 512-byte logical blocks: (4.04 GB/3.76 GiB)
> [  165.093510] sd 0:0:0:0: [sda] Write Protect is off
> [  165.104388] sd 0:0:0:0: [sda] Mode Sense: 00 00 00 00
> [  165.105632] sd 0:0:0:0: [sda] Asking for cache data failed
> [  165.115136] sd 0:0:0:0: [sda] Assuming drive cache: write through
> [  165.142950]  sda: sda1
> [  165.156480] ------------[ cut here ]------------
> [  165.159912] WARNING: CPU: 0 PID: 29 at block/blk-core.c:473 blk_queue_bypass_end+0x4d/0x62()
> [  165.160030] Modules linked in: sd_mod usb_storage scsi_mod hid_generic usbhid hid pcspkr evdev i915 cfbfillrect cfbimgblt i2c_algo_bit cfbcopyarea video fbcon backlight bitblit softcursor font ehci_pci drm_kms_helper uhci_hcd ehci_hcd ohci_pci ohci_hcd drm i2ccore usbcore e100 mii usb_common fb fbdev fan processor button thermal_sys
> [  165.160030] CPU: 0 PID: 29 Comm: kworker/u4:1 Not tainted 3.17.0-rc3AS-dirty #12
> [  165.160030] Hardware name: Hewlett-Packard HP dx2000 MT (EE004AA)/08FCh, BIOS 1.17    11/24/2005
> [  165.160030] Workqueue: events_unbound async_run_entry_fn
> [  165.160030]  c105d2ef 00000000 ea569e10 c12771c0 00000000 ea569e28 c102c5fb c114907d
> [  165.160030]  ecc18000 ea619c20 ecc18000 ea569e38 c102c676 00000009 00000000 ea569e44
> [  165.160030]  c114907d ea619c20 ea569e5c c114b97d ea569e5c ea619c20 ed74e400 ea619c2c
> [  165.160030] Call Trace:
> [  165.160030]  [<c105d2ef>] ? console_unlock+0x37e/0x3ab
> [  165.160030]  [<c12771c0>] dump_stack+0x49/0x73
> [  165.160030]  [<c102c5fb>] warn_slowpath_common+0x5c/0x73
> [  165.160030]  [<c114907d>] ? blk_queue_bypass_end+0x4d/0x62
> [  165.160030]  [<c102c676>] warn_slowpath_null+0xf/0x13
> [  165.160030]  [<c114907d>] blk_queue_bypass_end+0x4d/0x62
> [  165.160030]  [<c114b97d>] blk_register_queue+0x8f/0xc4
> [  165.160030]  [<c11548a6>] add_disk+0x2bc/0x3a8
> [  165.160030]  [<efff40a5>] sd_probe_async+0xf5/0x17b [sd_mod]
> [  165.160030]  [<c103fc08>] async_run_entry_fn+0x59/0xf9
> [  165.160030]  [<c103ab22>] process_one_work+0x187/0x2ac
> [  165.160030]  [<c103aac4>] ? process_one_work+0x129/0x2ac
> [  165.160030]  [<c103ae19>] worker_thread+0x1b1/0x26b
> [  165.160030]  [<c103ac68>] ? process_scheduled_works+0x21/0x21
> [  165.160030]  [<c103e4ee>] kthread+0x82/0x87
> [  165.160030]  [<c127b074>] ? _raw_spin_unlock_irq+0x22/0x3f
> [  165.160030]  [<c1160000>] ? radix_tree_tag_set+0x3f/0xa5
> [  165.160030]  [<c127b781>] ret_from_kernel_thread+0x21/0x30
> [  165.160030]  [<c103e46c>] ? __kthread_parkme+0x50/0x50
> [  165.160030] ---[ end trace 31df765b6ea80892 ]---
> [  165.308986] sd 0:0:0:0: [sda] Attached SCSI removable disk
>
> I don't know what's going on here, but it looks like something doesn't
> get cleaned up properly during the unbind operation.
>
> This was in vanilla 3.17-rc3.
>
> Alan Stern
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
