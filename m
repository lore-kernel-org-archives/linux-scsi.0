From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] scsi_debug: illegal blocking memory allocation
Date: Thu, 4 Jan 2007 16:50:48 +0100
Message-ID: <20070104155047.GE11203@kernel.dk>
References: <20070103134907.GV11203@kernel.dk> <459C92CE.4090709@torque.net> <20070104112156.GV11203@kernel.dk> <1167923401.2819.7.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([62.242.22.158]:7004 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964932AbXADPrz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Jan 2007 10:47:55 -0500
Content-Disposition: inline
In-Reply-To: <1167923401.2819.7.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Douglas Gilbert <dougg@torque.net>, linux-scsi@vger.kernel.org

On Thu, Jan 04 2007, James Bottomley wrote:
> On Thu, 2007-01-04 at 12:21 +0100, Jens Axboe wrote:
> > I guess it's fully up to you how you want to solve it. The scheme seems
> > a little elaborate, but these error conditions are unlikely to ever been
> > seen in the wild, so no objections from me.
> 
> Actually, there's already a DID_ code that does what you want.  Instead
> of DID_ERROR, which will retry immediately, there's DID_REQUEUE which
> will halt the device queue and wait for a returning command to retry.

As long as it keeps firing the queue at some intervals even without any
commands pending at all, then that'll work just fine. I like that
approach a lot better than coding the error into some sense value that
is (at best) some vague approximation of what has happened (calling
memory shortage a transport error is a bit of a stretch).

-- 
Jens Axboe

