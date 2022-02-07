Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F5C5C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Feb 2022 22:03:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239911AbiBGWD0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Feb 2022 17:03:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237679AbiBGWD0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Feb 2022 17:03:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4D007C0612A4
        for <linux-scsi@vger.kernel.org>; Mon,  7 Feb 2022 14:03:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644271404;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QJBT4ZKvrOFWBn0jGUZRaCe1FdHlq2m2Ky8vHL13IBc=;
        b=M26GtJyEFkuV8VeLq3fMUsNU04s1zHdBB580E9ApNMk7iOkMcbJW6jQ3QhGKNykRaWqgSL
        XEmEOnA+XXpM456FqSUH7RsrTYBPsxAc+k/naCZW2zkquI7ZI7H0B/JCmKs/xq7iUa70p5
        gJ8+n1BHYec7BypXoQxOb2zEy+1OGD8=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-477-JD1ybpBUPHGlDZSrrvmkyw-1; Mon, 07 Feb 2022 17:03:22 -0500
X-MC-Unique: JD1ybpBUPHGlDZSrrvmkyw-1
Received: by mail-lj1-f199.google.com with SMTP id k18-20020a05651c10b200b002430548189aso5028410ljn.15
        for <linux-scsi@vger.kernel.org>; Mon, 07 Feb 2022 14:03:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QJBT4ZKvrOFWBn0jGUZRaCe1FdHlq2m2Ky8vHL13IBc=;
        b=N6JeFfg0MGugUCkrKGX1kTelFy2kttXZGMyDbTZ2DuX0JRZm2gwgDo5CKeRV8HNyq6
         dSqkwz6/73ovSwRDWAxO075lqnc583yHmjkq/EWV0ddPnpsQm34rs57bZEMia//K88PE
         bo2d5S/dVqiLjsDZ6QQiW4hvfAnwkdVR4Ui12m05CNsJd9Jzw8F47RG85DR5XiY9easx
         cOEN/1w+qBkE7dmS1AXBrGMkquKgDJ5yjdLqCeTF80Doqi/QwsHUSPqBRPkec16eaxb6
         x+dAvr7ND/Yp/EhllHa1vQonH8JyMAaPTfkQqzTJhz/CebmP0HU/aePLvW3wND1KhV2j
         bliA==
X-Gm-Message-State: AOAM532XEJODNyUCZb5BkwTqZ7nJKp8pYNA9289dv1fypr5Z/OGxaxXi
        VDE5yTlJ1NyvhvuD6fI6xUdpp/XpY+DmcB8McLWynk92VhsN2luBC1EeUOx/9b5Tzce/H2EewXu
        AT8L6NY6J57hIjcGMOTiB5yCTKRVvji+Gqt2qIA==
X-Received: by 2002:a2e:7c10:: with SMTP id x16mr967190ljc.482.1644271401223;
        Mon, 07 Feb 2022 14:03:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxl3y9K6hvUIo4BDFD8AWRlf/tQ5qI1JRTqBlie8/4641M8WXa4PWuq+a1Y5a+xC+RLjiJRNCT6f1kbJRTr8MM=
X-Received: by 2002:a2e:7c10:: with SMTP id x16mr967183ljc.482.1644271401011;
 Mon, 07 Feb 2022 14:03:21 -0800 (PST)
MIME-Version: 1.0
References: <20220207180516.73052-1-jsmart2021@gmail.com>
In-Reply-To: <20220207180516.73052-1-jsmart2021@gmail.com>
From:   Ewan Milne <emilne@redhat.com>
Date:   Mon, 7 Feb 2022 17:03:09 -0500
Message-ID: <CAGtn9rmZUdiLrMqTAHS48VC+RdrEt+Rs_k72X9DN8k4jSHd8vg@mail.gmail.com>
Subject: Re: [PATCH] lpfc: Remove NVME protocol support of kernel has NVME_FC
 support disabled
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reviewed-by: Ewan D. Milne <emilne@redhat.com>

On Mon, Feb 7, 2022 at 1:12 PM James Smart <jsmart2021@gmail.com> wrote:
>
> The driver is intiating NVME PRLI's to determine NVME support to devices.
> This should not be occurring if CONFIG_NVME_FC support is disabled.
>
> Corrected by changing the default value for FC4 support. Currently it
> defaults to FCP and NVME. With change, when NVME_FC support is not enabled
> in the kernel, the default value is just SCSI.
>
> Cut against 5.18/scsi-queue
>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> ---
>  drivers/scsi/lpfc/lpfc.h      | 13 ++++++++++---
>  drivers/scsi/lpfc/lpfc_attr.c |  4 ++--
>  2 files changed, 12 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
> index 4878c94761f9..a1e0a106c132 100644
> --- a/drivers/scsi/lpfc/lpfc.h
> +++ b/drivers/scsi/lpfc/lpfc.h
> @@ -1161,6 +1161,16 @@ struct lpfc_hba {
>         uint32_t cfg_hostmem_hgp;
>         uint32_t cfg_log_verbose;
>         uint32_t cfg_enable_fc4_type;
> +#define LPFC_ENABLE_FCP  1
> +#define LPFC_ENABLE_NVME 2
> +#define LPFC_ENABLE_BOTH 3
> +#if (IS_ENABLED(CONFIG_NVME_FC))
> +#define LPFC_MAX_ENBL_FC4_TYPE LPFC_ENABLE_BOTH
> +#define LPFC_DEF_ENBL_FC4_TYPE LPFC_ENABLE_BOTH
> +#else
> +#define LPFC_MAX_ENBL_FC4_TYPE LPFC_ENABLE_FCP
> +#define LPFC_DEF_ENBL_FC4_TYPE LPFC_ENABLE_FCP
> +#endif
>         uint32_t cfg_aer_support;
>         uint32_t cfg_sriov_nr_virtfn;
>         uint32_t cfg_request_firmware_upgrade;
> @@ -1182,9 +1192,6 @@ struct lpfc_hba {
>         uint32_t cfg_ras_fwlog_func;
>         uint32_t cfg_enable_bbcr;       /* Enable BB Credit Recovery */
>         uint32_t cfg_enable_dpp;        /* Enable Direct Packet Push */
> -#define LPFC_ENABLE_FCP  1
> -#define LPFC_ENABLE_NVME 2
> -#define LPFC_ENABLE_BOTH 3
>         uint32_t cfg_enable_pbde;
>         uint32_t cfg_enable_mi;
>         struct nvmet_fc_target_port *targetport;
> diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
> index 7a7f17d71811..bac78fbce8d6 100644
> --- a/drivers/scsi/lpfc/lpfc_attr.c
> +++ b/drivers/scsi/lpfc/lpfc_attr.c
> @@ -3978,8 +3978,8 @@ LPFC_ATTR_R(nvmet_mrq_post,
>   *                    3 - register both FCP and NVME
>   * Supported values are [1,3]. Default value is 3
>   */
> -LPFC_ATTR_R(enable_fc4_type, LPFC_ENABLE_BOTH,
> -           LPFC_ENABLE_FCP, LPFC_ENABLE_BOTH,
> +LPFC_ATTR_R(enable_fc4_type, LPFC_DEF_ENBL_FC4_TYPE,
> +           LPFC_ENABLE_FCP, LPFC_MAX_ENBL_FC4_TYPE,
>             "Enable FC4 Protocol support - FCP / NVME");
>
>  /*
> --
> 2.26.2
>

