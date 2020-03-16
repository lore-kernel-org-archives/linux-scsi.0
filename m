Return-Path: <SRS0=cHy8=5B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 949CAC0044D
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 06:15:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 506A420575
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 06:15:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="WLVQfAfH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729464AbgCPGP0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Mar 2020 02:15:26 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:45660 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729319AbgCPGP0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Mar 2020 02:15:26 -0400
Received: by mail-ot1-f68.google.com with SMTP id e9so9454970otr.12
        for <linux-scsi@vger.kernel.org>; Sun, 15 Mar 2020 23:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YXhnrDszyFH56EmyR4eCmN00/9g9ltcCsSqXK8jNA5w=;
        b=WLVQfAfH6GU+1QiSRbjTOR0lf8JcZ84ivmJ+0ExwQqVuv3gNnB1s1wUl4C9fJbTPVR
         O8vJbUnCHgepdmGcXn180dfMeYJHYT7O/Brbdql9uwGDSDmh+yTRSpWK5bpevRELGm69
         qaV4bJs6gS7xJsWzguTTEp90LUXK++ooJ3mXI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YXhnrDszyFH56EmyR4eCmN00/9g9ltcCsSqXK8jNA5w=;
        b=FDVJkrqJRdLlra2qYGR6a0ygVGnPXLVhLduAjVcHz4ACai9KzuaoGYz5UvgBAGWLy0
         FY4gXVnYa+ANr/Awrm6Pjjg1y3K3+vWks3b4t9v5KMZvxyADVD4j9IDeOSnqJscC/mZZ
         bEi4MTV2XOdZ2T+lkllfMbU3yEpepqaBI9Vzkshb//E97g82qj4Hyv7ASKmp8inQzlSc
         fsPALBv9SWhx1uqx5dEQ83GMCbivtdpV6aEnKSRMsNKOFY4nqHmvcKmM7+wrcotE2hoz
         9ds9UhNzSnUoY21L2GzpVKnsBlFWud1NpuxgHJY/5Ih6oXCIXlzXM+i2YSzXjl7g16if
         dxLQ==
X-Gm-Message-State: ANhLgQ33L63VE7oWuGIVQQwPJz30aDecC/U6dBeTNUZ1cGxMuGLvRYvp
        DRNWS+gq8Q+rx/s6YPpFXOQE0mXk9rb2aSXn1RzlmDsf
X-Google-Smtp-Source: ADFU+vtaYHbXXdExSGONHsJsOy7R5W0XOFKWMW56TrzpZLfXmNXgANNaexVHHbKbwTiwXcUkd5rdZAgrGMfXk+S2tMI=
X-Received: by 2002:a9d:518e:: with SMTP id y14mr871884otg.27.1584339325445;
 Sun, 15 Mar 2020 23:15:25 -0700 (PDT)
MIME-Version: 1.0
References: <1583923013-3935-1-git-send-email-sreekanth.reddy@broadcom.com> <DF4PR8401MB12415ADC9760286F3930DBE4ABFB0@DF4PR8401MB1241.NAMPRD84.PROD.OUTLOOK.COM>
In-Reply-To: <DF4PR8401MB12415ADC9760286F3930DBE4ABFB0@DF4PR8401MB1241.NAMPRD84.PROD.OUTLOOK.COM>
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Date:   Mon, 16 Mar 2020 11:45:15 +0530
Message-ID: <CAK=zhgqWJs+Wbmgy9xp6WDRp2w5e+5BGD+R5mck-dVh5oOUQ0g@mail.gmail.com>
Subject: Re: [PATCH] mpt3sas: Fix kernel panic observed on soft HBA unplug
To:     "Elliott, Robert (Servers)" <elliott@hpe.com>
Cc:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>,
        "suganath-prabu.subramani@broadcom.com" 
        <suganath-prabu.subramani@broadcom.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "amit@kernel.org" <amit@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Mar 14, 2020 at 7:56 AM Elliott, Robert (Servers)
<elliott@hpe.com> wrote:
>
>
>
> > -----Original Message-----
> > From: linux-scsi-owner@vger.kernel.org <linux-scsi-
> > owner@vger.kernel.org> On Behalf Of Sreekanth Reddy
> > Sent: Wednesday, March 11, 2020 5:37 AM
> > To: martin.petersen@oracle.com
> > Cc: linux-scsi@vger.kernel.org; sathya.prakash@broadcom.com; suganath-
> > prabu.subramani@broadcom.com; stable@vger.kernel.org; amit@kernel.org;
> > Sreekanth Reddy <sreekanth.reddy@broadcom.com>
> > Subject: [PATCH] mpt3sas: Fix kernel panic observed on soft HBA unplug
> >
> > Generic protection fault type kernel panic is observed when user
> > performs soft(ordered) HBA unplug operation while IOs are running
> > on drives connected to HBA.
> >
> > When user performs ordered HBA removal operation then kernel calls
> > PCI device's .remove() call back function where driver is flushing out
> > all the outstanding SCSI IO commands with DID_NO_CONNECT host byte and
> > also un-maps sg buffers allocated for these IO commands.
> > But in the ordered HBA removal case (unlike of real HBA hot unplug)
> > HBA device is still alive and hence HBA hardware is performing the
> > DMA operations to those buffers on the system memory which are already
> > unmapped while flushing out the outstanding SCSI IO commands
> > and this leads to Kernel panic.
> >
> > Fix:
> > Don't flush out the outstanding IOs from .remove() path in case of
> > ordered HBA removal since HBA will be still alive in this case and
> > it can complete the outstanding IOs. Flush out the outstanding IOs
> > only in case physical HBA hot unplug where their won't be any
> > communication with the HBA.
> >
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
> > ---
> >  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> > b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> > index 778d5e6..04a40af 100644
> > --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> > +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> > @@ -9908,8 +9908,8 @@ static void scsih_remove(struct pci_dev *pdev)
> >
> >       ioc->remove_host = 1;
> >
> > -     mpt3sas_wait_for_commands_to_complete(ioc);
>
> Immediately removing the driver with IOs pending seems dangerous.
>
> That function includes a timeout to avoid hanging forever, which
> is reasonable (avoid hanging during system shutdown). Perhaps the
> kernel panic was happening because that function timed out?
>
> Reporting a warning or error and doing special handling might be
> appropriate if that occurs. That should be rare, though; the normal
> case should be to cleanly finish any outstanding commands.
>
> > -     _scsih_flush_running_cmds(ioc);
> > +     if (!pci_device_is_present(pdev))
> > +             _scsih_flush_running_cmds(ioc);
>
> If that branch is not taken, then it proceeds to remove the driver
> with IOs pending. That'll wipe out all sorts of ioc structures
> and things like interrupt handler code, leaving memory mapped forever
> (no code left to call scsi_dma_unmap). That might be better than
> a kernel panic, but still not good.

In the unload path driver call sas_remove_host() API before releasing
the resources. This sas_remove_host() API waits for all the
outstanding IOs to be completed. So here, indirectly driver is waiting
for the outstanding IOs to be processed before releasing the HBA
resources.  So only in the cases where HBA is inaccessible (e.g. HBA
unplug case), driver is flushing out the outstanding commands to avoid
SCSI error handling over head and can quilkey complete the driver
unload operation.

>
>
