From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: RE: [ANNOUNCE] MPT Fusion driver 3.02.06 update
Date: Tue, 26 Oct 2004 12:02:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57053AF0AE@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:26103 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261314AbUJZQCk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Oct 2004 12:02:40 -0400
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, jeremy@sgi.com
Cc: linux-scsi@vger.kernel.org

On Tuesday, October 26, 2004 4:38 AM, Christoph Hellwig wrote:
> On Mon, Oct 25, 2004 at 07:32:35PM -0400, Moore, Eric Dean wrote:
> > All,
> >=20
> > We are pleased to announce the MPT Fusion release candidate=20
> for lk 2.6
>=20
> Some things that come to mind immediately:
>=20
> >=20
> >=20
> > Highlights of this release:
> > =B7	SAS Support - 1064, 1066, 1068
>=20
> there's still tons of ioc->chip_type checks for SPI vs FC vs SAS -=20
> please always use the new bus_type member
>=20

I will fix this.

>=20
> > =B7	csmi ioctl support
>=20
> rejected, this ioctl interface is completely horrible, even worse tha=
n
> the fc hbaapi.  Please help to provide a proper sas transport=20
> class similar
> to the fc one.

This code code is ifdef'd with CPQ_CIM.  We currently have this is enab=
led
in the fusion Makefile. Instead would it be possible to have this disab=
led
for inclusion=20
in the kernel?  Applications are in place now used by several customers
using this
interface, and it would be difficult to have this remove at this stage,=
 as
our=20
customers are so close to shipment of product.=20

>=20
> > =B7	fc_transport support
>=20
> please don't put this under all kinds of ifdefs, also it's=20
> not working with
> current mainline anymore anyway.

I don't know what you mean.  The fc_transport stuff was just added two =
weeks
ago.  This was added by request of Jeremy Higdon.  This reports
the port_id, port_name, and node_name.  This support is enabled in
the fusion Makefile by MPT_ENABLE_FC_TRANSPORT. Its currently disabled =
for
reason (1) the transport layer is only available after 2.6.6 kernel, an=
d
we are supporting kernels older such as SUSE 9.1 and SLES9, (2)
we would not be able to build driver update disks due to the dependancy
of fc_transport.ko.=20

>=20
> Any reason there's no SPI transport attribute support, it's=20
> rather asymetric
> this way..
>=20

We are investigating into this, such as domain validation. =20
What other attributes do you suggest?
=20
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
