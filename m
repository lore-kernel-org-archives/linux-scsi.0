Return-Path: <SRS0=8IEi=A5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBDC6C433E1
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Jul 2020 04:15:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B999C2076A
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Jul 2020 04:15:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="nb8/LY1N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbgGREPb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Jul 2020 00:15:31 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:15947 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbgGREPb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 18 Jul 2020 00:15:31 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1595045730; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=kZI0pRkmSF19ncl6fjbgqaZ4PTyVGn4oMA3fOFjciPs=;
 b=nb8/LY1Nh6YsZo/SapzgVUyGqsX0pDn0TRRcXBW/1fzTLCyf3ub10hXyQqWh38KCmE9JziHM
 Rsop8m6kBcuQcozv86WX89DsoDQFaysD9rIzV+CgPh0+Hkw920y2RCuveTaAEgPp0RR9WQVi
 fm1mg5i0zdlnjqUC7MXDabFhRu8=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n08.prod.us-east-1.postgun.com with SMTP id
 5f12772fe3bee12510bf8c1c (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 18 Jul 2020 04:14:39
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 81FF4C43395; Sat, 18 Jul 2020 04:14:38 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CA30EC433C6;
        Sat, 18 Jul 2020 04:14:37 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sat, 18 Jul 2020 12:14:37 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Lee Sang Hyun <sh425.lee@samsung.com>
Cc:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        kwmad.kim@samsung.com
Subject: Re: [PATCH] scsi: ufs: set STATE_ERROR when ufshcd_probe_hba() failed
In-Reply-To: <1594970896-36170-1-git-send-email-sh425.lee@samsung.com>
References: <CGME20200717073633epcas2p21b8f5b5c64626b8ea299930193c6ad56@epcas2p2.samsung.com>
 <1594970896-36170-1-git-send-email-sh425.lee@samsung.com>
Message-ID: <6e5669e589d874e4e142020ad37721bf@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Sang Hyun,

On 2020-07-17 15:28, Lee Sang Hyun wrote:
> set STATE_ERR like below to prevent a lockup(IO stuck)
> when ufshcd_probe_hba() returns error.
> 
> Change-Id: I6c85ff290503cc9414d7f5fdd934295497b854ff
> Signed-off-by: Lee Sang Hyun <sh425.lee@samsung.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index ad4fc82..37e4105 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -7368,6 +7368,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba,
> bool async)
>  {
>  	int ret;
>  	ktime_t start = ktime_get();
> +	unsigned long flags;
> 
>  	ret = ufshcd_link_startup(hba);
>  	if (ret)
> @@ -7439,6 +7440,11 @@ static int ufshcd_probe_hba(struct ufs_hba
> *hba, bool async)
>  	ufshcd_auto_hibern8_enable(hba);
> 
>  out:
> +	if (ret) {
> +		spin_lock_irqsave(hba->host->host_lock, flags);
> +		hba->ufshcd_state = UFSHCD_STATE_ERROR;
> +		spin_unlock_irqrestore(hba->host->host_lock, flags);
> +	}

This change is included in my change
"scsi: ufs: Fix up and simplify error recovery mechanism",
please take a look if you are interested.

Thanks,

Can Guo.

> 
>  	trace_ufshcd_init(dev_name(hba->dev), ret,
>  		ktime_to_us(ktime_sub(ktime_get(), start)),
