Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59A77C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 21:31:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DD41610E9
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 21:31:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232784AbhIHVcQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Sep 2021 17:32:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57834 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229885AbhIHVcQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2021 17:32:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631136667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nFygGt25Yx6er8i6SUB64BbFK1q4/2tx9D5E6LiShJ0=;
        b=jSogCI1pD1d4OvnbmMU8Wxvij6zSmeSAU6W2NkFo76A36j64Iliwbo0GTmakEQg/imv8CW
        kcKD/klmsGJA9YQv5B0uKgzMhu2CvXt8AiVc0wwj3JCx06a0QBFKGoB9mPB6NgONcfex/v
        q3T1zbMRP+8ZtHx98XOw8TUV/54BfeI=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-WpIm0CG5MXyxa3mOxFGifA-1; Wed, 08 Sep 2021 17:31:06 -0400
X-MC-Unique: WpIm0CG5MXyxa3mOxFGifA-1
Received: by mail-ej1-f69.google.com with SMTP id cf17-20020a170906b2d100b005d42490f86bso1654400ejb.3
        for <linux-scsi@vger.kernel.org>; Wed, 08 Sep 2021 14:31:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nFygGt25Yx6er8i6SUB64BbFK1q4/2tx9D5E6LiShJ0=;
        b=djH48PCcHEHV72PH1dM9tGdX+ZKZ9ihlR/rj8gaypJbvca890u2tk3JpkdaFF3vKDS
         qY8+MR8JbTax87HNse7wgWjF2n2ojXTur2WrjpD1N5BcWKG2yGNO2xvlX6ABgF+QUHv+
         Z02WVFRjHpRURcHJvfyBmADbdtTMC8TcfmYT6I8O3o87+IZyPL/SReqAvGEGfVLm5bPu
         fb6QDJvtwXSSNIQJthIlq+yRfRr5x8qDR3VsD/LUTmu963xlY1aI+6CnmxqTvd5Pw2gx
         4/Ysizonf4jJ+NJRVs4X/hbvDj1+q78FyokwVyi3vZHyUdOWmmeGxjL+yiDioPA/d2AE
         2p3Q==
X-Gm-Message-State: AOAM530nchA2LAGEdzCBmN/9PVSwmXVd5YxZ2WtFdxlBMW9RXJ+VVdiq
        7lU0LWjFJLniDcN48TOBRwSVH2+vJ/ncuM1W/NcP3xydOlFasnQWq0l1rQGucPUad++TWuz2skW
        09bdi2aYsVfulQuE5pBczD+evRdf+oRhHDR4bjQ==
X-Received: by 2002:a17:906:bcd7:: with SMTP id lw23mr164802ejb.141.1631136664357;
        Wed, 08 Sep 2021 14:31:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz3s+Tzl10KtE4lWa2zru3+DQhnyWuGcJjmsNYkELW/MBoDLZeC+KfnJyxZ0GU5JSDw7k83mgBvizmmX/Nvweo=
X-Received: by 2002:a17:906:bcd7:: with SMTP id lw23mr164773ejb.141.1631136664121;
 Wed, 08 Sep 2021 14:31:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210907071605.48968-1-hare@suse.de> <0bc96e82-fdda-4187-148d-5b34f81d4942@oracle.com>
 <783a72db-93c7-92ad-81b4-bc7fee3ce2c1@suse.de>
In-Reply-To: <783a72db-93c7-92ad-81b4-bc7fee3ce2c1@suse.de>
From:   Ewan Milne <emilne@redhat.com>
Date:   Wed, 8 Sep 2021 17:30:53 -0400
Message-ID: <CAGtn9r=kicnTDE2o7Gt5Y=yoidHYD7tG8XdMHEBJTBraVEoOCw@mail.gmail.com>
Subject: Re: [PATCH] I/O errors for ALUA state transitions
To:     Hannes Reinecke <hare@suse.de>
Cc:     michael.christie@oracle.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Rajashekhar M A <rajs@netapp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

alua_check_sense() checks for NOT READY / 04h 0Ah but not
UNIT ATTENTION with the same ASC/ASCQ.

Careful about updating pg->state in this case though because that
may cause subsequent I/O in the probe to fail, we didn't do this before
and we *may* only get the UA once.

-Ewan

On Wed, Sep 8, 2021 at 2:12 AM Hannes Reinecke <hare@suse.de> wrote:
>
> On 9/7/21 5:59 PM, michael.christie@oracle.com wrote:
> > On 9/7/21 2:16 AM, Hannes Reinecke wrote:
> >> From: Rajashekhar M A <rajs@netapp.com>
> >>
> >> When a host is configured with a few LUNs and IO is running,
> >> injecting FC faults repeatedly leads to path recovery problems.
> >> The LUNs have 4 paths each and 3 of them come back active after
> >> say an FC fault which makes two of the paths go down, instead of
> >> all 4. This happens after several iterations of continuous FC faults.
> >>
> >> Reason here is that we're returning an I/O error whenever we're
> >> encountering sense code 06/04/0a (LOGICAL UNIT NOT ACCESSIBLE,
> >> ASYMMETRIC ACCESS STATE TRANSITION) instead of retrying.
> >>> Signed-off-by: Hannes Reinecke <hare@suse.de>
> >> ---
> >>   drivers/scsi/scsi_error.c | 7 ++++---
> >>   1 file changed, 4 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> >> index 03a2ff547b22..1185083105ae 100644
> >> --- a/drivers/scsi/scsi_error.c
> >> +++ b/drivers/scsi/scsi_error.c
> >> @@ -594,10 +594,11 @@ enum scsi_disposition scsi_check_sense(struct sc=
si_cmnd *scmd)
> >>                  sshdr.asc =3D=3D 0x3f && sshdr.ascq =3D=3D 0x0e)
> >>                      return NEEDS_RETRY;
> >>              /*
> >> -             * if the device is in the process of becoming ready, we
> >> -             * should retry.
> >> +             * if the device is in the process of becoming ready, or
> >> +             * transitions between ALUA states, we should retry.
> >>               */
> >> -            if ((sshdr.asc =3D=3D 0x04) && (sshdr.ascq =3D=3D 0x01))
> >> +            if ((sshdr.asc =3D=3D 0x04) &&
> >> +                (sshdr.ascq =3D=3D 0x01 || sshdr.ascq =3D=3D 0x0a))
> >>                      return NEEDS_RETRY;
> >
> > Why put this here instead of in alua_check_sense with the other ALUA
> > state transition check?
> >
> Good point. Will be updating the patch.
>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                Kernel Storage Architect
> hare@suse.de                              +49 911 74053 688
> SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> HRB 36809 (AG N=C3=BCrnberg), Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=
=B6rffer
>

