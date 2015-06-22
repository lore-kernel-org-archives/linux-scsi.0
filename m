From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] USB: storage: add "no SYNCHRONIZE CACHE" quirk
Date: Mon, 22 Jun 2015 10:36:28 -0700
Message-ID: <1434994588.2237.90.camel@HansenPartnership.com>
References: <Pine.LNX.4.44L0.1506221324110.1799-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:32790 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751421AbbFVRgb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Jun 2015 13:36:31 -0400
In-Reply-To: <Pine.LNX.4.44L0.1506221324110.1799-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, James Bottomley <JBottomley@Parallels.com>, Jun Itou <itou_jun@infoseek.jp>, Markus Rathgeb <maggu2810@gmail.com>, Matt <vickm78@hotmail.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, USB list <linux-usb@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>

On Mon, 2015-06-22 at 13:30 -0400, Alan Stern wrote:
> On Mon, 22 Jun 2015, James Bottomley wrote:
> 
> > I'm not sure I entirely like this:  we are back again treating data
> > corruption problems silently.
> > 
> > However, I also believe treating a single flush failure as a critical
> > filesystem error is also wrong:  The data's all there correctly; all it
> > does is introduce a potential window were the FS could get corrupted in
> > the unlikely event the system crashed.
> > 
> > Obviously, for a disk with a writeback cache that can't do flush, that
> > window is much wider and the real solution should be to try to switch
> > the cache to write through.
> 
> I agree.  Doing the switch manually (by writing to the "cache_type" 
> attribute file) works, but it's a nuisance to do this when you have a 
> portable USB drive that gets moved among a bunch of machines.

Perhaps it might be wise to do this to every USB device ... for external
devices, the small performance gain doesn't really make up for the
potential data loss.

> > How about something like this patch?  It transforms FS FLUSH into a log
> > warning from an error but preserves the error on any other path.  You'll
> > still get a fairly continuous dump of warnings for one of these devices,
> > though ... do they respond to mode selects turning off the writeback?
> 
> I would be very surprised if any of those drives support MODE SELECT at 
> all.

I assume the cache type attribute file you refer to above is just
pretending their cache is write through rather than actually setting it
to be so?  The original IDE device had no way of turning their cache
types to write through either, but the manufacturers were eventually
convinced of the error of their ways.

> Maybe your patch will be acceptable, though.  We'll have to hear from 
> Markus and Matt.

We'll probably have to take this to fsdevel as well ... they might have
opinions about whether the FS wants to be informed about flush failure.

James

> Alan Stern
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> 



--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
