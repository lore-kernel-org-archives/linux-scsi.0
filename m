Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6FDCC4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 23:20:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88A23610A3
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 23:20:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233964AbhHSXUn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 19:20:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233512AbhHSXUn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 19:20:43 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23A06C061575
        for <linux-scsi@vger.kernel.org>; Thu, 19 Aug 2021 16:20:06 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id d4so16320798lfk.9
        for <linux-scsi@vger.kernel.org>; Thu, 19 Aug 2021 16:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PaBKbTJLSYX0c6Y31IAyacMLSSEWPCTF/MiNXI8nbM8=;
        b=WYPNxb+bmTocfA5EfibxNDLtHpxnB84inUXyArWq3hfr75WJPoSb9EcEycfZO5IAxd
         p0SnyJSqSn5XQfNkti+PaOuSZS4KQ01GjukuORnMmWD854eIhlTbkTc/FsM0mp/LQDZ4
         k8oTjjooeBdgNCLjzN7tugJQxoYwZ/G156YZzF2k5CVlnghTuXgJSei8+OwGZqzBohvl
         oDCMpB8uXn+BP3sAS15qT2OIGPZbNM7tvOa1r1Rsp3S66xBJJolOHa0lHBH2Qmr1KR/J
         CNp2gMpmrT58pi/5g28FjNo3p8HEqV+qkOODaPpI3aoKi2rWj5KohgLt5BfH+8xtiXPC
         SHJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PaBKbTJLSYX0c6Y31IAyacMLSSEWPCTF/MiNXI8nbM8=;
        b=rs7JZx5OsKq7mWTLsraS/AkQixDZgMvof1hYoGVJZFoFHovTvV+ej096RG/EmP7+pK
         xDkDbCrz3fZG0d3/hKn7V7ctzzz3sPmcgX+KwavuarjsxK5Ndfbi84HKeB03YuTEMCSl
         Igte84RVbtcZ5gYfYxeBPxf+gic7HqBv12Fd6G3sFtctb1eJX13QoPU1bJwCYhPwImcG
         3f0fK4i/jia/WAAdbV43XG88IorPKsVdU/cq2zSdGXG4l1PYMUrCpwoYp/M9n9/eGAsh
         /S8QiVjKYO2Ug+Fe5jCdiTeBvJ+VY0fhvkiSKeqDnXhjrLNl7H2ZCy3JQVg3uywcjWbr
         /8UQ==
X-Gm-Message-State: AOAM530z4Qpv9ts7avR6EAVaWdx6CURxgzVLUMIbLEoH2YGMMWPMRHz7
        4l2ufs02yyg1QZFgUT5KrcMpoRZaFJs3Zut8Ig4=
X-Google-Smtp-Source: ABdhPJw+uHLVD0PEsku7D5CMmnbkDSg+BoU/vYawYoQGutg7PfUmDvQT16Zjz+vsLx26Jx0Zy41zq4sEAoY6lg8+q/0=
X-Received: by 2002:a05:6512:3d15:: with SMTP id d21mr12563096lfv.474.1629415204552;
 Thu, 19 Aug 2021 16:20:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210818090827.134342-1-hare@suse.de> <20210818090827.134342-6-hare@suse.de>
In-Reply-To: <20210818090827.134342-6-hare@suse.de>
From:   Julian Calaby <julian.calaby@gmail.com>
Date:   Fri, 20 Aug 2021 09:19:52 +1000
Message-ID: <CAGRGNgVZqAFVWW5fmXKCZnX8r2jK3bQ0uxfcZEHGcW3_zNG1DQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] lpfc: use rport as argument for lpfc_chk_tgt_mapped()
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        James Smart <james.smart@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Hannes,

On Wed, Aug 18, 2021 at 7:12 PM Hannes Reinecke <hare@suse.de> wrote:
>
> We only need the rport structure for lpfc_chk_tgt_mapped().
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Cc: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_scsi.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
> index 184ca2a90414..f09330a7e667 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -6092,19 +6092,20 @@ lpfc_send_taskmgmt(struct lpfc_vport *vport, struct fc_rport *rport,
>   *  0x2002 - Success
>   **/
>  static int
> -lpfc_chk_tgt_mapped(struct lpfc_vport *vport, struct scsi_cmnd *cmnd)
> +lpfc_chk_tgt_mapped(struct lpfc_vport *vport, struct fc_rport *rport)
>  {
>         struct lpfc_rport_data *rdata;
> -       struct lpfc_nodelist *pnode;
> +       struct lpfc_nodelist *pnode = NULL;

Do we need to initialise this variable ...

>         unsigned long later;
>
> -       rdata = lpfc_rport_data_from_scsi_device(cmnd->device);
> +       rdata = rport->dd_data;
>         if (!rdata) {
>                 lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
>                         "0797 Tgt Map rport failure: rdata x%px\n", rdata);
>                 return FAILED;
>         }
>         pnode = rdata->pnode;

... as we're assigning it here and don't use it before this line?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
