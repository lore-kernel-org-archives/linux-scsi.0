Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 374D5C77B73
	for <linux-scsi@archiver.kernel.org>; Wed, 24 May 2023 12:22:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbjEXMV5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 May 2023 08:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbjEXMVz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 May 2023 08:21:55 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DFE19E
        for <linux-scsi@vger.kernel.org>; Wed, 24 May 2023 05:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684930911; x=1716466911;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Yg7LoHsoxSYqGwZs5dFbTJ1UlUFwVvqTgUDJ3Cop0c8=;
  b=V1K0fUfdVkg2xEZMfHMf3pZr09JkR3GfSMTFH4TtU0RZb2++vGk45pNp
   dS97j/mJf2JpzSq0oKsrP8yrXmJB7/ieBjt5xxXNjR2vCSEaN9LSCkbPh
   cY2d5zgtxhU28//JZTCxJrni7VCVEwaTI4oLbwpO6rtmUOqu/3o+p0lbb
   xyJgXQTxhHLr403IQry5/mmzpF8PxQ8rVyHDuM+t3fs+k5iUDwj65NYAu
   VEFPBTXe9qRiL/QnRqIVj8mVZ9i5YXBfVnAWd62OJn5pEVc+zhwVp+iV4
   q5dkb46CvI9eTaZsBVYsEjaLc73g4ZppBVibpGp5rC7hKbb/7hq0YS7Pc
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="351056439"
X-IronPort-AV: E=Sophos;i="6.00,189,1681196400"; 
   d="scan'208";a="351056439"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 05:21:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="878638690"
X-IronPort-AV: E=Sophos;i="6.00,189,1681196400"; 
   d="scan'208";a="878638690"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.251.223.197])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 05:21:49 -0700
Message-ID: <c0126a93-c34f-10ef-b050-2e34be420b16@intel.com>
Date:   Wed, 24 May 2023 15:21:44 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.11.0
Subject: Re: [PATCH v2 2/4] scsi: ufs: Fix handling of lrbp->cmd
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
References: <20230517223157.1068210-1-bvanassche@acm.org>
 <20230517223157.1068210-3-bvanassche@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20230517223157.1068210-3-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 18/05/23 01:31, Bart Van Assche wrote:
> ufshcd_queuecommand() may be called two times in a row for a SCSI
> command before it is completed. Hence make the following changes:
> - In the functions that submit a command, do not check the old value of
>   lrbp->cmd nor clear lrbp->cmd in error paths.
> - In ufshcd_release_scsi_cmd(), do not clear lrbp->cmd.
> 
> See also scsi_send_eh_cmnd().
> 
> This patch prevents that the following appears if a command times out:
> 
> WARNING: at drivers/ufs/core/ufshcd.c:2965 ufshcd_queuecommand+0x6f8/0x9a8
> Call trace:
>  ufshcd_queuecommand+0x6f8/0x9a8
>  scsi_send_eh_cmnd+0x2c0/0x960
>  scsi_eh_test_devices+0x100/0x314
>  scsi_eh_ready_devs+0xd90/0x114c
>  scsi_error_handler+0x2b4/0xb70
>  kthread+0x16c/0x1e0
> 
> Fixes: 5a0b0cb9bee7 ("[SCSI] ufs: Add support for sending NOP OUT UPIU")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

A couple of minor comments, nevertheless:

Acked-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
>  drivers/ufs/core/ufshcd.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 37337d411466..68d9e24fac98 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -2928,7 +2928,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>  		(hba->clk_gating.state != CLKS_ON));
>  
>  	lrbp = &hba->lrb[tag];
> -	WARN_ON(lrbp->cmd);

AFAICT eh uses the same struct i.e. lrbp->cmd => lrbp->cmd == cmd in that case

>  	lrbp->cmd = cmd;
>  	lrbp->task_tag = tag;
>  	lrbp->lun = ufshcd_scsi_to_upiu_lun(cmd->device->lun);
> @@ -2944,7 +2943,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>  
>  	err = ufshcd_map_sg(hba, lrbp);
>  	if (err) {
> -		lrbp->cmd = NULL;
>  		ufshcd_release(hba);
>  		goto out;
>  	}
> @@ -5405,7 +5403,6 @@ static void ufshcd_release_scsi_cmd(struct ufs_hba *hba,
>  	struct scsi_cmnd *cmd = lrbp->cmd;
>  
>  	scsi_dma_unmap(cmd);
> -	lrbp->cmd = NULL;	/* Mark the command as completed. */
>  	ufshcd_release(hba);
>  	ufshcd_clk_scaling_update_busy(hba);
>  }
> @@ -7020,7 +7017,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
>  	down_read(&hba->clk_scaling_lock);
>  
>  	lrbp = &hba->lrb[tag];
> -	WARN_ON(lrbp->cmd);
>  	lrbp->cmd = NULL;
>  	lrbp->task_tag = tag;
>  	lrbp->lun = 0;
> @@ -7192,7 +7188,6 @@ int ufshcd_advanced_rpmb_req_handler(struct ufs_hba *hba, struct utp_upiu_req *r
>  	down_read(&hba->clk_scaling_lock);
>  
>  	lrbp = &hba->lrb[tag];
> -	WARN_ON(lrbp->cmd);
>  	lrbp->cmd = NULL;
>  	lrbp->task_tag = tag;
>  	lrbp->lun = UFS_UPIU_RPMB_WLUN;
> 

Currently the reserved tag is not used for SCSI cmds but
there is also a WARN_ON(lrbp->cmd) in ufshcd_exec_dev_cmd()

