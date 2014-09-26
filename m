From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Question: request tag usage
Date: Fri, 26 Sep 2014 11:12:23 +0100
Message-ID: <1411726343.2183.9.camel@jarvis>
References: <542507C9.2060901@suse.de>
	 <20140926080308.GA21137@infradead.org> <542521DB.1020605@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54244 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755365AbaIZKM1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Sep 2014 06:12:27 -0400
In-Reply-To: <542521DB.1020605@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, "Elliott, Robert (Server Storage)" <elliott@hp.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>

On Fri, 2014-09-26 at 10:20 +0200, Hannes Reinecke wrote:
> On 09/26/2014 10:03 AM, Christoph Hellwig wrote:
> > On Fri, Sep 26, 2014 at 08:29:29AM +0200, Hannes Reinecke wrote:
> >> Hi Christoph,
> >>
> >> as discussed it would make sense to use the request->tag in eg
> >> scmd_printk() to identify the command.
> >> Which I duly did, only to figure out that the tag is always '-1', ie
> >> tagging is not in use.
> >> (Which is okay from the SCSI side, seeing the TCQ is basically a
> >> SCSI parallel thing).
> > 
> > tag are still a live part of SAM for every transport, they've only
> > been renamed to "command identifier" in SAM-4 to confuse everyone.
> > 
> >> Looking closer I found plenty of code for handling tags in the block
> >> layer (and the blk-mq stuff, of course), but virtually none of the
> >> non-SPI driver seems to be using them.
> > 
> > A quick grep for scsi_activate_tcq disagrees with you.
> > 
> Yeah, I've noticed after I've written the mail.
> However, main point still stands: using 'tag' to identify commands
> is pointless if not all of the LLDDs use tagging ...

Every non parallel LLD uses tagging; they all use the network request
response model, so they can no longer hold the bus until they get an
answer (which was how untagged commands work in SPI), so for most of the
transports, untagged commands aren't legal.  Of course, some drivers
roll their own tags instead of using the block ones.

James


