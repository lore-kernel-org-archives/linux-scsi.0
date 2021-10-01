Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BAAAC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Oct 2021 08:16:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28E66615A4
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Oct 2021 08:16:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbhJAIRs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Oct 2021 04:17:48 -0400
Received: from mga12.intel.com ([192.55.52.136]:56621 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231126AbhJAIRs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 1 Oct 2021 04:17:48 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10123"; a="204855450"
X-IronPort-AV: E=Sophos;i="5.85,337,1624345200"; 
   d="scan'208";a="204855450"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2021 01:16:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,337,1624345200"; 
   d="scan'208";a="556188573"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.76]) ([10.237.72.76])
  by FMSMGA003.fm.intel.com with ESMTP; 01 Oct 2021 01:16:00 -0700
Subject: Re: [PATCH V6 1/3] scsi: ufs: Fix error handler clear ua deadlock
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Wei Li <liwei213@huawei.com>, linux-scsi@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>
References: <20210930124224.114031-1-adrian.hunter@intel.com>
 <20210930124224.114031-2-adrian.hunter@intel.com>
 <9e8ecb60-dc1b-2fd7-3ae4-bfa720f98769@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <de4ebba5-7030-3cfb-280b-1389cea65696@intel.com>
Date:   Fri, 1 Oct 2021 11:15:48 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <9e8ecb60-dc1b-2fd7-3ae4-bfa720f98769@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 01/10/2021 01:10, Bart Van Assche wrote:
> On 9/30/21 5:42 AM, Adrian Hunter wrote:
>> There is no guarantee to be able to enter the queue if requests are
>> blocked. That is because freezing the queue will block entry to the
>> queue, but freezing also waits for outstanding requests which can make
>> no progress while the queue is blocked.
>>
>> That situation can happen when the error handler issues requests to
>> clear unit attention condition. Requests are blocked if the ufshcd_state is
>> UFSHCD_STATE_EH_SCHEDULED_FATAL, which can happen as a result of
>> prior error handler activity. Requests cannot make progress when
>> ufshcd_state is UFSHCD_STATE_EH_SCHEDULED_FATAL, and only the error
>> handler can change that, so if the error handler is waiting to enter
>> the queue and blk_mq_freeze_queue() is waiting for outstanding requests,
>> they will deadlock.
>>
>> Fix by issuing REQUEST_SENSE directly avoiding the SCSI queues, in
>> a similar fashion as other device commands.
> 
> Hi Adrian,
> 
> Although I appreciate all the work that you have done on this patch, there
> is at least one application (the Android Trusty software) that needs the
> RPMB unit attention information to work correctly. Hence my request to drop
> this patch and to integrate the following patch series in the upstream kernel:
> https://lore.kernel.org/linux-scsi/aacbec00-34e8-f082-51a5-15391bf99710@acm.org/T/#t

That's fine.  It is always good to have options.

I made a couple of minor comments on the patch series.
