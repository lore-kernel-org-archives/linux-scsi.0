From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] allow drivers to hook into watchdog timeout
Date: 11 Feb 2004 15:05:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1076527539.1737.83.camel@mulgrave>
References: <20040120132052.GA6740@lst.de>		<2432440000.1076430858@aslan.btc.adaptec.com
	>	<1076431366.1804.24.camel@mulgrave>		<2472850000.1076435243@aslan.btc.ada
	ptec.com>	<1076438507.2165.38.camel@mulgrave>
	<2520610000.1076442259@aslan.btc.adaptec.com>
	<1076443541.2080.56.camel@mulgrave>
	<2549730000.1076444817@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:32983 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265765AbUBKUF0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Feb 2004 15:05:26 -0500
In-Reply-To: <2549730000.1076444817@aslan.btc.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: Christoph Hellwig <hch@lst.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-02-10 at 15:26, Justin T. Gibbs wrote:
> > So if I give you an error code for this, like DID_REQEUEUE, you'll
> > eliminate the driver queueing from your queucommand and from your done
> > processing?
> 
> If I can freeze at per-device granularity and testing of the BUSY and
> QUEUE_FULL paths in the mid-layer pan out, I believe the answer is yes.

I believe we have everything that you need with regard to BUSY and
QUEUE_FULL.

It looks like a device_blocked interface won't be too much work, I'll
look at coding one up.

> > No, they won't.  DID_RESET doesn't count against the retry count (the
> > only things that affect the retry count are conditions that go through
> > the maybe_retry label in scsi_device_disposition()).
> 
> This is only true if the peripheral driver calls scsi_io_completion().
> The SG driver, for instance, does not.

But that's by design.  The application using SG_IO receives the error
code directly and is in control of deciding to retry.

> That reminds me.  Reported bus/target resets do not cause a
> bus/device-settle delay.  This is another one of the workarounds
> in my driver.

That's correct.  The interface is really designed to report that
something happened.  Since we may not know the actual timing of the
reported event, the philosophy is that is't better queue and retry
(while correctly processing the NOT_READY) than to impose an arbitrary
delay.

The rule is that the mid-layer only delays for events it initiated.

James


