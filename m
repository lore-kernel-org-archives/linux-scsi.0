From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Question: request tag usage
Date: Fri, 26 Sep 2014 01:03:08 -0700
Message-ID: <20140926080308.GA21137@infradead.org>
References: <542507C9.2060901@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35379 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457AbaIZIDL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Sep 2014 04:03:11 -0400
Content-Disposition: inline
In-Reply-To: <542507C9.2060901@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Robert Elliot <elliot@hp.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>

On Fri, Sep 26, 2014 at 08:29:29AM +0200, Hannes Reinecke wrote:
> Hi Christoph,
> 
> as discussed it would make sense to use the request->tag in eg
> scmd_printk() to identify the command.
> Which I duly did, only to figure out that the tag is always '-1', ie
> tagging is not in use.
> (Which is okay from the SCSI side, seeing the TCQ is basically a
> SCSI parallel thing).

tag are still a live part of SAM for every transport, they've only
been renamed to "command identifier" in SAM-4 to confuse everyone.

> Looking closer I found plenty of code for handling tags in the block
> layer (and the blk-mq stuff, of course), but virtually none of the
> non-SPI driver seems to be using them.

A quick grep for scsi_activate_tcq disagrees with you.

> Which makes the original idea a bit pointless, seeing that we need
> to identify the command _always_, and not just if the host happens
> to support tagging.
> 
> Which leads me to some questions:
> - Is the stuff in blk-mq supposed to work as a superset of SCSI TCQ?

Yes.

> - If so, should any HBAs with a queue depth > 1 (which does not
>   support TCQ) set the tag of a command?
>   (that's what I've initially thought would happen ...)
> - If not (and the ->tag field is basically unused), can't we
>   have the HBA to fill in a value here?

blk-mq will always provide, and does rely on a valid request->tag.
A LLDD can still use it's own internal tagging or mess with scmd->tag,
although in general it should benefit from using the block layer
tagging.

> Which apparently was too much to hope for ...

I guess for now we'll need to stay with the command pointer address.
We can revisit this once the old request layer is gone.

