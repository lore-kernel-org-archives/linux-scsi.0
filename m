From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: FireWire/SBP2 Target mode
Date: Mon, 6 Feb 2012 21:26:28 +0100
Message-ID: <20120206212628.6880c506@stein>
References: <4E4BD560.4010806@bootc.net>
	<4E4D3B88.30003@ladisch.de>
	<4F29978A.3010707@redhat.com>
	<20120201224156.0773ebc6@stein>
	<4F2A55B9.4040005@panasas.com>
	<4F2A60DC.9030007@ladisch.de>
	<4F2FD1F4.9050702@bootc.net>
	<4F2FE705.3070509@ladisch.de>
	<4F2FE8DA.70502@bootc.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <4F2FE8DA.70502@bootc.net>
Sender: target-devel-owner@vger.kernel.org
To: Chris Boot <bootc@bootc.net>
Cc: Clemens Ladisch <clemens@ladisch.de>, target-devel@vger.kernel.org, linux1394-devel@lists.sourceforge.net, Boaz Harrosh <bharrosh@panasas.com>, Andy Grover <agrover@redhat.com>, linux-scsi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Feb 06 Chris Boot wrote:
> On 06/02/2012 14:43, Clemens Ladisch wrote:
> > Chris Boot wrote:
> >> You can pull the code from:
> >> git://github.com/bootc/Linux-SBP-2-Target.git
> >
> > The TODO file says:
> >> * Update Juju so we can get the speed in the fw_address_handler ca=
llback
> >
> > What is the speed needed for?
>=20
> "The speed at which the block write request to the MANAGEMENT_AGENT=20
> register is received shall determine the speed used by the target for=
=20
> all subsequent requests to read the initiator=E2=80=99s configuration=
 ROM, fetch=20
> ORB=E2=80=99s from initiator memory or store status at the initiator=E2=
=80=99s=20
> status_FIFO. Command block ORB=E2=80=99s separately specify the speed=
 for=20
> requests addressed to the data buffer or page table."
>=20
> (T10/1155D Revision 4 page 53/54)

I guess it is not too hard to add this to the AR-req handler.  On the
other hand, I see little reason to follow the SBP-2 spec to the letter
here.  The target driver could just use the maximum speed that the core
figured out.  On the other hand, this requires of course
  - the target to wait for core to finish scanning an initiator,
  - the core to offer an API to look up an fw_device by a
    card--generation--nodeID tuple.

The intention of the spec is IMO clearly to enable target implementatio=
ns
that do not need to implement topology scanning.  I have a hard time to
think of a valid scenario where an initiator needs to be able to steer =
a
target towards a lower wire speed than what the participating links and
PHYs actually support.

> > SBP-2 says:
> > | The target shall issue data transfer requests with a speed equal =
to
> > | that specified by the spd field in the ORB.
> >
> > SBP-3 says:
> > | The target shall issue data transfer requests with a speed equal =
to
> > | that specified by the controlling spd field, whether in the ORB o=
r in
> > | a node selector in an associated page table.

Clemens, the speed used in data transfers can be different from the spe=
ed
to be used to read the initiator's Config ROM/ fetch ORBs/ write status=
,
because data buffers and page tables can reside on a third node.  (In
practice they reside always on the initiator node, but per spec they
don't have to.)

Again, IMO the target driver could ignore this other speed too and just
use the speed which firewire-core figured out.  But on the other hand,
this would require an fw_device lookup, given card--generation--nodeID;=
 so
using the speed code given in the ORB is much simpler.

Side note:  Like with the speed, the max_payload given in the ORB may b=
e
different from that in the initiator's bus information block, simply
because the data buffers and page tables may reside on a third node wit=
h a
different packet payload limit.  Again, just using the max_payload give=
n
in the ORB makes for the easiest implementation (and follows the spec t=
o
the letter).

> >> Please note that you can't then disable a unit until all the targe=
ts
> >> are logged-out. For Linux this usually means 'rmmod firewire_sbp2'=
=2E
> >
> > That driver should not, by default, log into targets on its own nod=
e.
>=20
> It still tries to and never appears to give up, so this needs=20
> blacklisting on the target system until firewire_sbp2 is changed. It'=
s=20
> harmless other than filling up the kernel log with error messages.
>=20
> What I meant, however, is if you connect to the target from a separat=
e=20
> Linux system you will be unable to disable the unit on the target sys=
tem=20
> until the _initiator_ logs out. You can do this on the initiator by=20
> unloading the module, which sends a logout request to the target.

Another way to log out is
# echo "fw4.0" > /sys/bus/firewire/drivers/*sbp2/unbind

(I will post a patch soon which renames this directory from sbp2 to
firewire_sbp2, as a side effect of a logging related change.)
--=20
Stefan Richter
-=3D=3D=3D=3D=3D-=3D=3D=3D-- --=3D- --=3D=3D-
http://arcgraph.de/sr/
