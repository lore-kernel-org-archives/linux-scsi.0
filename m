Return-Path: <SRS0=ehq5=D3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F760C433E7
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 02:19:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51301223BF
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 02:19:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="vsjG8QGV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390530AbgJTCTz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Oct 2020 22:19:55 -0400
Received: from m42-4.mailgun.net ([69.72.42.4]:43364 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730130AbgJTCTz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 19 Oct 2020 22:19:55 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1603160395; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=5BVsSY0ox/S3zztq9B7f3z1X/K1uDSUzg2BONZtv+90=;
 b=vsjG8QGVg5znGOccJU/cJP1I/PGGiwlXAQ/Tiq58WFsmRjqXN42uMFV+UUYmCxIhPy31uKeH
 7YIcn3bZ7CO2XIDyZfQmPbF3bszx+Uy/kPZxL1GAJ7ftIlAtNlSOHmbBOoQ7QQtcmitifRFF
 YuAUQUWns4NiH7l9yVCHMD5qjSc=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 5f8e494a319d4e9cb595aeb3 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 20 Oct 2020 02:19:54
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6ABFEC433FF; Tue, 20 Oct 2020 02:19:54 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C0AE6C433C9;
        Tue, 20 Oct 2020 02:19:53 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 20 Oct 2020 10:19:53 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, Jaegeuk Kim <jaegeuk@google.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: Re: [PATCH 3/4] scsi: ufs: use WQ_HIGHPRI for gating work
In-Reply-To: <20201005223635.2922805-3-jaegeuk@kernel.org>
References: <20201005223635.2922805-1-jaegeuk@kernel.org>
 <20201005223635.2922805-3-jaegeuk@kernel.org>
Message-ID: <5c383fd90a0e97dbd1fffc35574133c9@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-10-06 06:36, Jaegeuk Kim wrote:
> From: Jaegeuk Kim <jaegeuk@google.com>
> 
> Must have WQ_MEM_RECLAIM
> ``WQ_MEM_RECLAIM``
>   All wq which might be used in the memory reclaim paths **MUST**
>   have this flag set.  The wq is guaranteed to have at least one
>   execution context regardless of memory pressure.
> 

The commit msg is not telling the same story as the change/title does.

Regards,

Can Guo.

> Cc: Alim Akhtar <alim.akhtar@samsung.com>
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Can Guo <cang@codeaurora.org>
> Signed-off-by: Jaegeuk Kim <jaegeuk@google.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 0bb07b50bd23e..76e95963887be 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1849,7 +1849,7 @@ static void ufshcd_init_clk_gating(struct ufs_hba 
> *hba)
>  	snprintf(wq_name, ARRAY_SIZE(wq_name), "ufs_clk_gating_%d",
>  		 hba->host->host_no);
>  	hba->clk_gating.clk_gating_workq = alloc_ordered_workqueue(wq_name,
> -							   WQ_MEM_RECLAIM);
> +					WQ_MEM_RECLAIM | WQ_HIGHPRI);
> 
>  	hba->clk_gating.is_enabled = true;
