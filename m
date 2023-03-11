Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA68DC6FD19
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Mar 2023 02:05:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbjCKCFx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Mar 2023 21:05:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbjCKCFt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Mar 2023 21:05:49 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9BC1143688;
        Fri, 10 Mar 2023 18:05:48 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id i28so9069271lfv.0;
        Fri, 10 Mar 2023 18:05:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678500347;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JFMM/LW85+BkmtqLGtTq7h5t/zGOgNTjSKHsZWTz0ks=;
        b=Bd/+0fto6WSHdEzDcuwWFsiVdUjzT1t4KSbBXI4q6x09sK0ONCUG0g4800pnmlPKWx
         HNd0aCeoGFE9R6HrD5X/7KNzBupSaBCJWTYYHpAeyo6KSeM8JJHe1/9gHM4W+2vAQxg6
         NbR9mi+myDFeGdDQWhQGmC0VJc0Rpx5ictYCkjqgz5TDQ7ZmhPHIVa2ohrv+yvREijT+
         OxnLVq/8yKaMufdBizA84T5pshIDzgubAqLSRHe+B5BCgs2w1D31V33uHSxiH+P+7oBh
         BYwySXTW2pnjkFxNdDPhG/rkEYuyRxBHZdUzgbea8nfZLlHeSj1YW0gecXkdWtQPBMch
         7PVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678500347;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JFMM/LW85+BkmtqLGtTq7h5t/zGOgNTjSKHsZWTz0ks=;
        b=O9PqI3O/a0qhsnXebfvHIBEUZ2kqW/tSF5q/Ha3WJerynM2jfHRfulSkBemd9mEqj0
         wjOQWsBw0wHZhK3rNqGm52sbfVNSf22d99WyqYcnerSHzAea+lLicd3sSBRAjo6vFRpx
         P6bG0iSAeFL3iVH4+tGhki2jXlhhCIbZE6vAGbomUmc6wZCX4n8vtAOmrUABhhbNOcVi
         eKSrXY6tNJ7BZRhhe/yQr1PmMw2ommoVmjD7ZxjahHRh+kaLCV/tR1yzcs2hqBvclJi3
         t0WTPNt60Jl2qNnCm03QyKC+qx8yKZ7ypdWrjnsmfIAfpypZEXd6OuFSM3YcosboDCVw
         Xa/A==
X-Gm-Message-State: AO0yUKXDO/P0pzSZB8MUSaxC8ZBY6E75mb/s/8MM0iMihtxzXsrh9BGK
        YNCs5g0yg5eozIrkdhkbOTziCd9GRek2zIJfNA==
X-Google-Smtp-Source: AK7set+lQcIx9X3YBDKKn3Bwz3OktR/0HzADRDx80+zlEgH3rVxeKKai9VN2RdVnOt2ZBcD1lWiW6A6CyQPq32uOFo8=
X-Received: by 2002:ac2:44b4:0:b0:4d5:ca43:703d with SMTP id
 c20-20020ac244b4000000b004d5ca43703dmr8437303lfm.0.1678500346671; Fri, 10 Mar
 2023 18:05:46 -0800 (PST)
MIME-Version: 1.0
References: <20230307065448.15279-1-powen.kao@mediatek.com> <20230307065448.15279-6-powen.kao@mediatek.com>
In-Reply-To: <20230307065448.15279-6-powen.kao@mediatek.com>
From:   Stanley Chu <chu.stanley@gmail.com>
Date:   Sat, 11 Mar 2023 10:05:35 +0800
Message-ID: <CAGaU9a92W5a_z_0cg=-BD_dAzzcN_SrpyN+MzN7xXefmeb-D8w@mail.gmail.com>
Subject: Re: [PATCH v4 5/5] scsi: ufs: ufs-mediatek: Add MCQ support for MTK platform
To:     Po-Wen Kao <powen.kao@mediatek.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        wsd_upstream@mediatek.com, peter.wang@mediatek.com,
        alice.chao@mediatek.com, naomi.chu@mediatek.com,
        chun-hung.wu@mediatek.com, cc.chou@mediatek.com,
        eddie.huang@mediatek.com, mason.zhang@mediatek.com,
        chaotian.jing@mediatek.com, jiajie.hao@mediatek.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Mar 7, 2023 at 2:57=E2=80=AFPM Po-Wen Kao <powen.kao@mediatek.com> =
wrote:
>
> Changes
> - Implement vops and setup irq
> - Fix pm flow under mcq mode
>
> Signed-off-by: Po-Wen Kao <powen.kao@mediatek.com>
> ---
>  drivers/ufs/host/ufs-mediatek.c | 192 +++++++++++++++++++++++++++++++-
>  drivers/ufs/host/ufs-mediatek.h |  33 ++++++
>  2 files changed, 223 insertions(+), 2 deletions(-)
>

Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
