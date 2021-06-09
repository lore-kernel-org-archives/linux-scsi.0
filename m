Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69714C48BCD
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 17:26:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5021161182
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 17:26:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbhFIR2c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 13:28:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:59446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231208AbhFIR2b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Jun 2021 13:28:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E00A60FF0;
        Wed,  9 Jun 2021 17:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623259597;
        bh=FpoCLV9AugRc/VDev7vPQc6huezBsa4q91oamgMCi5c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NLOK9mUD+/TKJsoyTz8L0eBkVX43pGvWLc5FpY6jTYXm9zQH9xDeb8eVBxYr7141D
         oOihLl1UDsYd8WcVKymY7cYRTAlm3IBdGHGVhpv44a485uzGP1mU2iQkVxmZiW6Yrr
         CYpWet4OJByewcGJb/e+Cvsm73g/rtgPybRmUxF8PG+VXeTf6OD/vvfSdsYhqew/B4
         C0t3li6a730oPWMd8/cLa8kLP3IXqdVjxFEe9oxvSmIAfWpXEc7rcRa8D36ghB0lqZ
         Z36gt8FMHm2fGxJbUpKIFxdjCg1lUZChHzTVUM7Jf/XD/gFw/osviQV2csVEl4jxOF
         21rQWy31RN3pg==
Date:   Wed, 9 Jun 2021 10:26:30 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH v3] scsi: ufs: Fix a possible use before initialization
 case
Message-ID: <YMD5xoeiE7+wrCEK@archlinux-ax161>
References: <1623227044-22635-1-git-send-email-cang@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1623227044-22635-1-git-send-email-cang@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jun 09, 2021 at 01:24:00AM -0700, Can Guo wrote:
> In ufshcd_exec_dev_cmd(), if error happens before lrpb is initialized,
> then we should bail out instead of letting trace record the error.
> 
> Fixes: a45f937110fa6 ("scsi: ufs: Optimize host lock on transfer requests send/compl paths")
> Reported-by: kernel test robot <lkp@intel.com>
> Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
> Signed-off-by: Can Guo <cang@codeaurora.org>

Reviewed-by: Nathan Chancellor <nathan@kernel.org>

> ---
> 
> Change since V2:
> - Removed unused goto out_put_tag
> 
> Change since V1:
> - Use codeaurora mail in Signed-off-by tag
> 
>  drivers/scsi/ufs/ufshcd.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index fe1b5f4..25fe18a 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -2980,7 +2980,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
>  	WARN_ON(lrbp->cmd);
>  	err = ufshcd_compose_dev_cmd(hba, lrbp, cmd_type, tag);
>  	if (unlikely(err))
> -		goto out_put_tag;
> +		goto out;
>  
>  	hba->dev_cmd.complete = &wait;
>  
> @@ -2990,11 +2990,10 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
>  
>  	ufshcd_send_command(hba, tag);
>  	err = ufshcd_wait_for_dev_cmd(hba, lrbp, timeout);
> -out:
>  	ufshcd_add_query_upiu_trace(hba, err ? UFS_QUERY_ERR : UFS_QUERY_COMP,
>  				    (struct utp_upiu_req *)lrbp->ucd_rsp_ptr);
>  
> -out_put_tag:
> +out:
>  	blk_put_request(req);
>  out_unlock:
>  	up_read(&hba->clk_scaling_lock);
> -- 
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.
> 
