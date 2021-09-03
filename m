Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A33FC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Sep 2021 09:54:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AF4860F9C
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Sep 2021 09:54:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348966AbhICJz6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Sep 2021 05:55:58 -0400
Received: from mga06.intel.com ([134.134.136.31]:18953 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348959AbhICJz5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 3 Sep 2021 05:55:57 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10095"; a="280395643"
X-IronPort-AV: E=Sophos;i="5.85,265,1624345200"; 
   d="scan'208";a="280395643"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2021 02:54:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,265,1624345200"; 
   d="scan'208";a="500274503"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.174]) ([10.237.72.174])
  by fmsmga008.fm.intel.com with ESMTP; 03 Sep 2021 02:54:54 -0700
Subject: Re: [PATCH 3/3] scsi: ufs: Let devices remain runtime suspended
 during system suspend
To:     "Asutosh Das (asd)" <asutoshd@codeaurora.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org
References: <d5f5552d-257a-62ee-f0a3-55c00959e63b@intel.com>
 <20210902101818.4132-1-adrian.hunter@intel.com>
 <20210902101818.4132-4-adrian.hunter@intel.com>
 <0c162d36-6fb5-19e8-dce2-82156e83db4d@codeaurora.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <0aef517c-d134-c0d7-8569-b45a9098336f@intel.com>
Date:   Fri, 3 Sep 2021 12:55:24 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <0c162d36-6fb5-19e8-dce2-82156e83db4d@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/09/21 8:07 pm, Asutosh Das (asd) wrote:
> On 9/2/2021 3:18 AM, Adrian Hunter wrote:
>> If the UFS Device WLUN is runtime suspended and is in the same power
>> mode, link state and b_rpm_dev_flush_capable (BKOP or WB buffer flush etc)
>> state, then it can remain runtime suspended instead of being runtime
>> resumed and then system suspended.
>>
>> The following patches have cleared the way for that to happen:
>>    scsi: ufs: Fix runtime PM dependencies getting broken
>>    scsi: ufs: Fix error handler clear ua deadlock
>>
>> So amend the logic accordingly.
>>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> ---
>>   drivers/scsi/ufs/ufshcd.c | 45 ++++++++++++++++++++++++++++-----------
>>   drivers/scsi/ufs/ufshcd.h | 11 +++++++++-
>>   2 files changed, 43 insertions(+), 13 deletions(-)
>>
> Hi Adrian,
> Thanks for the change.
> 
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index 57ed4b93b949..8e799e47e095 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -9722,13 +9722,29 @@ void ufshcd_resume_complete(struct device *dev)
>>           ufshcd_rpm_put(hba);
>>           hba->complete_put = false;
>>       }
>> -    if (hba->rpmb_complete_put) {
>> -        ufshcd_rpmb_rpm_put(hba);
>> -        hba->rpmb_complete_put = false;
>> -    }
>>   }
>>   EXPORT_SYMBOL_GPL(ufshcd_resume_complete);
>>   +static bool ufshcd_rpm_ok_for_spm(struct ufs_hba *hba)
>> +{
>> +    struct device *dev = &hba->sdev_ufs_device->sdev_gendev;
>> +    enum ufs_dev_pwr_mode dev_pwr_mode;
>> +    enum uic_link_state link_state;
>> +    unsigned long flags;
>> +    bool res;
>> +
> In the current ufshcd_suspend(), there's a ufshcd_vops_suspend().
> That's invoked for different pm_ops independent of the rpm_lvl and spm_lvl.
> I'm not sure if any vendor driver does different things for diff pm_op.
> Perhaps something to check.
> 

Good point.  The logic was that way before "scsi: ufs: core: Enable power
management for wlu" which was first in v5.14, so drivers should expect the
behaviour of this patch.  Checking shows only ufs-hisi does something
different but it sets different rpm_lvl and spm_lvl so wouldn't see any
change.  However I am sending a V2 patch that makes it explicit.
