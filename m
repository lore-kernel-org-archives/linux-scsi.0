From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] fix for missing proc dir in megaraid driver.
Date: Wed, 18 Feb 2004 08:08:16 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040218080816.A20630@beaverton.ibm.com>
References: <1077058085.1897.4.camel@morsel.kungfoocoder.org> <20040217231541.GG11824@parcelfarce.linux.theplanet.co.uk> <B9FA5EC5-61E6-11D8-B07A-000A95CD704C@wagland.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:3505 "EHLO e35.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S264479AbUBRQJx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Feb 2004 11:09:53 -0500
Content-Disposition: inline
In-Reply-To: <B9FA5EC5-61E6-11D8-B07A-000A95CD704C@wagland.net>; from paul@wagland.net on Wed, Feb 18, 2004 at 08:47:39AM +0100
List-Id: linux-scsi@vger.kernel.org
To: Paul Wagland <paul@wagland.net>
Cc: Matthew Wilcox <willy@debian.org>, Linux SCSI mailing list <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

On Wed, Feb 18, 2004 at 08:47:39AM +0100, Paul Wagland wrote:

> OK, I can resubmit with those #ifdefs in megaraid_init removed, though 
> this does raise the size of the module in that case by a small amount, 
> and also means that even though the kernel is configured as being a 
> non-procfs kernel, the megaraid module will still complain that it 
> cannot "create megaraid root". Hmm. Looking at this, this error message 
> is not overly intuitive anyway :-), but when procfs is not even 
> configured this could easily be mistaken for something quite serious.
> 
> If you would like a re-submit with the CONFIG_PROC_FS removed, then 
> just let me know.

Hmmmm ...

A separate issue, but I can't even boot if I enable CONFIG_SCSI_PROC_FS
but disable CONFIG_PROC_FS. We need to tie the two together.

I get this error hidden away in the dmesg:

SCSI subsystem failed to initialize, error = 12

And this badness and oops in init_this_scsi_driver:

Badness in kobject_get at lib/kobject.c:431
Call Trace:
 [<c01996e2>] kobject_get+0x2e/0x3c
 [<c01bfdfe>] class_get+0x16/0x34
 [<c01c00ce>] class_device_add+0x4a/0x140
 [<c01bea45>] get_device+0x11/0x20
 [<c01dd850>] scsi_add_host+0xb4/0x100
 [<c0356a9a>] init_this_scsi_driver+0x7a/0xe0
 [<c03447ad>] do_initcalls+0x3d/0x8c
 [<c0344815>] do_basic_setup+0x19/0x1a
 [<c01050cc>] init+0x44/0x148
 [<c0105088>] init+0x0/0x148
 [<c0106ed1>] kernel_thread_helper+0x5/0xc

Unable to handle kernel NULL pointer dereference at virtual address
0000000c
 printing eip:
c017384f
*pde = 00104001
Oops: 0000 [#1]
CPU:    0
EIP:    0060:[<c017384f>]    Not tainted
EFLAGS: 00010286
EIP is at create_dir+0xf/0x88
eax: f4b86964   ebx: f4b86960   ecx: c03087c8   edx: f4b86964
esi: c3d7ff54   edi: 00000000   ebp: f4b868c0   esp: c3d7ff30
ds: 007b   es: 007b   ss: 0068
Process swapper (pid: 1, threadinfo=c3d7e000 task=f519f900)
Stack: f4b86960 f4b86960 c0308780 c017393f f4b86960 00000000 f4b86964
c3d7ff54 
       00000000 00000000 c01990c3 f4b86960 f4b86960 c030a914 c0199519
f4b86960 
       f4b86960 c030a900 c030a914 c01c00f8 f4b86960 f4b86958 00000000
f4b86800 
Call Trace:
 [<c017393f>] sysfs_create_dir+0x5b/0x70
 [<c01990c3>] create_dir+0x13/0x3c
 [<c0199519>] kobject_add+0xa9/0xe4
 [<c01c00f8>] class_device_add+0x74/0x140
 [<c01bea45>] get_device+0x11/0x20
 [<c01dd850>] scsi_add_host+0xb4/0x100
 [<c0356a9a>] init_this_scsi_driver+0x7a/0xe0
 [<c03447ad>] do_initcalls+0x3d/0x8c
 [<c0344815>] do_basic_setup+0x19/0x1a
 [<c01050cc>] init+0x44/0x148
 [<c0105088>] init+0x0/0x148
 [<c0106ed1>] kernel_thread_helper+0x5/0xc

Code: 8b 47 0c 8d 48 6c f0 ff 48 6c 0f 88 ce 02 00 00 52 57 e8 9a 
 <0>Kernel panic: Attempted to kill init!

-- Patrick Mansfield
