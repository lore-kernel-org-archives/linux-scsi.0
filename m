Return-Path: <SRS0=ehq5=D3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CC2EC433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 02:35:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CE8C223BF
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 02:35:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="eywAp/bz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730497AbgJTCfz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Oct 2020 22:35:55 -0400
Received: from m42-4.mailgun.net ([69.72.42.4]:25190 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730404AbgJTCfz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 19 Oct 2020 22:35:55 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1603161354; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=7V0ug32c1j1PP+hx2W4Yh8PnNSTX3h6faSFkylQvda0=;
 b=eywAp/bzcf6xLmnT8DVIciT6wPjO73Z780V5fzkAMxmESyxoaVyiAApDbXfPnICOZCDEjVIV
 Z4zH7I7HFhUp1767zub88j2OF/e0/icqfpDQx+UKRaXr+Y4ic12uUFp6AKK0nxml2WkCFASR
 OBdaFldpM4J5E9QgXgjBY4Rptyc=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 5f8e4d0aaad2c3cd1c610816 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 20 Oct 2020 02:35:54
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id DAA79C43382; Tue, 20 Oct 2020 02:35:53 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 31967C433FE;
        Tue, 20 Oct 2020 02:35:53 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 20 Oct 2020 10:35:53 +0800
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com, cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: Make sure clk scaling happens only when hba is
 runtime ACTIVE
In-Reply-To: <1600758548-28576-1-git-send-email-cang@codeaurora.org>
References: <1600758548-28576-1-git-send-email-cang@codeaurora.org>
Message-ID: <67c4ae5998765daa674a4df696d8d673@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Stanley,

On 2020-09-22 15:09, Can Guo wrote:
> If someone plays with the UFS clk scaling devfreq governor through 
> sysfs,
> ufshcd_devfreq_scale may be called even when hba is not runtime ACTIVE,
> which can lead to unexpected error. We cannot just protect it by 
> calling
> pm_runtime_get_sync, because that may cause racing problem since hba
> runtime suspend ops needs to suspend clk scaling. In order to fix it, 
> call
> pm_runtime_get_noresume and check hba's runtime status, then only 
> proceed
> if hba is runtime ACTIVE, otherwise just bail.
> 
> governor_store
>  devfreq_performance_handler
>   update_devfreq
>    devfreq_set_target
>     ufshcd_devfreq_target
>      ufshcd_devfreq_scale
> 
> Signed-off-by: Can Guo <cang@codeaurora.org>
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index e4cb994..847f355 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1294,8 +1294,15 @@ static int ufshcd_devfreq_target(struct device 
> *dev,
>  	}
>  	spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
> 
> +	pm_runtime_get_noresume(hba->dev);
> +	if (!pm_runtime_active(hba->dev)) {
> +		pm_runtime_put_noidle(hba->dev);
> +		ret = -EAGAIN;
> +		goto out;
> +	}
>  	start = ktime_get();
>  	ret = ufshcd_devfreq_scale(hba, scale_up);
> +	pm_runtime_put(hba->dev);
> 
>  	trace_ufshcd_profile_clk_scaling(dev_name(hba->dev),
>  		(scale_up ? "up" : "down"),

Could you please review this one since we may be the only two
users of clk scaling?

Thanks,

Can Guo.
