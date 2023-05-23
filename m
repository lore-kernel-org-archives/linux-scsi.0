Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8FFDC7EE23
	for <linux-scsi@archiver.kernel.org>; Tue, 23 May 2023 19:19:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbjEWTTR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 May 2023 15:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjEWTTQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2023 15:19:16 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C31119
        for <linux-scsi@vger.kernel.org>; Tue, 23 May 2023 12:19:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684869555; x=1716405555;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=yM9TBg6uQFkbHqVCyvPVdO6hAsDVrCf91Vn0SRYPfqI=;
  b=j92Qc3h3KcfQaFBl/FQTdL2U6Zi1LPQ34QqZFyHurHZ9ivzMgbQFSW2m
   wFmVlub29jkylHc941SupxzROaOYEuN7+8C0RcjmEoYKsLBwu3/hpzeks
   DjvloYecvhMJBQpCHEBZ7YF5fSvExZr5KWB/Y6FD4+hEYewf9Upd+NhYW
   10HH3j7qmxmzkL730WoMGoVxS1mCpqipK+LidD1KA70hQgBFZSWHWk5MG
   mf2527Pbnc5V788Gh4DNh2imNja+RDqd9DCogz0MTXMNiLl5SkxeP7nBa
   eajjty/XVN22LtkDZ+XFcFLseb+lArY/Bi2OPcrQElhs2FGs74efr6vIP
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="416797182"
X-IronPort-AV: E=Sophos;i="6.00,187,1681196400"; 
   d="scan'208";a="416797182"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2023 12:19:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="878323840"
X-IronPort-AV: E=Sophos;i="6.00,187,1681196400"; 
   d="scan'208";a="878323840"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.249.39.37])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2023 12:19:13 -0700
Message-ID: <cac55dea-ec77-2802-f975-89a1cb1c734f@intel.com>
Date:   Tue, 23 May 2023 22:19:07 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.11.0
Subject: Re: [PATCH v2 3/4] scsi: ufs: Enable the BLK_MQ_F_BLOCKING flag
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20230517222359.1066918-1-bvanassche@acm.org>
 <20230517222359.1066918-4-bvanassche@acm.org>
 <957fb6d6-83db-6230-d81c-646e12ed7bf1@intel.com>
 <343be0eb-0650-cc5e-3154-ffe30f92c17d@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <343be0eb-0650-cc5e-3154-ffe30f92c17d@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 23/05/23 20:10, Bart Van Assche wrote:
> On 5/23/23 09:39, Adrian Hunter wrote:
>> On 18/05/23 01:23, Bart Van Assche wrote:
>>> Prepare for adding code in ufshcd_queuecommand() that may sleep.
>>>
>>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>>> ---
>>>   drivers/ufs/core/ufshcd.c | 1 +
>>>   1 file changed, 1 insertion(+)
>>>
>>> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
>>> index 7ee150d67d49..993034ac1696 100644
>>> --- a/drivers/ufs/core/ufshcd.c
>>> +++ b/drivers/ufs/core/ufshcd.c
>>> @@ -8756,6 +8756,7 @@ static const struct scsi_host_template ufshcd_driver_template = {
>>>       .max_host_blocked    = 1,
>>>       .track_queue_depth    = 1,
>>>       .skip_settle_delay    = 1,
>>> +    .queuecommand_may_block = true,
>>
>> Shouldn't this only be for controllers that support
>> clock gating?
> 
> Hi Adrian,
> 
> The overhead of BLK_MQ_F_BLOCKING is small relative to the time required to
> queue a UFS command so I think enabling BLK_MQ_F_BLOCKING for all UFS host
> controllers is fine.

Doesn't it also force the queue to be run asynchronously always?

But in any case, it doesn't seem like something to force on drivers
just because it would take a bit more coding to make it optional.


>                      BLK_MQ_F_BLOCKING causes the block layer to use SRCU
> instead of RCU. The cost of the sleepable RCU primitives is dominated by
> the memory barrier (smp_mb()) in the srcu_read_lock() and srcu_read_unlock()
> calls. From kernel/rcu/srcutree.c:
> 
> int __srcu_read_lock(struct srcu_struct *ssp)
> {
>     int idx;
> 
>     idx = READ_ONCE(ssp->srcu_idx) & 0x1;
>     this_cpu_inc(ssp->sda->srcu_lock_count[idx].counter);
>     smp_mb(); /* B */  /* Avoid leaking the critical section. */
>     return idx;
> }
> EXPORT_SYMBOL_GPL(__srcu_read_lock);
> 
> void __srcu_read_unlock(struct srcu_struct *ssp, int idx)
> {
>     smp_mb(); /* C */  /* Avoid leaking the critical section. */
>     this_cpu_inc(ssp->sda->srcu_unlock_count[idx].counter);
> }
> EXPORT_SYMBOL_GPL(__srcu_read_unlock);
> 
> The rcu_read_lock() and rcu_read_lock() implementations do not call
> smp_mb() as one can see in include/linux/rcupdate.h:
> 
> static inline void __rcu_read_lock(void)
> {
>     preempt_disable();
> }
> 
> static inline void __rcu_read_unlock(void)
> {
>     preempt_enable();
>     if (IS_ENABLED(CONFIG_RCU_STRICT_GRACE_PERIOD))
>         rcu_read_unlock_strict();
> }
> 
> Thanks,
> 
> Bart.
> 

