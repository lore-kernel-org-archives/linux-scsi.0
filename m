From: Shivasharan Srikanteshwara
        <shivasharan.srikanteshwara@broadcom.com>
Subject: RE: [PATCH 06/39] megaraid_sas: RAID map is accessed for SYS PDs when
 use_seqnum_jbod_fp is not set
Date: Mon, 6 Feb 2017 18:46:20 +0530
Message-ID: <d67529a5f967e12777573e626e7dfc7b@mail.gmail.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486375212-17329-7-git-send-email-shivasharan.srikanteshwara@broadcom.com> <50d9298c-1f4e-9f4c-b5dd-61bca957c76f@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f182.google.com ([209.85.216.182]:35049 "EHLO
        mail-qt0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750950AbdBFNQW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2017 08:16:22 -0500
Received: by mail-qt0-f182.google.com with SMTP id x49so103977524qtc.2
        for <linux-scsi@vger.kernel.org>; Mon, 06 Feb 2017 05:16:22 -0800 (PST)
In-Reply-To: <50d9298c-1f4e-9f4c-b5dd-61bca957c76f@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>

> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.com]
> Sent: Monday, February 06, 2017 4:11 PM
> To: Shivasharan S; linux-scsi@vger.kernel.org
> Cc: martin.petersen@oracle.com; thenzl@redhat.com;
> jejb@linux.vnet.ibm.com; kashyap.desai@broadcom.com;
> sumit.saxena@broadcom.com
> Subject: Re: [PATCH 06/39] megaraid_sas: RAID map is accessed for SYS
PDs
> when use_seqnum_jbod_fp is not set
>
> On 02/06/2017 10:59 AM, Shivasharan S wrote:
> > Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> > Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> > ---
> >  drivers/scsi/megaraid/megaraid_sas_base.c | 25
> > ++++++++++++++-----------
> >  1 file changed, 14 insertions(+), 11 deletions(-)
> >
> > diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
> > b/drivers/scsi/megaraid/megaraid_sas_base.c
> > index 6ca49ef..67a205a 100644
> > --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> > +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> > @@ -1756,28 +1756,31 @@ void megasas_update_sdev_properties(struct
> scsi_device *sdev)
> >  	fusion =3D instance->ctrl_context;
> >  	mr_device_priv_data =3D sdev->hostdata;
> >
> > -	if (!fusion)
> > +	if (!fusion || !mr_device_priv_data)
> >  		return;
> >
> > -	if (!MEGASAS_IS_LOGICAL(sdev) &&
> > -		instance->use_seqnum_jbod_fp) {
> > -		pd_index =3D (sdev->channel *
> MEGASAS_MAX_DEV_PER_CHANNEL) +
> > -			sdev->id;
> > -		pd_sync =3D (void *)fusion->pd_seq_sync
> > -				[(instance->pd_seq_map_id - 1) & 1];
> > -		mr_device_priv_data->is_tm_capable =3D
> > -			pd_sync->seq[pd_index].capability.tmCapable;
> > -	} else {
> > +	if (MEGASAS_IS_LOGICAL(sdev)) {
> >  		device_id =3D ((sdev->channel % 2) *
> MEGASAS_MAX_DEV_PER_CHANNEL)
> >  					+ sdev->id;
> >  		local_map_ptr =3D fusion->ld_drv_map[(instance->map_id &
1)];
> >  		ld =3D MR_TargetIdToLdGet(device_id, local_map_ptr);
> > +		if (ld >=3D instance->fw_supported_vd_count)
> > +			return;
> >  		raid =3D MR_LdRaidGet(ld, local_map_ptr);
> >
> >  		if (raid->capability.ldPiMode =3D=3D
> MR_PROT_INFO_TYPE_CONTROLLER)
> > -		blk_queue_update_dma_alignment(sdev->request_queue, 0x7);
> > +			blk_queue_update_dma_alignment(sdev-
> >request_queue,
> > +						       0x7);
> > +
> >  		mr_device_priv_data->is_tm_capable =3D
> >  			raid->capability.tmCapable;
> > +	} else if (instance->use_seqnum_jbod_fp) {
> > +		pd_index =3D (sdev->channel *
> MEGASAS_MAX_DEV_PER_CHANNEL) +
> > +				sdev->id;
> > +		pd_sync =3D (void *)fusion->pd_seq_sync
> > +				[(instance->pd_seq_map_id - 1) & 1];
> > +		mr_device_priv_data->is_tm_capable =3D
> > +
pd_sync->seq[pd_index].capability.tmCapable;
> >  	}
> >  }
> >
> >
> Don't you need a sanity check on pd_index, too?
> Otherwise you easily overflow the ->seq array ...

"pd_index" sanity check is not really required here. pd_index is function
of "sdev->id", "sdev->channel" and  MEGASAS_MAX_DEV_PER_CHANNEL.
Here sdev->channel can either be 0 or 1 as it is under
"!MEGASAS_IS_LOGICAL(sdev)", and sdev->id cannot be greater than
127(MEGASAS_MAX_DEV_PER_CHANNEL -1).
So maximum possible value of pd_index is 255(256th element) and
fusion->pd_seq_sync->seq array size is 256.
So pd_index should not overflow fusion->pd_seq_sync->seq array.
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
