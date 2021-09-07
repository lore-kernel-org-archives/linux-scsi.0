Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3691EC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Sep 2021 15:43:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1182860E97
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Sep 2021 15:43:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345443AbhIGPo0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Sep 2021 11:44:26 -0400
Received: from mga17.intel.com ([192.55.52.151]:29463 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235162AbhIGPoM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Sep 2021 11:44:12 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10099"; a="200439376"
X-IronPort-AV: E=Sophos;i="5.85,274,1624345200"; 
   d="scan'208";a="200439376"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2021 08:43:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,274,1624345200"; 
   d="scan'208";a="692820145"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.174]) ([10.237.72.174])
  by fmsmga006.fm.intel.com with ESMTP; 07 Sep 2021 08:43:01 -0700
Subject: Re: [PATCH V3 1/3] scsi: ufs: Fix error handler clear ua deadlock
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
References: <20210905095153.6217-1-adrian.hunter@intel.com>
 <20210905095153.6217-2-adrian.hunter@intel.com>
 <a12d88b3-8402-34bb-fe97-90b7aa2c2c39@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <835c5eab-5a7b-269d-7483-227978b80cd7@intel.com>
Date:   Tue, 7 Sep 2021 18:43:28 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <a12d88b3-8402-34bb-fe97-90b7aa2c2c39@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/09/21 5:42 pm, Bart Van Assche wrote:
> On 9/5/21 2:51 AM, Adrian Hunter wrote:
>> There is no guarantee to be able to enter the queue if requests are
>> blocked. That is because freezing the queue will block entry to the
>> queue, but freezing also waits for outstanding requests which can make
>> no progress while the queue is blocked.
>>
>> That situation can happen when the error handler issues requests to
>> clear unit attention condition. Requests can be blocked if the
>> ufshcd_state is UFSHCD_STATE_EH_SCHEDULED_FATAL, which can happen
>> as a result either of error handler activity, or theoretically a
>> request that is issued after the error handler unblocks the queue
>> but before clearing unit attention condition.
>>
>> The deadlock is very unlikely, so the error handler can be expected
>> to clear ua at some point anyway, so the simple solution is not to
>> wait to enter the queue.
> 
> Do you agree that the interaction between ufshcd_scsi_block_requests() and
> blk_mq_freeze_queue() can only lead to a deadlock if blk_queue_enter() is
> called without using the BLK_MQ_REQ_NOWAIT flag and if unblocking SCSI
> request processing can only happen by the same thread?

Sure

> Do you agree that no ufshcd_clear_ua_wluns() caller blocks SCSI request
> processing and hence that it is not necessary to add a "nowait" argument
> to ufshcd_clear_ua_wluns()?

No.  Requests cannot make progress when ufshcd_state is
UFSHCD_STATE_EH_SCHEDULED_FATAL, and only the error handler can change that,
so if the error handler is waiting to enter the queue and blk_mq_freeze_queue()
is waiting for outstanding requests, they will deadlock.
