From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH] [SCSI] megaraid: use GFP_ATOMIC under spin lock
Date: Tue, 25 Mar 2014 15:36:38 +0000
Message-ID: <2f22e621838e429ba3979e68dde2786e@BN1PR07MB247.namprd07.prod.outlook.com>
References: <CAPgLHd82Wqz_sG9s5RPJ+ad+N73JA+_R+5kG-NQwaTYmzik2Wg@mail.gmail.com>
	 <811b9a4297a34f07be49db76acb84afb@DM2PR07MB400.namprd07.prod.outlook.com>
	 <1394706593.2192.13.camel@dabdike>
	 <b0687451148a4a9eb3258f74aa96c041@BN1PR07MB247.namprd07.prod.outlook.com>
 <1395242465.2185.5.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1blp0185.outbound.protection.outlook.com ([207.46.163.185]:10179
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753680AbaCYPvz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Mar 2014 11:51:55 -0400
In-Reply-To: <1395242465.2185.5.camel@dabdike.int.hansenpartnership.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Saxena, Sumit" <Sumit.Saxena@lsi.com>, Wei Yongjun <weiyj.lk@gmail.com>, DL-MegaRAID Linux <megaraidlinux@lsi.com>, "simon.puels@gmail.com" <simon.puels@gmail.com>, "jkosina@suse.cz" <jkosina@suse.cz>, "yongjun_wei@trendmicro.com.cn" <yongjun_wei@trendmicro.com.cn>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
> Sent: Wednesday, March 19, 2014 8:51 PM
> To: Desai, Kashyap
> Cc: Saxena, Sumit; Wei Yongjun; DL-MegaRAID Linux;
> simon.puels@gmail.com; jkosina@suse.cz;
> yongjun_wei@trendmicro.com.cn; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH] [SCSI] megaraid: use GFP_ATOMIC under spin lock
> 
> On Wed, 2014-03-19 at 07:21 +0000, Desai, Kashyap wrote:
> >
> > > -----Original Message-----
> > > From: James Bottomley
> [mailto:James.Bottomley@HansenPartnership.com]
> > > Sent: Thursday, March 13, 2014 4:00 PM
> > > To: Saxena, Sumit
> > > Cc: Wei Yongjun; DL-MegaRAID Linux; simon.puels@gmail.com;
> > > jkosina@suse.cz; yongjun_wei@trendmicro.com.cn; linux-
> > > scsi@vger.kernel.org
> > > Subject: Re: [PATCH] [SCSI] megaraid: use GFP_ATOMIC under spin lock
> > >
> > > On Wed, 2014-01-08 at 12:16 +0000, Saxena, Sumit wrote:
> > > >
> > > > >-----Original Message-----
> > > > >From: Wei Yongjun [mailto:weiyj.lk@gmail.com]
> > > > >Sent: Friday, December 20, 2013 8:38 AM
> > > > >To: DL-MegaRAID Linux; JBottomley@parallels.com;
> > > > >simon.puels@gmail.com; jkosina@suse.cz
> > > > >Cc: yongjun_wei@trendmicro.com.cn; linux-scsi@vger.kernel.org
> > > > >Subject: [PATCH] [SCSI] megaraid: use GFP_ATOMIC under spin lock
> > > > >
> > > > >From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> > > > >
> > > > >A spin lock is taken here so we should use GFP_ATOMIC.
> > > > >
> > > > >Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> > > > >---
> > > > > drivers/scsi/megaraid/megaraid_mm.c | 2 +-
> > > > > 1 file changed, 1 insertion(+), 1 deletion(-)
> > > > >
> > > > >diff --git a/drivers/scsi/megaraid/megaraid_mm.c
> > > > >b/drivers/scsi/megaraid/megaraid_mm.c
> > > > >index a706927..99fa5d3 100644
> > > > >--- a/drivers/scsi/megaraid/megaraid_mm.c
> > > > >+++ b/drivers/scsi/megaraid/megaraid_mm.c
> > > > >@@ -570,7 +570,7 @@ mraid_mm_attach_buf(mraid_mmadp_t *adp,
> > > uioc_t
> > > > >*kioc, int xferlen)
> > > > >
> > > > > 	kioc->pool_index	= right_pool;
> > > > > 	kioc->free_buf		= 1;
> > > > >-	kioc->buf_vaddr 	= pci_pool_alloc(pool->handle, GFP_KERNEL,
> > > > >+	kioc->buf_vaddr		= pci_pool_alloc(pool-
> >handle,
> > > > >GFP_ATOMIC,
> > > > > 							&kioc->buf_paddr);
> > > > > 	spin_unlock_irqrestore(&pool->lock, flags);
> > > > >
> > > > >
> > > > Acked-by: Sumit Saxena <sumit.saxena@lsi.com>
> > >
> > > This doesn't look like the right fix to me.  What is the function of
> > > pool->lock around this code region?  The only data you use from the
> > > pool->pool
> > > is pool->handle which is set up at init time ... there's no need to
> > > use a lock to read a piece of data which is effectively constant, so just
> drop the lock.
> >
> >
> > Just trying to understand why pool->lock was used here.
> >
> > Looks like this code may require synchronization using pool->lock
> > while modifying anything in kioc.
> 
> It's possible, but kioc seems to be allocated and freed per thread in the driver
> (mraid_mm_ioctl) so looks to me to require no locking once you have it
> allocated because there's a single thread of control per ioctl.
> 
> > Below code is part of "mraid_mm_dealloc_kioc".. and here also
> > pool->lock is used before accessing
> > Kioc->free_buf variable.
> >
> >                 /* This routine may be called in non-isr context also */
> >                 spin_lock_irqsave(&pool->lock, flags);
> >
> >                 /*
> >                  * While attaching the dma buffer, if we didn't get the
> >                  * required buffer from the pool, we would have allocated
> >                  * it at the run time and set the free_buf flag. We must
> >                  * free that buffer. Otherwise, just mark that the buffer is
> >                  * not in use
> >                  */
> >                 if (kioc->free_buf == 1)
> >                         pci_pool_free(pool->handle, kioc->buf_vaddr,
> >                                                         kioc->buf_paddr);
> >                 else
> >                         pool->in_use = 0;
> >
> >                 spin_unlock_irqrestore(&pool->lock, flags);
> 
> In this code, pool->lock protects variables in the pool (in this case
> ->in_use) which looks to be correct.  It's the chunk further down that
> appears to have no use for the locking.
> 
> > This code is not actively change now by LSI, so doing too much of
> > experiment may break something.
> > Considering pool->lock usage as a valid (As you suggested it may be
> > possible candidate for optimization.), do you consider including
> > change proposed in this patch ?
> 
> Well, if you make this change, kmalloc GFP_ATOMIC will fail far more than
> kmalloc GFP_KERNEL.  That failure will be passed straight back to the caller of
> the ioctl which, presumably, is your raid tool.  What will that do?  Fail or
> Retry? If it fails, removing the locking would be best, if it retries, we can
> probably do the GFP_ATOMIC hack.

James, I agree that with GFP_ATOMIC may fail frequently.

Wei, I hope your found this issue and fixed as part of the issue..  Is this possible to try what James has suggested. ?
Remove the lock pool->lock while accessing pool->handle without lock and keep GFG_KERNEL flag as it is.

May be you need to do IOCTL stress to check there is no race condition.

> 
> James
> 
> 

