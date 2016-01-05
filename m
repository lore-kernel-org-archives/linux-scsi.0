From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s!
 [kworker/1:1:29]
Date: Tue, 5 Jan 2016 21:06:00 +0100
Message-ID: <20160105210600.000017c5@localhost>
References: <20151217222737.00000ab6@localhost>
	<20151231180415.00000bfc@localhost>
	<20160103114628.GA10582@lst.de>
	<20160103190341.0000387b@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:58647 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126AbcAEUGT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Jan 2016 15:06:19 -0500
In-Reply-To: <20160103190341.0000387b@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Sebastian Herbszt <herbszt@gmx.de>

I wrote:
> Christoph Hellwig wrote:
> > On Thu, Dec 31, 2015 at 06:04:15PM +0100, Sebastian Herbszt wrote:
> > > I still get this on 4.4.0-rc7-1.g276c9f4-default. Since this did not
> > > happen on 4.3 I checked the scsi changes and found the following commit:
> > > 
> > > scsi: restart list search after unlock in scsi_remove_target
> > > 
> > > Christoph, can it cause this issue?
> > 
> > Apparently yes.  Bad hard a patch to avoid this when he resubmitted
> > my patch, which for some reason didn't get apply.  Can you grab it
> > from the list archives and give it a try?
> 
> Do you mean the following patch?
> 
> "[PATCH v2] Separate target visibility from reaped state information" [1]
> 
> I can give it a try but it will likely take a few days.
> 
> [1] http://marc.info/?l=linux-scsi&m=144771953020415&w=2

Bart's patch mentioned above seems to fix my issue.
The soft lockup is gone and now I am getting the following but that
already happened on 4.3 too:

[  531.269588] ------------[ cut here ]------------
[  531.269609] WARNING: CPU: 0 PID: 3482 at fs/sysfs/group.c:237 sysfs_remove_group+0x8f/0xa0()
[  531.269616] sysfs group c0ad62c8 not found for kobject '4:0:0:0'
[  531.269620] Modules linked in: lpfc(-) qla2x00tgt(O) qla2xxx_scst(O) scst_vdisk(O) scst(O) dlm configfs libcrc32c scsi_transport_fc edd nfsd lockd grace nfs_acl snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device auth_rpcgss sunrpc dm_mod snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_codec snd_hda_core iTCO_wdt snd_hwdep ppdev parport_pc tg3 snd_pcm libphy gpio_ich acpi_cpufreq iTCO_vendor_support snd_timer parport fjes snd sr_mod ehci_pci ptp lpc_ich tpm_tis floppy 8250_fintek cdrom pps_core soundcore i2c_i801 tpm hwmon sg pcspkr i915 drm_kms_helper drm fb_sys_fops sysimgblt sysfillrect syscopyarea i2c_algo_bit uhci_hcd ehci_hcd usbcore button video usb_common fan ata_generic ata_piix ahci libahci libata thermal
[  531.269778] CPU: 0 PID: 3482 Comm: rmmod Tainted: G           O    4.4.0-rc8 #2
[  531.269785] Hardware name: FUJITSU SIEMENS ESPRIMO E           /D2164-A1, BIOS 5.00 R1.10.2164.A1               05/08/2006
[  531.269791]  00000000 00000000 f47cbd14 c051cfe0 000000ed c09d07e8 f47cbd44 c025aefe
[  531.269808]  c09c6620 f47cbd70 00000d9a c09d07e8 000000ed c041fbdf c041fbdf c0ad62c8
[  531.269824]  00000000 f4644408 f47cbd5c c025afe3 00000009 f47cbd54 c09c6620 f47cbd70
[  531.269841] Call Trace:
[  531.269852]  [<c051cfe0>] dump_stack+0x44/0x64
[  531.269859]  [<c025aefe>] warn_slowpath_common+0x8e/0xd0
[  531.269865]  [<c041fbdf>] ? sysfs_remove_group+0x8f/0xa0
[  531.269869]  [<c041fbdf>] ? sysfs_remove_group+0x8f/0xa0
[  531.269874]  [<c025afe3>] warn_slowpath_fmt+0x33/0x40
[  531.269879]  [<c041fbdf>] sysfs_remove_group+0x8f/0xa0
[  531.269885]  [<c064fea9>] dpm_sysfs_remove+0x49/0x60
[  531.269891]  [<c06445df>] device_del+0x3f/0x1d0
[  531.269897]  [<c064478e>] device_unregister+0x1e/0x60
[  531.269903]  [<c050ca04>] bsg_unregister_queue+0x54/0x90
[  531.269909]  [<c0679216>] __scsi_remove_device+0x96/0xc0
[  531.269913]  [<c06778b7>] scsi_forget_host+0x57/0x60
[  531.269919]  [<c066c1d8>] scsi_remove_host+0x68/0x100
[  531.269940]  [<f8b5c16a>] lpfc_pci_remove_one_s3+0xca/0x2b0 [lpfc]
[  531.269957]  [<f8b63cc5>] lpfc_pci_remove_one+0x65/0x80 [lpfc]
[  531.269963]  [<c0652aa6>] ? __pm_runtime_resume+0x46/0x60
[  531.269970]  [<c0566bc8>] pci_device_remove+0x38/0xc0
[  531.269975]  [<c06488c2>] __device_release_driver+0x72/0xf0
[  531.269979]  [<c0648aaf>] driver_detach+0x8f/0xa0
[  531.269984]  [<c0647bcc>] bus_remove_driver+0x4c/0xc0
[  531.269989]  [<c06491e8>] driver_unregister+0x28/0x60
[  531.269994]  [<c0644802>] ? device_destroy+0x32/0x40
[  531.269999]  [<c0643c20>] ? class_dir_child_ns_type+0x10/0x10
[  531.270004]  [<c05667d8>] pci_unregister_driver+0x18/0x70
[  531.270010]  [<c0622317>] ? misc_deregister+0x67/0x90
[  531.270024]  [<f8b8b6ef>] lpfc_exit+0x1a/0x92b [lpfc]
[  531.270031]  [<c02d603b>] ? find_module+0x1b/0x20
[  531.270035]  [<c02d9b56>] SyS_delete_module+0x176/0x1f0
[  531.270041]  [<c0380dfb>] ? do_munmap+0x22b/0x2c0
[  531.270046]  [<c0380ed6>] ? vm_munmap+0x46/0x60
[  531.270052]  [<c0201bd1>] do_fast_syscall_32+0x91/0x140
[  531.270059]  [<c07f9074>] sysenter_past_esp+0x3d/0x69
[  531.270064] ---[ end trace 6d7ac64edaa712d5 ]---
[  531.270160] ------------[ cut here ]------------


Sebastian
