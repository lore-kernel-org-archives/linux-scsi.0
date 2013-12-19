From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC 0/2] target refcounting infrastructure fixes for usb
Date: Wed, 18 Dec 2013 16:05:05 -0800
Message-ID: <1387411505.24521.3.camel@dabdike>
References: <Pine.LNX.4.44L0.1312181644460.3745-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:43590 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751404Ab3LSAFH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Dec 2013 19:05:07 -0500
In-Reply-To: <Pine.LNX.4.44L0.1312181644460.3745-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-scsi <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>

On Wed, 2013-12-18 at 16:50 -0500, Alan Stern wrote:
> On Wed, 18 Dec 2013, Sarah Sharp wrote:
> 
> > On Mon, Dec 16, 2013 at 07:10:19AM -0800, James Bottomley wrote:
> > > This set should fix our target problems with USB by making the target
> > > visibility properly reference counted.  Since it's a major change to the
> > > infrastructure, we'll incubate upstream first before backporting to
> > > stable.
> > > 
> > > James
> > 
> > I tried these patches, and they cause an oops when a USB mass storage
> > device is plugged in.  Note that this device uses the usb-storage
> > driver, not the uas driver.
> > 
> > [14248.340064] scsi6 : usb-storage 2-2:1.0
> > [14248.341083] usbcore: registered new interface driver usb-storage
> > [14248.346211] usbcore: registered new interface driver uas
> > [14249.339937] scsi 6:0:0:0: Direct-Access     Lexar    JumpDrive        1.00 PQ: 0 ANSI: 6
> > [14249.340988] ------------[ cut here ]------------
> > [14249.340999] WARNING: CPU: 3 PID: 5578 at lib/kobject.c:227 kobject_add_internal+0x13f/0x350()
> > [14249.341003] kobject_add_internal failed for 6:0:0:0 (error: -2 parent: target6:0:0)
> > [14249.341005] Modules linked in: uas usb_storage ctr ccm cuse dm_crypt uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core videodev btusb x86_pkg_temp_thermal coretemp ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd arc4 iwldvm mac80211 microcode snd_hda_codec_hdmi iwlwifi psmouse snd_hda_codec_realtek serio_raw snd_hda_intel snd_usb_audio snd_hda_codec thinkpad_acpi cfg80211 joydev snd_usbmidi_lib nvram snd_hwdep snd_seq_midi snd_pcm snd_seq_midi_event snd_rawmidi lpc_ich rfcomm bnep snd_seq bluetooth snd_seq_device snd_page_alloc ehci_pci snd_timer ehci_hcd snd soundcore tpm_tis binfmt_misc btrfs libcrc32c xor raid6_pq hid_generic usbhid hid i915 ahci libahci e1000e sdhci_pci sdhci i2c_algo_bit drm_kms_helper ptp pps_core drm xhci_hcd vi
 deo
