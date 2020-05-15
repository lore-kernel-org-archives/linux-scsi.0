Return-Path: <SRS0=Oq5V=65=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B701AC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 10:31:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93B0D206B6
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 10:31:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="DVauyA57"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728151AbgEOKa7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 May 2020 06:30:59 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:36584 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728013AbgEOKa6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2020 06:30:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1589538658; x=1621074658;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=Edx5LE0GtA0f8CTvfvLAqmL1Ms4BhYqygAz8k1OsHpQ=;
  b=DVauyA57eMXwllJ/CvnX1fk3KfnJfpYnTp3XnJNSmsyv025TkYApGPys
   3wyeGpCU15nMMHaYvSiOywsIWQ+pMF+lyLpmdwT8de89owpM1OoOPXYLv
   e8kd33fKswpP1bvkPAwqHQLdkvFv/Vv6NZvc5QFKpU5swUUKElVS04XZw
   J4IXQNxryQGmjOk9D00xbr90rz62sKlAcqiu1P8czqyDf1UzXyxU9R6JP
   DHsoXsHZc8NdZHY4YjveWXwOwFUTDFLu2oAowfMLmf6CHWwJkRImCvdzm
   ZB+XLtunjyw9ld4hxTqOGukoT0V3FM/CISvA6nG/JiNfBpUwDrarwBz7W
   A==;
IronPort-SDR: PQV0VUy7oOKvIIofwowyNw0exYuODxJGHMdW+/CWRNRZ/xWs2Yp5LWCLK3IH37AjrDcJgMbV9Y
 FLA/U/9LNnTN5ImMwAgLKy1PgMkPn3n4447hKCAIomR7XZS4AZ0O+I8fLBQeZ74OSdAZh2Zkt+
 f/pz+xKOT94HlFkHza5rpMnrpgIEHGuiaE1YOGwQKO+iVjDrEdkAo5R58l7BZl4S6U0iGwsgqG
 Voh9By5dxyIe1r2jvDxpQwv7QQe1qzEh38UfOjX5b73cmFzsc+z21uW6wINOZQK5traneBbXtd
 Obw=
X-IronPort-AV: E=Sophos;i="5.73,394,1583164800"; 
   d="scan'208";a="139202345"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 15 May 2020 18:30:58 +0800
IronPort-SDR: kwDQ90GjHgQK4FGCHfvsWb0XhiQkhrUTpP1IeBjOmBEKtinvQ3Rpdlv6P9KPeDxnUMCh2sp57v
 VJ1fC/8YgUMF2Gx11WGBjyImxZQdEs61I=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2020 03:21:08 -0700
IronPort-SDR: X98WAsiSUirhSR9jYR9ptTEI7tDTqYE/ALm0LN4z3E6H1Y9TcsIyV0tx+LKvXzAT5ubB4qgtD+
 bZjE5RUk4WYQ==
WDCIronportException: Internal
Received: from ile422988.sdcorp.global.sandisk.com ([10.0.231.246])
  by uls-op-cesaip01.wdc.com with ESMTP; 15 May 2020 03:30:53 -0700
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>, alim.akhtar@samsung.com,
        asutoshd@codeaurora.org, Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <avi.shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>, cang@codeaurora.org,
        stanley.chu@mediatek.com,
        MOHAMMED RAFIQ KAMAL BASHA <md.rafiq@samsung.com>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [RFC PATCH 01/13] scsi: ufs: Add HPB parameters
Date:   Fri, 15 May 2020 13:30:02 +0300
Message-Id: <1589538614-24048-2-git-send-email-avri.altman@wdc.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1589538614-24048-1-git-send-email-avri.altman@wdc.com>
References: <1589538614-24048-1-git-send-email-avri.altman@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A prep patch to introduce HPB-related parameters, that we will use
throughout.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufs.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index b313534..6428538 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -130,6 +130,11 @@ enum {
 	UPIU_QUERY_FUNC_STANDARD_WRITE_REQUEST          = 0x81,
 };
 
+/* Logical unit enable - to decode bLUEnable */
+enum {
+	UFS_LUN_HPB = 0x2,
+};
+
 /* Flag idn for Query Requests*/
 enum flag_idn {
 	QUERY_FLAG_IDN_FDEVICEINIT			= 0x01,
@@ -146,6 +151,7 @@ enum flag_idn {
 	QUERY_FLAG_IDN_WB_EN                            = 0x0E,
 	QUERY_FLAG_IDN_WB_BUFF_FLUSH_EN                 = 0x0F,
 	QUERY_FLAG_IDN_WB_BUFF_FLUSH_DURING_HIBERN8     = 0x10,
+	QUERY_FLAG_IDN_HPB_RESET                        = 0x11,
 };
 
 /* Attribute idn for Query requests */
@@ -229,6 +235,9 @@ enum unit_desc_param {
 	UNIT_DESC_PARAM_PHY_MEM_RSRC_CNT	= 0x18,
 	UNIT_DESC_PARAM_CTX_CAPABILITIES	= 0x20,
 	UNIT_DESC_PARAM_LARGE_UNIT_SIZE_M1	= 0x22,
+	UNIT_DESC_PARAM_MAX_ACTIVE_HPBREGIONS	= 0x23,
+	UNIT_DESC_PARAM_HPB_PINNED_OFFSET	= 0x25,
+	UNIT_DESC_PARAM_HPB_PINNED_COUNT	= 0x27,
 	UNIT_DESC_PARAM_WB_BUF_ALLOC_UNITS	= 0x29,
 };
 
@@ -269,6 +278,8 @@ enum device_desc_param {
 	DEVICE_DESC_PARAM_PSA_MAX_DATA		= 0x25,
 	DEVICE_DESC_PARAM_PSA_TMT		= 0x29,
 	DEVICE_DESC_PARAM_PRDCT_REV		= 0x2A,
+	DEVICE_DESC_PARAM_HPBVER		= 0x40,
+	DEVICE_DESC_PARAM_HPBCONTROL		= 0x42,
 	DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP	= 0x4F,
 	DEVICE_DESC_PARAM_WB_PRESRV_USRSPC_EN	= 0x53,
 	DEVICE_DESC_PARAM_WB_TYPE		= 0x54,
@@ -317,6 +328,10 @@ enum geometry_desc_param {
 	GEOMETRY_DESC_PARAM_ENM4_MAX_NUM_UNITS	= 0x3E,
 	GEOMETRY_DESC_PARAM_ENM4_CAP_ADJ_FCTR	= 0x42,
 	GEOMETRY_DESC_PARAM_OPT_LOG_BLK_SIZE	= 0x44,
+	GEOMETRY_DESC_PARAM_HPB_REGION_SIZE	= 0x48,
+	GEOMETRY_DESC_PARAM_MAX_HPB_LUNS	= 0x49,
+	GEOMETRY_DESC_PARAM_HPB_SUBREGION_SIZE	= 0x4A,
+	GEOMETRY_DESC_PARAM_HPB_ACTIVE_REGIONS	= 0x4B,
 	GEOMETRY_DESC_PARAM_WB_MAX_ALLOC_UNITS	= 0x4F,
 	GEOMETRY_DESC_PARAM_WB_MAX_WB_LUNS	= 0x53,
 	GEOMETRY_DESC_PARAM_WB_BUFF_CAP_ADJ	= 0x54,
@@ -361,6 +376,7 @@ enum {
 
 /* Possible values for dExtendedUFSFeaturesSupport */
 enum {
+	UFS_FEATURE_HPB			= BIT(7),
 	UFS_DEV_WRITE_BOOSTER_SUP	= BIT(8),
 };
 
-- 
2.7.4

