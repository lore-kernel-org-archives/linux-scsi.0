Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4FCBC07E95
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 19:03:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD2E561CC2
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 19:03:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbhGGTGi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jul 2021 15:06:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:10328 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230004AbhGGTGh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 7 Jul 2021 15:06:37 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10037"; a="206354197"
X-IronPort-AV: E=Sophos;i="5.84,221,1620716400"; 
   d="scan'208";a="206354197"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 12:03:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,221,1620716400"; 
   d="scan'208";a="628119658"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.79]) ([10.237.72.79])
  by orsmga005.jf.intel.com with ESMTP; 07 Jul 2021 12:03:52 -0700
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
 <a87e5ca5-390f-8ca0-41bf-27cdc70e3316@intel.com>
 <1b351766a6e40d0df90b3adec964eb33@codeaurora.org>
 <a654d2ef-b333-1c56-42c6-3d69e9f44bd0@intel.com>
 <3970b015e444c1f1714c7e7bd4c44651@codeaurora.org>
 <f1c997f3-66e4-3f1f-08f5-83449b65c397@intel.com>
 <7c6e2baa3578eb30f2d4bd1696e800eb@codeaurora.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <bd464b9f-b6d5-cd52-7377-c64c0cf933ff@intel.com>
Date:   Wed, 7 Jul 2021 22:04:06 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <7c6e2baa3578eb30f2d4bd1696e800eb@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 28/06/21 10:26 am, Can Guo wrote:
> On 2021-06-24 18:04, Adrian Hunter wrote:
>> On 24/06/21 9:31 am, Can Guo wrote:
>>> On 2021-06-24 14:23, Adrian Hunter wrote:
>>>> On 24/06/21 9:12 am, Can Guo wrote:
>>>>> On 2021-06-24 13:52, Adrian Hunter wrote:
>>>>>> On 24/06/21 5:16 am, Can Guo wrote:
>>>>>>> On 2021-06-23 22:30, Adrian Hunter wrote:
>>>>>>>> On 23/06/21 10:35 am, Can Guo wrote:
>>>>>>>>> To protect system suspend/resume from being disturbed by error handling,
>>>>>>>>> instead of using host_sem, let error handler call lock_system_sleep() and
>>>>>>>>> unlock_system_sleep() which achieve the same purpose. Remove the host_sem
>>>>>>>>> used in suspend/resume paths to make the code more readable.
>>>>>>>>>
>>>>>>>>> Suggested-by: Bart Van Assche <bvanassche@acm.org>
>>>>>>>>> Signed-off-by: Can Guo <cang@codeaurora.org>
>>>>>>>>> ---
>>>>>>>>>  drivers/scsi/ufs/ufshcd.c | 12 +++++++-----
>>>>>>>>>  1 file changed, 7 insertions(+), 5 deletions(-)
>>>>>>>>>
>>>>>>>>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>>>>>>>>> index 3695dd2..a09e4a2 100644
>>>>>>>>> --- a/drivers/scsi/ufs/ufshcd.c
>>>>>>>>> +++ b/drivers/scsi/ufs/ufshcd.c
>>>>>>>>> @@ -5907,6 +5907,11 @@ static void ufshcd_clk_scaling_suspend(struct ufs_hba *hba, bool suspend)
>>>>>>>>>
>>>>>>>>>  static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
>>>>>>>>>  {
>>>>>>>>> +    /*
>>>>>>>>> +     * It is not safe to perform error handling while suspend or resume is
>>>>>>>>> +     * in progress. Hence the lock_system_sleep() call.
>>>>>>>>> +     */
>>>>>>>>> +    lock_system_sleep();
>>>>>>>>
>>>>>>>> It looks to me like the system takes this lock quite early, even before
>>>>>>>> freezing tasks, so if anything needs the error handler to run it will
>>>>>>>> deadlock.
>>>>>>>
>>>>>>> Hi Adrian,
>>>>>>>
>>>>>>> UFS/hba system suspend/resume does not invoke or call error handling in a
>>>>>>> synchronous way. So, whatever UFS errors (which schedules the error handler)
>>>>>>> happens during suspend/resume, error handler will just wait here till system
>>>>>>> suspend/resume release the lock. Hence no worries of deadlock here.
>>>>>>
>>>>>> It looks to me like the state can change to UFSHCD_STATE_EH_SCHEDULED_FATAL
>>>>>> and since user processes are not frozen, nor file systems sync'ed, everything
>>>>>> is going to deadlock.
>>>>>> i.e.
>>>>>> I/O is blocked waiting on error handling
>>>>>> error handling is blocked waiting on lock_system_sleep()
>>>>>> suspend is blocked waiting on I/O
>>>>>>
>>>>>
>>>>> Hi Adrian,
>>>>>
>>>>> First of all, enter_state(suspend_state_t state) uses mutex_trylock(&system_transition_mutex).
>>>>
>>>> Yes, in the case I am outlining it gets the mutex.
>>>>
>>>>> Second, even that happens, in ufshcd_queuecommand(), below logic will break the cycle, by
>>>>> fast failing the PM request (below codes are from the code tip with this whole series applied).
>>>>
>>>> It won't get that far because the suspend will be waiting to sync filesystems.
>>>> Filesystems will be waiting on I/O.
>>>> I/O will be waiting on the error handler.
>>>> The error handler will be waiting on system_transition_mutex.
>>>> But system_transition_mutex is already held by PM core.
>>>
>>> Hi Adrian,
>>>
>>> You are right.... I missed the action of syncing filesystems...
>>>
>>> Using back host_sem in suspend_prepare()/resume_complete() won't have this
>>> problem of deadlock, right?
>>
>> I am not sure, but what was problem that the V3 patch was fixing?
>> Can you give an example?
> 
> V3 was moving host_sem from wl_system_suspend/resume() to
> ufshcd_suspend_prepare()/ufshcd_resume_complete(). It is to
> make sure error handling does not run concurrenly with system
> PM, since error handling is recovering/clearing runtime PM
> errors of all the scsi devices under hba (in patch #8). Having the
> error handling doing so (in patch 8) is because runtime PM framework
> may save the runtime errors of the supplier to one or more consumers (
> unlike the children - parent relationship), for example if wlu resume
> fails, sda and/or other scsi devices may save the resume error, then
> they will be left runtime suspended permanently.

Sorry for the slow reply.  I was going to do some more investigation but
never found time.

I was wondering if it would be simpler to do the error recovery for
wl_system_suspend/resume() before exiting wl_system_suspend/resume().

Then it would be possible to do something along the lines:
	- prevent runtime suspend while the error handler is outstanding
	- at suspend, block queuing of the error handler work and flush it
	- at resume, allow queuing of the error handler work
