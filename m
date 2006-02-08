From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Regarding ordered-tag support.
Date: Wed, 08 Feb 2006 09:49:25 -0600
Message-ID: <1139413766.3003.19.camel@mulgrave.il.steeleye.com>
References: <43E99248.7090505@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:29397 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1030350AbWBHPt3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Feb 2006 10:49:29 -0500
In-Reply-To: <43E99248.7090505@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2006-02-08 at 15:40 +0900, Tejun Heo wrote:
> Now that new ordered implementation is in the mainline, we can properly 
> use ordered-tag during barrier sequence.  As noted in the barrier doc, 
> the problem with the current SCSI midlayer is that scsi_request_fn() is 
> not atomic w.r.t. q->queuelock, so even if ordered-tag requests leave 
> request queue in the correct order, they can be reordered while they are 
> being issued by SCSI midlayer.

Unfortunately, though, this is only half the problem.

The other half is busy/queue_full processing and error recovery

For the first: busy/queue_full processing, the issue is that when we
send out a command, we could get a BUSY or QUEUE_FULL return which comes
back to us via IRQ context.  Unfortunately, we could have multiple
commands that do this and a command will be accepted as soon as the busy
condition alleviates, so we could see say two commands go down in order,
the first one will get BUSY, the second is accepted and only then do we
get the IRQ that says BUSY to the first ... now we have out of order
execution.

For the second:  Depending on the mode page (the QErr bit of the
queueing page), most devices fail only a single command.  We can set the
QErr bit to return every command after the failing one (thus ensuring
execution order), but the error handler would have to take them all back
and resort them for submission.

I think the first problem has to be solved before we can turn on ordered
tag based barriers.  I'm ambivalent on the second; we could probably
mark ordered tag based barriers as "caveat emptor" while we work on the
EH problem in parallel.

James


