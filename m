From: Andrew Morton <akpm@osdl.org>
Subject: Re: bug in mm/slab.c
Date: Tue, 23 Nov 2004 15:55:19 -0800
Message-ID: <20041123155519.4c08a949.akpm@osdl.org>
References: <34591.200.113.104.46.1101247993.squirrel@mail.chile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:51595 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S261631AbUKWXvS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Nov 2004 18:51:18 -0500
In-Reply-To: <34591.200.113.104.46.1101247993.squirrel@mail.chile.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: celeron2002@chile.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


(This is 2.6.9)

<celeron2002@chile.com> wrote:
>
> kmem_cache_create: duplicate cache sgpool-8

This is due to the scsi layer trying to create the "sgpool-8" cache during
`modprobe scsi_mod', but that cache already exists.

There have been a few reports of this, and I _think_ it has been fixed. 
Could the scsi folks please confirm?



> ------------[ cut here ]------------
> kernel BUG at mm/slab.c:1442!
> invalid operand: 0000 [#1]
> PREEMPT
> Modules linked in: scsi_mod i2c_amd756 i2c_algo_bit i2c_isa i2c_algo_pcf
> w83781d i2c_sensor nvidia
> CPU:    0
> EIP:    0060:[<c0139a22>]    Tainted: P   VLI
> EFLAGS: 00010202   (2.6.9-final)
> EIP is at kmem_cache_create+0x3f2/0x560
> eax: 0000002c   ebx: cee8fdd0   ecx: c056b8cc   edx: 00000286
> esi: c046a7c6   edi: cfa9c343   ebp: cec41c60   esp: cdc6af34
> ds: 007b   es: 007b   ss: 0068
> Process modprobe (pid: 1094, threadinfo=cdc6a000 task=cdcf0aa0)
> Stack: c044d5dc cfa9c33a 00000020 00002000 cdc6af54 cec41c9c ffffffe0
> c0000000
>        00000020 cfaa2dc0 00000000 cdc6a000 c049f4e0 cfa5e10a cfa9c33a
> 00000080
>        00000020 00002000 00000000 00000000 c049f4f8 cfaa3340 cfa5e009
> b7fcd000
> Call Trace:
>  [<cfa5e10a>] scsi_init_queue+0x4a/0xc0 [scsi_mod]
>  [<cfa5e009>] init_scsi+0x9/0xc0 [scsi_mod]
>  [<c012e7fa>] sys_init_module+0x18a/0x270
>  [<c01040b9>] sysenter_past_esp+0x52/0x71
