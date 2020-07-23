Return-Path: <SRS0=JunS=BC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AA94C433EB
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 03:21:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A33A20771
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 03:21:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="TvV+b3pR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733155AbgGWDVG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jul 2020 23:21:06 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:33527 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729401AbgGWDVG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Jul 2020 23:21:06 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1595474465; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=GYUHQD9UFJd3/Ug179wafi2cUgd7wUBMj5u8vpLP3qU=;
 b=TvV+b3pRCLmWR0mkIEuKLKlxNcvjPEMq3eH+J/Q/dabzUFa6xGiYylcs0j1P1TnfdGTtHJmV
 h1zB5VK4sAR5oDuo00Er9tAmReHv5vA9tYTZj1/kRaXlFQGQNmCLnueuwUejRJ+e91f8O1WW
 hr/C78xIarsLtuaipNrpEUlqcbM=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n12.prod.us-east-1.postgun.com with SMTP id
 5f190214f9ca681bd095ffe4 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 23 Jul 2020 03:20:52
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1BF0EC43391; Thu, 23 Jul 2020 03:20:52 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: hongwus)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 22B10C433C9;
        Thu, 23 Jul 2020 03:20:50 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 23 Jul 2020 11:20:50 +0800
From:   hongwus@codeaurora.org
To:     Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, sh425.lee@samsung.com,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/9] scsi: ufs: Fix imbalanced scsi_block_reqs_cnt
 caused by ufshcd_hold()
In-Reply-To: <1595471649-25675-3-git-send-email-cang@codeaurora.org>
References: <1595471649-25675-1-git-send-email-cang@codeaurora.org>
 <1595471649-25675-3-git-send-email-cang@codeaurora.org>
Message-ID: <307b91fd2d7a59a3e1caa1819e2593e5@codeaurora.org>
X-Sender: hongwus@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Can,
On 2020-07-23 10:34, Can Guo wrote:
> The scsi_block_reqs_cnt increased in ufshcd_hold() is supposed to be
> decreased back in ufshcd_ungate_work() in a paired way. However, if
> specific ufshcd_hold/release sequences are met, it is possible that
> scsi_block_reqs_cnt is increased twice but only one ungate work is
> queued. To make sure scsi_block_reqs_cnt is handled by ufshcd_hold() 
> and
> ufshcd_ungate_work() in a paired way, increase it only if queue_work()
> returns true.
> 
> Signed-off-by: Can Guo <cang@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 99bd3e4..2907828 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1611,12 +1611,12 @@ int ufshcd_hold(struct ufs_hba *hba, bool 
> async)
>  		 */
>  		/* fallthrough */
>  	case CLKS_OFF:
> -		ufshcd_scsi_block_requests(hba);
>  		hba->clk_gating.state = REQ_CLKS_ON;
>  		trace_ufshcd_clk_gating(dev_name(hba->dev),
>  					hba->clk_gating.state);
> -		queue_work(hba->clk_gating.clk_gating_workq,
> -			   &hba->clk_gating.ungate_work);
> +		if (queue_work(hba->clk_gating.clk_gating_workq,
> +			       &hba->clk_gating.ungate_work))
> +			ufshcd_scsi_block_requests(hba);
>  		/*
>  		 * fall through to check if we should wait for this
>  		 * work to be done or not.

Yes, queue_work() may fail for some reasons. We should make sure 
scsi_block_reqs_cnt is balanced. Your change looks good to me since it 
touches scsi_block_reqs_cnt only when the condition is met.

Reviewed-by: Hongwu Su <hongwus@codeaurora.org>

