From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 2/2] scsi: storvsc: Use the specified target ID in device
 lookup
Date: Tue, 12 Jan 2016 01:04:35 +0000
Message-ID: <BY2PR0301MB165444FAB69D52C96AB052ADA0CA0@BY2PR0301MB1654.namprd03.prod.outlook.com>
References: <1452318697-25451-1-git-send-email-kys@microsoft.com>
 <1452318719-25490-1-git-send-email-kys@microsoft.com>
 <1452318719-25490-2-git-send-email-kys@microsoft.com>
 <56935540.7060304@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0119.outbound.protection.outlook.com ([157.56.111.119]:41570
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759116AbcALBEj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jan 2016 20:04:39 -0500
In-Reply-To: <56935540.7060304@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "apw@canonical.com" <apw@canonical.com>, "vkuznets@redhat.com" <vkuznets@redhat.com>, "jasowang@redhat.com" <jasowang@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>



> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Sunday, January 10, 2016 11:10 PM
> To: KY Srinivasan <kys@microsoft.com>; gregkh@linuxfoundation.org; li=
nux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org; ohering@suse.co=
m;
> jbottomley@parallels.com; hch@infradead.org; linux-scsi@vger.kernel.o=
rg;
> apw@canonical.com; vkuznets@redhat.com; jasowang@redhat.com;
> martin.petersen@oracle.com
> Subject: Re: [PATCH 2/2] scsi: storvsc: Use the specified target ID i=
n device
> lookup
>=20
> On 01/09/2016 06:51 AM, K. Y. Srinivasan wrote:
> > The current code assumes that there is only one target in device lo=
okup.
> > Fix this bug. This will alow us to correctly handle hot reomoval of=
 LUNs.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > ---
> >   drivers/scsi/storvsc_drv.c |    6 ++++--
> >   1 files changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.=
c
> > index 622f64a..5faf357 100644
> > --- a/drivers/scsi/storvsc_drv.c
> > +++ b/drivers/scsi/storvsc_drv.c
> > @@ -479,6 +479,7 @@ struct storvsc_scan_work {
> >   	struct work_struct work;
> >   	struct Scsi_Host *host;
> >   	uint lun;
> > +	uint tgt_id;
> >   };
> >
> >   static void storvsc_device_scan(struct work_struct *work)
> > @@ -490,7 +491,7 @@ static void storvsc_device_scan(struct work_str=
uct
> *work)
> >   	wrk =3D container_of(work, struct storvsc_scan_work, work);
> >   	lun =3D wrk->lun;
> >
> > -	sdev =3D scsi_device_lookup(wrk->host, 0, 0, lun);
> > +	sdev =3D scsi_device_lookup(wrk->host, 0, wrk->tgt_id, lun);
> >   	if (!sdev)
> >   		goto done;
> >   	scsi_rescan_device(&sdev->sdev_gendev);
> > @@ -541,7 +542,7 @@ static void storvsc_remove_lun(struct work_stru=
ct
> *work)
> >   	if (!scsi_host_get(wrk->host))
> >   		goto done;
> >
> > -	sdev =3D scsi_device_lookup(wrk->host, 0, 0, wrk->lun);
> > +	sdev =3D scsi_device_lookup(wrk->host, 0, wrk->tgt_id, wrk->lun);
> >
> >   	if (sdev) {
> >   		scsi_remove_device(sdev);
> > @@ -941,6 +942,7 @@ static void storvsc_handle_error(struct
> vmscsi_request *vm_srb,
> >
> >   	wrk->host =3D host;
> >   	wrk->lun =3D vm_srb->lun;
> > +	wrk->tgt_id =3D vm_srb->target_id;
> >   	INIT_WORK(&wrk->work, process_err_fn);
> >   	schedule_work(&wrk->work);
> >   }
> >
> As a side note, are these really 32-bit values?
> Both the LUN and the target?

No, these are 8 bit values as communicated in the vmscsi_request.

Regards,

K. Y


>=20
> Cheers,
>=20
> Hannes
> --
> Dr. Hannes Reinecke		               zSeries & Storage
> hare@suse.de			               +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
> HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
