From: Andrew Morton <akpm@osdl.org>
Subject: Fw: 2.6.6-rc3 ia64 smp_call_function() called with interrupts
 disabled
Date: Sun, 2 May 2004 21:45:25 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040502214525.5ad05bed.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:46489 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S263584AbUECEpm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 May 2004 00:45:42 -0400
Received: from bix (build.pdx.osdl.net [172.20.1.2])
	by mail.osdl.org (8.11.6/8.11.6) with ESMTP id i434jf218816
	for <linux-scsi@vger.kernel.org>; Sun, 2 May 2004 21:45:41 -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org



Begin forwarded message:

Date: Mon, 03 May 2004 12:39:44 +1000
From: Keith Owens <kaos@sgi.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.6-rc3 ia64 smp_call_function() called with interrupts disabled


2.6.6-rc3, modprobe sg calls vfree() with interrupts disabled.  On
ia64, vfree calls smp_flush_tlb_all() which calls smp_call_function().
Calling smp_call_function() with interrupts disabled can deadlock.

Badness in smp_call_function at arch/ia64/kernel/smp.c:312

Call Trace:
 [<a0000001000190a0>] show_stack+0x80/0xa0
                                sp=e00001307811fc40 bsp=e0000130781191c0
 [<a000000100058a50>] smp_call_function+0x3d0/0x3e0
                                sp=e00001307811fe10 bsp=e000013078119160
 [<a000000100057e60>] smp_flush_tlb_all+0x40/0x80
                                sp=e00001307811fe30 bsp=e000013078119140
 [<a000000100142850>] unmap_vm_area+0xf0/0x120
                                sp=e00001307811fe30 bsp=e000013078119108
 [<a000000100142ed0>] remove_vm_area+0x150/0x1e0
                                sp=e00001307811fe30 bsp=e0000130781190e0
 [<a000000100142fb0>] __vunmap+0x50/0x1e0
                                sp=e00001307811fe30 bsp=e0000130781190a0
 [<a0000002002ae4d0>] sg_add+0x2d0/0xbe0 [sg]
                                sp=e00001307811fe30 bsp=e000013078119038
 [<a00000010047da40>] class_interface_register+0x1e0/0x2a0
                                sp=e00001307811fe30 bsp=e000013078119000
 [<a0000001005371b0>] scsi_register_interface+0x30/0x60
                                sp=e00001307811fe30 bsp=e000013078118fe0
 [<a0000002002d0200>] init_sg+0x140/0x190 [sg]
                                sp=e00001307811fe30 bsp=e000013078118fb8
 [<a000000100104b40>] sys_init_module+0x3c0/0x660
                                sp=e00001307811fe30 bsp=e000013078118f48
 [<a000000100011be0>] ia64_ret_from_syscall+0x0/0x20
                                sp=e00001307811fe30 bsp=e000013078118f40


-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
