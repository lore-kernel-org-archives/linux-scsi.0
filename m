Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FECBC00140
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Aug 2022 14:02:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237144AbiHBOCn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Aug 2022 10:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237014AbiHBOCR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Aug 2022 10:02:17 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB5182871C
        for <linux-scsi@vger.kernel.org>; Tue,  2 Aug 2022 07:02:15 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id u1so11836414lfq.4
        for <linux-scsi@vger.kernel.org>; Tue, 02 Aug 2022 07:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=0UzXuhE6yJcwl87VMTObzQUfGKkJDSW5LnrMp+jbqhs=;
        b=Y4dHHvintKOmRVO2Ms2dA0ZqYrdCW9AvjR0/yNnXIS+sSWBfDv5V3Ck2AUg2AyYLj3
         g9cxGOatvUFNKf7jOx6wWXNXSnE8EJpvSNPAx5MASiS8qtaEmUbelabEZlfFBUbqH31v
         /8n1zvu8ORV1ywV9LZ1kwhoW2EK6tEGO9tGYphVeFjbm1p6NUniuOx7WNu43AoxzIyV9
         MdxYkPnN3VIy6zMv/SgVDeBV84peCOpGRnNu1cRVmup1R+Xz8e7HVL1acOWw4tv0sz4g
         H+OkMKVNCrwQGWRrEVoTTW0622hNPqTH+rYHTB0gqhuKam4I4M0RM+ncBZUCE+m7wIqB
         6fAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=0UzXuhE6yJcwl87VMTObzQUfGKkJDSW5LnrMp+jbqhs=;
        b=y37heJp7YmmEAgwpMYB9Xdp3F1TAq8I8GnQBu7OYMnKULGEAru0vxmc6SAvwxvev0K
         yN2sD80NocG1tAx5cNW57TSKPVDa63Id67Z289VFBKFFf3pVcBZSbs9dPkxEfjPZeTcH
         6yrBLsDZ+d0sfcUHZiW1yainECbnWCcPFb4QiVNRzJIT+TxPL5TIffF7mG8xCAsl6XXI
         BGZz6OEb4xmzxMtReRwCXMnuhjAUC6IiBrHNf9qZogZdCvluuFfNrSgRXQWMC+ryyG+8
         s37ApxcjlSPdpmcxgBFDeCIs2BGg2kTX5DYAj0Z4Crp3MrEXDLytnYvIk2HV3MkFMEH+
         mMyw==
X-Gm-Message-State: AJIora/kIoP4f1BFDOuFo7RnDWrIfGafIpe+vKry6tEobtjZmAciRQGF
        z+QrJTrHzBW5ecAYzfXhsmwLayIkdD4Sz9DNNw==
X-Google-Smtp-Source: AGRyM1ux1TT8aEvnhCvivua72XsQNagFqcnYuzYOVKOhiawf4AJLoxYkrXXFPqq6a221cDDRGzWuvKcefgs6rPMZbKI=
X-Received: by 2002:a05:6512:1694:b0:48a:9d45:763f with SMTP id
 bu20-20020a056512169400b0048a9d45763fmr7213036lfb.662.1659448933851; Tue, 02
 Aug 2022 07:02:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220802132414.32607-1-peter.wang@mediatek.com>
In-Reply-To: <20220802132414.32607-1-peter.wang@mediatek.com>
From:   Stanley Chu <chu.stanley@gmail.com>
Date:   Tue, 2 Aug 2022 22:02:02 +0800
Message-ID: <CAGaU9a96uHTqaG_9n0jUVDuqfyzmD_hQE_h_n4rbUuS_u-6tUg@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] ufs: allow host driver disable wb toggle druing
 clock scaling
To:     peter.wang@mediatek.com
Cc:     stanley.chu@mediatek.com, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, avri.altman@wdc.com,
        alim.akhtar@samsung.com, jejb@linux.ibm.com,
        wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Peter,

On Tue, Aug 2, 2022 at 9:25 PM <peter.wang@mediatek.com> wrote:
>
> From: Peter Wang <peter.wang@mediatek.com>
>
> Mediatek ufs do not want to toggle write booster during clock scaling.
> This patch set allow host driver disable wb toggle during clock scaling.
>
> Peter Wang (2):
>   ufs: core: introduce a choice of wb toggle during clock scaling
>   ufs: host: support wb toggle with clock scaling
>
>  drivers/ufs/core/ufs-sysfs.c | 3 ++-
>  drivers/ufs/core/ufshcd.c    | 8 +++++---
>  drivers/ufs/host/ufs-qcom.c  | 2 +-
>  include/ufs/ufshcd.h         | 7 +++++++
>  4 files changed, 15 insertions(+), 5 deletions(-)
>
> --
> 2.18.0
>
Except for some typos in the commit messages, otherwise this series
looks good to me.

Please feel free to add
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
