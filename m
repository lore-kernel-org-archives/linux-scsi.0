Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91238C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jan 2021 19:26:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54E5761477
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jan 2021 19:26:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232816AbhA2T0Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Jan 2021 14:26:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232873AbhA2T0V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jan 2021 14:26:21 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8111AC061573;
        Fri, 29 Jan 2021 11:25:41 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id ox12so14667114ejb.2;
        Fri, 29 Jan 2021 11:25:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6XitYVxFpG+yfSmfoqgTHU6sMSl3GuaIPGPB+K4jS8k=;
        b=LdbXnStrTHRgqIPwn5KkG4SoV+wrMqcH1KfnZaeny7IR4YfKJV9FgD4gz7GOibixv/
         whHSnLoQs9JBuIakC13mlrNhgsX4k92RaeiHc1o/3C+2odPxbf+2ghqolAXGT9C8klHk
         PSDLU1WRRI8/pc+lP7UpMyZEwb9wxKuFWyvWppF2109PQjvMUbcBWEqtr65HdwmoYH92
         3/nZnhAM8rj40+lP2TIVOZowQfO86Dgi7VkFzDb6iaU/SIkFE+wOv5/pGWFC7eFT/B1+
         RPV1Bc36vVJYM1FV3CiuCh2M6k6q4ouG0jkpSB7CE3LuAYOU4S/sHaqehPlb8p40Xbv6
         FIGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6XitYVxFpG+yfSmfoqgTHU6sMSl3GuaIPGPB+K4jS8k=;
        b=e4cLBULMOJT2pYs9fmMJIC+75o9LCDWXLj23Te3ysNpgzHi40EcW2W8k9vavAq8vvd
         8qXQDADoOkEacScbPU4mnJj28cKT30lzyAMpotVIVhLYfIPp6jhRMFzw+Rpvp5XjFTJG
         ZwxTzQidzn4+xKO/FNFcT0iF/qrml/FIQ+ckCrTmsuNeK21u4INZzHwHdg7Rq6vKw7+5
         qJbi/akBbgXUo3rsawgy11p77XGMwLEVCvKWfsvoOyynV9xlb1mvk7ZSWQkyh615slOF
         bBRQy6oMyP9kYDR6G6a/sZEV/cfqQN3laKJpyPfZFQOZiWrhTnfGdIOS6bey/5VurLCS
         djSw==
X-Gm-Message-State: AOAM531HkSCJFw6UnQ88/9Nek9ykcxkPap25mUwV+G5Geta5c5oFI7BF
        Bq1+gIJwU2nz4ync1/FX5i4=
X-Google-Smtp-Source: ABdhPJyKVvrUDn70Cf/6sN90N0m4or33nV33ioulfHW4UFTSMyrCwyCZNOAR8DQu/6N7nyqHAKUmdQ==
X-Received: by 2002:a17:907:961d:: with SMTP id gb29mr6224545ejc.460.1611948340080;
        Fri, 29 Jan 2021 11:25:40 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bee1b.dynamic.kabel-deutschland.de. [95.91.238.27])
        by smtp.googlemail.com with ESMTPSA id dh14sm4995787edb.11.2021.01.29.11.25.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 29 Jan 2021 11:25:39 -0800 (PST)
Message-ID: <63f00f514f1e912b8fb1d0c183e9167b60b3a5dc.camel@gmail.com>
Subject: Re: [PATCH V2] scsi: ufs: Add UFS3.0 in ufs HCI version check
From:   Bean Huo <huobean@gmail.com>
To:     Nitin Rawat <nitirawa@codeaurora.org>, cang@codeaurora.org,
        asutoshd@codeaurora.org, stummala@codeaurora.org,
        vbadigan@codeaurora.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Fri, 29 Jan 2021 20:25:38 +0100
In-Reply-To: <1611058021-18611-1-git-send-email-nitirawa@codeaurora.org>
References: <1611058021-18611-1-git-send-email-nitirawa@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-01-19 at 17:37 +0530, Nitin Rawat wrote:
> As per JESD223D UFS HCI v3.0 spec, HCI version 3.0
> is also supported. Hence Adding UFS3.0 in UFS HCI
> version check to avoid logging of the error message.
> 
> Signed-off-by: Nitin Rawat <nitirawa@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 5 +++--
>  drivers/scsi/ufs/ufshci.h | 1 +
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 82ad317..54ca765 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -9255,8 +9255,9 @@ int ufshcd_init(struct ufs_hba *hba, void
> __iomem *mmio_base, unsigned int irq)
>         if ((hba->ufs_version != UFSHCI_VERSION_10) &&
>             (hba->ufs_version != UFSHCI_VERSION_11) &&
>             (hba->ufs_version != UFSHCI_VERSION_20) &&
> -           (hba->ufs_version != UFSHCI_VERSION_21))
> -               dev_err(hba->dev, "invalid UFS version 0x%x\n",
> +           (hba->ufs_version != UFSHCI_VERSION_21) &&
> +           (hba->ufs_version != UFSHCI_VERSION_30))
> +               dev_err(hba->dev, "invalid UFS HCI version 0x%x\n",
>                         hba->ufs_version);

Hi Nitin
Except HCI 1.0 / 1.1 / 2.0 / 2.1 / 3.0, do you have the other UFS HCI
version? if no, current driver supports all of them,  instead of
scaling these check, and avoid logging of the error message, I suggest 
you can directly delete these redundant checkup.

If there is a weird HCI version that not supported by the current
driver, you can only add an unsupported checkup list. thus, you don't
need to scale this useless checkup.

Bean




