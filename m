From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bugme-new] [Bug 13273] New: Error by disconnecting USB flash
 storage in 2.6.30-rc5 x86-64
Date: Mon, 11 May 2009 18:28:07 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0905111825210.3755-100000@iolanthe.rowland.org>
References: <20090511140153.fe1b3f01.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:42085 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756481AbZEKW2H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2009 18:28:07 -0400
In-Reply-To: <20090511140153.fe1b3f01.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: peter.kovar@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>, USB list <linux-usb@vger.kernel.org>, bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 11 May 2009, Andrew Morton wrote:

> (switched to email.  Please respond via emailed reply-to-all, not via the
> bugzilla web interface).
> 
> On Sun, 10 May 2009 10:44:59 GMT
> bugzilla-daemon@bugzilla.kernel.org wrote:
> 
> > http://bugzilla.kernel.org/show_bug.cgi?id=13273
> > 
> >            Summary: Error by disconnecting USB flash storage in 2.6.30-rc5
> >                     x86-64
> >            Product: Drivers
> >            Version: 2.5
> >           Platform: All
> >         OS/Version: Linux
> >               Tree: Mainline
> >             Status: NEW
> >           Severity: normal
> >           Priority: P1
> >          Component: USB
> >         AssignedTo: greg@kroah.com
> >         ReportedBy: peter.kovar@gmail.com
> >         Regression: No
> > 
> > 
> > Created an attachment (id=21291)
> >  --> (http://bugzilla.kernel.org/attachment.cgi?id=21291)
> > dmesg dump
> > 
> 
> Here's the fun bit:
> 
> > [36225.728401] usb-storage: storage_disconnect() called
> > [36225.728923] usb-storage: -- usb_stor_release_resources
> > [36225.728926] usb-storage: -- sending exit command to thread
> > [36225.729142] usb-storage: *** thread awakened.
> > [36225.729150] usb-storage: -- exiting
> > [36225.729710] usb-storage: -- dissociate_dev
> > [36225.730090]  unable to read partition table
> > [36225.730281] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
> > [36225.730287] IP: [<ffffffff81209340>] disk_part_iter_next+0xf0/0x100
> > [36225.730300] PGD 0 
> > [36225.730304] Oops: 0000 [#1] PREEMPT SMP 
> > [36225.730310] last sysfs file: /sys/class/net/eth0/statistics/collisions
> > [36225.730314] CPU 3 
> > [36225.730317] Modules linked in: vfat fat usb_storage nfs fuse appletalk psnap nfsd lockd nfs_acl auth_rpcgss sco bridge stp llc bnep l2cap bluetooth vboxnetflt vboxdrv autofs4 sunrpc ipv6 cpufreq_ondemand acpi_cpufreq freq_table dm_mirror dm_region_hash dm_log dm_multipath dm_mod snd_hda_codec_realtek snd_hda_intel snd_hda_codec nvidia(P) snd_pcm e1000e snd_timer 8250_pnp firewire_ohci snd iTCO_wdt firewire_core pl2303 r8169 usbserial iTCO_vendor_support i2c_i801 mii 8250 sr_mod soundcore rtc_cmos i2c_core pcspkr serial_core snd_page_alloc joydev crc_itu_t sg cdrom sd_mod uhci_hcd ohci_hcd ehci_hcd [last unloaded: microcode]
> > [36225.730411] Pid: 19715, comm: async/0 Tainted: P           2.6.30-rc5 #3         
> > [36225.730415] RIP: 0010:[<ffffffff81209340>]  [<ffffffff81209340>] disk_part_iter_next+0xf0/0x100
> > [36225.730422] RSP: 0018:ffff88006461fdc0  EFLAGS: 00010246
> > [36225.730425] RAX: ffff88010340dc00 RBX: ffff88006461fdf0 RCX: 0000000000000000
> > [36225.730429] RDX: 0000000000000008 RSI: 0000000000000000 RDI: 0000000000000000
> > [36225.730432] RBP: ffff88006461fde0 R08: 0000000000000000 R09: 0000000000000001
> > [36225.730436] R10: 0000000000000000 R11: 0000000000000001 R12: ffff88006461fdf0
> > [36225.730439] R13: ffff88013b594200 R14: 0000000000000000 R15: ffff880130166168
> > [36225.730443] FS:  0000000000000000(0000) GS:ffff88002809f000(0000) knlGS:0000000000000000
> > [36225.730447] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> > [36225.730451] CR2: 0000000000000010 CR3: 0000000001001000 CR4: 00000000000006e0
> > [36225.730454] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > [36225.730458] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > [36225.730462] Process async/0 (pid: 19715, threadinfo ffff88006461e000, task ffff8800b5e1d140)
> > [36225.730465] Stack:
> > [36225.730468]  0000000000000000 ffff88010340dc00 ffff88006461fdf0 ffff88013b594200
> > [36225.730474]  ffff88006461fe30 ffffffff8113afdb ffff88010340dc00 0000000000000000
> > [36225.730482]  0000000000000001 ffff880130166168 ffff88006461fe30 ffff88010340dc00
> > [36225.730491] Call Trace:
> > [36225.730494]  [<ffffffff8113afdb>] register_disk+0xcb/0x140
> > [36225.730501]  [<ffffffff81208f77>] add_disk+0x87/0x160
> > [36225.730508]  [<ffffffffa002ad06>] sd_probe_async+0x1a6/0x290 [sd_mod]
> > [36225.730517]  [<ffffffff81063f35>] async_thread+0x105/0x250
> > [36225.730524]  [<ffffffff8103fbc0>] ? default_wake_function+0x0/0x10
> > [36225.730531]  [<ffffffff81063e30>] ? async_thread+0x0/0x250
> > [36225.730536]  [<ffffffff81063e30>] ? async_thread+0x0/0x250
> > [36225.730541]  [<ffffffff8105cb75>] kthread+0x55/0xa0
> > [36225.730547]  [<ffffffff8100d03a>] child_rip+0xa/0x20
> > [36225.730554]  [<ffffffff8100ca00>] ? restore_args+0x0/0x30
> > [36225.730560]  [<ffffffff8105cb20>] ? kthread+0x0/0xa0
> > [36225.730565]  [<ffffffff8100d030>] ? child_rip+0x0/0x20
> > [36225.730570] Code: 48 8b 43 08 48 83 c4 08 5b 41 5c 41 5d c9 c3 0f 1f 40 00 49 8d 7c 24 10 e8 0e 9e 09 00 4c 89 63 08 44 01 6b 10 eb d4 0f 1f 40 00 <8b> 77 10 41 bd 01 00 00 00 e9 5d ff ff ff 66 90 55 48 89 e5 48 
> > [36225.730642] RIP  [<ffffffff81209340>] disk_part_iter_next+0xf0/0x100
> > [36225.730648]  RSP <ffff88006461fdc0>
> > [36225.730651] CR2: 0000000000000010
> 
> People are probably going to ask if it still happens if the nvidia
> driver has never been loaded into the kernel?
> 
> Are you sure this isn't a regression?  Did 2.6.29, 2.6.28 etc also oops
> in the same fashion?

I strongly suspect this may be a bug in the SCSI layer, not the USB 
layer.  Does this happen if you set the "scan=sync" parameter for 
scsi_mod?

Alan Stern

