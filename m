From: =?Windows-1252?Q?Str=F6sser=2C_Bodo?=
	<bodo.stroesser@ts.fujitsu.com>
Subject: RE: [PATCH] lpfc: in sli3 use configured sg_seg_cnt for sg_tablesize
Date: Fri, 29 May 2015 16:12:02 +0200
Message-ID: <8B06D1E6480A6747B23FEC34909D2B5EAFC6B5D7E3@ABGEX70E.FSC.NET>
References: <10f4d2$5t7km8@dgate20u.abg.fsc.net>
 <55687215.4050300@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dgate10.ts.fujitsu.com ([80.70.172.49]:44171 "EHLO
	dgate10.ts.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755119AbbE2OWF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 May 2015 10:22:05 -0400
In-Reply-To: <55687215.4050300@avagotech.com>
Content-Language: de-DE
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Yes, we normally use 128, as this is the value best suited
for our RAID systems. After upgrading the software we saw
a clear performance reduction that was caused by the bug.

With the fix everything works fine again.

Thank you,
Bodo

> -----Original Message-----
> From: James Smart [mailto:james.smart@avagotech.com]
> Sent: Friday, May 29, 2015 4:05 PM
> To: Str=F6sser, Bodo; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH] lpfc: in sli3 use configured sg_seg_cnt for sg_t=
ablesize
>=20
> Bodo,
>=20
> This is a valid fix.  Thank you.
>=20
> I assume you were changing the driver module parameter to up the SG
> count ?  without the fix we would have been capped at 64 sges.
>=20
> -- james
>=20
> Reviewed-By: James Smart <james.smart@avagotech.com>
>=20
>=20
>=20
> On 5/29/2015 8:22 AM, bstroesser@ts.fujitsu.com wrote:
> > Hi James,
> >
> > We had some performance problems with RAID systems connected to LPe=
12k.
> > AFAICS, the reason is a small bug in lpfc.ko, causing the IO-size t=
o
> > be smaller than expected.
> >
> > The patch below fixes it for us.
> >
> > Please CC me, I'm not on the list.
> >
> > Best regards
> > Bodo
> >
> >
> > ------------------------------------------------------
> >
> > From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
> > Date: Fri, 29 May 2015 13:34:19 +0200
> > Subject: [PATCH] lpfc: in sli3 use configured sg_seg_cnt for sg_tab=
lesize
> >
> > Currently the module parameter lpfc_sg_seg_count does not have effe=
ct
> > for sli3 devices.
> >
> > In lpfc_sli_driver_resource_setup(), which is used for sli3, the co=
de
> > writes the configured sg_seg_cnt into lpfc_template.sg_tablesize.
> > But lpfc_template is the template used for sli4 only. Thus the valu=
e should
> > correctly be written to lpfc_template_s3->sg_tablesize.
> >
> > This patch is for kernel 4.1-rc5, but is tested with lpfc 10.2.405.=
26 only.
> >
> > Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
> > ---
> >
> > --- a/drivers/scsi/lpfc/lpfc_init.c	2015-05-29 10:19:02.000000000 +=
0200
> > +++ b/drivers/scsi/lpfc/lpfc_init.c	2015-05-29 10:19:56.000000000 +=
0200
> > @@ -4988,7 +4988,7 @@ lpfc_sli_driver_resource_setup(struct lp
> >
> >   	/* Initialize the host templates the configured values. */
> >   	lpfc_vport_template.sg_tablesize =3D phba->cfg_sg_seg_cnt;
> > -	lpfc_template.sg_tablesize =3D phba->cfg_sg_seg_cnt;
> > +	lpfc_template_s3.sg_tablesize =3D phba->cfg_sg_seg_cnt;
> >
> >   	/* There are going to be 2 reserved BDEs: 1 FCP cmnd + 1 FCP rsp=
 */
> >   	if (phba->cfg_enable_bg) {

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
