Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB4E8C64E8A
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 10:21:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89CF522202
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 10:21:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727875AbgLBKVS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Dec 2020 05:21:18 -0500
Received: from mga17.intel.com ([192.55.52.151]:11190 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726999AbgLBKVR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 2 Dec 2020 05:21:17 -0500
IronPort-SDR: /2VZTNvg07CkGomuxFZxitSx1EP3D86Ux18t87HJJTYGg7dVGludhkoUyajKpLqxtWI1t4Qa/+
 Q0MxU8nypzWw==
X-IronPort-AV: E=McAfee;i="6000,8403,9822"; a="152821040"
X-IronPort-AV: E=Sophos;i="5.78,386,1599548400"; 
   d="scan'208";a="152821040"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2020 02:20:36 -0800
IronPort-SDR: usmZG6ykcOge6j+qtpi+/AmT7L0AXlqzuqIbYqemdNdLlFUJlTiJl5ooTETocVtz/JPXYtBe2U
 Z7G8CvCkmxLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,386,1599548400"; 
   d="scan'208";a="537934763"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.94]) ([10.237.72.94])
  by fmsmga006.fm.intel.com with ESMTP; 02 Dec 2020 02:20:35 -0800
Subject: Re: [PATCH] docs: ABI: sysfs-driver-ufs: Add DeepSleep power mode
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     linux-doc@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
References: <20201106153615.13033-1-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <fc4a5df4-8913-474c-07c0-1daf71750e8a@intel.com>
Date:   Wed, 2 Dec 2020 12:20:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201106153615.13033-1-adrian.hunter@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/11/20 5:36 pm, Adrian Hunter wrote:
> A patch for DeepSleep is in the scsi queue, but as per mkp:
> 
> 	I left out the sysfs ABI piece due to the conflicts.
> 	I suggest you send that piece through the doc tree.
> 
> Ergo this patch.
> 
> Link: https://lore.kernel.org/r/yq1imaksb3g.fsf@ca-mkp.ca.oracle.com/
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

Will anyone apply this?

> ---
>  Documentation/ABI/testing/sysfs-driver-ufs | 34 +++++++++++++---------
>  1 file changed, 20 insertions(+), 14 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
> index adc0d0e91607..e77fa784d6d8 100644
> --- a/Documentation/ABI/testing/sysfs-driver-ufs
> +++ b/Documentation/ABI/testing/sysfs-driver-ufs
> @@ -916,21 +916,24 @@ Date:		September 2014
>  Contact:	Subhash Jadavani <subhashj@codeaurora.org>
>  Description:	This entry could be used to set or show the UFS device
>  		runtime power management level. The current driver
> -		implementation supports 6 levels with next target states:
> +		implementation supports 7 levels with next target states:
>  
>  		==  ====================================================
> -		0   an UFS device will stay active, an UIC link will
> +		0   UFS device will stay active, UIC link will
>  		    stay active
> -		1   an UFS device will stay active, an UIC link will
> +		1   UFS device will stay active, UIC link will
>  		    hibernate
> -		2   an UFS device will moved to sleep, an UIC link will
> +		2   UFS device will be moved to sleep, UIC link will
>  		    stay active
> -		3   an UFS device will moved to sleep, an UIC link will
> +		3   UFS device will be moved to sleep, UIC link will
>  		    hibernate
> -		4   an UFS device will be powered off, an UIC link will
> +		4   UFS device will be powered off, UIC link will
>  		    hibernate
> -		5   an UFS device will be powered off, an UIC link will
> +		5   UFS device will be powered off, UIC link will
>  		    be powered off
> +		6   UFS device will be moved to deep sleep, UIC link
> +		will be powered off. Note, deep sleep might not be
> +		supported in which case this value will not be accepted
>  		==  ====================================================
>  
>  What:		/sys/bus/platform/drivers/ufshcd/*/rpm_target_dev_state
> @@ -954,21 +957,24 @@ Date:		September 2014
>  Contact:	Subhash Jadavani <subhashj@codeaurora.org>
>  Description:	This entry could be used to set or show the UFS device
>  		system power management level. The current driver
> -		implementation supports 6 levels with next target states:
> +		implementation supports 7 levels with next target states:
>  
>  		==  ====================================================
> -		0   an UFS device will stay active, an UIC link will
> +		0   UFS device will stay active, UIC link will
>  		    stay active
> -		1   an UFS device will stay active, an UIC link will
> +		1   UFS device will stay active, UIC link will
>  		    hibernate
> -		2   an UFS device will moved to sleep, an UIC link will
> +		2   UFS device will be moved to sleep, UIC link will
>  		    stay active
> -		3   an UFS device will moved to sleep, an UIC link will
> +		3   UFS device will be moved to sleep, UIC link will
>  		    hibernate
> -		4   an UFS device will be powered off, an UIC link will
> +		4   UFS device will be powered off, UIC link will
>  		    hibernate
> -		5   an UFS device will be powered off, an UIC link will
> +		5   UFS device will be powered off, UIC link will
>  		    be powered off
> +		6   UFS device will be moved to deep sleep, UIC link
> +		will be powered off. Note, deep sleep might not be
> +		supported in which case this value will not be accepted
>  		==  ====================================================
>  
>  What:		/sys/bus/platform/drivers/ufshcd/*/spm_target_dev_state
> 

