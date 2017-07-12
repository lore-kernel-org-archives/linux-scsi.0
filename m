From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: CPU lock-ups with 4.12.0+ kernels related to usb_storage
Date: Wed, 12 Jul 2017 12:10:02 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1707121152211.2118-100000@iolanthe.rowland.org>
References: <2b6dc4b0-71c8-28cb-383d-c01a9e896c7a@internode.on.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:33534 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1753554AbdGLQKE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2017 12:10:04 -0400
In-Reply-To: <2b6dc4b0-71c8-28cb-383d-c01a9e896c7a@internode.on.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arthur Marsh <arthur.marsh@internode.on.net>
Cc: Christoph Hellwig <hch@lst.de>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 13 Jul 2017, Arthur Marsh wrote:

> Thanks for the advice, I've enabled CONFIG_FRAME_POINTER and managed to 
> catch 1 more log triggered by issuing a
> 
> blkid
> 
> command after inserting a USB stick.
> 
> The problem is that I can't be certain of triggering the problem when 
> testing kernels using git-bisect, so my git-bisect efforts are not 
> guaranteed to get a result.

> Jul 12 18:51:00 localhost kernel: [ 1206.802306] NMI watchdog: Watchdog detected hard LOCKUP on cpu 1
> Jul 12 18:51:00 localhost kernel: [ 1206.802308] Modules linked in: cmac arc4 ecb md4 nls_utf8 cifs ccm dns_resolver fscache bnep bluetooth hmac drbg ansi_cprng ecdh_generic nfc rfkill cpufreq_userspace cpufreq_conservative snd_hrtimer cpufreq_powersave binfmt_misc fuse snd_emu10k1_synth snd_emux_synth snd_seq_midi_emul snd_seq_virmidi snd_seq_midi_event snd_seq max6650 ib_iser rdma_cm iw_cm ib_cm ib_core configfs iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi parport_pc ppdev lp parport ir_lirc_codec lirc_dev rtl2832_sdr videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 videobuf2_core videodev media fc0012 rtl2832 i2c_mux dvb_usb_rtl28xxu dvb_usb_v2 amdkfd dvb_core rc_core edac_mce_amd radeon kvm_amd kvm irqbypass wmi_bmof snd_hda_codec_hdmi snd_emu10k1 snd_hda_intel ttm sg drm_km
 s_helper snd_hda_codec snd_util_mem snd_hda_core
