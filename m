From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] Re: 2.6.14-rc1 load average calculation broken?
Date: Fri, 16 Sep 2005 13:57:20 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0509161351240.4523-100000@iolanthe.rowland.org>
References: <432B0394.8030907@ppp0.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:64490 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP
	id S1161213AbVIPR5W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Sep 2005 13:57:22 -0400
In-Reply-To: <432B0394.8030907@ppp0.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Dittmer <jdittmer@ppp0.net>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: Pavel Machek <pavel@suse.cz>, Greg KH <greg@kroah.com>, SCSI development list <linux-scsi@vger.kernel.org>

[I have moved this thread to the SCSI list, where it now belongs.]

On Fri, 16 Sep 2005, Jan Dittmer wrote:

> Alan Stern wrote:
> > On Fri, 16 Sep 2005, Jan Dittmer wrote:
> > 
> > 
> >>>Can you post a stack dump for those two threads?  Normally they are idle,
> >>>in an interruptible wait, so they shouldn't be in D state.  Since they
> >>>are, maybe there's some sort of error recovery attempt going on.  Like
> >>>hald doing its periodic checking of hotpluggable storage devices while
> >>>your monitor is off.
> >>
> >>They don't appear in lsusb or /proc/scsi/scsi anymore, so I don't know what
> >>you mean.
> >>
> >>[4327082.342000] usb-storage   D 000F4261     0  3308      1          4671
> >>2487 (L-TLB)
> >>[4327082.342000] ded95f0c c9185a70 c04ae888 000f4261 00000010 ded94000
> >>00000000 cd393840
> >>[4327082.342000]        000f4261 dfabcb98 dfabca70 ce5b2300 000f4261 ded94000
> >>09c67100 00000000
> >>[4327082.342000]        c0410b24 00000286 c0410b2c dfabca70 c03adb5d 00000001
> >>dfabca70 c011a2f0
> >>[4327082.342000] Call Trace:
> >>[4327082.342000]  [<c03adb5d>] __down+0xdd/0x140
> >>[4327082.342000]  [<c011a2f0>] default_wake_function+0x0/0x20
> >>[4327082.342000]  [<c03ac35f>] __down_failed+0x7/0xc
> >>[4327082.342000]  [<c02c5050>] scsi_host_dev_release+0x0/0x90
> >>[4327082.342000]  [<c0134dd4>] .text.lock.kthread+0xb/0x27
> >>[4327082.342000]  [<c02c5087>] scsi_host_dev_release+0x37/0x90
> >>[4327082.342000]  [<c020a4be>] kobject_cleanup+0x4e/0xa0
> >>[4327082.342000]  [<c020a510>] kobject_release+0x0/0x10
> >>[4327082.342000]  [<c020af3f>] kref_put+0x2f/0x80
> >>[4327082.342000]  [<c020a53e>] kobject_put+0x1e/0x30
> >>[4327082.342000]  [<c020a510>] kobject_release+0x0/0x10
> >>[4327082.342000]  [<e0869288>] usb_stor_control_thread+0x68/0x240 [usb_storage]
> >>[4327082.342000]  [<c010322e>] ret_from_fork+0x6/0x14
> >>[4327082.342000]  [<e0869220>] usb_stor_control_thread+0x0/0x240 [usb_storage]
> >>[4327082.342000]  [<e0869220>] usb_stor_control_thread+0x0/0x240 [usb_storage]
> >>[4327082.342000]  [<c01013ad>] kernel_thread_helper+0x5/0x18
> > 
> > 
> > I recognize the problem.  This experimental patch should fix it:

http://marc.theaimsgroup.com/?l=linux-scsi&m=112681273931290&w=2

(This is the new error-handler thread-exit patch.)

