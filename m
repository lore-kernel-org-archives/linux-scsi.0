From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: RE: [PATCH 5/5] megaraid_sas: add mmio barrier after register writes
Date: Wed, 30 Nov 2016 11:44:27 +0530
Message-ID: <c78dcfafac5db59a00224b812866e375@mail.gmail.com>
References: <1478857492-4581-1-git-send-email-hare@suse.de>
 <1478857492-4581-6-git-send-email-hare@suse.de> <5f6fcc3e-a48f-7909-c409-1d265ea9135c@redhat.com>
 <67e94cdd16a9f55f3a73a12a13330ed0@mail.gmail.com> <3c317f7a-f82e-a531-1056-ead1ec7eda5a@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f175.google.com ([209.85.216.175]:35814 "EHLO
        mail-qt0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751606AbcK3GWR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Nov 2016 01:22:17 -0500
Received: by mail-qt0-f175.google.com with SMTP id c47so178886209qtc.2
        for <linux-scsi@vger.kernel.org>; Tue, 29 Nov 2016 22:22:11 -0800 (PST)
In-Reply-To: <3c317f7a-f82e-a531-1056-ead1ec7eda5a@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Sumit Saxena <sumit.saxena@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

> -----Original Message-----
> From: Tomas Henzl [mailto:thenzl@redhat.com]
> Sent: Monday, November 21, 2016 9:27 PM
> To: Kashyap Desai; Hannes Reinecke; Martin K. Petersen
> Cc: Christoph Hellwig; James Bottomley; Sumit Saxena; linux-
> scsi@vger.kernel.org; Hannes Reinecke
> Subject: Re: [PATCH 5/5] megaraid_sas: add mmio barrier after register
> writes
>
> On 18.11.2016 17:48, Kashyap Desai wrote:
> >> -----Original Message-----
> >> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> >> owner@vger.kernel.org] On Behalf Of Tomas Henzl
> >> Sent: Friday, November 18, 2016 9:23 PM
> >> To: Hannes Reinecke; Martin K. Petersen
> >> Cc: Christoph Hellwig; James Bottomley; Sumit Saxena; linux-
> >> scsi@vger.kernel.org; Hannes Reinecke
> >> Subject: Re: [PATCH 5/5] megaraid_sas: add mmio barrier after
> >> register
> > writes
> >> On 11.11.2016 10:44, Hannes Reinecke wrote:
> >>> The megaraid_sas HBA only has a single register for I/O submission,
> >>> which will be hit pretty hard with scsi-mq. To ensure that the PCI
> >>> writes have made it across we need to add a mmio barrier after each
> >>> write; otherwise I've been seeing spurious command completions and
> >>> I/O stalls.
> >> Why is it needed that the PCI write reaches the hw exactly at this
> > point?
> >> Is it possible that this is a hw deficiency like that the hw can't
> > handle
> >> communication without tiny pauses, and so possible to remove in next
> >> generation?
> >> Thanks,
> >> Tomas
> > I think this is good to have mmiowb as we are already doing  for
> > writel() version of megasas_return_cmd_fusion.
> > May be not for x86, but for some other CPU arch it is useful. I think
> > it become more evident while scs-mq support for more than one
> > submission queue patch of Hannes expose this issue.
> >
> > Probably this patch is good. Intermediate PCI device (PCI bridge ?)
> > may cache PCI packet and eventually out of order PCI packet to
> > MegaRAID HBA can cause this type of spurious completion.
>
> Usually drivers do not add a write barrier after every pci write, unless
> like here in
> megasas_fire_cmd_fusion in the 32bit part where are two paired writes and
> it
> must be ensured that the pair arrives without any other write in between.
>
> Why is it wrong when a pci write is overtaken by another write or when
> happens
> a bit later and if it is wrong - don't we need an additional locking too ?
> The execution of  megasas_fire_cmd_fusion might be interrupted and a delay
> can happen at any time.

Since Hannes mentioned that with his experiment of mq megaraid_sas patch and
creating more Submission queue to SML cause invalid/suprious completion in
his code, I am trying to understand if " mmiowb" after writeq() call is safe
?  My understanding is "writeq" is atomic and it will have two 32bit PCI
WRITE in same sequence reaching to PCI end device. Assuming there will not
be PCI level caching on Intel x86 platform.  E.g if we have two CPU
executing writeq(), PCI write will always reach to end device in same
sequence. Assume ...Tag-1, Tag-2, Tag-3 and Tag-4 is expected sequence.  In
case of any optimization at system level, if device see Tag-1, Tag-3, Tag-2,
Tag-4 arrives,  then we may see the issue as Hannes experience.  We have
experience very rare instance of dual/spurious SMID completion  on released
megaraid_sas driver and not easy to be reproduced...so thinking on those
line, is this easy to reproduce such issue opening more submission queue to
SML (just to reproduce spurious completion effectively). We will apply all
the patches posted by Hannes *just* to understand this particular spurious
completion issue and understand in what condition it will impact.

We will post if this mmiowb() call after writeq() is good to have.

~ Kashyap

>
> tomash
>
> >
> >>> Signed-off-by: Hannes Reinecke <hare@suse.com>
> >>> ---
> >>>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 1 +
> >>>  1 file changed, 1 insertion(+)
> >>>
> >>> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> >>> b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> >>> index aba53c0..729a654 100644
> >>> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> >>> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> >>> @@ -196,6 +196,7 @@ inline void megasas_return_cmd_fusion(struct
> >> megasas_instance *instance,
> >>>  			le32_to_cpu(req_desc->u.low));
> >>>
> >>>  	writeq(req_data, &instance->reg_set->inbound_low_queue_port);
> >>> +	mmiowb();
> >>>  #else
> >>>  	unsigned long flags;
> >>>
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> >> in
> > the body of
> >> a message to majordomo@vger.kernel.org More majordomo info at
> >> http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> > in the body of a message to majordomo@vger.kernel.org More majordomo
> > info at  http://vger.kernel.org/majordomo-info.html
>
