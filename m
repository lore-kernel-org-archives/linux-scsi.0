Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 607F8C4361B
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Dec 2020 05:49:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CFC222D6D
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Dec 2020 05:49:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgLTFth (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 20 Dec 2020 00:49:37 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:31522 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726113AbgLTFth (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Dec 2020 00:49:37 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1608443358; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=CZ0XrPRIWoKljy4jIOitwDehlcO9+360TLC6Y2/Xyaw=;
 b=pfCUQ+QOPkmKDbieRleYvnhDVfMvhMkeP8DXTzf14kvWjnmYJJL/ebaELczk4LWiZAEZjHyf
 F6c1ByobiB5RenKS2d6U5BQNLmaZ1I6nF4UjRM/lMxWFaKRVNTjVKbkjULFXig/4sW632oRz
 Y2fVJr80/icMucZSVp1XhNjlJF0=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 5fdee5c275ab652e87db5d28 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 20 Dec 2020 05:48:50
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B6856C433ED; Sun, 20 Dec 2020 05:48:50 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 514E3C433CA;
        Sun, 20 Dec 2020 05:48:49 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 20 Dec 2020 13:48:49 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Kiwoong Kim <kwmad.kim@samsung.com>
Cc:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com
Subject: Re: [RFC PATCH v1] ufs: relocate flush of exceptional event
In-Reply-To: <1608360039-16390-1-git-send-email-kwmad.kim@samsung.com>
References: <CGME20201219065127epcas2p4ee350f78ba75619dfd502dbb2e694a9b@epcas2p4.samsung.com>
 <1608360039-16390-1-git-send-email-kwmad.kim@samsung.com>
Message-ID: <bd3f1db0170a5cc6badade2d5372ef19@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-12-19 14:40, Kiwoong Kim wrote:
> I found one case as follows and the current flush
> location doesn't guarantee disabling BKOPS in the
> case of requsting device power off.
> 1) The exceptional event handler is queued.
> 2) ufs suspend starts with a request of device power off
> 3) BKOPS is disabled in ufs suspend
> 4) The queued work for the handler is done and BKOPS
> is enabled again.
> 
> Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 92d433d..414025c 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -8608,6 +8608,8 @@ static int ufshcd_suspend(struct ufs_hba *hba,
> enum ufs_pm_op pm_op)
>  			ufshcd_wb_need_flush(hba));
>  	}
> 
> +	flush_work(&hba->eeh_work);
> +
>  	if (req_dev_pwr_mode != hba->curr_dev_pwr_mode) {
>  		if ((ufshcd_is_runtime_pm(pm_op) && !hba->auto_bkops_enabled) ||
>  		    !ufshcd_is_runtime_pm(pm_op)) {
> @@ -8622,8 +8624,6 @@ static int ufshcd_suspend(struct ufs_hba *hba,
> enum ufs_pm_op pm_op)
>  		}
>  	}
> 
> -	flush_work(&hba->eeh_work);
> -
>  	/*
>  	 * In the case of DeepSleep, the device is expected to remain powered
>  	 * with the link off, so do not check for bkops.

Reviewed-by: Can Guo <cang@codeaurora.org>
