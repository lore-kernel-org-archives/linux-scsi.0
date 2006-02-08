From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Regarding ordered-tag support.
Date: Wed, 08 Feb 2006 10:26:26 -0600
Message-ID: <1139415986.3003.29.camel@mulgrave.il.steeleye.com>
References: <43E99248.7090505@gmail.com>
	 <1139413766.3003.19.camel@mulgrave.il.steeleye.com>
	 <43EA17E6.4000800@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:52438 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1161101AbWBHQ0a (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Feb 2006 11:26:30 -0500
In-Reply-To: <43EA17E6.4000800@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun <htejun@gmail.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2006-02-09 at 01:10 +0900, Tejun wrote:
> Oh... I see.  How many drivers do that?  I can't think of good reasons
> to report BUSY via IRQ for simpler transports (SATA/SPI).  Maybe enable
> ordered-tag selectively?

All of them.  These are scsi *device* returns.  The problem is that even
if the driver is careful about this, we queue any status done for
softirq processing ...

> > 
> > For the second:  Depending on the mode page (the QErr bit of the
> > queueing page), most devices fail only a single command.  We can set the
> > QErr bit to return every command after the failing one (thus ensuring
> > execution order), but the error handler would have to take them all back
> > and resort them for submission.
> 
> Actually blk layer will do the sorting part (this is what req->ordcolor
> is for).  Block drivers are only required to not successfully complete
> later requests while retrying earlier ones, so setting QErr and retrying
> all on-the-fly requests should do it (no EH code change).

Right ... but at the moment, we don't do that.  The eh would have to be
changed to gather all the commands for the device (we do it per host)
and resubmit them in such a way that the block layer resorts them,
wouldn't we ... at the moment we queue each one as they're processed.

James


