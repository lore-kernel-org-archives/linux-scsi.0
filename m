Return-Path: <SRS0=Z0Y/=AH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29CCFC433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Jun 2020 12:29:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02039207E8
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Jun 2020 12:29:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gapp-nthu-edu-tw.20150623.gappssmtp.com header.i=@gapp-nthu-edu-tw.20150623.gappssmtp.com header.b="Bo5V9Ht6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbgFZM3n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Jun 2020 08:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725864AbgFZM3n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Jun 2020 08:29:43 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F2C8C08C5DB
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2020 05:29:43 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id m2so8400183otr.12
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2020 05:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gapp-nthu-edu-tw.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vAqp3yugMQrx8f8Zb665jfgOYk45fiDlRQGVzpQRM6k=;
        b=Bo5V9Ht6Jl85kX7locFo99ZgIeVqZbFHJeDe+++HeTnldx1qtpoO7YJ+oyIpE4l3Ik
         7jW9A+dH+JwilquwMRf1zAih0EMB9o9FhMCbEuP3fd+p89qPQesFHPYk9jCZXOnG3Uh3
         +zyS+fQ7RX+bJt+Tyxnv+GRgUPWp2dpsl9jL6G6SzjZ7ZUDj/ZIBGHDtMFJGoSJTciua
         pHy74TNNYzecrzmOgWn9odSh0uJMvf8ZlBSkeBPOOlxqL0mt8m5J4GyxKqmQS9VyBiHB
         caUnBjaPSBRxGUnhN2OJuzmfL2F0hhUeOreMOVPrEtLYB8/oo+62b55q8jJyokwtqwir
         S6BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vAqp3yugMQrx8f8Zb665jfgOYk45fiDlRQGVzpQRM6k=;
        b=ejbEpp5QeqvB2ABKA4C9TZCef+NhjybH78WvF53NY8stN08/sPs8ULjDGgT2Rlg1vr
         9rzWsejYvlgQc6McXMJ+76ofjmDyE0Al/amfGufJ7Wvs5m+pV6o4IHm4THbrwKM38EgV
         XVT4QrrWjB+X4j0kgTe5/6Lt975b9IGyEeNgHBV1w/6ZZSo8Cxa37sfxFQETJkZeQlU6
         TldblZmO+x+JjggIU+vEXR1mnmmcph2xuZJ1NQ1a+ZoVCP0mrwvs0X6Cw63z1HPJwYhU
         G57DuRcTTsp4/cigBrTedDC4cVuruQeYzaHJXdTiYb4ZNm/6SfnQsOA4Z3RBrpDz75z/
         b40A==
X-Gm-Message-State: AOAM531drCXhO055+eXm47GWVRHVEUkt2bOB2ojx6RXyNyUZMSfEZ1zj
        6v4IpizsurV2Bp2wg2jvd0+VbegcIbKSiIbjwN65qQ==
X-Google-Smtp-Source: ABdhPJz0bEcU24tlGb7u/xMjLShgOdHLQ5kQAzuvqS2in08HLYdoRIhwilqZ4PUcwDvoOs5bDsb9BJzb22zGMpjxFyg=
X-Received: by 2002:a9d:5786:: with SMTP id q6mr2235701oth.135.1593174582396;
 Fri, 26 Jun 2020 05:29:42 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20200620070044epcas2p269e3c266c86c65dd0e894d8188036a30@epcas2p2.samsung.com>
 <1592635992-35619-1-git-send-email-kwmad.kim@samsung.com> <CAOBeenbWTEbi=gF0WtHCYRK8Y3_nGD7sGcdRqP=oebBJUkanag@mail.gmail.com>
 <02e801d64bae$e5d36f00$b17a4d00$@samsung.com>
