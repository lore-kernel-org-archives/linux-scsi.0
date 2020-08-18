Return-Path: <SRS0=TRkT=B4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCE2FC433E4
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 05:43:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A30DC2075B
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 05:43:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="oEIqaBzZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726588AbgHRFnf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Aug 2020 01:43:35 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:49204 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726343AbgHRFne (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Aug 2020 01:43:34 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1597729414; h=In-Reply-To: Content-Type: MIME-Version:
 References: Message-ID: Subject: Cc: To: From: Date: Sender;
 bh=hVGk9WoKFEI85hZfqqpjRqhbkGzyJRRPLjlsKCsoybc=; b=oEIqaBzZcBVubJwfaYGrty+0RsokHpLe1++1X82ttwJ7tnZN824BhUbvZMW2j6nza8z5Xym8
 fgPjllyhGDSxm8BWKVKYeUp2vK7i7l8Bk5hCCGPADT9JPj7tGyYm0niDmgXOZyqvnGie2MtB
 AE71XEo3MibMYoJ8VwCDFdfRKCQ=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 5f3b6a56440a07969a98b25b (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 18 Aug 2020 05:42:46
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1FA5AC4339C; Tue, 18 Aug 2020 05:42:45 +0000 (UTC)
Received: from asutoshd-linux1.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 97F1EC433C6;
        Tue, 18 Aug 2020 05:42:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 97F1EC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=asutoshd@codeaurora.org
Date:   Mon, 17 Aug 2020 22:42:37 -0700
From:   Asutosh Das <asutoshd@codeaurora.org>
To:     Can Guo <cang@codeaurora.org>
Cc:     nguyenb@codeaurora.org, hongwus@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: ufs: Remove an unpaired
 ufshcd_scsi_unblock_requests() in err_handler()
Message-ID: <20200818054237.GA880@asutoshd-linux1.qualcomm.com>
References: <1597728047-39936-1-git-send-email-cang@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1597728047-39936-1-git-send-email-cang@codeaurora.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Aug 17 2020 at 22:21 -0700, Can Guo wrote:
>Commit 5586dd8ea250a ("scsi: ufs: Fix a race condition between error
>handler and runtime PM ops") moves the ufshcd_scsi_block_requests() inside
>err_handler(), but forgets to remove the ufshcd_scsi_unblock_requests() in
>the early return path. Correct the coding mistake.
>
>Signed-off-by: Can Guo <cang@codeaurora.org>
>
Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>

>diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>index 2b55c2e..b8441ad 100644
>--- a/drivers/scsi/ufs/ufshcd.c
>+++ b/drivers/scsi/ufs/ufshcd.c
>@@ -5670,7 +5670,6 @@ static void ufshcd_err_handler(struct work_struct *work)
> 		if (hba->ufshcd_state != UFSHCD_STATE_ERROR)
> 			hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
> 		spin_unlock_irqrestore(hba->host->host_lock, flags);
>-		ufshcd_scsi_unblock_requests(hba);
> 		return;
> 	}
> 	ufshcd_set_eh_in_progress(hba);
>-- 
>Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.
>
