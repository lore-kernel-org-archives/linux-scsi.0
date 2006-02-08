From: James Smart <James.Smart@Emulex.Com>
Subject: Re: Regarding ordered-tag support.
Date: Wed, 08 Feb 2006 11:25:25 -0500
Message-ID: <43EA1B75.40008@emulex.com>
References: <43E99248.7090505@gmail.com> <1139413766.3003.19.camel@mulgrave.il.steeleye.com> <43EA17E6.4000800@gmail.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:21653 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1161100AbWBHQZc
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Feb 2006 11:25:32 -0500
In-Reply-To: <43EA17E6.4000800@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun <htejun@gmail.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>


>> For the first: busy/queue_full processing, the issue is that when we
>> send out a command, we could get a BUSY or QUEUE_FULL return which comes
>> back to us via IRQ context.  Unfortunately, we could have multiple
>> commands that do this and a command will be accepted as soon as the busy
>> condition alleviates, so we could see say two commands go down in order,
>> the first one will get BUSY, the second is accepted and only then do we
>> get the IRQ that says BUSY to the first ... now we have out of order
>> execution.
> 
> Oh... I see.  How many drivers do that?  I can't think of good reasons
> to report BUSY via IRQ for simpler transports (SATA/SPI).  Maybe enable
> ordered-tag selectively?

This isn't a driver thing - this is a SCSI device thing.  The disk array
is temporarily out of resources so it BUSY's, or QUEUE_FULL's. But the
next i/o may not encounter it.


> 
>> For the second:  Depending on the mode page (the QErr bit of the
>> queueing page), most devices fail only a single command.  We can set the
>> QErr bit to return every command after the failing one (thus ensuring
>> execution order), but the error handler would have to take them all back
>> and resort them for submission.
> 
> Actually blk layer will do the sorting part (this is what req->ordcolor
> is for).  Block drivers are only required to not successfully complete
> later requests while retrying earlier ones, so setting QErr and retrying
> all on-the-fly requests should do it (no EH code change).

You're making the assumption that you can set QErr... It's under device control.

-- james s
