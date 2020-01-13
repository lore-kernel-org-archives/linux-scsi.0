Return-Path: <SRS0=nml+=3C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 473B2C33CAE
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jan 2020 18:45:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1CD5421739
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jan 2020 18:45:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="vXO5uVrf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728804AbgAMSo4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jan 2020 13:44:56 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:45032 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726435AbgAMSo4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Jan 2020 13:44:56 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1578941095; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=Fcxr2EqIF+3kq4AymzEPIs0358emuS7iPrdMMRaAXqE=;
 b=vXO5uVrfk1ELbVUFdSuPc0tPC2APxnpV+d865A4zVcQZiIX6Zp4SfK/GellAo3afn6cnigPG
 TQhLRf+RuglkPRJrDTR7u8Ra0gNtf05WLhyrjDOsnPRnHREAGkOkUMC1m3Ed6aDGE+28Wodo
 3NbFyD+F4DWQYi3gCqXJ3QryRec=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e1cbaa6.7f226737ced8-smtp-out-n03;
 Mon, 13 Jan 2020 18:44:54 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6A617C447A6; Mon, 13 Jan 2020 18:44:54 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 56B9AC43383;
        Mon, 13 Jan 2020 18:44:53 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 13 Jan 2020 10:44:53 -0800
From:   asutoshd@codeaurora.org
To:     Bean Huo <huobean@gmail.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        pedrom.sousa@synopsys.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi-owner@vger.kernel.org
Subject: Re: [PATCH 2/3] scsi: ufs: initialize max_lu_supported while booting
In-Reply-To: <20200110183606.10102-3-huobean@gmail.com>
References: <20200110183606.10102-1-huobean@gmail.com>
 <20200110183606.10102-3-huobean@gmail.com>
Message-ID: <90ba2b1a99e3934beea7516302cc2c2f@codeaurora.org>
X-Sender: asutoshd@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-01-10 10:36, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> This patch is to add a new function ufshcd_init_device_param() for
> initialization of  UFS device related parameters which are used by
> driver. In this version patch, there is only dev_info.max_lu_supported
> being initialized.
> 
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 47 ++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 46 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 1b97f2dc0b63..a297fe55e36a 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -3158,6 +3158,11 @@ static int ufshcd_read_device_desc(struct
> ufs_hba *hba, u8 *buf, u32 size)
>  	return ufshcd_read_desc(hba, QUERY_DESC_IDN_DEVICE, 0, buf, size);
>  }
> 
> +static int ufshcd_read_geometry_desc(struct ufs_hba *hba, u8 *buf, u32 
> size)
> +{
> +	return ufshcd_read_desc(hba, QUERY_DESC_IDN_GEOMETRY, 0, buf, size);
> +}
> +
>  /**
>   * struct uc_string_id - unicode string
>   *
> @@ -6827,6 +6832,37 @@ static void ufshcd_clear_dbg_ufs_stats(struct
> ufs_hba *hba)
>  	hba->req_abort_count = 0;
>  }
> 
> +static int ufshcd_init_device_param(struct ufs_hba *hba)
> +{
> +	int err;
> +	size_t buff_len;
> +	u8 *desc_buf;
> +
> +	buff_len = QUERY_DESC_MAX_SIZE;
> +	desc_buf = kmalloc(buff_len, GFP_KERNEL);
> +	if (!desc_buf) {
> +		err = -ENOMEM;
> +		goto out;
> +	}
> +
> +	err = ufshcd_read_geometry_desc(hba, desc_buf,
> +			hba->desc_size.geom_desc);
> +	if (err) {
> +		dev_err(hba->dev, "%s: Failed reading Geometry Desc. err = %d\n",
> +			__func__, err);
> +		goto out;
> +	}
> +
> +	if (desc_buf[GEOMETRY_DESC_PARAM_MAX_NUM_LUN] == 1)
> +		hba->dev_info.max_lu_supported = 32;
> +	else if (desc_buf[GEOMETRY_DESC_PARAM_MAX_NUM_LUN] == 0)
> +		hba->dev_info.max_lu_supported = 8;
> +
> +out:
> +	kfree(desc_buf);
> +	return err;
> +}
> +
>  static void ufshcd_init_desc_sizes(struct ufs_hba *hba)
>  {
>  	int err;
> @@ -7016,13 +7052,22 @@ static int ufshcd_probe_hba(struct ufs_hba 
> *hba)
> 
>  	/*
>  	 * If we are in error handling context or in power management 
> callbacks
> -	 * context, no need to scan the host
> +	 * context, no need to scan the host and to reinitialize the 
> parameters
>  	 */
>  	if (!ufshcd_eh_in_progress(hba) && !hba->pm_op_in_progress) {
>  		bool flag;
> 
>  		/* clear any previous UFS device information */
>  		memset(&hba->dev_info, 0, sizeof(hba->dev_info));
> +		/* Init parameters according to UFS relevant descriptors */
> +		ret = ufshcd_init_device_param(hba);
> +		if (ret) {
> +			dev_err(hba->dev,
> +				"%s: Init of device param failed. err = %d\n",
> +				__func__, ret);
> +			goto out;
> +		}
> +
>  		if (!ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_READ_FLAG,
>  				QUERY_FLAG_IDN_PWR_ON_WPE, &flag))
>  			hba->dev_info.f_power_on_wp_en = flag;

Looks good to me.
Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
