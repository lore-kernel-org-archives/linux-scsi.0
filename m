Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57FA7C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 15:35:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37D9260FDA
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 15:35:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234166AbhIOPgs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Sep 2021 11:36:48 -0400
Received: from mga17.intel.com ([192.55.52.151]:38919 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234095AbhIOPgs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Sep 2021 11:36:48 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10108"; a="202518921"
X-IronPort-AV: E=Sophos;i="5.85,295,1624345200"; 
   d="scan'208";a="202518921"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2021 08:35:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,295,1624345200"; 
   d="scan'208";a="529524460"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.174]) ([10.237.72.174])
  by fmsmga004.fm.intel.com with ESMTP; 15 Sep 2021 08:35:19 -0700
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
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <1072b4e3-8e18-bb6f-f63e-ec07b1404b50@intel.com>
Date:   Wed, 15 Sep 2021 18:35:43 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <75bf671f-6dad-906f-3e32-ceeaf3a6a1bd@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 15/09/21 1:28 am, Bart Van Assche wrote:
> On 9/13/21 9:55 PM, Adrian Hunter wrote:
>> On 13/09/21 11:11 pm, Bart Van Assche wrote: >> What am I missing?
>>
>> You have not responded to the issues raised by
>> "scsi: ufs: Synchronize SCSI and UFS error handling"
> 
> Because one of the follow-up messages to that patch was so cryptic that I
> did not comprehend it. Anyway, based on the patch at the start of this email
> thread I assume that the deadlock is caused by calling blk_get_request()
> without the BLK_MQ_REQ_NOWAIT flag from inside a SCSI error handler. How
> about fixing this by removing the code that submits a REQUEST SENSE command
> and calling scsi_report_bus_reset() or scsi_report_device_reset() instead?
> ufshcd_reset_and_restore() already uses that approach to make sure that the
> unit attention condition triggered by a reset is not reported to the SCSI
> command submitter. I think only if needs_restore == true and
> needs_reset == false that ufshcd_err_handler() can trigger a UA condition
> without calling scsi_report_bus_reset().
> 
> The following code from scsi_error.c makes sure that the UA after a reset
> does not reach the upper-level driver:
> 
>     case NOT_READY:
>     case UNIT_ATTENTION:
>         /*
>          * if we are expecting a cc/ua because of a bus reset that we
>          * performed, treat this just as a retry.  otherwise this is
>          * information that we should pass up to the upper-level driver
>          * so that we can deal with it there.
>          */
>         if (scmd->device->expecting_cc_ua) {
>             /*
>              * Because some device does not queue unit
>              * attentions correctly, we carefully check
>              * additional sense code and qualifier so as
>              * not to squash media change unit attention.
>              */
>             if (sshdr.asc != 0x28 || sshdr.ascq != 0x00) {
>                 scmd->device->expecting_cc_ua = 0;
>                 return NEEDS_RETRY;
>             }
>         }
> 
> Bart.


Thanks for the idea.  Unfortunately it does not work for pass-through
requests, refer scsi_noretry_cmd().  sdev_ufs_device and sdev_rpmb are
used with pass-through requests.
