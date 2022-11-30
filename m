Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB029C352A1
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Nov 2022 10:17:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235698AbiK3KRg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Nov 2022 05:17:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235624AbiK3KRd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Nov 2022 05:17:33 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FBA2E81
        for <linux-scsi@vger.kernel.org>; Wed, 30 Nov 2022 02:17:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669803453; x=1701339453;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=bByuVskl/8XPlxn6hYxVCcRye/G/AXccEKig7foijVg=;
  b=SbmU9Pp2kskjckLFZGrMHvvi2NIc+EDw6n2bfoMzFmA9Fv6jzViay0Uq
   NrUCn5V/Yk5R0w2Fpb7HbDYnV7JP3nP+VwxviB30+csHmM7r/yfDWMSsq
   GK/cI8FdyJ3wTqp+qmjQMDgtFFrZzU3n5TwHR4Bz88+LND/kENDYosDc+
   lTsCcnHswmOW+V5HmUdndfsaMsnjBRCmbTGsCZ/UDYcrKEZ/H8Lrs18vt
   /sQ9LoQ4dyEqWtsVzU7qcMHfzgRzU01eJ85tAeti8FIFeWqfRiQnTWBt6
   Rr7A48xb9noWtTbkKKQlZboEAV0SpsCXm2I04mhNQG/6eLgMVs5a1Lt/C
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="401639914"
X-IronPort-AV: E=Sophos;i="5.96,206,1665471600"; 
   d="scan'208";a="401639914"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 02:17:13 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="594612031"
X-IronPort-AV: E=Sophos;i="5.96,206,1665471600"; 
   d="scan'208";a="594612031"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.53.75])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 02:17:08 -0800
Message-ID: <98bfafd3-c7b7-89b5-497a-aa694d0152dd@intel.com>
Date:   Wed, 30 Nov 2022 12:17:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.0
Subject: Re: [PATCH v1] ufs: core: wlun suspend SSU fail recovery
Content-Language: en-US
To:     peter.wang@mediatek.com, stanley.chu@mediatek.com,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com,
        tun-yu.yu@mediatek.com, eddie.huang@mediatek.com,
        naomi.chu@mediatek.com
References: <20221101142410.31463-1-peter.wang@mediatek.com>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20221101142410.31463-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/11/22 16:24, peter.wang@mediatek.com wrote:
> From: Peter Wang <peter.wang@mediatek.com>
> 
> When SSU fail in wlun suspend flow, trigger error handlder and

handlder -> handler

Why / how does SSU fail?

> return busy to break the suspend.
> If not, wlun runtime pm status become error and the consumer will
> stuck in runtime suspend status.
> 
> Signed-off-by: Peter Wang <peter.wang@mediatek.com>
> ---
>  drivers/ufs/core/ufshcd.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index b1f59a5fe632..2f2d3d5d8684 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -8970,6 +8970,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>  	enum ufs_pm_level pm_lvl;
>  	enum ufs_dev_pwr_mode req_dev_pwr_mode;
>  	enum uic_link_state req_link_state;
> +	unsigned long flags;
>  
>  	hba->pm_op_in_progress = true;
>  	if (pm_op != UFS_SHUTDOWN_PM) {
> @@ -9049,8 +9050,21 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>  
>  		if (!hba->dev_info.b_rpm_dev_flush_capable) {
>  			ret = ufshcd_set_dev_pwr_mode(hba, req_dev_pwr_mode);
> -			if (ret)
> +			if (ret) {
> +				/*
> +				 * If retrun err in suspend flow, IO will hang.

retrun -> return

> +				 * Trigger error handler and break suspend for
> +				 * error recovery.
> +				 */
> +				spin_lock_irqsave(hba->host->host_lock, flags);
> +				hba->force_reset = true;
> +				ufshcd_schedule_eh_work(hba);

__ufshcd_wl_suspend() is also used for shutdown and poweroff
where scheduling EH is not appropriate.

> +				spin_unlock_irqrestore(hba->host->host_lock,
> +					flags);
> +
> +				ret = -EBUSY;
>  				goto enable_scaling;
> +			}
>  		}
>  	}
>  

