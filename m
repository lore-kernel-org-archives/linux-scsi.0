Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D7CBC433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 12:13:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 672C92072D
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 12:13:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="PXCMlqwb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729668AbgGMMNZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 08:13:25 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:27328 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726586AbgGMMNZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Jul 2020 08:13:25 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1594642404; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=QmzfPs8eZRl2dgcyf60Wj7Bm3TCq28QlYUw6T4kFc3o=;
 b=PXCMlqwboW7Aw9qC6NN+T9W3Xld8duTLgO4Gl4R2nNrpA7zgpTv2Ti165mPj1F0kuV36+oYp
 FJ0YjZLD0jD2pXECIOVTnRgVQasd51VMXRoP5nUQQnxww+6fvL4MJ7Tr3xy1Y1YuNa3bXO+j
 hh5FSNuQK9NqZ297cjjokxrMVlo=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 5f0c4fd9166c1c5494da358b (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 13 Jul 2020 12:13:13
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 84DC8C433AD; Mon, 13 Jul 2020 12:13:12 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7E466C433C8;
        Mon, 13 Jul 2020 12:13:11 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 13 Jul 2020 20:13:11 +0800
From:   Can Guo <cang@codeaurora.org>
To:     daejun7.park@samsung.com
Cc:     avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, asutoshd@codeaurora.org,
        beanhuo@micron.com, stanley.chu@mediatek.com, bvanassche@acm.org,
        tomas.winkler@intel.com, ALIM AKHTAR <alim.akhtar@samsung.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: Re: [PATCH v6 1/5] scsi: ufs: Add UFS feature related parameter
In-Reply-To: <231786897.01594636801601.JavaMail.epsvc@epcpadp1>
References: <963815509.21594636682161.JavaMail.epsvc@epcpadp2>
 <CGME20200713103423epcms2p8442ee7cc22395e4a4cedf224f95c45e8@epcms2p3>
 <231786897.01594636801601.JavaMail.epsvc@epcpadp1>
Message-ID: <dbc1c3ffaf66ec41236365c5b259d948@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-07-13 18:38, Daejun Park wrote:
> This is a patch for parameters to be used for UFS features layer and 
> HPB
> module.
> 
> Tested-by: Bean Huo <beanhuo@micron.com>
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>

Reviewed-by: Can Guo <cang@codeaurora.org>

> ---
>  drivers/scsi/ufs/ufs.h | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
> index f8ab16f30fdc..ae557b8d3eba 100644
> --- a/drivers/scsi/ufs/ufs.h
> +++ b/drivers/scsi/ufs/ufs.h
> @@ -122,6 +122,7 @@ enum flag_idn {
>  	QUERY_FLAG_IDN_WB_EN                            = 0x0E,
>  	QUERY_FLAG_IDN_WB_BUFF_FLUSH_EN                 = 0x0F,
>  	QUERY_FLAG_IDN_WB_BUFF_FLUSH_DURING_HIBERN8     = 0x10,
> +	QUERY_FLAG_IDN_HPB_RESET                        = 0x11,
>  };
> 
>  /* Attribute idn for Query requests */
> @@ -195,6 +196,9 @@ enum unit_desc_param {
>  	UNIT_DESC_PARAM_PHY_MEM_RSRC_CNT	= 0x18,
>  	UNIT_DESC_PARAM_CTX_CAPABILITIES	= 0x20,
>  	UNIT_DESC_PARAM_LARGE_UNIT_SIZE_M1	= 0x22,
> +	UNIT_DESC_HPB_LU_MAX_ACTIVE_REGIONS	= 0x23,
> +	UNIT_DESC_HPB_LU_PIN_REGION_START_OFFSET	= 0x25,
> +	UNIT_DESC_HPB_LU_NUM_PIN_REGIONS	= 0x27,
>  	UNIT_DESC_PARAM_WB_BUF_ALLOC_UNITS	= 0x29,
>  };
> 
> @@ -235,6 +239,8 @@ enum device_desc_param {
>  	DEVICE_DESC_PARAM_PSA_MAX_DATA		= 0x25,
>  	DEVICE_DESC_PARAM_PSA_TMT		= 0x29,
>  	DEVICE_DESC_PARAM_PRDCT_REV		= 0x2A,
> +	DEVICE_DESC_PARAM_HPB_VER		= 0x40,
> +	DEVICE_DESC_PARAM_HPB_CONTROL		= 0x42,
>  	DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP	= 0x4F,
>  	DEVICE_DESC_PARAM_WB_PRESRV_USRSPC_EN	= 0x53,
>  	DEVICE_DESC_PARAM_WB_TYPE		= 0x54,
> @@ -283,6 +289,10 @@ enum geometry_desc_param {
>  	GEOMETRY_DESC_PARAM_ENM4_MAX_NUM_UNITS	= 0x3E,
>  	GEOMETRY_DESC_PARAM_ENM4_CAP_ADJ_FCTR	= 0x42,
>  	GEOMETRY_DESC_PARAM_OPT_LOG_BLK_SIZE	= 0x44,
> +	GEOMETRY_DESC_HPB_REGION_SIZE		= 0x48,
> +	GEOMETRY_DESC_HPB_NUMBER_LU		= 0x49,
> +	GEOMETRY_DESC_HPB_SUBREGION_SIZE	= 0x4A,
> +	GEOMETRY_DESC_HPB_DEVICE_MAX_ACTIVE_REGIONS	= 0x4B,
>  	GEOMETRY_DESC_PARAM_WB_MAX_ALLOC_UNITS	= 0x4F,
>  	GEOMETRY_DESC_PARAM_WB_MAX_WB_LUNS	= 0x53,
>  	GEOMETRY_DESC_PARAM_WB_BUFF_CAP_ADJ	= 0x54,
> @@ -327,6 +337,7 @@ enum {
> 
>  /* Possible values for dExtendedUFSFeaturesSupport */
>  enum {
> +	UFS_DEV_HPB_SUPPORT		= BIT(7),
>  	UFS_DEV_WRITE_BOOSTER_SUP	= BIT(8),
>  };
> 
> @@ -537,6 +548,7 @@ struct ufs_dev_info {
>  	u8 *model;
>  	u16 wspecversion;
>  	u32 clk_gating_wait_us;
> +	u8 b_ufs_feature_sup;
>  	u32 d_ext_ufs_feature_sup;
>  	u8 b_wb_buffer_type;
>  	u32 d_wb_alloc_units;
> 
> base-commit: b53293fa662e28ae0cdd40828dc641c09f133405
