From: Doug Ledford <dledford@redhat.com>
Subject: Re: Wide negotiation fails with 80->68 LVD adapter?
Date: Tue, 22 Oct 2002 13:03:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021022170316.GA31085@redhat.com>
References: <200210210514.g9L5ElYp006401@angle.badbox.com> <20021021163424.GE28914@redhat.com> <20021022032435.GA11986@angle.setup.org> <3DB4E275.BC760EDE@ix.netcom.com> <20021022161644.GA15234@angle.setup.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021022161644.GA15234@angle.setup.org>
List-Id: linux-scsi@vger.kernel.org
To: Alexy Khrabrov <braver@pobox.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Oct 22, 2002 at 12:16:44PM -0400, Alexy Khrabrov wrote:
> 
> Dan -- thanks.  I see those sca2lvd are mentioned as working by others
> trapped in SCA to 68 pin LVD switching.
> 
> So what is a "backplane"?

If you look inside one of the Dell servers that use SCA drives, or inside 
any external drive enclosure that uses SCA drives, they will have a green 
board that the drive sockets are all attached to and which is the carrier 
of the signals to all the drives.  That board is the backplane.  The 
primary difference between a backplane and a simple LVD<->SCA adapter is 
that backplanes are usually semi-intelligent devices themselves that don't 
just connect the drives to the SCSI bus, but in many cases have built in 
termination for the 68 pin LVD connection that is then routed into a 
bridge chip for the SCSI bus and then the other side of that bridge chip 
is then routed to the SCSI bus built into the backplane.  In that sense 
you have two SCSI busses and a smart bridge that connects them instead of 
being like the simple adapter which simply sticks the drive on the 
existing SCSI bus.  Keep in mind one of the things that determines bus 
quality is something called "stub length".  That's the total length of the 
various SCSI lines from the point at which they leave the primary SCSI bus 
until they terminate at the end point SCSI chip.

  SCSI Cable, terminator at end
      ^
      | __Stub Length__
      |/               \
      --+---+------------|
      | |   |            SCSI chip on drive
      | |   Connector on drive
      | LVD<->SCA Adapter
      |
      |
      
As you can see by my pitiful ASCII art, the stub length gets longer when
you plave an LVD<->SCA adapter between the drive and the 68 pin connector
on the cable.  Depending on the SCA adapter and the drive in question, you
could actually be increasing the stub length by a full 100%.  That
degrades the whole bus.  With backplanes, by putting all of the SCA
connectors directly on the backplane and running the SCSI bus through the
backplane instead of a cable, they can guarantee good signal quality.  By
using a bridge chip between the internal backplane and the external SCSI
cable, they again guarantee good signal quality inside the chassis
(because any possible poor signal traits on the external SCSI cable are
entirely electrically isolated away from the internal bus), and they also
guarantee that the signal quality on the external SCSI cable will not be
degraded by the internal signal traces since they are, again, totally
electrically isolated.  Of course, not all backplanes use electrical
isolation of the internal and external SCSI busses like this.  But, even 
without it, just having the connectors and the SCSI bus itself both inside 
of a printed circuit board instead of attached to a cable helps them 
control overall signal quality.


-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
