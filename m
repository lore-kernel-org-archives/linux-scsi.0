Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7985BC48BC2
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 21:24:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F38761166
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 21:24:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhFWV1A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Jun 2021 17:27:00 -0400
Received: from mail-pf1-f180.google.com ([209.85.210.180]:44755 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhFWV07 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jun 2021 17:26:59 -0400
Received: by mail-pf1-f180.google.com with SMTP id g21so1669219pfc.11;
        Wed, 23 Jun 2021 14:24:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mfUoywj7A+qHZaFjYcTf+Sk+zKqKTIl/377sFv2uQeE=;
        b=opJeDT+EI/X3hXl+o31sgEYLHZnjROe3j+c+Hi1fIvwnxDyOkBg8D4L/s+hA46mpbq
         E2Qos7BefupiqBB3wXUUBGq3Me62oKp5N1kVy6NQrhVgOiuPm98wFB09oCTk3wZqCvrq
         jIej2nOAPka4HEZyM868SJmxQrt+ItwBvkzn5J4ftav4+u7P35AqqI1/1BHohF5utp7q
         b2YTD2U/GujSYXDFisAxTFGpLj7TfJHwhxS1nlhzlZ1bpqDG68D//fH1FAhjbMlVVLYM
         kx0pcKEArKenGH/OJv+Nvfyeqb8HQ8hP6/T3fWM2eZ1itHQ61eB+VOKqlds42IWA8aYI
         I+fA==
X-Gm-Message-State: AOAM531AM9WlEmImP0Rk0uOPpsOPdsph4heEP0SR3gyXN3keIHPXgmmK
        1xtL8RoI1xKQdO29hFLT1q5tfmX4ccY=
X-Google-Smtp-Source: ABdhPJy3aD3qI5cijiTLRw0cWD9T/89kkHDgwqz7GDDWm+VwdSPfgwgeIwbQ4XkmGnuAhqNzgnqCtA==
X-Received: by 2002:a63:50b:: with SMTP id 11mr1354190pgf.411.1624483481264;
        Wed, 23 Jun 2021 14:24:41 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id u13sm53193pga.64.2021.06.23.14.24.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 14:24:40 -0700 (PDT)
Subject: Re: [PATCH v4 05/10] scsi: ufs: Remove a redundant tag check in
 ufshcd_queuecommand()
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
        open list <linux-kernel@vger.kernel.org>
References: <1624433711-9339-1-git-send-email-cang@codeaurora.org>
 <1624433711-9339-7-git-send-email-cang@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <f98b3db3-f0cb-952d-b87e-acb7307e2090@acm.org>
Date:   Wed, 23 Jun 2021 14:24:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1624433711-9339-7-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/23/21 12:35 AM, Can Guo wrote:
> Since commit a45f937110fa6b0c2c06a5d3ef026963a5759050 ("scsi: ufs: Optimize

Please shorten commit IDs to 12 characters.

> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 5f837c4..3695dd2 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -2768,15 +2768,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>  	WARN_ON(ufshcd_is_clkgating_allowed(hba) &&
>  		(hba->clk_gating.state != CLKS_ON));
>  
> -	if (unlikely(test_bit(tag, &hba->outstanding_reqs))) {
> -		if (hba->wlu_pm_op_in_progress)
> -			set_host_byte(cmd, DID_BAD_TARGET);
> -		else
> -			err = SCSI_MLQUEUE_HOST_BUSY;
> -		ufshcd_release(hba);
> -		goto out;
> -	}

I have never encountered code like the above in any other SCSI LLD. Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
