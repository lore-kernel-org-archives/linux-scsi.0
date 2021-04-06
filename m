Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A771DC433B4
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 19:01:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69B20613C2
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 19:01:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234019AbhDFTBs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Apr 2021 15:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbhDFTBr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2021 15:01:47 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58293C06174A
        for <linux-scsi@vger.kernel.org>; Tue,  6 Apr 2021 12:01:38 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id v24-20020a9d69d80000b02901b9aec33371so15689504oto.2
        for <linux-scsi@vger.kernel.org>; Tue, 06 Apr 2021 12:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7Xyvrew26SDYXm4sPnRCFkiR24jaX0e+bfVG51ayOi8=;
        b=crDxqgDrLXJCNh/D6pTTDbpfVQgEwciJHjph+IBoeXqx3MFVJO0wfwgCWIgNw6/0IU
         aMEVABW4QFwcqNa0o8j5EqqV2RfDeJeRBK8vg8Vr/bCRo+J1EzYfwCxy6DieK5R3+nlE
         AG7Qx7hjYfqM6HbftsfoYR/sLqcrgCaqe4+BFijhB20ZpdaEImGUdBZNUnb2t3Evb1mf
         DmMADSoQMMPfLi4+UzkEFSiG9L0CVPqkILGICPsWCG2jOU6/DOeTXeHMOXxy4bEfl+NO
         8pCyeA6527TRhPIjdstFYCp411ypW5KkTPwhbEIxkmgLnfBAAEnxKrVpHfI08ROczVM/
         FvaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7Xyvrew26SDYXm4sPnRCFkiR24jaX0e+bfVG51ayOi8=;
        b=or7iJXQOYmAW2EixzUox2glO6830xyNvK9VOP3C6nDLqZEsVAb7ih2ZHymZiyZMe1K
         EUtNbasYDXvVmPLn4VX+973mNMdLRuFvFPvfX65i861dduXYC3VErcdzXlOhxXoH8tNF
         Usv95h1Q+JNousx+DeNlYfLNcOsR3JemVn1Bkl4QV6xm00kTgKzwj33uC4AokWNESuU5
         bhwZNjq8JlTw6jeWcCo8AwQ6xo+f2NmEtI7C1w+W4U5KpbxevERmHuFCbf7uI9kzVEK2
         3sqiZZfgg/KwVEnFLrQamwhZ5E7bXYlnuE6t48olzJlmNa0nPIyKgfp2UUdXwLytPd+k
         0J5w==
X-Gm-Message-State: AOAM531vA31IoNr/LQSA5skTFixVHVGSyANPkzJIFU5nKkoyG7kjuyEr
        mFha1hE3BhIx1/pfOJOcTOda4feHHx9WO2fTUVfy/g702mnvjg==
X-Google-Smtp-Source: ABdhPJzHcY82vCaKl3vP+U7T7beqLgszw3Hj/bicgMNvKQg3Y/nsDsbXyw19AHtsid6B9ArXMIwnSdnDnO4tsHuhF/4=
X-Received: by 2002:a9d:12cb:: with SMTP id g69mr27227134otg.77.1617735697598;
 Tue, 06 Apr 2021 12:01:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210329183639.1674307-1-ipylypiv@google.com> <20210329183639.1674307-2-ipylypiv@google.com>
 <CAMGffEkBX65d2w5OZ3=FWj+HnZe1WOqRpWkiEQdn3LuWNasCiQ@mail.gmail.com>
In-Reply-To: <CAMGffEkBX65d2w5OZ3=FWj+HnZe1WOqRpWkiEQdn3LuWNasCiQ@mail.gmail.com>
From:   Igor Pylypiv <ipylypiv@google.com>
Date:   Tue, 6 Apr 2021 12:01:26 -0700
Message-ID: <CAEoq6+1DH1KhFzj+QKWBuBo4qp0CxmAXDQLd8Bpw5m3UpQ9fiA@mail.gmail.com>
Subject: Re: [PATCH 1/2] scsi: pm80xx: Increase timeout for pm80xx mpi_uninit_check()
To:     Jinpu Wang <jinpu.wang@ionos.com>
Cc:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Vishakha Channapattan <vishakhavc@google.com>,
        Akshat Jain <akshatzen@google.com>,
        Jolly Shah <jollys@google.com>, Yu Zheng <yuuzheng@google.com>,
        Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Viswas G <Viswas.G@microchip.com>,
        Deepak Ukey <deepak.ukey@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Apr 6, 2021 at 1:14 AM Jinpu Wang <jinpu.wang@ionos.com> wrote:
>
> On Mon, Mar 29, 2021 at 8:37 PM Igor Pylypiv <ipylypiv@google.com> wrote:
> >
> > The mpi_uninit_check() takes longer for inbound doorbell register to be
> > cleared. Increased the timeout substantially so that the driver does not
> > fail to load.
> >
> > Previously, the inbound doorbell wait time was mistakenly increased in
> > the mpi_init_check() instead of the mpi_uninit_check(). It is okay to
> > leave the mpi_init_check() wait time as is as these are timeout values
> > and if there is a failure, waiting longer is not an issue.
> >
> > Fixes: e90e236250e9 ("scsi: pm80xx: Increase timeout for pm80xx
> > mpi_uninit_check")
> > Reviewed-by: Vishakha Channapattan <vishakhavc@google.com>
> > Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
> looks ok to me!
> Acked-by: Jack Wang <jinpu.wang@ionos.com>
> > ---
> >  drivers/scsi/pm8001/pm80xx_hwi.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> > index 84315560e8e1..a6f65666c98e 100644
> > --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> > +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> > @@ -1502,9 +1502,9 @@ static int mpi_uninit_check(struct pm8001_hba_info *pm8001_ha)
> >
> >         /* wait until Inbound DoorBell Clear Register toggled */
> >         if (IS_SPCV_12G(pm8001_ha->pdev)) {
> > -               max_wait_count = 4 * 1000 * 1000;/* 4 sec */
> > +               max_wait_count = (30 * 1000 * 1000) /* 30 sec */
> >         } else {
> > -               max_wait_count = 2 * 1000 * 1000;/* 2 sec */
> > +               max_wait_count = (15 * 1000 * 1000) /* 15 sec */
Noticed missing semicolons. Sent v2 to fix this issue.

> >         }
> >         do {
> >                 udelay(1);
> > --
> > 2.31.0.291.g576ba9dcdaf-goog
> >
