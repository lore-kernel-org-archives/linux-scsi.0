From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [DO NOT APPLY] sd take advantage of rotation speed
Date: Wed, 25 Jun 2008 19:26:39 +0200
Message-ID: <20080625172638.GE20851@kernel.dk>
References: <20080619160342.GJ4392@parisc-linux.org> <20080625134705.GZ20851@kernel.dk> <4862552A.5010900@gmail.com> <48627184.9010609@panasas.com> <20080625165759.GC20851@kernel.dk> <20080625172015.GR4392@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:12425 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395AbYFYR0l (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jun 2008 13:26:41 -0400
Content-Disposition: inline
In-Reply-To: <20080625172015.GR4392@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Ric Wheeler <ricwheeler@gmail.com>, linux-scsi@vger.kernel.org

On Wed, Jun 25 2008, Matthew Wilcox wrote:
> On Wed, Jun 25, 2008 at 06:57:59PM +0200, Jens Axboe wrote:
> > Precisely, merging and fairness is a big part of it. Plus, doing this in
> > sd is just a blatant layer violation.
> 
> I'm fine with tweaking the elevators to know about low-latency seeks.
> But please stop describing it as "a blatant layering violation".
> It's nothing of the sort.  It's setting a default at a point where we
> find out the information which would guide us.

Uhm, but it IS "a blatant layering violation", it's doing things from
the wrong side up :-)

> I haven't looked into doing this in udev yet; I've got caught up in
> another project.  In any case, it seems like there's no role for udev
> any more, so I'll probably not spend any more time on this unless there's
> some need.

I don't think udev is a particularly good idea either. My plan was to
introduce device profiles for the queue, but it is probably a bad idea
to over-engineer this. So I'll keep it simple, stick to a 'zero cost
seek' flag instead and allow drivers to signal that. libata/ide needs to
check the ID page word to detect SSD drives as well, so they need a few
lines of change too.

I'll just stick the block bit in the 2.6.27 pending queue and let the
other patches go through Jeff/James/Bart.

-- 
Jens Axboe

