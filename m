Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A150C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Sep 2021 05:43:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33EE060FC1
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Sep 2021 05:43:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239185AbhIWFpO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Sep 2021 01:45:14 -0400
Received: from mga03.intel.com ([134.134.136.65]:7010 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229890AbhIWFpN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Sep 2021 01:45:13 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10115"; a="223810413"
X-IronPort-AV: E=Sophos;i="5.85,316,1624345200"; 
   d="scan'208";a="223810413"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2021 22:43:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,316,1624345200"; 
   d="scan'208";a="550663458"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.84]) ([10.237.72.84])
  by FMSMGA003.fm.intel.com with ESMTP; 22 Sep 2021 22:43:38 -0700
Subject: Re: [PATCH] scsi: ufs: Fix task management completion
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org
References: <20210922091059.4040-1-adrian.hunter@intel.com>
 <88b64fec-4034-3e0d-d15e-46dcfaad5863@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <3a9a6c89-089c-bf7a-bc32-8f83a0209e29@intel.com>
Date:   Thu, 23 Sep 2021 08:44:18 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <88b64fec-4034-3e0d-d15e-46dcfaad5863@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 22/09/21 11:48 pm, Bart Van Assche wrote:
> On 9/22/21 2:10 AM, Adrian Hunter wrote:
>> The UFS driver uses blk_mq_tagset_busy_iter() when identifying task
>> management requests to complete, however blk_mq_tagset_busy_iter()
>> doesn't work.
>>
>> blk_mq_tagset_busy_iter() only iterates requests dispatched by the block
>> layer. That appears as if it might have started since commit 37f4a24c2469a1
>> ("blk-mq: centralise related handling into blk_mq_get_driver_tag") which
>> removed 'data->hctx->tags->rqs[rq->tag] = rq' from blk_mq_rq_ctx_init()
>> which gets called:
>>
>>     blk_get_request
>>         blk_mq_alloc_request
>>             __blk_mq_alloc_request
>>                 blk_mq_rq_ctx_init
>>
>> Since UFS task management requests are not dispatched by the block
>> layer, hctx->tags->rqs[rq->tag] remains NULL,  and since
>> blk_mq_tagset_busy_iter() relies on finding requests using
>> hctx->tags->rqs[rq->tag], UFS task management requests are never found by
>> blk_mq_tagset_busy_iter().
>>
>> By using blk_mq_tagset_busy_iter(), the UFS driver was relying on internal
>> details of the block layer, which was fragile and subsequently got
>> broken. Fix by removing the use of blk_mq_tagset_busy_iter() and having
>> the driver keep track of task management requests.
> 
> Thanks for the detailed analysis. I agree that using blk_mq_tagset_busy_iter()
> no longer works due to recent changes in the block layer. Has it been
> considered to export blk_mq_all_tag_iter() and to use that function instead of
> blk_mq_tagset_busy_iter()?

It seemed better not to be the only driver using the block layer in a
different way.  Having the UFS driver self-contained in this regard
seemed more robust.  If anything, the code without blk_mq_tagset_busy_iter()
is slightly shorter, so using a block layer iterator doesn't help much.
