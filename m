From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH] scsi: Add QEMU CD-ROM to VPD Inquiry Blacklist
Date: Mon, 06 Jun 2016 10:11:39 -0400
Message-ID: <1465222299.20724.114.camel@localhost.localdomain>
References: <1464702149-26573-1-git-send-email-emilne@redhat.com>
	 <5755278E.8040002@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753098AbcFFOLk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Jun 2016 10:11:40 -0400
In-Reply-To: <5755278E.8040002@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org



On Mon, 2016-06-06 at 09:34 +0200, Hannes Reinecke wrote:
> On 05/31/2016 03:42 PM, Ewan D. Milne wrote:
> > Linux fails to boot as a guest with a QEMU CD-ROM:
> > 
> > [    4.439488] ata2.00: ATAPI: QEMU CD-ROM, 0.8.2, max UDMA/100
> > [    4.443649] ata2.00: configured for MWDMA2
> > [    4.450267] scsi 1:0:0:0: CD-ROM            QEMU     QEMU CD-ROM      0.8. PQ: 0 ANSI: 5
> > [    4.464317] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
> > [    4.464319] ata2.00: BMDMA stat 0x5
> > [    4.464339] ata2.00: cmd a0/01:00:00:00:01/00:00:00:00:00/a0 tag 0 dma 16640 in
> > [    4.464339]          Inquiry 12 01 00 00 ff 00res 48/20:02:00:24:00/00:00:00:00:00/a0 Emask 0x2 (HSM violation)
> > [    4.464341] ata2.00: status: { DRDY DRQ }
> > [    4.465864] ata2: soft resetting link
> > [    4.625971] ata2.00: configured for MWDMA2
> > [    4.628290] ata2: EH complete
> > [    4.646670] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
> > [    4.646671] ata2.00: BMDMA stat 0x5
> > [    4.646683] ata2.00: cmd a0/01:00:00:00:01/00:00:00:00:00/a0 tag 0 dma 16640 in
> > [    4.646683]          Inquiry 12 01 00 00 ff 00res 48/20:02:00:24:00/00:00:00:00:00/a0 Emask 0x2 (HSM violation)
> > [    4.646685] ata2.00: status: { DRDY DRQ }
> > [    4.648193] ata2: soft resetting link
> > 
> > ...
> > 
> > Fix this by suppressing VPD inquiry for this device.
> > 
> > Reported-by: Jan Stancek <jstancek@redhat.com>
> > Tested-by: Jan Stancek <jstancek@redhat.com>
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> > ---
> >  drivers/scsi/scsi_devinfo.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
> > index bbfbfd9..09bbd3f 100644
> > --- a/drivers/scsi/scsi_devinfo.c
> > +++ b/drivers/scsi/scsi_devinfo.c
> > @@ -228,6 +228,7 @@ static struct {
> >  	{"PIONEER", "CD-ROM DRM-624X", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
> >  	{"Promise", "VTrak E610f", NULL, BLIST_SPARSELUN | BLIST_NO_RSOC},
> >  	{"Promise", "", NULL, BLIST_SPARSELUN},
> > +	{"QEMU", "QEMU CD-ROM", NULL, BLIST_SKIP_VPD_PAGES},
> >  	{"QNAP", "iSCSI Storage", NULL, BLIST_MAX_1024},
> >  	{"SYNOLOGY", "iSCSI Storage", NULL, BLIST_MAX_1024},
> >  	{"QUANTUM", "XP34301", "1071", BLIST_NOTQ},
> > 
> This doesn't apply to all versions of QEMU (upstream qemu works fine),
> so at the very least it needs to be restricted to a specific version.

Well, the "0.8." version shown above definitely didn't work.

> 
> At the same time I'd _rather_ like to figure out why things break in the
> first place.
> QEMU CD-ROM claims to support SPC-3, for which VPD pages are mandatory.
> So why is this error generated?

Not sure why the error is generated, but if it is, we can't keep sending
the commands, the guest won't boot.  I guess the real problem is do we
want to keep finding the problem devices one-by-one, or should we put in
some logic to e.g. avoid re-reading the VPD pages on rescan if the
initial scan didn't work.  Seems like a lot of trouble, though, for a
broken device, and that's what the blacklist is for.

> 
> Either way, this patch is wrong.

If we can identify which versions work, we can update it.  Otherwise
I think we have to be conservative.

> 
> NACK.
> 
> Cheers,
> 
> Hannes


