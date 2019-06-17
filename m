From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH] scsi: storvsc: Add ability to change scsi queue depth
Date: Mon, 17 Jun 2019 17:08:21 +0000
Message-ID: <DM5PR2101MB1061E9107B0B71FC26433BA8A0EB0@DM5PR2101MB1061.namprd21.prod.outlook.com>
References: <20190614234822.5193-1-brandonbonaby94@gmail.com>
 <BL0PR2101MB13482F73342F77866D6A6AABD7E90@BL0PR2101MB1348.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <BL0PR2101MB13482F73342F77866D6A6AABD7E90@BL0PR2101MB1348.namprd21.prod.outlook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Kelley <mikelley@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Stephen Hemminger <sthemmin@microsoft.com>, "sashal@kernel.org" <sashal@kernel.org>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: brandonbonaby94 <brandonbonaby94@gmail.com>, "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Michael Kelley <mikelley@microsoft.com>
> Sent: Saturday, June 15, 2019 11:19 AM
> To: brandonbonaby94 <brandonbonaby94@gmail.com>; KY Srinivasan
> <kys@microsoft.com>; Haiyang Zhang <haiyangz@microsoft.com>; Stephen
> Hemminger <sthemmin@microsoft.com>; sashal@kernel.org;
> jejb@linux.ibm.com; martin.petersen@oracle.com
> Cc: brandonbonaby94 <brandonbonaby94@gmail.com>; linux-
> hyperv@vger.kernel.org; linux-scsi@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: RE: [PATCH] scsi: storvsc: Add ability to change scsi queue dept=
h
>=20
> From: Branden Bonaby <brandonbonaby94@gmail.com> Sent: Friday, June
> 14, 2019 4:48 PM
> >
> > Adding functionality to allow the SCSI queue depth to be changed,
> > by utilizing the "scsi_change_queue_depth" function.
> >
> > Signed-off-by: Branden Bonaby <brandonbonaby94@gmail.com>
> > ---
> >  drivers/scsi/storvsc_drv.c | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> >
> > diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> > index 8472de1007ff..719ca9906fc2 100644
> > --- a/drivers/scsi/storvsc_drv.c
> > +++ b/drivers/scsi/storvsc_drv.c
> > @@ -387,6 +387,7 @@ enum storvsc_request_type {
> >
> >  static int storvsc_ringbuffer_size =3D (128 * 1024);
> >  static u32 max_outstanding_req_per_channel;
> > +static int storvsc_change_queue_depth(struct scsi_device *sdev, int
> queue_depth);
> >
> >  static int storvsc_vcpus_per_sub_channel =3D 4;
> >
> > @@ -1711,6 +1712,7 @@ static struct scsi_host_template scsi_driver =3D =
{
> >  	.dma_boundary =3D		PAGE_SIZE-1,
> >  	.no_write_same =3D	1,
> >  	.track_queue_depth =3D	1,
> > +	.change_queue_depth =3D	storvsc_change_queue_depth,
> >  };
> >
> >  enum {
> > @@ -1917,6 +1919,15 @@ static int storvsc_probe(struct hv_device
> *device,
> >  	return ret;
> >  }
> >
> > +/* Change a scsi target's queue depth */
> > +static int storvsc_change_queue_depth(struct scsi_device *sdev, int
> queue_depth)
> > +{
> > +	if (queue_depth > scsi_driver.can_queue){
> > +		queue_depth =3D scsi_driver.can_queue;
> > +	}
> > +	return scsi_change_queue_depth(sdev, queue_depth);
> > +}
> > +
> >  static int storvsc_remove(struct hv_device *dev)
> >  {
> >  	struct storvsc_device *stor_device =3D hv_get_drvdata(dev);
> > --
> > 2.17.1
>=20
> Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
