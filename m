From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Problems with the block-layer timeouts
Date: Tue, 11 Nov 2008 12:11:53 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0811111205390.29125-100000@netrider.rowland.org>
References: <20081111155458M.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:1675 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752654AbYKKRLy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Nov 2008 12:11:54 -0500
In-Reply-To: <20081111155458M.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 11 Nov 2008, FUJITA Tomonori wrote:

> I don't worry about anything. I just think that these round_jiffies_up
> are pointless because they were added for the block-layer users that
> care about exact timeouts, however the block-layer doesn't export
> blk_add_timer() so the block-layer users can't control the exact time
> when the timer starts. So doing round_jiffies_up calculation per every
> request doesn't make sense for me.

In fact the round_jiffies_up() routines were added for other users as
well as the block layer.  However none of the others could be changed
until the routines were merged.  Now that the routines are in the 
mainline, you should see them start to be called in multiple places.

Also, the users of the block layer _don't_ care about exact timeouts.  
That's an important aspect of round_jiffies() and round_jiffies_up() --
you don't use them if you want an exact timeout.

The reason for using round_jiffies() is to insure that the timeout
will occur at a 1-second boundary.  If several timeouts are set for
about the same time and they all use round_jiffies() or
round_jiffies_up(), then they will all occur at the same tick instead
of spread out among several different ticks during the course of that
1-second interval.  As a result, the system will need to wake up only
once to service all those timeouts, instead of waking up several
different times.  It is a power-saving scheme.

Alan Stern

