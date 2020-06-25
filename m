Return-Path: <SRS0=uw5d=AG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8357FC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Jun 2020 14:05:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B04A20702
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Jun 2020 14:05:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gapp-nthu-edu-tw.20150623.gappssmtp.com header.i=@gapp-nthu-edu-tw.20150623.gappssmtp.com header.b="URiB/a0m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405181AbgFYOFY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Jun 2020 10:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405082AbgFYOFX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Jun 2020 10:05:23 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B8AC08C5C1
        for <linux-scsi@vger.kernel.org>; Thu, 25 Jun 2020 07:05:23 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id d4so5358896otk.2
        for <linux-scsi@vger.kernel.org>; Thu, 25 Jun 2020 07:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gapp-nthu-edu-tw.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Hd8D3FQc16fVM1TGA3rEN/222liyQC9zETgmkUBPLl0=;
        b=URiB/a0mLDQKN4+fwx1SMaJgaxQGK2oEauLbtquzHDH1fqhu43NYoqmh1+N54ycGo9
         lu2DIoD/Y6LER0QhEHZn8y+SMkDCjus/wybH+Wy6AK+hOiLAHFfe/CdujDx2EphqZVoa
         o0CeYH/NYQxHyPtB0ALrXRGO/6u0QqqI4Gr4iivySQdwH0bGK8WbuAvlcbao5PZ88pm9
         Qbay1mkOCrifQ8wS7ZqbekRf0sVpPRTo4mVTjkWISLSE95cpgSC5l3S3SEZw813QiD59
         xhTdPrJ8n8Cg7rVlFu8pET6Dy6IyQIn9QkgAMGrErfIrH33JtWgTofa4DRtbedXDIG0g
         0jXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Hd8D3FQc16fVM1TGA3rEN/222liyQC9zETgmkUBPLl0=;
        b=U0zU6Ay6msW4aSR4FI+IIDsQjwwvaj9ayDzo5VO2x4QddfmgGJwhtZkkiKMIMjMao3
         QBRnBJMU5ZpWTYqYLLY4FYUC0TjpKB5Tg9+BP2w3WDCug+2b/A+GNiHt6BhjjQpBFctM
         6vZucHf1L6K5/Dx3tS32X5rlPQuJV3k1/sALykoHIa3K0qaSKq0UNsOytRJ0HDYVFeQi
         qVtiudFiK0Qy7DAoPsZuatrHB+xW+VYfTyG7ja/3sJqW6f5avQHpc8pt8/d//wOniLcT
         0+2Tkte4xNkDRSAm6wFIUFSDZDqwnnATLneH2N5sazrzsboxgqEQL6G1xPTimUMo/iXU
         2Dkw==
X-Gm-Message-State: AOAM530YZH2oVm7Af63ygxxcrutY+gLHXstJHmKrkcvWm/yOqZ409W0h
        iSbswhXgYjbKMEME5jzJ8MB7V6nKLMJ+ZKlZWVuhWQ==
X-Google-Smtp-Source: ABdhPJyERQZk7OEPNgaszuTCnCNXX8aiyBS4UXZnM6r1eAR3nqUQhKBWX/l8pCFHY8yI9RKJck8IrV+8c8Q65weNnVI=
X-Received: by 2002:a9d:5786:: with SMTP id q6mr13023039oth.135.1593093922697;
 Thu, 25 Jun 2020 07:05:22 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20200620070044epcas2p269e3c266c86c65dd0e894d8188036a30@epcas2p2.samsung.com>
 <1592635992-35619-1-git-send-email-kwmad.kim@samsung.com>
In-Reply-To: <1592635992-35619-1-git-send-email-kwmad.kim@samsung.com>
From:   Stanley Chu <chu.stanley@gapp.nthu.edu.tw>
Date:   Thu, 25 Jun 2020 22:05:12 +0800
Message-ID: <CAOBeenbWTEbi=gF0WtHCYRK8Y3_nGD7sGcdRqP=oebBJUkanag@mail.gmail.com>
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

Kiwoong Kim <kwmad.kim@samsung.com> =E6=96=BC 2020=E5=B9=B46=E6=9C=8820=E6=
=97=A5 =E9=80=B1=E5=85=AD =E4=B8=8B=E5=8D=883:00=E5=AF=AB=E9=81=93=EF=BC=9A
>
> Some SoC specific might need command history for
> various reasons, such as stacking command contexts
> in system memory to check for debugging in the future
> or scaling some DVFS knobs to boost IO throughput.
>
> What you would do with the information could be
> variant per SoC vendor.
>
> Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 4 ++++
>  drivers/scsi/ufs/ufshcd.h | 8 ++++++++
>  2 files changed, 12 insertions(+)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 52abe82..0eae3ce 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -2545,6 +2545,8 @@ static int ufshcd_queuecommand(struct Scsi_Host *ho=
st, struct scsi_cmnd *cmd)
>         /* issue command to the controller */
>         spin_lock_irqsave(hba->host->host_lock, flags);
>         ufshcd_vops_setup_xfer_req(hba, tag, true);
> +       if (cmd)
> +               ufshcd_vops_cmd_log(hba, cmd, 1);
>         ufshcd_send_command(hba, tag);
>  out_unlock:
>         spin_unlock_irqrestore(hba->host->host_lock, flags);
> @@ -4890,6 +4892,8 @@ static void __ufshcd_transfer_req_compl(struct ufs_=
hba *hba,
>                         /* Mark completed command as NULL in LRB */
>                         lrbp->cmd =3D NULL;
>                         lrbp->compl_time_stamp =3D ktime_get();
> +                       ufshcd_vops_cmd_log(hba, cmd, 2);
> +
>                         /* Do not touch lrbp after scsi done */
>                         cmd->scsi_done(cmd);
>                         __ufshcd_release(hba);

If your cmd_log vop callbacks are only existed in
"ufshcd_queuecommand" and "ufshcd_transfer_req_compl", perhaps you
could re-use "ufshcd_vops_setup_xfer_req()" and an added
"ufshcd_vops_compl_req()" instead of a brand new
"ufshcd_vops_cmd_log()" ?

Thanks,
Stanley Chu
