Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 032ECC433DB
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 09:57:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD8EC64DD4
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 09:57:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233563AbhBCJ4q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Feb 2021 04:56:46 -0500
Received: from mga07.intel.com ([134.134.136.100]:58110 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233258AbhBCJ4p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 3 Feb 2021 04:56:45 -0500
IronPort-SDR: UEv0RG4URBHY/0NinJ8F1mes+OEP2z7p9qTXIGC4/9Z3VrThqsOyIHqP7RRjQmxFJ606ZbLP0A
 q9MDxSQoInJA==
X-IronPort-AV: E=McAfee;i="6000,8403,9883"; a="245091943"
X-IronPort-AV: E=Sophos;i="5.79,398,1602572400"; 
   d="scan'208";a="245091943"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 01:56:04 -0800
IronPort-SDR: QqnlqYDVHUZjs0LoFZMwWUmT6jR5sxhZc/T0rKHXfyGP0jPNcdxArOeq12BlhBgeC0ZWv8UWlp
 fPHVeB2Oop7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,398,1602572400"; 
   d="scan'208";a="372319185"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.149]) ([10.237.72.149])
  by orsmga002.jf.intel.com with ESMTP; 03 Feb 2021 01:56:01 -0800
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
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <b7a812ed-8965-76cf-3d05-be2486fcaed2@intel.com>
Date:   Wed, 3 Feb 2021 11:56:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <85b6cbb805e97081a676aeb30fe76f059eba192e.camel@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/02/21 11:45 am, Bean Huo wrote:
> On Tue, 2021-01-19 at 16:15 +0200, Adrian Hunter wrote:
>> Allow users to enable specific exception events via debugfs.
>>
>> The bits enabled by the driver ee_drv_ctrl are separated from the
>> bits
>> enabled by the user ee_usr_ctrl. The control mask ee_mask_ctrl is the
>> logical-or of those two. A mutex is needed to ensure that the masks
>> match
>> what was written to the device.
> 
> Hallo Adrian

Hi Bean

Thanks for the review

> 
> Would you like sharing the advantage of this debugfs node comparing to
> sysfs node "attributes/exception_event_control(if it is writable)"?

Primarily this is being done as a debug interface, but the user's exception
events also need to be kept separate from the driver's ones.

> what is the value of this?

To be able to determine if the UFS device is being affected by exception events.

> Also, now I can disable/enable UFS event over ufs-bsg.

That will be overwritten by the driver when it updates the e.g. bkops
control, or sometimes also suspend/resume.
