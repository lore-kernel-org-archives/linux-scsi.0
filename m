From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Problems with the block-layer timeouts
Date: Tue, 11 Nov 2008 20:19:36 +0100
Message-ID: <20081111191936.GK26778@kernel.dk>
References: <20081111155458M.fujita.tomonori@lab.ntt.co.jp> <Pine.LNX.4.44L0.0811111205390.29125-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pasmtpa.tele.dk ([80.160.77.114]:56777 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122AbYKKTVM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Nov 2008 14:21:12 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0811111205390.29125-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Nov 11 2008, Alan Stern wrote:
> On Tue, 11 Nov 2008, FUJITA Tomonori wrote:
> 
> > I don't worry about anything. I just think that these round_jiffies_up
> > are pointless because they were added for the block-layer users that
> > care about exact timeouts, however the block-layer doesn't export
> > blk_add_timer() so the block-layer users can't control the exact time
> > when the timer starts. So doing round_jiffies_up calculation per every
> > request doesn't make sense for me.
> 
> In fact the round_jiffies_up() routines were added for other users as
> well as the block layer.  However none of the others could be changed
> until the routines were merged.  Now that the routines are in the 
> mainline, you should see them start to be called in multiple places.
> 
> Also, the users of the block layer _don't_ care about exact timeouts.  
> That's an important aspect of round_jiffies() and round_jiffies_up() --
> you don't use them if you want an exact timeout.
> 
> The reason for using round_jiffies() is to insure that the timeout
> will occur at a 1-second boundary.  If several timeouts are set for
> about the same time and they all use round_jiffies() or
> round_jiffies_up(), then they will all occur at the same tick instead
> of spread out among several different ticks during the course of that
> 1-second interval.  As a result, the system will need to wake up only
> once to service all those timeouts, instead of waking up several
> different times.  It is a power-saving scheme.

I can't add anything else, can't say it any better either. The main
point of using round_jiffies_up() is to align with other timers. I don't
understand why you (Tomo) think that timeouts are exact? They really are
not, and within the same second is quite adequate here.

-- 
Jens Axboe

