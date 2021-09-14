Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A193BC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 04:55:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 846F66112E
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 04:55:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234253AbhINE4p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 00:56:45 -0400
Received: from mga04.intel.com ([192.55.52.120]:42413 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232829AbhINE4o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Sep 2021 00:56:44 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10106"; a="220001540"
X-IronPort-AV: E=Sophos;i="5.85,291,1624345200"; 
   d="scan'208";a="220001540"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2021 21:55:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,291,1624345200"; 
   d="scan'208";a="609454091"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.174]) ([10.237.72.174])
  by fmsmga001.fm.intel.com with ESMTP; 13 Sep 2021 21:55:21 -0700
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
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <8b3f4f40-4959-17ee-577e-ab9473e4882b@intel.com>
Date:   Tue, 14 Sep 2021 07:55:45 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <2a43c750-ec15-2ac9-b899-00ed911addd8@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 13/09/21 11:11 pm, Bart Van Assche wrote:
> On 9/13/21 10:13 AM, Adrian Hunter wrote:
>> SCSI_MLQUEUE_HOST_BUSY causes scsi_host_busy() to decrement by calling
>> scsi_dec_host_busy() as described above, so the request is not being
>> counted in that condition anymore.
> 
> Let's take a step back. My understanding is that the deadlock is caused by
> the combination of:
> * SCSI command processing being blocked because of the state
>   UFSHCD_STATE_EH_SCHEDULED_FATAL.

That assumes "scsi: ufs: Synchronize SCSI and UFS error handling" is reverted.
With "scsi: ufs: Synchronize SCSI and UFS error handling" all requests are
blocked because scsi_host_in_recovery().

> * The sdev_ufs_device and/or sdev_rpmb request queues are frozen
>   (blk_mq_freeze_queue() has started).

Yes

> * A REQUEST SENSE command being scheduled from inside the error handler
>   (ufshcd_clear_ua_wlun()).

Not exactly.  It is not possible to enter the queue after freezing starts
so blk_queue_enter() is stuck waiting on any existing requests to exit
the queue, but existing requests are blocked as described above.

> 
> Is this a theoretical concern or something that has been observed on a test
> setup?

It is observed on Samsung Galaxy Book S when suspending.

> 
> If this has been observed on a test setup, was the error handler scheduled
> (ufshcd_err_handler())?

Yes.

> 
> I don't see how SCSI command processing could get stuck indefinitely since
> it is guaranteed that the UFS error handler will get scheduled and also that
> the UFS error handler will change ufshcd_state from
> UFSHCD_STATE_EH_SCHEDULED_FATAL into another state?

The error handler is stuck waiting on the freeze, which is stuck waiting on
requests which are stuck waiting on the error handler.


> 
> What am I missing?

You have not responded to the issues raised by
"scsi: ufs: Synchronize SCSI and UFS error handling"

