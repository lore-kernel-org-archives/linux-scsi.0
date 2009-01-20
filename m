From: <Stuart_Hayes@Dell.com>
Subject: problems resuming with some SATA drives
Date: Tue, 20 Jan 2009 14:18:58 -0600
Message-ID: <DFEF91B22ED07447AB6AA4B237F913F90218593D@ausx3mpc125.aus.amer.dell.com>
References: <496B1B31.4050606@marvell.com> <1231774426.3256.2.camel@localhost.localdomain> <49707B7A.90100@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:59119 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757016AbZATUTA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Jan 2009 15:19:00 -0500
Content-class: urn:content-classes:message
In-Reply-To: <49707B7A.90100@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


When I resume a system that is suspended (it's a Dell studio xps
portable), I'm seeing ugly messages and a slow resume with certain SATA
hard drives --I've pasted the messages below.  This is with an ahci
controller.

I've dug into it, and see what is happening.  During resume, the port is
first issued a hard reset, then a soft reset.  This is done in
ata_eh_reset().  What's happening is that the hard reset is issued in
sata_link_hardreset(), and the code waits for the drive to be
ready--BUT, after ATA_TMOUT_PMP_SRST_WAIT (one second), the code stops
waiting for the drive to be ready, and everything proceeds as if it were
ready (!).  The soft reset is then sent to the drive, but, because the
drive isn't ready, it doesn't see the soft reset.  This times out after
10 seconds (ata_eh_reset_timeouts[0]), and then everything again
proceeds as if the drive was finished with the soft reset.  At that
point an IDENTIFY command is sent, which times out, and it goes into the
error handler and the whole process starts over with another hard reset,
which works this time because the drive has been powered up for a while
at this point.

The main problem is that the code in sata_link_hardreset() is timing out
after 1 second (ATA_TMOUT_PMP_SRST_WAIT), apparently as a workaround
because certain PMPs don't come back and say they are ready if their
first port is empty.  If I get rid of the ATA_TMOUT_PMP_SRST_WAIT one
second timeout, sata_link_hardreset() will wait until the drive is ready
(about 3 seconds--the ATA-6 spec seems to allow up to 5 seconds), then
the soft reset is successful, and the whole system resumes in about 3.5
seconds (instead of 17-18 seconds).

I saw this with an Ubuntu kernel based on 2.6.27, but the relevant code
appears to be unchanged in 2.6.29-rc2.

My best guess as to how to fix this is to change ATA_TMOUT_PMP_SRST_WAIT
to 5 seconds, since that's how long the ATA-6 spec gives drives to be
ready, but I'm not sure how badly that would impact users with the PMPs
that don't say they are ready after a hard reset.

Any suggestions?

Thanks!
Stuart

[181220.664100] ata1: link is slow to respond, please be patient
(ready=0)
[181224.136100] ata1: softreset failed (device not ready)
[181224.136106] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[181229.136103] ata1.00: qc timeout (cmd 0xec)
[181229.136108] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[181229.136110] ata1.00: revalidation failed (errno=-5)
[181229.620102] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[181229.629530] ata1.00: configured for UDMA/133
[181229.629539] ata1: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9
t4
[181229.629541] ata1: irq_stat 0x00400040, connection status changed
[181229.640113] ata1.00: configured for UDMA/133
[181229.640116] ata1: EH complete
[181229.640159] sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors
(200050 MB)
[181229.640172] sd 0:0:0:0: [sda] Write Protect is off
[181229.640174] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[181229.640193] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[181229.640212] sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors
(200050 MB)
[181229.640223] sd 0:0:0:0: [sda] Write Protect is off
[181229.640225] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[181229.640243] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[181230.480106] usb 4-3: reset high speed USB device using ehci_hcd and
address 2
[181230.620234] PM: resume devices took 17.376 seconds
[181230.620240] ------------[ cut here ]------------
[181230.620241] WARNING: at
/build/buildd/linux-2.6.27/kernel/power/main.c:176
suspend_test_finish+0x74/0x80()
[181230.620243] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat
mmc_block af_packet binfmt_misc rfcomm bridge stp bnep sco l2cap
bluetooth vboxnetflt vboxdrv ppdev ipv6 acpi_cpufreq
cpufreq_conservative cpufreq_stats cpufreq_powersave cpufreq_userspace
cpufreq_ondemand freq_table pci_slot container sbs sbshc iptable_filter
ip_tables x_tables sbp2 parport_pc lp parport joydev psmouse dcdbas
uvcvideo nvidia(P) serio_raw evdev ieee80211_crypt_tkip compat_ioctl32
pcspkr agpgart wl(P) videodev v4l1_compat ieee80211_crypt i2c_core ac
battery sdhci_pci sdhci mmc_core ricoh_mmc video output snd_hda_intel
snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi
snd_rawmidi snd_seq_midi_event snd_seq wmi shpchp button snd_timer
snd_seq_device snd pci_hotplug soundcore snd_page_alloc ext3 jbd mbcache
sd_mod crc_t10dif sr_mod cdrom sg ohci_hcd ehci_hcd ahci libata scsi_mod
dock ohci1394 forcedeth ieee1394 usbcore thermal processor fan fbcon
tileblit font bitblit softcursor fuse
[181230.620293] Pid: 4199, comm: pm-suspend Tainted: P        W
2.6.27-11-generic #1
[181230.620296]  [<c037d386>] ? printk+0x1d/0x1f
[181230.620299]  [<c0131e99>] warn_on_slowpath+0x59/0x90
[181230.620303]  [<c014d305>] ? sched_clock_cpu+0xd5/0x170
[181230.620306]  [<c014c15f>] ? down_trylock+0x2f/0x40
[181230.620308]  [<c0132572>] ? try_acquire_console_sem+0x12/0x40
[181230.620311]  [<c024ed00>] ? kobject_put+0x20/0x50
[181230.620314]  [<c015d2b4>] suspend_test_finish+0x74/0x80
[181230.620317]  [<c015d3a6>] suspend_devices_and_enter+0xe6/0x190
[181230.620319]  [<c015d621>] enter_state+0xd1/0x100
[181230.620321]  [<c015d6d5>] state_store+0x85/0xd0
[181230.620323]  [<c015d650>] ? state_store+0x0/0xd0
[181230.620325]  [<c024ebc4>] kobj_attr_store+0x24/0x30
[181230.620328]  [<c01ffac7>] sysfs_write_file+0x97/0x100
[181230.620330]  [<c01b2760>] vfs_write+0xa0/0x110
[181230.620333]  [<c01ffa30>] ? sysfs_write_file+0x0/0x100
[181230.620335]  [<c01b28a2>] sys_write+0x42/0x70
[181230.620337]  [<c0103f7b>] sysenter_do_call+0x12/0x2f
[181230.620340]  [<c0370000>] ? init_memory_mapping+0x230/0x320
[181230.620343]  =======================
[181230.620345] ---[ end trace cefb6a77a684b9aa ]---
[181230.620805] PM: Finishing wakeup.
[181230.620807] Restarting tasks ... done.
