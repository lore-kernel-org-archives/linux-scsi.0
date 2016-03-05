From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] cxgbit: fix dma_addr_t printk format
Date: Sat, 05 Mar 2016 01:34:43 +0100
Message-ID: <1512908.OAtrKYf46L@wuerfel>
References: <1457136294-2229829-1-git-send-email-arnd@arndb.de> <1457137507.4044.143.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.135]:60706 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760074AbcCEAfE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Mar 2016 19:35:04 -0500
In-Reply-To: <1457137507.4044.143.camel@perches.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Varun Prakash <varun@chelsio.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org

On Friday 04 March 2016 16:25:07 Joe Perches wrote:
> > 
> > diff --git a/drivers/target/iscsi/cxgbit/cxgbit_ddp.c b/drivers/target/iscsi/cxgbit/cxgbit_ddp.c
> > index 07e2bc86d0df..d667bc88e21d 100644
> > --- a/drivers/target/iscsi/cxgbit/cxgbit_ddp.c
> > +++ b/drivers/target/iscsi/cxgbit/cxgbit_ddp.c
> > @@ -179,7 +179,7 @@ cxgbit_dump_sgl(const char *cap, struct scatterlist *sgl, int nents)
> >       for_each_sg(sgl, sg, nents, i)
> >               pr_info("\t%d/%u, 0x%p: len %u, off %u, pg 0x%p, dma 0x%llx, %u\n",
> >                       i, nents, sg, sg->length, sg->offset, sg_page(sg),
> > -                     sg_dma_address(sg), sg_dma_len(sg));
> > +                     (u64)sg_dma_address(sg), sg_dma_len(sg));
> >  }
> >  
> >  static int cxgbit_ddp_sgl_check(struct scatterlist *sgl, int nents)
> 
> You could create a temporary:
> 
>         for_each_sg(sgl, sg, nents, i) {
>                 dma_addr_t addr = sg_dma_address(sg);
> 
>                 pr_info("\t%d/%u, 0x%p: len %u, off %u, pg 0x%p, dma %pad, %u\n",
>                         i, nents, sg, sg->length, sg->offset, sg_page(sg),
>                         &addr, sg_dma_len(sg));
>         }
> 

Sure, but the cast seemed nicer in this case, the result is the same.
	
	Arnd
