From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: [PATCH] allow drivers to hook into watchdog timeout
Date: Tue, 10 Feb 2004 13:26:57 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <2549730000.1076444817@aslan.btc.adaptec.com>
References: <20040120132052.GA6740@lst.de>		<2432440000.1076430858@aslan.btc.adaptec.com	>	<1076431366.1804.24.camel@mulgrave>		<2472850000.1076435243@aslan.btc.adaptec.com>	<1076438507.2165.38.camel@mulgrave> 	<2520610000.1076442259@aslan.btc.adaptec.com> <1076443541.2080.56.camel@mulgrave>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:52707 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S264477AbUBJUUT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Feb 2004 15:20:19 -0500
In-Reply-To: <1076443541.2080.56.camel@mulgrave>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@lst.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

> On Tue, 2004-02-10 at 14:44, Justin T. Gibbs wrote:
>> > If you need to stall a command after you've accepted it by returning
>> > zero from queuecommand, you return it to the mid-layer with status
>> > either BUSY or QUEUE_FULL.
>> 
>> BUSY and QUEUE_FULL status have particular meanings when associated
>> with an SCSI peripheral.  Using them for this purpose will only confuse
>> the mid-layer into taking unwarranted action, like trying to throttle
>> the queue depth.  The times that I want to use this have nothing to
>> do with BUSY or QUEUE_FULL in their SCSI sense.
> 
> So if I give you an error code for this, like DID_REQEUEUE, you'll
> eliminate the driver queueing from your queucommand and from your done
> processing?

If I can freeze at per-device granularity and testing of the BUSY and
QUEUE_FULL paths in the mid-layer pan out, I believe the answer is yes.

>> They will only be issued up to their command retry count which may be zero
>> for certain commands.  This may also confuse the peripheral or mid-layer
>> drivers into believing that a unit attention condition is expected and
>> should be ignored.  The commands that were affected by the recovery action
>> should be marked accordingly, but marking the commands that are still waiting
>> on the sidelines is the equivalent of a drive-by-shooting.
> 
> No, they won't.  DID_RESET doesn't count against the retry count (the
> only things that affect the retry count are conditions that go through
> the maybe_retry label in scsi_device_disposition()).

This is only true if the peripheral driver calls scsi_io_completion().
The SG driver, for instance, does not.

> It will not cause any unit attention exception processing.  That only
> happens if the error handler knows it reset something, or the driver
> reports that it is resetting something.

That reminds me.  Reported bus/target resets do not cause a
bus/device-settle delay.  This is another one of the workarounds
in my driver.

--
Justin

