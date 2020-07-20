Return-Path: <SRS0=rv89=A7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3651CC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 16:55:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0910E207DF
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 16:55:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="ntlAYlAY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729178AbgGTQzW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jul 2020 12:55:22 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:19171 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728876AbgGTQzW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Jul 2020 12:55:22 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1595264120; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: To:
 Subject: Sender; bh=UIzNvmV+ELxYTOAXP4k3FzNVCR/8qyxuqB7kxehhtOU=; b=ntlAYlAYKLDPQuqnhQQ7ikrASohSfHEGBDfnK789LMeKMqjJe/Zf2hUbka92/4GifLYvnPJm
 uLkXr42z/b0JkFBrfZTmDyujDgcwo65xm9H7SOSkiCdEiIF1LomAqIYtWct4kjSxxZ6PyRq9
 iaNW+ynUFgfw7M1yfx3JRWPPSLk=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n09.prod.us-east-1.postgun.com with SMTP id
 5f15cc6a65270fa5955ca78c (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 20 Jul 2020 16:55:06
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 408C2C433CA; Mon, 20 Jul 2020 16:55:05 +0000 (UTC)
Received: from [192.168.8.168] (cpe-70-95-149-85.san.res.rr.com [70.95.149.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1BBD3C433C6;
        Mon, 20 Jul 2020 16:55:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1BBD3C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [RFC PATCH v2 3/3] scsi: ufs: add vendor specific write booster
 To support the fuction of writebooster by vendor. The WB behavior that the
 vendor wants is slightly different. But we have to support it
To:     SEO HOYOUNG <hy50.seo@samsung.com>, linux-scsi@vger.kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        cang@codeaurora.org, bvanassche@acm.org, grant.jung@samsung.com
References: <cover.1595240433.git.hy50.seo@samsung.com>
 <CGME20200720103951epcas2p246072985a70a459f0acb31d339298a47@epcas2p2.samsung.com>
 <5be595eb83365ec97a8ee0ddafb748029ee8cdf9.1595240433.git.hy50.seo@samsung.com>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <588c1a29-38b9-8c5f-d9c5-899272b9f3a3@codeaurora.org>
Date:   Mon, 20 Jul 2020 09:55:02 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <5be595eb83365ec97a8ee0ddafb748029ee8cdf9.1595240433.git.hy50.seo@samsung.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/20/2020 3:40 AM, SEO HOYOUNG wrote:
> Signed-off-by: SEO HOYOUNG <hy50.seo@samsung.com>
> ---
>   drivers/scsi/ufs/Makefile     |   1 +
>   drivers/scsi/ufs/ufs-exynos.c |   6 +
>   drivers/scsi/ufs/ufs_ctmwb.c  | 279 ++++++++++++++++++++++++++++++++++
>   drivers/scsi/ufs/ufs_ctmwb.h  |  27 ++++
>   4 files changed, 313 insertions(+)
>   create mode 100644 drivers/scsi/ufs/ufs_ctmwb.c
>   create mode 100644 drivers/scsi/ufs/ufs_ctmwb.h
> 
> diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
> index 9810963bc049..b1ba36c7d66f 100644
> --- a/drivers/scsi/ufs/Makefile
> +++ b/drivers/scsi/ufs/Makefile
> @@ -5,6 +5,7 @@ obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) += tc-dwc-g210-pltfrm.o ufshcd-dwc.o tc-d
>   obj-$(CONFIG_SCSI_UFS_CDNS_PLATFORM) += cdns-pltfrm.o
>   obj-$(CONFIG_SCSI_UFS_QCOM) += ufs-qcom.o
>   obj-$(CONFIG_SCSI_UFS_EXYNOS) += ufs-exynos.o
> +obj-$(CONFIG_SCSI_UFS_VENDOR_WB) += ufs_ctmwb.o
>   obj-$(CONFIG_SCSI_UFSHCD) += ufshcd-core.o
>   ufshcd-core-y				+= ufshcd.o ufs-sysfs.o
>   ufshcd-core-$(CONFIG_SCSI_UFS_BSG)	+= ufs_bsg.o
> diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
> index 32b61ba77241..f127f5f2bf36 100644
> --- a/drivers/scsi/ufs/ufs-exynos.c
> +++ b/drivers/scsi/ufs/ufs-exynos.c
> @@ -22,6 +22,9 @@
>   

To me it looks like, you want to have your own flush policy & 
initializations etc, is that understanding correct?
I don't understand why though. The current implementation is spec 
compliant. If there're benefits that you see in this implementation, 
please highlight those. It'd be interesting to see that.


>   #include "ufs-exynos.h"
>   
> +#ifdef CONFIG_SCSI_UFS_VENDOR_WB
> +#include "ufs_ctmwb.h"
> +#endif
>   /*
>    * Exynos's Vendor specific registers for UFSHCI
>    */
> @@ -989,6 +992,9 @@ static int exynos_ufs_init(struct ufs_hba *hba)
>   		goto phy_off;
>   
>   	ufs->hba = hba;
> +#ifdef CONFIG_SCSI_UFS_VENDOR_WB
> +	ufs->hba->wb_ops = ufshcd_ctmwb_init();
> +#endif
>   	ufs->opts = ufs->drv_data->opts;
>   	ufs->rx_sel_idx = PA_MAXDATALANES;
>   	if (ufs->opts & EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX)
> diff --git a/drivers/scsi/ufs/ufs_ctmwb.c b/drivers/scsi/ufs/ufs_ctmwb.c
> new file mode 100644
> index 000000000000..ab39f40721ae
> --- /dev/null
> +++ b/drivers/scsi/ufs/ufs_ctmwb.c
> @@ -0,0 +1,279 @@
> +#include "ufshcd.h"
> +#include "ufshci.h"
> +#include "ufs_ctmwb.h"
> +
> +static struct ufshba_ctmwb hba_ctmwb;
> +
> +/* Query request retries */
> +#define QUERY_REQ_RETRIES 3
> +
> +static int ufshcd_query_attr_retry(struct ufs_hba *hba,
> +	enum query_opcode opcode, enum attr_idn idn, u8 index, u8 selector,
> +	u32 *attr_val)
> +{
> +	int ret = 0;
> +	u32 retries;
> +
> +	 for (retries = QUERY_REQ_RETRIES; retries > 0; retries--) {
> +		ret = ufshcd_query_attr(hba, opcode, idn, index,
> +						selector, attr_val);
> +		if (ret)
> +			dev_dbg(hba->dev, "%s: failed with error %d, retries %d\n",
> +				__func__, ret, retries);
> +		else
> +			break;
> +	}
> +
> +	if (ret)
> +		dev_err(hba->dev,
> +			"%s: query attribute, idn %d, failed with error %d after %d retires\n",
> +			__func__, idn, ret, QUERY_REQ_RETRIES);
> +	return ret;
> +}
> +
> +static int ufshcd_query_flag_retry(struct ufs_hba *hba,
> +	enum query_opcode opcode, enum flag_idn idn, bool *flag_res)
> +{
> +	int ret;
> +	int retries;
> +
> +	for (retries = 0; retries < QUERY_REQ_RETRIES; retries++) {
> +		ret = ufshcd_query_flag(hba, opcode, idn, flag_res);
> +		if (ret)
> +			dev_dbg(hba->dev,
> +				"%s: failed with error %d, retries %d\n",
> +				__func__, ret, retries);
> +		else
> +			break;
> +	}
> +
> +	if (ret)
> +		dev_err(hba->dev,
> +			"%s: query attribute, opcode %d, idn %d, failed with error %d after %d retries\n",
> +			__func__, (int)opcode, (int)idn, ret, retries);
> +	return ret;
> +}
> +
> +static int ufshcd_reset_ctmwb(struct ufs_hba *hba, bool force)
> +{
> +	int err = 0;
> +
> +	if (!hba_ctmwb.support_ctmwb)
> +		return 0;
> +
> +	if (ufshcd_is_ctmwb_off(hba_ctmwb)) {
> +		dev_info(hba->dev, "%s: turbo write already disabled. ctmwb_state = %d\n",
> +			__func__, hba_ctmwb.ufs_ctmwb_state);
> +		return 0;
> +	}
> +
> +	if (ufshcd_is_ctmwb_err(hba_ctmwb))
> +		dev_err(hba->dev, "%s: previous turbo write control was failed.\n",
> +			__func__);
> +
> +	if (force)
> +		err = ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_CLEAR_FLAG,
> +				QUERY_FLAG_IDN_WB_EN, NULL);
> +
> +	if (err) {
> +		ufshcd_set_ctmwb_err(hba_ctmwb);
> +		dev_err(hba->dev, "%s: disable turbo write failed. err = %d\n",
> +			__func__, err);
> +	} else {
> +		ufshcd_set_ctmwb_off(hba_ctmwb);
> +		dev_info(hba->dev, "%s: ufs turbo write disabled \n", __func__);
> +	}
> +
> +	return 0;
> +}
> +
> +static int ufshcd_get_ctmwb_buf_status(struct ufs_hba *hba, u32 *status)
> +{
> +	return ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
> +			QUERY_ATTR_IDN_AVAIL_WB_BUFF_SIZE, 0, 0, status);
> +}
> +
> +static int ufshcd_ctmwb_manual_flush_ctrl(struct ufs_hba *hba, int en)
> +{
> +	int err = 0;
> +
> +	dev_info(hba->dev, "%s: %sable turbo write manual flush\n",
> +				__func__, en ? "en" : "dis");
> +	if (en) {
> +		err = ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_SET_FLAG,
> +					QUERY_FLAG_IDN_WB_BUFF_FLUSH_EN, NULL);
> +		if (err)
> +			dev_err(hba->dev, "%s: enable turbo write failed. err = %d\n",
> +				__func__, err);
> +	} else {
> +		err = ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_CLEAR_FLAG,
> +					QUERY_FLAG_IDN_WB_BUFF_FLUSH_EN, NULL);
> +		if (err)
> +			dev_err(hba->dev, "%s: disable turbo write failed. err = %d\n",
> +				__func__, err);
> +	}
> +
> +	return err;
> +}
> +
> +static int ufshcd_ctmwb_flush_ctrl(struct ufs_hba *hba)
> +{
> +	int err = 0;
> +	u32 curr_status = 0;
> +
> +	err = ufshcd_get_ctmwb_buf_status(hba, &curr_status);
> +
> +	if (!err && (curr_status <= UFS_WB_MANUAL_FLUSH_THRESHOLD)) {
> +		dev_info(hba->dev, "%s: enable ctmwb manual flush, buf status : %d\n",
> +				__func__, curr_status);
> +		scsi_block_requests(hba->host);
> +		err = ufshcd_ctmwb_manual_flush_ctrl(hba, 1);
> +		if (!err) {
> +			mdelay(100);
> +			err = ufshcd_ctmwb_manual_flush_ctrl(hba, 0);
> +			if (err)
> +				dev_err(hba->dev, "%s: disable ctmwb manual flush failed. err = %d\n",
> +						__func__, err);
> +		} else
> +			dev_err(hba->dev, "%s: enable ctmwb manual flush failed. err = %d\n",
> +					__func__, err);
> +		scsi_unblock_requests(hba->host);
> +	}
> +	return err;
> +}
> +
> +static int ufshcd_ctmwb_ctrl(struct ufs_hba *hba, bool enable)
> +{
> +	int err;
> +#if 0
Did you miss removing these #if 0?

> +	if (!hba->support_ctmwb)
> +		return;
> +
> +	if (hba->pm_op_in_progress) {
> +		dev_err(hba->dev, "%s: ctmwb ctrl during pm operation is not allowed.\n",
> +			__func__);
> +		return;
> +	}
> +
> +	if (hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL) {
> +		dev_err(hba->dev, "%s: ufs host is not available.\n",
> +			__func__);
> +		return;
> +	}
> +	if (ufshcd_is_ctmwb_err(hba_ctmwb))
> +		dev_err(hba->dev, "%s: previous turbo write control was failed.\n",
> +			__func__);
> +#endif
> +	if (enable) {
> +		if (ufshcd_is_ctmwb_on(hba_ctmwb)) {
> +			dev_err(hba->dev, "%s: turbo write already enabled. ctmwb_state = %d\n",
> +				__func__, hba_ctmwb.ufs_ctmwb_state);
> +			return 0;
> +		}
> +		pm_runtime_get_sync(hba->dev);
> +		err = ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_SET_FLAG,
> +					QUERY_FLAG_IDN_WB_EN, NULL);
> +		if (err) {
> +			ufshcd_set_ctmwb_err(hba_ctmwb);
> +			dev_err(hba->dev, "%s: enable turbo write failed. err = %d\n",
> +				__func__, err);
> +		} else {
> +			ufshcd_set_ctmwb_on(hba_ctmwb);
> +			dev_info(hba->dev, "%s: ufs turbo write enabled \n", __func__);
> +		}
> +	} else {
> +		if (ufshcd_is_ctmwb_off(hba_ctmwb)) {
> +			dev_err(hba->dev, "%s: turbo write already disabled. ctmwb_state = %d\n",
> +				__func__, hba_ctmwb.ufs_ctmwb_state);
> +			return 0;
> +		}
> +		pm_runtime_get_sync(hba->dev);
> +		err = ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_CLEAR_FLAG,
> +					QUERY_FLAG_IDN_WB_EN, NULL);
> +		if (err) {
> +			ufshcd_set_ctmwb_err(hba_ctmwb);
> +			dev_err(hba->dev, "%s: disable turbo write failed. err = %d\n",
> +				__func__, err);
> +		} else {
> +			ufshcd_set_ctmwb_off(hba_ctmwb);
> +			dev_info(hba->dev, "%s: ufs turbo write disabled \n", __func__);
What is 'turbo write'?
> +		}
> +	}
> +
> +	pm_runtime_put_sync(hba->dev);
> +
> +	return 0;
> +}
> +
> +/**
> + * ufshcd_get_ctmwbbuf_unit - get ctmwb buffer alloc units
> + * @sdev: pointer to SCSI device
> + *
> + * Read dLUNumTurboWriteBufferAllocUnits in UNIT Descriptor
> + * to check if LU supports turbo write feature
> + */
> +static int ufshcd_get_ctmwbbuf_unit(struct ufs_hba *hba)
> +{
> +	struct scsi_device *sdev = hba->sdev_ufs_device;
> +	struct ufshba_ctmwb *hba_ctmwb = (struct ufshba_ctmwb *)hba->wb_ops;
> +	int ret = 0;
> +
> +	u32 dLUNumTurboWriteBufferAllocUnits = 0;
> +	u8 desc_buf[4];
> +
> +	if (!hba_ctmwb->support_ctmwb)
> +		return 0;
> +
> +	ret = ufshcd_read_unit_desc_param(hba,
> +			ufshcd_scsi_to_upiu_lun(sdev->lun),
> +			UNIT_DESC_PARAM_WB_BUF_ALLOC_UNITS,
> +			desc_buf,
> +			sizeof(dLUNumTurboWriteBufferAllocUnits));
> +
> +	/* Some WLUN doesn't support unit descriptor */
> +	if ((ret == -EOPNOTSUPP) || scsi_is_wlun(sdev->lun)){
> +		hba_ctmwb->support_ctmwb_lu = false;
> +		dev_info(hba->dev,"%s: do not support WB\n", __func__);
> +		return 0;
> +	}
> +
> +	dLUNumTurboWriteBufferAllocUnits = ((desc_buf[0] << 24)|
> +			(desc_buf[1] << 16) |
> +			(desc_buf[2] << 8) |
> +			desc_buf[3]);
> +
> +	if (dLUNumTurboWriteBufferAllocUnits) {
> +		hba_ctmwb->support_ctmwb_lu = true;
> +		dev_info(hba->dev, "%s: LU %d supports ctmwb, ctmwbbuf unit : 0x%x\n",
> +				__func__, (int)sdev->lun, dLUNumTurboWriteBufferAllocUnits);
> +	} else
> +		hba_ctmwb->support_ctmwb_lu = false;
> +
> +	return 0;
> +}
> +
> +static inline int ufshcd_ctmwb_toggle_flush(struct ufs_hba *hba, enum ufs_pm_op pm_op)
> +{
> +	ufshcd_ctmwb_flush_ctrl(hba);
> +
> +	if (ufshcd_is_system_pm(pm_op))
> +		ufshcd_reset_ctmwb(hba, true);
> +
> +	return 0;
> +}
> +
> +static struct ufs_wb_ops exynos_ctmwb_ops = {
> +	.wb_toggle_flush_vendor = ufshcd_ctmwb_toggle_flush,
> +	.wb_alloc_units_vendor = ufshcd_get_ctmwbbuf_unit,
> +	.wb_ctrl_vendor = ufshcd_ctmwb_ctrl,
> +	.wb_reset_vendor = ufshcd_reset_ctmwb,
> +};
> +
> +struct ufs_wb_ops *ufshcd_ctmwb_init(void)
> +{
> +	hba_ctmwb.support_ctmwb = 1;
> +
> +	return &exynos_ctmwb_ops;
> +}
> +EXPORT_SYMBOL_GPL(ufshcd_ctmwb_init);
> +
> diff --git a/drivers/scsi/ufs/ufs_ctmwb.h b/drivers/scsi/ufs/ufs_ctmwb.h
> new file mode 100644
> index 000000000000..073e21a4900b
> --- /dev/null
> +++ b/drivers/scsi/ufs/ufs_ctmwb.h
> @@ -0,0 +1,27 @@
> +#ifndef _UFS_CTMWB_H_
> +#define _UFS_CTMWB_H_
> +
> +enum ufs_ctmwb_state {
> +       UFS_WB_OFF_STATE	= 0,    /* turbo write disabled state */
> +       UFS_WB_ON_STATE	= 1,            /* turbo write enabled state */
> +       UFS_WB_ERR_STATE	= 2,            /* turbo write error state */
> +};
> +
> +#define ufshcd_is_ctmwb_off(hba) ((hba).ufs_ctmwb_state == UFS_WB_OFF_STATE)
> +#define ufshcd_is_ctmwb_on(hba) ((hba).ufs_ctmwb_state == UFS_WB_ON_STATE)
> +#define ufshcd_is_ctmwb_err(hba) ((hba).ufs_ctmwb_state == UFS_WB_ERR_STATE)
> +#define ufshcd_set_ctmwb_off(hba) ((hba).ufs_ctmwb_state = UFS_WB_OFF_STATE)
> +#define ufshcd_set_ctmwb_on(hba) ((hba).ufs_ctmwb_state = UFS_WB_ON_STATE)
> +#define ufshcd_set_ctmwb_err(hba) ((hba).ufs_ctmwb_state = UFS_WB_ERR_STATE)
> +
> +#define UFS_WB_MANUAL_FLUSH_THRESHOLD	5
> +
> +struct ufshba_ctmwb {
> +	enum ufs_ctmwb_state ufs_ctmwb_state;
> +	bool support_ctmwb;
> +
> +	bool support_ctmwb_lu;
> +};
> +
> +struct ufs_wb_ops *ufshcd_ctmwb_init(void);
> +#endif
> 

-Asutosh

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
