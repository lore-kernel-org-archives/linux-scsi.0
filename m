From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] bsg: Add support for submitting requests at tail of
	queue
Date: Fri, 23 Jan 2009 15:14:47 +0900
Message-ID: <20090123151408G.fujita.tomonori@lab.ntt.co.jp>
References: <20090122124640.GQ30821@kernel.dk>
	<20090123070237B.fujita.tomonori@lab.ntt.co.jp>
	<1232663279.27348.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:44089 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328AbZAWGPR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jan 2009 01:15:17 -0500
In-Reply-To: <1232663279.27348.6.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, bharrosh@panasas.com, dougg@torque.net, linux-scsi@vger.kernel.org, osd-dev@open-osd.org

On Thu, 22 Jan 2009 16:27:59 -0600
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Fri, 2009-01-23 at 07:03 +0900, FUJITA Tomonori wrote: 
> > So, Boaz, what do you want to do exactly? It should have in the patch
> > description. I don't want to add something that nobody uses.
> 
> OK, can we step back a bit from this?  Everyone seems to be talking past
> each other.  The original complaint was that multiple commands against
> the same device issued by SG_IO could be executed "out of order".  This
> is really irrelevant because we never guarantee execution order in the
> first place.
> 
> However, if you consider our current at head insertion policy coupled
> with a multi-threaded application issuing hundreds of SG_IO requests at
> once, you can see we have a potential starvation issue:  Commands at the
> tail of the queue end up pushed further and further back as more
> commands are added to the head.  This starvation issue is worth
> addressing, I think, and it can only be addressed by allowing tail
> insertion.

Ah, I see. Thanks. We could see this with something busy.

BTW, bsg write interface enables you to send a command asynchronously
so a single-thread-ed application could cause this.
