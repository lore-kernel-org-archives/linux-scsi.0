Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0DEEC4338F
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 05:36:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 864E861042
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 05:36:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231949AbhHTFh1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Aug 2021 01:37:27 -0400
Received: from mga05.intel.com ([192.55.52.43]:33886 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233004AbhHTFh1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Aug 2021 01:37:27 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10081"; a="302303737"
X-IronPort-AV: E=Sophos;i="5.84,336,1620716400"; 
   d="scan'208";a="302303737"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2021 22:36:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,336,1620716400"; 
   d="scan'208";a="679855740"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.174]) ([10.237.72.174])
  by fmsmga006.fm.intel.com with ESMTP; 19 Aug 2021 22:36:47 -0700
Subject: Re: [PATCH] scsi: ufs: Fix ufshcd_request_sense_async() for Samsung
 KLUFG8RHDA-B2D1
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <huobean@gmail.com>, Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        linux-scsi@vger.kernel.org
References: <20210819093534.17507-1-adrian.hunter@intel.com>
 <e495acd6-ab2c-dc07-5515-08316ac8a22d@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <80969e85-40e9-7cff-02fc-304774f3061b@intel.com>
Date:   Fri, 20 Aug 2021 08:37:22 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <e495acd6-ab2c-dc07-5515-08316ac8a22d@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 19/08/21 9:14 pm, Bart Van Assche wrote:
> On 8/19/21 2:35 AM, Adrian Hunter wrote:
>>        * From SPC-6: the REQUEST SENSE command with any allocation length
>> -     * clears the sense data.
>> +     * clears the sense data, but not all UFS devices behave that way.
>>        */
> 
> How about removing the comment entirely? Comprehending the above comment is not possible without reviewing the git history so I think it's better to remove it.

Perhaps a comment might stop someone tempted to remove the sense size in the future.  What about:

	/*
	 * Some UFS devices clear unit attention condition only if the sense
	 * size used (UFS_SENSE_SIZE in this case) is non-zero.
	 */

> 
>> -    static const u8 cmd[6] = {REQUEST_SENSE, 0, 0, 0, 0, 0};
>> +    static const u8 cmd[6] = {REQUEST_SENSE, 0, 0, 0, UFS_SENSE_SIZE, 0};
>>       struct scsi_request *rq;
>>       struct request *req;
>> +    char *buffer;
>> +    int ret;
>> +
>> +    buffer = kzalloc(UFS_SENSE_SIZE, GFP_KERNEL);
>> +    if (!buffer)
>> +        return -ENOMEM;
>>   -    req = blk_get_request(sdev->request_queue, REQ_OP_DRV_IN, /*flags=*/0);
>> +    req = blk_get_request(sdev->request_queue, REQ_OP_DRV_IN,
>> +                  /*flags=*/BLK_MQ_REQ_PM);
> 
> Why has the flags argument been changed from 0 into BLK_MQ_REQ_PM? MODE SENSE is not a power management command.

It is used in a PM path, it is consistent with RQF_PM also used by ufshcd_request_sense_async(), it is what __scsi_execute() does with RQF_PM, so it is what was used before "scsi: ufs: Request sense data asynchronously".

