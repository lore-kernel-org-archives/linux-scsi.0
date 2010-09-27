From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: I/O topology fixes for big physical block size
Date: Mon, 27 Sep 2010 13:23:10 -0400
Message-ID: <20100927172309.GA13874@redhat.com>
References: <1285605664-27027-1-git-send-email-martin.petersen@oracle.com>
 <4CA0CC38.5010804@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757014Ab0I0RXQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Sep 2010 13:23:16 -0400
Content-Disposition: inline
In-Reply-To: <4CA0CC38.5010804@fusionio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, Sep 27 2010 at 12:54pm -0400,
Jens Axboe <jaxboe@fusionio.com> wrote:

> On 2010-09-28 01:41, Martin K. Petersen wrote:
> > Mike Snitzer reported that he has access to a device that supports thin
> > provisioning but does not use the Block Limits VPD page to indicate
> > discard granularity. Instead it reports a huge (1MB) physical block
> > size. That caused a bit of fallout in the topology stack which assumed a
> > physical block size of 4KiB or less.
> 
> Fixing the overflow aside, I question the validity of setting the physical
> block size to something larger than PAGE_SIZE as there's no way that that
> could really work in the current kernel.
> 
> I would suggest doing something similar as we do with other 'invalid'
> settings that we cannot honor, print a warning and drop the queue
> limits to PAGE_SIZE.

I'm inclined to agree.  Doesn't make a whole lot of sense.

But could this cap of PAGE_SIZE be enforced with a follow-on patch?  Or
would you rather see it be dealt with in a single revised 2/2 patch?

Mike
