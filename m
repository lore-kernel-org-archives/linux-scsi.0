From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 0/5] sg_ring for scsi
Date: Fri, 21 Dec 2007 11:28:34 +0900
Message-ID: <20071221112834X.fujita.tomonori@lab.ntt.co.jp>
References: <200712201853.48643.rusty@rustcorp.com.au>
	<20071219.235807.173273479.davem@davemloft.net>
	<200712211013.38511.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama555.ecl.ntt.co.jp ([129.60.39.106]:34392 "EHLO
	tama555.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbXLUC3I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Dec 2007 21:29:08 -0500
In-Reply-To: <200712211013.38511.rusty@rustcorp.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rusty@rustcorp.com.au
Cc: davem@davemloft.net, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jens.axboe@oracle.com, dougg@torque.net

On Fri, 21 Dec 2007 10:13:38 +1100
Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Thursday 20 December 2007 18:58:07 David Miller wrote:
> > From: Rusty Russell <rusty@rustcorp.com.au>
> > Date: Thu, 20 Dec 2007 18:53:48 +1100
> >
> > > Manipulating the magic chains is horrible; it looks simple to the
> > > places which simply want to iterate through it, but it's awful for
> > > code which wants to create them.
> >
> > I'm not saying complexity is inherent in this stuff, but
> > assuming that it is the complexity should live as far away
> > from the minions (the iterators in this case).  Therefore,
> > the creators is the right spot for the hard stuff.
> 
> In this case, the main benefit of the sg chaining was that the conversion of 
> most scsi drivers was easy (basically sg++ -> sg = sg_next(sg)).  The 
> conversion to sg_ring is more complex, but the end result is not 
> significantly more complex.
> 
> However, the cost to code which manipulates sg chains was significant: I tried 
> using them in virtio and it was too ugly to live (so that doesn't support sg 
> chaining).  If this was the best we could do, that'd be fine.
> 
> But, as demonstrated, there are real benefits of having an explicit header:

I'm not sure about chaining the headers (as your sg_ring and
scsi_sgtable do) would simplify LLDs. Have you looked at ips or
qla1280?
