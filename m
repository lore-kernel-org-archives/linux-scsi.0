Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51288C43217
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Nov 2021 10:56:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E7CB60F8F
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Nov 2021 10:56:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234857AbhKLK7o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Nov 2021 05:59:44 -0500
Received: from mga07.intel.com ([134.134.136.100]:45946 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234872AbhKLK7h (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 12 Nov 2021 05:59:37 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10165"; a="296551590"
X-IronPort-AV: E=Sophos;i="5.87,229,1631602800"; 
   d="scan'208";a="296551590"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2021 02:56:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,229,1631602800"; 
   d="scan'208";a="546898338"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.76]) ([10.237.72.76])
  by fmsmga008.fm.intel.com with ESMTP; 12 Nov 2021 02:56:41 -0800
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
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <985b86c5-e45f-8d07-31e3-7eed1c7c894c@intel.com>
Date:   Fri, 12 Nov 2021 12:56:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <aac7b8c8-7474-4317-c342-1714cc61a331@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/11/2021 20:56, Bart Van Assche wrote:
> On 11/10/21 12:57 AM, Adrian Hunter wrote:
>> On 10/11/2021 02:44, Bart Van Assche wrote:
>>> Make sure that aborted commands are completed once by clearing the
>>> corresponding tag bit from hba->outstanding_reqs. This patch is a
>>> follow-up for commit cd892096c940 ("scsi: ufs: core: Improve SCSI
>>> abort handling").
>>>
>>> Fixes: 7a3e97b0dc4b ("[SCSI] ufshcd: UFS Host controller driver")
>>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>>> ---
>>>   drivers/scsi/ufs/ufshcd.c | 9 +++++++++
>>>   1 file changed, 9 insertions(+)
>>>
>>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>>> index 8f5640647054..1e15ed1f639f 100644
>>> --- a/drivers/scsi/ufs/ufshcd.c
>>> +++ b/drivers/scsi/ufs/ufshcd.c
>>> @@ -7090,6 +7090,15 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>>>           goto release;
>>>       }
>>>   +    /*
>>> +     * ufshcd_try_to_abort_task() cleared the 'tag' bit in the doorbell
>>> +     * register. Clear the corresponding bit from outstanding_reqs to
>>> +     * prevent early completion.
>>> +     */
>>> +    spin_lock_irqsave(&hba->outstanding_lock, flags);
>>> +    __clear_bit(tag, &hba->outstanding_reqs);
>>> +    spin_unlock_irqrestore(&hba->outstanding_lock, flags);
>>
>> Seems like something ufshcd_clear_cmd() should be doing instead?
> 
> Hi Adrian,
> 
> I'm concerned that would break ufshcd_eh_device_reset_handler() since that reset handler retries SCSI commands by calling __ufshcd_transfer_req_compl() after having called ufshcd_clear_cmd().

Whenever an outstanding_reqs bit transitions 1 -> 0, then
__ufshcd_transfer_req_compl() must be called.

In all cases, the correct logic must have the effect of:

	spin_lock_irqsave(&hba->outstanding_lock, flags);
	bit = __test_and_clear_bit(tag, &hba->outstanding_reqs);
	spin_unlock_irqrestore(&hba->outstanding_lock, flags);

	if (bit)
		__ufshcd_transfer_req_compl(hba, 1UL << tag);

To put it another way, how else does the driver know whether or
not __ufshcd_transfer_req_compl() has been called already.


As a separate issue, in ufshcd_abort() there is:

	/* If command is already aborted/completed, return FAILED. */
	if (!(test_bit(tag, &hba->outstanding_reqs))) {
		dev_err(hba->dev,
			"%s: cmd at tag %d already completed, outstanding=0x%lx, doorbell=0x%x\n",
			__func__, tag, hba->outstanding_reqs, reg);
		goto release;
	}

which seems wrong. FAILED should only be returned to escalate the
error handling, so if the slot has already successfully been
cleared, that is SUCCESS.  scsi_times_out() has already blocked
the scsi_done() path (by setting SCMD_STATE_COMPLETE), so any use
after free must be being caused by SCSI not the ufs driver.

path
