From: Shivasharan Srikanteshwara
        <shivasharan.srikanteshwara@broadcom.com>
Subject: RE: [PATCH 11/15] megaraid_sas: Set device queue_depth same as HBA
 can_queue value in scsi-mq mode
Date: Tue, 4 Jul 2017 12:52:21 +0530
Message-ID: <a84688d6248fd1ddb6cb7f001a941936@mail.gmail.com>
References: <1498811409-11157-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1498811409-11157-12-git-send-email-shivasharan.srikanteshwara@broadcom.com> <40da55a6-77c5-340d-17cd-fae3c6f4c097@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:35837 "EHLO
        mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752135AbdGDHWX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Jul 2017 03:22:23 -0400
Received: by mail-qk0-f173.google.com with SMTP id 16so162228663qkg.2
        for <linux-scsi@vger.kernel.org>; Tue, 04 Jul 2017 00:22:22 -0700 (PDT)
In-Reply-To: <40da55a6-77c5-340d-17cd-fae3c6f4c097@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, hare@suse.com, hch@lst.de

> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Friday, June 30, 2017 7:10 PM
> To: Shivasharan S; linux-scsi@vger.kernel.org
> Cc: martin.petersen@oracle.com; thenzl@redhat.com;
> jejb@linux.vnet.ibm.com; kashyap.desai@broadcom.com;
> sumit.saxena@broadcom.com; hare@suse.com; hch@lst.de
> Subject: Re: [PATCH 11/15] megaraid_sas: Set device queue_depth same as
> HBA
> can_queue value in scsi-mq mode
>
> On 06/30/2017 10:30 AM, Shivasharan S wrote:
> > Currently driver sets default queue_depth for VDs at 256 and JBODs
> > based on interface type, ie., for SAS JBOD QD will be 64, for SATA JBOD
> > QD will
> be 32.
> > During performance runs with scsi-mq enabled, we are seeing better
> > results by setting QD same as HBA queue_depth.
> >
> > Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> > Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> > ---
> >  drivers/scsi/megaraid/megaraid_sas_base.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
> > b/drivers/scsi/megaraid/megaraid_sas_base.c
> > index 0230929..c200f1a 100644
> > --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> > +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> > @@ -1891,7 +1891,8 @@ static void
> megasas_set_static_target_properties(struct scsi_device *sdev,
> >  	if (instance->nvme_page_size && max_io_size_kb)
> >  		megasas_set_nvme_device_properties(sdev, (max_io_size_kb
> << 10));
> >
> > -	scsi_change_queue_depth(sdev, device_qd);
> > +	if (!shost_use_blk_mq(sdev->host))
> > +		scsi_change_queue_depth(sdev, device_qd);
> >
> >  }
> >
> > @@ -5914,6 +5915,9 @@ static int megasas_io_attach(struct
> megasas_instance *instance)
> >  	host->max_lun =3D MEGASAS_MAX_LUN;
> >  	host->max_cmd_len =3D 16;
> >
> > +	if (shost_use_blk_mq(host))
> > +		host->cmd_per_lun =3D host->can_queue;
> > +
> >  	/*
> >  	 * Notify the mid-layer about the new controller
> >  	 */
> >
> Is this bit really necessary? It will be adjusted by the above hunk, woul=
d
> it not?
>

The default cmd_per_lun is now set to 256 (MEGASAS_DEFAULT_CMD_PER_LUN).
In the above snip, we are changing cmd_per_lun to be equal to HBA
queue_depth for multiqueue enabled case.
So any scsi_device getting configured with scsi-mq enabled will have
queue_depth
set to cmd_per_lun value.
The hunk in megasas_set_static_target_properties is to update
the queue_depth for non-mq case only based on value provided by firmware.

Thanks,
Shivasharan

> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke		   Teamlead Storage & Networking
> hare@suse.de			               +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton HRB=
 21284
> (AG
> N=C3=BCrnberg)
