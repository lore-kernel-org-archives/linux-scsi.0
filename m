From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: BUG: unable to handle kernel paging request - scsi_bus_uevent
Date: Wed, 14 May 2008 19:48:05 -0700
Message-ID: <20080514194805.7ff54c79.akpm@linux-foundation.org>
References: <c4e36d110805140223w640a4e1erf613ce27284e78ff@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35990 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750720AbYEOCsc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 May 2008 22:48:32 -0400
In-Reply-To: <c4e36d110805140223w640a4e1erf613ce27284e78ff@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org


(cc linux-scsi)

On Wed, 14 May 2008 11:23:02 +0200 "Zdenek Kabelac" <zdenek.kabelac@gmail.com> wrote:

> Hello
> 
> 
> With kernel 2.6.26-rc2 - commit 093e2bb3cb5fcc37e3d02a193a3435ba64e9eb7b
> (2 days old) I've got oops during boot (my setup T61, C2D, 2GB)
> 
> Zdenek
> 
> This oops is not deterministic
> 
> BUG: unable to handle kernel paging request at ffff81007ca27f78
> IP: [<ffffffff81218497>] scsi_bus_uevent+0x7/0x30
> PGD 8063 PUD a063 PMD 7ceb8163 PTE 800000007ca27160
> Oops: 0000 [1] PREEMPT SMP DEBUG_PAGEALLOC
> CPU 0
> Modules linked in: uhci_hcd ohci_hcd ehci_hcd usbcore
> Pid: 612, comm: udevtrigger Not tainted 2.6.26-rc2 #1
> RIP: 0010:[<ffffffff81218497>]  [<ffffffff81218497>] scsi_bus_uevent+0x7/0x30
> RSP: 0018:ffff81007c9ffdb8  EFLAGS: 00010286
> RAX: ffff81007e152090 RBX: ffff81007ca28028 RCX: 0000000000000003
> RDX: ffff81007e1521e9 RSI: ffff81007e152090 RDI: ffff81007ca28028
> RBP: ffff81007c9ffdb8 R08: 00000000fffffffe R09: 000000000000000b
> R10: ffffffff8140d3d1 R11: ffff81007c9ffcd8 R12: ffff81007e152090
> R13: 0000000000000000 R14: ffffffff8147c8e0 R15: 0000000000000000
> FS:  00007f57ce88a780(0000) GS:ffffffff81493000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: ffff81007ca27f78 CR3: 000000007cefb000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process udevtrigger (pid: 612, threadinfo ffff81007c9fe000, task
> ffff81007c910000)
> Stack:  ffff81007c9ffdd8 ffffffff81202bf4 ffff81007e02d738 ffff81007ca281d8
>  ffff81007c9ffe68 ffffffff81177cd5 ffffffff813e5dff 0000000000000000
>  ffff81007ca88cc0 ffff81007e152090 ffffffff8142831e 0000000000000000
> Call Trace:
>  [<ffffffff81202bf4>] dev_uevent+0x84/0x120
>  [<ffffffff81177cd5>] kobject_uevent_env+0x1d5/0x3f0
>  [<ffffffff81177efb>] kobject_uevent+0xb/0x10
>  [<ffffffff81202eb8>] store_uevent+0x38/0xa0
>  [<ffffffff8120244e>] dev_attr_store+0x1e/0x20
>  [<ffffffff8111032a>] sysfs_write_file+0xca/0x140
>  [<ffffffff810b98eb>] vfs_write+0xcb/0x170
>  [<ffffffff810b9a80>] sys_write+0x50/0x90
>  [<ffffffff8100c50b>] system_call_after_swapgs+0x7b/0x80
> 
> 
> Code: f5 ff 4d 85 e4 74 0f 49 8b 44 24 28 48 85 c0 74 05 48 89 df ff
> d0 31 c0 48 8b 1c 24 4c 8b 64 24 08 c9 c3 90 55 48 89 f0 48 89 e5 <0f>
> be 97 50 ff ff ff 48 c7 c6 43 d4 40 81 48 89 c7 31 c0 e8 21
> RIP  [<ffffffff81218497>] scsi_bus_uevent+0x7/0x30
>  RSP <ffff81007c9ffdb8>
> CR2: ffff81007ca27f78

