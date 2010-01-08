From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH]drivers/ata/libata-eh.c:1509 unneeded memset()
Date: Fri, 08 Jan 2010 09:28:39 -0600
Message-ID: <1262964519.3025.614.camel@mulgrave.site>
References: <4B3BDB66.6000008@googlemail.com>  <4B4632BF.4070806@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4B4632BF.4070806@pobox.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: =?ISO-8859-1?Q?Ren=E9?= Bolldorf <xsecute@googlemail.com>, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2010-01-07 at 14:15 -0500, Jeff Garzik wrote:
> On 12/30/2009 05:59 PM, Ren=C3=A9 Bolldorf wrote:
> > We don't need this ;-).
> >
> > Best regards Ren=C3=A9 Bolldorf & a happy new year in advance.
> >
> > --- ./drivers/ata/libata-eh.c 2009-12-30 23:44:05.578988545 +0100
> > +++ ./drivers/ata/libata-eh.c 2009-12-30 23:45:06.991987607 +0100
> > @@ -1505,9 +1505,6 @@ static unsigned int atapi_eh_request_sen
> >
> > DPRINTK("ATAPI request sense\n");
> >
> > - /* FIXME: is this needed? */
> > - memset(sense_buf, 0, SCSI_SENSE_BUFFERSIZE);
>=20
> I need a little bit more detail than an unqualified statement...  Did=
=20
> you audit all paths leading to this code point?

There are two code paths coming into here.  One directly from the scsi
sense buffer:

		if (!(qc->ap->pflags & ATA_PFLAG_FROZEN)) {
			tmp =3D atapi_eh_request_sense(qc->dev,
						qc->scsicmd->sense_buffer,
						qc->result_tf.feature >> 4);

Which is fine because SCSI zeros the sense buffer.

But one also here:

		u8 *sense_buffer =3D dev->link->ap->sector_buf;
		[...]
		err_mask =3D atapi_eh_request_sense(dev, sense_buffer, sense_key);

Which doesn't look OK because it looks like the sector_buf isn't cleare=
d
(and it is reused).

James