> > [14249.341095] CPU: 3 PID: 5578 Comm: kworker/u16:0 Not tainted 3.13.0-rc1+ #142
> > [14249.341098] Hardware name: LENOVO 2325AP7/2325AP7, BIOS G2ET82WW (2.02 ) 09/11/2012
> > [14249.341105] Workqueue: events_unbound async_run_entry_fn
> > [14249.341108]  0000000000000009 ffff88003aa9db60 ffffffff81658a4e ffff88003aa9dba8
> > [14249.341115]  ffff88003aa9db98 ffffffff81048c3d ffff88006bc551b0 00000000fffffffe
> > [14249.341121]  0000000000000000 ffff8800bec22838 0000000000000200 ffff88003aa9dbf8
> > [14249.341127] Call Trace:
> > [14249.341135]  [<ffffffff81658a4e>] dump_stack+0x4d/0x66
> > [14249.341142]  [<ffffffff81048c3d>] warn_slowpath_common+0x7d/0xa0
> > [14249.341148]  [<ffffffff81048cac>] warn_slowpath_fmt+0x4c/0x50
> > [14249.341154]  [<ffffffff81660f17>] ? _raw_spin_unlock+0x27/0x40
> > [14249.341159]  [<ffffffff8133748f>] kobject_add_internal+0x13f/0x350
> > [14249.341163]  [<ffffffff813379b5>] kobject_add+0x65/0xb0
> > [14249.341170]  [<ffffffff81425b40>] ? get_device+0x30/0x30
> > [14249.341175]  [<ffffffff81649781>] ? klist_init+0x31/0x40
> > [14249.341181]  [<ffffffff81427208>] device_add+0x128/0x660
> > [14249.341186]  [<ffffffff814369cc>] ? __pm_runtime_resume+0x5c/0x90
> > [14249.341193]  [<ffffffff8145bcdc>] scsi_sysfs_add_sdev+0xac/0x340
> > [14249.341199]  [<ffffffff8145a443>] do_scan_async+0x83/0x180
> > [14249.341204]  [<ffffffff81074247>] async_run_entry_fn+0x37/0x130
> > [14249.341210]  [<ffffffff81066524>] process_one_work+0x1f4/0x550
> > [14249.341215]  [<ffffffff810664c2>] ? process_one_work+0x192/0x550
> > [14249.341220]  [<ffffffff81067261>] worker_thread+0x121/0x3a0
> > [14249.341225]  [<ffffffff81067140>] ? manage_workers.isra.22+0x2a0/0x2a0
> > [14249.341231]  [<ffffffff8106dc8c>] kthread+0xfc/0x120
> > [14249.341238]  [<ffffffff8106db90>] ? kthread_create_on_node+0x230/0x230
> > [14249.341243]  [<ffffffff81669cac>] ret_from_fork+0x7c/0xb0
> > [14249.341249]  [<ffffffff8106db90>] ? kthread_create_on_node+0x230/0x230
> > [14249.341253] ---[ end trace 7f1d8a449e6af5aa ]---
> > [14249.341259] scsi 6:0:0:0: failed to add device: -2
> 
> James:
> 
> The problem occurs when scsi_finish_async_scan() calls 
> scsi_sysfs_add_devices().
> 
> During an async scan, the devices get stored up and not made visible as
> they are found (see the end of scsi_add_lun()).  At the end, the target
> gets removed because it has no visible children, of course.  Then when
> the children do get added all at once, when the scan is over, it's too
> late.
> 
> How should this be fixed?  Forget about the en-masse registration and 
> do each device as it is found?

Great, I knew I'd find a reason to hate the async scanning code
eventually.

However, the solution is just to make the kref work for us.  We already
properly refcount everything, so we just take the reap_ref on the target
at the point the disk has to go through the remove device path, then
just rely on refcounting ... a bit like this.

James

---

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 34eab7b..cc6e5bd 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -996,7 +996,6 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 		return error;
 	}
 	transport_add_device(&sdev->sdev_gendev);
-	kref_get(&starget->reap_ref); /* device now visible, so target is held */
 	sdev->is_visible = 1;
 
 	/* create queue files, which may be writable, depending on the host */
@@ -1043,6 +1042,13 @@ void __scsi_remove_device(struct scsi_device *sdev)
 {
 	struct device *dev = &sdev->sdev_gendev;
 
+	/*
+	 * Paired with the kref_get() in scsi_sysfs_initialize().  We're
+	 * removing sysfs visibility from the device, so make the target
+	 * invisible if this was the last device underneath it.
+	 */
+	scsi_target_reap(scsi_target(sdev));
+
 	if (sdev->is_visible) {
 		if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
 			return;
@@ -1051,13 +1057,6 @@ void __scsi_remove_device(struct scsi_device *sdev)
 		device_unregister(&sdev->sdev_dev);
 		transport_remove_device(dev);
 		device_del(dev);
-		/*
-		 * Paired with the kref_get() in scsi_sysfs_add_sdev().  We're
-		 * removing sysfs visibility from the device, so make the
-		 * target invisible if this was the last device underneath it.
-		 */
-		scsi_target_reap(scsi_target(sdev));
-
 	} else
 		put_device(&sdev->sdev_dev);
 
@@ -1220,6 +1219,12 @@ void scsi_sysfs_device_initialize(struct scsi_device *sdev)
 	list_add_tail(&sdev->same_target_siblings, &starget->devices);
 	list_add_tail(&sdev->siblings, &shost->__devices);
 	spin_unlock_irqrestore(shost->host_lock, flags);
+	/*
+	 * device can now only be removed via __scsi_remove_device() so hold
+	 * the target.  Target will be held in CREATED state until something
+	 * beneath it becomes visible (in which case it moves to RUNNING)
+	 */
+	kref_get(&starget->reap_ref);
 }
 
 int scsi_is_sdev_device(const struct device *dev)



