From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [linux-iscsi-devel] [question] deferred sense
Date: Wed, 05 Jan 2005 10:44:29 -0600
Message-ID: <1104943469.3997.8.camel@mulgrave>
References: <41DB21D7.5080904@us.ibm.com> <20050104234700.GA18343@visi.com>
	 <20050105092144.GB26793@lst.de> <20050105152112.GA8472@visi.com>
	 <20050105152333.GA1453@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:48109 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262465AbVAEQpA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Jan 2005 11:45:00 -0500
In-Reply-To: <20050105152333.GA1453@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Scott M. Ferris" <sferris@acm.org>, Mike Christie <mikenc@us.ibm.com>, linux-iscsi-devel <linux-iscsi-devel@lists.sourceforge.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2005-01-05 at 16:23 +0100, Christoph Hellwig wrote:
> On Wed, Jan 05, 2005 at 09:21:12AM -0600, Scott M. Ferris wrote:
> > To be more specific, there were some devices that would fail a command
> > and return deferred sense.  The command didn't complete at the target,
> > and the kernel wasn't retrying it because the sense was deferred
> > rather than current.  For those devices, the translation produced the
> > desired retry.
> 
> Do you remember these devices?  Might be worth adding a midlayer
> blacklist entry for them.

That's certainly possible ... although we'd need a lot more details.
Any device that returns deferred sense for a current error is pretty
badly broken according to the spec.

> And I suspect we should get linux-scsi in the loop for the discussion
> about deferred sense handling.

Well, I'm willing to think about it again, but beyond reporting to the
user that "something went wrong" I'm not sure there's anything we can
do.

The most common case for deferred sense is using a writeback cache.
Here the device takes the write into its cache and returns GOOD.  Later
trying to write it to the device it gets a medium error and now tries to
send deferred sense saying "you remember that write I told you worked,
well actually..."  by this time, we've already acknowledged the write to
the block layer and any JFS will proceed on the assumption that it
completed.  There's no way we can go back in time and apply this error
to an already completed transaction.  However, the device has violated
the journalling assumptions, and the FS will be corrupt.

So does anyone have any better suggestions for handling deferred sense?

James


