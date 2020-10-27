Return-Path: <SRS0=LZqT=EC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8388DC2D0A3
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 02:22:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B2B620872
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 02:22:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="MIC3Jvbv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441357AbgJ0CWK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Oct 2020 22:22:10 -0400
Received: from m42-4.mailgun.net ([69.72.42.4]:51749 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438662AbgJ0CWJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Oct 2020 22:22:09 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1603765328; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=AGhgURyohfn/3Ju6PDZpb7S7TBRxmdJD5RBwWfLer5k=;
 b=MIC3JvbvSj0aPmIR8/lK7tKsdi1ZAZKtKmY2XiEDoJxuAo5OzfVYdKUdQBtbY8EoUTTH7cCu
 TYNezXkn/O+RWE0laD5RHX/YR6x8ukhc62H4/KNPpXxfLiWRhUa0Jk0gvdwBdzPZ5HPcvPRr
 35djOCHz7vTWkEDzXK1TYGh7GEc=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 5f978403d6826c2dbd07e4af (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 27 Oct 2020 02:20:51
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id DA7B4C433FF; Tue, 27 Oct 2020 02:20:50 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 38B42C433CB;
        Tue, 27 Oct 2020 02:20:50 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 27 Oct 2020 10:20:50 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, alim.akhtar@samsung.com,
        avri.altman@wdc.com, bvanassche@acm.org,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: Re: [PATCH v4 5/5] scsi: ufs: fix clkgating on/off correctly
In-Reply-To: <20201026195124.363096-6-jaegeuk@kernel.org>
References: <20201026195124.363096-1-jaegeuk@kernel.org>
 <20201026195124.363096-6-jaegeuk@kernel.org>
Message-ID: <bcc5dd8f6da818247b420a1559ef4b25@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-10-27 03:51, Jaegeuk Kim wrote:
> The below call stack prevents clk_gating at every IO completion.
> We can remove the condition, ufshcd_any_tag_in_use(), since 
> clkgating_work
> will check it again.
> 
> ufshcd_complete_requests(struct ufs_hba *hba)
>   ufshcd_transfer_req_compl()
>     __ufshcd_transfer_req_compl()
>       __ufshcd_release(hba)
>         if (ufshcd_any_tag_in_use() == 1)
>            return;
>   ufshcd_tmc_handler(hba);
>     blk_mq_tagset_busy_iter();
> 
> Note that, this still requires a work to deal with a potential racy 
> condition
> when user sets clkgating.delay_ms to very small value. That can cause 
> preventing
> clkgating by the check of ufshcd_any_tag_in_use() in gate_work.
> 
> Fixes: 7252a3603015 ("scsi: ufs: Avoid busy-waiting by eliminating tag
> conflicts")
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>

Reviewed-by: Can Guo <cang@codeaurora.org>

> ---
>  drivers/scsi/ufs/ufshcd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index b8a54d09e750..86c8dee01ca9 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1746,7 +1746,7 @@ static void __ufshcd_release(struct ufs_hba *hba)
> 
>  	if (hba->clk_gating.active_reqs || hba->clk_gating.is_suspended ||
>  	    hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL ||
> -	    ufshcd_any_tag_in_use(hba) || hba->outstanding_tasks ||
> +	    hba->outstanding_tasks ||
>  	    hba->active_uic_cmd || hba->uic_async_done ||
>  	    hba->clk_gating.state == CLKS_OFF)
>  		return;
