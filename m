Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AD89C7EE2C
	for <linux-scsi@archiver.kernel.org>; Wed, 24 May 2023 12:45:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233349AbjEXMp1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 May 2023 08:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233112AbjEXMpZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 May 2023 08:45:25 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F17E9E
        for <linux-scsi@vger.kernel.org>; Wed, 24 May 2023 05:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684932324; x=1716468324;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=evYaWHocr2lxhv7uTbXHFYP/n9rHG7nciN+pqXmtizM=;
  b=fpqk11NnTENI0dDLNn+635D8b7ymHxiFpGgDzDeDgGx184hoB6wh1u1D
   +yVhU82rMudJ1oe+xcal1ETQ5LwfiLfpB8/hSh+B8Uay3EFKq5/KsE0uC
   kaTsJpdkgEguVpVby+IY5XRF6ITCEFfL8oGRLoTOHyYd2EoYIcjFhUR+q
   ERn8rm+NDmckOd2hZkGOj2RK3wJfUwh8t4nV2u6XcNmLyKI7+FPmeU5cH
   85cTB5FPSIM3q2+nfVRCgLBPGg8TtuX7RXJsxI/DBjiu/cIxpfocs/UuI
   yGuhC6u4quiBOeFFG1M0e5TMxy7KhQcf9HI87JkgqOZwBeE93W9+JfDc9
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="333909511"
X-IronPort-AV: E=Sophos;i="6.00,189,1681196400"; 
   d="scan'208";a="333909511"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 05:45:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="681883152"
X-IronPort-AV: E=Sophos;i="6.00,189,1681196400"; 
   d="scan'208";a="681883152"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.251.223.197])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 05:45:21 -0700
Message-ID: <f923cf03-5bf4-efc8-b967-cbb4366d819a@intel.com>
Date:   Wed, 24 May 2023 15:45:16 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.11.0
Subject: Re: [PATCH v2 3/4] scsi: ufs: Move ufshcd_wl_shutdown()
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
References: <20230517223157.1068210-1-bvanassche@acm.org>
 <20230517223157.1068210-4-bvanassche@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20230517223157.1068210-4-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 18/05/23 01:31, Bart Van Assche wrote:
> Move the definition of ufshcd_wl_shutdown() to make the next patch in
> this series easier to review.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
>  drivers/ufs/core/ufshcd.c | 44 +++++++++++++++++++--------------------
>  1 file changed, 22 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 68d9e24fac98..0f426d46d91e 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -9746,28 +9746,6 @@ static int ufshcd_wl_resume(struct device *dev)
>  }
>  #endif
>  
> -static void ufshcd_wl_shutdown(struct device *dev)
> -{
> -	struct scsi_device *sdev = to_scsi_device(dev);
> -	struct ufs_hba *hba;
> -
> -	hba = shost_priv(sdev->host);
> -
> -	down(&hba->host_sem);
> -	hba->shutting_down = true;
> -	up(&hba->host_sem);
> -
> -	/* Turn on everything while shutting down */
> -	ufshcd_rpm_get_sync(hba);
> -	scsi_device_quiesce(sdev);
> -	shost_for_each_device(sdev, hba->host) {
> -		if (sdev == hba->ufs_device_wlun)
> -			continue;
> -		scsi_device_quiesce(sdev);
> -	}
> -	__ufshcd_wl_suspend(hba, UFS_SHUTDOWN_PM);
> -}
> -
>  /**
>   * ufshcd_suspend - helper function for suspend operations
>   * @hba: per adapter instance
> @@ -9952,6 +9930,28 @@ int ufshcd_runtime_resume(struct device *dev)
>  EXPORT_SYMBOL(ufshcd_runtime_resume);
>  #endif /* CONFIG_PM */
>  
> +static void ufshcd_wl_shutdown(struct device *dev)
> +{
> +	struct scsi_device *sdev = to_scsi_device(dev);
> +	struct ufs_hba *hba;
> +
> +	hba = shost_priv(sdev->host);
> +
> +	down(&hba->host_sem);
> +	hba->shutting_down = true;
> +	up(&hba->host_sem);
> +
> +	/* Turn on everything while shutting down */
> +	ufshcd_rpm_get_sync(hba);
> +	scsi_device_quiesce(sdev);
> +	shost_for_each_device(sdev, hba->host) {
> +		if (sdev == hba->ufs_device_wlun)
> +			continue;
> +		scsi_device_quiesce(sdev);
> +	}
> +	__ufshcd_wl_suspend(hba, UFS_SHUTDOWN_PM);
> +}
> +
>  /**
>   * ufshcd_shutdown - shutdown routine
>   * @hba: per adapter instance
> 

