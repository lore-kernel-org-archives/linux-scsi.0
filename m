Return-Path: <SRS0=fWC9=4W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FCB9C3F2D7
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 05:44:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F374421556
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 05:44:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="sphQoshk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725844AbgCEFos (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Mar 2020 00:44:48 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:33621 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725858AbgCEFos (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Mar 2020 00:44:48 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1583387087; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=As7z+9RsocK5CQV9qlxwp3vbojEnbfUk/NP3ejBV3dc=;
 b=sphQoshk/hVEe1cNe84+xZ1Rn3LJIvCURvcVqkjWjMtQnK14GlSDjQ97IfXKgY/ZCygtN+vh
 8Rn1lzuYskkjAhQpWn5GAoYXBh8hhH2/OFo5Ma0GfDY53ZKBk5DZ7ROlHLE9VuYzvJ48JH+F
 kG8KxMvR/xqzxo7ycmFy9gcIkn8=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e6091cb.7f9a4dcfafb8-smtp-out-n04;
 Thu, 05 Mar 2020 05:44:43 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 2E615C447A4; Thu,  5 Mar 2020 05:44:41 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A1C56C43383;
        Thu,  5 Mar 2020 05:44:39 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 05 Mar 2020 13:44:39 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com,
        beanhuo@micron.com, asutoshd@codeaurora.org,
        matthias.bgg@gmail.com, bvanassche@acm.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com
Subject: Re: [PATCH v1 2/4] scsi: ufs: use an enum for host capabilities
In-Reply-To: <20200305040704.10645-3-stanley.chu@mediatek.com>
References: <20200305040704.10645-1-stanley.chu@mediatek.com>
 <20200305040704.10645-3-stanley.chu@mediatek.com>
Message-ID: <2f7c30cab1abf458930ac4253ff17ee1@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Stanley,

On 2020-03-05 12:07, Stanley Chu wrote:
> Use an enum to specify the host capabilities instead of #defines inside 
> the
> structure definition.
> 
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>

Reviewed-by: Can Guo <cang@codeaurora.org>

> ---
>  drivers/scsi/ufs/ufshcd.h | 65 ++++++++++++++++++++++-----------------
>  1 file changed, 37 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 4e235cef99bc..49ade1bfd085 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -510,6 +510,43 @@ enum ufshcd_quirks {
>  	UFSHCD_QUIRK_BROKEN_UFS_HCI_VERSION		= 1 << 5,
>  };
> 
> +enum ufshcd_caps {
> +	/* Allow dynamic clk gating */
> +	UFSHCD_CAP_CLK_GATING				= 1 << 0,
> +
> +	/* Allow hiberb8 with clk gating */
> +	UFSHCD_CAP_HIBERN8_WITH_CLK_GATING		= 1 << 1,
> +
> +	/* Allow dynamic clk scaling */
> +	UFSHCD_CAP_CLK_SCALING				= 1 << 2,
> +
> +	/* Allow auto bkops to enabled during runtime suspend */
> +	UFSHCD_CAP_AUTO_BKOPS_SUSPEND			= 1 << 3,
> +
> +	/*
> +	 * This capability allows host controller driver to use the UFS HCI's
> +	 * interrupt aggregation capability.
> +	 * CAUTION: Enabling this might reduce overall UFS throughput.
> +	 */
> +	UFSHCD_CAP_INTR_AGGR				= 1 << 4,
> +
> +	/*
> +	 * This capability allows the device auto-bkops to be always enabled
> +	 * except during suspend (both runtime and suspend).
> +	 * Enabling this capability means that device will always be allowed
> +	 * to do background operation when it's active but it might degrade
> +	 * the performance of ongoing read/write operations.
> +	 */
> +	UFSHCD_CAP_KEEP_AUTO_BKOPS_ENABLED_EXCEPT_SUSPEND = 1 << 5,
> +
> +	/*
> +	 * This capability allows host controller driver to automatically
> +	 * enable runtime power management by itself instead of waiting
> +	 * for userspace to control the power management.
> +	 */
> +	UFSHCD_CAP_RPM_AUTOSUSPEND			= 1 << 6,
> +};
> +
>  /**
>   * struct ufs_hba - per adapter private structure
>   * @mmio_base: UFSHCI base register address
> @@ -662,34 +699,6 @@ struct ufs_hba {
>  	struct ufs_clk_gating clk_gating;
>  	/* Control to enable/disable host capabilities */
>  	u32 caps;
> -	/* Allow dynamic clk gating */
> -#define UFSHCD_CAP_CLK_GATING	(1 << 0)
> -	/* Allow hiberb8 with clk gating */
> -#define UFSHCD_CAP_HIBERN8_WITH_CLK_GATING (1 << 1)
> -	/* Allow dynamic clk scaling */
> -#define UFSHCD_CAP_CLK_SCALING	(1 << 2)
> -	/* Allow auto bkops to enabled during runtime suspend */
> -#define UFSHCD_CAP_AUTO_BKOPS_SUSPEND (1 << 3)
> -	/*
> -	 * This capability allows host controller driver to use the UFS HCI's
> -	 * interrupt aggregation capability.
> -	 * CAUTION: Enabling this might reduce overall UFS throughput.
> -	 */
> -#define UFSHCD_CAP_INTR_AGGR (1 << 4)
> -	/*
> -	 * This capability allows the device auto-bkops to be always enabled
> -	 * except during suspend (both runtime and suspend).
> -	 * Enabling this capability means that device will always be allowed
> -	 * to do background operation when it's active but it might degrade
> -	 * the performance of ongoing read/write operations.
> -	 */
> -#define UFSHCD_CAP_KEEP_AUTO_BKOPS_ENABLED_EXCEPT_SUSPEND (1 << 5)
> -	/*
> -	 * This capability allows host controller driver to automatically
> -	 * enable runtime power management by itself instead of waiting
> -	 * for userspace to control the power management.
> -	 */
> -#define UFSHCD_CAP_RPM_AUTOSUSPEND (1 << 6)
> 
>  	struct devfreq *devfreq;
>  	struct ufs_clk_scaling clk_scaling;
