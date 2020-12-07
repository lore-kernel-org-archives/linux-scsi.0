Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D47E8C433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 11:00:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7B602158C
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 11:00:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbgLGLAQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 06:00:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbgLGLAP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 06:00:15 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DE3DC0613D0;
        Mon,  7 Dec 2020 02:59:35 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id n26so18834684eju.6;
        Mon, 07 Dec 2020 02:59:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ueepF1yzZbMICZuzK5SyCCKVIYjp8Ub6eatZHwC5SNQ=;
        b=Uj3sJueNflNH5hUhwt0vjG3oYCYO+JvWwURqSIkaAssBzmL9l0UksVHzWDm3qtz2tJ
         K2m/NH2IdmMK5JHKkmP1rQvuZ8ND6SqV+WJ7jnZvE5Eyn2HHH+Je5moW1QNHSWCyEpDu
         v/pxS7OwzqkPBZf9XdCP/TY/+iTf/wAi+/bR4ovxnTn/pvxrSdiEqGpTmENEooWhkXFS
         YrmBG+XL7/DfLNeH7Csw7rlznTI7736WIW6Y2Bum3XMNeT/Gq4Oua5l8dCecVZSpCWuv
         D4jzSoJ2ktoxY+57WJj5i5Xo4XKLTKhCr/BZ4yAaOQmrtJIxGFSZxYmr+jZYqJS6tGqN
         KUXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ueepF1yzZbMICZuzK5SyCCKVIYjp8Ub6eatZHwC5SNQ=;
        b=thT23nSDShPr2xX/3NpUDpMxhD8gKoOlhwBUCCx2CGBgKgNgyTkWjvcfvr7lpRSS1X
         Pz+eomatxnB8PT+t1dJxAbApNEFkS+gYT9WkaHAfDBBI/rUKACHNp+518Dad2BuWnMx0
         iQHN6OkaFeSjqOgeGVVXleH3jl7Y6gnPRVpdg/BBAt8F+my1SM9FeuEh+KysEZFlHI6l
         rSHkLVmFYdgNX27REs8z4+E561h56aEYmjR2w15btXSATP+MvZmIG2IXnV3vHVjCLpNF
         xhXhByZCiv+/KymjSLi1bKqJvATo8xgEBFFiwpDAAQqS8mWkLZUdfmPAqzZvZnnXyMfV
         GmPQ==
X-Gm-Message-State: AOAM5327hIC8otNbF9ym3IEPjjHUbvLFrDpvfJe4WCOu4BXzjATJRJQH
        58CTcBu3hoLa64vhr6RAJKY=
X-Google-Smtp-Source: ABdhPJwdVXVVZBusMiT3eABzfCHMmKAbPpc8SyCWfIQKwVGaIl4aMaqM9p8ahtPH/YufDw7gFzoe9g==
X-Received: by 2002:a17:906:52d9:: with SMTP id w25mr17646791ejn.504.1607338773893;
        Mon, 07 Dec 2020 02:59:33 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.googlemail.com with ESMTPSA id h23sm11571690ejg.37.2020.12.07.02.59.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 07 Dec 2020 02:59:33 -0800 (PST)
Message-ID: <062aa9e8f37c2e50032241ff8ddc1dcbc8051ba9.camel@gmail.com>
Subject: Re: [PATCH] scsi: ufs: Enable WB flush during suspend only if WB is
 enabled
From:   Bean Huo <huobean@gmail.com>
To:     Stanley Chu <stanley.chu@mediatek.com>, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, avri.altman@wdc.com,
        alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     beanhuo@micron.com, asutoshd@codeaurora.org, cang@codeaurora.org,
        matthias.bgg@gmail.com, bvanassche@acm.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com,
        chaotian.jing@mediatek.com, cc.chou@mediatek.com,
        jiajie.hao@mediatek.com, alice.chao@mediatek.com
Date:   Mon, 07 Dec 2020 11:59:31 +0100
In-Reply-To: <20201207055006.24471-1-stanley.chu@mediatek.com>
References: <20201207055006.24471-1-stanley.chu@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2020-12-07 at 13:50 +0800, Stanley Chu wrote:
> WriteBootser flush during suspend is not necessary to be enabled if
> WriteBooster feature is disabled. Simply adding a check to prevent
> unexpected power drain.
> 
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 4879e87577e1..89fa8b9ac11d 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -5458,7 +5458,7 @@ static bool ufshcd_wb_need_flush(struct ufs_hba
> *hba)
>         u32 avail_buf;
>         u8 index;
>  
> -       if (!ufshcd_is_wb_allowed(hba))
> +       if (!ufshcd_is_wb_allowed(hba) || !hba->wb_enabled)
>                 return false;
>         /*
>          * The ufs device needs the vcc to be ON to flush.


Hi Stanley

In the 3.1 Spec:

"If the fWriteBoosterEn flag is set to zero, data written to any
logical unit is written in normal storage.
If the fWriteBoosterEn flag is set to one and the device is configured
in “shared buffer” mode, data written to any logical unit is written in
the shared WriteBooster Buffer."

so, IMO, fWriteBoosterEn is independant with WB buffer flush.

as for the flush:

"There are two methods for flushing data from the WriteBooster Buffer
to the normal storage: one is using an explicit flush command, the
other enabling the flushing during link hibernate state. If the
fWriteBoosterBufferFlushEn flag is set to one, the device shall flush
the data stored in the WriteBooster Buffer to the normal storage. If
fWriteBoosterBufferFlushDuringHibernate is set to one, the device
flushes the WriteBooster Buffer data automatically whenever the link
enters the hibernate (HIBERN8) state."

IMO, for the flush, it is controlled by fWriteBoosterBufferFlushEn and
fWriteBoosterBufferFlushDuringHibernate.

how do you understand the above two paragraphs from Spec?


thanks,
Bean


