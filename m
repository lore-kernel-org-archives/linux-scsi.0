From: Eddie Williams <Eddie.Williams@steeleye.com>
Subject: Re: how to connect 2 nodes to a SCSI disk (cabinet)
Date: Fri, 20 Jun 2003 14:25:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200306201425.53540.Eddie.Williams@Steeleye.com>
References: <64655AAA92E6ED46B9AC9421260D96A560CB5A@srmanning.eng.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [65.114.3.137] ([65.114.3.137]:17926 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264246AbTFTShr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Jun 2003 14:37:47 -0400
In-Reply-To: <64655AAA92E6ED46B9AC9421260D96A560CB5A@srmanning.eng.emc.com>
List-Id: linux-scsi@vger.kernel.org
To: "jansen, frank" <jansen_frank@emc.com>, "'Ranade, Prakash'" <prakashr@intgroup.com>, Mike Dresser <mdresser_l@windsormachine.com>
Cc: linux-scsi@vger.kernel.org


Depending on which adaptec card you are using you may need to set a jumper to 
force termination.  Some of the older Adaptec cards have "soft" termination.  
Meaning, when power is applied it will drive termination but when power is 
dropped termination is dropped.  For those cards setting a jumper will force 
termination even when the power is removed.  This is pretty important if you 
power off one server.

It is probably safe to assume other wise but just to be sure, this is not a 
dual ported SCSI drive is it?  If so then it is not really a shared bus and 
in that case the drive would need to terminate both busses.

I agree with Frank here, you want the hosts at 7 and 6.

If you power the servers up one at a time can they see the drive OK?  Start 
simple.

Eddie
On Friday 20 June 2003 01:49 pm, jansen, frank wrote:
> This is fairly old technology, so I'll have to go back in my memory banks,
> but here are my recollections on setting this up:
>
> - Change the topology so that there is no termination on either HBA and use
> Y-cables with external termination, so that you can unplug either host from
> the bus without taking down access for the other host.  The topology will
> look as follows:
>
>     T   _______external SCSI driver______________   T
>      \ /                                         \ /
>       Y                                           Y
>    node 1 							node 2
>
> The other option is to leave termination on both HBAs, inwhich case you
> should never unplug anything.  Note that the bus must be arbitrated on both
> ends.  Also be sure not to violate any length limits on your SCSI bus.
> - ID settings: set one HBA to 7 and the other to 6.  The reason for these
> numbers is that the arbitration scheme for SCSI runs 7 down to 0 to 15 down
> to 8.  In your current configuration the disk has a higher arbitration
> priority than the HBAs.
> - Disable bus erset on power up on both HBAs; this will ensure that you can
> power either host without clearing all outstanding requests on the bus.
>
> If none of your pins are bent anywhere, this should work for sharing a
> device.  Now you'll get to the fun part of 2 hosts coordinating access to a
> single device.
>
> Good luck,
>
> Frank
>
> -----Original Message-----
> From: Ranade, Prakash [mailto:prakashr@intgroup.com]
> Sent: Friday, June 20, 2003 1:01 PM
> To: Mike Dresser
> Cc: linux-scsi@vger.kernel.org
> Subject: RE: how to connect 2 nodes to a SCSI disk (cabinet)
>
>
> isent it true that...
> you cannot have two seperate SCSI controllers trying to maintain the same
> bus.They will fight..for same bus?
>
> Prakash S. Ranade
> OCP - Oracle Certified DBA 8i, 9i
> 205 776 2320
>
> "Lets document it and call it a feature"
>
>
> -----Original Message-----
> From: Mike Dresser [mailto:mdresser_l@windsormachine.com]
> Sent: Friday, June 20, 2003 11:57 AM
> To: Ranade, Prakash
> Cc: linux-scsi@vger.kernel.org
> Subject: RE: how to connect 2 nodes to a SCSI disk (cabinet)
>
> On Fri, 20 Jun 2003, Ranade, Prakash wrote:
> > node1 and node2 both running redhat linux 7.2...both have Adaptec scsi
>
> card in it...scsi disk is  DataSilo DS-100 (see attached manual) using
> Seagate HD.
>
> > node1:scsi id = 14 - scsi termination is disabled
> > node1:scsi id = 15 - scsi termination is automatic (i tried all
>
> enabled/disabled/automatic nothing works)
>
> > external scsi disk id = 0
> >
> > node 1 							node 2
> >
> >
> > 	---------external SCSI drive---------------
>
> Any internal connections on either SCSI card?
>
> If not, set both node's to enabled scsi termination.
>
> Mike
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

