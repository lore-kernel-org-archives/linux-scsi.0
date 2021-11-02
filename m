Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCD31C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Nov 2021 06:11:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98D5460F70
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Nov 2021 06:11:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbhKBGNp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Nov 2021 02:13:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:21223 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229497AbhKBGNo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 2 Nov 2021 02:13:44 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10155"; a="231047322"
X-IronPort-AV: E=Sophos;i="5.87,201,1631602800"; 
   d="scan'208";a="231047322"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2021 23:11:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,201,1631602800"; 
   d="scan'208";a="488961222"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.76]) ([10.237.72.76])
  by orsmga007.jf.intel.com with ESMTP; 01 Nov 2021 23:11:06 -0700
Subject: Re: [PATCH RFC] scsi: ufs-core: Do not use clk_scaling_lock in
 ufshcd_queuecommand()
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Daejun Park <daejun7.park@samsung.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Luca Porzio <lporzio@micron.com>, linux-scsi@vger.kernel.org
References: <20211029133751.420015-1-adrian.hunter@intel.com>
 <24e21ff3-c992-c71e-70e3-e0c3926fbcda@acm.org>
 <c2d76154-b2ef-2e66-0a56-cd22ac8c652f@intel.com>
 <d3d70c8e-f260-ca2d-f4c1-2c9dd1a08c5d@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <3f4ef5e8-38e8-2e90-6da4-abc67aac9e4d@intel.com>
Date:   Tue, 2 Nov 2021 08:11:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <d3d70c8e-f260-ca2d-f4c1-2c9dd1a08c5d@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 01/11/2021 20:35, Bart Van Assche wrote:
> On 11/1/21 2:16 AM, Adrian Hunter wrote:
>> On 29/10/2021 19:31, Bart Van Assche wrote:
>>> @@ -5985,9 +5920,12 @@ static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
>>>           ufshcd_clk_scaling_allow(hba, false);
>>>       }
>>>       ufshcd_scsi_block_requests(hba);
>>> -    /* Drain ufshcd_queuecommand() */
>>> -    down_write(&hba->clk_scaling_lock);
>>> -    up_write(&hba->clk_scaling_lock);
>>> +    /*
>>> +     * Drain ufshcd_queuecommand(). Since ufshcd_queuecommand() does not
>>> +     * sleep, calling synchronize_rcu() is sufficient to wait for ongoing
>>> +     * ufshcd_queuecommand calls.
>>> +     */
>>> +    synchronize_rcu();
>>
>> This depends upon block layer internals, so it must be called via a block
>> layer function i.e. the block layer must guarantee this will always work. > Also, scsi_unjam_host() does not look like it uses RCU when issuing
>> requests.
> 
> I will add an rcu_read_lock() / rcu_read_unlock() pair in ufshcd_queuecommand().
> I think that addresses both points mentioned above.
> 
>>>       cancel_work_sync(&hba->eeh_work);
>>>   }
>>>
>>> @@ -6212,11 +6150,8 @@ static void ufshcd_err_handler(struct work_struct *work)
>>>        */
>>>       if (needs_restore) {
>>>           spin_unlock_irqrestore(hba->host->host_lock, flags);
>>> -        /*
>>> -         * Hold the scaling lock just in case dev cmds
>>> -         * are sent via bsg and/or sysfs.
>>> -         */
>>> -        down_write(&hba->clk_scaling_lock);
>>> +        /* Block TMF submission, e.g. through BSG or sysfs. */
>>
>> What about dev cmds?
> 
> ufshcd_exec_dev_cmd() and ufshcd_issue_devman_upiu_cmd() both allocate a
> request from hba->cmd_queue. blk_get_request() indirectly increments
> q->q_usage_counter and blk_mq_freeze_queue() waits until that counter drops
> to zero. Hence, hba->cmd_queue freezing only finishes after all pending dev
> cmds have finished. Additionally, if hba->cmd_queue is frozen,
> blk_get_request() blocks until it is unfrozen. So dev cmds are covered.

The queue is not usually frozen when the error handler runs.

> 
>> Also, there is the outstanding question of synchronization for the call to
>> ufshcd_reset_and_restore() further down.
> 
> Please clarify this comment further. I assume that you are referring to the
> ufshcd_reset_and_restore() call guarded by if (needs_reset)? It is not clear
> to me what the outstanding question is?

What is to stop it racing with BSG, sysfs, debugfs, abort, reset etc?

> 
> Thanks,
> 
> Bart.

