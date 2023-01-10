Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D46DEC54EBE
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Jan 2023 08:06:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbjAJIG0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Jan 2023 03:06:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238031AbjAJH46 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jan 2023 02:56:58 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D517373BE
        for <linux-scsi@vger.kernel.org>; Mon,  9 Jan 2023 23:56:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673337408; x=1704873408;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=JXV5oTDhDkk1fDYT8zKVDyr1ndIwsA69DNr+9yQOPdo=;
  b=McKamBmhdmJCm0NVxoGNwRpM/BckaQplHZ6tyrwkvukJxsTle5fcxFG7
   IM1wOCidVYkqvsghn2hovo0f0pbj0EzBSs+gsWiByulZxSYVwoiyJHcve
   ju6xmkQjQfYLkxXdU3/78BEVZpp2nmkXrl5H22DZsoYJgqhQLccte+18P
   LO8y8oIT1OidvRsYWCI1XtP2H+DkhgBntxxXc0lTxWbZOdFGZJSDl2nzm
   SToI/YXQa+b5P5J2m7ApSKBuHLF4XY7zk2EezWzKvkrYq11nBS0KLUZGi
   mmOi2q5jdLpoUVKaMWEmVxLS+C8ZlOCaXd6gVmgSd+aIG6wLwdgJ3Wu1t
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="320781851"
X-IronPort-AV: E=Sophos;i="5.96,314,1665471600"; 
   d="scan'208";a="320781851"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 23:56:47 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="780983224"
X-IronPort-AV: E=Sophos;i="5.96,314,1665471600"; 
   d="scan'208";a="780983224"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.251.221.1])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 23:56:44 -0800
Message-ID: <56f36c02-bc04-0587-2980-d28b7b75394f@intel.com>
Date:   Tue, 10 Jan 2023 09:56:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.6.1
Subject: Re: [PATCH 3/3] scsi: ufs: Enable DMA clustering
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
References: <20230106215800.2249344-1-bvanassche@acm.org>
 <20230106215800.2249344-4-bvanassche@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20230106215800.2249344-4-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/01/23 23:58, Bart Van Assche wrote:
> All UFS host controllers support DMA clustering. Hence enable DMA
> clustering.

The patch history of ufshcd.c seems to suggest the dma_boundary
setting was never intentional, but was inherited by default.

However, I guess it is not impossible that removing the setting
exposes issues for existing controllers.

I suggest perhaps expanding upon the commit message and the
cc list so more people will be aware of the change.

Possibly worth including the explanation in your reply to
Avri concerning PRDT 256K DBC limit

> 
> Note: without patch "Exynos: Fix the maximum segment size", this patch
> breaks support for the Exynos controller.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Otherwise:

Acked-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
>  drivers/ufs/core/ufshcd.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index be18edf4ef7f..fe83fdda8d23 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -8429,7 +8429,6 @@ static struct scsi_host_template ufshcd_driver_template = {
>  	.max_host_blocked	= 1,
>  	.track_queue_depth	= 1,
>  	.sdev_groups		= ufshcd_driver_groups,
> -	.dma_boundary		= PAGE_SIZE - 1,
>  	.rpm_autosuspend_delay	= RPM_AUTOSUSPEND_DELAY_MS,
>  };
>  

