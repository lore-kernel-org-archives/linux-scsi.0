From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] fixup some tagged queuing mess
Date: Mon, 25 Aug 2003 15:32:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1061839949.2948.208.camel@compaq.xsintricity.com>
References: <20030825122751.GF15506@lst.de>
	 <1061827243.2044.107.camel@mulgrave>
	 <1061827751.2948.35.camel@compaq.xsintricity.com>
	 <1061828571.2044.134.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pix-525-pool.redhat.com ([66.187.233.200]:42602 "EHLO
	lacrosse.corp.redhat.com") by vger.kernel.org with ESMTP
	id S262161AbTHYThV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2003 15:37:21 -0400
In-Reply-To: <1061828571.2044.134.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Christoph Hellwig <hch@lst.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2003-08-25 at 12:22, James Bottomley wrote:
> Ah, OK, I was thinking of them as an either/or.

Nope.

> Hmm, we should probably fix scsi_populate_tag_msg as well then.  It
> looks like it will happily spit out an ordered tag even if we know the
> drive cannot take it.

So, given that you want to fully and completely handle tagged queueing
issues in all drivers, here's what needs to be working:

1)  Split out simple tags from ordered tags (skip head of queue, they
aren't real usefull for our purposes).  This is done.

2)  Either blacklist all the drives we can find that don't support
ordered tags (not impossible, just some older cheap drives have this
problem last I knew, I don't think any modern SCSI drives do this unless
some of the drives in the Firewire or USB realm are currently having
this problem, but then again we would know on them since last I knew at
least USB storage was still 1 command at a time and who cares about
tags, don't know about Firewire) or make sure that the low level drivers
can deal with tag rejection and make sure that low level drivers know to
disable ordered tags if they get a rejection of an ordered tag.

3) In the mid layer, whenever we have a REQ_BARRIER command, if the
drive supports ordered tags, send an ordered tag.  If the drive doesn't,
then put this command on the MLQUEUE, plug the device, wait for the last
outstanding command to complete, then send this one command as an
untagged command, then when this command completes, unplug the device. 
That preserves the REQ_BARRIER operation in the two cases that we care
about, devices with and without ordered tags.

Anyway, that's how I remember things needing to be, but I've been too
busy on other stuff to look into it and keep up with the 2.6 scsi work
for a while, so I could be way off base.  Therefore, probably not even
$.02 worth ;-)


-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc.
         1801 Varsity Dr.
         Raleigh, NC 27606


