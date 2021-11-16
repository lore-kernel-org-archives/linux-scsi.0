Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73771C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 20:16:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 554896138B
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 20:16:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbhKPUTT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Nov 2021 15:19:19 -0500
Received: from mga18.intel.com ([134.134.136.126]:37844 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229543AbhKPUTR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 16 Nov 2021 15:19:17 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10170"; a="220705112"
X-IronPort-AV: E=Sophos;i="5.87,239,1631602800"; 
   d="scan'208";a="220705112"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2021 12:16:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,239,1631602800"; 
   d="scan'208";a="506601881"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.76]) ([10.237.72.76])
  by orsmga008.jf.intel.com with ESMTP; 16 Nov 2021 12:16:15 -0800
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
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <59620452-e5a2-74e1-5971-a5535de3d536@intel.com>
Date:   Tue, 16 Nov 2021 22:16:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <87d8a036-087d-f1fa-19f4-f50c7279170a@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 16/11/2021 18:08, Bart Van Assche wrote:
> On 11/16/21 1:07 AM, Peter Wang wrote:
>> Should we add unmap?
> 
> Hi Peter,
> 
> I will add DMA unmapping code in the abort handler.

I would note that __ufshcd_transfer_req_compl() does that, as well as providing
a matching ufshcd_release() for the ufshcd_hold() in ufshcd_queuecommand(), so
do consider __ufshcd_transfer_req_compl().

Using __ufshcd_transfer_req_compl() seems consistent with the error handler which
uses __ufshcd_transfer_req_compl() via ufshcd_complete_requests(), which will pick
up all the requests that the error handler has just aborted via
ufshcd_try_to_abort_task().  Also ufshcd_host_reset_and_restore() uses
__ufshcd_transfer_req_compl() via ufshcd_complete_requests(), which will pick
up anything still in outstanding_reqs because the doorbell has become zero at
that point.