> It fixes the described problem but introduces some others:
> 
> [4294822.152000] ACPI: PCI Interrupt 0000:00:0d.1[A] -> GSI 17 (level, low) ->
> IRQ 18
> [4294822.781000] libata version 1.12 loaded.
> [4294822.795000] sata_via version 1.1
> [4294822.795000] ACPI: PCI Interrupt 0000:00:0f.0[B] -> GSI 20 (level, low) ->
> IRQ 17
> [4294822.796000] PCI: Via IRQ fixup for 0000:00:0f.0, from 10 to 1
> [4294822.798000] sata_via(0000:00:0f.0): routed to hard irq line 1
> [4294822.800000] Unable to handle kernel NULL pointer dereference at virtual
> address 00000048
> [4294822.801000]  printing eip:
> [4294822.803000] e5c4d384
> [4294822.805000] *pde = 00000000
> [4294822.806000] Oops: 0000 [#1]
> [4294822.806000] PREEMPT
> [4294822.806000] Modules linked in: sata_via libata snd_bt87x pl2303 usbserial
> usblp usbhid snd_via82xx snd_mpu401_uart w83627hf w83781d i2c_viapro tun vfat
> fat loop via_agp intel_agp agpgart lp parport_pc parport tuner tvaudio msp3400
> bttv video_buf firmware_class v4l2_common btcx_risc tveeprom videodev eeprom
> asb100 hwmon_vid hwmon i2c_dev i2c_isa i2c_i801 snd_emu10k1_synth
> snd_emux_synth snd_seq_virmidi snd_seq_midi_emul snd_seq_dummy snd_seq_oss
> snd_seq_midi snd_seq_midi_event snd_seq snd_emu10k1 snd_rawmidi snd_seq_device
> snd_ac97_codec snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd_ac97_bus
> snd_page_alloc snd_util_mem snd_hwdep snd soundcore usb_storage ehci_hcd
> uhci_hcd usbcore button processor ac e100 rtc
> [4294822.806000] CPU:    0
> [4294822.806000] EIP:    0060:[<e5c4d384>]    Not tainted VLI
> [4294822.806000] EFLAGS: 00010282   (2.6.14-rc1-git1-via)
> [4294822.806000] EIP is at ata_scsi_error+0x14/0x30 [libata]
> [4294822.806000] eax: dfabb254   ebx: dfabb000   ecx: df8de000   edx: 00000000
> [4294822.806000] esi: deb82000   edi: dfabb000   ebp: c02c8310   esp: deb83fa8
> [4294822.806000] ds: 007b   es: 007b   ss: 0068
> [4294822.806000] Process scsi_eh_5 (pid: 6417, threadinfo=deb82000 task=df5fda70)
> [4294822.806000] Stack: dfabb254 dfabb000 c02c836d dfabb000 fffffffc df8dfde0
> c0134bb6 dfabb000
> [4294822.806000]        deb83fd0 00000000 ffffffff ffffffff c0134b00 00000000
> 00000000 00000000
> [4294822.806000]        c01013ad df8dfde0 00000000 00000000 00000000 00000000
> [4294822.806000] Call Trace:
> [4294822.806000]  [<c02c836d>] scsi_error_handler+0x5d/0xa0
> [4294822.806000]  [<c0134bb6>] kthread+0xb6/0xc0
> [4294822.806000]  [<c0134b00>] kthread+0x0/0xc0
> [4294822.806000]  [<c01013ad>] kernel_thread_helper+0x5/0x18
> [4294822.806000] Code: 83 bd 63 da 83 c4 08 31 c0 5b c3 8d b6 00 00 00 00 8d
> bf 00 00 00 00 53 83 ec 04 8b 5c 24 0c 8d 83 54 02 00 00 8b 50 04 89 04 24
> <ff> 52 48 8d 43 38 ff 4b 60 89 43 38 89 43 3c 83 c4 04 5b 31 c0
> [4294822.806000]  <6>ata1: SATA max UDMA/133 cmd 0xEC00 ctl 0xE802 bmdma
> 0xDC00 irq 17

This makes me suspect that the condition about host_busy == host_failed is 
wrong.  Unfortunately I don't know why it's wrong or how to fix it.

Perhaps somebody on the SCSI list can provide the answer.

Alan Stern

