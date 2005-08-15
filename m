From: James Bottomley <jejb@steeleye.com>
Subject: Re: [PATCH] allow a transport to pre-initialize starget_data
Date: Mon, 15 Aug 2005 11:32:13 -0500
Message-ID: <1124123533.5089.24.camel@mulgrave>
References: <20050815134210.GA19426@lst.de>  <4300B232.9000308@adaptec.com>
	 <1124119431.5089.9.camel@mulgrave>  <4300B7C4.8060400@adaptec.com>
	 <1124121234.5089.14.camel@mulgrave>  <4300BE8D.4070002@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:59084 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964824AbVHOQcX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2005 12:32:23 -0400
In-Reply-To: <4300BE8D.4070002@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Christoph Hellwig <hch@lst.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2005-08-15 at 12:10 -0400, Luben Tuikov wrote:
> Isn't DV an SPI paradigm?

Yes, but that's only one of the reasons to expose the underlying device.

> If the whole point of the LLDD+controller is to _give_ you this,
> "an LU which is actually RAID", abstraction, why does SCSI Core
> need to get to the underlying devices?

Because lots of the RAID drivers have internal code that performs
actions, like DV, on their underlying physical discs.

> What will SCSI Core do with the RAID members?  Why is SCSI Core
> concerned with this information?  What kind of parameters will
> it have to set, without the RAID device server knowing about it
> (which is implemented on the chip if HW RAID)?

Nothing except expose them ... that's the idea.  The parameters are set
from user level after that.  This elimiates need for the pass through
ioctl that all of these drivers have.

> > It's not a SPI leftover.  It's used by HBA's that have two channels that
> > genuinely share resources.  Although most modern SCSI cards simply have
> > two chips (and hence two separate HBAs) per channel, there are a few, of
> > which the qlogic fc card is one, that still have this one chip per two
> > channels model.
> 
> Ah, I see.
> 
> Please help me understand this:
> 
> You say that "channel" is not an SPI leftover but it is used
> by SCSI Core because 
> 
> 	"HBA's that have two channels that genuinely share resources".
> 
> Why is SCSI Core concerned with how HBAs are _built_?  Isn't this
> the LLDD's job?

Because resource management belongs in the mid-layer.  In particular
available commands per host.

> Is "channel" in SCSI Core used to _address_ SCSI devices?
> How many of those "channel" will we need?

On the wire? No.  In the mid-layer, not really, since devices are
addressed by struct scsi_device.  The channel makes a useful
discriminator for the LLD in the scsi device, however.

James


