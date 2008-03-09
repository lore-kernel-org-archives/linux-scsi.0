From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: kernel BUG at drivers/scsi/aic7xxx/aic79xx_osm.c:1490!
Date: Sun, 09 Mar 2008 14:25:49 +0300
Message-ID: <47D3C93D.8070204@msgid.tls.msk.ru>
References: <47D3C8A1.6040409@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hobbit.corpit.ru ([81.13.94.6]:24396 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406AbYCILZv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 9 Mar 2008 07:25:51 -0400
In-Reply-To: <47D3C8A1.6040409@msgid.tls.msk.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Michael Tokarev wrote:
> Just got quite.. bad situation on a production server
> here.  The machine locked up hard several times in a
> row (required hard reboot).  So I finally enabled watchdog
> subsystem which helped.
> 
> Now I see the following (over netconsole):

Forgot the most important information.

# uname -a
Linux tbus90.msk.rgs-podm.ru 2.6.24-x86-64 #2.6.24.2 SMP Mon Feb 18 16:04:41 MSK 2008 x86_64 GNU/Linux

It's mostly vanilla 2.6.24.2, with some irrelevant patches like unionfs
(not even loaded).


> DMA: Out of SW-IOMMU space for 65536 bytes at device 0000:08:07.0
> ------------[ cut here ]------------
> kernel BUG at drivers/scsi/aic7xxx/aic79xx_osm.c:1490!
> invalid opcode: 0000 [1] SMP
> CPU 0
> Modules linked in: xfs netconsole nfsd lockd nfs_acl sunrpc exportfs 
> autofs4 iTCO_wdt iTCO_vendor_support raid10 raid0 sr_mod cdrom ata_piix 
> libata tg3 mptspi mptscsih mptbase ext3 jbd mbcache raid1 md_mod sd_mod 
> aic79xx scsi_transport_spi scsi_mod
> Pid: 2176, comm: gzip Not tainted 2.6.24-x86-64 #2.6.24.2
> RIP: 0010:[<ffffffff8805053a>]  [<ffffffff8805053a>] 
> :aic79xx:ahd_linux_queue+0x58a/0x590
> RSP: 0000:ffffffff80511d40  EFLAGS: 00010082
> RAX: 00000000fffffff4 RBX: ffff81018c331600 RCX: 00000000fffffff4
> RDX: ffff8100063660e0 RSI: 0000000000000002 RDI: ffffffff804a2150
> RBP: ffff8101a9029e40 R08: 0000000000000044 R09: 0000000000000000
> R10: 00000000fffffff4 R11: ffffffff80222d80 R12: ffff8101aff8d418
> R13: ffff8101aeea7000 R14: ffff8101aef50000 R15: ffff8101aeea78b4
> FS:  0000000000000000(0000) GS:ffffffff804b7000(0063) 
> knlGS:00000000f7de56b0
> CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
> CR2: 0000000008065000 CR3: 00000001adbb8000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process gzip (pid: 2176, threadinfo ffff8101a9270000, task 
> ffff8101a91b2000)
> Stack:  ffff8101aff8d000 0000000000000083 0000000000000220 ffffffff80245435
>  ffff81014ec656c0 0000000000000293 ffff8101aff8d000 ffff81018c331600
>  ffff8101aef48800 ffff81018c331600 ffff8101aff8d048 ffffffff8800100c
> Call Trace:
>  <IRQ>  [<ffffffff80245435>] __mod_timer+0xb5/0xd0
>  [<ffffffff8800100c>] :scsi_mod:scsi_dispatch_cmd+0x17c/0x2e0
>  [<ffffffff88007db5>] :scsi_mod:scsi_request_fn+0x225/0x3d0
>  [<ffffffff802ee723>] blk_run_queue+0x43/0x80
>  [<ffffffff880063fb>] :scsi_mod:scsi_next_command+0x3b/0x60
>  [<ffffffff880065e5>] :scsi_mod:scsi_end_request+0xd5/0x110
>  [<ffffffff8800694e>] :scsi_mod:scsi_io_completion+0xae/0x3e0
>  [<ffffffff802eea89>] blk_done_softirq+0x69/0x80
>  [<ffffffff802415d5>] __do_softirq+0x75/0xe0
>  [<ffffffff8020ce3c>] call_softirq+0x1c/0x30
>  [<ffffffff8020efd5>] do_softirq+0x35/0x90
>  [<ffffffff80241558>] irq_exit+0x88/0x90
>  [<ffffffff8020f220>] do_IRQ+0x80/0x100
>  [<ffffffff8020c1c1>] ret_from_intr+0x0/0xa
>  <EOI>
> 
> Code: 0f 0b eb fe 66 90 48 83 ec 78 4c 89 64 24 58 4c 89 74 24 68
> RIP  [<ffffffff8805053a>] :aic79xx:ahd_linux_queue+0x58a/0x590
>  RSP <ffffffff80511d40>
> Kernel panic - not syncing: Fatal exception
> 
> 
> The hardware is an IBM xSeries 346 [8840ECY] machine, with
> 2x dualcore CPUs and 6Gb Ram.  It has 2 SCSI controllers -
> one onboard 2-channel AIC-7902B, and one LSI Logic 53c1030 PCI-X
> Fusion-MPT Dual Ultra320.  Total 16 drives are attached to the
> 2 controllers.
> 
> There's a linux software raid10 array running over 14 drives
> (7 drives on each controller), and an XFS filesystem on top of
> it (410Gb).
> 
> The problem (the above oops) happens almost immediately after
> I'm trying to gzip some file on that filesystem - the system
> dies within one minute of running gzip.  The same happens when
> I try to copy those files over NFS - the same instant lockup,
> but happens later than with gzip.
> 
> Please help!....  This is a critical piece of hardware.
> 
> Thanks!
> 
> /mjt

