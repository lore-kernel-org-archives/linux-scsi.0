From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] fixup some tagged queuing mess
Date: Mon, 25 Aug 2003 12:09:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1061827751.2948.35.camel@compaq.xsintricity.com>
References: <20030825122751.GF15506@lst.de>
	 <1061827243.2044.107.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pix-525-pool.redhat.com ([66.187.233.200]:4008 "EHLO
	lacrosse.corp.redhat.com") by vger.kernel.org with ESMTP
	id S261976AbTHYQN4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2003 12:13:56 -0400
In-Reply-To: <1061827243.2044.107.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Christoph Hellwig <hch@lst.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2003-08-25 at 12:00, James Bottomley wrote:
> On Mon, 2003-08-25 at 07:27, Christoph Hellwig wrote:
> > James, can you review the code in 53c700.c?  Calling scsi_activate_tcq
> > in ->queuecommand rather than ->slave_configure looks rather strange to
> > me..
> 
> There is a reason why it works this way (apart from history): Just
> because a device says it supports TCQ in its inquiry data doesn't mean
> that it actually does, so 53c700 goes through a state machine
> interaction where it first tries a single tagged command, and if that
> succeeds it turns on TCQ permanently.

Actually, there are only a couple examples of this that I know of
(Iomega Jaz 1GB drives with firmware revision less than J.86 or
something like that and a few others).  But, they are all in the
blacklist to my knowledge and prior to slave_configure we should have
already evaluated the Inquiry results against the blacklist and set the
sdev-> (damn, don't have a 2.6 tree handy to look this up, but we used
to parse the device inquiry vs. bflags when we attached the device, then
in select_queue_depths you didn't look at inquiry, you looked at
sdev->tagged_supported to know if it passed the tests in the mid
layer).  Don't know if that's still happening in 2.6, but that was the
purpose, so that things like doing this in the low level driver wouldn't
be needed.

> The problem with doing this from slave_configure is that the flags
> represent a state machine of the commands, so they can't be set from
> there (because we passively wait for commands to come down before
> changing states).
> 
> The patch:
> 
> -       if(SCp->device->tagged_supported && !SCp->device->tagged_queue
> +       if(SCp->device->tagged_supported && !SCp->device->simple_tags &&
> 
> Looks wrong.  Shouldn't it be
> 
> if(SCp->device->tagged_supported && !(SCp->device->simple_tags ||
> SCp->device->ordered_tags) &&
> 
> to pick up the two types of tag we may turn on?

Nope.  It's invalid to have ordered_tags without simple_tags (and stupid
to boot, if you only had ordered tags then you might as well just run
untagged since all commands have to be completed in order and you are
now adding overhead on the drive firmware in tracking tags for no
usefull purpose).  However, and this is why I split these two out, there
*are* devices out there that support simple tags but not ordered tags
(or head of queue tags).  But, testing on simple tags is sufficient.  We
should *never* be enabling tagged queueing on a device without enabling
simple tags.

> Since there's also a currently unused third type of tag (head of queue)
> perhaps you would be better off introducing a scsi_tag_enabled() macro
> that encapsulates the logic.
> 
> James
-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc.
         1801 Varsity Dr.
         Raleigh, NC 27606


