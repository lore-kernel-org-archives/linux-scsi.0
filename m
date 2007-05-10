From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH v2] add bidi support for block pc requests
Date: Thu, 10 May 2007 22:01:17 +0900
Message-ID: <20070510220117I.fujita.tomonori@lab.ntt.co.jp>
References: <20070510155322R.fujita.tomonori@lab.ntt.co.jp>
	<20070510164535F.fujita.tomonori@lab.ntt.co.jp>
	<4643121C.600@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:62338 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234AbXEJNCU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 May 2007 09:02:20 -0400
In-Reply-To: <4643121C.600@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com, bharrosh@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, bhalevy@panasas.com, hch@infradead.org, akpm@linux-foundation.org, michaelc@cs.wisc.edu

From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH v2] add bidi support for block pc requests
Date: Thu, 10 May 2007 15:37:48 +0300

> > +/* moved to scatterlist.h after chaining sg */
> > +#define sg_next(sg) ((sg) + 1)
> > +
> > +#define scsi_for_each_sg(cmd, nseg, i)					\
> > +	for (i = 0, sg = (cmd)->request_buffer; i < nseg;		\
> > +		sg = sg_next(sg), i++)					\
> > +
> 
> Better we do like Jens's patch
> +#define for_each_sg(sglist, sg, nr, __i)	\
> +	for (__i = 0, sg = (sglist); __i < (nr); __i++, sg = sg_next(sg))
> 
> I think that we should wait for Jens pending patchset and do this work on top
> of his, then use his sg macros directly. This way the cleaners can also be
> watchfully for any drivers that might brake with big IO sent to them.

Yeah, we can use sg list's macro something like:

#define scsi_for_each_sg(cmd, sg, nseg, __i)			\
	for_each_sg((cmd)->request_buffer, sg, nseg, __i)	

Seems that Jens converted lots of LLDs to use for_each_sg. If
for_each_sg goes first, we can just replase for_each_sg (but after
all, we need to touch LLDs to remove the non-use-sg path). On the
other hand, if we go first, there is no conversion for for_each_sg in
LLDs.

Jens, do you want the sg list stuff done before our cleanups?
