Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CC8BC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Sep 2021 11:06:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30D2C60F25
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Sep 2021 11:06:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235574AbhIGLHF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Sep 2021 07:07:05 -0400
Received: from mga14.intel.com ([192.55.52.115]:49996 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233864AbhIGLHF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Sep 2021 07:07:05 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10099"; a="219854467"
X-IronPort-AV: E=Sophos;i="5.85,274,1624345200"; 
   d="scan'208";a="219854467"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2021 04:05:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,274,1624345200"; 
   d="scan'208";a="692486581"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.174]) ([10.237.72.174])
  by fmsmga006.fm.intel.com with ESMTP; 07 Sep 2021 04:05:41 -0700
Subject: Re: [PATCH V2 1/3] scsi: ufs: Fix error handler clear ua deadlock
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Wei Li <liwei213@huawei.com>, linux-scsi@vger.kernel.org
References: <20210903095609.16201-1-adrian.hunter@intel.com>
 <20210903095609.16201-2-adrian.hunter@intel.com>
 <56b1a7b3-90b7-e208-2486-20421d32d2e7@acm.org>
 <58c32af5-7a96-16bd-1f59-e77ea97a50f4@intel.com>
 <bd3692d9-f3da-9a78-60ee-09e10dd6c77f@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <3e9c49ed-6fb1-a635-96ec-f881e5a75c09@intel.com>
Date:   Tue, 7 Sep 2021 14:06:09 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <bd3692d9-f3da-9a78-60ee-09e10dd6c77f@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/09/21 3:37 am, Bart Van Assche wrote:
> On 9/5/21 02:51, Adrian Hunter wrote:
>> On 3/09/21 11:29 pm, Bart Van Assche wrote:
>>> On 9/3/21 2:56 AM, Adrian Hunter wrote:
>>>> There is no guarantee to be able to enter the queue if requests
>>>> are blocked. That is because freezing the queue will block entry
>>>> to the queue, but freezing also waits for outstanding requests
>>>> which can make no progress while the queue is blocked.
>>>>
>>>> That situation can happen when the error handler issues requests
>>>> to clear unit attention condition. The deadlock is very unlikely,
>>>> so the error handler can be expected to clear ua at some point
>>>> anyway, so the simple solution is not to wait to enter the
>>>> queue.
>>>>
>>>> Additionally, note that the RPMB queue might be not be entered
>>>> because it is runtime suspended, but in that case ua will be
>>>> cleared at RPMB runtime resume.
>>>
>>> The only ufshcd_clear_ua_wluns() call that I am aware of and that
>>> is related to error handling is the call in
>>> ufshcd_err_handling_unprepare(). That call happens after
>>> ufshcd_scsi_unblock_requests() has been called so how can it be
>>> involved in a deadlock?
>>
>> That is a very good question.  I went back to reproduce the deadlock
>> again, and it is because, in addition, ufshcd_state is
>> UFSHCD_STATE_EH_SCHEDULED_FATAL.  So I have updated the commit
>> message accordingly in V3.
>>
>>> Additionally, the ufshcd_scsi_block_requests() and
>>> ufshcd_scsi_unblock_requests() calls can be removed from
>>> ufshcd_err_handling_prepare() and ufshcd_err_handling_unprepare().
>>> These calls are no longer necessary since patch "scsi: ufs:
>>> Synchronize SCSI and UFS error handling".
>>
>> As has been noted, that commit introduces several new deadlocks - and
>> will presumably cause the deadlock this patches addresses, even if
>> ufshcd_state is not UFSHCD_STATE_EH_SCHEDULED_FATAL.
>>
>> It is perhaps more appropriate to revert "scsi: ufs: Synchronize SCSI
>> and UFS error handling" for v5.15 and try to get things sorted out
>> for v5.16.  What do you think?
> 
> Reverting that patch would be a step backwards because it would make it again possible that the SCSI EH and UFS EH run concurrently and obstruct each other.

I wouldn't say it is a step backwards, just a step forwards the driver is not ready for.

For me, the change causes deadlocks so it is a regression.

I have never seen SCSI EH cause a problem, but AFAICT it is not needed because the UFS driver's error handler is always scheduled when needed.

As a temporary workaround until the driver is ready for SCSI EH, interference between SCSI EH and UFS EH could presumably be avoided by setting eh_strategy_handler to an empty function.

> 
> Does the above mean that "if (hba->pm_op_in_progress)" should be removed from the following code in ufshcd_queuecommand()?
> 
>     case UFSHCD_STATE_EH_SCHEDULED_FATAL:
>         if (hba->pm_op_in_progress) {
>             hba->force_reset = true;
>             set_host_byte(cmd, DID_BAD_TARGET);
>             cmd->scsi_done(cmd);
>             goto out;
>         }

It seems to me that removing "if (hba->pm_op_in_progress)" would cause errors for requests that had not in fact even been issued.
