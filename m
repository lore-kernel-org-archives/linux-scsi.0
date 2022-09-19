Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1FF5ECAAD3
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Sep 2022 11:34:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbiISLee (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Sep 2022 07:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbiISLec (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Sep 2022 07:34:32 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13D72DBA
        for <linux-scsi@vger.kernel.org>; Mon, 19 Sep 2022 04:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663587271; x=1695123271;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OwB/ufwxxBwv8R/iy4bZQj152RJr9NfaA35EtpBf6sk=;
  b=KJ2kCPyFsj7qNrJBdlNtAjndsWu3CEsI7vxjxDkGZTyRDUgHW7ECYNU+
   hxUgy6patmSpOR9cXyfwB3tLlPbPLENHl4ZIULVF/sSIZV2Xl5saU5iuk
   Tl+Kwg5tserQHlnGHteZsb41xLL20uEvllBOGvtvDE3+UrTkaa51CqbeZ
   U44pkyloGFnPyHtZInur2/9rN6ZtDG8UgYz9z1O5n5U4TeQ/cxsOLcNLS
   FK5V2GtkmB4uKh4y9bkWymLVpR5wAe2b6KDWlCWNdxi1exNQ6RDCF9v7E
   ASmlRD8qkJBhMrFAmlqT8zyoPoHvpkt56maYELjaQIN7e4mYn3IcBM7bO
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10474"; a="282402584"
X-IronPort-AV: E=Sophos;i="5.93,327,1654585200"; 
   d="scan'208";a="282402584"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2022 04:34:12 -0700
X-IronPort-AV: E=Sophos;i="5.93,327,1654585200"; 
   d="scan'208";a="760832473"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.58.240])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2022 04:34:09 -0700
Message-ID: <3712590b-20cb-7d27-3017-4567f1fcddc2@intel.com>
Date:   Mon, 19 Sep 2022 14:34:03 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH] scsi: ufs: Fix deadlocks between power management and
 error handler
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        dh0421.hwang@samsung.com, Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
References: <20220916184220.867535-1-bvanassche@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20220916184220.867535-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 16/09/22 21:42, Bart Van Assche wrote:
> The following deadlocks have been observed on multiple test setups:
> 
> * ufshcd_wl_suspend() is waiting for blk_execute_rq() to complete while it
>   holds host_sem.
> * ufshcd_eh_host_reset_handler() invokes ufshcd_err_handler() and the
>   latter function tries to obtain host_sem.
> This is a deadlock because blk_execute_rq() can't execute SCSI commands
> while the host is in the SHOST_RECOVERY state and because the error
> handler cannot make progress either.

Hi Bart

Did you consider something like:

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 7256e6c43ca6..dc83b38dfde9 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7374,6 +7374,9 @@ static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd)
 
 	hba = shost_priv(cmd->device->host);
 
+	if (hba->pm_op_in_progress)
+		return FAST_IO_FAIL;
+
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	hba->force_reset = true;
 	ufshcd_schedule_eh_work(hba);

> 
> * ufshcd_wl_runtime_resume() is waiting for blk_execute_rq() to finish
>   while it holds host_sem.
> * ufshcd_eh_host_reset_handler() invokes ufshcd_err_handler() and the
>   latter function calls pm_runtime_resume().
> This is a deadlock because of the same reason as the previous scenario.
> 
> Fix both deadlocks by not obtaining host_sem from the power management
> code paths. Removing the host_sem locking from the power management code
> is safe because the ufshcd_err_handler() is already serialized against
> SCSI command execution.

The original commit for host_sem was aimed at sysfs (see commit below).
Did you consider how sysfs access is affected?

  commit 9cd20d3f473619d8d482551d15d4cebfb3ce73c8
  Author: Can Guo <cang@codeaurora.org>
  Date:   Wed Jan 13 19:13:28 2021 -0800

    scsi: ufs: Protect PM ops and err_handler from user access through sysfs
    
    User layer may access sysfs nodes when system PM ops or error handling is
    running. This can cause various problems. Rename eh_sem to host_sem and use
    it to protect PM ops and error handling from user layer intervention.

> 
> The ufshcd_rpm_get_sync() call at the start of
> ufshcd_err_handling_prepare() may deadlock since calling scsi_execute()
> is required by the UFS runtime resume implementation. Fixing that
> deadlock falls outside the scope of this patch.

Do you mean:

static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
{
	ufshcd_rpm_get_sync(hba);

because that is the host controller, not the UFS device, that is
being resumed.

> 
> Cc: dh0421.hwang@samsung.com
> Cc: Asutosh Das <asutoshd@codeaurora.org>
> Fixes: b294ff3e3449 ("scsi: ufs: core: Enable power management for wlun")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/ufs/core/ufshcd.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 7c15cbc737b4..cd3c2aa981c6 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -9254,16 +9254,13 @@ static int ufshcd_wl_suspend(struct device *dev)
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
> @@ -9296,7 +9293,6 @@ static int ufshcd_wl_resume(struct device *dev)
>  		hba->curr_dev_pwr_mode, hba->uic_link_state);
>  	if (!ret)
>  		hba->is_sys_suspended = false;
> -	up(&hba->host_sem);
>  	return ret;
>  }
>  #endif

