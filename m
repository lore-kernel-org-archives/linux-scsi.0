Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7203C61DA4
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Mar 2023 12:43:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233081AbjCOMnn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Mar 2023 08:43:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232868AbjCOMnW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Mar 2023 08:43:22 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD29A2F1F
        for <linux-scsi@vger.kernel.org>; Wed, 15 Mar 2023 05:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678884124; x=1710420124;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=buKcQ+ws54y1oUW/oqTLL9lJyJkcLjOY/KEY3OM+5d4=;
  b=lcfRfc0QVdbe5J5fALXnNWLcc+dvDMIaVCtK4HNdPZEkSOBPdynjK9U2
   M0u10wNe46aFyY5E9pMui0bMCzogeBP86aKkJ6rMkYjWdU789OS0F5j2L
   3PRJyiuOuGIdy3SyuUzEG772oDhEF191sG2DA36mvP4jt3CdHmWybND4n
   GiCxXNGgupSxkhxDF9UhW6ZWPKbIwXIFruDxNH8L/XAwpGp0pgbjxcE8d
   nYQ6/WS8yfyem6Q+1yRMm+XOTsD/zcQ6KyaX9A+um29Sr+yX7/otoUoll
   CyFwB2mDKEn1qGJucbWP2l0XQxdyQxX2KzbY+AgMRWQocUKIHExbI6tnf
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="335174426"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="335174426"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 05:41:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="679487475"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="679487475"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.251.220.200])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 05:41:43 -0700
Message-ID: <5393e27b-a32f-5a01-cc23-45020b98efa7@intel.com>
Date:   Wed, 15 Mar 2023 14:41:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.0
Subject: Re: [PATCH 1/2] scsi: ufs: core: Disable the reset settle delay
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>
References: <20230314205822.313447-1-bvanassche@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20230314205822.313447-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/03/23 22:58, Bart Van Assche wrote:
> Neither UFS host controllers nor UFS devices require a ten second delay
> after a host reset or after a bus reset. Hence this patch.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Acked-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
>  drivers/ufs/core/ufshcd.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 172d25fef740..ce7b765aa2af 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -8744,6 +8744,7 @@ static struct scsi_host_template ufshcd_driver_template = {
>  	.max_sectors		= (1 << 20) / SECTOR_SIZE, /* 1 MiB */
>  	.max_host_blocked	= 1,
>  	.track_queue_depth	= 1,
> +	.skip_settle_delay	= 1,
>  	.sdev_groups		= ufshcd_driver_groups,
>  	.rpm_autosuspend_delay	= RPM_AUTOSUSPEND_DELAY_MS,
>  };

