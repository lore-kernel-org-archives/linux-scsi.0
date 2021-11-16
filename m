Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31752C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 09:03:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 177F263219
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 09:03:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232778AbhKPJGd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Nov 2021 04:06:33 -0500
Received: from mga14.intel.com ([192.55.52.115]:40111 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232753AbhKPJGW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 16 Nov 2021 04:06:22 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10169"; a="233893930"
X-IronPort-AV: E=Sophos;i="5.87,238,1631602800"; 
   d="scan'208";a="233893930"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2021 01:03:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,238,1631602800"; 
   d="scan'208";a="548531943"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.76]) ([10.237.72.76])
  by fmsmga008.fm.intel.com with ESMTP; 16 Nov 2021 01:03:21 -0800
Subject: Re: [PATCH 08/11] scsi: ufs: Improve SCSI abort handling further
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Santosh Yaraganavi <santoshsy@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Vishak G <vishak.g@samsung.com>
References: <20211110004440.3389311-1-bvanassche@acm.org>
 <20211110004440.3389311-9-bvanassche@acm.org>
 <509e2b2c-689a-04e3-e773-b8b99d9f6d0e@intel.com>
 <aac7b8c8-7474-4317-c342-1714cc61a331@acm.org>
 <985b86c5-e45f-8d07-31e3-7eed1c7c894c@intel.com>
 <9ebeec91-ff62-3dcd-a377-1d6f98bd7c32@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <4829b1ab-9f33-7189-3b72-a65250552e54@intel.com>
Date:   Tue, 16 Nov 2021 11:03:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <9ebeec91-ff62-3dcd-a377-1d6f98bd7c32@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 16/11/2021 01:09, Bart Van Assche wrote:
> On 11/12/21 2:56 AM, Adrian Hunter wrote:
>> On 10/11/2021 20:56, Bart Van Assche wrote:
>>> On 11/10/21 12:57 AM, Adrian Hunter wrote:
>>>> Seems like something ufshcd_clear_cmd() should be doing instead?
>>>
>>> I'm concerned that would break ufshcd_eh_device_reset_handler()
>>> since that reset handler retries SCSI commands by calling
>>> __ufshcd_transfer_req_compl() after having called ufshcd_clear_cmd().
>> Whenever an outstanding_reqs bit transitions 1 -> 0, then
>> __ufshcd_transfer_req_compl() must be called.
> 
> I will look further into this.
> 
>> As a separate issue, in ufshcd_abort() there is:
>>
>>     /* If command is already aborted/completed, return FAILED. */
>>     if (!(test_bit(tag, &hba->outstanding_reqs))) {
>>         dev_err(hba->dev,
>>             "%s: cmd at tag %d already completed, outstanding=0x%lx, doorbell=0x%x\n",
>>             __func__, tag, hba->outstanding_reqs, reg);
>>         goto release;
>>     }
>>
>> which seems wrong. FAILED should only be returned to escalate the
>> error handling, so if the slot has already successfully been
>> cleared, that is SUCCESS.  scsi_times_out() has already blocked
>> the scsi_done() path (by setting SCMD_STATE_COMPLETE), so any use
>> after free must be being caused by SCSI not the ufs driver.
> 
> scmd_eh_abort_handler() would trigger a use-after-free if ufshcd_abort() would return SUCCESS for completed commands. Hence the choice for the return value FAILED for completed commands.
> 
> BTW, can this code path ever be reached since scsi_done() sets the SCMD_STATE_COMPLETE bit before it calls blk_mq_complete_request() and since scsi_times_out() tests that bit before it schedules a call of ufshcd_abort()?

Racing with timing out, the UFS interrupt handler can clear hba->outstanding_reqs bit and call __ufshcd_transfer_req_compl(), but the request will not be freed if scsi_times_out() wins the race.  So there should be no use-after-free unless SCSI error handling itself has a bug.

One perhaps unrelated issue in scsi_times_out():

		if (test_and_set_bit(SCMD_STATE_COMPLETE, &scmd->state))
			return BLK_EH_RESET_TIMER;

Shouldn't that return BLK_EH_DONE not BLK_EH_RESET_TIMER, since the request has been through blk_mq_complete_request() ?




