From: Andrew Morton <akpm@osdl.org>
Subject: Re: [Bug 1594] New: kernel BUG at mm/slab.c:1268!, did not affect
 the system's ability to run
Date: Tue, 25 Nov 2003 11:05:13 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031125110513.078dd6b6.akpm@osdl.org>
References: <200311251851.hAPIpuRi023659@fire-1.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:25060 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S262864AbTKYTEh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Nov 2003 14:04:37 -0500
In-Reply-To: <200311251851.hAPIpuRi023659@fire-1.osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: tstef@cs.purdue.edu


This crashed because scsi_init_queue() tried to create a slab cache which
already exists.

Please see if it can be reproduced, then send a description of the system,
which drivers are in use and the method by whcih the crash can be
reproduced to linux-scsi@vger.kernel.org, Cc'ed here.

Thanks.

bugme-daemon@osdl.org wrote:
>
> http://bugme.osdl.org/show_bug.cgi?id=1594
> 
>            Summary: kernel BUG at mm/slab.c:1268!, did not affect the
>                     system's ability to run
>     Kernel Version: 2.6.0-test10-gentoo-r1
>             Status: NEW
>           Severity: normal
>              Owner: akpm@digeo.com
>          Submitter: tstef@cs.purdue.edu
> 
> 
> Distribution: Gentoo 
> Hardware Environment:  
> Compaq Presario 1500 laptop 
> Linux laptop 2.6.0-test10-gentoo-r1 #1 SMP Mon Nov 24 20:06:57 
> CST 2003 i686 Intel(R) Pentium(R) 4 CPU 2.00GHz GenuineIntel GNU/Linux 
>  
> Problem Description: 
> When logged in, I got this on the screen 
>  
> kernel BUG at mm/slab.c:1268! 
> invalid operand: 0000 [#1] 
> CPU:    0 
> EIP:    0060:[<c0145aed>]    Not tainted 
> EFLAGS: 00010202 
> EIP is at kmem_cache_create+0x458/0x569 
> eax: 0000002c   ebx: dbf1cc08   ecx: c046a2f0   edx: 00000286 
> esi: c037e3da   edi: dc9b2b7a   ebp: dad0bf5c   esp: dad0bf2c 
> ds: 007b   es: 007b   ss: 0068 
> Process modprobe (pid: 3138, threadinfo=dad0a000 task=db3ba080) 
> Stack: c03688c0 dc9b2b71 00002000 dad0bf4c dbda8294 c0000000 dbda823c 
> ffffff80 
>        00000000 00000000 00000004 c03abed0 dad0bf84 dc93913b dc9b2b71 
> 00000080 
>        00000080 00002000 00000000 00000000 c03abeec dc9bcd00 dad0bf9c 
> dc93900e 
> Call Trace: 
>  [<dc93913b>] scsi_init_queue+0x4a/0xcf [scsi_mod] 
>  [<dc93900e>] init_scsi+0xe/0xf1 [scsi_mod] 
>  [<c013cf11>] sys_init_module+0x14f/0x233 
>  [<c010a437>] syscall_call+0x7/0xb 
>  
> Code: 0f 0b f4 04 bf 80 36 c0 8b 0b e9 6a ff ff ff 8b 47 50 c7 04 
>  

