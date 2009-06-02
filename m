From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 13420] New: NULL pointer dereference after
 hard-resetting a usb-connected iPod
Date: Mon, 1 Jun 2009 21:48:01 -0700
Message-ID: <20090601214801.0d59154a.akpm@linux-foundation.org>
References: <bug-13420-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35609 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751159AbZFBEsJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jun 2009 00:48:09 -0400
In-Reply-To: <bug-13420-10286@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org
Cc: bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org, dariush@forouher.de, Kay Sievers <kay.sievers@vrfy.org>



(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).


On Mon, 1 Jun 2009 11:54:13 GMT bugzilla-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=13420
> 
>            Summary: NULL pointer dereference after hard-resetting a
>                     usb-connected iPod
>            Product: Drivers
>            Version: 2.5
>     Kernel Version: 2.6.30-rc7
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: USB
>         AssignedTo: greg@kroah.com
>         ReportedBy: dariush@forouher.de
>         Regression: No
> 

scsi and USB core conspired to get a NULL pointer passed into
device_del() and the driver core wasn't robust enough to handle it.

Kay: if you have time: driver do this rather a lot and it would be good
if we could bullet-proof the core a bit more to handle these bugs more
gracefully.

The trace is horridly wordwrapped.  I'll see if I can get that fixed,
after the bugzilla guys have repsonded to my previous emails.  Sigh.

It would help if someone could work out if this is a scsi bug or a USB
bug so we can assign it appropriately, thanks.

