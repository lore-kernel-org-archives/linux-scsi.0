From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] sym53c8xx_2: Avoid calling __sym_mfree with irqs
 disabled
Date: Thu, 25 Mar 2010 11:21:17 -0600
Message-ID: <1269537678.9182.8.camel@mulgrave.site>
References: <1269536751-2463-1-git-send-email-stefan.bader@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43536 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396Ab0CYRVY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Mar 2010 13:21:24 -0400
In-Reply-To: <1269536751-2463-1-git-send-email-stefan.bader@canonical.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Bader <stefan.bader@canonical.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

On Thu, 2010-03-25 at 18:05 +0100, Stefan Bader wrote:
> The following patch was tested and seemed to avoid the warning. Howver
> I am not completely sure that none of the later functions need to be
> protected with spinlocks. Though it feels ok. But maybe someone can do
> some sanity checking.

So, I'm afraid you're right, the patch as is won't work ... the problem
is that __sym_mfree_dma does list manipulation and for safety that has
to be under a lock.

The inception of this problem is that ARM needs a sleeping function on
DMA free but nothing else does so, on every platform that sym2 is
supported, this warning is bogus.

One way of getting rid of it might be to undef SYM_MEM_FREE_UNUSED which
will prevent the free routines actually from releasing memory ...
another might be to drop the lock and reacquire it around the free ...
but that's sitting in a list traversal function so it may expose us to
list races again, so really the whole of the freeing routines would have
to be re-written to be list safe under lock ...

James

> Thanks,
> Stefan
> 
> From d8c94332b8c7422c9c3e20d236f7ba6f59170408 Mon Sep 17 00:00:00 2001
> From: Stefan Bader <stefan.bader@canonical.com>
> Date: Wed, 24 Mar 2010 17:06:05 +0000
> Subject: [PATCH] sym53c8xx_2: Avoid calling __sym_mfree with irqs disabled
> 
> BugLink: http://bugs.launchpad.net/bugs/458201
> 
> Testing disk hotswap in kvm produced the following warning when removing
> an inactive drive from the vm. Looking at the code it is __sym_mfree_dma,
> that disables irqs and then calls __sym_mfree which at some point ends up
> at code which checks for irqs disabled.
> 
> WARNING: at /build/buildd/linux-2.6.32/arch/x86/include/asm/dma-mapping.h:154 ___free_dma_mem_cluster+0x102/0x110()
> Hardware name: Bochs
> Pid: 17, comm: kacpi_notify Not tainted 2.6.32-16-server #25-Ubuntu
> Call Trace:
>  [<ffffffff81064f9b>] warn_slowpath_common+0x7b/0xc0
>  [<ffffffff81064ff4>] warn_slowpath_null+0x14/0x20
>  [<ffffffff8139a2a2>] ___free_dma_mem_cluster+0x102/0x110
>  [<ffffffff8139a072>] __sym_mfree+0xd2/0x100
>  [<ffffffff8139a109>] __sym_mfree_dma+0x69/0x100
>  [<ffffffff8139245f>] sym_hcb_free+0x8f/0x1f0
>  [<ffffffff8138fa96>] sym_free_resources+0x46/0x90
>  [<ffffffff8138fb93>] sym_detach+0xb3/0xe0
>  [<ffffffff8138fbfb>] sym2_remove+0x3b/0x60
> 
> Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
> CC: stable@kernel.org
> ---
>  drivers/scsi/sym53c8xx_2/sym_malloc.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/sym53c8xx_2/sym_malloc.c b/drivers/scsi/sym53c8xx_2/sym_malloc.c
> index 883cac1..006a079 100644
> --- a/drivers/scsi/sym53c8xx_2/sym_malloc.c
> +++ b/drivers/scsi/sym53c8xx_2/sym_malloc.c
> @@ -339,15 +339,14 @@ void __sym_mfree_dma(m_pool_ident_t dev_dmat, void *m, int size, char *name)
>  
>  	spin_lock_irqsave(&sym53c8xx_lock, flags);
>  	mp = ___get_dma_pool(dev_dmat);
> +	spin_unlock_irqrestore(&sym53c8xx_lock, flags);
>  	if (!mp)
> -		goto out;
> +		return;
>  	__sym_mfree(mp, m, size, name);
>  #ifdef	SYM_MEM_FREE_UNUSED
>  	if (!mp->nump)
>  		___del_dma_pool(mp);
>  #endif
> - out:
> -	spin_unlock_irqrestore(&sym53c8xx_lock, flags);
>  }
>  
>  /*


