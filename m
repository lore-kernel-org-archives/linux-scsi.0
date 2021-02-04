Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B57DAC433DB
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 15:27:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69A1664DF5
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 15:27:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237284AbhBDP1S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Feb 2021 10:27:18 -0500
Received: from mga09.intel.com ([134.134.136.24]:45849 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237248AbhBDPZu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 4 Feb 2021 10:25:50 -0500
IronPort-SDR: 44f/ual3VdHpLTvG9d6Fy322EUPOp8WxG3JOIviZQvTl6Q2TGbAWmycHC+t4LN22QunWgLHCMb
 pgY8qF1Dfj7w==
X-IronPort-AV: E=McAfee;i="6000,8403,9884"; a="181410965"
X-IronPort-AV: E=Sophos;i="5.79,401,1602572400"; 
   d="scan'208";a="181410965"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2021 07:25:04 -0800
IronPort-SDR: SrO7SuHPlHWikYTbmVkiTa5ISyfDiJUSCKwuFoung0M3TjbN4kIAtNn0oR+Sovzcr7MQ6KvNcT
 HFpS9bPOGFJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,401,1602572400"; 
   d="scan'208";a="483274049"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.149]) ([10.237.72.149])
  by fmsmga001.fm.intel.com with ESMTP; 04 Feb 2021 07:25:02 -0800
Subject: Re: [PATCH 3/4] scsi: ufs-debugfs: Add user-defined
 exception_event_mask
To:     Bean Huo <huobean@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
References: <20210119141542.3808-1-adrian.hunter@intel.com>
 <20210119141542.3808-4-adrian.hunter@intel.com>
 <85b6cbb805e97081a676aeb30fe76f059eba192e.camel@gmail.com>
 <b7a812ed-8965-76cf-3d05-be2486fcaed2@intel.com>
 <372c6dbbda18cccdcf2b053ee87f2ada9640e2b8.camel@gmail.com>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <a4102d62-9101-c69d-c030-ec6a6bad7fc7@intel.com>
Date:   Thu, 4 Feb 2021 17:25:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <372c6dbbda18cccdcf2b053ee87f2ada9640e2b8.camel@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/02/21 4:58 pm, Bean Huo wrote:
> On Wed, 2021-02-03 at 11:56 +0200, Adrian Hunter wrote:
>>>
>>> Hallo Adrian
>>
>> Hi Bean
>>
>> Thanks for the review
>>
>>>
>>> Would you like sharing the advantage of this debugfs node comparing
>>> to
>>> sysfs node "attributes/exception_event_control(if it is writable)"?
>>
>> Primarily this is being done as a debug interface, but the user's
>> exception
>> events also need to be kept separate from the driver's ones.
>>
>>> what is the value of this?
>>
>> To be able to determine if the UFS device is being affected by
>> exception events.
>>
>>> Also, now I can disable/enable UFS event over ufs-bsg.
>>
>> That will be overwritten by the driver when it updates the e.g. bkops
>> control, or sometimes also suspend/resume.
> 
> Hi Adrian
> yes, I saw that, they are not tracked by driver.
> 
> I have one question that why "exception_event_mask" cannot represent
> the current QUERY_ATTR_IDN_EE_CONTROL value? only after writing it.

It represents only the user's exception events (ee_usr_mask), not the
driver's ones (ee_drv_mask) as well.  ee_usr_mask is updated after
successfully ensuring it is set on the device.
