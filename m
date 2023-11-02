Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 112B1C4332F
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Nov 2023 08:00:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344540AbjKBIAQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Nov 2023 04:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234393AbjKBIAP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Nov 2023 04:00:15 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B80E128
        for <linux-scsi@vger.kernel.org>; Thu,  2 Nov 2023 01:00:12 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-9be02fcf268so89188166b.3
        for <linux-scsi@vger.kernel.org>; Thu, 02 Nov 2023 01:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698912010; x=1699516810; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ehYt5zOxZrv3k+kn+bhN3ghAtclwBRikXVBpysq1NME=;
        b=PpiNj1ua13XK8IFZuclX58oevIigwuwErfdoJEZzhxi+UpCnhqhMwsDGoqSu/9drSh
         suQ3AC8iIQ9SJS/f5lIKnKOFxAAZBrXIe7w3X7tGPfoXMh/TI10Dc+toXzOYYkJBwHoX
         Iqg16cVNM527RE5btdbgYlgz+ZHpZYF6nTQbvj63n7YfxlTy2uwpLrtpJF8XU1aZEH15
         KSUrO0aufslP6NZVynUEm8OT0aDSRHw2YVhwq/utgH8Py6PiRSDk7ArWtA11N/d1Np/J
         iNclf0fcnCecpgoVXdmCyDQ2KE7AUNMgXR/8LwXO3WmesNDHZfsZpBh2DzOnOIDzKNzW
         Y31w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698912010; x=1699516810;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ehYt5zOxZrv3k+kn+bhN3ghAtclwBRikXVBpysq1NME=;
        b=FXqkOgH7V18A2r+/EgHIw5cOjnTrFoA05X0OZj/Ht/M92x8Ic3175j2BkbjL+H9WCW
         wJZ5hD82f1TZDXjRi/g8XCP5hqMtwTrJaEu3m9bXOZoUkZofRiUynjekycudGhUQc/TG
         oWnWILEk0Vk6QLOkCpOo6fu+bQ9i2b9bfdbqm4ifda81TiHk2TZniTfM3ampDG79qP0D
         gGALV26rNQuYADk8c7JKeTLNMguF7rnehI7SpTcQw/bHjCS3auT/OzUxQtwJBooZK7Sx
         gUqS3s2v/MOVXaMoWmkHpApbhr5Ey/g4Fz8AMs7HT1EpeTkqV4U1+XUeBKo4qvyVzozP
         6W5Q==
X-Gm-Message-State: AOJu0YyitsFlx5XUBvp/rIKBz7hHSPYT6DcnArqw2M+eJn9U1ZQ4mb9L
        3zQzf6JUkog/fDTJDZMz/Mxwce08MIxxYIcfmYM=
X-Google-Smtp-Source: AGHT+IHWjWRRO6Mcn8tKtfOTZYkv54mevq8WGPj/g92aR20aSMgum+zjiZTka20pgTfwdBXPxYhY8ozzfGOcgkmFW3k=
X-Received: by 2002:a17:907:c0b:b0:9ae:59c9:b831 with SMTP id
 ga11-20020a1709070c0b00b009ae59c9b831mr4607396ejc.49.1698912010407; Thu, 02
 Nov 2023 01:00:10 -0700 (PDT)
MIME-Version: 1.0
References: <20231101071420.29238-1-zhe.wang1@unisoc.com> <f1be8bb5-7fac-45b3-a428-d5ba9b1ec260@acm.org>
In-Reply-To: <f1be8bb5-7fac-45b3-a428-d5ba9b1ec260@acm.org>
From:   Zhe Wang <zhewang116@gmail.com>
Date:   Thu, 2 Nov 2023 15:59:58 +0800
Message-ID: <CAJxzgGrcFYhrTr29_jS-LQ3qya9JkTxCp-286gkMY_HGhkuu5g@mail.gmail.com>
Subject: Re: [PATCH] scsi: ufs: core: Add compl_time_stamp_local_clock assignment
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Zhe Wang <zhe.wang1@unisoc.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com, alim.akhtar@samsung.com, avri.altman@wdc.com,
        quic_asutoshd@quicinc.com, linux-scsi@vger.kernel.org,
        orsonzhai@gmail.com, yuelin.tang@unisoc.com,
        zhenxiong.lai@unisoc.com, zhang.lyra@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart

On Thu, Nov 2, 2023 at 12:43=E2=80=AFAM Bart Van Assche <bvanassche@acm.org=
> wrote:
>
>
> On 11/1/23 00:14, Zhe Wang wrote:
> > The compl_time_stamp_local_clock assignment seems to have been
> > accidentally deleted in the previous patch, so it needs to be added
> > again for debugging needs.
> >
> > Fixes: c30d8d010b5e ("scsi: ufs: core: Prepare for completion in MCQ")
> > Signed-off-by: Zhe Wang <zhe.wang1@unisoc.com>
> > ---
> >   drivers/ufs/core/ufshcd.c | 1 +
> >   1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> > index 8382e8cfa414..b35977fa931f 100644
> > --- a/drivers/ufs/core/ufshcd.c
> > +++ b/drivers/ufs/core/ufshcd.c
> > @@ -5388,6 +5388,7 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, in=
t task_tag,
> >
> >       lrbp =3D &hba->lrb[task_tag];
> >       lrbp->compl_time_stamp =3D ktime_get();
> > +     lrbp->compl_time_stamp_local_clock =3D local_clock();
> >       cmd =3D lrbp->cmd;
> >       if (cmd) {
> >               if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
>
> Is anyone using the data tracked in compl_time_stamp /
> compl_time_stamp_local_clock? I'm wondering whether the code for
> tracking command duration can be removed. Otherwise the above patch
> looks fine to me.
>
> Thanks,
>
> Bart.

'compl_time_stamp_local_clock' can correspond to the timestamp of
dmesg entries or other timestamps used by the UFS driver, such as
'tstamp' in 'struct ufs_event_hist'. The timestamp that can be
correlated with each other can be easily combined to record the
sequence of command execution for analyzing problem scenarios, so I
think it is quite useful.

Thanks,
Zhe.
