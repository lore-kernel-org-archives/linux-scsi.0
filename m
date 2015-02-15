From: Athlion <athlion@gmail.com>
Subject: Re: Kernel Ooops upon USB disconnect of a Western Digital My Passport
 1TB drive
Date: Sun, 15 Feb 2015 10:15:12 +0200
Message-ID: <CACfp4317g=kLqh8imuDRP_uPRZYYWhi_UfCoAQFZwh+FsJsdmA@mail.gmail.com>
References: <CACfp432Vqiu2eeMyYupdkMxs=bNN83ayMgiDrZic54VjhM6aZw@mail.gmail.com>
 <Pine.LNX.4.44L0.1502031033300.1130-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:33665 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbbBOIPf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Feb 2015 03:15:35 -0500
In-Reply-To: <Pine.LNX.4.44L0.1502031033300.1130-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

Just one more FYI, by blacklisting the ses module, the oops goes away.

On Tue, Feb 3, 2015 at 6:05 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Tue, 3 Feb 2015, Athlion wrote:
>
>> On Mon, Feb 2, 2015 at 7:27 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
>>
>> > Had you made any changes to the runtime suspend settings?
>> > blk_post_runtime_resume wouldn't be called unless the drive had gone
>> > into runtime suspend.  And even then, it's not likely to be called
>> > after you unplug the USB cable.
>> >
>> > Alan Stern
>>
>> I have enabled SCSI ATA Bus power management with this udev rule:
>> ACTION=="add", SUBSYSTEM=="scsi_host", KERNEL=="host*",
>> ATTR{link_power_management_policy}="min_power"
>
> That won't have any effect on SCSI over USB, as far as I know.
>
>> ( And generally almost all of actions herein:
>> https://wiki.archlinux.org/index.php/Power_saving#Laptop_Mode )
>>
>> Here's another with dynamic debugging on (and some of the stack trace):
>>
>> [ 1565.610481] usb usb2: usb wakeup-resume
>> [ 1565.613019] usb usb2: usb auto-resume
>> [ 1565.615599] hub 2-0:1.0: hub_resume
>> [ 1565.617876] usb usb2-port1: status 0507 change 0000
>> [ 1565.620125] hub 2-0:1.0: state 7 ports 3 chg 0000 evt 0000
>> [ 1565.623471] hub 2-0:1.0: state 7 ports 3 chg 0000 evt 0000
>> [ 1565.650219] hub 2-0:1.0: state 7 ports 3 chg 0000 evt 0002
>> [ 1565.663520] usb 2-1: usb wakeup-resume
>> [ 1565.665518] usb 2-1: finish resume
>> [ 1565.667684] hub 2-1:1.0: hub_resume
>> [ 1565.669812] usb 2-1-port2: status 0101 change 0001
>> [ 1565.773645] usb usb2-port1: resume, status 0
>> [ 1565.776031] hub 2-1:1.0: state 7 ports 8 chg 0004 evt 0000
>> [ 1565.778664] usb 2-1-port2: status 0101, change 0000, 12 Mb/s
>> [ 1565.847291] usb 2-1.2: new high-speed USB device number 3 using ehci-pci
>> [ 1565.860480] usb 2-1-port2: not reset yet, waiting 10ms
>> [ 1565.945202] usb 2-1.2: default language 0x0409
>> [ 1565.947882] usb 2-1.2: udev 3, busnum 2, minor = 130
>> [ 1565.950384] usb 2-1.2: usb_probe_device
>> [ 1565.952704] usb 2-1.2: configuration #1 chosen from 1 choice
>> [ 1565.955145] usb 2-1.2: adding 2-1.2:1.0 (config #1, interface 0)
>> [ 1565.957630] hub 2-1:1.0: state 7 ports 8 chg 0000 evt 0004
>> [ 1566.005124] usb-storage 2-1.2:1.0: usb_probe_interface
>> [ 1566.006655] usb-storage 2-1.2:1.0: usb_probe_interface - got id
>> [ 1566.008169] usb-storage 2-1.2:1.0: USB Mass Storage device detected
>> [ 1566.010155] scsi host6: usb-storage 2-1.2:1.0
>> [ 1566.012149] usbcore: registered new interface driver usb-storage
>> [ 1566.016061] usbcore: registered new interface driver uas
>> [ 1567.015852] scsi 6:0:0:0: Direct-Access     WD       My Passport
>> 0748 1016 PQ: 0 ANSI: 6
>> [ 1567.018966] scsi 6:0:0:1: Enclosure         WD       SES Device
>>   1016 PQ: 0 ANSI: 6
>
> Your device contains two Logical Units.  One of them is the My Passport
> disk drive, and the other is the SES Device enclosure.
>
>> [ 1567.027072] scsi 6:0:0:1: scsi_runtime_idle
>> [ 1567.029695] sd 6:0:0:0: [sdb] Spinning up disk...
>> [ 1567.032764] scsi 6:0:0:1: scsi_runtime_suspend
>> [ 1568.031907] .ready
>> [ 1569.060225] sd 6:0:0:0: [sdb] 1953458176 512-byte logical blocks:
>> (1.00 TB/931 GiB)
>> [ 1569.063857] sd 6:0:0:0: [sdb] Write Protect is off
>> [ 1569.065613] ses 6:0:0:1: Attached Enclosure device
>> [ 1569.068492] sd 6:0:0:0: [sdb] Mode Sense: 47 00 10 08
>> [ 1569.071598] sd 6:0:0:0: [sdb] No Caching mode page found
>> [ 1569.073628] sd 6:0:0:0: [sdb] Assuming drive cache: write through
>> [ 1569.087891]  sdb: sdb1
>> [ 1569.093382] sd 6:0:0:0: [sdb] Attached SCSI disk
>> [ 1615.830142] hub 2-1:1.0: state 7 ports 8 chg 0000 evt 0004
>> [ 1615.833066] usb 2-1-port2: status 0100, change 0001, 12 Mb/s
>> [ 1615.835764] usb 2-1.2: USB disconnect, device number 3
>> [ 1615.838471] usb 2-1.2: unregistering device
>> [ 1615.841199] usb 2-1.2: unregistering interface 2-1.2:1.0
>> [ 1615.844996] scsi target6:0:0: scsi_runtime_idle
>> [ 1615.848746] scsi target6:0:0: scsi_runtime_suspend
>> [ 1615.868925] scsi target6:0:0: scsi_runtime_resume
>> [ 1615.870975] ses 6:0:0:1: scsi_runtime_resume
>> [ 1615.872913] BUG: unable to handle kernel NULL pointer dereference
>> at 00000000000001a0
>> [ 1615.874896] IP: [<ffffffff812850d5>] blk_post_runtime_resume+0x65/0x80
>> [ 1615.876843] PGD 0
>> [ 1615.878765] Oops: 0002 [#1] PREEMPT SMP
>> [ 1615.880734] Modules linked in: ses enclosure uas usb_storage
>> netconsole joydev mousedev snd_hda_codec_hdmi snd_hda_codec_conexant
>> snd_hda_codec_generic coretemp intel_rapl x86_pkg_temp_thermal
>> intel_powerclamp kvm_intel kvm arc4 crct10dif_pclmul iwldvm
>> crc32_pclmul iTCO_wdt iTCO_vendor_support crc32c_intel mac80211
>> ghash_clmulni_intel ip6t_REJECT nf_reject_ipv6 aesni_intel xt_hl
>> aes_x86_64 lrw gf128mul ip6t_rt psmouse iwlwifi glue_helper
>> ablk_helper cryptd i2c_i801 serio_raw cfg80211 nf_conntrack_ipv6
>> nf_defrag_ipv6 snd_hda_intel wmi thinkpad_acpi nvram thermal rfkill
>> ipt_REJECT nf_reject_ipv4 hwmon tpm_tis ac tpm battery
>> snd_hda_controller snd_hda_codec snd_hwdep evdev snd_pcm mac_hid
>> xt_limit e1000e snd_timer xt_tcpudp mei_me snd mei ptp soundcore
>> shpchp pps_core lpc_ich processor xt_addrtype nf_conntrack_ipv4
>> nf_defrag_ipv4 xt_conntrack at ffffffffffffffd8
>> [ 1616.064883] IP: [<ffffffff81091500>] kthread_data+0x10/0x20
>
> Once again, there is no stack trace.  In fact, if you look at the
> second-to-last line above, it appears that another oops occurred about
> 0.2 seconds after the first one, and part of the kernel log got lost:
>
>> nf_defrag_ipv4 xt_conntrack at ffffffffffffffd8
> -----------------------------^
>
> Right there, the "at ffffffffffffffd8" part appears to be the end of
> another BUG: line.  Everything in between is missing -- presumably
> including the stack trace.  Maybe the stack got messed up, so that
> tracing it caused the second oops to occur.
>
> Anyway, this shows that the problem was associated with the SES Device,
> not the My Passport disk.  It occurred during the runtime resume of the
> SES, as indicated by the reference to blk_post_runtime_resume.  (Note
> that the ses driver doesn't support runtime power management in any
> case.)
>
> Clearly this problem has nothing to do with USB; it is a SCSI matter.
> Somehow the ses driver interacts badly with runtime PM.
>
> James, do you have any idea what might be going wrong here?  The
> blk_post_runtime_resume routine in block/blk-core.c does very little
> other than call __blk_run_queue.  I don't know how the ses driver
> works, but it looks like it hardly uses its request queue at all.
>
> Alan Stern
>
