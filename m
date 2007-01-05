From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] scsi_debug: illegal blocking memory allocation
Date: Fri, 05 Jan 2007 00:30:13 -0500
Message-ID: <459DE265.7030100@torque.net>
References: <20070103134907.GV11203@kernel.dk> <459C92CE.4090709@torque.net> <20070104112156.GV11203@kernel.dk> <1167923401.2819.7.camel@mulgrave.il.steeleye.com> <20070104155047.GE11203@kernel.dk>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:56623 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030331AbXAEFaT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jan 2007 00:30:19 -0500
In-Reply-To: <20070104155047.GE11203@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

Jens Axboe wrote:
> On Thu, Jan 04 2007, James Bottomley wrote:
>> On Thu, 2007-01-04 at 12:21 +0100, Jens Axboe wrote:
>>> I guess it's fully up to you how you want to solve it. The scheme seems
>>> a little elaborate, but these error conditions are unlikely to ever been
>>> seen in the wild, so no objections from me.
>> Actually, there's already a DID_ code that does what you want.  Instead
>> of DID_ERROR, which will retry immediately, there's DID_REQUEUE which
>> will halt the device queue and wait for a returning command to retry.
> 
> As long as it keeps firing the queue at some intervals even without any
> commands pending at all, then that'll work just fine. I like that
> approach a lot better than coding the error into some sense value that
> is (at best) some vague approximation of what has happened (calling
> memory shortage a transport error is a bit of a stretch).

True, but both happen. The scsi_debug driver is a
virtual host, virtual target and a lu (ram disk).
The failure that you pointed out stopped a response
being built. In the real world that would in the
target or lu.

The reason that I mentioned aborted_command sense key
is that it is also a "out of resources" (bandwidth) error
and it broke sg_dd. I would bet money that it would
also break the block layer/sd. The block layer should
leave it alone as it is simply a matter of sd
retrying a few times. However the st driver could have
a real problem (e.g. did that state changing command
work, fail or partially work??).

Anyway, I have submitted a patch that reports DID_REQUEUE
for an allocation failures and adds the ability to inject
aborted_command errors.

Doug Gilbert

