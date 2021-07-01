Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4A00C11F67
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 22:26:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B6B261416
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 22:26:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236875AbhGAW31 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Jul 2021 18:29:27 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:43321 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234270AbhGAW30 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jul 2021 18:29:26 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1625178415; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=rROsKx2wa9L/BZ+T4ZHjsxB1LDe8vV3ompVZNCEPTU8=; b=OxEeohpFPuBt9WxMoMYE/fXdh0bUWYEPXmSHb+81QDTDDHSa8Iz+3F3pHEPxMSiVYvJKUdEB
 gsRCs+uHyFGXCnxulUBFT8caq38HP2QNxMU/GLMzgIwXI3Du/mG2q+a0KGV+PD6bYhoK74RW
 z5SIbkGsoW71XXr7PAgkgKUwm9w=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 60de412c5e3e57240be576cb (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 01 Jul 2021 22:26:52
 GMT
Sender: asutoshd=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 0FE9BC43217; Thu,  1 Jul 2021 22:26:52 +0000 (UTC)
Received: from [192.168.8.168] (cpe-70-95-149-85.san.res.rr.com [70.95.149.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5CDABC433D3;
        Thu,  1 Jul 2021 22:26:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5CDABC433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [PATCH 13/21] ufs: Remove several wmb() calls
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>
References: <20210701211224.17070-1-bvanassche@acm.org>
 <20210701211224.17070-14-bvanassche@acm.org>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <a5770fbe-9bdc-444e-2093-aa3fd58d5638@codeaurora.org>
Date:   Thu, 1 Jul 2021 15:26:47 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210701211224.17070-14-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/1/2021 2:12 PM, Bart Van Assche wrote:
>  From arch/arm/include/asm/io.h
> 
>    #define __iowmb() wmb()
>    [ ... ]
>    #define writel(v,c) ({ __iowmb(); writel_relaxed(v,c); })
> 
>  From Documentation/memory-barriers.txt: "Note that, when using writel(), a
> prior wmb() is not needed to guarantee that the cache coherent memory
> writes have completed before writing to the MMIO region."
> 
> In other words, calling wmb() before writel() is not necessary. Hence
> remove the wmb() calls that precede a writel() call. Remove the wmb()
> calls that precede a ufshcd_send_command() call since the latter function
> uses writel(). Remove the wmb() call from ufshcd_wait_for_dev_cmd()
> since the following chain of events guarantees that the CPU will see
> up-to-date LRB values:
> * UFS controller writes to host memory.
> * UFS controller posts completion interrupt after the memory writes from
>    the previous step are visible to the CPU.
> * complete(hba->dev_cmd.complete) is called from the UFS interrupt handler.
> * The wait_for_completion(hba->dev_cmd.complete) call in
>    ufshcd_wait_for_dev_cmd() returns.
> 
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> Cc: Can Guo <cang@codeaurora.org>
> Cc: Asutosh Das <asutoshd@codeaurora.org>
> Cc: Avri Altman <avri.altman@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/ufs/ufshcd.c | 11 -----------
>   1 file changed, 11 deletions(-)
> 

Hi Bart,
Did you verify this change? I think we've seen OCS errors which were 
fixed with the wmb() in queuecommand.

> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 7091798e6245..25ab603acad1 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -2768,8 +2768,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>   		ufshcd_release(hba);
>   		goto out;
>   	}
> -	/* Make sure descriptors are ready before ringing the doorbell */
> -	wmb();
>   
>   	ufshcd_send_command(hba, tag);
>   out:
> @@ -2879,8 +2877,6 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hba,
>   	time_left = wait_for_completion_timeout(hba->dev_cmd.complete,
>   			msecs_to_jiffies(max_timeout));
>   
> -	/* Make sure descriptors are ready before ringing the doorbell */
> -	wmb();
>   	spin_lock_irqsave(hba->host->host_lock, flags);
>   	hba->dev_cmd.complete = NULL;
>   	if (likely(time_left)) {
> @@ -2955,8 +2951,6 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
>   	hba->dev_cmd.complete = &wait;
>   
>   	ufshcd_add_query_upiu_trace(hba, UFS_QUERY_SEND, lrbp->ucd_req_ptr);
> -	/* Make sure descriptors are ready before ringing the doorbell */
> -	wmb();
>   
>   	ufshcd_send_command(hba, tag);
>   	err = ufshcd_wait_for_dev_cmd(hba, lrbp, timeout);
> @@ -6514,9 +6508,6 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
>   	/* send command to the controller */
>   	__set_bit(task_tag, &hba->outstanding_tasks);
>   
> -	/* Make sure descriptors are ready before ringing the task doorbell */
> -	wmb();
> -
>   	ufshcd_writel(hba, 1 << task_tag, REG_UTP_TASK_REQ_DOOR_BELL);
>   	/* Make sure that doorbell is committed immediately */
>   	wmb();
> @@ -6687,8 +6678,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
>   	hba->dev_cmd.complete = &wait;
>   
>   	ufshcd_add_query_upiu_trace(hba, UFS_QUERY_SEND, lrbp->ucd_req_ptr);
> -	/* Make sure descriptors are ready before ringing the doorbell */
> -	wmb();
>   
>   	ufshcd_send_command(hba, tag);
>   	/*
> 


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