> Jul 12 18:51:00 localhost kernel: [ 1206.802336]  snd_ac97_codec snd_rawmidi snd_seq_device snd_hwdep snd_pcm_oss drm snd_mixer_oss ac97_bus snd_pcm pcspkr evdev k10temp i2c_algo_bit serio_raw snd_timer emu10k1_gp snd gameport sp5100_tco soundcore button acpi_cpufreq asus_atk0110 wmi ext4 mbcache crc16 jbd2 crc32c_generic btrfs raid6_pq xor uas usb_storage sr_mod cdrom sd_mod hid_generic usbhid hid ata_generic ohci_pci ahci firewire_ohci libahci pata_atiixp firewire_core crc_itu_t i2c_piix4 ehci_pci ohci_hcd libata ehci_hcd usbcore scsi_mod r8169 mii
> Jul 12 18:51:00 localhost kernel: [ 1206.802359] CPU: 1 PID: 142 Comm: usb-storage Not tainted 4.12.0+ #2751
> Jul 12 18:51:00 localhost kernel: [ 1206.802359] Hardware name: System manufacturer System Product Name/M3A78 PRO, BIOS 1701    01/27/2011
> Jul 12 18:51:00 localhost kernel: [ 1206.802361] task: ffff927c610eef80 task.stack: ffffba9501b78000
> Jul 12 18:51:00 localhost kernel: [ 1206.802366] RIP: 0010:native_queued_spin_lock_slowpath+0x159/0x1c0
> Jul 12 18:51:00 localhost kernel: [ 1206.802366] RSP: 0018:ffffba9501b7bdc8 EFLAGS: 00000002
> Jul 12 18:51:00 localhost kernel: [ 1206.802368] RAX: 0000000000000101 RBX: ffff927c662f3030 RCX: 0000000000000001
> Jul 12 18:51:00 localhost kernel: [ 1206.802368] RDX: 0000000000000101 RSI: 0000000000000001 RDI: ffff927c662f3030
> Jul 12 18:51:00 localhost kernel: [ 1206.802369] RBP: ffffba9501b7bde0 R08: 0000000000000101 R09: 0000000000000100
> Jul 12 18:51:00 localhost kernel: [ 1206.802370] R10: 0000000000000000 R11: 7fffffffffffffff R12: 0000000000000082
> Jul 12 18:51:00 localhost kernel: [ 1206.802370] R13: 0000000000002003 R14: 0000000000001d4c R15: ffff927c610eef80
> Jul 12 18:51:00 localhost kernel: [ 1206.802371] FS:  0000000000000000(0000) GS:ffff927c6fc40000(0000) knlGS:0000000000000000
> Jul 12 18:51:00 localhost kernel: [ 1206.802372] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Jul 12 18:51:00 localhost kernel: [ 1206.802373] CR2: 00000030007995d8 CR3: 000000017b144000 CR4: 00000000000006e0
> Jul 12 18:51:00 localhost kernel: [ 1206.802374] Call Trace:
> Jul 12 18:51:00 localhost kernel: [ 1206.802378]  ? _raw_spin_lock_irqsave+0x59/0x68
> Jul 12 18:51:00 localhost kernel: [ 1206.802389]  scsi_eh_scmd_add+0x3f/0x150 [scsi_mod]
> Jul 12 18:51:00 localhost kernel: [ 1206.802393]  scsi_softirq_done+0xb5/0x150 [scsi_mod]
> Jul 12 18:51:00 localhost kernel: [ 1206.802396]  __blk_mq_complete_request+0xd4/0x160
> Jul 12 18:51:00 localhost kernel: [ 1206.802397]  blk_mq_complete_request+0x18/0x20
> Jul 12 18:51:00 localhost kernel: [ 1206.802402]  scsi_mq_done+0x21/0x80 [scsi_mod]
> Jul 12 18:51:00 localhost kernel: [ 1206.802405]  usb_stor_control_thread+0xf4/0x250 [usb_storage]
> Jul 12 18:51:00 localhost kernel: [ 1206.802407]  kthread+0x125/0x140
> Jul 12 18:51:00 localhost kernel: [ 1206.802409]  ? fill_inquiry_response+0x20/0x20 [usb_storage]
> Jul 12 18:51:00 localhost kernel: [ 1206.802410]  ? kthread_create_on_node+0x70/0x70
> Jul 12 18:51:00 localhost kernel: [ 1206.802412]  ret_from_fork+0x25/0x30
> Jul 12 18:51:00 localhost kernel: [ 1206.802413] Code: c2 74 a2 89 c2 89 d0 66 31 c0 39 c6 74 ea 4d 85 c9 c6 07 01 74 21 41 c7 41 08 01 00 00 00 eb 85 41 ff c9 75 04 f3 c3 f3 90 8b 07 <84> c0 75 f8 66 c7 07 01 00 c3 f3 90 4c 8b 09 4d 85 c9 74 f6 eb 

This is pretty conclusive.  The problem comes about because
usb_stor_control_thread() calls scsi_mq_done() while holding
shost->host_lock, and then scsi_eh_scmd_add() tries to acquire that
same lock.

I don't know why this didn't show up in earlier kernels.  I guess some
element of the call chain listed above must be new in 4.12.

Christoph, what's the best way to fix this?  Should usb-storage release
the host lock before issuing the ->scsi_done callback?  If so, does
that change need to be applied to any kernels before 4.12?

Alan Stern
