Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0557ECAAA1
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Sep 2022 17:21:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbiISRVU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Sep 2022 13:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbiISRVS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Sep 2022 13:21:18 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BB2B3A15D
        for <linux-scsi@vger.kernel.org>; Mon, 19 Sep 2022 10:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663608076; x=1695144076;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=s6sEKqV23xWvnyNLIiN0O+KahKhdDRZ5WK1XqmQewwk=;
  b=WqnDH0gyxGYnuqg021oFS1KJluD/7U5Q0x99gJD2ndBk+0aV3+MYpwSc
   bPBP5jOeRHtKX4Z3v9piLBcXfjx0AvYZraiIFcCv2FoajaTNfrsPxuZZS
   mH2lPPPUK13lkNEFJRf49huCVC+IzPmVkuA9OX8mTtZQkCM79XTKH9kS6
   yNDo1ygJq90XFgGXbTsNQsIre1ylIhvogamODUEwX4P+mkLuEMLngecfK
   UOSV4h7PkEmyyKUxDyMVb9V9TUtqC+8BVDKJLvbZBth/hzgbOJWiCvv52
   jF+sdc6lyaxJwO+cEVjPKst5t3B01x8+6i9+WalfjXgy9v5Hibyszm8oO
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10475"; a="279193071"
X-IronPort-AV: E=Sophos;i="5.93,328,1654585200"; 
   d="scan'208";a="279193071"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2022 10:21:15 -0700
X-IronPort-AV: E=Sophos;i="5.93,328,1654585200"; 
   d="scan'208";a="947311638"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.58.240])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2022 10:21:13 -0700
Message-ID: <c98a4226-f1be-f84b-267c-5ce4e6c387d7@intel.com>
Date:   Mon, 19 Sep 2022 20:21:07 +0300
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
 <3712590b-20cb-7d27-3017-4567f1fcddc2@intel.com>
 <913f72ad-7f6f-9067-df36-f9507359c816@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <913f72ad-7f6f-9067-df36-f9507359c816@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 19/09/22 16:54, Bart Van Assche wrote:
> On 9/19/22 04:34, Adrian Hunter wrote:
>> Did you consider something like:
>>
>> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
>> index 7256e6c43ca6..dc83b38dfde9 100644
>> --- a/drivers/ufs/core/ufshcd.c
>> +++ b/drivers/ufs/core/ufshcd.c
>> @@ -7374,6 +7374,9 @@ static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd)
>>         hba = shost_priv(cmd->device->host);
>>   +    if (hba->pm_op_in_progress)
>> +        return FAST_IO_FAIL;
>> +
>>       spin_lock_irqsave(hba->host->host_lock, flags);
>>       hba->force_reset = true;
>>       ufshcd_schedule_eh_work(hba);
> 
> The above change could cause error handling to be skipped if an error happened that requires the link to be reset. That seems wrong to me.

Hopefully a PM op with an error that really needed a host reset
would show up as a UFS error that the error handler could fix
successfully.

Alternatively, the same change but after scheduling the error handler?

> 
>> The original commit for host_sem was aimed at sysfs (see commit below).
>> Did you consider how sysfs access is affected?
>>
>>    commit 9cd20d3f473619d8d482551d15d4cebfb3ce73c8
>>    Author: Can Guo <cang@codeaurora.org>
>>    Date:   Wed Jan 13 19:13:28 2021 -0800
>>
>>      scsi: ufs: Protect PM ops and err_handler from user access through sysfs
>>           User layer may access sysfs nodes when system PM ops or error handling is
>>      running. This can cause various problems. Rename eh_sem to host_sem and use
>>      it to protect PM ops and error handling from user layer intervention.
> 
> The sysfs and debugfs attribute callback methods already call pm_runtime_get_sync() and pm_runtime_put_sync() so how could the power state change while a sysfs or debugfs attribute callback method is in progress?

Without PM holding host_sem, maybe it would give a similar
deadlock to what was described:

ufs_sysfs_read_desc_param
down(&hba->host_sem); <------------------------------------
ufshcd_rpm_get_sync(hba);
	waits for blk_execute_rq()
	waits for ufshcd_eh_host_reset_handler()
	waits for ufshcd_err_handler()
	waits for down(&hba->host_sem); <------------------

> 
>>> The ufshcd_rpm_get_sync() call at the start of
>>> ufshcd_err_handling_prepare() may deadlock since calling scsi_execute()
>>> is required by the UFS runtime resume implementation. Fixing that
>>> deadlock falls outside the scope of this patch.
>>
>> Do you mean:
>>
>> static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
>> {
>>     ufshcd_rpm_get_sync(hba);
>>
>> because that is the host controller, not the UFS device, that is
>> being resumed.
> 
> Hmm ... I think that ufshcd_rpm_get_sync() affects the power state of the UFS device and not the power state of the UFS host controller. From ufshcd-priv.h:
> 
> static inline int ufshcd_rpm_get_sync(struct ufs_hba *hba)
> {
>     return pm_runtime_get_sync(&hba->ufs_device_wlun->sdev_gendev);
> }

Yes, I misread that, sorry.

I guess it goes unnoticed because it is very unlikely i.e. the UFS
device would need to be suspending but not yet have claimed host_sem.
There would not be any outstanding requests otherwise the suspend
would not have started, so chance of errors at that point is very low.

Maybe deadlock could be sidestepped by changing:

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 7256e6c43ca6..9cb04c6f8dc3 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9258,7 +9261,10 @@ static int ufshcd_wl_suspend(struct device *dev)
 	ktime_t start = ktime_get();
 
 	hba = shost_priv(sdev->host);
-	down(&hba->host_sem);
+	if (down_trylock(&hba->host_sem)) {
+		ret = -EBUSY;
+		goto out;
+	}
 
 	if (pm_runtime_suspended(dev))
 		goto out;