> Platform: Dell Latidude D630
> Arch: x86_64
> OS: Debian Stable/Unstable
> 
> I own an iPod which once in a while hangs itself when I connect it to
> my laptop (I don't know if details matter here, it's an older device and quite
> possibly buggy).
> 
> Jun  1 13:11:54 polaris kernel: [11800.823139] usb 2-3: new high speed USB
> device using ehci_hcd and address 4
> Jun  1 13:11:54 polaris kernel: [11800.942218] usb 2-3: configuration #1 chosen
> from 2 choices
> Jun  1 13:11:54 polaris kernel: [11800.946501] scsi5 : SCSI emulation for USB
> Mass Storage devices
> Jun  1 13:11:54 polaris kernel: [11800.947928] usb-storage: device found at 4
> Jun  1 13:11:54 polaris kernel: [11800.947934] usb-storage: waiting for device
> to settle before scanning
> Jun  1 13:11:59 polaris kernel: [11805.948327] usb-storage: device scan
> complete
> Jun  1 13:11:59 polaris kernel: [11805.949683] scsi 5:0:0:0: Direct-Access    
> Apple    iPod             1.62 PQ: 0 ANSI: 0
> Jun  1 13:11:59 polaris kernel: [11805.955498] sd 5:0:0:0: Attached scsi
> generic sg1 type 0
> 
> 
> 
> After noticing that the iPod has hung I tried disconnecting the iPod and
> plugging it back in...
> 
> 
> Jun  1 13:13:17 polaris kernel: [11883.745786] usb 2-3: USB disconnect, address
> 4
> Jun  1 13:13:17 polaris kernel: [11883.746689] sd 5:0:0:0: [sdb] READ CAPACITY
> failed
> Jun  1 13:13:17 polaris kernel: [11883.746696] sd 5:0:0:0: [sdb] Result:
> hostbyte=0x07 driverbyte=0x00
> Jun  1 13:13:17 polaris kernel: [11883.746706] sd 5:0:0:0: [sdb] Sense not
> available.
> Jun  1 13:13:17 polaris kernel: [11883.746914] sd 5:0:0:0: [sdb] Write Protect
> is off
> Jun  1 13:13:17 polaris kernel: [11883.746921] sd 5:0:0:0: [sdb] Mode Sense: 00
> 00 00 00
> Jun  1 13:13:17 polaris kernel: [11883.746927] sd 5:0:0:0: [sdb] Assuming drive
> cache: write through
> Jun  1 13:13:17 polaris kernel: [11883.747372] sd 5:0:0:0: [sdb] Attached SCSI
> removable disk
> Jun  1 13:13:26 polaris kernel: [11892.489161] usb 2-3: new high speed USB
> device using ehci_hcd and address 5
> Jun  1 13:13:26 polaris kernel: [11892.606346] usb 2-3: configuration #1 chosen
> from 2 choices
> Jun  1 13:13:26 polaris kernel: [11892.607038] scsi6 : SCSI emulation for USB
> Mass Storage devices
> Jun  1 13:13:26 polaris kernel: [11892.607858] usb-storage: device found at 5
> Jun  1 13:13:26 polaris kernel: [11892.607864] usb-storage: waiting for device
> to settle before scanning
> Jun  1 13:13:31 polaris kernel: [11897.607428] usb-storage: device scan
> complete
> Jun  1 13:13:31 polaris kernel: [11897.608329] scsi 6:0:0:0: Direct-Access    
> Apple    iPod             1.62 PQ: 0 ANSI: 0
> Jun  1 13:13:31 polaris kernel: [11897.610034] sd 6:0:0:0: Attached scsi
> generic sg1 type 0
> 
> 
> ... but the iPod still hung. So i hard-resetted it while it was still connected
> to the laptop. Oops:
> 
> 
> Jun  1 13:13:48 polaris kernel: [11915.124766] usb 2-3: USB disconnect, address
> 5
> Jun  1 13:13:48 polaris kernel: [11915.126638] BUG: unable to handle kernel
> NULL pointer dereference at 00000000000000b8
> Jun  1 13:13:48 polaris kernel: [11915.126651] IP: [<ffffffff8056219e>]
> device_del+0xe/0x1d0
> Jun  1 13:13:48 polaris kernel: [11915.126670] PGD 0
> Jun  1 13:13:48 polaris kernel: [11915.126677] Oops: 0000 [#1] SMP
> Jun  1 13:13:48 polaris kernel: [11915.126685] last sysfs file:
> /sys/devices/pci0000:00/0000:00:1d.2/pools
> Jun  1 13:13:48 polaris kernel: [11915.126692] CPU 1
> Jun  1 13:13:48 polaris kernel: [11915.126697] Modules linked in: vboxnetflt
> vboxdrv dell_laptop
> Jun  1 13:13:48 polaris kernel: [11915.126714] Pid: 339, comm: khubd Not
> tainted 2.6.30-rc7 #1 Latitude D630
> Jun  1 13:13:48 polaris kernel: [11915.126721] RIP: 0010:[<ffffffff8056219e>] 
> [<ffffffff8056219e>] device_del+0xe/0x1d0
> Jun  1 13:13:48 polaris kernel: [11915.126734] RSP: 0018:ffff88007f1fba80 
> EFLAGS: 00010282
> Jun  1 13:13:48 polaris kernel: [11915.126740] RAX: ffffffff80580840 RBX:
> 0000000000000000 RCX: 00000000ffffffff
> Jun  1 13:13:48 polaris kernel: [11915.126746] RDX: ffff880072d51168 RSI:
> ffffffff80579600 RDI: 0000000000000010
> Jun  1 13:13:48 polaris kernel: [11915.126752] RBP: ffff88007f1fbaa0 R08:
> 0000000000000000 R09: 0000000000000000
> Jun  1 13:13:48 polaris kernel: [11915.126759] R10: 0000000000000001 R11:
> 0000000000000001 R12: 0000000000000010
> Jun  1 13:13:48 polaris kernel: [11915.126765] R13: 0000000000000010 R14:
> ffff880069f2f828 R15: ffff880072d54000
> Jun  1 13:13:48 polaris kernel: [11915.126772] FS:  0000000000000000(0000)
> GS:ffff88000141d000(0000) knlGS:0000000000000000
> Jun  1 13:13:48 polaris kernel: [11915.126779] CS:  0010 DS: 0018 ES: 0018 CR0:
> 000000008005003b
> Jun  1 13:13:48 polaris kernel: [11915.126785] CR2: 00000000000000b8 CR3:
> 0000000000201000 CR4: 00000000000006e0
> Jun  1 13:13:48 polaris kernel: [11915.126791] DR0: 0000000000000000 DR1:
> 0000000000000000 DR2: 0000000000000000
> Jun  1 13:13:48 polaris kernel: [11915.126798] DR3: 0000000000000000 DR6:
> 00000000ffff0ff0 DR7: 0000000000000400
> Jun  1 13:13:48 polaris kernel: [11915.126805] Process khubd (pid: 339,
> threadinfo ffff88007f1fa000, task ffff88007f17d6a0)
> Jun  1 13:13:48 polaris kernel: [11915.126810] Stack:
> Jun  1 13:13:48 polaris kernel: [11915.126814]  0000000000000000
> ffff880072d51168 0000000000000010 ffff880069f2f828
> Jun  1 13:13:48 polaris kernel: [11915.126826]  ffff88007f1fbad0
> ffffffff8058086a 0000000000000004 ffff880072d51168
> Jun  1 13:13:48 polaris kernel: [11915.126840]  ffffffff80abefc8
> ffffffff80abe2a0 ffff88007f1fbaf0 ffffffff8057dd12
> Jun  1 13:13:48 polaris kernel: [11915.126856] Call Trace:
> Jun  1 13:13:48 polaris kernel: [11915.126862]  [<ffffffff8058086a>]
> sd_remove+0x2a/0x80
> Jun  1 13:13:48 polaris kernel: [11915.126873]  [<ffffffff8057dd12>]
> scsi_bus_remove+0x42/0x50
> Jun  1 13:13:48 polaris kernel: [11915.126883]  [<ffffffff80564992>]
> __device_release_driver+0x72/0xc0
> Jun  1 13:13:48 polaris kernel: [11915.126893]  [<ffffffff80564ac8>]
> device_release_driver+0x28/0x40
> Jun  1 13:13:48 polaris kernel: [11915.126902]  [<ffffffff80563e40>]
> bus_remove_device+0xb0/0xf0
> Jun  1 13:13:48 polaris kernel: [11915.126911]  [<ffffffff805622c8>]
> device_del+0x138/0x1d0
> Jun  1 13:13:48 polaris kernel: [11915.126921]  [<ffffffff8057e0a3>]
> __scsi_remove_device+0x53/0x90
> Jun  1 13:13:48 polaris kernel: [11915.126930]  [<ffffffff8057afc5>]
> scsi_forget_host+0x75/0x80
> Jun  1 13:13:48 polaris kernel: [11915.126942]  [<ffffffff80574277>]
> scsi_remove_host+0x77/0x130
> Jun  1 13:13:48 polaris kernel: [11915.126951]  [<ffffffff8061e62a>]
> quiesce_and_remove_host+0x7a/0xd0
> Jun  1 13:13:48 polaris kernel: [11915.126963]  [<ffffffff8061e758>]
> usb_stor_disconnect+0x18/0x30
> Jun  1 13:13:48 polaris kernel: [11915.126973]  [<ffffffff80604942>]
> usb_unbind_interface+0x62/0x170
> Jun  1 13:13:48 polaris kernel: [11915.126986]  [<ffffffff80564992>]
> __device_release_driver+0x72/0xc0
> Jun  1 13:13:48 polaris kernel: [11915.126995]  [<ffffffff80564ac8>]
> device_release_driver+0x28/0x40
> Jun  1 13:13:48 polaris kernel: [11915.127004]  [<ffffffff80563e40>]
> bus_remove_device+0xb0/0xf0
> Jun  1 13:13:48 polaris kernel: [11915.127013]  [<ffffffff805622c8>]
> device_del+0x138/0x1d0
> Jun  1 13:13:48 polaris kernel: [11915.127022]  [<ffffffff806015d5>]
> usb_disable_device+0xa5/0x130
> Jun  1 13:13:48 polaris kernel: [11915.127032]  [<ffffffff805fc1db>]
> usb_disconnect+0xbb/0x130
> Jun  1 13:13:48 polaris kernel: [11915.127042]  [<ffffffff805fd0df>]
> hub_thread+0x3ef/0x13e0
> Jun  1 13:13:48 polaris kernel: [11915.127051]  [<ffffffff8026bdbd>] ?
> trace_hardirqs_on+0xd/0x10
> Jun  1 13:13:48 polaris kernel: [11915.127066]  [<ffffffff8080da0f>] ?
> _spin_unlock_irqrestore+0x3f/0x60
> Jun  1 13:13:48 polaris kernel: [11915.127079]  [<ffffffff8025aea0>] ?
> autoremove_wake_function+0x0/0x40
> Jun  1 13:13:48 polaris kernel: [11915.127091]  [<ffffffff805fccf0>] ?
> hub_thread+0x0/0x13e0
> Jun  1 13:13:48 polaris kernel: [11915.127100]  [<ffffffff805fccf0>] ?
> hub_thread+0x0/0x13e0
> Jun  1 13:13:48 polaris kernel: [11915.127109]  [<ffffffff8025aac6>]
> kthread+0x56/0x90
> Jun  1 13:13:48 polaris kernel: [11915.127118]  [<ffffffff8020c43a>]
> child_rip+0xa/0x20
> Jun  1 13:13:48 polaris kernel: [11915.127131]  [<ffffffff8020be3c>] ?
> restore_args+0x0/0x30
> Jun  1 13:13:48 polaris kernel: [11915.127141]  [<ffffffff8025aa70>] ?
> kthread+0x0/0x90
> Jun  1 13:13:48 polaris kernel: [11915.127150]  [<ffffffff8020c430>] ?
> child_rip+0x0/0x20
> Jun  1 13:13:48 polaris kernel: [11915.127160] Code: 48 83 c4 08 5b 41 5c 41 5d
> 41 5e 41 5f c9 c3 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 41 56
> 41 55 41 54 49 89 f
> c 53 <48> 8b 87 a8 00 00 00 4c 8b 37 48 85 c0 74 18 48 8b 78 70 4c 89
> Jun  1 13:13:48 polaris kernel: [11915.127263] RIP  [<ffffffff8056219e>]
> device_del+0xe/0x1d0
> Jun  1 13:13:48 polaris kernel: [11915.127263]  RSP <ffff88007f1fba80>
> Jun  1 13:13:48 polaris kernel: [11915.127263] CR2: 00000000000000b8
> Jun  1 13:13:48 polaris kernel: [11915.127329] ---[ end trace cc2ced89cc82911f
> ]---
> Jun  1 13:13:48 polaris kernel: [11915.130236] sd 6:0:0:0: [sdb] READ CAPACITY
> failed
> Jun  1 13:13:48 polaris kernel: [11915.130246] sd 6:0:0:0: [sdb] Result:
> hostbyte=0x01 driverbyte=0x00
> Jun  1 13:13:48 polaris kernel: [11915.130256] sd 6:0:0:0: [sdb] Sense not
> available.
> Jun  1 13:13:48 polaris kernel: [11915.130299] sd 6:0:0:0: [sdb] Write Protect
> is off
> Jun  1 13:13:48 polaris kernel: [11915.130306] sd 6:0:0:0: [sdb] Mode Sense: 00
> 00 00 00
> Jun  1 13:13:48 polaris kernel: [11915.130312] sd 6:0:0:0: [sdb] Assuming drive
> cache: write through
> Jun  1 13:13:48 polaris kernel: [11915.130582] sd 6:0:0:0: [sdb] Attached SCSI
> removable disk
> 
> 
> 
> I observed this bug twice during the last month (the other time was with
> 2.6.30-rc4 I think). The bug seems to happen reliably once the iPod has hung it
> self. But since the bug in the iPod isn't easy to trigger, I can't reproduce
> the NULL dererefence repeatedly at the moment. 
> 

