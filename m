Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8535AC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Nov 2021 06:41:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238711AbhK3GpL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Nov 2021 01:45:11 -0500
Received: from mga05.intel.com ([192.55.52.43]:29984 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233768AbhK3GpL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 Nov 2021 01:45:11 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10183"; a="322397001"
X-IronPort-AV: E=Sophos;i="5.87,275,1631602800"; 
   d="scan'208";a="322397001"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2021 22:41:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,275,1631602800"; 
   d="scan'208";a="512046397"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.76]) ([10.237.72.76])
  by orsmga008.jf.intel.com with ESMTP; 29 Nov 2021 22:41:49 -0800
Subject: Re: [PATCH v2 11/20] scsi: ufs: Switch to
 scsi_(get|put)_internal_cmd()
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20211119195743.2817-1-bvanassche@acm.org>
 <20211119195743.2817-12-bvanassche@acm.org>
 <6bfb59ef-4f00-3918-59e6-3c9569f6adc6@intel.com>
 <bc19f55f-a3e9-a3fe-437d-57b9e077f532@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <1a9cddd9-b67a-be4b-4c83-3636f37e6769@intel.com>
Date:   Tue, 30 Nov 2021 08:41:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <bc19f55f-a3e9-a3fe-437d-57b9e077f532@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 29/11/2021 21:32, Bart Van Assche wrote:
> On 11/24/21 3:02 AM, Adrian Hunter wrote:
>> On 19/11/2021 21:57, Bart Van Assche wrote:
>>> The only functional change in this patch is the addition of a
>>> blk_mq_start_request() call in ufshcd_issue_devman_upiu_cmd().
>>>
>>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>>> ---
>>>   drivers/scsi/ufs/ufshcd.c | 46 +++++++++++++++++++++++++--------------
>>>   1 file changed, 30 insertions(+), 16 deletions(-)
>>>
>>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>>> index fced4528ee90..dfa5f127342b 100644
>>> --- a/drivers/scsi/ufs/ufshcd.c
>>> +++ b/drivers/scsi/ufs/ufshcd.c
>>> @@ -2933,6 +2933,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
>>>   {
>>>       struct request_queue *q = hba->cmd_queue;
>>>       DECLARE_COMPLETION_ONSTACK(wait);
>>> +    struct scsi_cmnd *scmd;
>>>       struct request *req;
>>>       struct ufshcd_lrb *lrbp;
>>>       int err;
>>> @@ -2945,15 +2946,18 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
>>>        * Even though we use wait_event() which sleeps indefinitely,
>>>        * the maximum wait time is bounded by SCSI request timeout.
>>>        */
>>> -    req = blk_mq_alloc_request(q, REQ_OP_DRV_OUT, 0);
>>> -    if (IS_ERR(req)) {
>>> -        err = PTR_ERR(req);
>>> +    scmd = scsi_get_internal_cmd(q, DMA_TO_DEVICE, 0);
>>
>> We do not need the block layer, nor SCSI commands which begs the question,
>> why involve them at all?
>>
>> For example, the following is much simpler and seems to work:
>> [ ... ]
> 
> That patch bypasses the block layer for device management commands. So that
> patch breaks a very basic assumption on which the block layer has been built,
> namely that the block layer core knows whether or not any requests are ongoing.
> That patch breaks at least the following functionality:
> * Run-time power management. blk_pre_runtime_suspend() checks whether
>   q_usage_counter is zero before initiating runtime power management.
>   q_usage_counter is increased by blk_mq_alloc_request() and decreased by
>   blk_mq_free_request(). I don't think it is safe to change the power state
>   while a device management request is in progress.

hba->cmd_queue does not have runtime PM.

I suspect making it do runtime PM might open up deadlock issues similar to
the issues that were seen with sending sending clear WLUN UA from the
UFS error handler.

> * The code in blk_cleanup_queue() that waits for pending requests to finish
>   before resources associated with the request queue are freed.
>   ufshcd_remove() calls blk_cleanup_queue(hba->cmd_queue) and hence waits until
>   pending device management commands have finished. That would no longer be the
>   case if the block layer is bypassed to submit device management commands.

cmd_queue is used only by the UFS driver, so if the driver is racing with
itself at "remove", then that should be fixed. The risk is not that the UFS
driver might use requests, but that it might still be operating when hba or
other resources get freed.

So the question remains, for device commands, we do not need the block
layer, nor SCSI commands which still begs the question, why involve them
at all?
