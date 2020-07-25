Return-Path: <SRS0=zQak=BE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FD7DC433E1
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jul 2020 03:10:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77D5F2070E
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jul 2020 03:10:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gapp-nthu-edu-tw.20150623.gappssmtp.com header.i=@gapp-nthu-edu-tw.20150623.gappssmtp.com header.b="uSMKiSqQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbgGYDKX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jul 2020 23:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726572AbgGYDKW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jul 2020 23:10:22 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B66C0619D3
        for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2020 20:10:22 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id e8so6435493pgc.5
        for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2020 20:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gapp-nthu-edu-tw.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NtJvGAFAv7OtdJZPqygN758uG41MdXEaE+G2Ed35ZD8=;
        b=uSMKiSqQWzxOnVBO5CJKg4OSRpSBTpWNZYUJPreWSjcK3ceDIfJv70VpMxCa+rTON2
         MZatWln+JvwEiZlG/6bmR5Rl12RsXs0ez4u1HMsKt3YRjgDfU9h2v3/cmOvRpBuuZ8O3
         ZiqDW14h66eR6UuIUQLDPYjNpHP4c1IXNb7dpf4Aee+7mzVdxF3Q6oHcuQp1Wz+aAndW
         f2YgWTHQHLJJL+IjaZuDNDSzkX7eKAdciJ1Ar7j3fb7dW/EmLErwI9nsp8nEE/fsMLI8
         X66w/Lsk442hdBxyjlZtgfcNfLGcYMuvRiBeKz//C0lqjoP5FUkUTwd07ZeCYQAj+Gv0
         ba1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NtJvGAFAv7OtdJZPqygN758uG41MdXEaE+G2Ed35ZD8=;
        b=TeyU79bZvXRKsepNv7sH0zY0RU6PS51QIgZyHpsUm/jGUy2zhQUrQPgoDD6+P7330D
         hOoErjEVVoe0emODeAUlbq+sCzNwLCseXNRla+vFF3zT3sgRTBAy+63l1/nYpkwIxIsB
         flK5WCBN3pXoYde8oGFbppBKgWhnqFXlCVtDa1/9jOA1W3AThV5tah7oZftyO49OBTrC
         q9VMuYGi7jAmxWrWTHyUXJr3AjpZlvuiGFJAxbwEUKOE6meyS91F/0qLaGfPheAQat6L
         UQb0nFnaA4KFqUjQF2MBNsd57Ery+pghnOoPulGMsiJvHiHhNHWYQmx4wVJLmMQpJ9zQ
         jXlg==
X-Gm-Message-State: AOAM5325IImZODKCuNGb2cE4VDKIC98m6B6l8RuUMeHObA413x0swzv3
        umagTriXA/77BuJn+qiNnwFm8f6xDva76jY3+fDzXA==
X-Google-Smtp-Source: ABdhPJzn6qIJWefh+34jgoJwl+XENAdpIFsJrAsdskoOXaAGhVG6PXdQyMNEbv1xM9zPORsm14KArwlCSArJakqT5hw=
X-Received: by 2002:a62:ce83:: with SMTP id y125mr11053990pfg.181.1595646621877;
 Fri, 24 Jul 2020 20:10:21 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20200717074740epcas2p2b1c8e7bf7dc28f13c5a9999373f4601b@epcas2p2.samsung.com>
 <1594971576-40264-1-git-send-email-sh425.lee@samsung.com> <6ac05df5-71ff-e71d-a4df-94118f67caf1@acm.org>
 <1595409255.27178.17.camel@mtkswgap22> <893ed1a8-504f-ae87-f5e4-4c1dbc3607a7@acm.org>
In-Reply-To: <893ed1a8-504f-ae87-f5e4-4c1dbc3607a7@acm.org>
From:   Stanley Chu <chu.stanley@gapp.nthu.edu.tw>
Date:   Sat, 25 Jul 2020 11:10:10 +0800
Message-ID: <CAOBeenaq0V3X_JCCceduVYe7gGAq7V0VOW05hHhNyaMwsO+e6A@mail.gmail.com>
Subject: Re: [RESEND RFC PATCH v1] scsi: ufs: add retries for SSU
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Stanley Chu <stanley.chu@mediatek.com>,
        Lee Sang Hyun <sh425.lee@samsung.com>,
        linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Bean Huo (beanhuo)" <beanhuo@micron.com>,
        Asutosh Das <asutoshd@codeaurora.org>, cang@codeaurora.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        Kiwoong Kim <kwmad.kim@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

