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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAEAAC2BB48
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 14:33:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A24D12222B
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 14:33:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437500AbgLNOdJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Dec 2020 09:33:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727309AbgLNOdI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Dec 2020 09:33:08 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55725C0613CF;
        Mon, 14 Dec 2020 06:32:28 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id d17so22777219ejy.9;
        Mon, 14 Dec 2020 06:32:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JtZlG2TMyR1uzxpDuh0ZpCaVmKX8ab8m6m4yiucXZd8=;
        b=Jv71QX4cZGzIhCF0Z390WTp5fvzAKvcbvCTOr+y2l3q2sULpQ9ec5xz1oSlBR0sTkx
         LX8U0KHNsDRNOmsWhKuYrsBp6OSq4WqTJlyEOCp63pLh9sC2fwc9xqS7o/I2BEclYGmD
         rDcaR0XOrDfk1GvlbjnKJSKXLLn7qVmcXNxoED3BRHXMynUvQW7LyVKJXP1xsXt8KHRr
         i3IOU6liXq7JLibfyPZ69FFgKdC3hnsIKTC53J74Zgdzq4V2K09XqjaSydY/Su8Y5RLQ
         uyEYy5WyzrM71wtpTGJXVNpFAAk1aLc/C0IYkkRmV8GsKgfgKuMyVbH/emjXzqjJyQ/C
         oiYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JtZlG2TMyR1uzxpDuh0ZpCaVmKX8ab8m6m4yiucXZd8=;
        b=Oh50dsZd2PL8gcflbelHdbA1HlXoqakVec/XUfiptM1+wTSOqJ/kyaHROXfzAPKsDD
         AH7Ss41ueUT9rx+QI9gmi+TZw6fzTf/6Pvu3+dYkD6QFEZREZyxC2Po6oajb05XZLxay
         gW8GMrhWmXbtMETNdQ58QFHr9SzOMI7xX9Kv0jVnCaV2zqxFUSEh85/AKPvoLQpcoQ/2
         HGo1dVpKAQeByKnmUJ7+RfzKJrXJoDVP1nJGEioRDO1RW3KhsL0HYYQ9RZJlW12f9MMz
         3WV78F5N0OAF78rA9PoKVfe0s4/Ohzi/+V52G57+L3h+WJn1HMK24I4DUvzEC6cklnKl
         W+Dg==
X-Gm-Message-State: AOAM530L8KkeIrvbCyEXMgahNkwOL7Qn/xqvoEfON2MGsK0PG2xs2zsh
        e1cnbCUkETE+1Ulhpc4zl4A=
X-Google-Smtp-Source: ABdhPJwngt/PUkO7jH32uLfB7mefD+T0aGNBldPv0GvFOwqdSOADN4LEBfFkz8dM5W00G+xdFGMn0Q==
X-Received: by 2002:a17:906:dc1:: with SMTP id p1mr23191835eji.9.1607956347034;
        Mon, 14 Dec 2020 06:32:27 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.googlemail.com with ESMTPSA id h15sm14623665ejq.29.2020.12.14.06.32.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 14 Dec 2020 06:32:26 -0800 (PST)
Message-ID: <7eb8f335f4eb85385f54c88952f7749750340320.camel@gmail.com>
Subject: Re: [PATCH V2 1/1] scsi: ufs: Fix a possible NULL pointer issue
From:   Bean Huo <huobean@gmail.com>
To:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Mon, 14 Dec 2020 15:32:25 +0100
In-Reply-To: <1607917296-11735-1-git-send-email-cang@codeaurora.org>
References: <1607917296-11735-1-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 2020-12-13 at 19:41 -0800, Can Guo wrote:
> Fixes: 88a92d6ae4fe ("scsi: ufs: Serialize eh_work with system PM
> events and async scan")
> 
> Signed-off-by: Can Guo <cang@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index c1c401b..ef155a9 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -8883,8 +8883,11 @@ int ufshcd_system_suspend(struct ufs_hba *hba)
>         int ret = 0;
>         ktime_t start = ktime_get();
>  
> +       if (!hba)
> +               return 0;
> +
>         down(&hba->eh_sem);
> -       if (!hba || !hba->is_powered)
> +       if (!hba->is_powered)
>                 return 0;


Can,

why not moving down(&hba->eh_sem) after "return 0;"?






