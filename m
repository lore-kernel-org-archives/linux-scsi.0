From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 14/17] scsi: replace custom rq mapping with
	blk_rq_map_kern_sgl()
Date: Tue, 14 Apr 2009 09:44:31 +0900
Message-ID: <20090414093401V.fujita.tomonori@lab.ntt.co.jp>
References: <49E3080F.7080206@kernel.org>
	<20090413190747V.fujita.tomonori@lab.ntt.co.jp>
	<20090413125912.GA16337@liondog.tnic>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:49861 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754885AbZDNApo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Apr 2009 20:45:44 -0400
In-Reply-To: <20090413125912.GA16337@liondog.tnic>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: petkovbb@gmail.com
Cc: fujita.tomonori@lab.ntt.co.jp, tj@kernel.org, bharrosh@panasas.com, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, axboe@kernel.dk, linux-kernel@vger.kernel.org

On Mon, 13 Apr 2009 14:59:12 +0200
Borislav Petkov <petkovbb@googlemail.com> wrote:

> Hi,
> 
> On Mon, Apr 13, 2009 at 07:07:58PM +0900, FUJITA Tomonori wrote:
> > On Mon, 13 Apr 2009 18:38:23 +0900
> > Tejun Heo <tj@kernel.org> wrote:
> > 
> > > FUJITA Tomonori wrote:
> > > >> I thought that was agreed and done? What is left to do for that to go
> > > >> in.
> > > > 
> > > > I've converted all the users (sg, st, osst). Nothing is left. So we
> > > > don't need this.
> > > 
> > > Yeah, pulled it.  Okay, so we can postpone diddling with request
> > > mapping for now.  I'll re-post fixes only from this and the previous
> > > patchset and proceed with other patchsets.
> > 
> > To be honest, I don't think that we can clean up the block
> > mapping. For example, blk_rq_map_kern_prealloc() in your patchset
> > doesn't look cleanup to me. It's just moving a hack from ide to the
> > block (well, I have to admit that I did the same thing when I
> > converted sg/st/osst...).
> 
> Well, since blk_rq_map_kern_prealloc() is going to be used only in
> ide-cd (driver needs it to queue a sense request from within the irq
> handler) and since it is considered a hack I could try to move it out of
> the irq handler

It's quite nice if you could do that.

But I think that ide-atapi also needs blk_rq_map_kern_prealloc().

> and do away only with blk_rq_map_kern() if that is more
> of an agreeable solution?

Yeah, blk_rq_map_kern() is much proper.
