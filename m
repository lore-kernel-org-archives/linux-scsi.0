Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA03FC49EA5
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 17:35:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBC7D613EA
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 17:35:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232174AbhFXRh6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Jun 2021 13:37:58 -0400
Received: from mail-pl1-f171.google.com ([209.85.214.171]:33768 "EHLO
        mail-pl1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbhFXRh5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jun 2021 13:37:57 -0400
Received: by mail-pl1-f171.google.com with SMTP id f10so3346714plg.0;
        Thu, 24 Jun 2021 10:35:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=x8YDqjlY3Yhk+5aYy3Mt9hst4lMIKy4S0P/FHR83jL8=;
        b=Q0y4ptmW0uzOAH9w5y/glR/NMa2sx0qfeAAsx0/jAiZ9QqFJjmnYDJIr8EMBb0SDYK
         svmhVJT5kEWQWWejOo4k8dJUIKgqU0jjnDbRLnbVswJ6+pfjdiUeqfhAS7xse3JkUE8N
         WGlZP1d7eCzquVbQUEUlkbjyDguFIlDfs1aij/TPeQ9k9ZHsExZD4gzU2TncUi1yOWda
         3tsI2NPrsw47f7yYbeTEqb0+mawMJ2jUPRHAuXqBnOc02qt4w44pmnwyGyfVu36H/lQ1
         FJEKJav9Wn5pxB+ai/LvNGPuUZwCasdqomoWkba+FAXQPgWV1PxkoEhbJMnDqwz+M5fX
         z4JA==
X-Gm-Message-State: AOAM532J7GgFvHFVyvl3/0mF5ZOPRKa7iOwd2jJO1Qocu80brp9oLbs4
        eBZ37cp5eTukxJvu57XjIsF1agTKW54UHQ==
X-Google-Smtp-Source: ABdhPJyJTxjm8a4rguy/WDm+Y82IhEjZYDyQ3Yz9Rdv88ukNXnO07lu6xNFBZbpmscPS7ZDFXoXtKA==
X-Received: by 2002:a17:90a:6404:: with SMTP id g4mr16349851pjj.155.1624556136704;
        Thu, 24 Jun 2021 10:35:36 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id c62sm3444447pfa.12.2021.06.24.10.35.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jun 2021 10:35:35 -0700 (PDT)
Subject: Re: [PATCH v4 02/10] scsi: ufs: Add flags pm_op_in_progress and
 is_sys_suspended
To:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        ziqichen@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Satya Tangirala <satyat@google.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        open list <linux-kernel@vger.kernel.org>
References: <1624433711-9339-1-git-send-email-cang@codeaurora.org>
 <1624433711-9339-3-git-send-email-cang@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <77b92c6e-2e1c-c799-f6ac-04467175f96a@acm.org>
Date:   Thu, 24 Jun 2021 10:35:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1624433711-9339-3-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/23/21 12:35 AM, Can Guo wrote:
> @@ -9141,6 +9143,8 @@ static int ufshcd_suspend(struct ufs_hba *hba)
>  
>  	if (!hba->is_powered)
>  		return 0;
> +
> +	hba->pm_op_in_progress = true;
>  	/*
>  	 * Disable the host irq as host controller as there won't be any
>  	 * host controller transaction expected till resume.
> @@ -9160,6 +9164,7 @@ static int ufshcd_suspend(struct ufs_hba *hba)
>  	ufshcd_vreg_set_lpm(hba);
>  	/* Put the host controller in low power mode if possible */
>  	ufshcd_hba_vreg_set_lpm(hba);
> +	hba->pm_op_in_progress = false;
>  	return ret;
>  }
>  
> @@ -9179,6 +9184,7 @@ static int ufshcd_resume(struct ufs_hba *hba)
>  	if (!hba->is_powered)
>  		return 0;
>  
> +	hba->pm_op_in_progress = true;
>  	ufshcd_hba_vreg_set_hpm(hba);
>  	ret = ufshcd_vreg_set_hpm(hba);
>  	if (ret)
> @@ -9198,6 +9204,7 @@ static int ufshcd_resume(struct ufs_hba *hba)
>  out:
>  	if (ret)
>  		ufshcd_update_evt_hist(hba, UFS_EVT_RESUME_ERR, (u32)ret);
> +	hba->pm_op_in_progress = false;
>  	return ret;
>  }

Has it been considered to check dev->power.runtime_status instead of
introducing the pm_op_in_progress variable?

Thanks,

Bart.
