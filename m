Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E36E3C04A68
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jul 2022 21:41:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbiG1Vl7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jul 2022 17:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiG1Vl5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jul 2022 17:41:57 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2CC06069C
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jul 2022 14:41:56 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id a89so3751478edf.5
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jul 2022 14:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-transfer-encoding:user-agent:mime-version;
        bh=DCg7GtaSXROd2kWLXvtaVXu/XbXGSeBpgg9VkrvNnNE=;
        b=b6m9nDIZZSRG2d7BV+fokw/IEYjz2hmiRQGUs5o4rmX/IPX32M6hu7ihafxYzP0ruW
         xgyyaBQAJy87jCgzACousrmqqFThpkKGdlQjiPDt0OR7hdohlWy/RCFO1cjxcJE4u+M7
         AC+3elsTvx48xUuU6b+U1xDwdrZD7i4Db1hW6ugl6oC+G/QdO9Vpx9oxWo3VmsNzl0Ea
         XT5092253qK8gXvLrqkR9aI0Xo8CyB/tBBb4zBADllCxxCm/L1T3DWR1mkmWs/Ue33Ps
         GjAu9A4dDOO/WQOGoimN4gK3QsFU/JwqLHRQZQ9+ZpozTBJKU4g+PWKDBId6RbSNeCVH
         Fm9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:content-transfer-encoding:user-agent:mime-version;
        bh=DCg7GtaSXROd2kWLXvtaVXu/XbXGSeBpgg9VkrvNnNE=;
        b=AWTW+5sSl1rkVSZ5csuG2w43Q38QSck/IbLoN3vuiAUUeVGHVzs6+LCkzErDE+bcKf
         XLq3z72wI0DPO/XNxpztvarxvqMgYIfuZ4MmmJXzOpyVmial7LO4rKlphby4lmJ1EbGq
         DuWVGf3uR8paJ1thBkyo69jXjL/XOGfFx3LHVsuwwLKlxucUdTAmEwfkx8hyAVsBxiPM
         /Mf7xkI3xWUGfVYTAuYfRseB203i085ZZV8nXzpC7FjO7h07PT50GowAJsHFDZZAbkJ4
         +RVkFga/Cz5hYyerIu+CXzrHVnaJBIqjVTla7LNd9s1xsaM38a3VCL117FRVt4rPodBa
         rE5A==
X-Gm-Message-State: AJIora/fLIcxckhyL+7ik8DjswUmKZGMCLDvrP16ZlbcIPZFbWt4y2Es
        ZVK1SV8u6/4tKqjwlCpew6NQzlDdWm4nDQ==
X-Google-Smtp-Source: AGRyM1uWKigPK1kK4wjfeeVfkpJx5hKTWn8qmigyXCcCq0xxwAMewuPEYKP8gwjgLe9B5YISj+2p8Q==
X-Received: by 2002:a05:6402:1011:b0:43a:76bf:6c40 with SMTP id c17-20020a056402101100b0043a76bf6c40mr885484edu.352.1659044515478;
        Thu, 28 Jul 2022 14:41:55 -0700 (PDT)
Received: from p200300c5870e1483ac11a16c0f4ae195.dip0.t-ipconnect.de (p200300c5870e1483ac11a16c0f4ae195.dip0.t-ipconnect.de. [2003:c5:870e:1483:ac11:a16c:f4a:e195])
        by smtp.googlemail.com with ESMTPSA id f7-20020a056402068700b0043adc6552d6sm1362159edy.20.2022.07.28.14.41.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 14:41:55 -0700 (PDT)
Message-ID: <b9fab29cde42cb9573616092329089f45cd27af2.camel@gmail.com>
Subject: Re: [PATCH v1 1/2] ufs: core: interduce a choice of wb toggle in
 clock scaling
From:   Bean Huo <huobean@gmail.com>
To:     peter.wang@mediatek.com, stanley.chu@mediatek.com,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com
Date:   Thu, 28 Jul 2022 23:41:54 +0200
In-Reply-To: <20220728071637.22364-2-peter.wang@mediatek.com>
References: <20220728071637.22364-1-peter.wang@mediatek.com>
         <20220728071637.22364-2-peter.wang@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On Thu, 2022-07-28 at 15:16 +0800, peter.wang@mediatek.com wrote:
> From: Peter Wang <peter.wang@mediatek.com>
>=20
> Vendor may wan't disable/enable write booster while clock scaling.
> Introduce a flag UFSHCD_CAP_WB_WITH_CLK_SCALING to decouple WB and
> clock scaling.
>=20
> UFSHCD_CAP_WB_WITH_CLK_SCALING only valid when UFSHCD_CAP_CLK_SCALING
> is set. Just like UFSHCD_CAP_HIBERN8_WITH_CLK_GATING is valid only
> when
> UFSHCD_CAP_CLK_GATING set.
>=20

Hi Peter,

probably "interduce" is a typo in your subject?

Kind regards,
Bean
