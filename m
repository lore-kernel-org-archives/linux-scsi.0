From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] fixup some tagged queuing mess
Date: 25 Aug 2003 11:22:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1061828571.2044.134.camel@mulgrave>
References: <20030825122751.GF15506@lst.de>
	<1061827243.2044.107.camel@mulgrave>
	<1061827751.2948.35.camel@compaq.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:4102 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261873AbTHYQXF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2003 12:23:05 -0400
In-Reply-To: <1061827751.2948.35.camel@compaq.xsintricity.com>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2003-08-25 at 11:09, Doug Ledford wrote:
> Actually, there are only a couple examples of this that I know of
> (Iomega Jaz 1GB drives with firmware revision less than J.86 or
> something like that and a few others).  But, they are all in the
> blacklist to my knowledge and prior to slave_configure we should have
> already evaluated the Inquiry results against the blacklist and set the
> sdev-> (damn, don't have a 2.6 tree handy to look this up, but we used
> to parse the device inquiry vs. bflags when we attached the device, then
> in select_queue_depths you didn't look at inquiry, you looked at
> sdev->tagged_supported to know if it passed the tests in the mid
> layer).  Don't know if that's still happening in 2.6, but that was the
> purpose, so that things like doing this in the low level driver wouldn't
> be needed.

Yes, the 53c700 is a driver for very old chips, likely to be connected
to very old hardware.  It's really a "just in case" feature for this
driver.

> Nope.  It's invalid to have ordered_tags without simple_tags (and stupid
> to boot, if you only had ordered tags then you might as well just run
> untagged since all commands have to be completed in order and you are
> now adding overhead on the drive firmware in tracking tags for no
> usefull purpose).  However, and this is why I split these two out, there
> *are* devices out there that support simple tags but not ordered tags
> (or head of queue tags).  But, testing on simple tags is sufficient.  We
> should *never* be enabling tagged queueing on a device without enabling
> simple tags.

Ah, OK, I was thinking of them as an either/or.

Hmm, we should probably fix scsi_populate_tag_msg as well then.  It
looks like it will happily spit out an ordered tag even if we know the
drive cannot take it.

James


