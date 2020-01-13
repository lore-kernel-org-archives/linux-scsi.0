Return-Path: <SRS0=nml+=3C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1E04C33CA9
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jan 2020 18:45:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D932214AF
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jan 2020 18:45:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="Z5xacSTz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728680AbgAMSpb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jan 2020 13:45:31 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:45032 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728516AbgAMSpb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Jan 2020 13:45:31 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1578941130; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=BE7Ii/+ZSj3amZRXFjwOsrUKK4ov1l85oSUE5ZJn4jU=;
 b=Z5xacSTzfmqrX+tnecGtkmGaBwfCrEMTL86/Da3WgLmoFGiAQwS16PCyH+FbkMUzFd8xPa63
 mObgTvNXHTUSpPPB/bEqkVqMbZG0/j08h5V0umVubhIvUAspF1KNfV49eoU1NSpAAcXwkfKF
 nQ2qOa2IBSEFqvspjNy5nk9uCCE=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e1cbaca.7fc7eb66f2d0-smtp-out-n01;
 Mon, 13 Jan 2020 18:45:30 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C44C9C447A1; Mon, 13 Jan 2020 18:45:29 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 93683C43383;
        Mon, 13 Jan 2020 18:45:28 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 13 Jan 2020 10:45:28 -0800
From:   asutoshd@codeaurora.org
To:     Bean Huo <huobean@gmail.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        pedrom.sousa@synopsys.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi-owner@vger.kernel.org
Subject: Re: [PATCH 3/3] scsi: ufs: use UFS device indicated maximum LU number
In-Reply-To: <20200110183606.10102-4-huobean@gmail.com>
References: <20200110183606.10102-1-huobean@gmail.com>
 <20200110183606.10102-4-huobean@gmail.com>
Message-ID: <3c6080a44d2943f86d6991d48cd2dd28@codeaurora.org>
X-Sender: asutoshd@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-01-10 10:36, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> According to Jedec standard UFS 3.0 and UFS 2.1 Spec, Maximum number of 
> logical
> units supported by the UFS device is indicated by parameter 
> bMaxNumberLU in
> Geometry Descriptor. This patch is to delete current hard code macro 
> definition
> of UFS_UPIU_MAX_GENERAL_LUN, and switch to use device indicated number 
> instead.
> 
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>  drivers/scsi/ufs/ufs-sysfs.c |  2 +-
>  drivers/scsi/ufs/ufs.h       | 12 +++++++++---
>  drivers/scsi/ufs/ufshcd.c    |  4 ++--
>  3 files changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufs-sysfs.c 
> b/drivers/scsi/ufs/ufs-sysfs.c
> index 720be3f64be7..dbdf8b01abed 100644
> --- a/drivers/scsi/ufs/ufs-sysfs.c
> +++ b/drivers/scsi/ufs/ufs-sysfs.c
> @@ -713,7 +713,7 @@ static ssize_t _pname##_show(struct device 
> *dev,			\
>  	struct scsi_device *sdev = to_scsi_device(dev);			\
>  	struct ufs_hba *hba = shost_priv(sdev->host);			\
>  	u8 lun = ufshcd_scsi_to_upiu_lun(sdev->lun);			\
> -	if (!ufs_is_valid_unit_desc_lun(lun))				\
> +	if (!ufs_is_valid_unit_desc_lun(&hba->dev_info, lun))		\
>  		return -EINVAL;						\
>  	return ufs_sysfs_read_desc_param(hba, QUERY_DESC_IDN_##_duname,	\
>  		lun, _duname##_DESC_PARAM##_puname, buf, _size);	\
> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
> index 5ca7ea4f223e..810eeca0de63 100644
> --- a/drivers/scsi/ufs/ufs.h
> +++ b/drivers/scsi/ufs/ufs.h
> @@ -63,7 +63,6 @@
>  #define UFS_UPIU_MAX_UNIT_NUM_ID	0x7F
>  #define UFS_MAX_LUNS		(SCSI_W_LUN_BASE + UFS_UPIU_MAX_UNIT_NUM_ID)
>  #define UFS_UPIU_WLUN_ID	(1 << 7)
> -#define UFS_UPIU_MAX_GENERAL_LUN	8
> 
>  /* Well known logical unit id in LUN field of UPIU */
>  enum {
> @@ -548,12 +547,19 @@ struct ufs_dev_desc {
> 
>  /**
>   * ufs_is_valid_unit_desc_lun - checks if the given LUN has a unit 
> descriptor
> + * @dev_info: pointer of instance of struct ufs_dev_info
>   * @lun: LU number to check
>   * @return: true if the lun has a matching unit descriptor, false 
> otherwise
>   */
> -static inline bool ufs_is_valid_unit_desc_lun(u8 lun)
> +static inline bool ufs_is_valid_unit_desc_lun(struct ufs_dev_info 
> *dev_info,
> +		u8 lun)
>  {
> -	return lun == UFS_UPIU_RPMB_WLUN || (lun < UFS_UPIU_MAX_GENERAL_LUN);
> +	if (!dev_info || !dev_info->max_lu_supported) {
> +		pr_err("Max General LU supported by UFS isn't initilized\n");
> +		return false;
> +	}
> +
> +	return lun == UFS_UPIU_RPMB_WLUN || (lun < 
> dev_info->max_lu_supported);
>  }
> 
>  #endif /* End of Header */
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index a297fe55e36a..c6ea5d88222d 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -3286,7 +3286,7 @@ static inline int
> ufshcd_read_unit_desc_param(struct ufs_hba *hba,
>  	 * Unit descriptors are only available for general purpose LUs (LUN 
> id
>  	 * from 0 to 7) and RPMB Well known LU.
>  	 */
> -	if (!ufs_is_valid_unit_desc_lun(lun))
> +	if (!ufs_is_valid_unit_desc_lun(&hba->dev_info, lun))
>  		return -EOPNOTSUPP;
> 
>  	return ufshcd_read_desc_param(hba, QUERY_DESC_IDN_UNIT, lun,
> @@ -4540,7 +4540,7 @@ static int ufshcd_get_lu_wp(struct ufs_hba *hba,
>  	 * protected so skip reading bLUWriteProtect parameter for
>  	 * it. For other W-LUs, UNIT DESCRIPTOR is not available.
>  	 */
> -	else if (lun >= UFS_UPIU_MAX_GENERAL_LUN)
> +	else if (lun >= hba->dev_info.max_lu_supported)
>  		ret = -ENOTSUPP;
>  	else
>  		ret = ufshcd_read_unit_desc_param(hba,

Looks good to me.
Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
