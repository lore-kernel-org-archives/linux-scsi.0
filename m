Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E82B0C04A68
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jul 2022 21:57:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbiG1V5m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jul 2022 17:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbiG1V5l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jul 2022 17:57:41 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C37B578599
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jul 2022 14:57:39 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id os14so5377419ejb.4
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jul 2022 14:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-transfer-encoding:user-agent:mime-version;
        bh=tBTdEaMEquzGdtE2SVb08phk2G37dgthWhMmnNyIQXQ=;
        b=qik0nU5JmZ2hSKOH6hggscV2BAG/9N43fjICFDnIr6Oh/1KThVNlL8CfCushErjX/d
         IwWpVHdXnlq//A+OM/PmZ1AuA6B8VEUNNWISmAN9OXwBLbiBWPNTG++yr54nLElqx3SG
         cg6LPIb7J6kqStPN5zyIcNMEb4G/hfniIqXzOtVyFaVv2gGgshZLIt9EWOPRLDYIBTkQ
         VCoUDBWQ2YOmtPlc3tBLIKPBINlS4D4JUbh11vm9x/mo+i+rNwj0RBfqBkSTAAyGEn6N
         so4OQLRl8f+9W6Bn0IsHelSLP6d5vugbxdW3pSru/XvDy9Nwp1bRg0cse35SadiK6mlZ
         XOMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:content-transfer-encoding:user-agent:mime-version;
        bh=tBTdEaMEquzGdtE2SVb08phk2G37dgthWhMmnNyIQXQ=;
        b=e1+iP5oe9xBxTP+8roT1oXNc828lf7+v7dDVMwql9/5DqzQDfNmawvjft3bmNhKbDo
         s+Eyh28+lv5bQDIQUOQ9XyUMJ1FN55pBQhYExm2gogU3Z2bLZWIh1I5NmZAKwkkCxSlw
         5EomUXIhGlZy44CFZjI+4WenY3Yf8BC9EfW5axACvfW7wthCxoboFCRGcA1xzxswnZ4g
         1H8kpWjNe36i6mhCy9QrIeAp6BhSUQuX0tpgJ8HNl1yjjhboNCZ4AzyqhxjKyHpfufu3
         tkDqKF7qdm60Vo4zJgxLTbJUyyHIHsEzN09ZagrDXbpqxBVa2HsvOBIfYJtWtEcHdhw4
         k7wQ==
X-Gm-Message-State: AJIora/BZNMV3cnoU3LvvaWWrhvkoG5vV/P5UEYatZFTzS2mXD1H3/m8
        1tfkL9aJObHFIrUNh68RdePQkDiBFvKMvA==
X-Google-Smtp-Source: AGRyM1vYCId71UEtdFiUSjVInECfR19OlxaAJET7OeqVtqFaeLICO+T9alMwOQ0yumwgipWSgA9SbQ==
X-Received: by 2002:a17:907:6e13:b0:72b:509e:bd6b with SMTP id sd19-20020a1709076e1300b0072b509ebd6bmr688038ejc.202.1659045458144;
        Thu, 28 Jul 2022 14:57:38 -0700 (PDT)
Received: from p200300c5870e1483ac11a16c0f4ae195.dip0.t-ipconnect.de (p200300c5870e1483ac11a16c0f4ae195.dip0.t-ipconnect.de. [2003:c5:870e:1483:ac11:a16c:f4a:e195])
        by smtp.googlemail.com with ESMTPSA id y6-20020a50eb86000000b0043bd192e826sm1377247edr.17.2022.07.28.14.57.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 14:57:37 -0700 (PDT)
Message-ID: <ea3b173cb2575dbb81cb416469880c50dd536bd0.camel@gmail.com>
Subject: Re: [PATCH v1 2/2] ufs: host: support wb toggle with clock scaling
From:   Bean Huo <huobean@gmail.com>
To:     peter.wang@mediatek.com, stanley.chu@mediatek.com,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com
Date:   Thu, 28 Jul 2022 23:57:37 +0200
In-Reply-To: <20220728071637.22364-3-peter.wang@mediatek.com>
References: <20220728071637.22364-1-peter.wang@mediatek.com>
         <20220728071637.22364-3-peter.wang@mediatek.com>
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
> Set UFSHCD_CAP_WB_WITH_CLK_SCALING for qcom to compatible legacy
> design.
>=20
> Signed-off-by: Peter Wang <peter.wang@mediatek.com>
> ---
> =C2=A0drivers/ufs/host/ufs-qcom.c | 2 +-
> =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-
> qcom.c
> index f10d4668814c..f8c9a78e7776 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -869,7 +869,7 @@ static void ufs_qcom_set_caps(struct ufs_hba
> *hba)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct ufs_qcom_host *hos=
t =3D ufshcd_get_variant(hba);
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0hba->caps |=3D UFSHCD_CAP=
_CLK_GATING |
> UFSHCD_CAP_HIBERN8_WITH_CLK_GATING;
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0hba->caps |=3D UFSHCD_CAP_CLK_=
SCALING;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0hba->caps |=3D UFSHCD_CAP_CLK_=
SCALING |
> UFSHCD_CAP_WB_WITH_CLK_SCALING;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0hba->caps |=3D UFSHCD_CAP=
_AUTO_BKOPS_SUSPEND;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0hba->caps |=3D UFSHCD_CAP=
_WB_EN;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0hba->caps |=3D UFSHCD_CAP=
_CRYPTO;

Hi peter,=20

If WB is on/off based on clk scaling up/down is legacy design, maybe
you have a more advanced design. It is true there is an issue since we
didn't differentiate the read or write. WB is only for write. How to
know this time clk scaling is for write from driver level, not possible
now.

Kind regards,
Bean
