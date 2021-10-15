Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F57DC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 05:41:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B56A61108
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 05:41:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235409AbhJOFnf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Oct 2021 01:43:35 -0400
Received: from mga07.intel.com ([134.134.136.100]:52958 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229706AbhJOFne (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 15 Oct 2021 01:43:34 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10137"; a="291337972"
X-IronPort-AV: E=Sophos;i="5.85,374,1624345200"; 
   d="scan'208";a="291337972"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2021 22:41:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,374,1624345200"; 
   d="scan'208";a="571654311"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.76]) ([10.237.72.76])
  by fmsmga002.fm.intel.com with ESMTP; 14 Oct 2021 22:41:22 -0700
Subject: Re: [PATCH 1/1] scsi: ufs: core: Fix task management completion
 timeout race
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        linux-scsi@vger.kernel.org
References: <20211013150116.31158-1-adrian.hunter@intel.com>
 <20211013150116.31158-2-adrian.hunter@intel.com>
 <40259621-aac4-e69f-c230-6376bf4d3e36@acm.org>
 <235af725-5346-d830-b62b-21b729aa8703@intel.com>
 <58b1d411-cb88-468b-e1a7-f7c2f04c8333@acm.org>
 <8782c443-709c-5d62-c0f9-0fbf98745747@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <02094c7f-6927-710f-353b-781a20e5fb5b@intel.com>
Date:   Fri, 15 Oct 2021 08:41:21 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <8782c443-709c-5d62-c0f9-0fbf98745747@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/10/2021 21:50, Adrian Hunter wrote:
> On 14/10/2021 19:47, Bart Van Assche wrote:
>> On 10/13/21 11:02 PM, Adrian Hunter wrote:
>>> On 14/10/2021 07:14, Bart Van Assche wrote:
>>>> Wouldn't it be better to keep the code that clears req->end_io_data
>>>> and to change complete(c) into if(c) complete(c) in
>>>> ufshcd_tmc_handler()?
>>>
>>> If that were needed, it would imply the synchronization was broken
>>> i.e. why are we referencing a request that has already been through
>>> blk_put_request()?
>>
>> The scenario I'm worried about is as follows:
>> * __ufshcd_issue_tm_cmd() issues a task management function.
>> * No completion is received before TM_CMD_TIMEOUT has expired (100 ms).
>> * ufshcd_clear_tm_cmd() fails.
>> * The TMF completes, ufshcd_tmc_handler() is called and that function calls complete(req->end_io_data).
>>
>> Can this happen?
> 
> No because the tag's bit is cleared from outstanding_tasks before blk_put_request() and
> access to outstanding_tasks is protected by host_lock in both __ufshcd_issue_tm_cmd()
> and ufshcd_clear_tm_cmd().

Although I just noticed a different issue.

In ufshcd_tmc_handler() the task doorbell register needs to be read
in conjunction with outstanding_tasks i.e. under the spinlock

I will send a V2.

> 
>>
>> I agree that this scenario involves completion of a request that has already been through blk_put_request().
>>
>> Thanks,
>>
>> Bart.
> 

