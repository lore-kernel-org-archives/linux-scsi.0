From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] USB: storage: add "no SYNCHRONIZE CACHE" quirk
Date: Mon, 22 Jun 2015 13:30:05 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1506221324110.1799-100000@iolanthe.rowland.org>
References: <1434987827.2237.71.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:34200 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751896AbbFVRaJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jun 2015 13:30:09 -0400
In-Reply-To: <1434987827.2237.71.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Greg KH <greg@kroah.com>, James Bottomley <JBottomley@Parallels.com>, Jun Itou <itou_jun@infoseek.jp>, Markus Rathgeb <maggu2810@gmail.com>, Matt <vickm78@hotmail.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, USB list <linux-usb@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>

On Mon, 22 Jun 2015, James Bottomley wrote:

> I'm not sure I entirely like this:  we are back again treating data
> corruption problems silently.
> 
> However, I also believe treating a single flush failure as a critical
> filesystem error is also wrong:  The data's all there correctly; all it
> does is introduce a potential window were the FS could get corrupted in
> the unlikely event the system crashed.
> 
> Obviously, for a disk with a writeback cache that can't do flush, that
> window is much wider and the real solution should be to try to switch
> the cache to write through.

I agree.  Doing the switch manually (by writing to the "cache_type" 
attribute file) works, but it's a nuisance to do this when you have a 
portable USB drive that gets moved among a bunch of machines.

> How about something like this patch?  It transforms FS FLUSH into a log
> warning from an error but preserves the error on any other path.  You'll
> still get a fairly continuous dump of warnings for one of these devices,
> though ... do they respond to mode selects turning off the writeback?

I would be very surprised if any of those drives support MODE SELECT at 
all.

Maybe your patch will be acceptable, though.  We'll have to hear from 
Markus and Matt.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
