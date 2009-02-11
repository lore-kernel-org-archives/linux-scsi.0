From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 2/3] block: unexport blk_rq_append_bio
Date: Wed, 11 Feb 2009 09:21:02 +0900
Message-ID: <20090211092109Y.fujita.tomonori@lab.ntt.co.jp>
References: <1229185427-4130-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1234287784.3268.31.camel@localhost.localdomain>
	<1234289973.3268.37.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:36410 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754251AbZBKAV0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Feb 2009 19:21:26 -0500
In-Reply-To: <1234289973.3268.37.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, bharrosh@panasas.com

On Tue, 10 Feb 2009 18:19:33 +0000
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Tue, 2009-02-10 at 17:43 +0000, James Bottomley wrote:
> > There's a current barrier to this: osd_initiator has also become a
> > consumer of blk_rq_append_bio().
> > 
> > It seems to be emulating block internals, so I think the fix is twofold:
> > 
> >      1. adjust blk_rq_map_kern to call blk_rq_append_bio() instead of
> >         blk_rq_prep_bio() (with an extra failure path).
> >      2. make osd_initiator simply call it for additions.
> > 
> > I can code up a patch to see if it works.
> 
> So this is the patch to allow blk_rq_map_kern to append to requests,
> which is what I think is needed.
> 
> Unfortunately unwinding osd_initator's bio dependence and putting it
> back on data buffers looks to be a bit of a longer chore.

Looks like the osd initiator code uses bio nicely; e.g. using
blk_rq_append_bio and bio_map_kern is completely wrong. I'll see the
code to fix it...
