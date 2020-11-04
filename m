Return-Path: <SRS0=199q=EK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E574C4741F
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Nov 2020 11:55:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA0142242A
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Nov 2020 11:55:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729779AbgKDLz1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Nov 2020 06:55:27 -0500
Received: from mga07.intel.com ([134.134.136.100]:16707 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726344AbgKDLzX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 4 Nov 2020 06:55:23 -0500
IronPort-SDR: xe5bITMnjVENrTZf90+AISoNj2c1bN9GSGozrbnRZX89AsS5rwX3NEgltRHTR5HQzHH0raOdMa
 1k1k6U1LJJkg==
X-IronPort-AV: E=McAfee;i="6000,8403,9794"; a="233367094"
X-IronPort-AV: E=Sophos;i="5.77,450,1596524400"; 
   d="scan'208";a="233367094"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2020 03:55:21 -0800
IronPort-SDR: n3DiUsFOb2vBYKhrbpImWAcUlbSMM64+uh8Fc3xzbfkHbG7DKDMGYGoYpYfuwn6/fKJXdICuUG
 Dlh/BO/wCrgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,450,1596524400"; 
   d="scan'208";a="538893851"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.94]) ([10.237.72.94])
  by orsmga005.jf.intel.com with ESMTP; 04 Nov 2020 03:55:19 -0800
Subject: Re: [PATCH V4 1/2] scsi: ufs: Add DeepSleep feature
To:     Bean Huo <huobean@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
References: <20201103141403.2142-1-adrian.hunter@intel.com>
 <20201103141403.2142-2-adrian.hunter@intel.com>
 <d00acd2cef07c50de3e19e1b8517c996d67795b2.camel@gmail.com>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <b4178f30-f956-5f33-fd3e-f38b2d99dc1e@intel.com>
Date:   Wed, 4 Nov 2020 13:55:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <d00acd2cef07c50de3e19e1b8517c996d67795b2.camel@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/11/20 12:57 pm, Bean Huo wrote:
> On Tue, 2020-11-03 at 16:14 +0200, Adrian Hunter wrote:
>> DeepSleep is a UFS v3.1 feature that achieves the lowest power
>> consumption
>> of the device, apart from power off.
>>
>> In DeepSleep mode, no commands are accepted, and the only way to exit
>> is
>> using a hardware reset or power cycle.
>>
>> This patch assumes that if a power cycle was an option, then power
>> off
>> would be preferable, so only exit via a hardware reset is supported.
>>
>> Drivers that wish to support DeepSleep need to set a new capability
>> flag
>> UFSHCD_CAP_DEEPSLEEP and provide a hardware reset via the existing
>>  ->device_reset() callback.
>>
>> It is assumed that UFS devices with wspecversion >= 0x310 support
>> DeepSleep.
>>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> ---
>>  Documentation/ABI/testing/sysfs-driver-ufs | 34 +++++++++++--------
>>  drivers/scsi/ufs/ufs-sysfs.c               |  7 ++++
>>  drivers/scsi/ufs/ufs.h                     |  1 +
>>  drivers/scsi/ufs/ufshcd.c                  | 39
>> ++++++++++++++++++++--
>>  drivers/scsi/ufs/ufshcd.h                  | 17 +++++++++-
>>  include/trace/events/ufs.h                 |  3 +-
>>  6 files changed, 83 insertions(+), 18 deletions(-)
>>
>> diff --git a/Documentation/ABI/testing/sysfs-driver-ufs
>> b/Documentation/ABI/testing/sysfs-driver-ufs
>> index adc0d0e91607..e77fa784d6d8 100644
>> --- a/Documentation/ABI/testing/sysfs-driver-ufs
>> +++ b/Documentation/ABI/testing/sysfs-driver-ufs
>> @@ -916,21 +916,24 @@ Date:		September 2014
>>  Contact:	Subhash Jadavani <subhashj@codeaurora.org>
>>  Description:	This entry could be used to set or show the UFS device
>>  		runtime power management level. The current driver
>> -		implementation supports 6 levels with next target
>> states:
>> +		implementation supports 7 levels with next target
>> states:
>>  
>>  		==  ===================================================
>> =
>> -		0   an UFS device will stay active, an UIC link will
>> +		0   UFS device will stay active, UIC link will
>>  		    stay active
>> -		1   an UFS device will stay active, an UIC link will
>> +		1   UFS device will stay active, UIC link will
>>  		    hibernate
>> -		2   an UFS device will moved to sleep, an UIC link will
>> +		2   UFS device will be moved to sleep, UIC link will
>>  		    stay active
>> -		3   an UFS device will moved to sleep, an UIC link will
>> +		3   UFS device will be moved to sleep, UIC link will
>>  		    hibernate
>> -		4   an UFS device will be powered off, an UIC link will
>> +		4   UFS device will be powered off, UIC link will
>>  		    hibernate
>> -		5   an UFS device will be powered off, an UIC link will
>> +		5   UFS device will be powered off, UIC link will
>>  		    be powered off
>> +		6   UFS device will be moved to deep sleep, UIC link
>> +		will be powered off. Note, deep sleep might not be
>> +		supported in which case this value will not be accepted
>>  		==  ===================================================
>> =
>>  
>>  What:		/sys/bus/platform/drivers/ufshcd/*/rpm_target_d
>> ev_state
>> @@ -954,21 +957,24 @@ Date:		September 2014
>>  Contact:	Subhash Jadavani <subhashj@codeaurora.org>
>>  Description:	This entry could be used to set or show the UFS device
>>  		system power management level. The current driver
>> -		implementation supports 6 levels with next target
>> states:
>> +		implementation supports 7 levels with next target
>> states:
>>  
>>  		==  ===================================================
>> =
> 
> Hi Adrian
> There doesn't have these equal sign lines in the sysfs-driver-ufs.
> maybe you should remove these. or add + prefix.

The "=" are from the patch below which is in v5.10-rc2

commit 54a19b4d3fe0fa0a31b46cd60951e8177cac25fa
Author: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Fri Oct 30 08:40:50 2020 +0100

    docs: ABI: cleanup several ABI documents
    
    There are some ABI documents that, while they don't generate
    any warnings, they have issues when parsed by get_abi.pl script
    on its output result.
    
    Address them, in order to provide a clean output.
    
    Reviewed-by: Tom Rix <trix@redhat.com> # for fpga-manager
    Reviewed-By: Kajol Jain<kjain@linux.ibm.com> # for sysfs-bus-event_source-devices-hv_gpci and sysfs-bus-event_source-devices-hv_24x7
    Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com> #for IIO                                                                                                                             
    Acked-by: Oded Gabbay <oded.gabbay@gmail.com> # for Habanalabs                                                                                                                                
    Acked-by: Vaibhav Jain <vaibhav@linux.ibm.com> # for sysfs-bus-papr-pmem                                                                                                                      
    Acked-by: Cezary Rojewski <cezary.rojewski@intel.com> # for catpt                                                                                                                             
    Acked-by: Suzuki K Poulose <suzuki.poulose@arm.com>                                                                                                                                           
    Acked-by: Ilya Dryomov <idryomov@gmail.com> # for rbd                                                                                                                                         
    Acked-by: Jonathan Corbet <corbet@lwn.net>                                                                                                                                                    
    Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>                                                                                                                              
    Link: https://lore.kernel.org/r/5bc78e5b68ed1e9e39135173857cb2e753be868f.1604042072.git.mchehab+huawei@kernel.org                                                                             
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>               

