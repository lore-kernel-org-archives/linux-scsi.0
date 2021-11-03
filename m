Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04846C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 14:04:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D49A061130
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 14:04:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbhKCOHY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 10:07:24 -0400
Received: from mga05.intel.com ([192.55.52.43]:14143 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230527AbhKCOHY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 3 Nov 2021 10:07:24 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10156"; a="317703792"
X-IronPort-AV: E=Sophos;i="5.87,206,1631602800"; 
   d="scan'208";a="317703792"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2021 07:03:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,206,1631602800"; 
   d="scan'208";a="541695514"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.76]) ([10.237.72.76])
  by fmsmga008.fm.intel.com with ESMTP; 03 Nov 2021 07:03:38 -0700
Subject: Re: [PATCH 2/2] scsi: ufs: Fix a deadlock in the error handler
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20211103000529.1549411-1-bvanassche@acm.org>
 <20211103000529.1549411-3-bvanassche@acm.org>
 <82dffddc-15e8-dc1a-abda-e84e7e441d87@intel.com>
 <d25a32ff-251c-dcca-57ad-5e95c094317d@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <c1c798f1-9772-e2b0-80c5-0aa3b28f22a2@intel.com>
Date:   Wed, 3 Nov 2021 16:03:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <d25a32ff-251c-dcca-57ad-5e95c094317d@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 03/11/2021 15:40, Bart Van Assche wrote:
> On 11/2/21 23:56, Adrian Hunter wrote:
>> On 03/11/2021 02:05, Bart Van Assche wrote:
>>> The following deadlock has been observed on a test setup:
>>> * All tags allocated.
>>> * The SCSI error handler calls ufshcd_eh_host_reset_handler()
>>> * ufshcd_eh_host_reset_handler() queues work that calls ufshcd_err_handler()
>>> * ufshcd_err_handler() locks up as follows:
>>>
>>> Workqueue: ufs_eh_wq_0 ufshcd_err_handler.cfi_jt
>>> Call trace:
>>>   __switch_to+0x298/0x5d8
>>>   __schedule+0x6cc/0xa94
>>>   schedule+0x12c/0x298
>>>   blk_mq_get_tag+0x210/0x480
>>>   __blk_mq_alloc_request+0x1c8/0x284
>>>   blk_get_request+0x74/0x134
>>>   ufshcd_exec_dev_cmd+0x68/0x640
>>>   ufshcd_verify_dev_init+0x68/0x35c
>>>   ufshcd_probe_hba+0x12c/0x1cb8
>>>   ufshcd_host_reset_and_restore+0x88/0x254
>>>   ufshcd_reset_and_restore+0xd0/0x354
>>>   ufshcd_err_handler+0x408/0xc58
>>>   process_one_work+0x24c/0x66c
>>>   worker_thread+0x3e8/0xa4c
>>>   kthread+0x150/0x1b4
>>>   ret_from_fork+0x10/0x30
>>>
>>> Fix this lockup by making ufshcd_exec_dev_cmd() allocate a reserved
>>> request.
>>
>> It is worth noting that the error handler itself could always find
>> a free slot, either by waiting for one, or by taking the reset
>> path which clears all slots.
> 
> I do not agree. As mentioned in the patch description, this patch is a fix for a scenario in which ufshcd_eh_host_reset_handler() waits until ufshcd_err_handler() finishes. ufshcd_err_handler() does not finish since there are no tags and no tags will be freed since that is the responsibility of ufshcd_eh_host_reset_handler() but it is blocked ...

I am referring to the host controller slots, not block layer tags.
The error handler does not need a free tag, it only needs a free slot.

