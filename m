Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81DFEC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 07:37:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6167363214
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 07:37:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234175AbhKQHkN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Nov 2021 02:40:13 -0500
Received: from mga17.intel.com ([192.55.52.151]:14464 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231718AbhKQHkM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 17 Nov 2021 02:40:12 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10170"; a="214617967"
X-IronPort-AV: E=Sophos;i="5.87,240,1631602800"; 
   d="scan'208";a="214617967"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2021 23:37:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,240,1631602800"; 
   d="scan'208";a="506804597"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.76]) ([10.237.72.76])
  by orsmga008.jf.intel.com with ESMTP; 16 Nov 2021 23:37:10 -0800
Subject: Re: [PATCH 08/11] scsi: ufs: Improve SCSI abort handling further
To:     Bart Van Assche <bvanassche@acm.org>,
        Peter Wang <peter.wang@mediatek.com>,
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
 <b728d150-3271-c6b0-25dc-881141ef3630@mediatek.com>
 <1a196e1b-1412-90f3-e511-3f669572a619@mediatek.com>
 <87d8a036-087d-f1fa-19f4-f50c7279170a@acm.org>
 <59620452-e5a2-74e1-5971-a5535de3d536@intel.com>
 <03036140-a7c6-fe0c-13e3-def8fcf2ecb3@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <d96ef6fd-f36b-5403-2ef9-8944b94df918@intel.com>
Date:   Wed, 17 Nov 2021 09:37:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <03036140-a7c6-fe0c-13e3-def8fcf2ecb3@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 16/11/2021 23:53, Bart Van Assche wrote:
> On 11/16/21 12:16, Adrian Hunter wrote:
>> On 16/11/2021 18:08, Bart Van Assche wrote:
>>> On 11/16/21 1:07 AM, Peter Wang wrote:
>>>> Should we add unmap?
>>>
>>> Hi Peter,
>>>
>>> I will add DMA unmapping code in the abort handler.
>>
>> I would note that __ufshcd_transfer_req_compl() does that, as well as providing
>> a matching ufshcd_release() for the ufshcd_hold() in ufshcd_queuecommand(), so
>> do consider __ufshcd_transfer_req_compl().
>>
>> Using __ufshcd_transfer_req_compl() seems consistent with the error handler which
>> uses __ufshcd_transfer_req_compl() via ufshcd_complete_requests(), which will pick
>> up all the requests that the error handler has just aborted via
>> ufshcd_try_to_abort_task().  Also ufshcd_host_reset_and_restore() uses
>> __ufshcd_transfer_req_compl() via ufshcd_complete_requests(), which will pick
>> up anything still in outstanding_reqs because the doorbell has become zero at
>> that point.
> 
> Hi Adrian,
> 
> Although I agree with minimizing code duplication, I'm not sure that __ufshcd_transfer_req_compl() should be called from inside ufshcd_abort(). __ufshcd_transfer_req_compl() also calls ufshcd_update_monitor() and ufshcd_add_command_trace(hba, index, UFS_CMD_COMP). Neither function should be called when aborting a command.

But we should trace the abort I would have thought - seems like a separate issue though.
