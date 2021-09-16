Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3570FC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Sep 2021 17:12:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18EC260EFF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Sep 2021 17:12:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245548AbhIPRNU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Sep 2021 13:13:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:53978 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349772AbhIPRLS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Sep 2021 13:11:18 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10109"; a="209844297"
X-IronPort-AV: E=Sophos;i="5.85,299,1624345200"; 
   d="scan'208";a="209844297"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2021 10:01:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,299,1624345200"; 
   d="scan'208";a="583723683"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.174]) ([10.237.72.174])
  by orsmga004.jf.intel.com with ESMTP; 16 Sep 2021 10:01:29 -0700
Subject: Re: [PATCH V3 1/3] scsi: ufs: Fix error handler clear ua deadlock
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
References: <20210905095153.6217-1-adrian.hunter@intel.com>
 <20210905095153.6217-2-adrian.hunter@intel.com>
 <a12d88b3-8402-34bb-fe97-90b7aa2c2c39@acm.org>
 <835c5eab-5a7b-269d-7483-227978b80cd7@intel.com>
 <d9656961-4abb-aff0-e34d-d8082a1f4eaa@acm.org>
 <e5307bbe-1cda-fdd2-a666-ae57cd90de07@acm.org>
 <36245674-b179-d25e-84c3-417ef2d85620@intel.com>
 <9220f68e-dc5e-9520-6e55-2a4d86809b44@acm.org>
 <fae15188-2c1d-b953-f6e4-6e5ac1902b24@intel.com>
 <2997f7f9-d136-4bad-6490-5e19abccba00@acm.org>
 <cad73161-f124-e764-964f-3c205aaca2d9@intel.com>
 <2a43c750-ec15-2ac9-b899-00ed911addd8@acm.org>
 <8b3f4f40-4959-17ee-577e-ab9473e4882b@intel.com>
 <75bf671f-6dad-906f-3e32-ceeaf3a6a1bd@acm.org>
 <1072b4e3-8e18-bb6f-f63e-ec07b1404b50@intel.com>
 <c33f0d4f-d7d4-3a8b-1999-d6bc2d9a5c07@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <e62aa9b2-5ccd-4edf-a224-312975f86164@intel.com>
Date:   Thu, 16 Sep 2021 20:01:53 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <c33f0d4f-d7d4-3a8b-1999-d6bc2d9a5c07@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 16/09/21 1:41 am, Bart Van Assche wrote:
> On 9/15/21 8:35 AM, Adrian Hunter wrote:
>> Thanks for the idea.  Unfortunately it does not work for pass-through
>> requests, refer scsi_noretry_cmd().  sdev_ufs_device and sdev_rpmb are
>> used with pass-through requests.
> 
> How about allocating and submitting the REQUEST SENSE command from the context
> of a workqueue, or in other words, switching back to scsi_execute()? Although
> that approach doesn't guarantee that the unit attention condition is cleared
> before the first SCSI command is received from outside the UFS driver, I don't
> see any other solution since my understanding is that the deadlock between
> blk_mq_freeze_queue() and blk_get_request() from inside ufshcd_err_handler()
> can also happen without "ufs: Synchronize SCSI and UFS error handling".

The issue can also be fixed by sending REQUEST SENSE directly avoiding the
SCSI queues.  Please see V4.

> 
> The only code I know of that relies on the UFS driver clearing unit attentions
> is this code:
> https://android.googlesource.com/platform/system/core/+/master/trusty/storage/proxy/rpmb.c
> The code that submits a REQUEST SENSE was added in the UFS driver as the result
> of a request from the team that maintains the Trusty code. Earlier today I have
> been promised that unit attention handling support will be added in Trusty but I
> do not when this will be realized.
> 
> Bart.
> 
> 

