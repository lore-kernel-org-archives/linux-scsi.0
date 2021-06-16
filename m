Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ED9BC48BE8
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 17:50:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82DDF61356
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 17:50:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbhFPRwU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Jun 2021 13:52:20 -0400
Received: from mail-pf1-f169.google.com ([209.85.210.169]:46890 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbhFPRwT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jun 2021 13:52:19 -0400
Received: by mail-pf1-f169.google.com with SMTP id x16so2779305pfa.13;
        Wed, 16 Jun 2021 10:50:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DBu8MXj8Z++5Tj08sCxjj3DBtiPGk64NAkrDpA4YCsY=;
        b=auSoCwuxcjAacY5VxkNCZPm9cMc0cny0DdkalmogWbB+JiVU9B7Hfys+roO4vdF9xc
         urDh+zL6BS8Vn73evIUnrKG/nzusSGKZMZs/28t0g5RzARZKyM0BQDErH33cI2KGREWA
         dRgJwsRYEgp3VhAoLOaFFBYEkMjkpEYZgxVx8wXieDSUBCdD0WLo0bzdU15JR225kCWE
         zScbnjy3xPVmceZ30rvv7xRX4/W4QKiRHgyvxuZAnfciIijVjDfeh9HWNUJJ/vgICXCi
         Rjcj4JJNMRYaZL8HNpnluZdS4P9YBlzTMs4T5Xl0Zz2H/BpGUQkC0XM+47E5DVepCR+M
         u53g==
X-Gm-Message-State: AOAM531Dkv/1CaxowCv9nN7qi0nO0avr7qoNgxSaz/X/0yE+GKNPhcJp
        znHsw81+lAwkR+IzcALFdxfGS4A3i9I=
X-Google-Smtp-Source: ABdhPJzxxZf40hpoe5Njow08uqeWKKX6+TG/Lp2v13nLFEun8M9iDYGAmiHoa2cfsMnNnE04F7PfGA==
X-Received: by 2002:a63:3d82:: with SMTP id k124mr721310pga.401.1623865812362;
        Wed, 16 Jun 2021 10:50:12 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id b1sm2808404pjh.4.2021.06.16.10.50.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jun 2021 10:50:11 -0700 (PDT)
Subject: Re: [PATCH v3 1/9] scsi: ufs: Differentiate status between hba pm ops
 and wl pm ops
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
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
References: <1623300218-9454-1-git-send-email-cang@codeaurora.org>
 <1623300218-9454-2-git-send-email-cang@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <a5804465-2ad4-f122-0458-dcdd75f39310@acm.org>
Date:   Wed, 16 Jun 2021 10:50:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1623300218-9454-2-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/9/21 9:43 PM, Can Guo wrote:
> @@ -8784,7 +8786,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>  	enum ufs_dev_pwr_mode req_dev_pwr_mode;
>  	enum uic_link_state req_link_state;
>  
> -	hba->pm_op_in_progress = true;
> +	hba->wl_pm_op_in_progress = true;
>  	if (pm_op != UFS_SHUTDOWN_PM) {
>  		pm_lvl = pm_op == UFS_RUNTIME_PM ?
>  			 hba->rpm_lvl : hba->spm_lvl;
> @@ -8919,7 +8921,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>  		hba->clk_gating.is_suspended = false;
>  		ufshcd_release(hba);
>  	}
> -	hba->pm_op_in_progress = false;
> +	hba->wl_pm_op_in_progress = false;
>  	return ret;
>  }

Are the __ufshcd_wl_suspend() calls serialized in any way? If not, will
the value of wl_pm_op_in_progress be incorrect if multiple kernel
threads run __ufshcd_wl_suspend() concurrently and one of the
__ufshcd_wl_suspend() instances returns earlier than the other?

Thanks,

Bart.
