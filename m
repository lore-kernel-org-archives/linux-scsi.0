Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEE59C4361B
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 12:18:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A6B12395C
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 12:18:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgLRMSh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Dec 2020 07:18:37 -0500
Received: from mga12.intel.com ([192.55.52.136]:27540 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726302AbgLRMSg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Dec 2020 07:18:36 -0500
IronPort-SDR: Fj4AbmTTNxQGwc8rIBv6wb92262VWvp62Lf0+SiBELwE1eKoYeTpEWYtn21fY+R4Ywt5OHMdln
 ZL1RI07YGS4g==
X-IronPort-AV: E=McAfee;i="6000,8403,9838"; a="154649968"
X-IronPort-AV: E=Sophos;i="5.78,430,1599548400"; 
   d="scan'208";a="154649968"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2020 04:17:55 -0800
IronPort-SDR: CI7T4Mc/wwjGjgrH41gmusgfz+mTt7V2JowBNBib61rwCWgYV6YTO22977jfq8DxdRHptNhNLb
 PPnl/0BY/QoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,430,1599548400"; 
   d="scan'208";a="413986866"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.94]) ([10.237.72.94])
  by orsmga001.jf.intel.com with ESMTP; 18 Dec 2020 04:17:53 -0800
Subject: Re: [PATCH V2] scsi: ufs-debugfs: Add error counters
To:     Bean Huo <huobean@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
References: <20201216185145.25800-1-adrian.hunter@intel.com>
 <920b01c29525ff1cf894a2cf9c809750533ddc13.camel@gmail.com>
 <750889b4-19b7-3c0b-c614-a8dddc2dcab2@intel.com>
 <fbb752c30a921f251b7df130c942e20548ca0997.camel@gmail.com>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <ec6d7b02-759b-2c9d-df6e-129a09fded1b@intel.com>
Date:   Fri, 18 Dec 2020 14:17:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <fbb752c30a921f251b7df130c942e20548ca0997.camel@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 18/12/20 12:57 am, Bean Huo wrote:
> On Thu, 2020-12-17 at 11:49 +0200, Adrian Hunter wrote:
>>>
>>> The purpose of patch is acceptable, but I don't know why you choose
>>> using ufshcd_core_* here. 
>>
>> Do you mean you would like a different function name?  'ufshcd_init'
>> is used
>> already.  The module is called ufshcd-core, so ufshcd_core_* seems
>> appropriate.
>>
>>> Also. I don't know if module_init()  is a proper way here.
>>
>> Can you be more specific?  It is normal to do module initialization
>> in
>> module_init().
> 
> Hi Adrian
> My concern that ufs_debugfs_init() is called in module_init(), but your
> another debugfs initialization function ufs_debugfs_hba_init(hba)
> called in the UFS host probe path. 

It is a good question, but module dependencies and initcall ordering means
that won't happen.  It is not unusual for modules to do initialization in
this way, that is completed before dependent modules initialize.

> 
> If these two (module_init() and module_platform_driver())
> initializaiton sequence always as your expectation: ufs_debugfs_init()-
> ->ufs_debugfs_hba_init(), that is fine, otherwise, it is better just
> group them, make it simpler.

Unfortunately, doing it that way, calls to debugsfs_create_dir("ufshcd",
NULL) could race. Losers of the race will get an error, and will not get the
dentry they need to proceed.  Preventing the race would require adding a
mutex.  So the other way is simpler.
