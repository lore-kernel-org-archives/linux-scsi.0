From: Tejun <htejun@gmail.com>
Subject: Re: Regarding ordered-tag support.
Date: Thu, 09 Feb 2006 01:57:55 +0900
Message-ID: <43EA2313.9030506@gmail.com>
References: <43E99248.7090505@gmail.com> <1139413766.3003.19.camel@mulgrave.il.steeleye.com> <43EA17E6.4000800@gmail.com> <43EA1B75.40008@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zproxy.gmail.com ([64.233.162.195]:63608 "EHLO zproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1030592AbWBHQ6C (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2006 11:58:02 -0500
Received: by zproxy.gmail.com with SMTP id 13so1601359nzn
        for <linux-scsi@vger.kernel.org>; Wed, 08 Feb 2006 08:58:01 -0800 (PST)
In-Reply-To: <43EA1B75.40008@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>


Hello,

James Smart wrote:
>>>For the first: busy/queue_full processing, the issue is that when we
>>>send out a command, we could get a BUSY or QUEUE_FULL return which comes
>>>back to us via IRQ context.  Unfortunately, we could have multiple
>>>commands that do this and a command will be accepted as soon as the busy
>>>condition alleviates, so we could see say two commands go down in order,
>>>the first one will get BUSY, the second is accepted and only then do we
>>>get the IRQ that says BUSY to the first ... now we have out of order
>>>execution.
>>
>>Oh... I see.  How many drivers do that?  I can't think of good reasons
>>to report BUSY via IRQ for simpler transports (SATA/SPI).  Maybe enable
>>ordered-tag selectively?
> 
> This isn't a driver thing - this is a SCSI device thing.  The disk array
> is temporarily out of resources so it BUSY's, or QUEUE_FULL's. But the
> next i/o may not encounter it.

I intentionally wrote 'driver' because if a SCSI device determines that 
it's busy, it would report via CHECK CONDITION.  Depending on QErr, the 
whole task set will be terminated, and such case falls into EH 
requeueing case (would require changes in scsi_softirq though).

So, I thought this case was driver/controller thing where they report 
busy condition after issue for a command while accepting later commands.

>>>For the second:  Depending on the mode page (the QErr bit of the
>>>queueing page), most devices fail only a single command.  We can set the
>>>QErr bit to return every command after the failing one (thus ensuring
>>>execution order), but the error handler would have to take them all back
>>>and resort them for submission.
>>
>>Actually blk layer will do the sorting part (this is what req->ordcolor
>>is for).  Block drivers are only required to not successfully complete
>>later requests while retrying earlier ones, so setting QErr and retrying
>>all on-the-fly requests should do it (no EH code change).
> 
> You're making the assumption that you can set QErr... It's under device control.
> 

Was it ro field?  Didn't know that.  I will check it tomorrow.  If a 
device doesn't abort whole taskset, we just can't use ordered-tag for 
barriers.

Thanks for your comment.

-- 
tejun
