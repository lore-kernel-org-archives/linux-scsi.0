From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: RE: [PATCH 13/47] megaraid: pass in NULL scb for host reset
Date: Wed, 28 Jun 2017 23:10:16 +0530
Message-ID: <5443ed26d0465a0a277ccf90fdeb1e73@mail.gmail.com>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
 <1498638793-44672-14-git-send-email-hare@suse.de> <f5b7e09b259b22452afe1da669712af6@mail.gmail.com>
 <ce2005d3-420c-3920-dadc-b9d1d36c8ecc@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:36199 "EHLO
        mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751528AbdF1RkS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jun 2017 13:40:18 -0400
Received: by mail-pf0-f181.google.com with SMTP id q86so36882151pfl.3
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jun 2017 10:40:18 -0700 (PDT)
In-Reply-To: <ce2005d3-420c-3920-dadc-b9d1d36c8ecc@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Sumit Saxena <sumit.saxena@broadcom.com>, Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Hannes Reinecke
> Sent: Wednesday, June 28, 2017 9:00 PM
> To: Sumit Saxena; Christoph Hellwig
> Cc: Martin K. Petersen; James Bottomley; linux-scsi@vger.kernel.org;
> Hannes
> Reinecke
> Subject: Re: [PATCH 13/47] megaraid: pass in NULL scb for host reset
>
> On 06/28/2017 03:41 PM, Sumit Saxena wrote:
> >> -----Original Message-----
> >> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> >> owner@vger.kernel.org] On Behalf Of Hannes Reinecke
> >> Sent: Wednesday, June 28, 2017 2:03 PM
> >> To: Christoph Hellwig
> >> Cc: Martin K. Petersen; James Bottomley; linux-scsi@vger.kernel.org;
> > Hannes
> >> Reinecke; Hannes Reinecke
> >> Subject: [PATCH 13/47] megaraid: pass in NULL scb for host reset
> >>
> >> When calling a host reset we shouldn't rely on the command triggering
> >> the reset, so allow megaraid_abort_and_reset() to be called with a NUL=
L
> scb.
> >> And drop the pointless 'bus_reset' and 'target_reset' handlers, which
> > just call
> >> the same function as host_reset.
> >
> > If this patch address any functional issue, then we should consider
> > this.
> > If it's code optimization, can we ignore this as this is being very
> > old driver and no more maintained by Broadcom/LSI ?
> >
> Sadly, ignoring is not an option.
> I'm planning to update the calling convention for SCSI EH, to resolve the
> long-
> standing problem with sg_reset ioctls.
> sg_reset ioctl will allocate an out-of-band SCSI command, which does no
> longer
> work with the new command allocation scheme in multiqueue.
> So it's not possible to just 'ignore' it, as then SCSI EH will cease to
> function with
> that driver.

Hannes - We are in process of sending megaraid and 3ware driver removal as
LSI/Broadcom  stopped supporting those products.
I agree we should review this closely, but lack of test coverage and end of
life cycle of product is requesting us to know the rational.
For now, let's consider NACK for this patch. We will be removing old
megaraid (mbox) driver and 3Ware drivers soon.

>
> Sorry.
>
> >>
> >> Signed-off-by: Hannes Reinecke <hare@suse.com>
> >> ---
> >> drivers/scsi/megaraid.c | 42
> >> ++++++++++++++++--------------------------
> >> 1 file changed, 16 insertions(+), 26 deletions(-)
> >>
> >> diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c index
> >> 3c63c29..7e504d3 100644
> >> --- a/drivers/scsi/megaraid.c
> >> +++ b/drivers/scsi/megaraid.c
> >> @@ -1909,7 +1909,7 @@ static DEF_SCSI_QCMD(megaraid_queue)
> >>
> >> 	spin_lock_irq(&adapter->lock);
> >>
> >> -	rval =3D  megaraid_abort_and_reset(adapter, cmd, SCB_RESET);
> >> +	rval =3D  megaraid_abort_and_reset(adapter, NULL, SCB_RESET);
> >
> > If cmd=3DNULL is passed, it will crash inside function
> > megaraid_abort_and_reset() while dereferencing "cmd" pointer.
> > Below is the code of function  megaraid_abort_and_reset() where it
> > will
> > crash-
> >
> > static int
> > megaraid_abort_and_reset(adapter_t *adapter, Scsi_Cmnd *cmd, int aor)
> > {
> > 	struct list_head	*pos, *next;
> > 	scb_t			*scb;
> >
> > 	dev_warn(&adapter->dev->dev, "%s cmd=3D%x <c=3D%d t=3D%d l=3D%d>\n",
> > 	     (aor =3D=3D SCB_ABORT)? "ABORTING":"RESET",
> > 	     cmd->cmnd[0],
> > cmd->device->channel,>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>it should
> > cmd->device->crash
> > here
> > 	     cmd->device->id, (u32)cmd->device->lun);
> >
> > Please correct if I am missing something here.Ah, correct. Will be
> > fixing it up.
>
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
