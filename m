Return-Path: <SRS0=POaH=YW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 130AACA9EC3
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 16:26:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C880921721
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 16:26:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ZPS+0MWs";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="POA1ZhWC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390267AbfJ2Q0w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Oct 2019 12:26:52 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:37480 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728902AbfJ2Q0w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Oct 2019 12:26:52 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A999B60CDD; Tue, 29 Oct 2019 16:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572366410;
        bh=oxh4rlK6bZR9Qdq45X3TCKCQDVm+kGPTdv4JEvnfIIk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZPS+0MWsX4ErNbommogw2fEXU3TNzotLrLp0kdwGuxwdwKR6XXvkDBDrZ0iPu0hdw
         tiPym9flOTuPUkNpG90Di6n02ezhuj1el0g/l2RYEG5+AHnPF33UOIhfzUdz/Ueb6F
         edmmOPiCJahrV/NGOwy/xBNYmhMzEzhwNO/R1l44=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 1552A607EF;
        Tue, 29 Oct 2019 16:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572366408;
        bh=oxh4rlK6bZR9Qdq45X3TCKCQDVm+kGPTdv4JEvnfIIk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=POA1ZhWC8QagaIQlbx7Hin1ppqzB2RqzK5NcSyimw8STUKoN3qzfH0bN98CpF/Ja4
         BZjEhPaAdkdzCXXGobG7e3U0eAqqYXCoOBKxJzwbA9laajniLitlmkVAbje8nWCZ3d
         CVb6WWq/eadDyCASWhS73MDingY22US/scnzxjGc=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 29 Oct 2019 09:26:48 -0700
From:   asutoshd@codeaurora.org
To:     Can Guo <cang@codeaurora.org>
Cc:     nguyenb@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 2/2] scsi: ufs: Do not rely on prefetched data
In-Reply-To: <1572351831-30373-3-git-send-email-cang@codeaurora.org>
References: <1572351831-30373-1-git-send-email-cang@codeaurora.org>
 <1572351831-30373-3-git-send-email-cang@codeaurora.org>
Message-ID: <d8850f39c67de9a8fb478a6a738093d1@codeaurora.org>
X-Sender: asutoshd@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-10-29 05:23, Can Guo wrote:
> We were setting bActiveICCLevel attribute for UFS device only once but
> type of this attribute has changed from persistent to volatile since 
> UFS
> device specification v2.1. This attribute is set to the default value 
> after
> power cycle or hardware reset event. It isn't safe to rely on 
> prefetched
> data (only used for bActiveICCLevel attribute now). Hence this change
> removes the code related to data prefetching and set this parameter on
> every attempt to probe the UFS device.
> 
> Signed-off-by: Can Guo <cang@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 30 +++++++++++++++---------------
>  drivers/scsi/ufs/ufshcd.h | 13 -------------
>  2 files changed, 15 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 3a0b99b..0026199 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6424,11 +6424,12 @@ static u32
> ufshcd_find_max_sup_active_icc_level(struct ufs_hba *hba,
>  	return icc_level;
>  }
> 
> -static void ufshcd_init_icc_levels(struct ufs_hba *hba)
> +static void ufshcd_set_active_icc_lvl(struct ufs_hba *hba)
>  {
>  	int ret;
>  	int buff_len = hba->desc_size.pwr_desc;
>  	u8 *desc_buf;
> +	u32 icc_level;
> 
>  	desc_buf = kmalloc(buff_len, GFP_KERNEL);
>  	if (!desc_buf)
> @@ -6442,20 +6443,17 @@ static void ufshcd_init_icc_levels(struct 
> ufs_hba *hba)
>  		goto out;
>  	}
> 
> -	hba->init_prefetch_data.icc_level =
> -			ufshcd_find_max_sup_active_icc_level(hba,
> -			desc_buf, buff_len);
> -	dev_dbg(hba->dev, "%s: setting icc_level 0x%x",
> -			__func__, hba->init_prefetch_data.icc_level);
> +	icc_level = ufshcd_find_max_sup_active_icc_level(hba, desc_buf,
> +							 buff_len);
> +	dev_dbg(hba->dev, "%s: setting icc_level 0x%x", __func__, icc_level);
> 
>  	ret = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
> -		QUERY_ATTR_IDN_ACTIVE_ICC_LVL, 0, 0,
> -		&hba->init_prefetch_data.icc_level);
> +		QUERY_ATTR_IDN_ACTIVE_ICC_LVL, 0, 0, &icc_level);
> 
>  	if (ret)
>  		dev_err(hba->dev,
>  			"%s: Failed configuring bActiveICCLevel = %d ret = %d",
> -			__func__, hba->init_prefetch_data.icc_level , ret);
> +			__func__, icc_level, ret);
> 
>  out:
>  	kfree(desc_buf);
> @@ -6963,6 +6961,14 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
>  		}
>  	}
> 
> +	/*
> +	 * bActiveICCLevel is volatile for UFS device (as per latest v2.1 
> spec)
> +	 * and for removable UFS card as well, hence always set the 
> parameter.
> +	 * Note: Error handler may issue the device reset hence resetting
> +	 *       bActiveICCLevel as well so it is always safe to set this 
> here.
> +	 */
> +	ufshcd_set_active_icc_lvl(hba);
> +
>  	/* set the state as operational after switching to desired gear */
>  	hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
> 
> @@ -6979,9 +6985,6 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
>  				QUERY_FLAG_IDN_PWR_ON_WPE, &flag))
>  			hba->dev_info.f_power_on_wp_en = flag;
> 
> -		if (!hba->is_init_prefetch)
> -			ufshcd_init_icc_levels(hba);
> -
>  		/* Add required well known logical units to scsi mid layer */
>  		if (ufshcd_scsi_add_wlus(hba))
>  			goto out;
> @@ -7006,9 +7009,6 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
>  		pm_runtime_put_sync(hba->dev);
>  	}
> 
> -	if (!hba->is_init_prefetch)
> -		hba->is_init_prefetch = true;
> -
>  out:
>  	/*
>  	 * If we failed to initialize the device or the device is not
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index e0fe247..3089b81 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -405,15 +405,6 @@ struct ufs_clk_scaling {
>  	bool is_suspended;
>  };
> 
> -/**
> - * struct ufs_init_prefetch - contains data that is pre-fetched once 
> during
> - * initialization
> - * @icc_level: icc level which was read during initialization
> - */
> -struct ufs_init_prefetch {
> -	u32 icc_level;
> -};
> -
>  #define UFS_ERR_REG_HIST_LENGTH 8
>  /**
>   * struct ufs_err_reg_hist - keeps history of errors
> @@ -505,8 +496,6 @@ struct ufs_stats {
>   * @intr_mask: Interrupt Mask Bits
>   * @ee_ctrl_mask: Exception event control mask
>   * @is_powered: flag to check if HBA is powered
> - * @is_init_prefetch: flag to check if data was pre-fetched in 
> initialization
> - * @init_prefetch_data: data pre-fetched during initialization
>   * @eh_work: Worker to handle UFS errors that require s/w attention
>   * @eeh_work: Worker to handle exception events
>   * @errors: HBA errors
> @@ -657,8 +646,6 @@ struct ufs_hba {
>  	u32 intr_mask;
>  	u16 ee_ctrl_mask;
>  	bool is_powered;
> -	bool is_init_prefetch;
> -	struct ufs_init_prefetch init_prefetch_data;
> 
>  	/* Work Queues */
>  	struct work_struct eh_work;

Looks good to me.

-Asutosh
