From: Christoph Hellwig <hch@infradead.org>
Subject: Re: uas: kernel BUG at block/blk-tag.c:89 is back again :|
Date: Tue, 8 Jul 2014 02:53:17 -0700
Message-ID: <20140708095317.GA4306@infradead.org>
References: <53B2B4B2.8050100@redhat.com>
 <20140703060135.GA5292@infradead.org>
 <53B93FE3.8050607@redhat.com>
 <20140707101015.GB3544@infradead.org>
 <53BA95C0.3020607@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44366 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbaGHJxU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jul 2014 05:53:20 -0400
Content-Disposition: inline
In-Reply-To: <53BA95C0.3020607@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>

On Mon, Jul 07, 2014 at 02:42:40PM +0200, Hans de Goede wrote:
> > I can't see any sensible way to "fix" the issue.  Struct gendisk keeps a
> > reference to the requeue_queue, and a struct gendisk reference is held
> > as long as the block device is open.  So whenever you surprise remove a
> > device that is open (usually by having a filesystem mounted on it),
> > the request_queue and it's reference to the tag structure will vastly
> > outlive the Scsi_Host.
> 
> Ok, so can we then please move forward with getting your patch merged ?

I've posted the patch in reply to another report and added Jens to the
Cc list.  As the block maintainer he need to review and merge it.

