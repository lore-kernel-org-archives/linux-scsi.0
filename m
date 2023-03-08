Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2911C678D5
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Mar 2023 05:43:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbjCHFnJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Mar 2023 00:43:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbjCHFnI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2023 00:43:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90EC2E05C;
        Tue,  7 Mar 2023 21:43:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48084B81BC2;
        Wed,  8 Mar 2023 05:43:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6B6AC433D2;
        Wed,  8 Mar 2023 05:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678254183;
        bh=qAHauBFZuHWDue6Ue3uyDXFjtoPdxblGDLd6QAcnlrw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mAAgnxiSveYE/+/NiFEtR+ElfJ3D5C0deEUOHYfYgtDhtpkbUYPoXRYL3N4ZmkcGY
         PY1w6bRUG2MtM65dBavpJNkLJ7VEDk8pVWUAUOkKbTlrFP9AMYnB32eRHRRi7obFUC
         V4DJxmGHz7Uf+JT0jy+u02aXLXrURmt3usU5Uqg8cr+HeRx6J65SdBdWNnqThuY+h7
         n9pIL8VyzERXmNDv//21ZyuQO0w2+0MWIcJTCtrfTe5IApQZ6cK3BxjUMkGBv8FvFs
         lhV5fJxpuZ7kO91gTnzzoO1FFhnZ+T9j9lVNVtw5Bzf1DagCKtz4VmkyYU73J/aYUw
         avyrqVczO8nTg==
Date:   Wed, 8 Mar 2023 11:12:53 +0530
From:   Manivannan Sadhasivam <mani@kernel.org>
To:     Asutosh Das <quic_asutoshd@quicinc.com>
Cc:     quic_cang@quicinc.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, quic_nguyenb@quicinc.com,
        quic_xiaosenh@quicinc.com, stanley.chu@mediatek.com,
        adrian.hunter@intel.com, bvanassche@acm.org, avri.altman@wdc.com,
        beanhuo@micron.com, linux-arm-msm@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 1/1] scsi: ufs: mcq: Use active_reqs to check busy in
 clock scaling
Message-ID: <20230308054253.GD5124@thinkpad>
References: <e8d303eff0713a3e5f3c3725cdf6e5c5d3de2b01.1678244386.git.quic_asutoshd@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e8d303eff0713a3e5f3c3725cdf6e5c5d3de2b01.1678244386.git.quic_asutoshd@quicinc.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Mar 07, 2023 at 07:00:09PM -0800, Asutosh Das wrote:
> Multi Circular Queue doesn't use outstanding_reqs.
> But the ufs clock scaling functions use outstanding_reqs to
> determine if there're requests pending. When MCQ is enabled
> this check always returns false.
> 
> Hence use active_reqs to check if there're pending requests.
> 
> Signed-off-by: Asutosh Das <quic_asutoshd@quicinc.com>

This looks like a fix to me. Hence there should be a fixes tag. With that,

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>

Thanks,
Mani

> ---
>  drivers/ufs/core/ufshcd.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 172d25fef740..c6b35123c83b 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -1500,7 +1500,7 @@ static int ufshcd_devfreq_get_dev_status(struct device *dev,
>  	scaling->window_start_t = curr_t;
>  	scaling->tot_busy_t = 0;
>  
> -	if (hba->outstanding_reqs) {
> +	if (scaling->active_reqs) {
>  		scaling->busy_start_t = curr_t;
>  		scaling->is_busy_started = true;
>  	} else {
> @@ -2118,7 +2118,7 @@ static void ufshcd_clk_scaling_update_busy(struct ufs_hba *hba)
>  
>  	spin_lock_irqsave(hba->host->host_lock, flags);
>  	hba->clk_scaling.active_reqs--;
> -	if (!hba->outstanding_reqs && scaling->is_busy_started) {
> +	if (!scaling->active_reqs && scaling->is_busy_started) {
>  		scaling->tot_busy_t += ktime_to_us(ktime_sub(ktime_get(),
>  					scaling->busy_start_t));
>  		scaling->busy_start_t = 0;
> -- 
> 2.7.4
> 

-- 
மணிவண்ணன் சதாசிவம்
