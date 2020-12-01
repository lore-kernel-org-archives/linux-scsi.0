Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD405C63777
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 02:43:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37B6D20857
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 02:43:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="iPopZylG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727288AbgLACnF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Nov 2020 21:43:05 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:45198 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727126AbgLACnF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Nov 2020 21:43:05 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606790563; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=bmnMEgeHu2+d1Q3HLkgVB3Z0SXVqSHWP2jBAsjKGVhc=; b=iPopZylGACWHLH9NfSMGcvV3jwW9QoOKiOuZdr/KgvXZ4Vmr91bAVslXAWGV8BHJpd2dR8i8
 f58ruiz7aXe4Er3iRmzJkCtAeszu3c5KoHBcf08GjYDXyfGbNHAS/+y+I0dAGVDmho2arikd
 575oIUR+RrgJLjypy3GLo3n5dds=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 5fc5ad830f9adc18c787f314 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 01 Dec 2020 02:42:11
 GMT
Sender: asutoshd=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6E320C43461; Tue,  1 Dec 2020 02:42:10 +0000 (UTC)
Received: from [192.168.8.168] (cpe-70-95-149-85.san.res.rr.com [70.95.149.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 241F9C43460;
        Tue,  1 Dec 2020 02:42:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 241F9C43460
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [PATCH v3 2/3] scsi: ufs: Fix a racing problem between
 ufshcd_abort and eh_work
To:     Can Guo <cang@codeaurora.org>, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
References: <1605596660-2987-1-git-send-email-cang@codeaurora.org>
 <1605596660-2987-3-git-send-email-cang@codeaurora.org>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <0a3a545b-55f8-e358-7d62-00cde64d40aa@codeaurora.org>
Date:   Mon, 30 Nov 2020 18:42:07 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <1605596660-2987-3-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/16/2020 11:04 PM, Can Guo wrote:
> In current task abort routine, if task abort happens to the device W-LU,
> the code directly jumps to ufshcd_eh_host_reset_handler() to perform a
> full reset and restore then returns FAIL or SUCCESS. Commands sent to the
> device W-LU are most likely the SSU cmds sent during UFS PM operations. If
> such SSU cmd enters task abort routine, when ufshcd_eh_host_reset_handler()
> flushes eh_work, there will be racing because err_handler is serialized
> with any PM operations.
> 
> Since the main idea of aborting one cmd to the device W-LU is to perform
> a full reset and restore, in order to resolve the racing problem, we merely
> clean up the lrb taken by this cmd, queue the eh_work and abort the cmd.
> Since the cmd has been aborted, the PM operation which sends the cmd simply
> errors out, thus err_handler will not be blocked by ongoing PM operations
> and err_handler can also recover PM error if any, which comes as another
> benefit of this change.
> 
> Because such cmd is aborted even before it is actually cleared from HW, set
> the lrb->in_use flag to prevent subsequent cmds, including SCSI cmds and
> dev cmds, from taking the lrb released by this cmd. Flag lrb->in_use shall
> evetually be cleared in __ufshcd_transfer_req_compl() invoked by the full
> reset and restore from err_handler.
> 
> Signed-off-by: Can Guo <cang@codeaurora.org>
> ---

Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>

>   drivers/scsi/ufs/ufshcd.c | 55 ++++++++++++++++++++++++++++++++++++-----------
>   drivers/scsi/ufs/ufshcd.h |  2 ++
>   2 files changed, 45 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 7e764e8..cd7394e 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -2539,6 +2539,14 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>   		(hba->clk_gating.state != CLKS_ON));
>   
>   	lrbp = &hba->lrb[tag];
> +	if (unlikely(lrbp->in_use)) {
> +		if (hba->pm_op_in_progress)
> +			set_host_byte(cmd, DID_BAD_TARGET);
> +		else
> +			err = SCSI_MLQUEUE_HOST_BUSY;
> +		ufshcd_release(hba);
> +		goto out;
> +	}
>   
>   	WARN_ON(lrbp->cmd);
>   	lrbp->cmd = cmd;
> @@ -2781,6 +2789,11 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
>   
>   	init_completion(&wait);
>   	lrbp = &hba->lrb[tag];
> +	if (unlikely(lrbp->in_use)) {
> +		err = -EBUSY;
> +		goto out;
> +	}
> +
>   	WARN_ON(lrbp->cmd);
>   	err = ufshcd_compose_dev_cmd(hba, lrbp, cmd_type, tag);
>   	if (unlikely(err))
> @@ -2797,6 +2810,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
>   
>   	err = ufshcd_wait_for_dev_cmd(hba, lrbp, timeout);
>   
> +out:
>   	ufshcd_add_query_upiu_trace(hba, tag,
>   			err ? "query_complete_err" : "query_complete");
>   
> @@ -4932,6 +4946,7 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
>   
>   	for_each_set_bit(index, &completed_reqs, hba->nutrs) {
>   		lrbp = &hba->lrb[index];
> +		lrbp->in_use = false;
>   		lrbp->compl_time_stamp = ktime_get();
>   		cmd = lrbp->cmd;
>   		if (cmd) {
> @@ -6374,8 +6389,12 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
>   
>   	init_completion(&wait);
>   	lrbp = &hba->lrb[tag];
> -	WARN_ON(lrbp->cmd);
> +	if (unlikely(lrbp->in_use)) {
> +		err = -EBUSY;
> +		goto out;
> +	}
>   
> +	WARN_ON(lrbp->cmd);
>   	lrbp->cmd = NULL;
>   	lrbp->sense_bufflen = 0;
>   	lrbp->sense_buffer = NULL;
> @@ -6447,6 +6466,7 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
>   		}
>   	}
>   
> +out:
>   	blk_put_request(req);
>   out_unlock:
>   	up_read(&hba->clk_scaling_lock);
> @@ -6696,16 +6716,6 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>   		BUG();
>   	}
>   
> -	/*
> -	 * Task abort to the device W-LUN is illegal. When this command
> -	 * will fail, due to spec violation, scsi err handling next step
> -	 * will be to send LU reset which, again, is a spec violation.
> -	 * To avoid these unnecessary/illegal step we skip to the last error
> -	 * handling stage: reset and restore.
> -	 */
> -	if (lrbp->lun == UFS_UPIU_UFS_DEVICE_WLUN)
> -		return ufshcd_eh_host_reset_handler(cmd);
> -
>   	ufshcd_hold(hba, false);
>   	reg = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
>   	/* If command is already aborted/completed, return SUCCESS */
> @@ -6726,7 +6736,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>   	 * to reduce repeated printouts. For other aborted requests only print
>   	 * basic details.
>   	 */
> -	scsi_print_command(hba->lrb[tag].cmd);
> +	scsi_print_command(cmd);
>   	if (!hba->req_abort_count) {
>   		ufshcd_update_reg_hist(&hba->ufs_stats.task_abort, 0);
>   		ufshcd_print_host_regs(hba);
> @@ -6745,6 +6755,27 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>   		goto cleanup;
>   	}
>   
> +	/*
> +	 * Task abort to the device W-LUN is illegal. When this command
> +	 * will fail, due to spec violation, scsi err handling next step
> +	 * will be to send LU reset which, again, is a spec violation.
> +	 * To avoid these unnecessary/illegal steps, first we clean up
> +	 * the lrb taken by this cmd and mark the lrb as in_use, then
> +	 * queue the eh_work and bail.
> +	 */
> +	if (lrbp->lun == UFS_UPIU_UFS_DEVICE_WLUN) {
> +		spin_lock_irqsave(host->host_lock, flags);
> +		if (lrbp->cmd) {
> +			__ufshcd_transfer_req_compl(hba, (1UL << tag));
> +			__set_bit(tag, &hba->outstanding_reqs);
> +			lrbp->in_use = true;
> +			hba->force_reset = true;
> +			ufshcd_schedule_eh_work(hba);
> +		}
> +		spin_unlock_irqrestore(host->host_lock, flags);
> +		goto out;
> +	}
> +
>   	/* Skip task abort in case previous aborts failed and report failure */
>   	if (lrbp->req_abort_skip)
>   		err = -EIO;
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 1e680bf..66e5338 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -163,6 +163,7 @@ struct ufs_pm_lvl_states {
>    * @crypto_key_slot: the key slot to use for inline crypto (-1 if none)
>    * @data_unit_num: the data unit number for the first block for inline crypto
>    * @req_abort_skip: skip request abort task flag
> + * @in_use: indicates that this lrb is still in use
>    */
>   struct ufshcd_lrb {
>   	struct utp_transfer_req_desc *utr_descriptor_ptr;
> @@ -192,6 +193,7 @@ struct ufshcd_lrb {
>   #endif
>   
>   	bool req_abort_skip;
> +	bool in_use;
>   };
>   
>   /**
> 


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
