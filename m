From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: scsi_wait_scan not working (2.6.30.5)
Date: Sat, 29 Aug 2009 23:07:31 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0908292301460.27655-100000@netrider.rowland.org>
References: <200908300127.35339.a.miskiewicz@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:51192 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752666AbZH3DHc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Aug 2009 23:07:32 -0400
In-Reply-To: <200908300127.35339.a.miskiewicz@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>

On Sun, 30 Aug 2009, Arkadiusz Miskiewicz wrote:

> > Can you provide the dmesg log showing what happens during bootup with
> > the patch applied?
> 
> Hm, can console= point to netconsole somehow, so userspace messages could be seen
> via netconsole? Anyway from netconsole:
> 
> Aug 30 01:07:16 rhea   13.144139] netconsole: network logging started
> Aug 30 01:07:16 rhea   13.173297] SCSI subsystem initialized
> Aug 30 01:07:16 rhea   13.189630] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
> Aug 30 01:07:16 rhea   13.216688] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
> Aug 30 01:07:16 rhea   13.238942] megaraid: probe new device 0x1000:0x0407:0x1000:0x0530:
> Aug 30 01:07:16 rhea bus: 2:slot 3:func 0
> Aug 30 01:07:16 rhea   13.271180] megaraid 0000:02:03.0: PCI INT A -> GSI 27 (level, low) -> IRQ 27
> Aug 30 01:07:16 rhea   13.316707] megaraid: fw version:[414G] bios version:[A100]
> Aug 30 01:07:16 rhea   13.334528] scsi0 : LSI Logic MegaRAID driver
> Aug 30 01:07:16 rhea   13.352156] scsi[0]: scanning scsi channel 0 [Phy 0]
> Aug 30 01:07:16 rhea for: non-raid devices
> Aug 30 01:07:16 rhea   13.381065] Driver 'sd' needs updating - please use bus_type methods
> Aug 30 01:07:16 rhea   13.420430] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
> Aug 30 01:07:16 rhea   13.453259] SGI XFS Quota Management subsystem
> Aug 30 01:07:16 rhea   13.583779] VFS: Cannot open root device "802" or unknown-block(8,2)
> Aug 30 01:07:16 rhea   13.602814] Please append a correct "root=" boot option; here are the available partitions:
> Aug 30 01:07:16 rhea   13.627824] Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(8,2)
> Aug 30 01:07:16 rhea   13.652637] Pid: 1, comm: swapper Not tainted 2.6.30.5-vs2.3.0.36.14-pre7-0.3 #4
> Aug 30 01:07:16 rhea   13.674797] Call Trace:
> Aug 30 01:07:16 rhea   13.682138]  [<ffffffff8056e75d>] ? panic+0x7a/0x12e
> Aug 30 01:07:16 rhea   13.697003]  [<ffffffff8056e851>] ? printk+0x40/0x47
> Aug 30 01:07:16 rhea   13.711890]  [<ffffffff8072e090>] ? mount_block_root+0x1d6/0x271
> Aug 30 01:07:16 rhea   13.729892]  [<ffffffff8072ecdb>] ? initrd_load+0x228/0x324
> Aug 30 01:07:16 rhea   13.746585]  [<ffffffff8072e24f>] ? prepare_namespace+0xd5/0x18d
> Aug 30 01:07:16 rhea   13.764578]  [<ffffffff8072d6cf>] ? kernel_init+0x178/0x188
> Aug 30 01:07:16 rhea   13.781282]  [<ffffffff8020ceba>] ? child_rip+0xa/0x20
> Aug 30 01:07:16 rhea   13.796686]  [<ffffffff8072d557>] ? kernel_init+0x0/0x188
> Aug 30 01:07:16 rhea   13.812858]  [<ffffffff8020ceb0>] ? child_rip+0x0/0x20
> Aug 30 01:07:16 rhea   13.828253] Rebooting in 60 seconds

> ...
> 
> and of course adding sleep 10 after scsi_wait_scan fixes boot

Not especially helpful, I'm afraid.  If you could add some extra printk
statements, it would be better.  For example, you might add some
KERN_INFO messages to sd.c at the start of sd_probe(), just before the
async_schedule() call near the end, and at the start of
sd_probe_async().  In addition, some messages demarking the various
steps of wait_scan_init() in scsi_wait_scan.c would be good.

Let's see what these messages produce both with and without the "sleep 
10" in your initrd.

Alan Stern

