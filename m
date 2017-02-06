From: Shivasharan Srikanteshwara
        <shivasharan.srikanteshwara@broadcom.com>
Subject: RE: [PATCH 04/39] megaraid_sas: 32 bit descriptor fire cmd optimization
Date: Mon, 6 Feb 2017 16:08:26 +0530
Message-ID: <3d12467daa28674de019813eef149f43@mail.gmail.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486375212-17329-5-git-send-email-shivasharan.srikanteshwara@broadcom.com> <2469ec36-b690-dba5-effa-3dc9f6c45954@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f181.google.com ([209.85.220.181]:33603 "EHLO
        mail-qk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751093AbdBFKkn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2017 05:40:43 -0500
Received: by mail-qk0-f181.google.com with SMTP id s140so50449307qke.0
        for <linux-scsi@vger.kernel.org>; Mon, 06 Feb 2017 02:40:43 -0800 (PST)
In-Reply-To: <2469ec36-b690-dba5-effa-3dc9f6c45954@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>

> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.com]
> Sent: Monday, February 06, 2017 3:54 PM
> To: Shivasharan S; linux-scsi@vger.kernel.org
> Cc: martin.petersen@oracle.com; thenzl@redhat.com;
> jejb@linux.vnet.ibm.com; kashyap.desai@broadcom.com;
> sumit.saxena@broadcom.com
> Subject: Re: [PATCH 04/39] megaraid_sas: 32 bit descriptor fire cmd
> optimization
>
> On 02/06/2017 10:59 AM, Shivasharan S wrote:
> > No functional change. Code refactor.
> > megasas_fire_cmd_fusion can always use 32 bit descriptor write for
ventura.
> No need to pass extra flag.
> > Only IOC INIT required 64 bit Descriptor write.
> >
> > Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> > Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> > ---
> >  drivers/scsi/megaraid/megaraid_sas_fusion.c | 65
> > +++++++++++++++--------------
> >  1 file changed, 33 insertions(+), 32 deletions(-)
> >
> [ .. ]
> > @@ -897,7 +893,14 @@ megasas_ioc_init_fusion(struct megasas_instance
> *instance)
> >  			break;
> >  	}
> >
> > -	megasas_fire_cmd_fusion(instance, &req_desc, false);
> > +	/* For Ventura also IOC INIT required 64 bit Descriptor write. */
> > +	spin_lock_irqsave(&instance->hba_lock, flags);
> > +	writel(le32_to_cpu(req_desc.u.low),
> > +	       &instance->reg_set->inbound_low_queue_port);
> > +	writel(le32_to_cpu(req_desc.u.high),
> > +	       &instance->reg_set->inbound_high_queue_port);
> > +	mmiowb();
> > +	spin_unlock_irqrestore(&instance->hba_lock, flags);
> >
> >  	wait_and_poll(instance, cmd, MFI_POLL_TIMEOUT_SECS);
> >
> You are missing the 64 bit writeq improvements here.

We have to use writeq() with additional checks " #if defined(writeq) &&
defined(CONFIG_64BIT)" as some arch still wants two PCI write as they do
not have writeq() support.
Since this is a one-time IOC INIT operation we should be good to keep
simple code avoiding writeq() usage.
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
