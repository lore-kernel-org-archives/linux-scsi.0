From: Tejun <htejun@gmail.com>
Subject: Re: Regarding ordered-tag support.
Date: Thu, 09 Feb 2006 01:10:14 +0900
Message-ID: <43EA17E6.4000800@gmail.com>
References: <43E99248.7090505@gmail.com> <1139413766.3003.19.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pproxy.gmail.com ([64.233.166.176]:20637 "EHLO pproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1161020AbWBHQKU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2006 11:10:20 -0500
Received: by pproxy.gmail.com with SMTP id x31so418174pye
        for <linux-scsi@vger.kernel.org>; Wed, 08 Feb 2006 08:10:19 -0800 (PST)
In-Reply-To: <1139413766.3003.19.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Wed, 2006-02-08 at 15:40 +0900, Tejun Heo wrote:
> 
>>Now that new ordered implementation is in the mainline, we can properly 
>>use ordered-tag during barrier sequence.  As noted in the barrier doc, 
>>the problem with the current SCSI midlayer is that scsi_request_fn() is 
>>not atomic w.r.t. q->queuelock, so even if ordered-tag requests leave 
>>request queue in the correct order, they can be reordered while they are 
>>being issued by SCSI midlayer.
> 
> 
> Unfortunately, though, this is only half the problem.
> 
> The other half is busy/queue_full processing and error recovery
> 
> For the first: busy/queue_full processing, the issue is that when we
> send out a command, we could get a BUSY or QUEUE_FULL return which comes
> back to us via IRQ context.  Unfortunately, we could have multiple
> commands that do this and a command will be accepted as soon as the busy
> condition alleviates, so we could see say two commands go down in order,
> the first one will get BUSY, the second is accepted and only then do we
> get the IRQ that says BUSY to the first ... now we have out of order
> execution.

Oh... I see.  How many drivers do that?  I can't think of good reasons
to report BUSY via IRQ for simpler transports (SATA/SPI).  Maybe enable
ordered-tag selectively?

> 
> For the second:  Depending on the mode page (the QErr bit of the
> queueing page), most devices fail only a single command.  We can set the
> QErr bit to return every command after the failing one (thus ensuring
> execution order), but the error handler would have to take them all back
> and resort them for submission.

Actually blk layer will do the sorting part (this is what req->ordcolor
is for).  Block drivers are only required to not successfully complete
later requests while retrying earlier ones, so setting QErr and retrying
all on-the-fly requests should do it (no EH code change).

> I think the first problem has to be solved before we can turn on ordered
> tag based barriers.  I'm ambivalent on the second; we could probably
> mark ordered tag based barriers as "caveat emptor" while we work on the
> EH problem in parallel.

-- 
tejun
