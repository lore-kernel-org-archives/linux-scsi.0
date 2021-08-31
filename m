Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 469F9C432BE
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Aug 2021 10:04:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FF8C60FF2
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Aug 2021 10:04:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240876AbhHaKFF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 Aug 2021 06:05:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:18901 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229818AbhHaKFE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 31 Aug 2021 06:05:04 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10092"; a="240694617"
X-IronPort-AV: E=Sophos;i="5.84,366,1620716400"; 
   d="scan'208";a="240694617"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2021 03:04:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,366,1620716400"; 
   d="scan'208";a="531036905"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.174]) ([10.237.72.174])
  by FMSMGA003.fm.intel.com with ESMTP; 31 Aug 2021 03:04:06 -0700
Subject: Re: [PATCH v3 16/18] scsi: ufs: Synchronize SCSI and UFS error
 handling
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>
References: <20210722033439.26550-1-bvanassche@acm.org>
 <20210722033439.26550-17-bvanassche@acm.org>
 <88e0dc4c-34ff-6d87-fa9f-2fc924f50369@intel.com>
 <020bd6be-0944-8e25-c9fd-972cab5e6746@acm.org>
 <69fb9f57-54b6-072c-9f53-5da8b8e3202d@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <537451c3-ab13-1312-5530-b154d510c312@intel.com>
Date:   Tue, 31 Aug 2021 13:04:37 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <69fb9f57-54b6-072c-9f53-5da8b8e3202d@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 31/08/21 10:24 am, Adrian Hunter wrote:
> On 30/08/21 1:18 am, Bart Van Assche wrote:
>> On 8/28/21 02:47, Adrian Hunter wrote:
>>> There is a deadlock that seems to be related to this patch, because now
>>> requests are blocked while the error handler waits on the host_sem.
>>
>> Hi Adrian,
>>
>> Some but not all of the issues mentioned below have been introduced by patch 16/18. Anyway, thank you for having shared your concerns.
>>
>>> Example:
>>>
>>> ufshcd_err_handler() races with ufshcd_wl_suspend() for host_sem.
>>> ufshcd_wl_suspend() wins the race but now PM requests deadlock:
>>>
>>> because:
>>>   scsi_queue_rq() -> scsi_host_queue_ready() -> scsi_host_in_recovery() is FALSE
>>>
>>> because:
>>>   scsi_schedule_eh() has done:
>>>         scsi_host_set_state(shost, SHOST_RECOVERY) == 0 ||
>>>         scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY) == 0)
>>>
>>>
>>> Some questions for thought:
>>>
>>> Won't any holder of host_sem deadlock if it tries to do SCSI requests
>>> and the error handler is waiting on host_sem?
>>>
>>> Won't runtime resume deadlock if it is initiated by the error handler?
>>
>> My understanding is that host_sem is used for the following purposes:
>> - To prevent that sysfs attributes are read or written after shutdown
>>   has started (hba->shutting_down).
>> - To serialize sysfs attribute access, clock scaling, error handling,
>>   the ufshcd_probe_hba() call from ufshcd_async_scan() and hibernation.
>>
>> I propose to make the following changes:
>> - Instead of checking the value of hba->shutting_down from inside sysfs
>>   attribute callbacks, remove sysfs attributes before starting shutdown.
>>   That will remove the need to check hba->shutting_down from inside
>>   sysfs attribute callbacks.
>> - Leave out the host_sem down() and up() calls from ufshcd_wl_suspend()
>>   and ufshcd_wl_resume(). Serializing hibernation against e.g. sysfs
>>   attribute access is not the responsibility of a SCSI LLD - this is the
>>   responsibility of the power management core.
>> - Split host_sem. I don't see how else to address the potential deadlock
>>   between the error handler and runtime resume.
>>
>> Do you agree with the above?
> 
> Looking some more:
> 
> sysfs and debugfs use direct access, so there is probably not a problem
> there.

Except with runtime pm, but might be OK if ufshcd_rpm_get_sync() is moved
before down(&hba->host_sem).

> 
> bsg also uses direct access but doesn't appear to have synchronization
> so there is maybe a gap there.  That is an existing problem.
> 
> As an aside, the current synchronization for direct access doesn't make
> complete sense because the lock (host_sem) remains held across retries
> (e.g. ufshcd_query_descriptor_retry) preventing error handling between
> retries.  That is an existing problem.
> 
> ufshcd_wl_suspend() and ufshcd_wl_shutdown() could wait for error handling
> and then disable it somehow. ufshcd_wl_resume() would have to enable it.
> 
> That leaves runtime PM.  Since the error handler can block runtime resume,
> it cannot wait for runtime resume, it must exit.  Another complication is
> that the PM workqueue (pm_wq) gets frozen early during system suspend, so
> requesting an asynchronous runtime resume won't necessarily make any
> progress.
> 
> How does splitting the host_sem address the potential deadlock
> between the error handler and runtime resume?
> 

