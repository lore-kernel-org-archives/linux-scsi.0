From: Matthew Wilcox <willy@debian.org>
Subject: Re: SAS overview
Date: Tue, 16 Mar 2004 13:12:46 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040316131246.GQ25059@parcelfarce.linux.theplanet.co.uk>
References: <4056E917.7050502@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:50586 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261444AbUCPNMs
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Mar 2004 08:12:48 -0500
Content-Disposition: inline
In-Reply-To: <4056E917.7050502@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Tue, Mar 16, 2004 at 09:46:31PM +1000, Douglas Gilbert wrote:
> The unit of serial communication is a "phy". The current
> generation of SATA phys run at 1.5 Gb/sec while the SAS
> phys run at 3.0 Gb/sec. [A byte is encoded in 10 bits in
> the serial stream so for maximum megabyte/sec throughputs,
> just divide by 10.]

This is going to be interesting with PCI Express.  PCI Express links also
encode a byte in 10 bits (and so does infinibad, iirc).  PCI-E 1.0 runs
its links at 2.5Gb/s, so you're going to need strictly more PCI-E links
than SAS phys in order to saturate the SAS bus.  Rumour has it that the
first generation of boxes will have x4 sockets for non-graphics slots,
which will be fine for cards with up to 3 phys (3 * 3 = 9; 4 * 2.5 =
10) but will be the bottleneck for cards with 4 phys.

> Now things start to get interesting. SAS can aggregate
> individual phy interconnects to form "wide" links. So
> if two (single phy) cables are run from a HBA (occupying
> two of its phys) to phys on the same expander then that
> is a wide link. Seen from Linux driving that HBA that is
> two PCI devices (each HBA phy) but only one SCSI initiator
> port. Up to 256 phy interconnects can be ganged to make
> a very wide SAS link (a parallel bus you might say).

It's different though (and I suspect you know this, but let's clarify for
the audience).  A parallel link would send each bit down a different phy.
PCI-E (and probably SAS) send each byte down a different phy.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
