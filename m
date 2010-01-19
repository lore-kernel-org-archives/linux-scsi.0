From: James Bottomley <James.Bottomley@suse.de>
Subject: RE: [PATCH 9/10] mpt2sas: Enable TLR for SSP TAPE drives (Added
 SAS Transport APIs)
Date: Tue, 19 Jan 2010 13:18:25 -0600
Message-ID: <1263928705.4398.35.camel@mulgrave.site>
References: <20091216132620.GJ31161@lsi.com>
	 <1263831291.2773.54.camel@mulgrave.site>
	 <0D1E8821739E724A86F4D16902CE275C1C95DFE75A@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:55167 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755416Ab0ASUta (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jan 2010 15:49:30 -0500
In-Reply-To: <0D1E8821739E724A86F4D16902CE275C1C95DFE75A@inbmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

On Tue, 2010-01-19 at 23:57 +0530, Desai, Kashyap wrote:
>=20
> > -----Original Message-----
> > From: James Bottomley [mailto:James.Bottomley@suse.de]
> > Sent: Monday, January 18, 2010 9:45 PM
> > To: Desai, Kashyap
> > Cc: linux-scsi@vger.kernel.org; Moore, Eric; Prakash, Sathya
> > Subject: Re: [PATCH 9/10] mpt2sas: Enable TLR for SSP TAPE drives
> > (Added SAS Transport APIs)
> >=20
> > On Wed, 2009-12-16 at 18:56 +0530, Kashyap, Desai wrote:
> > > Added tlr_enabled bit in sas_device structure, which will have
> > boolean
> > > value 0 for disabled and 1 for enabled.
> > >
> > > As suggested by James B, I have added
> > sas_tlr_supported(),sas_enable_tlr(),
> > > sas_disable_tlr() functions at SAS transport layer so that any ot=
her
> > > Low layer driver can use those APIs.
> > >
> > > SAS transport API sas_tlr_supported() will send vpd page 0x90,
> > > to check the TLR support. If TLR is supported for end device, MPT=
2SAS
> > driver
> > > will enable the TLR bit in the SCSI_IO for every request. If ther=
e is
> > a
> > > response with MPI2_SCSITASKMGMT_RSP_INVALID_FRAME, the driver wil=
l
> > turn off
> > > the TLR logic.
> > >
> > > Signed-off-by: Kashyap Desai <kashyap.desai@xxxxxxx>
> > > Reviewed-by: Eric Moore <Eric.moore@xxxxxxx>
> >=20
> > What's with the xxxx?  I've got better things to do than fix up
> > changelog signoffs.
>=20
> Really Sorry about this gaffe.=20
> >=20
> > > diff --git a/drivers/scsi/scsi_transport_sas.c
> > b/drivers/scsi/scsi_transport_sas.c
> > > index fd47cb1..41b8eab 100644
> > > --- a/drivers/scsi/scsi_transport_sas.c
> > > +++ b/drivers/scsi/scsi_transport_sas.c
> > > @@ -358,6 +358,61 @@ void sas_remove_host(struct Scsi_Host *shost=
)
> > >  }
> > >  EXPORT_SYMBOL(sas_remove_host);
> > >
> > > +/**
> > > + * sas_tlr_supported - checking TLR bit in vpd 0x90
> > > + * @sdev: scsi device struct
> > > + *
> > > + * Check Transport Layer Retries are supported or not.
> > > + * If vpd page 0x90 is present, TRL is supported.
> > > + *
> > > + */
> > > +unsigned int
> > > +sas_tlr_supported(struct scsi_device *sdev)
> > > +{
> > > +	char *buffer;
> > > +
> > > +	buffer =3D scsi_get_vpd_page(sdev, 0x90);
> > > +	if (buffer =3D=3D NULL)
> > > +		return 0;
> > > +
> > > +	kfree(buffer);
> > > +	return 1;
> >=20
> > This can't be right.  TLR supported is the lowest bit of the 8th by=
te
> > of
> > the port entry ... you can't condition this on whether the protocol
> > page
> > exists or not.
> Got this point. I will change accordingly.
> >=20
> > > diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_devic=
e.h
> > > index 68d185c..7c1361b 100644
> > > --- a/include/scsi/scsi_device.h
> > > +++ b/include/scsi/scsi_device.h
> > > @@ -112,6 +112,7 @@ struct scsi_device {
> > >  				 * scsi_devinfo.[hc]. For now used only to
> > >  				 * pass settings from slave_alloc to scsi
> > >  				 * core. */
> > > +	unsigned tlr_enabled:1;	/* set tlr flags */
> >=20
> > And this is wrong:  the tlr is SAS specific, it belongs in the end
> > device flags like all the other SAS specific entries.
> I got it. I will move this into scsi_transport_sas.h in sas_end_devic=
e  as flags.
> >=20
> > We also need to expose it to the user in case they want to change t=
he
> > flag.
> >=20
> I am little confused on this point. Hope you don=E2=80=99t mind simpl=
ifying it.
>=20
> > How about separating the two patches and doing this for the transpo=
rt
> > class?  If it looks OK, I'll add it to the patch sequence and alter
> > this
> > commit.
> James, What does this mean ?

It means does the patch look OK to you?  As in storing the data in the
transport class and separating it into supported and enabled.  The
actual API you use for mpt2sas is unchanged.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