In-Reply-To: <02e801d64bae$e5d36f00$b17a4d00$@samsung.com>
From:   Stanley Chu <chu.stanley@gapp.nthu.edu.tw>
Date:   Fri, 26 Jun 2020 20:29:32 +0800
Message-ID: <CAOBeenZ41xLfDDjfTUxaRmu4WJfzV+dXNSt3nCi_Oiu-Fi-oBA@mail.gmail.com>
Subject: Re: [RFC PATCH v1 1/2] ufs: introduce callbacks to get command information
To:     Kiwoong Kim <kwmad.kim@samsung.com>
Cc:     linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Bean Huo (beanhuo)" <beanhuo@micron.com>,
        Asutosh Das <asutoshd@codeaurora.org>, cang@codeaurora.org,
        bvanassche@acm.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Kiwoong,

Kiwoong Kim <kwmad.kim@samsung.com> =E6=96=BC 2020=E5=B9=B46=E6=9C=8826=E6=
=97=A5 =E9=80=B1=E4=BA=94 =E4=B8=8B=E5=8D=887:42=E5=AF=AB=E9=81=93=EF=BC=9A
>
> > Hi Kiwoong,
> >
> > Kiwoong Kim <kwmad.kim@samsung.com> =E6=96=BC 2020=E5=B9=B46=E6=9C=8820=
=E6=97=A5 =E9=80=B1=E5=85=AD =E4=B8=8B=E5=8D=883:00=E5=AF=AB=E9=81=93=EF=BC=
=9A
> > >
> > > Some SoC specific might need command history for various reasons, suc=
h
> > > as stacking command contexts in system memory to check for debugging
> > > in the future or scaling some DVFS knobs to boost IO throughput.
> > >
> > > What you would do with the information could be variant per SoC
> > > vendor.
> > >
> > > Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
> > > ---
> > >  drivers/scsi/ufs/ufshcd.c | 4 ++++
> > >  drivers/scsi/ufs/ufshcd.h | 8 ++++++++
> > >  2 files changed, 12 insertions(+)
> > >
> > > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > > index 52abe82..0eae3ce 100644
> > > --- a/drivers/scsi/ufs/ufshcd.c
> > > +++ b/drivers/scsi/ufs/ufshcd.c
> > > @@ -2545,6 +2545,8 @@ static int ufshcd_queuecommand(struct Scsi_Host
> > *host, struct scsi_cmnd *cmd)
> > >         /* issue command to the controller */
> > >         spin_lock_irqsave(hba->host->host_lock, flags);
> > >         ufshcd_vops_setup_xfer_req(hba, tag, true);
> > > +       if (cmd)
> > > +               ufshcd_vops_cmd_log(hba, cmd, 1);
> > >         ufshcd_send_command(hba, tag);
> > >  out_unlock:
> > >         spin_unlock_irqrestore(hba->host->host_lock, flags); @@
> > > -4890,6 +4892,8 @@ static void __ufshcd_transfer_req_compl(struct
> > ufs_hba *hba,
> > >                         /* Mark completed command as NULL in LRB */
> > >                         lrbp->cmd =3D NULL;
> > >                         lrbp->compl_time_stamp =3D ktime_get();
> > > +                       ufshcd_vops_cmd_log(hba, cmd, 2);
> > > +
> > >                         /* Do not touch lrbp after scsi done */
> > >                         cmd->scsi_done(cmd);
> > >                         __ufshcd_release(hba);
> >
> > If your cmd_log vop callbacks are only existed in "ufshcd_queuecommand"
> > and "ufshcd_transfer_req_compl", perhaps you could re-use
> > "ufshcd_vops_setup_xfer_req()" and an added "ufshcd_vops_compl_req()"
> > instead of a brand new "ufshcd_vops_cmd_log()" ?
> >
> > Thanks,
> > Stanley Chu
>
> Currently, ufshcd_vops_setup_xfer_req doesn't get scsi_cmnd variable.

You could get scsi_cmnd by hba->lrb[tag].cmd if is_scsi_cmd is true in
your ufshcd_vops_setup_xfer_req vendor implementation.

> Actually, when introduced this callback first, I was willing to make it d=
o that
> but someone gave me another idea. Then do you agree to change argument se=
t of the function?
>
> And I can't find ufshcd_vops_compl_req in 5.9/scsi-queue. Could you let m=
e know where to find?
>

Sorry to not describing clearly. What I mean is that you could "add"
ufshcd_vops_compl_xfer_req vop callback in your patch.

Thanks,
Stanley Chu
