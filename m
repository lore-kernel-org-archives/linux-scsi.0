From: "jansen, frank" <jansen_frank@emc.com>
Subject: RE: how to connect 2 nodes to a SCSI disk (cabinet)
Date: Fri, 20 Jun 2003 13:49:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <64655AAA92E6ED46B9AC9421260D96A560CB5A@srmanning.eng.emc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [168.159.100.12] ([168.159.100.12]:2835 "EHLO
	mercury.eng.emc.com") by vger.kernel.org with ESMTP id S263665AbTFTRfH
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jun 2003 13:35:07 -0400
List-Id: linux-scsi@vger.kernel.org
To: "'Ranade, Prakash'" <prakashr@intgroup.com>, Mike Dresser <mdresser_l@windsormachine.com>
Cc: linux-scsi@vger.kernel.org

This is fairly old technology, so I'll have to go back in my memory banks,
but here are my recollections on setting this up:

- Change the topology so that there is no termination on either HBA and use
Y-cables with external termination, so that you can unplug either host from
the bus without taking down access for the other host.  The topology will
look as follows:

    T   _______external SCSI driver______________   T
     \ /                                         \ /
      Y                                           Y
   node 1 							node 2

The other option is to leave termination on both HBAs, inwhich case you
should never unplug anything.  Note that the bus must be arbitrated on both
ends.  Also be sure not to violate any length limits on your SCSI bus.
- ID settings: set one HBA to 7 and the other to 6.  The reason for these
numbers is that the arbitration scheme for SCSI runs 7 down to 0 to 15 down
to 8.  In your current configuration the disk has a higher arbitration
priority than the HBAs.
- Disable bus erset on power up on both HBAs; this will ensure that you can
power either host without clearing all outstanding requests on the bus.

If none of your pins are bent anywhere, this should work for sharing a
device.  Now you'll get to the fun part of 2 hosts coordinating access to a
single device.

Good luck,

Frank

-----Original Message-----
From: Ranade, Prakash [mailto:prakashr@intgroup.com]
Sent: Friday, June 20, 2003 1:01 PM
To: Mike Dresser
Cc: linux-scsi@vger.kernel.org
Subject: RE: how to connect 2 nodes to a SCSI disk (cabinet)


isent it true that...
you cannot have two seperate SCSI controllers trying to maintain the same
bus.They will fight..for same bus?

Prakash S. Ranade
OCP - Oracle Certified DBA 8i, 9i
205 776 2320

"Lets document it and call it a feature"


-----Original Message-----
From: Mike Dresser [mailto:mdresser_l@windsormachine.com]
Sent: Friday, June 20, 2003 11:57 AM
To: Ranade, Prakash
Cc: linux-scsi@vger.kernel.org
Subject: RE: how to connect 2 nodes to a SCSI disk (cabinet)




On Fri, 20 Jun 2003, Ranade, Prakash wrote:

> node1 and node2 both running redhat linux 7.2...both have Adaptec scsi
card in it...scsi disk is  DataSilo DS-100 (see attached manual) using
Seagate HD.
> node1:scsi id = 14 - scsi termination is disabled
> node1:scsi id = 15 - scsi termination is automatic (i tried all
enabled/disabled/automatic nothing works)
> external scsi disk id = 0
>
> node 1 							node 2
> 	|							|
> 	|							|
> 	---------external SCSI drive---------------
>

Any internal connections on either SCSI card?

If not, set both node's to enabled scsi termination.

Mike

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
