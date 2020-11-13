Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DA85C388F9
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Nov 2020 05:05:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBD8F20A8B
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Nov 2020 05:05:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="lWC+LnLk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbgKMFFK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Nov 2020 00:05:10 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:56859 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726023AbgKMFFK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 13 Nov 2020 00:05:10 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1605243909; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=2vV1+LRLbU3pMGMU7pkb9KyQ6+s8e9iW3o/q4gDHIV8=;
 b=lWC+LnLkuROmcSgns1deonY09pefOnC+aXjTm9P9qOqPLTGXQJTGM85+Mpm9E0aYo1ITYsJy
 4cvT8o/UX4kylWjJ3Tn0OppPSPctgS3F1Ru+I/Ebtv/Bh0vFb7HlqDfaGm+8WhoAM6GEW+Cm
 tlolxJu46iF0uJEWDWy+9Di0+9g=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 5fae14038e090a88865b22a9 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 13 Nov 2020 05:05:07
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6ACD9C433C6; Fri, 13 Nov 2020 05:05:07 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EA7F0C433C8;
        Fri, 13 Nov 2020 05:05:05 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 13 Nov 2020 13:05:05 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Yang Yang <yang.yang@vivo.com>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Sujit Reddy Thumma <sthumma@codeaurora.org>,
        Dolev Raviv <draviv@codeaurora.org>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        onlyfever@icloud.com
Subject: Re: [PATCH] scsi: ufs: Fix a bug in ufshcd_system_resume()
In-Reply-To: <20201110085537.2889-1-yang.yang@vivo.com>
References: <20201110085537.2889-1-yang.yang@vivo.com>
Message-ID: <52a959ba7514f802488c93f907586a1d@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-11-10 16:55, Yang Yang wrote:
> During system resume, ufshcd_system_resume() won't resume UFS host if
> runtime suspended. After that, scsi_bus_resume() try to set SCSI host's
> RPM status to RPM_ACTIVE, this will fail because UFS host's RPM status
> is still RPM_SUSPENDED. So fix it.
> 
>     scsi host0: scsi_runtime_suspend()
> 		ufshcd_runtime_suspend()
>     scsi host0: scsi_bus_suspend()
> 		ufshcd_system_suspend()
>     ----------------------------------
> 		ufshcd_pltfrm_resume()
>     scsi host0: scsi_bus_resume()
>     scsi host0: scsi_bus_resume_common()
>     scsi host0: pm_runtime_set_active(dev)
> 
>     scsi host0: runtime PM trying to activate child device host0 but 
> parent
>     (8800000.ufshc) is not active
> 
> Fixes: 57d104c153d3 ("ufs: add UFS power management support")
> Signed-off-by: Yang Yang <yang.yang@vivo.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index b8f573a02713..9e666e1ad58c 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -8767,11 +8767,7 @@ int ufshcd_system_resume(struct ufs_hba *hba)
>  	if (!hba)
>  		return -EINVAL;
> 
> -	if (!hba->is_powered || pm_runtime_suspended(hba->dev))
> -		/*
> -		 * Let the runtime resume take care of resuming
> -		 * if runtime suspended.
> -		 */
> +	if (!hba->is_powered)
>  		goto out;
>  	else
>  		ret = ufshcd_resume(hba, UFS_SYSTEM_PM);
> @@ -8779,8 +8775,15 @@ int ufshcd_system_resume(struct ufs_hba *hba)
>  	trace_ufshcd_system_resume(dev_name(hba->dev), ret,
>  		ktime_to_us(ktime_sub(ktime_get(), start)),
>  		hba->curr_dev_pwr_mode, hba->uic_link_state);
> -	if (!ret)
> +	if (!ret) {
>  		hba->is_sys_suspended = false;
> +
> +		if (pm_runtime_suspended(hba->dev)) {
> +			pm_runtime_disable(hba->dev);
> +			pm_runtime_set_active(hba->dev);
> +			pm_runtime_enable(hba->dev);
> +		}
> +	}
>  	return ret;
>  }
>  EXPORT_SYMBOL(ufshcd_system_resume);

It is designed like this - if hba is runtime suspend, do not resume it
during system resume, which is the so called deferred resume feature.
This is to leave the runtime PM management to block layer PM, which
is more power efficiency.

> scsi host0: runtime PM trying to activate child device host0 but parent
> (8800000.ufshc) is not active
The log is not harmful or fatal, maybe just annoying. Do you see real
problem with it? If yes, please share it here.

Thanks,

Can Guo.
