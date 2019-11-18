Return-Path: <SRS0=r6FR=ZK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C17E5C432C0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 13:20:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 997E320726
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 13:20:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IklBmRpw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbfKRNUM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Nov 2019 08:20:12 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:40169 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbfKRNUL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Nov 2019 08:20:11 -0500
Received: by mail-io1-f68.google.com with SMTP id p6so18680338iod.7;
        Mon, 18 Nov 2019 05:20:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jtBslyeRe2dxLTJWRfxsV5lHghb7AWr4C0ILEly8qOo=;
        b=IklBmRpwFCy1UUTW/WpyvUTQmcKpYwT6SZr3EYlmZEe/e2GBu7EcIde5rTKrwNWfIx
         34uGvJ3010QsQ5SJZVNR0r847kdwMLaN1omVp+ELYmOGJ9NL8UtmD7jj2fnJtTErgDSS
         u2O+OuRq/SgomY9Ft+7BR/TRwehd57kqizCc45VYmg8K01Pr7ANFRSi9LnIwKdeCZ1v3
         pelR0reCfMuxini2KP//MZPpDOOAZ3tJRJa6Auilv05Z66Dt6KakcbrZmTJvSRvUUE4c
         M5XcR7mKwH32aLQYTZBkaSTKty1utWsbwN4QehGyyl1IuVRHIy1uT7LawlVCo15k7lsl
         kjeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jtBslyeRe2dxLTJWRfxsV5lHghb7AWr4C0ILEly8qOo=;
        b=Z5NEep7CMXzkPmijWcWOVIpkZZJWP4QMhf1BFSYTq6dI2GR5K4Pu0IQ2MZEX2DABcZ
         pnprDflWJ7BLQxqo86ZyzPANxdtDZUcyHUal49pZVW0QAwClgDIFEUR7APF1s/41pmCQ
         na4yNv/21glejeegPNLdVBF7ADZ/H1C1GTtkuKQRE+vviChf742fp/MKWQx7qQVpfPI0
         eQz7QvyO//HoP4kDT7FuM7yRLM0fD5TOTtzconlhg/9Vkb44EdqLG9gnA9H2VZC4ZKMV
         iovra1vYB3Z/HsSqZPwshgACBv3IaodtVPfCTWlPGUvmY1JhCVupoNLS4SOTAb1X7YYs
         rigA==
X-Gm-Message-State: APjAAAVfr0q4dRYYSguXLwJGDMLeFH8tzt7wzfNgdaXwxorVrbIkGkjR
        9gjAm6xTz4pt7XXP21+P+Ww3ZFaO8F6By9VftZw=
X-Google-Smtp-Source: APXvYqyfD7jj+bwf8NvPaepmFl8GYDAvT13TM0vx9+H1ZwsdMVUAQSWO3oe0cZzOsLvvUQy5YbMiAhjrN+krM3pPRnY=
X-Received: by 2002:a02:a810:: with SMTP id f16mr13538923jaj.73.1574083210748;
 Mon, 18 Nov 2019 05:20:10 -0800 (PST)
MIME-Version: 1.0
References: <1574049277-13477-1-git-send-email-cang@codeaurora.org> <0101016e7ca62853-73f33b23-b1d4-4f2e-aec1-e6aa9cd34dfe-000000@us-west-2.amazonses.com>
In-Reply-To: <0101016e7ca62853-73f33b23-b1d4-4f2e-aec1-e6aa9cd34dfe-000000@us-west-2.amazonses.com>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Mon, 18 Nov 2019 18:49:34 +0530
Message-ID: <CAGOxZ50tYWgbWFsRu+80_jaAH9J-2F6PP09Mzuf77jd+WU2jLA@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] scsi: ufs: Update VCCQ2 and VCCQ min/max voltage
 hard codes
To:     Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com,
        Mark Salyzyn <salyzyn@google.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

I agree with Avri, you can just drop this patch, unless you see
anything affected because of not setting VDDQ/VDDQ2 as per spec.
or alternatively you can have  different marco of each spec and handle
the same in the code as per ufs specification version.

On Mon, Nov 18, 2019 at 9:25 AM Can Guo <cang@codeaurora.org> wrote:
>
> Per UFS 3.0 JEDEC standard, the VCCQ2 min voltage is 1.7v and the VCCQ
> voltage range is 1.14v ~ 1.26v. Update their hard codes accordingly to
> make sure they work in a safe range compliant for ver 1.0/2.0/2.1/3.0
> UFS devices.
>
> Signed-off-by: Can Guo <cang@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufs.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
> index 385bac8..9df4f4d 100644
> --- a/drivers/scsi/ufs/ufs.h
> +++ b/drivers/scsi/ufs/ufs.h
> @@ -500,9 +500,9 @@ struct ufs_query_res {
>  #define UFS_VREG_VCC_MAX_UV       3600000 /* uV */
>  #define UFS_VREG_VCC_1P8_MIN_UV    1700000 /* uV */
>  #define UFS_VREG_VCC_1P8_MAX_UV    1950000 /* uV */
> -#define UFS_VREG_VCCQ_MIN_UV      1100000 /* uV */
> +#define UFS_VREG_VCCQ_MIN_UV      1140000 /* uV */
>  #define UFS_VREG_VCCQ_MAX_UV      1300000 /* uV */
> -#define UFS_VREG_VCCQ2_MIN_UV     1650000 /* uV */
> +#define UFS_VREG_VCCQ2_MIN_UV     1700000 /* uV */
>  #define UFS_VREG_VCCQ2_MAX_UV     1950000 /* uV */
>
>  /*
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project
>


-- 
Regards,
Alim
