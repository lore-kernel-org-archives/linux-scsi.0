From: James Bottomley <jejb@steeleye.com>
Subject: Re: [PATCH] minimal SAS transport class
Date: Fri, 26 Aug 2005 12:22:40 -0500
Message-ID: <1125076960.5079.61.camel@mulgrave>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A40@xbl3.ma.emulex.com>
	 <20050823154232.GA3464@us.ibm.com> <430BBBBE.4070408@adaptec.com>
	 <430E1CB1.1050108@s5r6.in-berlin.de> <430E24AB.2060002@pobox.com>
	 <430F46AA.2050305@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:10471 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S965129AbVHZRXB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Aug 2005 13:23:01 -0400
In-Reply-To: <430F46AA.2050305@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2005-08-26 at 12:43 -0400, Luben Tuikov wrote:
> > A move away from forced HCIL addressing would be a good thing.
> > 
> > However, its impossible to completely move away from addressing, as 
> > userspace and the SCSI core need ways to route CDBs to devices based on 
> > address.
> 
> They can use _anyone_ label in the label list of the LU.

I think what Jeff means is that the mid-layer needs to know which LLD to
send the CDB to.  This is the routing information (and is really just
the host number).  The LLD takes the rest of the information to work out
where it's sending the CDB.  For SPI this is often just PUN and LUN.
For FC it's usually WWPN and LUN.  Currently the information we send
down is the endpoint, represented by the scsi_device.

> The label itself is opaque to SCSI Core.  It may mean something
> to users, it may mean something to the protocol layer, but to
> SCSI Core it is completely opaque, and SCSI Core should _not_
> try to interpret it/them.

Labelling devices is policy.  That's the bit we're trying to push up to
the user via tools like udev.  The routing information we need is
already inherent in the structure of the scsi generic device tree. So,
by and large, the mid layer doesn't care what the numbers contained
within the struct scsi_device are.  It just uses a scsi_device to send a
CDB.  The LLDs however, do care.  SPI LLDs want to find channel, id
(target) and lun numbers.  FC drivers map id to wwpn internally and so
would probably quite like a way of sticking the wwpn into the id instead
of having a fictitious number.

The point is that labels are user policy and managed at user level.  The
representations used in the generic device tree shows what the kernel
actually uses and should be the preferred form for the transport.

So what's really needed is a scheme that allows the LLDs to use the id
transparently without having to map it to what they really want while
not breaking all the current SPI users (or which patches up every SPI
driver).

James


