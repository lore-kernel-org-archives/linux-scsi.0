Return-Path: <SRS0=glVe=EF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AF62C56201
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 07:44:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF22F2220B
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 07:44:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="BcTso3y3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbgJ3Hor (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Oct 2020 03:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgJ3Hor (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Oct 2020 03:44:47 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40CF5C0613D2
        for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2020 00:44:46 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id h24so7249770ejg.9
        for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2020 00:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OqbRCx1+8mNlsDYXOiqaELbQWEsj+DHsFaLkuHgCl0c=;
        b=BcTso3y3aPbxzAIu7boECzlFvvAhWEyjBIXEhyaW3FWqD8EWvmLQ10ehJmqCUG5FZj
         FAasxpxYo3Mm9zITU343ktXRZPjBAzHvnKs1iarG75AI8Ufbm1s68bkMzo37jOPMH7XT
         cyiA5enUiQGhLk9VV9kOxiTnYa1zhoCbIHF1Baj1X/dKGLyNMC2EHFJgGoOF6+yfDCbB
         ZfnCkSlt7OFi46bFtLac2HacAtfq2fB/8PbkQGj5XcmjrY3bzh2uc6opEQS8ZiiiTP3l
         WD1ZFEAgGHSrfNIHnK7pkyXmQ9LDo4qizBte1hqXToo7ukvgvxqkztN2z8juYcdxnwBH
         2lfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OqbRCx1+8mNlsDYXOiqaELbQWEsj+DHsFaLkuHgCl0c=;
        b=un+UwBVcDGBOYb17viE6OEkfPXH8g2+KRT0KLkHTUS7t/gQJ4sMKZMbA5KVbp/2MGT
         NMbq7/5dsG+L2E4C4y0hnBdIY5LJ91LeRtp74KAUW1AVwsV5GfwC8pXapxew+u/CdHdQ
         WL/GOlnlzO7D+JeuzlssgvYmTit4GMnxTtKyl3PBjgLrsQxxpnj9qBCllZd/p34igCOU
         wPCeY1jwo1YQHxEzg4qdCHiW5/llLRNxK5o57poSE/We/3Z0Y5823QawBenAFrB9r31h
         J2kCVQFLGZITVwMH8DBG+Jwv9GHIM0o9wNdnDN7A1wSCJDn9oROwyvSKuutXeCzlzneH
         MfkQ==
X-Gm-Message-State: AOAM530ZVevNPV3v2xgfv8+S+q6I54WI5VS3d1BaX+5hncO8F2c8pnXJ
        E9qt4DtuHnk/Mr4YccBLyuDRSTkI6+zx8e9K99Uu8Q==
X-Google-Smtp-Source: ABdhPJwQafmO+6ZOrZ8BfGN8Uj7sIidodo+2wmQVVndN2j7FaLG317KcLvc6HhCBNdmSVdo/0XsoMvWOF5FdbGMK6JY=
X-Received: by 2002:a17:906:3e08:: with SMTP id k8mr1261828eji.478.1604043884894;
 Fri, 30 Oct 2020 00:44:44 -0700 (PDT)
MIME-Version: 1.0
References: <20201030060913.14886-1-Viswas.G@microchip.com.com> <20201030060913.14886-5-Viswas.G@microchip.com.com>
In-Reply-To: <20201030060913.14886-5-Viswas.G@microchip.com.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Fri, 30 Oct 2020 08:44:34 +0100
Message-ID: <CAMGffE=fEHG1aVLbvr4DxhKHtEe6OSYPYe-DTh0DsejaqZL-tg@mail.gmail.com>
Subject: Re: [PATCH V2 4/4] pm80xx: make pm8001_mpi_set_nvmd_resp free of race condition
To:     Viswas G <Viswas.G@microchip.com.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        Viswas G <Viswas.G@microchip.com>, Ruksar.devadi@microchip.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        yuuzheng@google.com, vishakhavc@google.com,
        Radha Ramachandran <radha@google.com>, akshatzen@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Oct 30, 2020 at 6:59 AM Viswas G <Viswas.G@microchip.com.com> wrote:
>
> From: yuuzheng <yuuzheng@google.com>
>
> The use-after-free or null-pointer error occurs when the 251-byte
> response data are copied from IOMB buffer to response message
> buffer in function mp8001_mpi_set_nvmd_resp. pm8001_mpi_set_nvmd_resp
typo mp8001_mpi_set_nvmd_resp.
> is a function to process the response of command set_nvmd_data_resp.
> After sending the command set_nvmd_data, the caller begins to sleep by
> calling wait_for_complete() and wait for the wake-up from calling
> complete() in pm8001_mpi_set_nvmd_resp. In the current code,
> the memcpy for response message buffer occurs after calling complete().
> So, it is not protected by the use of wait_for_completion() and
> complete().
>
> Due to unexpected events (e.g., interrupt), if response buffer gets
> freed before memcpy, the use-after-free error will occur.
> To fix it, the complete() should be called after memcpy.
>
> Signed-off-by: yuuzheng <yuuzheng@google.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
> Signed-off-by: Radha Ramachandran <radha@google.com>
The code and the commit message doesn't match, the commit message is
talking about pm8001_mpi_set_nvmd_resp,
but the code change is in pm8001_mpi_get_nvmd_resp

The fix itself looks correct, please fix the commit message, with that
you can add my
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_hwi.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
> index 9e9a546da959..2054c2b03d92 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -3279,10 +3279,15 @@ pm8001_mpi_get_nvmd_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
>                 pm8001_ha->memoryMap.region[NVMD].virt_ptr,
>                 fw_control_context->len);
>         kfree(ccb->fw_control_context);
> +       /* To avoid race condition, complete should be
> +        * called after the message is copied to
> +        * fw_control_context->usrAddr
> +        */
> +       complete(pm8001_ha->nvmd_completion);
> +       PM8001_MSG_DBG(pm8001_ha, pm8001_printk("Set nvm data complete!\n"));
>         ccb->task = NULL;
>         ccb->ccb_tag = 0xFFFFFFFF;
>         pm8001_tag_free(pm8001_ha, tag);
> -       complete(pm8001_ha->nvmd_completion);
>  }
>
>  int pm8001_mpi_local_phy_ctl(struct pm8001_hba_info *pm8001_ha, void *piomb)
> --
> 2.16.3
>
