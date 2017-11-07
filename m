From: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: network namespace, netlink and sysfs changes for iSCSI (Re:
 [PATCH 0/9] use network namespace for iSCSI control interfaces)
Date: Tue, 7 Nov 2017 14:32:28 -0800
Message-ID: <20171107223228.GE29597@straylight.hirudinean.org>
References: <20171031224104.17735-1-cleech@redhat.com>
 <20171107180156.GD29597@straylight.hirudinean.org>
 <1510087526.3118.37.camel@HansenPartnership.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <open-iscsi+bncBCYMVIPVXQMBB77IRDIAKGQEETWMDBA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Content-Disposition: inline
In-Reply-To: <1510087526.3118.37.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Nov 07, 2017 at 12:45:26PM -0800, James Bottomley wrote:
> On Tue, 2017-11-07 at 10:01 -0800, Chris Leech wrote:
> > Hello,
> >=20
> > I have this set of changes to the iSCSI control interfaces pending
> > review, but seeing as it's sysfs and netlink changes there's not a
> > lot of feedback from linux-scsi.
>=20
> Well, it's a bit unlikely that they understand network namespaces.

I get that, just looking for suggestions of the right place to go before
going to crazy with the cross posting.

> > I was hoping I could get a brief review on the adding of network
> > namespace support here.
>=20
> Most network namespace work is done on netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, but they
> probably won't understand all the SCSI bits, but perhaps they don't
> need to; it's basically the netlink and the filters, right?
>=20
> The other list that would take a more generic view is the containers
> one=C2=A0containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org=C2=A0because that's where =
most
> namespace stuff ends up.

Thanks James, the container list isn't one I would have come up with.

Chris

>=20
> James
>=20
>=20
>=20
> > Thank you,
> > Chris
> >=20
> > On Tue, Oct 31, 2017 at 03:40:55PM -0700, Chris Leech wrote:
> > >=20
> > > This series of changes makes the iSCSI netlink and sysfs control
> > > interfaces filtered by network namespace.=C2=A0=C2=A0This is required=
 to run
> > > iscsid in any network namespace other than the initial default one.
> > >=20
> > > Currently the netlink communication will fail if iscsid is started
> > > in a non-default network namespace, as there is no kernel side
> > > socket.=C2=A0=C2=A0After fixing that, the rest of these changes are t=
o filter
> > > visibility of the iSCSI transport objects by netns.=C2=A0=C2=A0This a=
llows
> > > for multiple iscsid instances to be run, one per netns, each
> > > controlling it's own set of iSCSI sessions.
> > >=20
> > > The iSCSI transport objects are filtered, but not the SCSI or block
> > > layer devices.=C2=A0=C2=A0So while iSCSI hosts and sessions become li=
mited to
> > > a network namespace, any attached devices remain visible system
> > > wide.
> > >=20
> > > This currently only supports iscsi_tcp running in a new namespace,
> > > as it creates a virtual host per session.=C2=A0=C2=A0Support could be=
 added
> > > later to allow assignment of iSCSI HBAs to network namespace, much
> > > as is done for network interfaces.
> > >=20
> > > Chris Leech (9):
> > > =C2=A0 iscsi: create per-net iscsi netlink kernel sockets
> > > =C2=A0 iscsi: associate endpoints with a host
> > > =C2=A0 iscsi: sysfs filtering by network namespace
> > > =C2=A0 iscsi: make all iSCSI netlink multicast namespace aware
> > > =C2=A0 iscsi: set netns for iscsi_tcp hosts
> > > =C2=A0 iscsi: check net namespace for all iscsi lookups
> > > =C2=A0 iscsi: convert flashnode devices from bus to class
> > > =C2=A0 iscsi: rename iscsi_bus_flash_* to iscsi_flash_*
> > > =C2=A0 iscsi: filter flashnode sysfs by net namespace
> > >=20
> > > =C2=A0drivers/infiniband/ulp/iser/iscsi_iser.c |=C2=A0=C2=A0=C2=A07 +=
-
> > > =C2=A0drivers/scsi/be2iscsi/be_iscsi.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A06 +-
> > > =C2=A0drivers/scsi/bnx2i/bnx2i_iscsi.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A06 +-
> > > =C2=A0drivers/scsi/cxgbi/libcxgbi.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A06 +-
> > > =C2=A0drivers/scsi/iscsi_tcp.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=
=A0=C2=A07 +
> > > =C2=A0drivers/scsi/qedi/qedi_iscsi.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A06 +-
> > > =C2=A0drivers/scsi/qla4xxx/ql4_os.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A062 +--
> > > =C2=A0drivers/scsi/scsi_transport_iscsi.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0| 625
> > > ++++++++++++++++++++++---------
> > > =C2=A0include/scsi/scsi_transport_iscsi.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0|=C2=A0=C2=A063 ++--
> > > =C2=A09 files changed, 538 insertions(+), 250 deletions(-)
> > >=20
> > > --=C2=A0
> > > 2.9.5
> > >=20
> >=20
>=20

--=20
You received this message because you are subscribed to the Google Groups "=
open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
