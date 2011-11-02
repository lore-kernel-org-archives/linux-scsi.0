From: "Moger, Babu" <Babu.Moger@netapp.com>
Subject: RE: [dm-devel] [PATCH 3/4] scsi_dh_rdac: Adding the match function for	rdac device handler
Date: Wed, 2 Nov 2011 11:41:18 -0400
Message-ID: <47D23AD8469A2B448F33C24BD7A39BD9105DB910@RTPMVEXC1-PRD.hq.netapp.com>
References: <47D23AD8469A2B448F33C24BD7A39BD9105DB4D8@RTPMVEXC1-PRD.hq.netapp.com>	<4EB0EF3F.1010300@suse.de> <47D23AD8469A2B448F33C24BD7A39BD9105DB8EE@RTPMVEXC1-PRD.hq.netapp.com> <4EB162DD.5030507@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:20870 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753636Ab1KBPlV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Nov 2011 11:41:21 -0400
Content-class: urn:content-classes:message
In-Reply-To: <4EB162DD.5030507@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, device-mapper development <dm-devel@redhat.com>
Cc: Linux SCSI Mailing list <linux-scsi@vger.kernel.org>

> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Wednesday, November 02, 2011 10:34 AM
> To: device-mapper development
> Cc: Moger, Babu; Linux SCSI Mailing list
> Subject: Re: [dm-devel] [PATCH 3/4] scsi_dh_rdac: Adding the match
> function for rdac device handler
>=20
> On 11/02/2011 04:23 PM, Moger, Babu wrote:
> >> -----Original Message-----
> >> From: Hannes Reinecke [mailto:hare@suse.de]
> >> Sent: Wednesday, November 02, 2011 2:21 AM
> >> To: dm-devel@redhat.com
> >> Subject: Re: [dm-devel] [PATCH 3/4] scsi_dh_rdac: Adding the match
> >> function for rdac device handler
> >>
> >> On 11/01/2011 06:19 PM, Moger, Babu wrote:
> >>> This patch introduces the match function for rdac device handler.
> >> Without this,
> >>> sometimes handler attach fails during the device_add.  The match
> >> function was
> >>> introduced by this patch
> >>> http://www.spinics.net/lists/linux-scsi/msg54284.html
> >>>
> >>> Signed-off-by: Babu Moger<babu.moger@netapp.com>
> >>> ---
> >>>
> >>> --- linux/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	2011-
> 10-31
> >> 11:25:44.000000000 -0500
> >>> +++ linux/drivers/scsi/device_handler/scsi_dh_rdac.c	2011-10-31
> >> 11:31:34.000000000 -0500
> >>> @@ -819,6 +819,21 @@ static const struct scsi_dh_devlist rdac
> >>>    	{NULL, NULL},
> >>>    };
> >>>
> >>> +static bool rdac_match(struct scsi_device *sdev)
> >>> +{
> >>> +	int i;
> >>> +
> >>> +	for (i =3D 0; rdac_dev_list[i].vendor; i++) {
> >>> +		if (!strncmp(sdev->vendor, rdac_dev_list[i].vendor,
> >>> +			strlen(rdac_dev_list[i].vendor))&&
> >>> +		    !strncmp(sdev->model, rdac_dev_list[i].model,
> >>> +			strlen(rdac_dev_list[i].model))) {
> >>> +			return true;
> >>> +		}
> >>> +	}
> >>> +	return false;
> >>> +}
> >>> +
> >>>    static int rdac_bus_attach(struct scsi_device *sdev);
> >>>    static void rdac_bus_detach(struct scsi_device *sdev);
> >>>
> >>> @@ -831,6 +846,7 @@ static struct scsi_device_handler rdac_d
> >>>    	.attach =3D rdac_bus_attach,
> >>>    	.detach =3D rdac_bus_detach,
> >>>    	.activate =3D rdac_activate,
> >>> +	.match =3D rdac_match,
> >>>    };
> >>>
> >>>    static int rdac_bus_attach(struct scsi_device *sdev)
> >>>
> >> As stated in the other mail, I guess we would need to have a check
> >> if the LUN is in ALUA mode.
> >> And, btw, the _original_ intention was to allow vendor-specific
> >> device_handler to do some better probing, eg querying some
> >> vendor-specific VPD pages.
> >> Especially for RDAC it would make far more sense to query the
> >> existence and format of one of the RDAC-specific VPD pages (eg 0xC=
2,
> >> 0xC4, or 0xC8) and use that for matching.
> >> Then you could do away with the vendor/model array altogether here
> >> and we wouldn't need to update the rdac handler every time a new
> >> array comes out or has been rebranded by some OEM.
> >
> > OK. I will add the check for TPGS. I will send the patches tomorrow=
=2E
> > For sending the VPD pages(0xC2, 0xC4 and 0xC8), I think we need be
>  > little careful here.
> > This includes sending these commands to every possible device in th=
e
>  > system. That is what we want to avoid.
> > I will investigate more on that. That will be my next set of patche=
s
>  > independent of this.
> >
> Fair enough.
> As long as it's understood to be an interim solution, then we would
> only need to check for the TGPS bit.
> Which has the neat side-effect that we don't actually have to do any
> I/O to check this, as the information is already present at that time=
=2E
>=20
> While you're at it, could you please add this check for scsi_dh_emc,
> too?
> The Clariion is also able to run in dual-mode, so the same check is
> required there, too.

Sure..  Will add the check to Clariion also.. =20

>=20
> Cheers,
>=20
> Hannes
> --
> Dr. Hannes Reinecke		      zSeries & Storage
> hare@suse.de			      +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
