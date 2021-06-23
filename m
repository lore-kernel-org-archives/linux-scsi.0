Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCF27C48BC2
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 20:59:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5224610F7
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 20:59:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbhFWVBi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Jun 2021 17:01:38 -0400
Received: from mail-pj1-f46.google.com ([209.85.216.46]:38816 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbhFWVBh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jun 2021 17:01:37 -0400
Received: by mail-pj1-f46.google.com with SMTP id t19-20020a17090ae513b029016f66a73701so4556845pjy.3;
        Wed, 23 Jun 2021 13:59:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xXD5y188ygqKIkP27Gof3N1FMMAdVHVTEzZJ+8kpeh4=;
        b=ndF3imxlP8rlk1+z5GcSTcdkhozNeUg0Ca+OKbZVVRP+NZ+vHQ9YLr1JTZ3vF6Pk8n
         OgUHq6tIYEbIL0JL7eg3nQddDoWaXX4U+0/H4z+RYCa4oHiOSRARZDFeayj/or2I8ZCb
         sjXdJoJXFf7PqHuWhgkuMQAE97sad+y08115rNy8/Cp33+G96+GsvhCRVLV/EAJDN0V5
         9bDR3QeZnTXd/mGbwxXlIz75470U6O0bcEo4jawIV87jVKzfFFbwH5Le202R1ReXSnMg
         2+ByNR2lzwfwC/yyujake9+2K2Wr0AN2fi9Rcn16MJxLWnenC3J1/Lwlk3F3tSVoWLN5
         ei9Q==
X-Gm-Message-State: AOAM53197IvY+aja8VqRQCdHcRf7QqT0FJv6B7HzrCuwNzQ0XjX9Y7ji
        oMZ7kfAMbnOfTJovJD7U1iFljY2RAOIVsA==
X-Google-Smtp-Source: ABdhPJxogZWFuvq2zJmdrJa+0l8fXgjJx10+S62G7CuFk5TTw17H7vMibpIVfzR+jX3WP607B14/zA==
X-Received: by 2002:a17:902:da84:b029:10e:fafc:b29b with SMTP id j4-20020a170902da84b029010efafcb29bmr1448845plx.35.1624481958920;
        Wed, 23 Jun 2021 13:59:18 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id o16sm693352pfk.129.2021.06.23.13.59.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 13:59:18 -0700 (PDT)
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
Message-ID: <e728719d-8e43-0e5a-af7a-14196dafa2a9@acm.org>
Date:   Wed, 23 Jun 2021 13:59:16 -0700
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
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 93aeeb3..1e7fe73 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -754,6 +754,8 @@ struct ufs_hba {
>  	struct device_attribute spm_lvl_attr;
>  	/* A flag to tell whether __ufshcd_wl_suspend/resume() is in progress */
>  	bool wlu_pm_op_in_progress;
> +	/* A flag to tell whether ufshcd_suspend/resume() is in progress */
> +	bool pm_op_in_progress;
>  
>  	/* Auto-Hibernate Idle Timer register value */
>  	u32 ahit;
> @@ -841,6 +843,8 @@ struct ufs_hba {
>  	struct ufs_clk_scaling clk_scaling;
>  	/* A flag to tell whether the UFS device W-LU is system suspended */
>  	bool is_wlu_sys_suspended;
> +	/* A flag to tell whether hba is system suspended */
> +	bool is_sys_suspended;
>  
>  	enum bkops_status urgent_bkops_lvl;
>  	bool is_urgent_bkops_lvl_checked;

It is not yet clear to me whether we really need these new member
variables. If these are retained, please rename pm_op_in_progress into
platform_pm_op_in_progress and is_sys_suspended into
platform_is_sys_suspended.

Thanks,

Bart.


