From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] bsg: Add support for submitting requests at tail of
	queue
Date: Thu, 22 Jan 2009 16:27:59 -0600
Message-ID: <1232663279.27348.6.camel@localhost.localdomain>
References: <20090122111302.GG30821@kernel.dk>
	 <49786A1E.3070707@panasas.com> <20090122124640.GQ30821@kernel.dk>
	 <20090123070237B.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:34177 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759167AbZAVW2A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jan 2009 17:28:00 -0500
In-Reply-To: <20090123070237B.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jens.axboe@oracle.com, bharrosh@panasas.com, dougg@torque.net, linux-scsi@vger.kernel.org, osd-dev@open-osd.org

On Fri, 2009-01-23 at 07:03 +0900, FUJITA Tomonori wrote: 
> So, Boaz, what do you want to do exactly? It should have in the patch
> description. I don't want to add something that nobody uses.

OK, can we step back a bit from this?  Everyone seems to be talking past
each other.  The original complaint was that multiple commands against
the same device issued by SG_IO could be executed "out of order".  This
is really irrelevant because we never guarantee execution order in the
first place.

However, if you consider our current at head insertion policy coupled
with a multi-threaded application issuing hundreds of SG_IO requests at
once, you can see we have a potential starvation issue:  Commands at the
tail of the queue end up pushed further and further back as more
commands are added to the head.  This starvation issue is worth
addressing, I think, and it can only be addressed by allowing tail
insertion.

The original reason for at head is, as you surmise, inherited from sg
and the rationale is largely for error handling:  you need error
handling commands to pre-empt everything in the current queue.

James




