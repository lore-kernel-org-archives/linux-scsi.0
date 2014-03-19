From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH] [SCSI] megaraid: use GFP_ATOMIC under spin lock
Date: Wed, 19 Mar 2014 07:21:17 +0000
Message-ID: <b0687451148a4a9eb3258f74aa96c041@BN1PR07MB247.namprd07.prod.outlook.com>
References: <CAPgLHd82Wqz_sG9s5RPJ+ad+N73JA+_R+5kG-NQwaTYmzik2Wg@mail.gmail.com>
	 <811b9a4297a34f07be49db76acb84afb@DM2PR07MB400.namprd07.prod.outlook.com>
 <1394706593.2192.13.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2lp0209.outbound.protection.outlook.com ([207.46.163.209]:44701
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756803AbaCSHVj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Mar 2014 03:21:39 -0400
In-Reply-To: <1394706593.2192.13.camel@dabdike>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, "Saxena, Sumit" <Sumit.Saxena@lsi.com>
Cc: Wei Yongjun <weiyj.lk@gmail.com>, DL-MegaRAID Linux <megaraidlinux@lsi.com>, "simon.puels@gmail.com" <simon.puels@gmail.com>, "jkosina@suse.cz" <jkosina@suse.cz>, "yongjun_wei@trendmicro.com.cn" <yongjun_wei@trendmicro.com.cn>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
> Sent: Thursday, March 13, 2014 4:00 PM
> To: Saxena, Sumit
> Cc: Wei Yongjun; DL-MegaRAID Linux; simon.puels@gmail.com;
> jkosina@suse.cz; yongjun_wei@trendmicro.com.cn; linux-
> scsi@vger.kernel.org
> Subject: Re: [PATCH] [SCSI] megaraid: use GFP_ATOMIC under spin lock
> 
> On Wed, 2014-01-08 at 12:16 +0000, Saxena, Sumit wrote:
> >
> > >-----Original Message-----
> > >From: Wei Yongjun [mailto:weiyj.lk@gmail.com]
> > >Sent: Friday, December 20, 2013 8:38 AM
> > >To: DL-MegaRAID Linux; JBottomley@parallels.com;
> > >simon.puels@gmail.com; jkosina@suse.cz
> > >Cc: yongjun_wei@trendmicro.com.cn; linux-scsi@vger.kernel.org
> > >Subject: [PATCH] [SCSI] megaraid: use GFP_ATOMIC under spin lock
> > >
> > >From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> > >
> > >A spin lock is taken here so we should use GFP_ATOMIC.
> > >
> > >Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> > >---
> > > drivers/scsi/megaraid/megaraid_mm.c | 2 +-
> > > 1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > >diff --git a/drivers/scsi/megaraid/megaraid_mm.c
> > >b/drivers/scsi/megaraid/megaraid_mm.c
> > >index a706927..99fa5d3 100644
> > >--- a/drivers/scsi/megaraid/megaraid_mm.c
> > >+++ b/drivers/scsi/megaraid/megaraid_mm.c
> > >@@ -570,7 +570,7 @@ mraid_mm_attach_buf(mraid_mmadp_t *adp,
> uioc_t
> > >*kioc, int xferlen)
> > >
> > > 	kioc->pool_index	= right_pool;
> > > 	kioc->free_buf		= 1;
> > >-	kioc->buf_vaddr 	= pci_pool_alloc(pool->handle, GFP_KERNEL,
> > >+	kioc->buf_vaddr		= pci_pool_alloc(pool->handle,
> > >GFP_ATOMIC,
> > > 							&kioc->buf_paddr);
> > > 	spin_unlock_irqrestore(&pool->lock, flags);
> > >
> > >
> > Acked-by: Sumit Saxena <sumit.saxena@lsi.com>
> 
> This doesn't look like the right fix to me.  What is the function of
> pool->lock around this code region?  The only data you use from the pool
> is pool->handle which is set up at init time ... there's no need to use a lock to
> read a piece of data which is effectively constant, so just drop the lock.


Just trying to understand why pool->lock was used here.

Looks like this code may require synchronization using pool->lock while modifying anything in kioc.

Below code is part of "mraid_mm_dealloc_kioc".. and here also pool->lock is used before accessing 
Kioc->free_buf variable.

                /* This routine may be called in non-isr context also */
                spin_lock_irqsave(&pool->lock, flags);
 
                /*
                 * While attaching the dma buffer, if we didn't get the 
                 * required buffer from the pool, we would have allocated 
                 * it at the run time and set the free_buf flag. We must 
                 * free that buffer. Otherwise, just mark that the buffer is 
                 * not in use
                 */
                if (kioc->free_buf == 1)
                        pci_pool_free(pool->handle, kioc->buf_vaddr,
                                                        kioc->buf_paddr);
                else
                        pool->in_use = 0;
 
                spin_unlock_irqrestore(&pool->lock, flags); 

This code is not actively change now by LSI, so doing too much of experiment may break something.
Considering pool->lock usage as a valid (As you suggested it may be possible candidate for optimization.), 
do you consider including change proposed in this patch ?

` Kashyap

> 
> James
> 
> 

