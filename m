Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 097A6C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 15:43:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0B1B610E6
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 15:43:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbhJTPpi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 11:45:38 -0400
Received: from mga17.intel.com ([192.55.52.151]:10076 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229570AbhJTPph (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Oct 2021 11:45:37 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10143"; a="209603976"
X-IronPort-AV: E=Sophos;i="5.87,167,1631602800"; 
   d="scan'208";a="209603976"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2021 08:33:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,167,1631602800"; 
   d="scan'208";a="491315850"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.76]) ([10.237.72.76])
  by fmsmga007.fm.intel.com with ESMTP; 20 Oct 2021 08:33:12 -0700
Subject: Re: [PATCH RESEND v2] scsi: ufs: clear doorbell for hibern8 errors
 when using ah8
To:     Kiwoong Kim <kwmad.kim@samsung.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        cang@codeaurora.org, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com,
        vkumar.1997@samsung.com
References: <CGME20211019051346epcas2p132d3b9c6a1c812f3132e913525235b83@epcas2p1.samsung.com>
 <1634619427-171880-1-git-send-email-kwmad.kim@samsung.com>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <2e35d23b-babb-a617-d93e-ce9b522dafb3@intel.com>
Date:   Wed, 20 Oct 2021 18:33:11 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <1634619427-171880-1-git-send-email-kwmad.kim@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 19/10/2021 07:57, Kiwoong Kim wrote:
> Changes from v1:
> * Change the time to requeue pended commands
> 
> When an scsi command is dispatched right after host complete
> all the pended requests and ufs driver tries to ring a doorbell,
> host might be still during entering into hibern8.
> If the hibern8 error occurrs during that period, the doorbell
> might not be zero and clearing it should have done.
> But, current ufshcd_err_handler goes directly to reset
> w/o clearing the doorbell when the driver's link state is broken.

So you mean HCE 1->0 does not clear the doorbell register?

> This patch is to requeue pended commands after host reset.

So you mean HCE 0->1 does clear the doorbell register?

> 
> Here's an actual symptom that I've faced. At the time, tag #17
> is still pended even after host reset. And then the block timer
> is expired.
> 
> exynos-ufs 11100000.ufs: ufshcd_check_errors: Auto Hibern8
> Enter failed - status: 0x00000040, upmcrs: 0x00000001
> ..
> host_regs: 00000050: b8671000 00000008 00020000 00000000
> ..
> exynos-ufs 11100000.ufs: ufshcd_abort: Device abort task at tag 17
> 
> Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 9faf02c..e5d4ef7 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -7136,8 +7136,10 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
>  	err = ufshcd_hba_enable(hba);
>  
>  	/* Establish the link again and restore the device */
> -	if (!err)
> +	if (!err) {
> +		ufshcd_retry_aborted_requests(hba);
>  		err = ufshcd_probe_hba(hba, false);
> +	}
>  
>  	if (err)
>  		dev_err(hba->dev, "%s: Host init failed %d\n", __func__, err);
> 

