From: Douglas Gilbert <dougg@torque.net>
Subject: Re: SAS overview
Date: Sun, 28 Mar 2004 13:01:56 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40664024.2070700@torque.net>
References: <20040316174713.C424976C4F@isis.visi.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:27409 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S262078AbUC1DNR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Mar 2004 22:13:17 -0500
In-Reply-To: <20040316174713.C424976C4F@isis.visi.com>
List-Id: linux-scsi@vger.kernel.org
To: "Scott M. Ferris" <sferris@acm.org>
Cc: Matthew Wilcox <willy@debian.org>, linux-scsi <linux-scsi@vger.kernel.org>

Scott M. Ferris wrote:
> Matthew Wilcox wrote:
> 
>>On Tue, Mar 16, 2004 at 09:46:31PM +1000, Douglas Gilbert wrote:
>>
>>
>>>Now things start to get interesting. SAS can aggregate
>>>individual phy interconnects to form "wide" links. So
>>>if two (single phy) cables are run from a HBA (occupying
>>>two of its phys) to phys on the same expander then that
>>>is a wide link. Seen from Linux driving that HBA that is
>>>two PCI devices (each HBA phy) but only one SCSI initiator
>>>port. Up to 256 phy interconnects can be ganged to make
>>>a very wide SAS link (a parallel bus you might say).
>>
>>It's different though (and I suspect you know this, but let's clarify for
>>the audience).  A parallel link would send each bit down a different phy.
>>PCI-E (and probably SAS) send each byte down a different phy.
> 
> 
> The assumption that each phy will be a different PCI device is likely
> to be false, at least for initiators.  

Scott,
Whether two phys on a SAS HBA are two separate SCSI initiators
or one initiator on a wide link depends on what those phys are
attached to. That seems pretty dynamic so it seems to me the HBA
driver needs to look at phys individually. So if the phys are
not separate PCI devices then they at least need to be individually
addressable (and the SAS address isn't going to help since it's
the same for all HBA phys). At the moment for SPI PCI HBAs sysfs
has a one to one link between a PCI device and a SCSI host.
Such sysfs links might look a little different in the presene of
SAS wide links.

> Under normal circumstances,
> there's simply no reason for a host driver to care which initiator phy
> gets used, and it's more efficient for the HBA to choose the phy when
> it wants to open a connection, and expose a firmware interface that
> deals with either logical (SAM-2) SCSI initiator ports (narrow or wide
> depending on cabling), or end devices that the HBA has discovered in
> the SAS domain.  You can probably get phy information from the HBA for
> configuration or error reporting purposes, but host drivers probably
> won't queue commands to specific phys.

Knowing the physical components (cables) that make up a wide
link seems important IMO. It's possible to incorrectly "wire"
a SAS domain so it might be useful to point out which
cable(s) (by identifying the phys at either end) is
inappropriate. Also the "unit" of routing in a SAS expander
is the phy.

> SAS is connection-oriented, and each connection is between one
> initiator phy and one target phy.  The wide ports don't aggregate data
> at the byte level.  A wide port lets you have multiple connections
> open at the same time, to different devices, or to the same device if
> that device has enough phys.  Once a connection is established, SAS is
> fairly similar to packetized U320.

SAS has a protocol stack and it is connection-oriented towards the
top of that stack. IMO its important to know what is going on at
the lower levels as well.

> The main effect of having wide ports on the HBAs is that it allows the
> HBA to have 4 connections open at once, and it allows a target to open
> a connection to any of the HBA's 4 initiator phys when reconnecting to
> the initiator to provide data-in or status.  It's like having 4 phone
> lines with the same hunt-group phone number for incoming calls.

Yes, I didn't make that point. The hunt-group analogy is good (as long
as folks understand what that is).

Doug Gilbert



