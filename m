Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3B60C4361B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 14:14:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC86423A77
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 14:14:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729601AbgLHOO1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 09:14:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729457AbgLHOO1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 09:14:27 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22BB7C061749;
        Tue,  8 Dec 2020 06:13:47 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id c7so17719327edv.6;
        Tue, 08 Dec 2020 06:13:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eSPfpQbfD8TtnWjYs+6jj8qzhsWODAim1cckJ/MJTu0=;
        b=pMxp4TNM4M+N05Yx9TQgHM79zWQBDbpvpnmuI555O1zxarA53NmboJkgdjPiAvm2rk
         tA5Nxy3pEFTL8n62f5NDpQA2anFbpBzV6UuZnAmMdt23xIg1F4mQWZtvO0Ea4oWZhiqR
         Mk788rhqKcb8Z+qCwERSPi7jnRwjPYRDARTP9lDWSyID9m+1ZcJ8ccjghI6h6AZrh5C3
         2AdQvAAw5BgPumeEHZboIkxXk2yESbZyjnBCrArWoBb7TIKKaC+w3ANmYjV5CD8tdlck
         yGAsthsXggHQnxbc/Why3OhoTu2e/oBSBGMEEPYd2fLqeayYYbcl1HqO0wDamcPNgkdF
         OaGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eSPfpQbfD8TtnWjYs+6jj8qzhsWODAim1cckJ/MJTu0=;
        b=Iq2Jnh3FvMXcotoSClQ3hLSw3Dwy34Lys/OGAEebO8dHjNoSuVgb1eRR9P38Bw2wub
         R1yKWs681GCHNrF7CEj5+sCLuW60QEbaD2QMEwZUT/BAFToxpVZ7oj9GKqISazbqC+Mp
         EmHrEUggY7s/UVRFDKBrp5vDUesmOg5istNKCQftQ8lQAcmkLCnQfNSUWibxN+i+SuXz
         tWoLIzRFZs9n2KUUcJwke6saDRFfS+EUwijzhNQcnH88zhXtjrsGJSgZa8SIojihW/cV
         ExbcOVdl6LQHLhciSBFieGMUeFSn3nWOo7q7ccSfmu7yQtUTd78tt3E2suCijaDojsRU
         8jMg==
X-Gm-Message-State: AOAM533gFVzl6m6pyfU+gxKO5ey7GbW45SKMCYCPb/EAo2CiST9j6Qyx
        NoaT2V+FzwTY+nHhglv6GpE=
X-Google-Smtp-Source: ABdhPJxT3MS0tLQzrz5zGTrmxsemf1EdNibb6+Ece9/iVj28PTNygmtdP13l0xPVSWG+mugPOMO4PA==
X-Received: by 2002:a50:fb1a:: with SMTP id d26mr25055415edq.101.1607436825849;
        Tue, 08 Dec 2020 06:13:45 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.googlemail.com with ESMTPSA id s5sm15577093eju.98.2020.12.08.06.13.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 08 Dec 2020 06:13:45 -0800 (PST)
Message-ID: <970af8b1abf565184bf37c3c055bf42ad760201a.camel@gmail.com>
Subject: Re: [PATCH v2 1/2] scsi: ufs: Re-enable WriteBooster after device
 reset
From:   Bean Huo <huobean@gmail.com>
To:     Stanley Chu <stanley.chu@mediatek.com>, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, avri.altman@wdc.com,
        alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     beanhuo@micron.com, asutoshd@codeaurora.org, cang@codeaurora.org,
        matthias.bgg@gmail.com, bvanassche@acm.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        nguyenb@codeaurora.org, bjorn.andersson@linaro.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com,
        chaotian.jing@mediatek.com, cc.chou@mediatek.com,
        jiajie.hao@mediatek.com, alice.chao@mediatek.com
Date:   Tue, 08 Dec 2020 15:13:43 +0100
In-Reply-To: <20201208135635.15326-2-stanley.chu@mediatek.com>
References: <20201208135635.15326-1-stanley.chu@mediatek.com>
         <20201208135635.15326-2-stanley.chu@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2020-12-08 at 21:56 +0800, Stanley Chu wrote:
> index 08c8a591e6b0..36d367eb8139 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -1221,8 +1221,13 @@ static inline void
> ufshcd_vops_device_reset(struct ufs_hba *hba)
>         if (hba->vops && hba->vops->device_reset) {
>                 int err = hba->vops->device_reset(hba);
>  
> -               if (!err)
> +               if (!err) {
>                         ufshcd_set_ufs_dev_active(hba);
> +                       if (ufshcd_is_wb_allowed(hba)) {
> +                               hba->wb_enabled = false;
> +                               hba->wb_buf_flush_enabled = false;
> +                       }
> +               }

Stanley,
how do you think group wb_buf_flush_enabled and wb_enabled to the
dev_info, since they are UFS device attributes. means they are set only
when UFS device flags being set.

Reviewed-by: Bean Huo <beanhuo@micron.com>

