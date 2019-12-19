Return-Path: <SRS0=QEZ7=2J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4736C43603
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 18:01:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F57920716
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 18:01:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dsLosRjy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfLSSBI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Dec 2019 13:01:08 -0500
Received: from mail-ua1-f66.google.com ([209.85.222.66]:39462 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbfLSSBH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Dec 2019 13:01:07 -0500
Received: by mail-ua1-f66.google.com with SMTP id 73so2282012uac.6;
        Thu, 19 Dec 2019 10:01:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QjPQ9I3MaulCTCZ2YdAid7nxSKyySRyNct57kaSUS88=;
        b=dsLosRjyuSjvTAjKSLXV2e4+t0VYWTXQuFL+k20JqPB/UoaAMZPo4h1L8DlmR6qem2
         U3mQKxfqj2KdK8oG/Tg1BGUE/9neDB7zOKyz52MNGgqTkDXz2QLPBzEF2sL2XH2umOMD
         cbqrJweHNN/WfptPBOryXSaBIfTz9J8FkByItcChZ+1hEmzV6B01R+CvA3h2Z8C/3Rfp
         gEWWN5x+KIZwVHQaJ91U6UFmwfN0Bczg8Xk3buYK5KfpaY7gHj42tBzB1jtYrwccxCdY
         zLaqSUPrQMv0T1VKRlxzMiDSZNGOqOKCa1PdLeWoldNU4ZD0ojXcIGhbyHBa96vMtVp1
         ebrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QjPQ9I3MaulCTCZ2YdAid7nxSKyySRyNct57kaSUS88=;
        b=L0a2n1qzH2rtvOCdNbiS6ABOOJK9IfwDSn2SbCdyyDnEuKuAdIq2rvlDgFVc4RvCQU
         pUqDaMUTIVhnQYTnvw6x2FIXGFi7pNcEu5PjaNDW5/yVJXvMBRZKleQKwROp/X7eJdkR
         i5js2DtfPXTBBeqH5sc1iifQmxKSGkupPzauIN8SWhZG4pxPY0U5GYOXbr26v58OCJ2p
         oHd11CVoNYnkhzxB/IxsxWuXDyolLpLeK/6JkiLzBTAbc+AabsC9eTjHS2kjLT2/2QQ6
         +caiafMJl66EHtJm2h+ZAvgJlbeHWO+ItQdYVo0jsg9qrIGjStFS4/UgJo4KqYXY7M+n
         2Dnw==
X-Gm-Message-State: APjAAAUpBgeJTKeCOjZKQxfnrEmysgzISnMEawLLCUy3P2F9Oa3Y5Vb1
        iEnMqZVbH1TiSW0Ir3qej6UOiRr4G++UAmwBkfc=
X-Google-Smtp-Source: APXvYqwNBImtkGHDKyuRda18yw7naA/7n+2veuddJDpT4jKTMKEftJPEz5htPYoBKMPuYkbjM0g7DvUkosrf9MYJ+8I=
X-Received: by 2002:ab0:4966:: with SMTP id a35mr6112212uad.141.1576778466344;
 Thu, 19 Dec 2019 10:01:06 -0800 (PST)
MIME-Version: 1.0
References: <1576468137-17220-1-git-send-email-stanley.chu@mediatek.com> <1576468137-17220-2-git-send-email-stanley.chu@mediatek.com>
In-Reply-To: <1576468137-17220-2-git-send-email-stanley.chu@mediatek.com>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Thu, 19 Dec 2019 23:30:30 +0530
Message-ID: <CAGOxZ50RKYAEw=HwYMH=Jm7cagUV12C-fwhauJhJqx6HscAmFA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2 RESEND] soc: mediatek: add header for SiP service interface
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        f.fainelli@gmail.com, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        open list <linux-kernel@vger.kernel.org>,
        "Bean Huo (beanhuo)" <beanhuo@micron.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        peter.wang@mediatek.com, chun-hung.wu@mediatek.com,
        andy.teng@mediatek.com, leon.chen@mediatek.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi

On Mon, Dec 16, 2019 at 9:19 AM Stanley Chu <stanley.chu@mediatek.com> wrote:
>
> Add a header for the SiP service interface in order to access
> the UFSHCI controller for secure command handling in MediaTek Chipsets.
>
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> ---
>  include/linux/soc/mediatek/mtk_sip_svc.h | 29 ++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
>  create mode 100644 include/linux/soc/mediatek/mtk_sip_svc.h
>
> diff --git a/include/linux/soc/mediatek/mtk_sip_svc.h b/include/linux/soc/mediatek/mtk_sip_svc.h
> new file mode 100644
> index 000000000000..97311959d7d7
> --- /dev/null
> +++ b/include/linux/soc/mediatek/mtk_sip_svc.h
> @@ -0,0 +1,29 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2019 MediaTek Inc.
> + */
> +#ifndef __MTK_SIP_SVC_H
> +#define __MTK_SIP_SVC_H
> +
> +/* Error Code */
> +#define SIP_SVC_E_SUCCESS               0
> +#define SIP_SVC_E_NOT_SUPPORTED         -1
> +#define SIP_SVC_E_INVALID_PARAMS        -2
> +#define SIP_SVC_E_INVALID_RANGE         -3
> +#define SIP_SVC_E_PERMISSION_DENIED     -4
> +
> +#ifdef CONFIG_ARM64
> +#define MTK_SIP_SMC_CONVENTION          ARM_SMCCC_SMC_64
> +#else
> +#define MTK_SIP_SMC_CONVENTION          ARM_SMCCC_SMC_32
> +#endif
> +
> +#define MTK_SIP_SMC_CMD(fn_id) \
> +       ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL, MTK_SIP_SMC_CONVENTION, \
> +                          ARM_SMCCC_OWNER_SIP, fn_id)
> +
> +/* UFS related SMC call */
> +#define MTK_SIP_UFS_CONTROL \
> +       MTK_SIP_SMC_CMD(0x276)
> +
How about moving UFS specific stuff to MTK UFS driver and include this
header in driver file?
Rest looks fine.
> +#endif
> --
> 2.18.0



-- 
Regards,
Alim
