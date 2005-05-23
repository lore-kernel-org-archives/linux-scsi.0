From: Timur Tabi <timur.tabi@ammasso.com>
Subject: Re: kernel BUG at pageattr:107
Date: Mon, 23 May 2005 15:52:08 -0500
Message-ID: <42924278.9010501@ammasso.com>
References: <d3a6bba005052313382d7a81a4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rrcs-24-227-247-8.sw.biz.rr.com ([24.227.247.8]:27577 "EHLO
	emachine.austin.ammasso.com") by vger.kernel.org with ESMTP
	id S261969AbVEWUwQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 May 2005 16:52:16 -0400
In-Reply-To: <d3a6bba005052313382d7a81a4@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anil Kumar <anilsr@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

This was fixed a few days ago in a recent patch, titled:

x86_64: Don't look up struct page pointer of physical address in iounmap

It's only a one-line change:

tree b5d1e3e603823d798b77a91641f63f10a0a733b1
parent 1f5ee8da005f50d9f46ae5a7edba9a9c2d37b32e
author Andi Kleen <ak@suse.de> Tue, 17 May 2005 11:53:24 -0700
committer Linus Torvalds <torvalds@ppc970.osdl.org> Tue, 17 May 2005 21:59:14 -0700

[PATCH] x86_64: Don't look up struct page pointer of physical address in iounmap

It could be in a memory hole not mapped in mem_map and that causes the hash
lookup to go off to nirvana.

Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
Signed-off-by: Linus Torvalds <torvalds@osdl.org>

  arch/x86_64/mm/ioremap.c |    2 +-
  1 files changed, 1 insertion(+), 1 deletion(-)

Index: arch/x86_64/mm/ioremap.c
===================================================================
--- 4abd4f432bd1d8def0992ee55bb00a0d556122d3/arch/x86_64/mm/ioremap.c  (mode:100644 
sha1:74ec8554b195de6c5a9b87ce5d39f08d9c5da544)
+++ b5d1e3e603823d798b77a91641f63f10a0a733b1/arch/x86_64/mm/ioremap.c  (mode:100644 
sha1:c6fb0cb69992bbf14a2f42d4ddde10b298cd9316)
@@ -272,7 +272,7 @@ void iounmap(volatile void __iomem *addr
  	if ((p->flags >> 20) &&
  		p->phys_addr + p->size - 1 < virt_to_phys(high_memory)) {
  		/* p->size includes the guard page, but cpa doesn't like that */
-		change_page_attr(virt_to_page(__va(p->phys_addr)),
+		change_page_attr_addr((unsigned long)__va(p->phys_addr),
  				 p->size >> PAGE_SHIFT,
  				 PAGE_KERNEL);
  		global_flush_tlb();

Anil Kumar wrote:
> Hi,
> 
> I am getting the following error message as part of stack trace. 
> I have a system with > 4G mem with RHEL4 x86_64. I installed the OS
> and when I did the reboot, the system failed with a stack trace with
> errors as follows:
> 
> Intializing hardware.....
> kernel BUG at pageattr:107
> Invalid operand:0000 [1] SMP
> Modules linked in: hw_random tg3 floppy sd_mod aic79xx(U) scsi_mod
> dm_snapshot dm_zero dm_mirror ext3 jbd dm_mod
> pid: 1217,comm:modprobe....
> ..............
> ................
> ...............
> RIP ...{__change_page_attr+1039}
> /etc/rc.d/rc.sysinit: line 167: 1217 Segmentation fault modprobe $1
> 
>>/dev/null 2>&1
> 
> 
> I wanted to know if aic79xx driver is having some problems or is it
> kernel/scsi subsystem. I don't see the stack trace pointing to aic79xx
> driver at all.
> 
> Also, the above issue is only for > 4G mem.
> 
> Thanks in advance for the help.
> 
> with regards,
>    Anil
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Timur Tabi
Staff Software Engineer
timur.tabi@ammasso.com

One thing a Southern boy will never say is,
"I don't think duct tape will fix it."
      -- Ed Smylie, NASA engineer for Apollo 13
