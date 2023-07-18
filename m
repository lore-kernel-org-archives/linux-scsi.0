Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DC6DEB64DC
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Jul 2023 17:52:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233468AbjGRRwl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Jul 2023 13:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233450AbjGRRwi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Jul 2023 13:52:38 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC405173B
        for <linux-scsi@vger.kernel.org>; Tue, 18 Jul 2023 10:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689702757; x=1721238757;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lyOapdsD3yoK2bVm7BmklkI9MlUnB07yOEx2YZKjfdA=;
  b=A9yW6GPBXHC9pmtOoxuY2WhBl29sUts7ZCoVbDBMCwm/0yheY/WRKB4/
   Nq6J2bqFPJ2cH+D9YAlDJXnTxaT/OwVi4ZAlsVM6xb7EwzOhf1ztrF+fq
   9VSNGNt1GzNSGZ3i4U/AUbaS7lPaDQOiS923c4l67S5e4ZdDI8yiu8m/q
   RIGF7rWJGUlMdCSLqtUW9YEI++t8wdTcojGKONVgdHc1CYgJzVoyxjceI
   isnZgPUjZG04I3BH6n/8f3NGwMaWc1LENp6ojv0QnVHG270LfKDd20wJ7
   xv1m2/iHPG9TYEH8t3urmSUryuuzCV9n7YSrRL41CILbsWcRJ6yevFB98
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="368916808"
X-IronPort-AV: E=Sophos;i="6.01,214,1684825200"; 
   d="scan'208";a="368916808"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2023 10:52:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="753415668"
X-IronPort-AV: E=Sophos;i="6.01,214,1684825200"; 
   d="scan'208";a="753415668"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.251.223.138])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2023 10:52:29 -0700
Message-ID: <0192f661-522f-cd98-1930-b18af70f7b7f@intel.com>
Date:   Tue, 18 Jul 2023 20:52:24 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.13.0
Subject: Re: [PATCH] scsi: ufs: Remove HPB support
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        ChanWoo Lee <cw9316.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Lu Hongfei <luhongfei@vivo.com>,
        Daniil Lunev <dlunev@chromium.org>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Can Guo <quic_cang@quicinc.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Arthur Simchaev <arthur.simchaev@wdc.com>,
        Jens Axboe <axboe@kernel.dk>, Markus Fuchs <mklntf@gmail.com>,
        Po-Wen Kao <powen.kao@mediatek.com>,
        Eric Biggers <ebiggers@google.com>
References: <20230717193827.2001174-1-bvanassche@acm.org>
 <46838112-007a-0245-8026-59e35b6e2415@intel.com>
 <90b1d8d6-dbfe-efcb-45c6-c7d781b846b9@acm.org>
Content-Language: en-US
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <90b1d8d6-dbfe-efcb-45c6-c7d781b846b9@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 18/07/23 16:18, Bart Van Assche wrote:
> On 7/17/23 23:43, Adrian Hunter wrote:
>> On 17/07/23 22:36, Bart Van Assche wrote:
>>> Interest among UFS users in HPB has reduced significantly.
>>
>> Can you say more about why, or give some background?
> 
> Hi Adrian,
> 
> I haven't seen any recent changes in the HPB implementation - neither upstream nor in the Android kernel. That makes me wonder whether there are any HPB users left at all. If there are any HPB users left, it's time for them to speak up. Additionally, the work in JEDEC on a successor for HPB nears completion (Zoned storage for UFS or ZUFS).

That is useful to know, thanks!  I'll leave it to you if you want to expand the commit message a bit or not.

> 
> My motivation for removing the HPB code is that I want to make blk_mq_run_hw_queue() faster if BLK_MQ_F_BLOCKING is set. The patch series I posted (https://lore.kernel.org/linux-block/20230717205216.2024545-1-bvanassche@acm.org/) may cause blk_execute_rq_nowait() to sleep. The HPB code is the only code I am aware of that calls blk_execute_rq_nowait() from a context where it is not allowed to sleep. If the HPB code is removed, I don't have to modify it to make it compatible with the blk_execute_rq_nowait() changes.
> 
> Bart.
> 
> 

