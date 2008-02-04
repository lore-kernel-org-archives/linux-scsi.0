From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 9880] dma_free_coherent in arcmsr when calling areca tools
Date: Sun,  3 Feb 2008 19:55:54 -0800 (PST)
Message-ID: <20080204035554.7CCE7108017@picon.linux-foundation.org>
References: <bug-9880-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53114 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755671AbYBDD4Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Feb 2008 22:56:24 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [207.189.120.79])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id m143tsjh018024
	for <linux-scsi@vger.kernel.org>; Sun, 3 Feb 2008 19:55:55 -0800
In-Reply-To: <bug-9880-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=9880





------- Comment #1 from anonymous@kernel-bugs.osdl.org  2008-02-03 19:55 -------
Reply-To: James.Bottomley@HansenPartnership.com


On Sun, 2008-02-03 at 19:00 -0800, bugme-daemon@bugzilla.kernel.org
wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=9880


> Latest working kernel version: 2.6.23.12
> Earliest failing kernel version: 2.6.24
> Distribution: Gentoo
> Hardware Environment: 
> Intel Core2Quad, 2GB Memory, Areca 1220ML
> 
> Software Environment: 
> Areca CLI, Version: 1.72.250, Date: Apr 11 2007( Linux )
> Areca HTTP proxy server V1.81.250 for Areca RAID controllers.
> 
> Problem Description:
> 
> Feb  2 02:04:01 mrb WARNING: at arch/x86/kernel/pci-dma_64.c:169
> dma_free_coherent()
> Feb  2 02:04:01 mrb Pid: 16080, comm: archttp64 Not tainted
> 2.6.24 #1
> Feb  2 02:04:01 mrb
> Feb  2 02:04:01 mrb Call Trace:
> Feb  2 02:04:01 mrb [<ffffffff80213568>] dma_free_coherent+0x43/0x82
> Feb  2 02:04:01 mrb [<ffffffff88178b85>] :arcmsr:arcmsr_queue_command
> +0x379/0x973
> Feb  2 02:04:01 mrb [<ffffffff8053d8c2>] _spin_unlock_irqrestore
> +0x16/0x31
> Feb  2 02:04:01 mrb [<ffffffff8043cce3>] scsi_dispatch_cmd+0x194/0x1e9
> Feb  2 02:04:01 mrb [<ffffffff80441bab>] scsi_request_fn+0x28b/0x360
> Feb  2 02:04:01 mrb [<ffffffff80387726>] blk_execute_rq_nowait+0x7a/0x8b
> Feb  2 02:04:01 mrb [<ffffffff80441698>] scsi_execute_async+0x33d/0x36e
> Feb  2 02:04:01 mrb [<ffffffff88159379>] :sg:sg_common_write+0x66f/0x6a3
> Feb  2 02:04:01 mrb [<ffffffff881595c0>] :sg:sg_cmd_done+0x0/0x1fe
> Feb  2 02:04:01 mrb [<ffffffff8053d97f>] _write_unlock_irqrestore
> +0x17/0x34
> Feb  2 02:04:01 mrb [<ffffffff8815959d>] :sg:sg_new_write+0x1f0/0x213
> Feb  2 02:04:01 mrb [<ffffffff8815ab47>] :sg:sg_ioctl+0x1f3/0x9f5
> Feb  2 02:04:01 mrb [<ffffffff8024d1c0>] hrtimer_try_to_cancel+0x5f/0x68
> Feb  2 02:04:01 mrb [<ffffffff8024d1d5>] hrtimer_cancel+0xc/0x16
> Feb  2 02:04:01 mrb [<ffffffff8053c62a>] do_nanosleep+0x55/0x7e
> Feb  2 02:04:01 mrb [<ffffffff8029ae2d>] do_ioctl+0x55/0x6b
> Feb  2 02:04:01 mrb [<ffffffff8029b076>] vfs_ioctl+0x233/0x24c
> Feb  2 02:04:01 mrb [<ffffffff8029b0e0>] sys_ioctl+0x51/0x71
> Feb  2 02:04:01 mrb [<ffffffff8020bfae>] system_call+0x7e/0x83
> 
> Steps to reproduce:
> 
> If the httpd deamon runs the message occurs endless.
> The areca cli command produces the message for each call.
> 
> The problem occurs after upgrading to kernel 2.6.24 kernel 2.6.23.12 and before
> works well.

This is here, isn't it:

void dma_free_coherent(struct device *dev, size_t size,
                         void *vaddr, dma_addr_t bus)
{
        WARN_ON(irqs_disabled());       /* for portability */
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
        if (dma_ops->unmap_single)
                dma_ops->unmap_single(dev, bus, size, 0);
        free_pages((unsigned long)vaddr, get_order(size));
}

That's caused by this commit:

commit aa24886e379d2b641c5117e178b15ce1d5d366ba
Author: David Brownell <david-b@pacbell.net>
Date:   Fri Aug 10 13:10:27 2007 -0700

    dma_free_coherent() needs irqs enabled (sigh)

I've cc'd the people responsible for this apparent bit of idiocy.  Since
the API addition to dma_alloc_coherent() was the GFP flags so you could
call it from interrupt context with GFP_ATOMIC if so desired,
(pci_dma_alloc_consistent always has GFP_ATOMIC semantics), why on earth
would the corresponding free routine require non-atomic semantics?

Is it seriously true that you can call dma_alloc_coherent() from atomic
context on arm, but not dma_free_coherent()?

James


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
