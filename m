Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93408C77B7A
	for <linux-scsi@archiver.kernel.org>; Thu, 25 May 2023 04:47:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235760AbjEYEri (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 May 2023 00:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235377AbjEYErh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 May 2023 00:47:37 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0817D83
        for <linux-scsi@vger.kernel.org>; Wed, 24 May 2023 21:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684990056; x=1716526056;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=yQZjabhIb2prJHatTQmljoK7f/k84t1Gae8znBVBXNI=;
  b=YhCPebSxmpSKFrFItjDApZXEhcVcHCfJne18t3lE5TzmVHG1ZLYQiqnA
   f4vbYsl9hecS9gBCrIqukMKbgYMYvAWw1bS4Vk+V2384uJplfU+qyYnnj
   xH1mPcGEfV+ArhAp+vK5a9fUN98Q5+d4mH0cFlMaIlRDx0P4vM1BTKFOH
   hLXni3TKWVqhfZ0rtOS3E5gn9U3+eX7QbcTaIyPaWw1zoflOK+zVZqUt5
   I4+b/KKiNA9dzPOWH0wtdA7PL8M9HvaUIWYsIyI8asYO97tExjKGcMTYu
   uyOlrDZE9Hg1LmgO7S6efuSR21jfdNr6uHH216DyPcNrb8GnUlt7zGhpE
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="417244802"
X-IronPort-AV: E=Sophos;i="6.00,190,1681196400"; 
   d="scan'208";a="417244802"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 21:47:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="737567928"
X-IronPort-AV: E=Sophos;i="6.00,190,1681196400"; 
   d="scan'208";a="737567928"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.251.208.63])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 21:47:30 -0700
Message-ID: <c748989a-37cf-abe9-da6e-f72de13d1f55@intel.com>
Date:   Thu, 25 May 2023 07:47:26 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.11.0
Subject: Re: [PATCH v3 2/4] scsi: ufs: Fix handling of lrbp->cmd
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Bean Huo <beanhuo@micron.com>,
        Ziqi Chen <quic_ziqichen@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Adrien Thierry <athierry@redhat.com>,
        Santosh Y <santoshsy@gmail.com>,
        James Bottomley <JBottomley@Parallels.com>
References: <20230524203659.1394307-1-bvanassche@acm.org>
 <20230524203659.1394307-3-bvanassche@acm.org>
Content-Language: en-US
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20230524203659.1394307-3-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 24/05/23 23:36, Bart Van Assche wrote:
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

Acked-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
>  drivers/ufs/core/ufshcd.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index dc4b047db27e..3a7598120d23 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -2931,7 +2931,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>  		(hba->clk_gating.state != CLKS_ON));
>  
>  	lrbp = &hba->lrb[tag];
> -	WARN_ON(lrbp->cmd);
>  	lrbp->cmd = cmd;
>  	lrbp->task_tag = tag;
>  	lrbp->lun = ufshcd_scsi_to_upiu_lun(cmd->device->lun);
> @@ -2947,7 +2946,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>  
>  	err = ufshcd_map_sg(hba, lrbp);
>  	if (err) {
> -		lrbp->cmd = NULL;
>  		ufshcd_release(hba);
>  		goto out;
>  	}
> @@ -3166,7 +3164,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
>  	down_read(&hba->clk_scaling_lock);
>  
>  	lrbp = &hba->lrb[tag];
> -	WARN_ON(lrbp->cmd);
> +	lrbp->cmd = NULL;
>  	err = ufshcd_compose_dev_cmd(hba, lrbp, cmd_type, tag);
>  	if (unlikely(err))
>  		goto out;
> @@ -5408,7 +5406,6 @@ static void ufshcd_release_scsi_cmd(struct ufs_hba *hba,
>  	struct scsi_cmnd *cmd = lrbp->cmd;
>  
>  	scsi_dma_unmap(cmd);
> -	lrbp->cmd = NULL;	/* Mark the command as completed. */
>  	ufshcd_release(hba);
>  	ufshcd_clk_scaling_update_busy(hba);
>  }
> @@ -7023,7 +7020,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
>  	down_read(&hba->clk_scaling_lock);
>  
>  	lrbp = &hba->lrb[tag];
> -	WARN_ON(lrbp->cmd);
>  	lrbp->cmd = NULL;
>  	lrbp->task_tag = tag;
>  	lrbp->lun = 0;
> @@ -7195,7 +7191,6 @@ int ufshcd_advanced_rpmb_req_handler(struct ufs_hba *hba, struct utp_upiu_req *r
>  	down_read(&hba->clk_scaling_lock);
>  
>  	lrbp = &hba->lrb[tag];
> -	WARN_ON(lrbp->cmd);
>  	lrbp->cmd = NULL;
>  	lrbp->task_tag = tag;
>  	lrbp->lun = UFS_UPIU_RPMB_WLUN;

