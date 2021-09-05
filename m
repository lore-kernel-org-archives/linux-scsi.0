Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3D49C433EF
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Sep 2021 09:50:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99A5660FBF
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Sep 2021 09:50:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237241AbhIEJv6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 5 Sep 2021 05:51:58 -0400
Received: from mga12.intel.com ([192.55.52.136]:29316 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237148AbhIEJv6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 5 Sep 2021 05:51:58 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10097"; a="199295986"
X-IronPort-AV: E=Sophos;i="5.85,269,1624345200"; 
   d="scan'208";a="199295986"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2021 02:50:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,269,1624345200"; 
   d="scan'208";a="535873180"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.174]) ([10.237.72.174])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Sep 2021 02:50:52 -0700
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
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <58c32af5-7a96-16bd-1f59-e77ea97a50f4@intel.com>
Date:   Sun, 5 Sep 2021 12:51:20 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <56b1a7b3-90b7-e208-2486-20421d32d2e7@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/09/21 11:29 pm, Bart Van Assche wrote:
> On 9/3/21 2:56 AM, Adrian Hunter wrote:
>> There is no guarantee to be able to enter the queue if requests are
>> blocked. That is because freezing the queue will block entry to the
>> queue, but freezing also waits for outstanding requests which can make
>> no progress while the queue is blocked.
>>
>> That situation can happen when the error handler issues requests to
>> clear unit attention condition. The deadlock is very unlikely, so the
>> error handler can be expected to clear ua at some point anyway, so the
>> simple solution is not to wait to enter the queue.
>>
>> Additionally, note that the RPMB queue might be not be entered because
>> it is runtime suspended, but in that case ua will be cleared at RPMB
>> runtime resume.
> 
> The only ufshcd_clear_ua_wluns() call that I am aware of and that is related to error handling is the call in ufshcd_err_handling_unprepare(). That call happens after ufshcd_scsi_unblock_requests() has been called so how can it be involved in a deadlock?

That is a very good question.  I went back to reproduce the deadlock again, and it is because, in addition, ufshcd_state is UFSHCD_STATE_EH_SCHEDULED_FATAL.  So I have updated the commit message accordingly in V3.

> 
> Additionally, the ufshcd_scsi_block_requests() and ufshcd_scsi_unblock_requests() calls can be removed from ufshcd_err_handling_prepare() and ufshcd_err_handling_unprepare(). These calls are no longer necessary since patch "scsi: ufs: Synchronize SCSI and UFS error handling".

As has been noted, that commit introduces several new deadlocks - and will presumably cause the deadlock this patches addresses, even if ufshcd_state is not UFSHCD_STATE_EH_SCHEDULED_FATAL.

It is perhaps more appropriate to revert "scsi: ufs: Synchronize SCSI and UFS error handling" for v5.15 and try to get things sorted out for v5.16.  What do you think?
