From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: Incorrect response to SK/ASC/ASCQ = x 02/04/01 (becoming ready)
Date: Thu, 26 Aug 2004 09:21:28 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <99D30EDE-F773-11D8-B3DA-00039398BB5E@ieee.org>
Mime-Version: 1.0 (Apple Message framework v619)
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:60304 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S269043AbUHZPV2
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Aug 2004 11:21:28 -0400
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-scsi@vger.kernel.org

 > > > the mid-layer assumes an operational device
 > > > won't spontaneously spin down,
 > ...
 > What other conditions produce something like this?

Spontaneous park and then spontaneous spin down occur with some devices 
if the host neglects to read or write thru the cache from the disc for 
a long time, like whole seconds.

This policy reduces noise, power, and media wear.  Guarantees a gentle 
park.  Etc.  Same device design rationale as ATA HDD power management.  
Not disputed in the device world, I hear.

 > 02/04/01 = Not Ready, ...
 > becoming ready.
 > ...
 > retries ... exhausted in ... a second, ...

I vote we distinguish:

a) the spin-up implied by insert or power on,
b) the spin down implied by eject, and
c) other spin up and spin down.

 > work around ... by [modprobe] after plugging the drive in...

Our host should not rapidly retry and give up on any of these, sure.

 > disable disconnects ...
 > the bus would be blocked
 > while waiting for START STOP UNIT ...

SCSI over USB disables disconnects always, I know.

I hear SCSI over IDE in practice disables disconnects almost always, 
though t13.org publishes a theory of more capable devices.

 > > 02/04/01 should be treated like a Busy status.
 > ...
 > a) the spin-up implied by insert or power on,

Many devices use x 2 04 01 to mean a spin-up implied by insert or power 
on.

I hear x 2 04 01 had a pre-Windows history of meaning please rapidly 
retry, but Windows support was so poor - including rapidly counted 
retries - that those other uses of x 2 04 01 have migrate out of PC 
peripheral device designs.

 > b) the spin down implied by eject, and

Many PDT x00 devices use x 2 04 00 to mean the spin down implied by 
eject, many PDT x05 devices use x 2 3A.

 > > > the mid-layer assumes an operational device
 > > > won't spontaneously spin down,
 > > ...
 > > the 02/04/02 handling code
 > ...
 > c) other spin up and spin down.

I see x 0 and x 2 04 00 and x 2 04 02 reported to mean a spontaneous 
spin down.  I hear x 0 works well in Windows only if the auto spin up 
completes in a few seconds.

Pat LaVarre

