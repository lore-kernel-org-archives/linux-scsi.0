Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B32A1C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Nov 2021 06:34:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbhKWGhR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Nov 2021 01:37:17 -0500
Received: from mga04.intel.com ([192.55.52.120]:2437 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229579AbhKWGhQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 Nov 2021 01:37:16 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10176"; a="233683844"
X-IronPort-AV: E=Sophos;i="5.87,257,1631602800"; 
   d="scan'208";a="233683844"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2021 22:34:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,257,1631602800"; 
   d="scan'208";a="456591620"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.76]) ([10.237.72.76])
  by orsmga003.jf.intel.com with ESMTP; 22 Nov 2021 22:34:05 -0800
Subject: Re: [PATCH V8 1/1] scsi: ufs: Let devices remain runtime suspended
 during system suspend
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Wei Li <liwei213@huawei.com>, linux-scsi@vger.kernel.org
References: <20211027130614.406985-1-adrian.hunter@intel.com>
 <20211027130614.406985-2-adrian.hunter@intel.com>
 <9fae5b29-72d2-046c-204b-b12629fa6e09@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <3f530afd-89c3-30d2-d44a-586e488f343c@intel.com>
Date:   Tue, 23 Nov 2021 08:34:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <9fae5b29-72d2-046c-204b-b12629fa6e09@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/11/2021 09:09, Adrian Hunter wrote:
> On 27/10/2021 16:06, Adrian Hunter wrote:
>> If the UFS Device WLUN is runtime suspended and is in the same power
>> mode, link state and b_rpm_dev_flush_capable (BKOP or WB buffer flush etc)
>> state, then it can remain runtime suspended instead of being runtime
>> resumed and then system suspended.
>>
>> The following patch has cleared the way for that to happen:
>>   scsi: core: pm: Only runtime resume if necessary
>>
>> So amend the logic accordingly.
>>
>> Note, the ufs-hisi driver uses different RPM and SPM, but it is made
>> explicit by a new parameter to suspend prepare.
>>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
> 
> Any more comments on this?

Seems like there are no objections, so can this be applied for 5.17 ?

