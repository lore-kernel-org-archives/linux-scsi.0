Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AFCEC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 17:38:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F6AD60F21
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 17:38:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240689AbhIQRjw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 13:39:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:34263 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237238AbhIQRjw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Sep 2021 13:39:52 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10110"; a="222881344"
X-IronPort-AV: E=Sophos;i="5.85,302,1624345200"; 
   d="scan'208";a="222881344"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2021 10:38:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,302,1624345200"; 
   d="scan'208";a="473192468"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.84]) ([10.237.72.84])
  by orsmga007.jf.intel.com with ESMTP; 17 Sep 2021 10:38:27 -0700
Subject: Re: [PATCH V4 1/3] scsi: ufs: Fix error handler clear ua deadlock
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
References: <20210916170211.8564-1-adrian.hunter@intel.com>
 <20210916170211.8564-2-adrian.hunter@intel.com>
 <8a3ab601-81c4-8386-b7c8-5bea2ed99002@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <3a8b5325-0bef-b18e-8961-3bfc465096a0@intel.com>
Date:   Fri, 17 Sep 2021 20:39:09 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <8a3ab601-81c4-8386-b7c8-5bea2ed99002@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 17/09/21 7:09 pm, Bart Van Assche wrote:
> On 9/16/21 10:02 AM, Adrian Hunter wrote:
>> -static void ufshcd_request_sense_done(struct request *rq, blk_status_t error)
>> +static int ufshcd_request_sense_direct(struct ufs_hba *hba, u8 wlun)
>>   {
> [ ... ]
>> +    /* The command queue cannot be frozen */
>> +    req = blk_get_request(q, REQ_OP_DRV_OUT, 0);
> 
> hba->cmd_queue shares a tag set with the request queues associated with SCSI
> LUNs. Since this blk_get_request() call happens from the context of the error
> handler before SCSI requests are unblocked, it will hang if all tags are
> in use for SCSI requests before the error handler starts.

All the commands sent by ufshcd_probe_hba() take the same approach, so no
difference there.

