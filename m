From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] allow drivers to hook into watchdog timeout
Date: 12 Feb 2004 09:42:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1076596943.2196.71.camel@mulgrave>
References: <20040120132052.GA6740@lst.de>		<2432440000.1076430858@aslan.btc.adaptec.com
	 >	<1076431366.1804.24.camel@mulgrave>		<2472850000.1076435243@aslan.btc.ad
	a	ptec.com>	<1076438507.2165.38.camel@mulgrave>	<2520610000.1076442259@aslan
	 .btc.adaptec.com>	<1076443541.2080.56.camel@mulgrave>
	<2549730000.1076444817@aslan.btc.adaptec.com>
	<1076527539.1737.83.camel@mulgrave>
	<3156030000.1076544910@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:45730 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266445AbUBLOmd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Feb 2004 09:42:33 -0500
In-Reply-To: <3156030000.1076544910@aslan.btc.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: Christoph Hellwig <hch@lst.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2004-02-11 at 19:15, Justin T. Gibbs wrote: 
> > But that's by design.  The application using SG_IO receives the error
> > code directly and is in control of deciding to retry.
> 
> That's fine if the application has good information to go on.  Most
> of the comments in the SCSI layer indicate that DID_RESET means that
> a bus reset event happened, not that the LLD wanted to unconditionally
> retry a command that has never seen the transport.

DID_RESET doesn't mean the LLD wants to retry the command
unconditionally.  It means that the LLD is reporting that the command
was affected by error recovery actions and should be retried. 

In the normal course of events, the mid-layer will do the retry without
incrementing the retry count. 

applications issuing direct commands get to decide what the policy
should be. 

> > The rule is that the mid-layer only delays for events it initiated.
> 
> Well, this breaks lots of devices like external RAID controllers that
> need at least a few hundred ms bus settle delay before they will handle
> a new command.  This controllers often initiate the bus reset when they
> do a module failover or shutdown (e.g. upgrading one of the two controllers
> in a redundant controller).  Without a bus settle delay, these devices
> are taken offline by the mid-layer.
> 
> You have to enforce the delay regardless of where the reset event comes
> from.  The devices on the bus don't care who reset the bus, and their
> behavior doesn't differ when Linux does the reset or some third party
> does.

Well, there are two delays, aren't there: the bus settle delay and the
device ready delay.  The latter isn't really determinable, but the
device is supposed to return NOT_READY while in it.

For the former, it only applies to a bus reset on SPI, so I'd like to
handle it in the transport class.

James


