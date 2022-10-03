Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EA6AC433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 06:11:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbiJCGLD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 02:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiJCGLC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 02:11:02 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F83E26571
        for <linux-scsi@vger.kernel.org>; Sun,  2 Oct 2022 23:11:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664777461; x=1696313461;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=FDnIvMQmNeXchmGI/8nlC7zTd2PmdPa3vDQQRJsVtYY=;
  b=KX+lVX5TCu8liRnmUo/n2kAozcDZYv/Msc2QoZK8LBEpdDU1nY5NQt58
   vwCuKYLxz9rIwepq7HUW8Zpbn+vfUj8GQiRKoDn5ILq2mHT8lt94UMM9S
   7LBGteNbDOs4laW/NNtR9EA1IMQKFZBp6TEActfz0ymgwa7QAtBy8qWP4
   C55gcBVPa62E2F7aRUIL/1kGixR0Emox81nJri/FSkHIz5aaCgqg/AXf7
   Gy7RK8qBklHEH8bmScE+qf5WPWqqtW17Jb3XQVxgV6aicxDoH1xypHu0s
   InxJtc+RHyRBorp9cnbN0AURVTw1su5SssSG539YSWZ2Jgm89H9EEefAB
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10488"; a="366601961"
X-IronPort-AV: E=Sophos;i="5.93,364,1654585200"; 
   d="scan'208";a="366601961"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2022 23:11:00 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10488"; a="618621755"
X-IronPort-AV: E=Sophos;i="5.93,364,1654585200"; 
   d="scan'208";a="618621755"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.60.77])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2022 23:10:57 -0700
Message-ID: <af7da97d-43f5-fb3d-fbc8-fecba69ab870@intel.com>
Date:   Mon, 3 Oct 2022 09:10:55 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH v3 7/8] scsi: ufs: Track system suspend / resume activity
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        jongmin jeong <jjmin.jeong@samsung.com>,
        Eric Biggers <ebiggers@google.com>
References: <20220929220021.247097-1-bvanassche@acm.org>
 <20220929220021.247097-8-bvanassche@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20220929220021.247097-8-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 30/09/22 01:00, Bart Van Assche wrote:
> Add a new boolean variable that tracks whether the system is suspending,
> suspended or resuming. This information will be used in a later patch to
> fix a deadlock between the SCSI error handler and the suspend code.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
>  drivers/ufs/core/ufshcd.c | 2 ++
>  include/ufs/ufshcd.h      | 5 ++++-
>  2 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index e8c0504e9e83..5507d93a4bba 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -9253,6 +9253,7 @@ static int ufshcd_wl_suspend(struct device *dev)
>  
>  	hba = shost_priv(sdev->host);
>  	down(&hba->host_sem);
> +	hba->system_suspending = true;
>  
>  	if (pm_runtime_suspended(dev))
>  		goto out;
> @@ -9294,6 +9295,7 @@ static int ufshcd_wl_resume(struct device *dev)
>  		hba->curr_dev_pwr_mode, hba->uic_link_state);
>  	if (!ret)
>  		hba->is_sys_suspended = false;
> +	hba->system_suspending = false;
>  	up(&hba->host_sem);
>  	return ret;
>  }
> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> index 9f28349ebcff..96538eb3a6c0 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -802,7 +802,9 @@ struct ufs_hba_monitor {
>   * @caps: bitmask with information about UFS controller capabilities
>   * @devfreq: frequency scaling information owned by the devfreq core
>   * @clk_scaling: frequency scaling information owned by the UFS driver
> - * @is_sys_suspended: whether or not the entire system has been suspended
> + * @system_suspending: system suspend has been started and system resume has
> + *	not yet finished.
> + * @is_sys_suspended: UFS device has been suspended because of system suspend
>   * @urgent_bkops_lvl: keeps track of urgent bkops level for device
>   * @is_urgent_bkops_lvl_checked: keeps track if the urgent bkops level for
>   *  device is known or not.
> @@ -943,6 +945,7 @@ struct ufs_hba {
>  
>  	struct devfreq *devfreq;
>  	struct ufs_clk_scaling clk_scaling;
> +	bool system_suspending;
>  	bool is_sys_suspended;
>  
>  	enum bkops_status urgent_bkops_lvl;

