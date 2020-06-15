Return-Path: <SRS0=1R64=74=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55C33C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 07:23:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BBC420738
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 07:23:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="fqMer2uM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728541AbgFOHXH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Jun 2020 03:23:07 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:62901 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728380AbgFOHXG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jun 2020 03:23:06 -0400
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200615072304epoutp01128fe7f131c1fa8bca423336f5663d00~YprmMLoGi2565725657epoutp01I
        for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2020 07:23:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200615072304epoutp01128fe7f131c1fa8bca423336f5663d00~YprmMLoGi2565725657epoutp01I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592205784;
        bh=q16fNkxdF6WvQtIMVDHHO9Q+D9jqMqIJ4OFGZj0vF64=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=fqMer2uMlvslNlN7qPRnuKuqu8aTrUnXJqVyZcUXyaI3uEG7lrF2/DZwgQs/dyWtF
         KxXirmXEciaxyKo4Q+WazOw4MA5/PKgpZc/U3hecPBCqsGAcC7m1cMUlspaRMiDBZN
         zD+f/bh9xS+SCt2i9xgEGejH04ejPKyyC0Zqk1XM=
Received: from epcpadp2 (unknown [182.195.40.12]) by epcas1p3.samsung.com
        (KnoxPortal) with ESMTP id
        20200615072303epcas1p398eaedd8598e3a37d391491f6943c55e~Yprlun-Rc1374213742epcas1p3C;
        Mon, 15 Jun 2020 07:23:03 +0000 (GMT)
Mime-Version: 1.0
Subject: [RFC PATCH v2 1/5] scsi: ufs: Add UFS feature related parameter
Reply-To: daejun7.park@samsung.com
From:   Daejun Park <daejun7.park@samsung.com>
To:     Daejun Park <daejun7.park@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <231786897.01592205482200.JavaMail.epsvc@epcpadp2>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <336371513.41592205783606.JavaMail.epsvc@epcpadp2>
Date:   Mon, 15 Jun 2020 16:21:27 +0900
X-CMS-MailID: 20200615072127epcms2p50292cefb5aa41ac033e29f6a9fad8681
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200615062708epcms2p19a7fbc051bcd5e843c29dcd58fff4210
References: <231786897.01592205482200.JavaMail.epsvc@epcpadp2>
        <CGME20200615062708epcms2p19a7fbc051bcd5e843c29dcd58fff4210@epcms2p5>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is a patch for parameters to be used for UFS features layer and HPB
module.

Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
 drivers/scsi/ufs/ufs.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index c70845d41449..f3efa3424fc0 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -146,6 +146,7 @@ enum flag_idn {
 	QUERY_FLAG_IDN_WB_EN                            = 0x0E,
 	QUERY_FLAG_IDN_WB_BUFF_FLUSH_EN                 = 0x0F,
 	QUERY_FLAG_IDN_WB_BUFF_FLUSH_DURING_HIBERN8     = 0x10,
+	QUERY_FLAG_IDN_HPB_RESET                        = 0x11,
 };
 
 /* Attribute idn for Query requests */
@@ -229,6 +230,9 @@ enum unit_desc_param {
 	UNIT_DESC_PARAM_PHY_MEM_RSRC_CNT	= 0x18,
 	UNIT_DESC_PARAM_CTX_CAPABILITIES	= 0x20,
 	UNIT_DESC_PARAM_LARGE_UNIT_SIZE_M1	= 0x22,
+	UNIT_DESC_HPB_LU_MAX_ACTIVE_REGIONS	= 0x23,
+	UNIT_DESC_HPB_LU_PIN_REGION_START_OFFSET	= 0x25,
+	UNIT_DESC_HPB_LU_NUM_PIN_REGIONS	= 0x27,
 	UNIT_DESC_PARAM_WB_BUF_ALLOC_UNITS	= 0x29,
 };
 
@@ -269,6 +273,8 @@ enum device_desc_param {
 	DEVICE_DESC_PARAM_PSA_MAX_DATA		= 0x25,
 	DEVICE_DESC_PARAM_PSA_TMT		= 0x29,
 	DEVICE_DESC_PARAM_PRDCT_REV		= 0x2A,
+	DEVICE_DESC_PARAM_HPB_VER		= 0x40,
+	DEVICE_DESC_PARAM_HPB_CONTROL		= 0x42,
 	DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP	= 0x4F,
 	DEVICE_DESC_PARAM_WB_PRESRV_USRSPC_EN	= 0x53,
 	DEVICE_DESC_PARAM_WB_TYPE		= 0x54,
@@ -317,6 +323,10 @@ enum geometry_desc_param {
 	GEOMETRY_DESC_PARAM_ENM4_MAX_NUM_UNITS	= 0x3E,
 	GEOMETRY_DESC_PARAM_ENM4_CAP_ADJ_FCTR	= 0x42,
 	GEOMETRY_DESC_PARAM_OPT_LOG_BLK_SIZE	= 0x44,
+	GEOMETRY_DESC_HPB_REGION_SIZE		= 0x48,
+	GEOMETRY_DESC_HPB_NUMBER_LU		= 0x49,
+	GEOMETRY_DESC_HPB_SUBREGION_SIZE	= 0x4A,
+	GEOMETRY_DESC_HPB_DEVICE_MAX_ACTIVE_REGIONS	= 0x4B,
 	GEOMETRY_DESC_PARAM_WB_MAX_ALLOC_UNITS	= 0x4F,
 	GEOMETRY_DESC_PARAM_WB_MAX_WB_LUNS	= 0x53,
 	GEOMETRY_DESC_PARAM_WB_BUFF_CAP_ADJ	= 0x54,
@@ -361,6 +371,7 @@ enum {
 
 /* Possible values for dExtendedUFSFeaturesSupport */
 enum {
+	UFS_DEV_HPB_SUPPORT		= BIT(7),
 	UFS_DEV_WRITE_BOOSTER_SUP	= BIT(8),
 };
 
@@ -571,6 +582,7 @@ struct ufs_dev_info {
 	u8 *model;
 	u16 wspecversion;
 	u32 clk_gating_wait_us;
+	u8 b_ufs_feature_sup;
 	u32 d_ext_ufs_feature_sup;
 	u8 b_wb_buffer_type;
 	u32 d_wb_alloc_units;
-- 
2.17.1

