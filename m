Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E70FC48BDF
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 05:52:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DA1B613E2
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 05:52:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbhFXFys (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Jun 2021 01:54:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:13025 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230490AbhFXFym (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Jun 2021 01:54:42 -0400
IronPort-SDR: xB/0foU3Fp3R8n37Ulc4FPZsf43wweObL3EJi/xvkyM0eCPqwAcFYZpP1/DtKRl/e+GylkG0BP
 G54MNVQ8adtA==
X-IronPort-AV: E=McAfee;i="6200,9189,10024"; a="204393799"
X-IronPort-AV: E=Sophos;i="5.83,295,1616482800"; 
   d="scan'208";a="204393799"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2021 22:52:06 -0700
IronPort-SDR: ui/P9D01LSr2z7kxpyRmG7ZclFxhQZDgisqApsmdsNwLeZt4FdNTDlW8uw45D6Z/cU8PTyTKS9
 7Mo2a5IUlVbw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,295,1616482800"; 
   d="scan'208";a="406531260"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.79]) ([10.237.72.79])
  by orsmga006.jf.intel.com with ESMTP; 23 Jun 2021 22:52:02 -0700
Subject: Re: [PATCH v4 06/10] scsi: ufs: Remove host_sem used in
 suspend/resume
To:     Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <1624433711-9339-1-git-send-email-cang@codeaurora.org>
 <1624433711-9339-8-git-send-email-cang@codeaurora.org>
 <ed59d61a-6951-2acd-4f89-40f8dc5015e1@intel.com>
 <9105f328ee6ce916a7f01027b0d28332@codeaurora.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <a87e5ca5-390f-8ca0-41bf-27cdc70e3316@intel.com>
Date:   Thu, 24 Jun 2021 08:52:24 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <9105f328ee6ce916a7f01027b0d28332@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 24/06/21 5:16 am, Can Guo wrote:
> On 2021-06-23 22:30, Adrian Hunter wrote:
>> On 23/06/21 10:35 am, Can Guo wrote:
>>> To protect system suspend/resume from being disturbed by error handling,
>>> instead of using host_sem, let error handler call lock_system_sleep() and
>>> unlock_system_sleep() which achieve the same purpose. Remove the host_sem
>>> used in suspend/resume paths to make the code more readable.
>>>
>>> Suggested-by: Bart Van Assche <bvanassche@acm.org>
>>> Signed-off-by: Can Guo <cang@codeaurora.org>
>>> ---
>>>  drivers/scsi/ufs/ufshcd.c | 12 +++++++-----
>>>  1 file changed, 7 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>>> index 3695dd2..a09e4a2 100644
>>> --- a/drivers/scsi/ufs/ufshcd.c
>>> +++ b/drivers/scsi/ufs/ufshcd.c
>>> @@ -5907,6 +5907,11 @@ static void ufshcd_clk_scaling_suspend(struct ufs_hba *hba, bool suspend)
>>>
>>>  static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
>>>  {
>>> +    /*
>>> +     * It is not safe to perform error handling while suspend or resume is
>>> +     * in progress. Hence the lock_system_sleep() call.
>>> +     */
>>> +    lock_system_sleep();
>>
>> It looks to me like the system takes this lock quite early, even before
>> freezing tasks, so if anything needs the error handler to run it will
>> deadlock.
> 
> Hi Adrian,
> 
> UFS/hba system suspend/resume does not invoke or call error handling in a
> synchronous way. So, whatever UFS errors (which schedules the error handler)
> happens during suspend/resume, error handler will just wait here till system
> suspend/resume release the lock. Hence no worries of deadlock here.

It looks to me like the state can change to UFSHCD_STATE_EH_SCHEDULED_FATAL
and since user processes are not frozen, nor file systems sync'ed, everything
is going to deadlock.
i.e.
I/O is blocked waiting on error handling
error handling is blocked waiting on lock_system_sleep()
suspend is blocked waiting on I/O

> 
> Thanks,
> 
> Can Guo.
> 
>>
>>>      ufshcd_rpm_get_sync(hba);
>>>      if (pm_runtime_status_suspended(&hba->sdev_ufs_device->sdev_gendev) ||
>>>          hba->is_wlu_sys_suspended) {
>>> @@ -5951,6 +5956,7 @@ static void ufshcd_err_handling_unprepare(struct ufs_hba *hba)
>>>          ufshcd_clk_scaling_suspend(hba, false);
>>>      ufshcd_clear_ua_wluns(hba);
>>>      ufshcd_rpm_put(hba);
>>> +    unlock_system_sleep();
>>>  }
>>>
>>>  static inline bool ufshcd_err_handling_should_stop(struct ufs_hba *hba)
>>> @@ -9053,16 +9059,13 @@ static int ufshcd_wl_suspend(struct device *dev)
>>>      ktime_t start = ktime_get();
>>>
>>>      hba = shost_priv(sdev->host);
>>> -    down(&hba->host_sem);
>>>
>>>      if (pm_runtime_suspended(dev))
>>>          goto out;
>>>
>>>      ret = __ufshcd_wl_suspend(hba, UFS_SYSTEM_PM);
>>> -    if (ret) {
>>> +    if (ret)
>>>          dev_err(&sdev->sdev_gendev, "%s failed: %d\n", __func__,  ret);
>>> -        up(&hba->host_sem);
>>> -    }
>>>
>>>  out:
>>>      if (!ret)
>>> @@ -9095,7 +9098,6 @@ static int ufshcd_wl_resume(struct device *dev)
>>>          hba->curr_dev_pwr_mode, hba->uic_link_state);
>>>      if (!ret)
>>>          hba->is_wlu_sys_suspended = false;
>>> -    up(&hba->host_sem);
>>>      return ret;
>>>  }
>>>  #endif
>>>

