Return-Path: <SRS0=QEZ7=2J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBD14C43603
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 18:02:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FC1A20716
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 18:02:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jb8HzqW7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbfLSSCp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Dec 2019 13:02:45 -0500
Received: from mail-vs1-f66.google.com ([209.85.217.66]:41631 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726858AbfLSSCp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Dec 2019 13:02:45 -0500
Received: by mail-vs1-f66.google.com with SMTP id f8so4319322vsq.8;
        Thu, 19 Dec 2019 10:02:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rAQovkcIWRg/uT7Wt4ZXLTChTNB0K/Ms05qPpBBigFs=;
        b=jb8HzqW7FqnKB/KJV1E038aKgBLCAFaOmx4e/SEbN6zwqhp/4pDjpjQySFp8TMQe+b
         s1Q5VciU5q0TLp+PaMVvflF2uN0Ld1bSbGS7/kTCUgCvCOXnNysbN3vyrtKA4ZgNQksb
         kl1IDLtKgcTuqEOyGmf7dLRO2LU7sA8qvwPU+NsSSRyv1RyVbnKsNCQhKy1tCarRwlwx
         +Aj3D4rHsjeVmZBOo7+oRXFyave6rptfxibTWUWGrasI7MCjPuiTGEnNcxhsVEg4oeaF
         rh7u7NQZ4WLk4633f3zwoAsOy6HnIXQ1irfRVy5evSBsQSNpyaz1eWrqAur1ZfIpWl54
         hJ2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rAQovkcIWRg/uT7Wt4ZXLTChTNB0K/Ms05qPpBBigFs=;
        b=b4iFJ1UELrRrtc+9468nxJ5UYFuerNaTRJNBhB7vBL7sOf8s4/mHuL8Drc8Ng9pt9+
         mKUcTs0Zc3rIwqrrcYsYOJ33BAqqT3ytMQKw9U0yNzOMJuV1UAhAmKJZKHh1X3c7Uiyt
         SZtIehy6qiWjondBTlUcnnDZzy/XziEwnpPg7T3D+6AlUjxsBPgInFutXIbAwyi/0Nlc
         zOufA4DQuRZPkyR6BywmEhmJaYgf5DQ5/ozTl2RTrQPWEd7qHyERpvCyPT6ni3pAr69x
         8PXmqIAnCnhZrQgiXTPBWg3im64/ocCfacMfHxLP5Qr5JY4AKVSops/mGRra0fWXWmOa
         2cWA==
X-Gm-Message-State: APjAAAXMh4NG2N8lFZ1jeVNF4Tp45d44JPgO+JgQJDHixMPmnyNFYbz8
        bWwsAWnOJJqUZVvZ9mu/0brXi0gWrOql6IKrs5k=
X-Google-Smtp-Source: APXvYqypfDBo3AHuAtJUuEds0r/E977ET2q9PNpOVds2Jiih/A5bkuyjydb2YmL4ArPAlG9jOgW37FEugxym5qIbaAA=
X-Received: by 2002:a67:e204:: with SMTP id g4mr4898254vsa.176.1576778563711;
 Thu, 19 Dec 2019 10:02:43 -0800 (PST)
MIME-Version: 1.0
References: <1576491432-631-1-git-send-email-sheebab@cadence.com>
In-Reply-To: <1576491432-631-1-git-send-email-sheebab@cadence.com>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Thu, 19 Dec 2019 23:32:07 +0530
Message-ID: <CAGOxZ53eZupSFu+ugHuuNTZ+tJWa8Ex2YmDXe+uQ5YbAR8nsqA@mail.gmail.com>
Subject: Re: [PATCH] scsi: ufs: Power off hook for Cadence UFS driver
To:     Sheeba B <sheebab@cadence.com>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Bean Huo (beanhuo)" <beanhuo@micron.com>, yuehaibing@huawei.com,
        linux-scsi@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>, rafalc@cadence.com,
        mparab@cadence.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Sheeba

On Mon, Dec 16, 2019 at 4:55 PM Sheeba B <sheebab@cadence.com> wrote:
>
> Attach Power off hook on Cadence UFS driver
>
> Signed-off-by: Sheeba B <sheebab@cadence.com>

Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>

> ---
>  drivers/scsi/ufs/cdns-pltfrm.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/scsi/ufs/cdns-pltfrm.c b/drivers/scsi/ufs/cdns-pltfrm.c
> index 1c80f9633da6..56a6a1ed5ec2 100644
> --- a/drivers/scsi/ufs/cdns-pltfrm.c
> +++ b/drivers/scsi/ufs/cdns-pltfrm.c
> @@ -325,6 +325,7 @@ static const struct dev_pm_ops cdns_ufs_dev_pm_ops = {
>  static struct platform_driver cdns_ufs_pltfrm_driver = {
>         .probe  = cdns_ufs_pltfrm_probe,
>         .remove = cdns_ufs_pltfrm_remove,
> +       .shutdown = ufshcd_pltfrm_shutdown,
>         .driver = {
>                 .name   = "cdns-ufshcd",
>                 .pm     = &cdns_ufs_dev_pm_ops,
> --
> 2.17.1
>


-- 
Regards,
Alim
