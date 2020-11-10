Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29D0EC388F7
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Nov 2020 18:18:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE9B220797
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Nov 2020 18:18:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="VLAbQG5/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730672AbgKJSSM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Nov 2020 13:18:12 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:27642 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726152AbgKJSSM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Nov 2020 13:18:12 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1605032291; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=1v/7o0QVfMPf/rh8cR2nTJ87U1DD86pv7+KwaCwWMb8=; b=VLAbQG5/6jRYZxaVqMbyeXLY0E8bSV77WKBTY0PEkl0h/2sHJSHo3lYfz0NX3wW4IWElDONt
 Des3RVYPqhB9Bq0bQJHmtHi7r2WzHIckKamUPXfl+FAQAd3JBs94Y7izgOe9pxIG73KWPrHc
 48y80aPsNEedzKQuFqQftvxauO0=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 5faad9590d87d63775bc0181 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 10 Nov 2020 18:18:01
 GMT
Sender: asutoshd=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 193F5C433CB; Tue, 10 Nov 2020 18:18:01 +0000 (UTC)
Received: from [192.168.8.168] (cpe-70-95-149-85.san.res.rr.com [70.95.149.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 781EDC433C9;
        Tue, 10 Nov 2020 18:17:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 781EDC433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [PATCH v2] scsi: ufshcd: fix missing destroy_workqueue()
To:     Qinglang Miao <miaoqinglang@huawei.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201110074223.41280-1-miaoqinglang@huawei.com>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <e765eb4f-a85d-72c8-3f82-1f321e3d6c3b@codeaurora.org>
Date:   Tue, 10 Nov 2020 10:17:57 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201110074223.41280-1-miaoqinglang@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/9/2020 11:42 PM, Qinglang Miao wrote:
> Add the missing destroy_workqueue() before return from
> ufshcd_init in the error handling case as well as in
> ufshcd_remove.
> 
> Fixes: 4db7a2360597 ("scsi: ufs: Fix concurrency of error handler and other error recovery paths")
> Suggested-by: Avri Altman <Avri.Altman@wdc.com>
> Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
> ---

Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>

>   v2: consider missing destroy_workqueue ufshcd_remove either.
> 
>   drivers/scsi/ufs/ufshcd.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index b8f573a02713..adbdda4f556b 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -8906,6 +8906,7 @@ void ufshcd_remove(struct ufs_hba *hba)
>   	blk_mq_free_tag_set(&hba->tmf_tag_set);
>   	blk_cleanup_queue(hba->cmd_queue);
>   	scsi_remove_host(hba->host);
> +	destroy_workqueue(hba->eh_wq);
>   	/* disable interrupts */
>   	ufshcd_disable_intr(hba, hba->intr_mask);
>   	ufshcd_hba_stop(hba);
> @@ -9206,6 +9207,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
>   exit_gating:
>   	ufshcd_exit_clk_scaling(hba);
>   	ufshcd_exit_clk_gating(hba);
> +	destroy_workqueue(hba->eh_wq);
>   out_disable:
>   	hba->is_irq_enabled = false;
>   	ufshcd_hba_exit(hba);
> 


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
