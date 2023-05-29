Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FCC3C77B7A
	for <linux-scsi@archiver.kernel.org>; Mon, 29 May 2023 06:21:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbjE2GV0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 May 2023 02:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbjE2GVZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 May 2023 02:21:25 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2EC7B5
        for <linux-scsi@vger.kernel.org>; Sun, 28 May 2023 23:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685341284; x=1716877284;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mht4Cta/6F/deHf8ctn7Q/Hc0B5lk1dtTyh/RIEOK3Y=;
  b=M92QWvG+Z4XoIE3ZbsVsyt9eBpLrCBJdHONGIiSgU+1nBrLGtnyHabcS
   EHf4zywhSSw1nrs+sPcUnSDXIwxx6Rk1Mk1kDzcVGjeiXUWe8FX0euo55
   VrqyRvYO7EVVEwxt3Cxf5ZtuAhXevSKLs+0Hxd28x7yVNIhXMPzfF4Dqv
   Y5Cl/SwDIAyQ9yhAStt8BVz8yA+eQIrx0ChvKMYrAp7Bs4hv5FcIgbyE4
   rtvSc8hYf3kKXBYRLsdVJXZkRat5xOLLnKR8mkIuyZeUv60K8w9Nhpz1U
   rLr//QXtNWByIxmbykaB4wNwMvCyW6HFrF95yIBzKFbrQf0u0xBvYf2Fd
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="357012247"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="357012247"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 23:21:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="656379220"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="656379220"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.251.208.110])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 23:21:03 -0700
Message-ID: <820aa9bc-f752-ff3e-ef1f-8037dba51848@intel.com>
Date:   Mon, 29 May 2023 09:20:59 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.11.0
Subject: Re: [PATCH v2 3/4] scsi: ufs: Enable the BLK_MQ_F_BLOCKING flag
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20230517222359.1066918-1-bvanassche@acm.org>
 <20230517222359.1066918-4-bvanassche@acm.org>
 <957fb6d6-83db-6230-d81c-646e12ed7bf1@intel.com>
 <343be0eb-0650-cc5e-3154-ffe30f92c17d@acm.org>
 <cac55dea-ec77-2802-f975-89a1cb1c734f@intel.com>
 <2d37028b-c7a1-f2ac-abb5-e85c00aceba2@acm.org>
 <096e1a7e-ea0d-de46-ef82-02a755635640@intel.com>
 <6112c17a-15f3-4517-c73f-8cbbdde20a6b@acm.org>
 <182cc063-e897-cd7d-d859-809da0e4fc2d@intel.com>
 <13c4abf1-19e0-190c-4c2f-543243955986@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <13c4abf1-19e0-190c-4c2f-543243955986@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 26/05/23 20:27, Bart Van Assche wrote:
> On 5/26/23 00:11, Adrian Hunter wrote:
>> Why would we want to when we don't have to?
> 
> Anyone is allowed to formulate objections to a patch but when objecting to a patch or an approach please explain *why*. I think I already explained that unconditionally enabling BLK_MQ_F_BLOCKING makes testing the UFS host controller driver easier.

I don't think you are claiming blocking queues are better for block drivers than non-blocking queues, so it is quite reasonable to stay with non-blocking queues.

I am not sure testing is really relevant to this discussion, but it seems like different combinations need to be tested anyway e.g. testing with / without clock gating is the same testing with / without blocking.

> 
>> So with those fixed and the vops->may_block instead of vops->nonblocking:
> 
> [ ... ]
> 
> I think a much simpler solution exists. I plan to post a new version of this patch series soon.

Thank you!

