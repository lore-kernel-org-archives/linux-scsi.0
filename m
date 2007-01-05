From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] scsi_debug: illegal blocking memory allocation
Date: Fri, 5 Jan 2007 13:49:18 +0100
Message-ID: <20070105124918.GD11203@kernel.dk>
References: <20070103134907.GV11203@kernel.dk> <459C92CE.4090709@torque.net> <20070104112156.GV11203@kernel.dk> <1167923401.2819.7.camel@mulgrave.il.steeleye.com> <20070104155047.GE11203@kernel.dk> <459DE265.7030100@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([62.242.22.158]:4935 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161089AbXAEMs7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Jan 2007 07:48:59 -0500
Content-Disposition: inline
In-Reply-To: <459DE265.7030100@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

On Fri, Jan 05 2007, Douglas Gilbert wrote:
> Jens Axboe wrote:
> > On Thu, Jan 04 2007, James Bottomley wrote:
> >> On Thu, 2007-01-04 at 12:21 +0100, Jens Axboe wrote:
> >>> I guess it's fully up to you how you want to solve it. The scheme seems
> >>> a little elaborate, but these error conditions are unlikely to ever been
> >>> seen in the wild, so no objections from me.
> >> Actually, there's already a DID_ code that does what you want.  Instead
> >> of DID_ERROR, which will retry immediately, there's DID_REQUEUE which
> >> will halt the device queue and wait for a returning command to retry.
> > 
> > As long as it keeps firing the queue at some intervals even without any
> > commands pending at all, then that'll work just fine. I like that
> > approach a lot better than coding the error into some sense value that
> > is (at best) some vague approximation of what has happened (calling
> > memory shortage a transport error is a bit of a stretch).
> 
> True, but both happen. The scsi_debug driver is a
> virtual host, virtual target and a lu (ram disk).
> The failure that you pointed out stopped a response
> being built. In the real world that would in the
> target or lu.

The point is that the condition need not be exposed, even if it could be
compared to (say) a device busy condition. Both should just results in a
requeue and later retry, when resources are available to satisfy the
request.

Your revised patch looks good to me!

-- 
Jens Axboe

