From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [linux-usb-devel] Re: 2.6.14-rc1 load average calculation broken?
Date: Fri, 16 Sep 2005 13:28:28 -0700
Message-ID: <20050916202827.GA30689@us.ibm.com>
References: <432B0394.8030907@ppp0.net> <Pine.LNX.4.44L0.0509161351240.4523-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:44493 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S1750828AbVIPU2y
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Sep 2005 16:28:54 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e31.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j8GKSrAx210642
	for <linux-scsi@vger.kernel.org>; Fri, 16 Sep 2005 16:28:53 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j8GKSrg7536750
	for <linux-scsi@vger.kernel.org>; Fri, 16 Sep 2005 14:28:53 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id j8GKSqMq027687
	for <linux-scsi@vger.kernel.org>; Fri, 16 Sep 2005 14:28:53 -0600
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0509161351240.4523-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jan Dittmer <jdittmer@ppp0.net>, James Bottomley <James.Bottomley@SteelEye.com>, Pavel Machek <pavel@suse.cz>, Greg KH <greg@kroah.com>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern <stern@rowland.harvard.edu> wrote:
> > It fixes the described problem but introduces some others:
> > 
> > [4294822.152000] ACPI: PCI Interrupt 0000:00:0d.1[A] -> GSI 17 (level, low) ->
> > IRQ 18
> > [4294822.781000] libata version 1.12 loaded.
> > [4294822.795000] sata_via version 1.1
> > [4294822.795000] ACPI: PCI Interrupt 0000:00:0f.0[B] -> GSI 20 (level, low) ->
> > IRQ 17
> > [4294822.796000] PCI: Via IRQ fixup for 0000:00:0f.0, from 10 to 1
> > [4294822.798000] sata_via(0000:00:0f.0): routed to hard irq line 1
> > [4294822.800000] Unable to handle kernel NULL pointer dereference at virtual
> > address 00000048
> > [4294822.801000]  printing eip:
> > [4294822.803000] e5c4d384
> > [4294822.805000] *pde = 00000000
> > [4294822.806000] Oops: 0000 [#1]
> > [4294822.806000] PREEMPT
> > [4294822.806000] Modules linked in: sata_via libata snd_bt87x pl2303 usbserial
> > usblp usbhid snd_via82xx snd_mpu401_uart w83627hf w83781d i2c_viapro tun vfat
> > fat loop via_agp intel_agp agpgart lp parport_pc parport tuner tvaudio msp3400
> > bttv video_buf firmware_class v4l2_common btcx_risc tveeprom videodev eeprom
> > asb100 hwmon_vid hwmon i2c_dev i2c_isa i2c_i801 snd_emu10k1_synth
> > snd_emux_synth snd_seq_virmidi snd_seq_midi_emul snd_seq_dummy snd_seq_oss
> > snd_seq_midi snd_seq_midi_event snd_seq snd_emu10k1 snd_rawmidi snd_seq_device
> > snd_ac97_codec snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd_ac97_bus
> > snd_page_alloc snd_util_mem snd_hwdep snd soundcore usb_storage ehci_hcd
> > uhci_hcd usbcore button processor ac e100 rtc
> > [4294822.806000] CPU:    0
> > [4294822.806000] EIP:    0060:[<e5c4d384>]    Not tainted VLI
> > [4294822.806000] EFLAGS: 00010282   (2.6.14-rc1-git1-via)
> > [4294822.806000] EIP is at ata_scsi_error+0x14/0x30 [libata]
> > [4294822.806000] eax: dfabb254   ebx: dfabb000   ecx: df8de000   edx: 00000000
> > [4294822.806000] esi: deb82000   edi: dfabb000   ebp: c02c8310   esp: deb83fa8
> > [4294822.806000] ds: 007b   es: 007b   ss: 0068
> > [4294822.806000] Process scsi_eh_5 (pid: 6417, threadinfo=deb82000 task=df5fda70)
> > [4294822.806000] Stack: dfabb254 dfabb000 c02c836d dfabb000 fffffffc df8dfde0
> > c0134bb6 dfabb000
> > [4294822.806000]        deb83fd0 00000000 ffffffff ffffffff c0134b00 00000000
> > 00000000 00000000
> > [4294822.806000]        c01013ad df8dfde0 00000000 00000000 00000000 00000000
> > [4294822.806000] Call Trace:
> > [4294822.806000]  [<c02c836d>] scsi_error_handler+0x5d/0xa0
> > [4294822.806000]  [<c0134bb6>] kthread+0xb6/0xc0
> > [4294822.806000]  [<c0134b00>] kthread+0x0/0xc0
> > [4294822.806000]  [<c01013ad>] kernel_thread_helper+0x5/0x18
> > [4294822.806000] Code: 83 bd 63 da 83 c4 08 31 c0 5b c3 8d b6 00 00 00 00 8d
> > bf 00 00 00 00 53 83 ec 04 8b 5c 24 0c 8d 83 54 02 00 00 8b 50 04 89 04 24
> > <ff> 52 48 8d 43 38 ff 4b 60 89 43 38 89 43 3c 83 c4 04 5b 31 c0
> > [4294822.806000]  <6>ata1: SATA max UDMA/133 cmd 0xEC00 ctl 0xE802 bmdma
> > 0xDC00 irq 17
> 
> This makes me suspect that the condition about host_busy == host_failed is 
> wrong.  Unfortunately I don't know why it's wrong or how to fix it.
> 
> Perhaps somebody on the SCSI list can provide the answer.
> 

What condition are you thinking would happen if this was wrong (we are
getting woken up too early?)? I did a quick look and could not see changes
between 2.6.13 and 2.16.14-rc1 that would make these values wrong. This is
just a check to ensure the eh is not woken up to early. Historically in
older scsi eh code there used to be a panic if the error handler was woken
up to early. In scsi_unjam_host and a quick look at ata_scsi_error getting
woken up early should not cause a panic.

I built a listfile (libata-scsi.lst) and it is probably not an exact
match. ..but..

These lines in ata_scsi_error(..) appear to be close to the failure and
edx being zero as shown above in the oops would not be good.
	ap->ops->eng_timeout(ap);
	499:       8b 50 04                mov    0x4(%eax),%edx
	49c:       ff 52 48                call   *0x48(%edx)

Since I do not know the libata code it is unclear from doing a short
search how an ops pointer could get altered or if my observations are
correct.

-andmike
--
Michael Anderson
andmike@us.ibm.com
