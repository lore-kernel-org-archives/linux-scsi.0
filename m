From: "Scott M. Ferris" <sferris@acm.org>
Subject: Re: SAS overview
Date: Tue, 16 Mar 2004 11:47:13 -0600 (CST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040316174713.C424976C4F@isis.visi.com>
References: <20040316131246.GQ25059@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from corb.mc.mpls.visi.com ([208.42.156.1]:30403 "EHLO
	corb.mc.mpls.visi.com") by vger.kernel.org with ESMTP
	id S264312AbUCPRrP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Mar 2004 12:47:15 -0500
In-Reply-To: <20040316131246.GQ25059@parcelfarce.linux.theplanet.co.uk> from
 Matthew Wilcox at "Mar 16, 2004 07:12:58 am"
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: Douglas Gilbert <dougg@torque.net>, linux-scsi <linux-scsi@vger.kernel.org>

Matthew Wilcox wrote:
> On Tue, Mar 16, 2004 at 09:46:31PM +1000, Douglas Gilbert wrote:
> 
> > Now things start to get interesting. SAS can aggregate
> > individual phy interconnects to form "wide" links. So
> > if two (single phy) cables are run from a HBA (occupying
> > two of its phys) to phys on the same expander then that
> > is a wide link. Seen from Linux driving that HBA that is
> > two PCI devices (each HBA phy) but only one SCSI initiator
> > port. Up to 256 phy interconnects can be ganged to make
> > a very wide SAS link (a parallel bus you might say).
> 
> It's different though (and I suspect you know this, but let's clarify for
> the audience).  A parallel link would send each bit down a different phy.
> PCI-E (and probably SAS) send each byte down a different phy.

The assumption that each phy will be a different PCI device is likely
to be false, at least for initiators.  Under normal circumstances,
there's simply no reason for a host driver to care which initiator phy
gets used, and it's more efficient for the HBA to choose the phy when
it wants to open a connection, and expose a firmware interface that
deals with either logical (SAM-2) SCSI initiator ports (narrow or wide
depending on cabling), or end devices that the HBA has discovered in
the SAS domain.  You can probably get phy information from the HBA for
configuration or error reporting purposes, but host drivers probably
won't queue commands to specific phys.

SAS is connection-oriented, and each connection is between one
initiator phy and one target phy.  The wide ports don't aggregate data
at the byte level.  A wide port lets you have multiple connections
open at the same time, to different devices, or to the same device if
that device has enough phys.  Once a connection is established, SAS is
fairly similar to packetized U320.

The main effect of having wide ports on the HBAs is that it allows the
HBA to have 4 connections open at once, and it allows a target to open
a connection to any of the HBA's 4 initiator phys when reconnecting to
the initiator to provide data-in or status.  It's like having 4 phone
lines with the same hunt-group phone number for incoming calls.

-- 
Scott M. Ferris,
sferris@acm.org 
