From: Jens Axboe <axboe@suse.de>
Subject: Re: aacraid oopses on load
Date: Fri, 12 Mar 2004 12:36:55 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040312113655.GN6955@suse.de>
References: <20040312113104.GM6955@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:40132 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261764AbUCLLg5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Mar 2004 06:36:57 -0500
Content-Disposition: inline
In-Reply-To: <20040312113104.GM6955@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, mark_salyzyn@adaptec.com
Cc: markh@osdl.org, "Justin T. Gibbs" <gibbs@scsiguy.com>

On Fri, Mar 12 2004, Jens Axboe wrote:
> Hi
> 
> 2.6.3(-ish) oopses on load of aacraid:
> 
> Oops: 0002 [#1]
> CPU:    0
> EIP:    0060:[<c01d2306>]    Not tainted
> EFLAGS: 00010292
> EIP is at kobject_add+0x66/0x130
> eax: c0362840   ebx: e113a11c   ecx: e1161e98   edx: e113a138
> esi: e113a120   edi: e113a104   ebp: c0362848   esp: dd497db0
> ds: 007b   es: 007b   ss: 0068
> Process modprobe (pid: 622, threadinfo=dd496000 task=dd28c080)
> Stack: e113a11c ffffffea e113a104 00000000 c01d2459 e113a11c c03627e0
> c0216b7f
>        e113a11c e112b538 e113a0e0 00000000 e113a178 c032e258 c0217008
> 00000001
>        00000046 c03a3a00 00000001 c01db00b c032e268 00000000 c032e258
> e112855a
> Call Trace:
>  [<c01d2459>] kobject_register+0x19/0x3f
>  [<c0216b7f>] bus_add_driver+0x2f/0x80
>  [<c0217008>] driver_register+0x28/0x30
>  [<c01db00b>] pci_register_driver+0x4b/0x80
>  [<e112855a>] ahc_linux_pci_init+0xa/0x990 [aic7xxx]
>  [<e100a19c>] ahc_linux_init+0x19c/0x29b [aic7xxx]
>  [<e110f000>] ahc_patch23_func+0x0/0x10 [aic7xxx]
>  [<c012f105>] sys_init_module+0x105/0x15a0
>  [<c0121120>] __request_region+0x0/0x80
>  [<e100a000>] ahc_linux_init+0x0/0x29b [aic7xxx]
>  [<c010e5ad>] do_mmap2+0x6d/0xa0
>  [<c010e5cf>] do_mmap2+0x8f/0xa0
>  [<c010e65d>] old_mmap+0x7d/0xa0
>  [<c0108e17>] syscall_call+0x7/0xb
> 
> Code: 89 11 8b 43 28 8b 30 8d 4e 48 89 c8 ba ff ff 00 00 0f c1 10
>  <6>Red Hat/Adaptec aacraid driver (1.1.2-lk1 Mar  9 2004)

The oops is on aic7xxx of course, _not_ aacraid. Thanks Arjan for
correcting me.

-- 
Jens Axboe

