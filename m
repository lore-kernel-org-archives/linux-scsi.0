From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Fw: 2.5.65 panic in remove_proc_entry() while trying to rmmod
Date: Fri, 21 Mar 2003 15:13:54 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030321231353.GA1446@beaverton.ibm.com>
References: <20030321164855.598090d7.akpm@digeo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030321164855.598090d7.akpm@digeo.com>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@digeo.com>
Cc: linux-scsi@vger.kernel.org, mochel@osdl.org

I will look into this. I was not seeing this yesterday, but I have slab
debug turned off (maybe that is why I do not see it).

FYI, There is also a regression issue in the last update of sysfs
inode.c that the sysfs links are not getting removed.  Which results in
a insmod of scsi_debug failing (I believe Greg KH is also hitting this
with some usb /i2c ). If I roll back a rev on inode.c the insmod / rmmod
work. I looked at this, but d_delete functionality is not my area and it
is slow going.

-andmike

Andrew Morton [akpm@digeo.com] wrote:
> Looks like removal on the scsi_deubg module causes some
> /proc entries to be removed twice.
> 
> 
> Begin forwarded message:
> 
> Date: Fri, 21 Mar 2003 10:36:35 -0800
> From: Badari Pulavarty <pbadari@us.ibm.com>
> To: linux-kernel@vger.kernel.org
> Cc: andrew <akpm@digeo.com>
> Subject: 2.5.65 panic in remove_proc_entry() while trying to rmmod
> 
> 
> Hi,
> 
> I get following panic while playing with scsi_debug.
> Any ideas on how to fix this ?
> 
> Thanks,
> Badari
> 
> 

> Unable to handle kernel paging request at virtual address 6b6b6b6d
>  printing eip:
> c018590a
> *pde = 00000000
> Oops: 0000 [#1]
> CPU:    4
> EIP:    0060:[<c018590a>]    Not tainted
> EFLAGS: 00010202 VLI
> EIP is at proc_match+0xa/0x30
> eax: 6b6b6b6b   ebx: 00000002   ecx: d9d61e9c   edx: 6b6b6b6b
> esi: d9d61e9c   edi: f7166e74   ebp: c03a2648   esp: d9d61e60
> ds: 007b   es: 007b   ss: 0068
> Process rmmod (pid: 10547, threadinfo=d9d60000 task=d9ade0a0)
> Stack: d9d61e9c f7166e74 c018679e 00000002 d9d61e9c 6b6b6b6b d9d61e9c f440a084
>        f440a084 c0295efa d9d61e9c f7166e44 d9d61e9c c03a23cc 0000001a d9003632
>        f440a084 c03a2648 c01081cc f440a084 f44259c4 c028f733 f440a084 00000000
> Call Trace:
>  [<c018679e>] remove_proc_entry+0x5e/0x110
>  [<c0295efa>] scsi_proc_host_rm+0x2a/0x50
>  [<c01081cc>] __up_wakeup+0x8/0xc
>  [<c028f733>] scsi_unregister+0x103/0x120
>  [<f8966929>] sdebug_driver_remove+0x119/0x160 [scsi_debug]
>  [<f8969440>] sdebug_driverfs_driver+0x0/0x74 [scsi_debug]
>  [<f8969440>] sdebug_driverfs_driver+0x0/0x74 [scsi_debug]
>  [<c0254134>] device_release_driver+0x44/0x50
>  [<f8969498>] sdebug_driverfs_driver+0x58/0x74 [scsi_debug]
>  [<c0254169>] driver_detach+0x29/0x40
>  [<f8969660>] pseudo_lld_bus+0x40/0xe0 [scsi_debug]
>  [<f8969620>] pseudo_lld_bus+0x0/0xe0 [scsi_debug]
>  [<c02543e8>] bus_remove_driver+0x38/0x80
>  [<f8969440>] sdebug_driverfs_driver+0x0/0x74 [scsi_debug]
>  [<f896944c>] sdebug_driverfs_driver+0xc/0x74 [scsi_debug]
>  [<f8969440>] sdebug_driverfs_driver+0x0/0x74 [scsi_debug]
>  [<c025479f>] driver_unregister+0xf/0x33
>  [<f8969440>] sdebug_driverfs_driver+0x0/0x74 [scsi_debug]
>  [<f8969700>] +0x0/0x4e0 [scsi_debug]
>  [<f896651a>] scsi_debug_unregister_driver+0xa/0x10 [scsi_debug]
>  [<f8969440>] sdebug_driverfs_driver+0x0/0x74 [scsi_debug]
>  [<f8966984>] +0x14/0x40 [scsi_debug]
>  [<f8969440>] sdebug_driverfs_driver+0x0/0x74 [scsi_debug]
>  [<c013517f>] sys_delete_module+0x1ff/0x230
>  [<c0148f8b>] do_munmap+0x17b/0x190
>  [<c0148fe4>] sys_munmap+0x44/0x70
>  [<c0109303>] syscall_call+0x7/0xb
> 
> Code: 63 08 00 59 e9 8a e6 ff ff 66 4a 0f 85 1b e7 ff ff 51 e8 9a 64 08 00 59 e9 0f e7 ff ff 8d 74 26 00 57 56 8b
> 
> 

-andmike
--
Michael Anderson
andmike@us.ibm.com

