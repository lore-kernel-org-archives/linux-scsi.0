Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71295C6FD18
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Mar 2023 01:32:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbjC2Bcp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Mar 2023 21:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjC2Bcm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Mar 2023 21:32:42 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A561706;
        Tue, 28 Mar 2023 18:32:41 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id bi9so18156017lfb.12;
        Tue, 28 Mar 2023 18:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680053560;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R+bl2jOqAxhapHDrn1yb1EQ5+zvuHUKPCi6FQtw5dMg=;
        b=YA40+Qhla2B04rSM3SnBmkaxakoM4INVok5CAbJ2EXY+z3ICXnU1c1M5qRym2sQrDF
         TIFApfhL0AXhR+DabzE0zHoX8Pl+gJgkm7oyeLFnB7r1RPULHEgeZJGggPw2tQVqN/tI
         9AZOiYQQOxkG0CwdxnN98dCVMdc9cRTGg4bfysvN6ScLDZfHrSYbkEPior8lH7dfPsEH
         tceSvz5H9IzTvM0F/NBRJsZeNTI+Gu9PqcYxgiGPqxteD1znbtt7nw3amlen0ImgV+OT
         gbpk2dblyx422jTvGFbM9ZlhDJ9ddrOJfT1/mqVFav/7o/IHMl/87+mgbsgDCXF16lMJ
         KtmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680053560;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R+bl2jOqAxhapHDrn1yb1EQ5+zvuHUKPCi6FQtw5dMg=;
        b=3wsR1nNRtE53t69Jcr9VqX5OobofIoC5t/lxvdGOOMyE1IxdZfCtL6i06PPXgjpel+
         B0Sxw9DpgTYBIVgDQ2DtHrRCkA4+z9NJXC0mULdhBY4l+BQhD8qhmufhCKfkWspGb3hd
         yJ9lbaPuzavhBUARGVCExq/TnN6/OlymdzBiPk6KKlpv//w+FvcKvrtUiXHXREtlLWfl
         VwKLrAdocqju95uJ152AN8667IpJP5VTsZf7zc8ktYJSeiQw58XNsBBJ9jgKoz2kNx69
         F3eS1d2DVQ6pKJsVh7KrBUMvIgjpG7jA4Yk+JSlBpXwdhEkpzyNKtrgSFMpIZfg0XtmC
         Gj7g==
X-Gm-Message-State: AAQBX9ebX9oNGCjhGa6I+OMyFqJ4IUF2pMmm7dCpaI1voxz157QTsq5s
        xbeUiD+ew4o2/MKM8wFkdbpuFoyhyMPcU1Ka7si5RKCAxn/X5VA=
X-Google-Smtp-Source: AKy350ZJ9jIcLlIPvnGyeqDurFEL4h5eLrfQa1R7Mv2CsUszEPgG4iU/d/cmPNe4aFnJMdQZM7nB7di2+4aaCIXKVyc=
X-Received: by 2002:a05:6512:159e:b0:4e8:4409:bb76 with SMTP id
 bp30-20020a056512159e00b004e84409bb76mr309412lfb.2.1680053559678; Tue, 28 Mar
 2023 18:32:39 -0700 (PDT)
MIME-Version: 1.0
References: <20230328103801.11198-1-powen.kao@mediatek.com> <20230328103801.11198-2-powen.kao@mediatek.com>
In-Reply-To: <20230328103801.11198-2-powen.kao@mediatek.com>
From:   Stanley Chu <chu.stanley@gmail.com>
Date:   Wed, 29 Mar 2023 09:32:28 +0800
Message-ID: <CAGaU9a8f37ZyMjVyYnonNCro55UQJ033Ns+LoaOcWDUg3Gp=3A@mail.gmail.com>
Subject: Re: [PATCH 2/2] scsi: ufs: ufs-mediatek: Add UFSHCD_QUIRK_MCQ_BROKEN_INTR
 quirk
To:     Po-Wen Kao <powen.kao@mediatek.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
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

On Tue, Mar 28, 2023 at 6:42=E2=80=AFPM Po-Wen Kao <powen.kao@mediatek.com>=
 wrote:
>
> Set UFSHCD_QUIRK_MCQ_BROKEN_INTR for mtk driver
>
> Signed-off-by: Po-Wen Kao <powen.kao@mediatek.com>
> ---
>  drivers/ufs/host/ufs-mediatek.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> index 73e217260390..b4a4a580ad37 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c
> @@ -901,6 +901,8 @@ static int ufs_mtk_init(struct ufs_hba *hba)
>         hba->caps |=3D UFSHCD_CAP_CLK_SCALING;
>
>         hba->quirks |=3D UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL;
> +       hba->quirks |=3D UFSHCD_QUIRK_MCQ_BROKEN_INTR;
> +
>         hba->vps->wb_flush_threshold =3D UFS_WB_BUF_REMAIN_PERCENT(80);
>
>         if (host->caps & UFS_MTK_CAP_DISABLE_AH8)
> --
> 2.18.0
>

Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
