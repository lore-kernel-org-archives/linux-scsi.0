Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D8F2C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 06:35:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 198A561248
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 06:35:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237328AbhJFGhp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Oct 2021 02:37:45 -0400
Received: from mga05.intel.com ([192.55.52.43]:30189 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237395AbhJFGhm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 6 Oct 2021 02:37:42 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10128"; a="312133916"
X-IronPort-AV: E=Sophos;i="5.85,350,1624345200"; 
   d="scan'208";a="312133916"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2021 23:35:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,350,1624345200"; 
   d="scan'208";a="589652804"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.76]) ([10.237.72.76])
  by orsmga004.jf.intel.com with ESMTP; 05 Oct 2021 23:35:45 -0700
Subject: Re: [PATCH V7 1/2] scsi: ufs: Fix runtime PM dependencies getting
 broken
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Wei Li <liwei213@huawei.com>, linux-scsi@vger.kernel.org
References: <20211005134445.234671-1-adrian.hunter@intel.com>
 <20211005134445.234671-2-adrian.hunter@intel.com>
 <dcb1c627-1431-8437-7a02-e5d74a3f3b70@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <9ad82ef9-30ea-1f01-db65-931d6ec14693@intel.com>
Date:   Wed, 6 Oct 2021 09:35:44 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <dcb1c627-1431-8437-7a02-e5d74a3f3b70@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 05/10/2021 21:52, Bart Van Assche wrote:
> On 10/5/21 6:44 AM, Adrian Hunter wrote:
>> UFS SCSI devices make use of device links to establish PM dependencies.
>> However, SCSI PM will force devices' runtime PM state to be active during
>> system resume. That can break runtime PM dependencies for UFS devices.
>> Fix by adding a flag 'preserve_rpm' to let UFS SCSI devices opt-out of
>> the unwanted behaviour.
>>
>> Fixes: b294ff3e34490f ("scsi: ufs: core: Enable power management for wlun")
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> ---
>>   drivers/scsi/scsi_pm.c     | 16 +++++++++++-----
>>   drivers/scsi/ufs/ufshcd.c  |  1 +
>>   include/scsi/scsi_device.h |  1 +
>>   3 files changed, 13 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
>> index 3717eea37ecb..0557c1ad304d 100644
>> --- a/drivers/scsi/scsi_pm.c
>> +++ b/drivers/scsi/scsi_pm.c
>> @@ -73,13 +73,22 @@ static int scsi_dev_type_resume(struct device *dev,
>>           int (*cb)(struct device *, const struct dev_pm_ops *))
>>   {
>>       const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
>> +    struct scsi_device *sdev = NULL;
>> +    bool preserve_rpm = false;
>>       int err = 0;
>>   +    if (scsi_is_sdev_device(dev)) {
>> +        sdev = to_scsi_device(dev);
>> +        preserve_rpm = sdev->preserve_rpm;
>> +        if (preserve_rpm && pm_runtime_suspended(dev))
>> +            return 0;
>> +    }
>> +
>>       err = cb(dev, pm);
>>       scsi_device_resume(to_scsi_device(dev));
>>       dev_dbg(dev, "scsi resume: %d\n", err);
>>   -    if (err == 0) {
>> +    if (err == 0 && !preserve_rpm) {
>>           pm_runtime_disable(dev);
>>           err = pm_runtime_set_active(dev);
>>           pm_runtime_enable(dev);
>> @@ -91,11 +100,8 @@ static int scsi_dev_type_resume(struct device *dev,
>>            *
>>            * The resume hook will correct runtime PM status of the disk.
>>            */
>> -        if (!err && scsi_is_sdev_device(dev)) {
>> -            struct scsi_device *sdev = to_scsi_device(dev);
>> -
>> +        if (!err && sdev)
>>               blk_set_runtime_active(sdev->request_queue);
>> -        }
>>       }
>>         return err;
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index d91a405fd181..b70f566f7f8a 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -5016,6 +5016,7 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
>>           pm_runtime_get_noresume(&sdev->sdev_gendev);
>>       else if (ufshcd_is_rpm_autosuspend_allowed(hba))
>>           sdev->rpm_autosuspend = 1;
>> +    sdev->preserve_rpm = 1;
>>         ufshcd_crypto_setup_rq_keyslot_manager(hba, q);
>>   diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
>> index 09a17f6e93a7..47eb30a6b7b2 100644
>> --- a/include/scsi/scsi_device.h
>> +++ b/include/scsi/scsi_device.h
>> @@ -197,6 +197,7 @@ struct scsi_device {
>>       unsigned no_read_disc_info:1;    /* Avoid READ_DISC_INFO cmds */
>>       unsigned no_read_capacity_16:1; /* Avoid READ_CAPACITY_16 cmds */
>>       unsigned try_rc_10_first:1;    /* Try READ_CAPACACITY_10 first */
>> +    unsigned preserve_rpm:1;    /* Preserve runtime PM */
>>       unsigned security_supported:1;    /* Supports Security Protocols */
>>       unsigned is_visible:1;    /* is the device visible in sysfs */
>>       unsigned wce_default_on:1;    /* Cache is ON by default */
> 
> So a new flag is added in struct scsi_device and that flag is only used by
> the UFS driver? I'm less than enthusiast about this patch. I think that the
> SCSI core needs to be modified such that system suspend and resume is
> separated from runtime suspend and resume.

That is a tidy-up, whereas this patch is a fix needed also in stable
kernels.

> The following code:
> 
>     if (err == 0) {
>         pm_runtime_disable(dev);
>         err = pm_runtime_set_active(dev);
>         pm_runtime_enable(dev);
>         [ ... ]
>     }
> 
> has been introduced in scsi_dev_type_resume() by commit 3c31b52f96f7
> ("scsi: async sd resume"). I'm in favor of removing that code.

Presumably that code is necessary.  Trying to remove it really seems a
separate issue.
