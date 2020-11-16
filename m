Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 899EDC55ABD
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 09:15:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27B112224F
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 09:15:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cF2NsUGs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbgKPIqh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 03:46:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728204AbgKPIqg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Nov 2020 03:46:36 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8796C0613CF;
        Mon, 16 Nov 2020 00:46:35 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id oq3so23243823ejb.7;
        Mon, 16 Nov 2020 00:46:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mCofBzJy30fhjMWH00xS2hq/jknrv2dfs6NyvbseoFQ=;
        b=cF2NsUGse1hW5wog8Dq0U2TGCaUVhqzE3884hcp6wAXvED/krAr2Ix/jOrSD6KlO52
         daxM3IW8Vu7LKLxCHjNX10SXtQrafdintDb9tT17PS+9uAA+4XWEDKqTgWLR7gnJ9Mkw
         sz1KB/BAr8EpO6aS9T6QZvlL6i5reWJAYt/GqhXgnSraoqMfP7KuXiMUnb9VT4Fp90Bi
         fzhr+/6HyojcHkLQhNvkzTJfiL5EOvvQxnKmZKhfdWK+kbQfjR7L1zhXYpuH8Ti126ku
         lcaUbLMdifRoLHlhykcq2eueEWDErBWBtYKRWVmXOk+eqEsrjqP6dOPIIp4pUE8y20Dh
         iDeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mCofBzJy30fhjMWH00xS2hq/jknrv2dfs6NyvbseoFQ=;
        b=hLKTVwGcNgCYGKmPn6rIOQM68+CQrAqtMeVC8nV8Da5KlEjIn1EWrkp46KYs3Xot1y
         Hlrr6B8z4XsHnYsg0GPhKps9+0Lwrk4NCSAynlyhWwury7zIxhtpT7UAS8WfDtK+dBFW
         3CWtsExn5PzRwVDgK2kOIlXgelVCwaLsGbVhGkbvxDnsR7dEI1CC6AqnzVN0jzvXodRc
         ynz2PB+1QyqmNBKUSQuZVQm+y4g0TvGFUneqrmWFEaNN4Ss77nGG/lbRm5/zze53B2A+
         Fe5wKkix1TODcKuXsBYmYCSjJ487hR7WhpG3LFDoYJLYEpaYP+hcHTb9LM8MQxHwQWYQ
         XzAw==
X-Gm-Message-State: AOAM532bDMQJkPXq85CdPHH/YKbNJ350nM1ANECEs+92uB5GR0/DPCOe
        anTaHNmqa6ljknq9OujwYK4=
X-Google-Smtp-Source: ABdhPJwLUUiqwOrEc50Ra9NiKEF2Cm/Ktj5Ut9whQJY21mzZcz2RIKdMsxfQo2Kk8N9rTYtN4B7RSQ==
X-Received: by 2002:a17:906:b749:: with SMTP id fx9mr4956570ejb.0.1605516394490;
        Mon, 16 Nov 2020 00:46:34 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bee22.dynamic.kabel-deutschland.de. [95.91.238.34])
        by smtp.googlemail.com with ESMTPSA id nd5sm10128807ejb.37.2020.11.16.00.46.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 16 Nov 2020 00:46:34 -0800 (PST)
Message-ID: <40d184834e6953982ac31b719d9803c81b3d61f4.camel@gmail.com>
Subject: Re: [PATCH v1 0/9] scsi: ufs: Refactoring and cleanups
From:   Bean Huo <huobean@gmail.com>
To:     Stanley Chu <stanley.chu@mediatek.com>, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, avri.altman@wdc.com,
        alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     beanhuo@micron.com, asutoshd@codeaurora.org, cang@codeaurora.org,
        kwmad.kim@samsung.com, liwei213@huawei.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com,
        chaotian.jing@mediatek.com, cc.chou@mediatek.com,
        jiajie.hao@mediatek.com, alice.chao@mediatek.com
Date:   Mon, 16 Nov 2020 09:46:32 +0100
In-Reply-To: <20201116065054.7658-1-stanley.chu@mediatek.com>
References: <20201116065054.7658-1-stanley.chu@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2020-11-16 at 14:50 +0800, Stanley Chu wrote:
> Hi,
> This series simply do some refactoring and cleanups in UFS drivers.
> 
> Stanley Chu (9):
>   scsi: ufs-mediatek: Refactor performance scaling functions
>   scsi: ufs: Introduce device parameter initialization function
>   scsi: ufs-mediatek: Use device parameter initialization function
>   scsi: ufs-qcom: Use device parameter initialization function
>   scsi: ufs-exynos: Use device parameter initialization function
>   scsi: ufs-hisi: Use device parameter initialization function
>   scsi: ufs: Refactor ADAPT configuration function
>   scsi: ufs-mediatek: Use common ADAPT configuration function
>   scsi: ufs-qcom: Use common ADAPT configuration function
> 
>  drivers/scsi/ufs/ufs-exynos.c    | 15 +---------
>  drivers/scsi/ufs/ufs-exynos.h    | 13 --------
>  drivers/scsi/ufs/ufs-hisi.c      | 13 +-------
>  drivers/scsi/ufs/ufs-hisi.h      | 13 --------
>  drivers/scsi/ufs/ufs-mediatek.c  | 51 ++++++++++++++--------------
> ----
>  drivers/scsi/ufs/ufs-mediatek.h  | 16 ----------
>  drivers/scsi/ufs/ufs-qcom.c      | 27 +++--------------
>  drivers/scsi/ufs/ufs-qcom.h      | 11 -------
>  drivers/scsi/ufs/ufshcd-pltfrm.c | 17 +++++++++++
>  drivers/scsi/ufs/ufshcd-pltfrm.h |  1 +
>  drivers/scsi/ufs/ufshcd.c        | 16 ++++++++++
>  drivers/scsi/ufs/ufshcd.h        |  3 ++
>  12 files changed, 65 insertions(+), 131 deletions(-)
> 

This series looks good to me, thanks.

Reviewed-by: Bean Huo <beanhuo@micron.com>

