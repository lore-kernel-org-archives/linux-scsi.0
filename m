Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EFB6C11F64
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 15:23:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D89136139A
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 15:23:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233207AbhGAPZr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Jul 2021 11:25:47 -0400
Received: from mail-pl1-f171.google.com ([209.85.214.171]:33282 "EHLO
        mail-pl1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232817AbhGAPZr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jul 2021 11:25:47 -0400
Received: by mail-pl1-f171.google.com with SMTP id f11so3875953plg.0;
        Thu, 01 Jul 2021 08:23:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=op/8QQgICOI0xBquP9cPRhXiHb+xsSxA/2r2A5tZDpk=;
        b=uhzhg3txr9W0EVxElMvSHd+QQmwAhxet0oruY4uVH+ophTB2VTmcCE0g1ojQEPb5s1
         l4FTGTSuQVhwo7dJ1MiM50UHucixwutd9QsgLy5WDKJ1/7Wawh/AiDdNqG2wvGfI8E2Z
         kJvA3GckEHkqnk4ZczsGy53/1dV0vHBW1yaxFi/LFGJ/xY5mB74nmDMZNg6SLYCTVQV7
         1ns9wUnS+q7e616cKLHuLkdTmT0r3ktAKNvIPSqXWxf9zp0qKlP79JaBPhbyQL308OyD
         q3tXCPQ3g4QmJZ6pE+vfe9BC083biuSBfJNGFzF0+SqjTJPa9/LEfm1StZs252lV8WbZ
         O/fw==
X-Gm-Message-State: AOAM532bKSGQgHo2Ec2pCamVFpEjt3pxB7ipE0h01H+tJjHjQ418sPxB
        wAhI1Kkfjg9QzX0LnAANFg4=
X-Google-Smtp-Source: ABdhPJzcDA3pcMtD/E1BwXWtoJBA97ibiL3sE6E9Mvw0ky5/mOzwbpHy1bIgWhVZq9lX08dhUOxoCQ==
X-Received: by 2002:a17:902:fe10:b029:127:6549:fe98 with SMTP id g16-20020a170902fe10b02901276549fe98mr106442plj.25.1625152995732;
        Thu, 01 Jul 2021 08:23:15 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:6a75:b07:a0d:8bd5? ([2601:647:4000:d7:6a75:b07:a0d:8bd5])
        by smtp.gmail.com with ESMTPSA id z4sm67803pjq.8.2021.07.01.08.23.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jul 2021 08:23:14 -0700 (PDT)
Subject: Re: [PATCH] scsi: ufs: add missing host_lock in setup_xfer_req
To:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20210701005117.3846179-1-jaegeuk@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <cb928bc9-0124-f082-8b5a-584afd9f1d66@acm.org>
Date:   Thu, 1 Jul 2021 08:23:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210701005117.3846179-1-jaegeuk@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/30/21 5:51 PM, Jaegeuk Kim wrote:
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index c98d540ac044..194755c9ddfe 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -1229,8 +1229,13 @@ static inline int ufshcd_vops_pwr_change_notify(struct ufs_hba *hba,
>  static inline void ufshcd_vops_setup_xfer_req(struct ufs_hba *hba, int tag,
>  					bool is_scsi_cmd)
>  {
> -	if (hba->vops && hba->vops->setup_xfer_req)
> -		return hba->vops->setup_xfer_req(hba, tag, is_scsi_cmd);
> +	if (hba->vops && hba->vops->setup_xfer_req) {
> +		unsigned long flags;
> +
> +		spin_lock_irqsave(hba->host->host_lock, flags);
> +		hba->vops->setup_xfer_req(hba, tag, is_scsi_cmd);
> +		spin_unlock_irqrestore(hba->host->host_lock, flags);
> +	}
>  }

Since this function has only one caller, how about moving it into ufshcd.c?

Thanks,

Bart.
