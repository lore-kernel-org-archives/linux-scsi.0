From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/17] SCSI data path micro-optimizations
Date: Thu, 6 Feb 2014 08:29:00 -0800
Message-ID: <20140206162900.GA21572@infradead.org>
References: <20140205123930.150608699@bombadil.infradead.org>
 <1391643664.2213.59.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58060 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756660AbaBFQ3B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Feb 2014 11:29:01 -0500
Content-Disposition: inline
In-Reply-To: <1391643664.2213.59.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <axboe@kernel.dk>, Nicholas Bellinger <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org

On Wed, Feb 05, 2014 at 03:41:04PM -0800, James Bottomley wrote:
> I will say that you do make the series hard to review by including
> things that do code churn for no gain: like making all the error
> handling goto based instead of the current in-place if () clause
> based ... this doesn't do anything for optmisation, so why do it?  (I'm
> not going to take sides on which is better, since we do both).

You mean the command allocation bits?  When I inline one function into a
nother I might as well add coherent error handling.  And for more than
one level of unwinding gotos are always better because a humand actually
can grasp it.

> There's also a lot of extraneous stuff in here.  I'm assuming most of
> the performance stuff is get/put removal and locking efficiency, things
> like this

This was already cut down.   If it makes your life easier we can do the
cmd allocation part separate of the rest, but there's really no "churn"
left.

> 
> 2,3,5 are allocation simplification.  In general it doesn't look so bad,
> but it doesn't seem to be part of the series.  It needs an ACK from the
> megaraid people since they're the only consumer of the interface you're
> trying to eliminate

It's needed to not make the cmd_size addition not a complete mess.

> 
> 6,7 is a new interface for command allocation and a virtio consumer.
> OK, as it goes, but also separable ... and preferably, if, as you say,
> it's important for mq, some more users, also doesn't need to be part of
> the series.

Feel free to consider 1-7 and the rest separate series already, I'll
resend them that way next time.

> 9,10 look like they aren't your patches, so they need an Author From:
> field for git (9 needs your signoff, if you're sending it).

The are, and they are properly attributed in the git tree.
Unfortunately quilt still hasn't learned to properly deal with From:
headers.

