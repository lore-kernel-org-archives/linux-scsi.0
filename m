Return-Path: <SRS0=lUfO=A6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E831C433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jul 2020 10:20:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09D05208DB
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jul 2020 10:20:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="JYuVKoSG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbgGSKU1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Jul 2020 06:20:27 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:42566 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbgGSKU1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 19 Jul 2020 06:20:27 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1595154026; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=3WKhNoT72PjTLLU0AAfidX0Z4pbHPPrBM71pG/YscQU=;
 b=JYuVKoSG4xKb+GjR8GLcT4TWRvvrNn0ysHFBvhQAns43N57N+/KkohDXj4jHW6U9rpHvedM1
 Gj7w70j/Ckh5YLoR4A/LrMHWVqdsjEo6tDxf2s38TJF7S19bXKhjim6PUssxvkaJPoC6iLEy
 guj/8UxEePm+iTsda0l9sBYDT08=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 5f141e38427cd5576633ea0f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 19 Jul 2020 10:19:36
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 59E82C4339C; Sun, 19 Jul 2020 10:19:35 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7181DC433C6;
        Sun, 19 Jul 2020 10:19:34 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 19 Jul 2020 18:19:34 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Lee Sang Hyun <sh425.lee@samsung.com>
Cc:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        kwmad.kim@samsung.com
Subject: Re: [RFC PATCH v2] scsi: ufs: set STATE_ERROR when ufshcd_probe_hba()
 failed
In-Reply-To: <1594971107-37463-1-git-send-email-sh425.lee@samsung.com>
References: <CGME20200717073950epcas2p3fe023138e3c04e706a1afb887998eb5c@epcas2p3.samsung.com>
 <1594971107-37463-1-git-send-email-sh425.lee@samsung.com>
Message-ID: <fe7ffa6778360cafeabbd238db85ae13@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Sang Hyun,

On 2020-07-17 15:31, Lee Sang Hyun wrote:
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
> 
>  	trace_ufshcd_init(dev_name(hba->dev), ret,
>  		ktime_to_us(ktime_sub(ktime_get(), start)),

This change is included in my change
"scsi: ufs: Fix up and simplify error recovery mechanism".

Besides, this change seems not complete because

#1 You are only protecting your changes with spin lock in
ufshcd_probe_hba, what about the other line
"hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;"?

#2 As you are giving "hba->ufshcd_state = UFSHCD_STATE_ERROR;"
in ufshcd_probe_hba, why keep the same lines in
ufshcd_error_handler and ufshcd_eh_host_reset_handler?

Thanks,

Can Guo.