Thanks for your suggestions.

Hi Sang Hyun,

Bart Van Assche <bvanassche@acm.org> =E6=96=BC 2020=E5=B9=B47=E6=9C=8822=E6=
=97=A5 =E9=80=B1=E4=B8=89 =E4=B8=8B=E5=8D=8811:11=E5=AF=AB=E9=81=93=EF=BC=
=9A
>
> On 2020-07-22 02:14, Stanley Chu wrote:
> > Hi Bart,
> >
> > On Sat, 2020-07-18 at 13:30 -0700, Bart Van Assche wrote:
> >> On 2020-07-17 00:39, Lee Sang Hyun wrote:
> >>> -   ret =3D scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
> >>> -                   START_STOP_TIMEOUT, 0, 0, RQF_PM, NULL);
> >>> -   if (ret) {
> >>> -           sdev_printk(KERN_WARNING, sdp,
> >>> -                       "START_STOP failed for power mode: %d, result=
 %x\n",
> >>> -                       pwr_mode, ret);
> >>> -           if (driver_byte(ret) =3D=3D DRIVER_SENSE)
> >>> -                   scsi_print_sense_hdr(sdp, NULL, &sshdr);
> >>> +   for (retries =3D 0; retries < SSU_RETRIES; retries++) {
> >>> +           ret =3D scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &=
sshdr,
> >>> +                           START_STOP_TIMEOUT, 0, 0, RQF_PM, NULL);
> >>> +           if (ret) {
> >>> +                   sdev_printk(KERN_WARNING, sdp,
> >>> +                               "START_STOP failed for power mode: %d=
, result %x\n",
> >>> +                               pwr_mode, ret);
> >>> +                   if (driver_byte(ret) =3D=3D DRIVER_SENSE)
> >>> +                           scsi_print_sense_hdr(sdp, NULL, &sshdr);
> >>> +           } else {
> >>> +                   break;
> >>> +           }
> >>
> >> The ninth argument of scsi_execute() is called 'retries'. Wouldn't it =
be
> >> better to pass a nonzero value as the 'retries' argument of
> >> scsi_execute() instead of adding a loop around the scsi_execute() call=
?
> >
> > If a SCSI command issued via scsi_execute() encounters "timeout" or
> > "check condition", scsi_noretry_cmd() will return 1 (true) because
> > blk_rq_is_passthrough() is true due to REQ_OP_SCSI_IN or REQ_OP_SCSI_OU=
T
> > flag was set to this SCSI command by scsi_execute(). Therefore even a
> > non-zero 'retries' value is assigned while calling scsi_execute(), the
> > failed command has no chance to be retried since the decision will be
> > no-retry by scsi_noretry_cmd().
> >
> > (Take command timeout as example)
> > scsi_times_out()->scsi_abort_command()->scmd_eh_abort_handler(), here
> > scsi_noretry_cmd() returns 1, and then command will be finished (with
> > error code) without retry.
> >
> > In scsi_noretry_cmd(), there is a comment message in section
> > "check_type" as below
> >
> >       /*
> >        * assume caller has checked sense and determined
> >        * the check condition was retryable.
> >        */
> >
> > I am not sure if "timeout" and "check condition" cases in such SCSI
> > commands issued via scsi_execute() are specially designed to be unable
> > to retry.
> >
> > Would you have any suggestions if LLD drivers would like to retry these
> > kinds of SCSI commands?
>
> How about summarizing the above explanation of why the 'retry' argument
> of scsi_execute() cannot be used in a two or three line comment and to
> add that comment above the loop introduced by this patch?
>

I like this patch since this could also recover the "SSU timeout" case
we met before.
Could you please make this as formal patch with Bart's suggestion?

Thanks,
Stanley Chu
