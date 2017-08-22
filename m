From: Paul Menzel <pmenzel@molgen.mpg.de>
Subject: Re: [Regression 4.13-rc1] Resume does not work on Lenovo X60t
Date: Tue, 22 Aug 2017 08:37:48 +0200
Message-ID: <3b5be305179828fd0e768c8ba9455851@molgen.mpg.de>
References: <7032513a-7a28-5807-40d4-cb0f7005d513@molgen.mpg.de>
 <20170805093014.GA6511@infradead.org>
 <d30803d1861c9c105a35845759f58f8d@molgen.mpg.de>
 <9123f447-c06b-6a67-b380-90338eb2dde8@molgen.mpg.de>
 <20170821184115.GA16735@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3.molgen.mpg.de ([141.14.17.11]:54295 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752736AbdHVGhv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 22 Aug 2017 02:37:51 -0400
In-Reply-To: <20170821184115.GA16735@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Dear Christoph,


On 2017-08-21 20:41, Christoph Hellwig wrote:

> with 4.13-rc6 we're not using blk-mq by default any more, do you
> still see the issue with that one?

Yes, I do see it this commit 6470812e2226 (Merge
git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc).

```
00.831: [  575.945132] BUG: unable to handle kernel NULL pointer 
dereference at 000000f4
00.830: [  575.948009] IP: blk_set_runtime_active+0x27/0x60
00.830: [  575.948009] *pde = 00000000
00.831: [  575.948009]
00.831: [  575.948009] Oops: 0002 [#1] SMP
00.831: [  575.948009] Modules linked in: joydev wacom_w8001 serport 
cpufreq_powersave cpufreq_conservative cpufreq_userspace binfmt_misc 
iTCO_wdt iTCO_vendor_support arc4 coretemp snd_hda_codec_analog 
snd_hda_codec_generic iwl3945 snd_hda_intel pcmcia iwlegacy 
snd_hda_codec kvm mac80211 snd_hda_core irqbypass yenta_socket snd_pcsp 
lpc_ich snd_hwdep thinkpad_acpi pcmcia_rsrc mfd_core serio_raw snd_pcm 
sg pcmcia_core nvram cfg80211 snd_timer rng_core snd rfkill battery 
soundcore shpchp evdev ac acpi_cpufreq parport_pc ppdev lp parport 
ip_tables x_tables autofs4 ext4 crc16 mbcache jbd2 fscrypto ecb cbc 
algif_skcipher af_alg dm_crypt dm_mod sr_mod cdrom sd_mod ata_generic 
ahci libahci sdhci_pci firewire_ohci ata_piix sdhci firewire_core libata 
e1000e i2c_i801 psmouse mmc_core crc_itu_t ptp scsi_mod i915 pps_core
00.831: [  575.948009]  ehci_pci video button uhci_hcd i2c_algo_bit 
ehci_hcd drm_kms_helper thermal usbcore syscopyarea sysfillrect 
sysimgblt fb_sys_fops drm
00.831: [  575.948009] CPU: 0 PID: 1126 Comm: kworker/u4:36 Not tainted 
4.13.0-rc6+ #110
00.831: [  575.948009] Hardware name: LENOVO 636338U/636338U, BIOS 
CBET4000 TIMELESS 01/01/1970
00.831: [  575.948009] Workqueue: events_unbound async_run_entry_fn
00.831: [  575.948009] task: f2ed8bc0 task.stack: f2ecc000
00.831: [  575.948009] EIP: blk_set_runtime_active+0x27/0x60
00.831: [  575.948009] EFLAGS: 00010046 CPU: 0
00.831: [  575.948009] EAX: 00000000 EBX: f5f3f820 ECX: f5f3f918 EDX: 
00010d7b
00.831: [  575.948009] ESI: f8ac3cc0 EDI: 00000010 EBP: 00000010 ESP: 
f2ecdea4
00.831: [  575.948009]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
00.831: [  575.948009] CR0: 80050033 CR2: 000000f4 CR3: 0e3a9000 CR4: 
000006d0
00.831: [  575.948009] Call Trace:
00.831: [  575.948009]  ? scsi_bus_resume_common+0x6e/0x110 [scsi_mod]
00.831: [  575.948009]  ? dpm_run_callback+0x4f/0x150
00.831: [  575.948009]  ? wait_for_completion+0x29/0x140
00.831: [  575.948009]  ? scsi_bus_thaw+0x10/0x10 [scsi_mod]
00.831: [  575.948009]  ? device_resume+0x8e/0x180
00.831: [  575.948009]  ? async_resume+0x1b/0x40
00.831: [  575.948009]  ? async_run_entry_fn+0x3f/0x1a0
00.831: [  575.948009]  ? process_one_work+0x136/0x310
00.831: [  575.948009]  ? worker_thread+0x39/0x3b0
00.831: [  575.948009]  ? kthread+0xd7/0x110
00.831: [  575.948009]  ? process_one_work+0x310/0x310
00.831: [  575.948009]  ? kthread_create_on_node+0x30/0x30
00.831: [  575.948009]  ? ret_from_fork+0x19/0x24
00.831: [  575.948009] Code: 8d 74 26 00 3e 8d 74 26 00 53 89 c3 8b 80 
fc 00 00 00 e8 2d 48 32 00 31 c0 8b 15 20 9e 24 ce 89 83 54 01 00 00 8b 
83 50 01 00 00 <89> 90 f4 00 00 00 ba 09 00 00 00 8b 83 50 01 00 00 e8 
f3 f2 16
00.831: [  575.948009] EIP: blk_set_runtime_active+0x27/0x60 SS:ESP: 
0068:f2ecdea4
00.831: [  575.948009] CR2: 00000000000000f4
00.831: [  575.948009] ---[ end trace b3f1ac10115418ab ]---
00.831: [  576.195662] pciehp 0000:00:1c.0:pcie004: Timeout on hotplug 
command 0x1038 (issued 574920 msec ago)
00.831: [  576.204847] pciehp 0000:00:1c.0:pcie004: Device 0000:01:00.0 
already exists at 0000:01:00, cannot hot-add
00.832: [  576.214460] pciehp 0000:00:1c.0:pcie004: Cannot add device at 
0000:01:00
00.834: [  576.223117] atkbd serio0: Spurious ACK on isa0060/serio0. 
Some program might be trying to access hardware directly.
00.834: [  576.233968] ata1.00: configured for UDMA/33
00.927: [  576.328159] pciehp 0000:00:1c.0:pcie004: Device 0000:01:00.0 
already exists at 0000:01:00, cannot hot-add
00.929: [  576.340348] pciehp 0000:00:1c.0:pcie004: Cannot add device at 
0000:01:00
01.002: [  576.420139] usb 5-6: reset high-speed USB device number 2 
using ehci-pci
01.372: [  576.796072] firewire_core 0000:05:00.1: rediscovered device 
fw0
03.010: [  578.440083] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 
300)
05.274: [  580.710027] ata3.00: ATA Identify Device Log not supported
05.276: [  580.718136] ata3.00: Security Log not supported
05.279: [  580.725856] ata3.00: ATA Identify Device Log not supported
05.282: [  580.733887] ata3.00: Security Log not supported
05.284: [  580.740838] ata3.00: configured for UDMA/100
```


Kind regards,

Paul
