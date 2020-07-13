Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UPPERCASE_50_75,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29A98C433E3
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 10:40:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 088482064B
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 10:40:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="EfEnHR8T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729027AbgGMKkE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 06:40:04 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:33416 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727890AbgGMKkE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 06:40:04 -0400
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200713104002epoutp030fcd4926189daa90a48d53836d8874d1~hSbkRqNsL0212202122epoutp03M
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 10:40:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200713104002epoutp030fcd4926189daa90a48d53836d8874d1~hSbkRqNsL0212202122epoutp03M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594636802;
        bh=+nonInlvRNBBiK+G9+3XuizcDOKbPFL5nOJ1JXlgR9k=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=EfEnHR8T8SJKVuVjmcCdOGoG3ZW29sQ6B5PYVwvQmrbdxYuPXxMe0a6yvA7+A4crE
         +fjdPkKzXC3RgYT2TzZDYpxHm5vMLqqhGeDUzSzqOzm2SaerH+hvSFcVNyACoc/L6T
         INIRTmVHnaWN2BUkuZ/fgdJ7AnQosmXHj8kOXYFI=
Received: from epcpadp1 (unknown [182.195.40.11]) by epcas1p1.samsung.com
        (KnoxPortal) with ESMTP id
        20200713104001epcas1p1d1fe6bbec6a0c041dddb7ef975fbda98~hSbjqMPVp0441904419epcas1p18;
        Mon, 13 Jul 2020 10:40:01 +0000 (GMT)
Mime-Version: 1.0
Subject: [PATCH v6 1/5] scsi: ufs: Add UFS feature related parameter
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
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <963815509.21594636682161.JavaMail.epsvc@epcpadp2>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <231786897.01594636801601.JavaMail.epsvc@epcpadp1>
Date:   Mon, 13 Jul 2020 19:38:52 +0900
X-CMS-MailID: 20200713103852epcms2p3014120adf9233da2be1efa8835cd9d34
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200713103423epcms2p8442ee7cc22395e4a4cedf224f95c45e8
References: <963815509.21594636682161.JavaMail.epsvc@epcpadp2>
        <CGME20200713103423epcms2p8442ee7cc22395e4a4cedf224f95c45e8@epcms2p3>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is a patch for parameters to be used for UFS features layer and HPB
module.

Tested-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
 drivers/scsi/ufs/ufs.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index f8ab16f30fdc..ae557b8d3eba 100644
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
+	GEOMETRY_DESC_HPB_REGION_SIZE		= 0x48,
+	GEOMETRY_DESC_HPB_NUMBER_LU		= 0x49,
+	GEOMETRY_DESC_HPB_SUBREGION_SIZE	= 0x4A,
+	GEOMETRY_DESC_HPB_DEVICE_MAX_ACTIVE_REGIONS	= 0x4B,
 	GEOMETRY_DESC_PARAM_WB_MAX_ALLOC_UNITS	= 0x4F,
 	GEOMETRY_DESC_PARAM_WB_MAX_WB_LUNS	= 0x53,
 	GEOMETRY_DESC_PARAM_WB_BUFF_CAP_ADJ	= 0x54,
@@ -327,6 +337,7 @@ enum {
 
 /* Possible values for dExtendedUFSFeaturesSupport */
 enum {
+	UFS_DEV_HPB_SUPPORT		= BIT(7),
 	UFS_DEV_WRITE_BOOSTER_SUP	= BIT(8),
 };
 
@@ -537,6 +548,7 @@ struct ufs_dev_info {
 	u8 *model;
 	u16 wspecversion;
 	u32 clk_gating_wait_us;
+	u8 b_ufs_feature_sup;
 	u32 d_ext_ufs_feature_sup;
 	u8 b_wb_buffer_type;
 	u32 d_wb_alloc_units;

base-commit: b53293fa662e28ae0cdd40828dc641c09f133405
-- 
2.17.1


