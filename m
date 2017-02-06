From: Shivasharan Srikanteshwara
        <shivasharan.srikanteshwara@broadcom.com>
Subject: RE: [PATCH 09/39] megaraid_sas: NVME Interface detection and prop settings
Date: Mon, 6 Feb 2017 19:25:33 +0530
Message-ID: <a62a837f17711d34a68af62a904a4a6a@mail.gmail.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486375212-17329-10-git-send-email-shivasharan.srikanteshwara@broadcom.com> <996c107a-9a15-3e9e-c510-eb94913d21c7@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f170.google.com ([209.85.216.170]:34090 "EHLO
        mail-qt0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751654AbdBFNzf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2017 08:55:35 -0500
Received: by mail-qt0-f170.google.com with SMTP id w20so100270320qtb.1
        for <linux-scsi@vger.kernel.org>; Mon, 06 Feb 2017 05:55:35 -0800 (PST)
In-Reply-To: <996c107a-9a15-3e9e-c510-eb94913d21c7@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>

> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.com]
> Sent: Monday, February 06, 2017 4:17 PM
> To: Shivasharan S; linux-scsi@vger.kernel.org
> Cc: martin.petersen@oracle.com; thenzl@redhat.com;
> jejb@linux.vnet.ibm.com; kashyap.desai@broadcom.com;
> sumit.saxena@broadcom.com
> Subject: Re: [PATCH 09/39] megaraid_sas: NVME Interface detection and
prop
> settings
>
> On 02/06/2017 10:59 AM, Shivasharan S wrote:
> > New functionality
> > Adding detection logic for NVME device attached behind Ventura
controller.
> > Driver set HostPageSize in IOC_INIT frame to inform about page size
for NVME
> devices.
> > Firmware reports NVME page size to the driver.
> > PD INFO DCMD provide new interface type NVME_PD. Driver set property
of
> NVME device.
> >
> > Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> > Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> > ---
> >  drivers/scsi/megaraid/megaraid_sas.h        |  23 ++--
> >  drivers/scsi/megaraid/megaraid_sas_base.c   | 170
++++++++++++++++++++--
> ------
> >  drivers/scsi/megaraid/megaraid_sas_fusion.c |   6 +-
> >  drivers/scsi/megaraid/megaraid_sas_fusion.h |   2 +-
> >  4 files changed, 142 insertions(+), 59 deletions(-)
> >
> [ .. ]
> > @@ -3983,18 +4037,22 @@ dcmd_timeout_ocr_possible(struct
> megasas_instance *instance) {
> >  		return INITIATE_OCR;
> >  }
> >
> > -static int
> > -megasas_get_pd_info(struct megasas_instance *instance, u16 device_id)
> > +static void
> > +megasas_get_pd_info(struct megasas_instance *instance, struct
> > +scsi_device *sdev)
> >  {
> >  	int ret;
> >  	struct megasas_cmd *cmd;
> >  	struct megasas_dcmd_frame *dcmd;
> >
> > +	struct MR_PRIV_DEVICE *mr_device_priv_data;
> > +	u16 device_id =3D 0;
> > +
> > +	device_id =3D (sdev->channel * MEGASAS_MAX_DEV_PER_CHANNEL) +
> > +sdev->id;
> >  	cmd =3D megasas_get_cmd(instance);
> >
> >  	if (!cmd) {
> >  		dev_err(&instance->pdev->dev, "Failed to get cmd %s\n",
> __func__);
> > -		return -ENOMEM;
> > +		return;
> >  	}
> >
> >  	dcmd =3D &cmd->frame->dcmd;
> > @@ -4021,7 +4079,9 @@ megasas_get_pd_info(struct megasas_instance
> > *instance, u16 device_id)
> >
> >  	switch (ret) {
> >  	case DCMD_SUCCESS:
> > -		instance->pd_list[device_id].interface =3D
> > +		mr_device_priv_data =3D sdev->hostdata;
> > +		le16_to_cpus((u16 *)&instance->pd_info->state.ddf.pdType);
> > +		mr_device_priv_data->interface_type =3D
> >  				instance->pd_info->state.ddf.pdType.intf;
> >  		break;
> >
> > @@ -4048,7 +4108,7 @@ megasas_get_pd_info(struct megasas_instance
> *instance, u16 device_id)
> >  	if (ret !=3D DCMD_TIMEOUT)
> >  		megasas_return_cmd(instance, cmd);
> >
> > -	return ret;
> > +	return;
> >  }
> >  /*
> >   * megasas_get_pd_list_info -	Returns FW's pd_list structure
> Please don't do this.
> There's a valid reason why there is return value in the first place (hot
removal of
> devices IIRC), and it's always good manners to provide for an error path
instead
> of assuming that everything will be fine.

megasas_get_pd_info is called to get "interface type" (SAS, SATA or NVME)
of non-RAID disks. The interface type is used in IO path (applicable only
for
NVME based non-RAID disks) and also used for setting the device queue
depth.
Even if this function returns some error, driver is not going to do
anything but
continue in low performance mode (for NVME based non-RAID disks driver
will
not form native PRPs and device QD will be set to default value).
>
> And, incidentally, this has nothing to do with the NVMe backend changes,
right?

The "interface type" tells the driver whether a drive is NVME based or
not. And
if NVME, then we form PRPs.

Thanks,
Shivasharan
>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke		               zSeries & Storage
> hare@suse.com			               +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: F. Imend=C3=B6rffer, J. Smithard, D. Upmanyu, G. Norton HRB 21284 (AG
> N=C3=BCrnberg)
