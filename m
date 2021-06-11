Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB7F7C48BE0
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Jun 2021 20:52:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFA05613CA
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Jun 2021 20:52:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbhFKUyV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Jun 2021 16:54:21 -0400
Received: from mail-pl1-f182.google.com ([209.85.214.182]:36860 "EHLO
        mail-pl1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbhFKUyU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Jun 2021 16:54:20 -0400
Received: by mail-pl1-f182.google.com with SMTP id x10so3432380plg.3;
        Fri, 11 Jun 2021 13:52:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TJMxLoKB5A1+wwU2Ud8xDFQ5JXpkKM21vfaV9VrMyCE=;
        b=VvycVjrItD7xW7loJqhky7aMh6q/k7A4GBsr8lMnnG2JiAWl/DbzwmX1ZHVZNqvIEf
         gVQw/vg833XUcU8R8/oLz2z7emk48rpBBordrXQKOn4zKd4XtE3VjGNx4/xgHBmo0+qC
         Q0PTEVc7q1+PsHpDqjExthl2l8R24AxwhYyBvVTQkxvpw5qbf6r5wnllkqRzB9nXV3gN
         +V+EuyrqK7mZzlXI/UbaYHTQKhu3NIwCdVL8Ugl5vv0izjMVv8499hbhPd2dWrWdA5Ip
         5YeuxKNyR4A72pjgiln0XgCiARbwf+gqkFfBI/aAaAE7riBbH4TARPN0IRRuXGvoiFIw
         44Pw==
X-Gm-Message-State: AOAM5339kSdBSok89GJaX/ZyUVXv76LMFDBHKv4yuysxO/oCL1FxZdBr
        vRteZbier95IR5W3Wki+tHyw4IZXNNE=
X-Google-Smtp-Source: ABdhPJyJTS6z/OsZewzLBZ3SF2ivr5UUMYEgGEpD3eD4BgSSb2Sso+Ug51g8U5yI5YM1C1lX1GYIGg==
X-Received: by 2002:a17:903:4106:b029:fd:9cea:7008 with SMTP id r6-20020a1709034106b02900fd9cea7008mr5564802pld.47.1623444741289;
        Fri, 11 Jun 2021 13:52:21 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id l201sm5919224pfd.183.2021.06.11.13.52.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Jun 2021 13:52:20 -0700 (PDT)
Subject: Re: [PATCH v3 4/9] scsi: ufs: Complete the cmd before returning in
 queuecommand
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
References: <1623300218-9454-1-git-send-email-cang@codeaurora.org>
 <1623300218-9454-5-git-send-email-cang@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <d017548a-16fb-8ad0-2363-09dad00c9642@acm.org>
Date:   Fri, 11 Jun 2021 13:52:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <1623300218-9454-5-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/9/21 9:43 PM, Can Guo wrote:
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 0c9d2ee..7dc0fda 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -2758,6 +2758,16 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>  		goto out;
>  	}
>  
> +	if (unlikely(test_bit(tag, &hba->outstanding_reqs))) {
> +		if (hba->wl_pm_op_in_progress) {
> +			set_host_byte(cmd, DID_BAD_TARGET);
> +			cmd->scsi_done(cmd);
> +		} else {
> +			err = SCSI_MLQUEUE_HOST_BUSY;
> +		}
> +		goto out;
> +	}
> +
>  	hba->req_abort_count = 0;
>  
>  	err = ufshcd_hold(hba, true);
> @@ -2768,15 +2778,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>  	WARN_ON(ufshcd_is_clkgating_allowed(hba) &&
>  		(hba->clk_gating.state != CLKS_ON));
>  
> -	if (unlikely(test_bit(tag, &hba->outstanding_reqs))) {
> -		if (hba->wl_pm_op_in_progress)
> -			set_host_byte(cmd, DID_BAD_TARGET);
> -		else
> -			err = SCSI_MLQUEUE_HOST_BUSY;
> -		ufshcd_release(hba);
> -		goto out;
> -	}
> -
>  	lrbp = &hba->lrb[tag];
>  	WARN_ON(lrbp->cmd);
>  	lrbp->cmd = cmd;

Can the code under "if (unlikely(test_bit(tag,
&hba->outstanding_reqs)))" be deleted instead of moving it? I don't
think that it is useful to verify whether the block layer tag allocator
works correctly. Additionally, I'm not aware of any similar code in any
other SCSI LLD.

Thanks,

Bart.


