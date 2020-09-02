Return-Path: <SRS0=1vUj=CL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UPPERCASE_50_75 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4042AC433E6
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 03:23:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FDF4207EA
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 03:23:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="N43PFbYO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbgIBDXF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Sep 2020 23:23:05 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:63064 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726971AbgIBDXF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Sep 2020 23:23:05 -0400
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200902032302epoutp01d0c0d763eb2328eff5a33576ae9a9e10~w2Xlct6qZ1810818108epoutp01f
        for <linux-scsi@vger.kernel.org>; Wed,  2 Sep 2020 03:23:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200902032302epoutp01d0c0d763eb2328eff5a33576ae9a9e10~w2Xlct6qZ1810818108epoutp01f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1599016983;
        bh=DSnklmNM1iRH6V9fPTu0ChZ9yrpvpym06lWfFNwv+dQ=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=N43PFbYOInmONGlfHh/B4euxEMdcZVnbqqetxLyz24LJIPKKcSMa/Cum0leeNd5Br
         q96jkrQ5GLcHRjkNiF2MbwnQvtdt4sulRo46vmz7BJdRB1CWGZzSf+sxhe0kKtYzLr
         a8oz1H0wpgGFoVwLjA6Q3i4z/juJFAZTsyoeViHE=
Received: from epcpadp2 (unknown [182.195.40.12]) by epcas1p4.samsung.com
        (KnoxPortal) with ESMTP id
        20200902032302epcas1p4bc579ca4007cd49f39d668248eca5a12~w2Xk7mySO2726627266epcas1p4C;
        Wed,  2 Sep 2020 03:23:02 +0000 (GMT)
Mime-Version: 1.0
Subject: [PATCH v11 1/4] scsi: ufs: Add HPB feature related parameters
Reply-To: daejun7.park@samsung.com
From:   Daejun Park <daejun7.park@samsung.com>
To:     Daejun Park <daejun7.park@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <231786897.01599016802080.JavaMail.epsvc@epcpadp1>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <336371513.41599016982374.JavaMail.epsvc@epcpadp2>
Date:   Wed, 02 Sep 2020 12:20:58 +0900
X-CMS-MailID: 20200902032058epcms2p2d2762c1ffaea976db2c8dcff77a9aec2
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200902031713epcms2p664cebf386ba19d3d05895fec89aaf4fe
References: <231786897.01599016802080.JavaMail.epsvc@epcpadp1>
        <CGME20200902031713epcms2p664cebf386ba19d3d05895fec89aaf4fe@epcms2p2>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is a patch for parameters to be used for HPB feature.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Can Guo <cang@codeaurora.org>
Acked-by: Avri Altman <Avri.Altman@wdc.com>
Tested-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
 drivers/scsi/ufs/ufs.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index f8ab16f30fdc..e879ac34c065 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -122,6 +122,7 @@ enum flag_idn {
 	QUERY_FLAG_IDN_WB_EN                            = 0x0E,
 	QUERY_FLAG_IDN_WB_BUFF_FLUSH_EN                 = 0x0F,
 	QUERY_FLAG_IDN_WB_BUFF_FLUSH_DURING_HIBERN8     = 0x10,
+	QUERY_FLAG_IDN_HPB_RESET                        = 0x11,
 };
 
 /* Attribute idn for Query requests */
@@ -195,6 +196,9 @@ enum unit_desc_param {
 	UNIT_DESC_PARAM_PHY_MEM_RSRC_CNT	= 0x18,
 	UNIT_DESC_PARAM_CTX_CAPABILITIES	= 0x20,
 	UNIT_DESC_PARAM_LARGE_UNIT_SIZE_M1	= 0x22,
+	UNIT_DESC_HPB_LU_MAX_ACTIVE_REGIONS	= 0x23,
+	UNIT_DESC_HPB_LU_PIN_REGION_START_OFFSET	= 0x25,
+	UNIT_DESC_HPB_LU_NUM_PIN_REGIONS	= 0x27,
 	UNIT_DESC_PARAM_WB_BUF_ALLOC_UNITS	= 0x29,
 };
 
@@ -235,6 +239,8 @@ enum device_desc_param {
 	DEVICE_DESC_PARAM_PSA_MAX_DATA		= 0x25,
 	DEVICE_DESC_PARAM_PSA_TMT		= 0x29,
 	DEVICE_DESC_PARAM_PRDCT_REV		= 0x2A,
+	DEVICE_DESC_PARAM_HPB_VER		= 0x40,
+	DEVICE_DESC_PARAM_HPB_CONTROL		= 0x42,
 	DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP	= 0x4F,
 	DEVICE_DESC_PARAM_WB_PRESRV_USRSPC_EN	= 0x53,
 	DEVICE_DESC_PARAM_WB_TYPE		= 0x54,
@@ -283,6 +289,10 @@ enum geometry_desc_param {
 	GEOMETRY_DESC_PARAM_ENM4_MAX_NUM_UNITS	= 0x3E,
 	GEOMETRY_DESC_PARAM_ENM4_CAP_ADJ_FCTR	= 0x42,
 	GEOMETRY_DESC_PARAM_OPT_LOG_BLK_SIZE	= 0x44,
+	GEOMETRY_DESC_PARAM_HPB_REGION_SIZE	= 0x48,
+	GEOMETRY_DESC_PARAM_HPB_NUMBER_LU	= 0x49,
+	GEOMETRY_DESC_PARAM_HPB_SUBREGION_SIZE	= 0x4A,
+	GEOMETRY_DESC_PARAM_HPB_MAX_ACTIVE_REGS	= 0x4B,
 	GEOMETRY_DESC_PARAM_WB_MAX_ALLOC_UNITS	= 0x4F,
 	GEOMETRY_DESC_PARAM_WB_MAX_WB_LUNS	= 0x53,
 	GEOMETRY_DESC_PARAM_WB_BUFF_CAP_ADJ	= 0x54,
@@ -327,8 +337,10 @@ enum {
 
 /* Possible values for dExtendedUFSFeaturesSupport */
 enum {
+	UFS_DEV_HPB_SUPPORT		= BIT(7),
 	UFS_DEV_WRITE_BOOSTER_SUP	= BIT(8),
 };
+#define UFS_DEV_HPB_SUPPORT_VERSION		0x310
 
 #define POWER_DESC_MAX_SIZE			0x62
 #define POWER_DESC_MAX_ACTV_ICC_LVLS		16
@@ -537,6 +549,7 @@ struct ufs_dev_info {
 	u8 *model;
 	u16 wspecversion;
 	u32 clk_gating_wait_us;
+	u8 b_ufs_feature_sup;
 	u32 d_ext_ufs_feature_sup;
 	u8 b_wb_buffer_type;
 	u32 d_wb_alloc_units;
-- 
2.17.1


