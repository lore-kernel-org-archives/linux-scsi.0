Return-Path: <SRS0=3mnS=DM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD37AC4363A
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 08:43:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6E1B2064C
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 08:43:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbgJEIn7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Oct 2020 04:43:59 -0400
Received: from mga17.intel.com ([192.55.52.151]:5278 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbgJEIn7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 5 Oct 2020 04:43:59 -0400
IronPort-SDR: bQE38C7bVAUMiR2Go6ZAybrDCxmjtsYVgxqFMlFGeo4chf8sKWwB0kg4nxuIuuzQRecGo0iWti
 dVb3Ctn4q8ZQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9764"; a="143346184"
X-IronPort-AV: E=Sophos;i="5.77,338,1596524400"; 
   d="scan'208";a="143346184"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2020 01:43:53 -0700
IronPort-SDR: ELbU7QIRQy4Z7gFsvS+hT+aZWXMh5TrQhcyxJo6tWcYJuAVc2aDlpp5IBBmksRNz76pUT0cERv
 VpKT+B4pLFzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,338,1596524400"; 
   d="scan'208";a="516649662"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.190]) ([10.237.72.190])
  by fmsmga005.fm.intel.com with ESMTP; 05 Oct 2020 01:43:50 -0700
Subject: Re: [PATCH 1/2] scsi: ufs: Add DeepSleep feature
To:     Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>
References: <20201002124043.25394-1-adrian.hunter@intel.com>
 <20201002124043.25394-2-adrian.hunter@intel.com>
 <BY5PR04MB67054C67CCA53AB5FC5CBCFAFC0C0@BY5PR04MB6705.namprd04.prod.outlook.com>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <a3cd3d32-0dcf-ebaf-d6fe-e8f21539dff1@intel.com>
Date:   Mon, 5 Oct 2020 11:43:15 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <BY5PR04MB67054C67CCA53AB5FC5CBCFAFC0C0@BY5PR04MB6705.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/10/20 11:02 am, Avri Altman wrote:
> HI,
> 
>> Drivers that wish to support DeepSleep need to set a new capability flag
>> UFSHCD_CAP_DEEPSLEEP and provide a hardware reset via the existing
>>  ->device_reset() callback.
> I would expect that this capability controls sending SSU 4, but it only controls the sysfs entry?

The sysfs entry is the only way to request DeepSleep.

> 
>>
>> It is assumed that UFS devices with wspecversion >= 0x310 support
>> DeepSleep.
>>
>> The UFS specification says to set the IMMED (immediate) flag for the
>> Start/Stop Unit command when entering DeepSleep. However some UFS
>> devices object to that, which is addressed in a subsequent patch.
> After failing to understand what the proper behavior should be with respect of the IMMED bit,
> Although I read the applicable section few time, I gave up and consult our system guy,
> Which is our jedec representative.  This is his answer:
> "...
> In order to avoid uncertainty - the host need to set IMMED bit to '0' (this is explicitly specified by the standard).
> The device responds only after it switches to Pre-DeepSleep state. The host then switch to H8 and this would trigger the device to transition to DeepSleep state.
> ..."
> 
> So maybe the 2nd patch isn't really needed. 

Yes I managed to get it the wrong way around!  I will drop patch 2 and send
V2 of patch 1 in due course.
