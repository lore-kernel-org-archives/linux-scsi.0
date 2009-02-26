From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: RFC: Transport identifier
Date: Wed, 25 Feb 2009 21:32:21 -0800
Message-ID: <20090226053221.GB1145@ca-server1.us.oracle.com>
References: <yq1iqmxg6o4.fsf@sermon.lab.mkp.net> <646765f40902252054t3def25e4j73ccd0192e0be51e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:41129 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbZBZFdA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Feb 2009 00:33:00 -0500
Content-Disposition: inline
In-Reply-To: <646765f40902252054t3def25e4j73ccd0192e0be51e@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Julian Calaby <julian.calaby@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

On Thu, Feb 26, 2009 at 03:54:30PM +1100, Julian Calaby wrote:
> On Thu, Feb 26, 2009 at 15:31, Martin K. Petersen
> <martin.petersen@oracle.com> wrote:
> >
> > There are a few cases where it would be useful to know which transp=
ort
> > is associated with a scsi_device. =A0For instance when determining =
whether
> > to send a READ CAPACITY(16) to a device or not:
> >
> > =A0 =A0static int sd_try_rc16_first(struct scsi_device *sdp)
> > =A0 =A0{
> > =A0 =A0 =A0 =A0if (scsi_device_transport(sdp) =3D=3D SCSI_TRANSPORT=
_USB)
> > =A0 =A0 =A0 =A0 =A0 return 0; /* Run screaming for the hills */
> > =A0 =A0[...]
> >
> > This patch implements support for a transport identifier in the
> > scsi_host. =A0The id defaults to SPI and it is explicitly overridde=
n in
> > the host templates for FC, SAS, USB, etc. drivers.
> >
> > It also looks like the availability of this transport id could impr=
ove
> > the sysfs parsing in lsscsi.
> >
> > Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
>=20
> [snip]
>=20
> > +/* These strings must match the scsi_transport_id enum in scsi.h *=
/
> > +static const char * const transport_names[] =3D {
> > + =A0 =A0 =A0 "spi", "fc", "sas", "iscsi", "sbp", "usb", "ata",
> > +};
>=20
> Firstly, this should probably mark which name is for which value. (I
> know it's obvious, but it could get confusing if there are ever user
> friendly names here.)

I like doing this:

static const char * const transport_names[] =3D {
	[SCSI_TRANSPORT_SPI]		=3D "spi",
	...
};

Joel

--=20

"It is not the function of our government to keep the citizen from
 falling into error; it is the function of the citizen to keep the
 government from falling into error."
	- Robert H. Jackson

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
