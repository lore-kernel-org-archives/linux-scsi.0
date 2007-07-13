From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [RFC 4/8] scsi-ml: scsi_sgtable implementation
Date: Fri, 13 Jul 2007 09:15:48 +0900
Message-ID: <20070712154739K.tomof@acm.org>
References: <468CDB3C.4060500@panasas.com>
	<468CF58E.1020901@panasas.com>
	<46967C78.3070100@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:45809 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756243AbXGMARF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jul 2007 20:17:05 -0400
In-Reply-To: <46967C78.3070100@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: bharrosh@panasas.com, James.Bottomley@SteelEye.com, fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org, linux-scsi@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC 4/8] scsi-ml: scsi_sgtable implementation
Date: Thu, 12 Jul 2007 14:09:44 -0500

> Boaz Harrosh wrote:
> > +/*
> > + * Should fit within a single page.
> > + */
> > +enum { SCSI_MAX_SG_SEGMENTS =
> > +	((PAGE_SIZE - sizeof(struct scsi_sgtable)) /
> > +	sizeof(struct scatterlist)) };
> > +
> > +enum { SG_MEMPOOL_NR =
> > +	(SCSI_MAX_SG_SEGMENTS >= 7) +
> > +	(SCSI_MAX_SG_SEGMENTS >= 15) +
> > +	(SCSI_MAX_SG_SEGMENTS >= 31) +
> > +	(SCSI_MAX_SG_SEGMENTS >= 63) +
> > +	(SCSI_MAX_SG_SEGMENTS >= 127) +
> > +	(SCSI_MAX_SG_SEGMENTS >= 255) +
> > +	(SCSI_MAX_SG_SEGMENTS >= 511)
> > +};
> >  
> 
> What does SCSI_MAX_SG_SEGMENTS end up being on x86 now? On x86_64 or 
> some other arch, we were going over a page when doing 
> SCSI_MAX_PHYS_SEGMENTS of 256 right?

Seems that 170 with x86 and 127 with x86_64.


> What happened to Jens's scatter list chaining and how does this relate 
> to it then?

With Jens' sglist, we can set SCSI_MAX_SG_SEGMENTS to whatever we
want. We can remove the above code.

We need to push this and Jens' sglist together in one merge window, I
think.
