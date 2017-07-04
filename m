From: Shivasharan Srikanteshwara
        <shivasharan.srikanteshwara@broadcom.com>
Subject: RE: [PATCH 04/15] megaraid_sas: Call megasas_complete_cmd_dpc_fusion
 every 1 second while there are pending commands
Date: Tue, 4 Jul 2017 12:35:14 +0530
Message-ID: <1299ef3826363cdc5e14ab2b98f7337f@mail.gmail.com>
References: <1498811409-11157-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1498811409-11157-5-git-send-email-shivasharan.srikanteshwara@broadcom.com> <3db566c3-6641-90a5-4b41-18c8c78ac953@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:35762 "EHLO
        mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751614AbdGDHFQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Jul 2017 03:05:16 -0400
Received: by mail-qk0-f175.google.com with SMTP id 16so161962033qkg.2
        for <linux-scsi@vger.kernel.org>; Tue, 04 Jul 2017 00:05:16 -0700 (PDT)
In-Reply-To: <3db566c3-6641-90a5-4b41-18c8c78ac953@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, hare@suse.com, hch@lst.de

> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Friday, June 30, 2017 6:55 PM
> To: Shivasharan S; linux-scsi@vger.kernel.org
> Cc: martin.petersen@oracle.com; thenzl@redhat.com;
> jejb@linux.vnet.ibm.com; kashyap.desai@broadcom.com;
> sumit.saxena@broadcom.com; hare@suse.com; hch@lst.de
> Subject: Re: [PATCH 04/15] megaraid_sas: Call
> megasas_complete_cmd_dpc_fusion every 1 second while there are pending
> commands
>
> On 06/30/2017 10:29 AM, Shivasharan S wrote:
> > Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> > Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> > ---
> >  drivers/scsi/megaraid/megaraid_sas_fusion.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> > b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> > index 5018a3f..0f13c58 100644
> > --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> > +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> > @@ -3552,6 +3552,7 @@ int megasas_wait_for_outstanding_fusion(struct
> megasas_instance *instance,
> >  			}
> >  		}
> >
> > +		megasas_complete_cmd_dpc_fusion((unsigned long)instance);
> >  		outstanding =3D atomic_read(&instance->fw_outstanding);
> >  		if (!outstanding)
> >  			goto out;
> > @@ -3560,8 +3561,6 @@ int megasas_wait_for_outstanding_fusion(struct
> megasas_instance *instance,
> >  			dev_notice(&instance->pdev->dev, "[%2d]waiting for
> %d "
> >  			       "commands to complete for scsi%d\n", i,
> >  			       outstanding, instance->host->host_no);
> > -			megasas_complete_cmd_dpc_fusion(
> > -				(unsigned long)instance);
> >  		}
> >  		msleep(1000);
> >  	}
> >
> Please add a changelog why this is necessary.
>

Sure Hannes. I will update the commit description with the details
and send out v2 of the series.

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
