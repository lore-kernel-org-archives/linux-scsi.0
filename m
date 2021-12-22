Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B5F9C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Dec 2021 06:48:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242815AbhLVGsm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Dec 2021 01:48:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233215AbhLVGsl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Dec 2021 01:48:41 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0905FC06173F
        for <linux-scsi@vger.kernel.org>; Tue, 21 Dec 2021 22:48:41 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id u22so2182175lju.7
        for <linux-scsi@vger.kernel.org>; Tue, 21 Dec 2021 22:48:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NSkDFoSerZVrmpLUilEfV8Ju2E4v5m7ZKobzRBew9sw=;
        b=mEC1KfAwMvoAoyjVKDIGpaOLh80+Y/8/xezFZ1BLp994C5sEoKe3q3md8D4fzDyDbk
         FloATRehA0zl19Me9KCKvGjRSoAM9nD2q5Y9g8wdVB20G7bMA2NlXZNjYSbnpj96VGts
         DKRPGYXR9DbMka+rF+2fpac9vkLiM3thWRWls=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NSkDFoSerZVrmpLUilEfV8Ju2E4v5m7ZKobzRBew9sw=;
        b=6xP84bdeSewfTcIFJKX8GaWMeopuMpi/gbLmmubHX7leeGFh6CRN1tF+9xABWwcCvS
         HpvmoTGTNegBAaP11nwyEEDHZEhHBeBtWxgAUximCKY/V5lOSTLGJrRixozYjw/H+/Ny
         XvCd4ptru0PCeDhncoiJMPLrhaj/yAgOebcg0w4qZm0cM7HSFr+k/3w7/MtUgw4PNG+p
         EN50bXEjG+sbkCBJ+IOGqzQO9BSOZibLlJbVp0F5j6Yah+2Z+3GkgKaUccAcb1RDgOFq
         16L9+rgAX6fC9+U4it57abg0OBb3z2xdGedqGPH4vbTWue9JOShBYaB2wXcueDZMCFf4
         hGqw==
X-Gm-Message-State: AOAM532xyno/aDi/meUTT4hGCKTY0Uii9yxXmUlG9hgXQXU+e1JeAwEP
        TJFF4doaEqJfuPsSywqBE8sagN7HCFzuO6RNdkcHZw==
X-Google-Smtp-Source: ABdhPJwYuCHiq0ppLpf4B056P0N88O5bHGRzhgw4jU3lnH8UCjNrBnXr/enwCxheyjFZfYfLP7YvdLpHLB7uLjwdqdE=
X-Received: by 2002:a2e:aa14:: with SMTP id bf20mr1254932ljb.376.1640155719274;
 Tue, 21 Dec 2021 22:48:39 -0800 (PST)
MIME-Version: 1.0
References: <20211222062444.16144-1-linmq006@gmail.com>
In-Reply-To: <20211222062444.16144-1-linmq006@gmail.com>
From:   Chen-Yu Tsai <wenst@chromium.org>
Date:   Wed, 22 Dec 2021 14:48:28 +0800
Message-ID: <CAGXv+5GF1WOeXVtnknAa4GYXE3Hd-UzcCBCyQzT6KY3tJCrVGA@mail.gmail.com>
Subject: Re: [PATCH] scsi: ufs: ufs-mediatek : Fix NULL vs IS_ERR checking in ufs_mtk_init_va09_pwr_ctrl
To:     Miaoqian Lin <linmq006@gmail.com>
Cc:     Stanley Chu <stanley.chu@mediatek.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-scsi@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Dec 22, 2021 at 2:25 PM Miaoqian Lin <linmq006@gmail.com> wrote:
>
> The function regulator_get() return error pointer,
> use IS_ERR() to check if has error.
>
> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>

Please add

Fixes: cf137b3ea49a ("scsi: ufs-mediatek: Support VA09 regulator operations")

so that the patch has a chance to get picked into stable.
