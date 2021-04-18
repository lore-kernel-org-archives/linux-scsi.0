Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB10CC433B4
	for <linux-scsi@archiver.kernel.org>; Sun, 18 Apr 2021 17:51:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C68B1610EA
	for <linux-scsi@archiver.kernel.org>; Sun, 18 Apr 2021 17:51:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232479AbhDRRv5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 18 Apr 2021 13:51:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:27417 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229783AbhDRRvz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 18 Apr 2021 13:51:55 -0400
IronPort-SDR: ZlSbyQ6zrqlLlTiCLvcB+NK7wS/zxv1B6AkgtkEHRlMYw5++3ywuJcsSfemVrOCxsCquOlATIm
 7pYX/SVhPfRg==
X-IronPort-AV: E=McAfee;i="6200,9189,9958"; a="182365273"
X-IronPort-AV: E=Sophos;i="5.82,232,1613462400"; 
   d="scan'208";a="182365273"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2021 10:51:25 -0700
IronPort-SDR: zSd+fLIuQFKo/U1wfd8IDTq8CI+947dtrdK8O0hi9ecBrpM2effepD/3f2kBAGExIPvQLkqDqv
 iGYb5DvUwBpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,232,1613462400"; 
   d="scan'208";a="419737749"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.174]) ([10.237.72.174])
  by fmsmga008.fm.intel.com with ESMTP; 18 Apr 2021 10:51:22 -0700
Subject: Re: [PATCH] scsi: ufs: Check for bkops in runtime suspend
To:     Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Alex Lemberg <alex.lemberg@wdc.com>
References: <20210418072150.3288-1-avri.altman@wdc.com>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <2b66db28-2caa-8121-342d-c95c23412876@intel.com>
Date:   Sun, 18 Apr 2021 20:51:38 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210418072150.3288-1-avri.altman@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 18/04/21 10:21 am, Avri Altman wrote:
> The UFS driver allowed BKOPS and WB Flush operations to be completed on
> Runtime suspend. Adding the DeepSleep support, this is no longer true:
> the driver will ignore BKOPS and WB Flush states, and force a link state
> transition to UIC_LINK_OFF_STATE.
> 
> Do not ignore BKOPS and WB Flush on runtme suspend flow.
> 
> fixes: fe1d4c2ebcae (scsi: ufs: Add DeepSleep feature)
> 
> Suggested-by: Alex Lemberg <alex.lemberg@wdc.com>
> Signed-off-by: Avri Altman <avri.altman@wdc.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 58d7f264c664..1a0cac670aba 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -8755,7 +8755,8 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>  	 * In the case of DeepSleep, the device is expected to remain powered
>  	 * with the link off, so do not check for bkops.
>  	 */
> -	check_for_bkops = !ufshcd_is_ufs_dev_deepsleep(hba);
> +	check_for_bkops = !ufshcd_is_ufs_dev_deepsleep(hba) ||
> +			  hba->dev_info.b_rpm_dev_flush_capable;

Can you explain this some more? If hba->dev_info.b_rpm_dev_flush_capable
is true, then ufshcd_set_dev_pwr_mode() was not called, so
ufshcd_is_ufs_dev_deepsleep() is false i.e. the same result for the
condition above.

However, it is assumed DeepSleep has the link off so that a full reset
and restore is done upon resume, which is necessary to exit DeepSleep.
So if you wanted to have DeepSleep with the link on, then the resume
logic would also need changes.

>  	ret = ufshcd_link_state_transition(hba, req_link_state, check_for_bkops);
>  	if (ret)
>  		goto set_dev_active;
> 

