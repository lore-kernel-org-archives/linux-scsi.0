Return-Path: <SRS0=4AUr=2R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B11FC2D0C0
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Dec 2019 01:18:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33AE120740
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Dec 2019 01:18:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ii5j1sxs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbfL0BSN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Dec 2019 20:18:13 -0500
Received: from mail-vs1-f65.google.com ([209.85.217.65]:36542 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbfL0BSM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Dec 2019 20:18:12 -0500
Received: by mail-vs1-f65.google.com with SMTP id u14so16124553vsu.3
        for <linux-scsi@vger.kernel.org>; Thu, 26 Dec 2019 17:18:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YX3ZxuKBgZWKpkOro3N6brEpa3kIaFENVBNq2JCmFCw=;
        b=Ii5j1sxsNUfNZB0IlVcS5GjRzjNpmWrFveRTVQ8gxKOR6lTDQHKGyopADemmL+h/49
         txFNifo5ZhOUhuDj9DiwyfGuJRWHUZdEL0OGY6e13OAUqTPT2MKyy5waOOU4koa5NWmp
         3N7v0+xJF6PZxs96g1e5o8MrMEJ4aqQb1uoN2zGj58YWhmh1IIH3mYmAJHK0m7fRRRW2
         J7TM0atTNh14OG2K0wAzE/zW9Sz36OGMOkY96TTXIK1MLDd8ZZ7+rLzDo563hrR7m5s6
         lr1ztweyX+vLJh3XroVGNhAHOFl+g3DbgbQi0yWZCvFu+x/Nl9Gssk0wTKhA8CGl/V/e
         ZxGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YX3ZxuKBgZWKpkOro3N6brEpa3kIaFENVBNq2JCmFCw=;
        b=GlqacmA4w277rxk2kA8+naIJYFHf4tdJkoK3ztHlwpx+T9wTVuaQe5+PUW7QMBZDMh
         mDZpwLwMOmcP0rkvtOp2kIya3Uk5ue8Jn8X7mkM347ZZCPfpU6mOF0Ka8I94bum5rlL9
         qbkNshwauJltfkX6XRo3nCPwE3TROSKhc5OVYIgLylt7OT2rf3ZPmHiy7lwbN2qK1Q9q
         Vf7MIL2xr+DQ/JENpx4QQmoYFr98SgtvSx5DMS55b0IkuRHO7yCfSaDYJxuMwqZ+y9sZ
         jwiYyXzZyW/gOTrZKp2o5IrgkTYQ9s3KiMcunO7dxn30Gm+5kgnxX2mzTTnui9FgUuy/
         /Ogw==
X-Gm-Message-State: APjAAAUl1tUMtdiZxWfxR80it29jSnOVdpEKqigNeWIXdbCxGx+VVZJb
        nuQzG4Wh3Pb9d+ArUysVphWOj4dpdOHCovFcbNk=
X-Google-Smtp-Source: APXvYqz1vZRt+f41OXdvpqIOeDiBFbVsIBVsrfN3a+7rz+XfN6/lOGBdGBYKrSb4r8KE7kZoEbPpLV0AtZl68Hzc70Y=
X-Received: by 2002:a05:6102:3102:: with SMTP id e2mr27304849vsh.179.1577409491763;
 Thu, 26 Dec 2019 17:18:11 -0800 (PST)
MIME-Version: 1.0
References: <20191224220248.30138-1-bvanassche@acm.org> <20191224220248.30138-3-bvanassche@acm.org>
In-Reply-To: <20191224220248.30138-3-bvanassche@acm.org>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Fri, 27 Dec 2019 06:47:35 +0530
Message-ID: <CAGOxZ52yTEa9c-pYZxW6R4QppqR543ksnep7v521=AcjQFiA0g@mail.gmail.com>
Subject: Re: [PATCH 2/6] ufs: Make ufshcd_add_command_trace() easier to read
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Bean Huo <beanhuo@micron.com>,
        Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Alim Akhtar <alim.akhtar@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Dec 25, 2019 at 3:34 AM Bart Van Assche <bvanassche@acm.org> wrote:
>
> Since the lrbp->cmd expression occurs multiple times, introduce a new
> local variable to hold that pointer. This patch does not change any
> functionality.
>
FYMI, Any Advantage of doing this? or it just we don't want to fetch
cmd from lrbp every time? I mean in terms of execution speed.

> Cc: Bean Huo <beanhuo@micron.com>
> Cc: Can Guo <cang@codeaurora.org>
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> Cc: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
>  drivers/scsi/ufs/ufshcd.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 48f2f94d51bc..acc84e964e8f 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -327,27 +327,27 @@ static void ufshcd_add_command_trace(struct ufs_hba *hba,
>         u8 opcode = 0;
>         u32 intr, doorbell;
>         struct ufshcd_lrb *lrbp = &hba->lrb[tag];
> +       struct scsi_cmnd *cmd = lrbp->cmd;
>         int transfer_len = -1;
>
>         if (!trace_ufshcd_command_enabled()) {
>                 /* trace UPIU W/O tracing command */
> -               if (lrbp->cmd)
> +               if (cmd)
>                         ufshcd_add_cmd_upiu_trace(hba, tag, str);
>                 return;
>         }
>
> -       if (lrbp->cmd) { /* data phase exists */
> +       if (cmd) { /* data phase exists */
>                 /* trace UPIU also */
>                 ufshcd_add_cmd_upiu_trace(hba, tag, str);
> -               opcode = (u8)(*lrbp->cmd->cmnd);
> +               opcode = cmd->cmnd[0];
>                 if ((opcode == READ_10) || (opcode == WRITE_10)) {
>                         /*
>                          * Currently we only fully trace read(10) and write(10)
>                          * commands
>                          */
> -                       if (lrbp->cmd->request && lrbp->cmd->request->bio)
> -                               lba =
> -                                 lrbp->cmd->request->bio->bi_iter.bi_sector;
> +                       if (cmd->request && cmd->request->bio)
> +                               lba = cmd->request->bio->bi_iter.bi_sector;
>                         transfer_len = be32_to_cpu(
>                                 lrbp->ucd_req_ptr->sc.exp_data_transfer_len);
>                 }



-- 
Regards,
Alim
