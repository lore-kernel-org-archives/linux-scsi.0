Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E432C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Feb 2022 22:03:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239996AbiBGWDr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Feb 2022 17:03:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239911AbiBGWDr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Feb 2022 17:03:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EDE61C0612A4
        for <linux-scsi@vger.kernel.org>; Mon,  7 Feb 2022 14:03:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644271426;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=k2PokJzHb7RCZafVmi7OcM+talCqQ3jYM2ksI4wYO8o=;
        b=XCK+c/I0vs/zgxPIK4Wl8ygb5EQ7sHIt+dB2w8HMP70ANpXcLkax/wm5+bjeMmlAKRkpvn
        V7CE63JaVQQ7H3HUS3y2BFNvmemi9JVw/52Q5H88bXVVpvd04Zez4Vs/b8Pf/YBhQ83gzi
        YKTkfx+KVihXXqWpX99QF+qkGCHlDlI=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-232-AFp166MPOVC0ou6NcJGCHw-1; Mon, 07 Feb 2022 17:03:44 -0500
X-MC-Unique: AFp166MPOVC0ou6NcJGCHw-1
Received: by mail-lj1-f199.google.com with SMTP id 184-20020a2e05c1000000b0023a30a97e36so5030832ljf.14
        for <linux-scsi@vger.kernel.org>; Mon, 07 Feb 2022 14:03:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k2PokJzHb7RCZafVmi7OcM+talCqQ3jYM2ksI4wYO8o=;
        b=TassEreCq9EvVpD9zB8nj+YJ2bOyZXkZj/GQQi5KLQwnZ6bYX7s7/dEyr1/6IRjDqS
         MI2jOSg69U/2SgPB6w9w9GvTAqjYvXSUtsJP/s91gOflAY4V0L1LrXLJk7/kklpBPDrt
         Wna5OwyrA/PhbbbsfrskacEvJuVO41/F9WjYFcdBz6q7eACp+mhJVhWdOcXEEpcnxTbY
         Hy1GU44va6wqmd2f5/yamNRIuVlms4cDt9l1Y7LOQCcJ+piI/mN11R8BUh6fFhRZSq3V
         QAKxRx2zJeiyhoDMOcazP85I0qKJ+HGoY4/6B5ny1sXYxkXJXvu5MhY+8dmfNY42ylYn
         JL8A==
X-Gm-Message-State: AOAM531SQx7gaqrXVkiESWQkuAvuObUExEo9yhoW7rLgE9B9iDwPkLNl
        bmTpuY53Dp0U1QgVJD1bsb2AKfrzsz7NGa4eP5LtUkP5Nerti5Flr5s2WfsXczyUFEN9mT84N2N
        05xm0v2wJayEsTpXq44PtAbPqaiG47b/MSm34MQ==
X-Received: by 2002:a05:6512:230b:: with SMTP id o11mr1027489lfu.660.1644271422909;
        Mon, 07 Feb 2022 14:03:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwEvofmcC+BlNAMLi21z2sm7Qn8WJWw/yvCZldHDSby1PmhsR5KzBup4KxSlQOgK0RiilULPkO2H8tNgGsnysA=
X-Received: by 2002:a05:6512:230b:: with SMTP id o11mr1027478lfu.660.1644271422714;
 Mon, 07 Feb 2022 14:03:42 -0800 (PST)
MIME-Version: 1.0
References: <20220207180442.72836-1-jsmart2021@gmail.com>
In-Reply-To: <20220207180442.72836-1-jsmart2021@gmail.com>
From:   Ewan Milne <emilne@redhat.com>
Date:   Mon, 7 Feb 2022 17:03:31 -0500
Message-ID: <CAGtn9r=EGOkf6E1SuKfqPoA8qn+C79pMov1XPiSyngg26C25ew@mail.gmail.com>
Subject: Re: [PATCH] lpfc: Reduce log messages see after successful firmware download
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reviewed-by: Ewan D. Milne <emilne@redhat.com>

On Mon, Feb 7, 2022 at 1:13 PM James Smart <jsmart2021@gmail.com> wrote:
>
> Messages around fw download were incorrectly tagged as being related to
> discovery trace events. Thus, fw download status ended up dumping the
> trace log as well as the fw update message. As there were a couple of
> log messages in this state, the trace log was dumped multiple times.
>
> Resolved by converting from trace events to sli events.
>
> Cut against 5.18/scsi-queue
>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> ---
>  drivers/scsi/lpfc/lpfc_init.c | 2 +-
>  drivers/scsi/lpfc/lpfc_sli.c  | 8 +++++++-
>  2 files changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index a56f01f659f8..558f7d2559c4 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -2104,7 +2104,7 @@ lpfc_handle_eratt_s4(struct lpfc_hba *phba)
>                 }
>                 if (reg_err1 == SLIPORT_ERR1_REG_ERR_CODE_2 &&
>                     reg_err2 == SLIPORT_ERR2_REG_FW_RESTART) {
> -                       lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
> +                       lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
>                                         "3143 Port Down: Firmware Update "
>                                         "Detected\n");
>                         en_rn_msg = false;
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index 1bc0db572d9e..430abebf99f1 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -13363,6 +13363,7 @@ lpfc_sli4_eratt_read(struct lpfc_hba *phba)
>         uint32_t uerr_sta_hi, uerr_sta_lo;
>         uint32_t if_type, portsmphr;
>         struct lpfc_register portstat_reg;
> +       u32 logmask;
>
>         /*
>          * For now, use the SLI4 device internal unrecoverable error
> @@ -13413,7 +13414,12 @@ lpfc_sli4_eratt_read(struct lpfc_hba *phba)
>                                 readl(phba->sli4_hba.u.if_type2.ERR1regaddr);
>                         phba->work_status[1] =
>                                 readl(phba->sli4_hba.u.if_type2.ERR2regaddr);
> -                       lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
> +                       logmask = LOG_TRACE_EVENT;
> +                       if (phba->work_status[0] ==
> +                               SLIPORT_ERR1_REG_ERR_CODE_2 &&
> +                           phba->work_status[1] == SLIPORT_ERR2_REG_FW_RESTART)
> +                               logmask = LOG_SLI;
> +                       lpfc_printf_log(phba, KERN_ERR, logmask,
>                                         "2885 Port Status Event: "
>                                         "port status reg 0x%x, "
>                                         "port smphr reg 0x%x, "
> --
> 2.26.2
>

