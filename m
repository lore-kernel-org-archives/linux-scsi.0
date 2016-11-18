From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: RE: [PATCH 5/5] megaraid_sas: add mmio barrier after register writes
Date: Fri, 18 Nov 2016 22:18:47 +0530
Message-ID: <67e94cdd16a9f55f3a73a12a13330ed0@mail.gmail.com>
References: <1478857492-4581-1-git-send-email-hare@suse.de>
 <1478857492-4581-6-git-send-email-hare@suse.de> <5f6fcc3e-a48f-7909-c409-1d265ea9135c@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:34695 "EHLO
        mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752724AbcKRQsu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Nov 2016 11:48:50 -0500
Received: by mail-qk0-f173.google.com with SMTP id q130so270706539qke.1
        for <linux-scsi@vger.kernel.org>; Fri, 18 Nov 2016 08:48:49 -0800 (PST)
In-Reply-To: <5f6fcc3e-a48f-7909-c409-1d265ea9135c@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Sumit Saxena <sumit.saxena@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Tomas Henzl
> Sent: Friday, November 18, 2016 9:23 PM
> To: Hannes Reinecke; Martin K. Petersen
> Cc: Christoph Hellwig; James Bottomley; Sumit Saxena; linux-
> scsi@vger.kernel.org; Hannes Reinecke
> Subject: Re: [PATCH 5/5] megaraid_sas: add mmio barrier after register
writes
>
> On 11.11.2016 10:44, Hannes Reinecke wrote:
> > The megaraid_sas HBA only has a single register for I/O submission,
> > which will be hit pretty hard with scsi-mq. To ensure that the PCI
> > writes have made it across we need to add a mmio barrier after each
> > write; otherwise I've been seeing spurious command completions and I/O
> > stalls.
>
> Why is it needed that the PCI write reaches the hw exactly at this
point?
> Is it possible that this is a hw deficiency like that the hw can't
handle
> communication without tiny pauses, and so possible to remove in next
> generation?
> Thanks,
> Tomas

I think this is good to have mmiowb as we are already doing  for writel()
version of megasas_return_cmd_fusion.
May be not for x86, but for some other CPU arch it is useful. I think it
become more evident while scs-mq support for more than one submission
queue patch of Hannes expose this issue.

Probably this patch is good. Intermediate PCI device (PCI bridge ?)  may
cache PCI packet and eventually out of order PCI packet to MegaRAID HBA
can cause this type of spurious completion.

>
> >
> > Signed-off-by: Hannes Reinecke <hare@suse.com>
> > ---
> >  drivers/scsi/megaraid/megaraid_sas_fusion.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> > b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> > index aba53c0..729a654 100644
> > --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> > +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> > @@ -196,6 +196,7 @@ inline void megasas_return_cmd_fusion(struct
> megasas_instance *instance,
> >  			le32_to_cpu(req_desc->u.low));
> >
> >  	writeq(req_data, &instance->reg_set->inbound_low_queue_port);
> > +	mmiowb();
> >  #else
> >  	unsigned long flags;
> >
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of
> a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
