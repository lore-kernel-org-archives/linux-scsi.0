Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AE1BC4361B
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 06:32:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BBFE229EF
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 06:32:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725832AbgLGGcB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 01:32:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725681AbgLGGcB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 01:32:01 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A69C0613D0
        for <linux-scsi@vger.kernel.org>; Sun,  6 Dec 2020 22:31:14 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id k4so12504946edl.0
        for <linux-scsi@vger.kernel.org>; Sun, 06 Dec 2020 22:31:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=znkNDbBbDHgiw3XuSJL4fJ/G0rYMAONXrt8IiNgFFbU=;
        b=LwVK4ZXjHxG6TEIGTfyDazx/Ar7ZdZ0eNsSD/0lmiEZ0U/kU43+94DVJDURGP31Z5G
         MgB8b2+zCjERyB6O6M4HmvhUKxjfVgUb7+uOfRGw4/AuLE6537mq6PnoXAAAb1MyviIa
         vPBAKF+q8RCAQv85B2nKk1xxnQvTwyUmZLqwKhcn6EXjtU13dVFHNd2menbrVtaZI3WJ
         +49DdF57iB4cAOB4mjtPDJA3lTa9da5jyMRXV7Y5S/aCkZGWNtQ1zAqnrxsCB3LMm4Mr
         JKbEzkteAYGmNSD2SDT50vleOf4JtVeywZHPdV2/YEo0NASDI7RhRC5M2Gvg+OVlLSpR
         Qngw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=znkNDbBbDHgiw3XuSJL4fJ/G0rYMAONXrt8IiNgFFbU=;
        b=Vo6/ANQbJYs0OW1ThKyjRanvmNE7st3AUuq2zqN2n7YyHcYS9Z/etKO5fCCaUv4Mwo
         2guOdw1OVkbD1uov6qIj3VHKUVV+xjqWI/X/Wg+ayXZhqojIxHc0KIC/2eDioJos8Q8B
         R2vtAKl2XdEHh4HYnHhjvgXYQNSOCokjfh+gjrkAw/vbO7pXvFoC83/2VSoSdGj1n1Bj
         nC/ZJShWnh9J/D0PGrGXSHdgKo8t+GC1Ia23+xmbywQH0XftI70ZmIB6yX2pZscEqyKR
         mD5N3Xl+rHCMOG68rnHZL8Lcczy6PPIEPn4AKZwBGcmV0lCH3C8NZ5UF7SHop8Z0JVEU
         cqzQ==
X-Gm-Message-State: AOAM531LMxCILUDVgdRzZ4DgGZCZyToGqZNMHPYQb5DAu9Rtpp05IYTX
        Sx6OE/i/wprbLuEo5AAUPmLDV4NcLhZPtHxcX3G0sA==
X-Google-Smtp-Source: ABdhPJwfBrX+e82YelPH9Jp/p4Cg4viJ21MyZZkDIkh4rc3Xd6Ezl2TcopjFp6CrVIr3j2esYaVQrEEWTIK4TqHR0DQ=
X-Received: by 2002:a50:ab51:: with SMTP id t17mr18550168edc.89.1607322673512;
 Sun, 06 Dec 2020 22:31:13 -0800 (PST)
MIME-Version: 1.0
References: <20201205115551.2079471-1-zhangqilong3@huawei.com>
In-Reply-To: <20201205115551.2079471-1-zhangqilong3@huawei.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Mon, 7 Dec 2020 07:31:02 +0100
Message-ID: <CAMGffEk0=krTjXQftCzTLM_=dcqhxxz=1DPX_FzTjmSCkFV0oQ@mail.gmail.com>
Subject: Re: [PATCH] scsi: pm80xx: Fix error return in pm8001_pci_probe
To:     Zhang Qilong <zhangqilong3@huawei.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Dec 5, 2020 at 12:53 PM Zhang Qilong <zhangqilong3@huawei.com> wrote:
>
> Forget to set error code when pm8001_configure_phy_settings
> failed. We fixed it by using rc to store return value of
> pm8001_configure_phy_settings.
>
> Fixes: 279094079a442 ("[SCSI] pm80xx: Phy settings support for motherboard controller.")
> Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Thx
> ---
>  drivers/scsi/pm8001/pm8001_init.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index 9a5d284f076a..ee2de177d0d0 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -1127,7 +1127,8 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
>
>         pm8001_init_sas_add(pm8001_ha);
>         /* phy setting support for motherboard controller */
> -       if (pm8001_configure_phy_settings(pm8001_ha))
> +       rc = pm8001_configure_phy_settings(pm8001_ha);
> +       if (rc)
>                 goto err_out_shost;
>
>         pm8001_post_sas_ha_init(shost, chip);
> --
> 2.25.4
>
