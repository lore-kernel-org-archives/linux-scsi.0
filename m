Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E818AC433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 14:38:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB40F206E5
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 14:38:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389292AbhASOiB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jan 2021 09:38:01 -0500
Received: from mga01.intel.com ([192.55.52.88]:46234 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389261AbhASKCX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Jan 2021 05:02:23 -0500
IronPort-SDR: T6sK1g08LkbFLJzdSfpTw3p9YLG3N0XsKCTGQ1k6RyPBHTA+7M2OcpK3D5hCJqsCPelW6XOKu9
 8z/ay9RILxgQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9868"; a="197606669"
X-IronPort-AV: E=Sophos;i="5.79,358,1602572400"; 
   d="scan'208";a="197606669"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2021 02:00:10 -0800
IronPort-SDR: YdqSs5Psq+23YLCpXN6FumFnhAAHgaRxKZ2jG/c1XZ2oRMo/e+avm521ANqo5It3JJVgMutKMw
 yQoVZJ32nHNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,358,1602572400"; 
   d="scan'208";a="391042310"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.149]) ([10.237.72.149])
  by orsmga007.jf.intel.com with ESMTP; 19 Jan 2021 02:00:06 -0800
Subject: Re: [PATCH v6 1/6] scsi: ufs: Add "wb_on" sysfs node to control WB
 on/off
To:     Bean Huo <huobean@gmail.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210118201039.2398-1-huobean@gmail.com>
 <20210118201039.2398-2-huobean@gmail.com>
 <0a9971aa-e508-2aaa-1379-fb898471a252@intel.com>
 <fabf0e83387f6155efea521a15b00bb1225d35a4.camel@gmail.com>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <9ad2cf1a-68df-47ef-9fe7-01954d2d6181@intel.com>
Date:   Tue, 19 Jan 2021 12:00:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <fabf0e83387f6155efea521a15b00bb1225d35a4.camel@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 19/01/21 11:33 am, Bean Huo wrote:
> On Tue, 2021-01-19 at 09:01 +0200, Adrian Hunter wrote:
>> On 18/01/21 10:10 pm, Bean Huo wrote:
>>> From: Bean Huo <beanhuo@micron.com>
>>>
>>> Currently UFS WriteBooster driver uses clock scaling up/down to set
>>> WB on/off, for the platform which doesn't support
>>> UFSHCD_CAP_CLK_SCALING,
>>> WB will be always on. Provide a sysfs attribute to enable/disable
>>> WB
>>> during runtime. Write 1/0 to "wb_on" sysfs node to enable/disable
>>> UFS WB.
>>
>> Is it so, that after a full reset, WB is always enabled again?  Is
>> that
>> intended?
> 
> Hello Adrian
> Good questions. yes, after a full reset, the UFS device side by default
> is wb disabled,  then WB will be always enabled agaion in
> ufshcd_wb_config(hba). but, for the platform which
> supports UFSHCD_CAP_CLK_SCALING, wb will be disabled again while clk
> scaling down and enabled while clk scaling up.
> 
> Regarding the last question, I think OEM wants to do that. maybe they
> suppose there will be a lot of writing after reset?? From the UFS
> device's point of view, the control of WB is up to the user.

If it is by design enabled after reset, then perhaps it should be mentioned
in the sysfs documentation.
