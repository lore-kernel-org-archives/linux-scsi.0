Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B3AAC48BD1
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 13:34:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E07D3610C7
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 13:34:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbhFJNgx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Jun 2021 09:36:53 -0400
Received: from mga18.intel.com ([134.134.136.126]:31511 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230435AbhFJNgw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Jun 2021 09:36:52 -0400
IronPort-SDR: l5TLdD7cGsxIEf4kLEPWMTEPLz31J8RpgiIdSxHcDL43fWCwf06ErFlsxrNvlFGUd7ZDkXQzFN
 g0+LI8sIzJBA==
X-IronPort-AV: E=McAfee;i="6200,9189,10011"; a="192612418"
X-IronPort-AV: E=Sophos;i="5.83,263,1616482800"; 
   d="scan'208";a="192612418"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2021 06:32:50 -0700
IronPort-SDR: 7nUpw3RLVnjyioJh0UKy5Niob54pNKBtNcsAgqMkXa/lbEBX7AR284S94bh+XMP7GFHpgFf1mX
 VIZtpjgBO+Zw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,263,1616482800"; 
   d="scan'208";a="402861024"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.79]) ([10.237.72.79])
  by orsmga003.jf.intel.com with ESMTP; 10 Jun 2021 06:32:00 -0700
Subject: Re: [PATCH v3 7/9] scsi: ufs: Let host_sem cover the entire system
 suspend/resume
To:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        ziqichen@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Satya Tangirala <satyat@google.com>,
        Bart Van Assche <bvanassche@acm.org>,
        open list <linux-kernel@vger.kernel.org>
References: <1623300218-9454-1-git-send-email-cang@codeaurora.org>
 <1623300218-9454-8-git-send-email-cang@codeaurora.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <6d31becb-98f8-2302-8ffa-657e6cadd8ec@intel.com>
Date:   Thu, 10 Jun 2021 16:32:29 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1623300218-9454-8-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/06/21 7:43 am, Can Guo wrote:
> UFS error handling now is doing more than just re-probing, but also sending
> scsi cmds, e.g., for clearing UACs, and recovering runtime PM error, which
> may change runtime status of scsi devices. To protect system suspend/resume
> from being disturbed by error handling, move the host_sem from wl pm ops
> to ufshcd_suspend_prepare() and ufshcd_resume_complete().

Have you checked whether error handling might actually be needed after
ufshcd_suspend_prepare()?

Wouldn't this complexity go away if we just did recovery
directly in __ufshcd_wl_suspend() and  __ufshcd_wl_resume()?

> 
> Signed-off-by: Can Guo <cang@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 8 +++-----
>  drivers/scsi/ufs/ufshcd.h | 2 +-
>  2 files changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index c418a19..861942b 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -9060,16 +9060,13 @@ static int ufshcd_wl_suspend(struct device *dev)
>  	ktime_t start = ktime_get();
>  
>  	hba = shost_priv(sdev->host);
> -	down(&hba->host_sem);
>  
>  	if (pm_runtime_suspended(dev))
>  		goto out;
>  
>  	ret = __ufshcd_wl_suspend(hba, UFS_SYSTEM_PM);
> -	if (ret) {
> +	if (ret)
>  		dev_err(&sdev->sdev_gendev, "%s failed: %d\n", __func__,  ret);
> -		up(&hba->host_sem);
> -	}
>  
>  out:
>  	if (!ret)
> @@ -9102,7 +9099,6 @@ static int ufshcd_wl_resume(struct device *dev)
>  		hba->curr_dev_pwr_mode, hba->uic_link_state);
>  	if (!ret)
>  		hba->is_wl_sys_suspended = false;
> -	up(&hba->host_sem);
>  	return ret;
>  }
>  #endif
> @@ -9665,6 +9661,7 @@ void ufshcd_resume_complete(struct device *dev)
>  		ufshcd_rpmb_rpm_put(hba);
>  		hba->rpmb_complete_put = false;
>  	}
> +	up(&hba->host_sem);
>  }
>  EXPORT_SYMBOL_GPL(ufshcd_resume_complete);
>  
> @@ -9691,6 +9688,7 @@ int ufshcd_suspend_prepare(struct device *dev)
>  		ufshcd_rpmb_rpm_get_sync(hba);
>  		hba->rpmb_complete_put = true;
>  	}
> +	down(&hba->host_sem);
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(ufshcd_suspend_prepare);
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index eaebb4e..47da47c 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -693,7 +693,7 @@ struct ufs_hba_monitor {
>   * @ee_ctrl_mask: Exception event control mask
>   * @is_powered: flag to check if HBA is powered
>   * @shutting_down: flag to check if shutdown has been invoked
> - * @host_sem: semaphore used to serialize concurrent contexts
> + * @host_sem: semaphore used to avoid concurrency of contexts
>   * @eh_wq: Workqueue that eh_work works on
>   * @eh_work: Worker to handle UFS errors that require s/w attention
>   * @eeh_work: Worker to handle exception events
> 