> 
>> ---
>>  drivers/scsi/ufs/ufs-hisi.c |  8 ++++++-
>>  drivers/scsi/ufs/ufshcd.c   | 45 ++++++++++++++++++++++++++++++++-----
>>  drivers/scsi/ufs/ufshcd.h   | 11 +++++++++
>>  3 files changed, 58 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/scsi/ufs/ufs-hisi.c b/drivers/scsi/ufs/ufs-hisi.c
>> index 8c7e8d321746..ab1a7ebd89b1 100644
>> --- a/drivers/scsi/ufs/ufs-hisi.c
>> +++ b/drivers/scsi/ufs/ufs-hisi.c
>> @@ -396,6 +396,12 @@ static int ufs_hisi_pwr_change_notify(struct ufs_hba *hba,
>>  	return ret;
>>  }
>>  
>> +static int ufs_hisi_suspend_prepare(struct device *dev)
>> +{
>> +	/* RPM and SPM are different. Refer ufs_hisi_suspend() */
>> +	return __ufshcd_suspend_prepare(dev, false);
>> +}
>> +
>>  static int ufs_hisi_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op,
>>  	enum ufs_notify_change_status status)
>>  {
>> @@ -578,7 +584,7 @@ static int ufs_hisi_remove(struct platform_device *pdev)
>>  static const struct dev_pm_ops ufs_hisi_pm_ops = {
>>  	SET_SYSTEM_SLEEP_PM_OPS(ufshcd_system_suspend, ufshcd_system_resume)
>>  	SET_RUNTIME_PM_OPS(ufshcd_runtime_suspend, ufshcd_runtime_resume, NULL)
>> -	.prepare	 = ufshcd_suspend_prepare,
>> +	.prepare	 = ufs_hisi_suspend_prepare,
>>  	.complete	 = ufshcd_resume_complete,
>>  };
>>  
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index 04cb67995750..115ea16f5a22 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -9707,7 +9707,27 @@ void ufshcd_resume_complete(struct device *dev)
>>  }
>>  EXPORT_SYMBOL_GPL(ufshcd_resume_complete);
>>  
>> -int ufshcd_suspend_prepare(struct device *dev)
>> +static bool ufshcd_rpm_ok_for_spm(struct ufs_hba *hba)
>> +{
>> +	struct device *dev = &hba->sdev_ufs_device->sdev_gendev;
>> +	enum ufs_dev_pwr_mode dev_pwr_mode;
>> +	enum uic_link_state link_state;
>> +	unsigned long flags;
>> +	bool res;
>> +
>> +	spin_lock_irqsave(&dev->power.lock, flags);
>> +	dev_pwr_mode = ufs_get_pm_lvl_to_dev_pwr_mode(hba->spm_lvl);
>> +	link_state = ufs_get_pm_lvl_to_link_pwr_state(hba->spm_lvl);
>> +	res = pm_runtime_suspended(dev) &&
>> +	      hba->curr_dev_pwr_mode == dev_pwr_mode &&
>> +	      hba->uic_link_state == link_state &&
>> +	      !hba->dev_info.b_rpm_dev_flush_capable;
>> +	spin_unlock_irqrestore(&dev->power.lock, flags);
>> +
>> +	return res;
>> +}
>> +
>> +int __ufshcd_suspend_prepare(struct device *dev, bool rpm_ok_for_spm)
>>  {
>>  	struct ufs_hba *hba = dev_get_drvdata(dev);
>>  	int ret;
>> @@ -9719,15 +9739,30 @@ int ufshcd_suspend_prepare(struct device *dev)
>>  	 * Refer ufshcd_resume_complete()
>>  	 */
>>  	if (hba->sdev_ufs_device) {
>> -		ret = ufshcd_rpm_get_sync(hba);
>> -		if (ret < 0 && ret != -EACCES) {
>> -			ufshcd_rpm_put(hba);
>> -			return ret;
>> +		/* Prevent runtime suspend */
>> +		ufshcd_rpm_get_noresume(hba);
>> +		/*
>> +		 * Check if already runtime suspended in same state as system
>> +		 * suspend would be.
>> +		 */
>> +		if (!rpm_ok_for_spm || !ufshcd_rpm_ok_for_spm(hba)) {
>> +			/* RPM state is not ok for SPM, so runtime resume */
>> +			ret = ufshcd_rpm_resume(hba);
>> +			if (ret < 0 && ret != -EACCES) {
>> +				ufshcd_rpm_put(hba);
>> +				return ret;
>> +			}
>>  		}
>>  		hba->complete_put = true;
>>  	}
>>  	return 0;
>>  }
>> +EXPORT_SYMBOL_GPL(__ufshcd_suspend_prepare);
>> +
>> +int ufshcd_suspend_prepare(struct device *dev)
>> +{
>> +	return __ufshcd_suspend_prepare(dev, true);
>> +}
>>  EXPORT_SYMBOL_GPL(ufshcd_suspend_prepare);
>>  
>>  #ifdef CONFIG_PM_SLEEP
>> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
>> index 3f5dc6732fe1..b9492f300bd1 100644
>> --- a/drivers/scsi/ufs/ufshcd.h
>> +++ b/drivers/scsi/ufs/ufshcd.h
>> @@ -1199,6 +1199,7 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
>>  
>>  int ufshcd_wb_toggle(struct ufs_hba *hba, bool enable);
>>  int ufshcd_suspend_prepare(struct device *dev);
>> +int __ufshcd_suspend_prepare(struct device *dev, bool rpm_ok_for_spm);
>>  void ufshcd_resume_complete(struct device *dev);
>>  
>>  /* Wrapper functions for safely calling variant operations */
>> @@ -1408,6 +1409,16 @@ static inline int ufshcd_rpm_put_sync(struct ufs_hba *hba)
>>  	return pm_runtime_put_sync(&hba->sdev_ufs_device->sdev_gendev);
>>  }
>>  
>> +static inline void ufshcd_rpm_get_noresume(struct ufs_hba *hba)
>> +{
>> +	pm_runtime_get_noresume(&hba->sdev_ufs_device->sdev_gendev);
>> +}
>> +
>> +static inline int ufshcd_rpm_resume(struct ufs_hba *hba)
>> +{
>> +	return pm_runtime_resume(&hba->sdev_ufs_device->sdev_gendev);
>> +}
>> +
>>  static inline int ufshcd_rpm_put(struct ufs_hba *hba)
>>  {
>>  	return pm_runtime_put(&hba->sdev_ufs_device->sdev_gendev);
>>
> 

