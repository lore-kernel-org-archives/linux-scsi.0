From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: [PATCH] allow drivers to hook into watchdog timeout
Date: Wed, 11 Feb 2004 17:15:10 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3156030000.1076544910@aslan.btc.adaptec.com>
References: <20040120132052.GA6740@lst.de>		<2432440000.1076430858@aslan.btc.adaptec.com		>	<1076431366.1804.24.camel@mulgrave>		<2472850000.1076435243@aslan.btc.ada	ptec.com>	<1076438507.2165.38.camel@mulgrave>	<2520610000.1076442259@aslan.btc.adaptec.com>	<1076443541.2080.56.camel@mulgrave> 	<2549730000.1076444817@aslan.btc.adaptec.com> <1076527539.1737.83.camel@mulgrave>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:51922 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S266294AbUBLAIc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Feb 2004 19:08:32 -0500
In-Reply-To: <1076527539.1737.83.camel@mulgrave>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@lst.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

> On Tue, 2004-02-10 at 15:26, Justin T. Gibbs wrote:
>> > So if I give you an error code for this, like DID_REQEUEUE, you'll
>> > eliminate the driver queueing from your queucommand and from your done
>> > processing?
>> 
>> If I can freeze at per-device granularity and testing of the BUSY and
>> QUEUE_FULL paths in the mid-layer pan out, I believe the answer is yes.
> 
> I believe we have everything that you need with regard to BUSY and
> QUEUE_FULL.
> 
> It looks like a device_blocked interface won't be too much work, I'll
> look at coding one up.

Okay.

>> > No, they won't.  DID_RESET doesn't count against the retry count (the
>> > only things that affect the retry count are conditions that go through
>> > the maybe_retry label in scsi_device_disposition()).
>> 
>> This is only true if the peripheral driver calls scsi_io_completion().
>> The SG driver, for instance, does not.
> 
> But that's by design.  The application using SG_IO receives the error
> code directly and is in control of deciding to retry.

That's fine if the application has good information to go on.  Most
of the comments in the SCSI layer indicate that DID_RESET means that
a bus reset event happened, not that the LLD wanted to unconditionally
retry a command that has never seen the transport.

>> That reminds me.  Reported bus/target resets do not cause a
>> bus/device-settle delay.  This is another one of the workarounds
>> in my driver.
> 
> That's correct.  The interface is really designed to report that
> something happened.  Since we may not know the actual timing of the
> reported event, the philosophy is that is't better queue and retry
> (while correctly processing the NOT_READY) than to impose an arbitrary
> delay.
> 
> The rule is that the mid-layer only delays for events it initiated.

Well, this breaks lots of devices like external RAID controllers that
need at least a few hundred ms bus settle delay before they will handle
a new command.  This controllers often initiate the bus reset when they
do a module failover or shutdown (e.g. upgrading one of the two controllers
in a redundant controller).  Without a bus settle delay, these devices
are taken offline by the mid-layer.

You have to enforce the delay regardless of where the reset event comes
from.  The devices on the bus don't care who reset the bus, and their
behavior doesn't differ when Linux does the reset or some third party
does.

--
Justin

