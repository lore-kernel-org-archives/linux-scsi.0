Return-Path: <SRS0=mOiQ=7X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 595CEC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 09:06:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37E72207C3
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 09:06:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jR8yqW9f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbgFJJGg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Jun 2020 05:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbgFJJGg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jun 2020 05:06:36 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DF4AC03E96B;
        Wed, 10 Jun 2020 02:06:36 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id j10so1348646wrw.8;
        Wed, 10 Jun 2020 02:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hJE0N3sQWCYDZd2K2v2aUUyDKr9zLBCD5upNatqrvns=;
        b=jR8yqW9faRx6jDMBWUQM1MyeETZVp0RnCXVrTV5Pk8g6XuyfnGiWZ4NbZRovA3ynH6
         MmRNUuJt2ad8LZ48QSkOAoIShCgD/eAwqLG/VSduq9d0RAfWektR8fgdBAaKN8E5eK3A
         jOts4wfXb7yoI3bvsZsLXbSQqZxp3KaVGPhQslBFe9s3YK/xDHhFdtEthHFGLtgDprkm
         9DyKB85qz6h5INhtmYatqzEsWFbpnU3VwI+/SU8kC79j5O74k0g2z0cird/uNKY0fijr
         9COnJJ7FFrJs0xAgeM8o7YMlqfYUNZD1fnCxQp5fUXdY95Ws9aguIMEnOXXdZ53ft0Pq
         OzGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hJE0N3sQWCYDZd2K2v2aUUyDKr9zLBCD5upNatqrvns=;
        b=JBbHoUVN6ZekB4qK00CdMDvxrcPm5QjpjDwSTzKp1u+fwrAd5lsg/OOiX/v9GDfSiu
         3UU/KYPOhjzKGQAqLFKHNeklyOyaBhcUJbqfqivpfCfE3LuZUhoyUHiObMKZfow9MiRz
         86+M1j4YpbP5kHO6a8OXzVfF38iSKAwFBBb09pPeF3XIw2AgrwZ87VwiCk1wEG+U5nDk
         N2A5YZ0+f5r6qSFwriWvYvzE7oxQ+ZJFob/uEiQInXUbWQSs2z5K0wNyLzw1rA+ccPq6
         IcT7l3PfWmTu63AiszuPtn7xSRjg4JHB6Zrcshqu/PyorzPeOH2kdwYaUDHIiGJktf5Q
         Z3MQ==
X-Gm-Message-State: AOAM533aaMDEYuirZ+BqYvhyMVtOuWaRLzg93tbtJOlZ8673R5s4kqhV
        woAUBN/uHT1Kjvatye3t8VQ=
X-Google-Smtp-Source: ABdhPJwaBPobM6YCEvv+1MJfH887E5h3N1Ogqek8oHI9rtfhwm7C3nS0RJAprmmT1qKM18Oz8Evyxw==
X-Received: by 2002:a5d:6150:: with SMTP id y16mr2648501wrt.219.1591779994792;
        Wed, 10 Jun 2020 02:06:34 -0700 (PDT)
Received: from ubuntu-laptop ([2a01:598:b90a:8f5:dd1:7313:78f9:539b])
        by smtp.googlemail.com with ESMTPSA id b19sm6618937wmj.0.2020.06.10.02.06.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 10 Jun 2020 02:06:34 -0700 (PDT)
Message-ID: <bc93a1d6b38e993a606fec3078a6cad3f056041b.camel@gmail.com>
Subject: Re: [PATCH v1 1/2] scsi: ufs: Add DELAY_BEFORE_LPM quirk for Micron
 devices
From:   Bean Huo <huobean@gmail.com>
To:     Stanley Chu <stanley.chu@mediatek.com>, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, avri.altman@wdc.com,
        alim.akhtar@samsung.com, jejb@linux.ibm.com,
        asutoshd@codeaurora.org
Cc:     beanhuo@micron.com, cang@codeaurora.org, matthias.bgg@gmail.com,
        bvanassche@acm.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com,
        chaotian.jing@mediatek.com, cc.chou@mediatek.com
Date:   Wed, 10 Jun 2020 11:06:26 +0200
In-Reply-To: <20200610053645.19975-2-stanley.chu@mediatek.com>
References: <20200610053645.19975-1-stanley.chu@mediatek.com>
         <20200610053645.19975-2-stanley.chu@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-06-10 at 13:36 +0800, Stanley Chu wrote:
> It is confirmed that Micron device needs DELAY_BEFORE_LPM
> quirk to have a delay before VCC is powered off. So add Micron
> vendor ID and this quirk for Micron devices.
> 
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>


Thanks,
Bean

> ---
>  drivers/scsi/ufs/ufs_quirks.h | 1 +
>  drivers/scsi/ufs/ufshcd.c     | 2 ++
>  2 files changed, 3 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufs_quirks.h
> b/drivers/scsi/ufs/ufs_quirks.h
> index e3175a63c676..e80d5f26a442 100644
> --- a/drivers/scsi/ufs/ufs_quirks.h
> +++ b/drivers/scsi/ufs/ufs_quirks.h
> @@ -12,6 +12,7 @@
>  #define UFS_ANY_VENDOR 0xFFFF
>  #define UFS_ANY_MODEL  "ANY_MODEL"
>  
> +#define UFS_VENDOR_MICRON      0x12C
>  #define UFS_VENDOR_TOSHIBA     0x198
>  #define UFS_VENDOR_SAMSUNG     0x1CE
>  #define UFS_VENDOR_SKHYNIX     0x1AD
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 04b79ca66fdf..dea4fddf9332 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -216,6 +216,8 @@ ufs_get_desired_pm_lvl_for_dev_link_state(enum
> ufs_dev_pwr_mode dev_state,
>  
>  static struct ufs_dev_fix ufs_fixups[] = {
>  	/* UFS cards deviations table */
> +	UFS_FIX(UFS_VENDOR_MICRON, UFS_ANY_MODEL,
> +		UFS_DEVICE_QUIRK_DELAY_BEFORE_LPM),
>  	UFS_FIX(UFS_VENDOR_SAMSUNG, UFS_ANY_MODEL,
>  		UFS_DEVICE_QUIRK_DELAY_BEFORE_LPM),
>  	UFS_FIX(UFS_VENDOR_SAMSUNG, UFS_ANY_MODEL,
> -- 
> 2.18.0

