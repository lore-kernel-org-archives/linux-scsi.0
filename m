From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] [SCSI] megaraid: use GFP_ATOMIC under spin lock
Date: Thu, 13 Mar 2014 14:29:53 +0400
Message-ID: <1394706593.2192.13.camel@dabdike>
References: <CAPgLHd82Wqz_sG9s5RPJ+ad+N73JA+_R+5kG-NQwaTYmzik2Wg@mail.gmail.com>
	 <811b9a4297a34f07be49db76acb84afb@DM2PR07MB400.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:43108 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753264AbaCMOSF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Mar 2014 10:18:05 -0400
In-Reply-To: <811b9a4297a34f07be49db76acb84afb@DM2PR07MB400.namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Saxena, Sumit" <Sumit.Saxena@lsi.com>
Cc: Wei Yongjun <weiyj.lk@gmail.com>, DL-MegaRAID Linux <megaraidlinux@lsi.com>, "simon.puels@gmail.com" <simon.puels@gmail.com>, "jkosina@suse.cz" <jkosina@suse.cz>, "yongjun_wei@trendmicro.com.cn" <yongjun_wei@trendmicro.com.cn>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, 2014-01-08 at 12:16 +0000, Saxena, Sumit wrote:
> 
> >-----Original Message-----
> >From: Wei Yongjun [mailto:weiyj.lk@gmail.com]
> >Sent: Friday, December 20, 2013 8:38 AM
> >To: DL-MegaRAID Linux; JBottomley@parallels.com; simon.puels@gmail.com;
> >jkosina@suse.cz
> >Cc: yongjun_wei@trendmicro.com.cn; linux-scsi@vger.kernel.org
> >Subject: [PATCH] [SCSI] megaraid: use GFP_ATOMIC under spin lock
> >
> >From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> >
> >A spin lock is taken here so we should use GFP_ATOMIC.
> >
> >Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> >---
> > drivers/scsi/megaraid/megaraid_mm.c | 2 +-
> > 1 file changed, 1 insertion(+), 1 deletion(-)
> >
> >diff --git a/drivers/scsi/megaraid/megaraid_mm.c
> >b/drivers/scsi/megaraid/megaraid_mm.c
> >index a706927..99fa5d3 100644
> >--- a/drivers/scsi/megaraid/megaraid_mm.c
> >+++ b/drivers/scsi/megaraid/megaraid_mm.c
> >@@ -570,7 +570,7 @@ mraid_mm_attach_buf(mraid_mmadp_t *adp, uioc_t
> >*kioc, int xferlen)
> >
> > 	kioc->pool_index	= right_pool;
> > 	kioc->free_buf		= 1;
> >-	kioc->buf_vaddr 	= pci_pool_alloc(pool->handle, GFP_KERNEL,
> >+	kioc->buf_vaddr		= pci_pool_alloc(pool->handle,
> >GFP_ATOMIC,
> > 							&kioc->buf_paddr);
> > 	spin_unlock_irqrestore(&pool->lock, flags);
> >
> >
> Acked-by: Sumit Saxena <sumit.saxena@lsi.com>

This doesn't look like the right fix to me.  What is the function of
pool->lock around this code region?  The only data you use from the pool
is pool->handle which is set up at init time ... there's no need to use
a lock to read a piece of data which is effectively constant, so just
drop the lock.

James


