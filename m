Return-Path: <SRS0=rv89=A7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94EBFC433EA
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 18:10:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AACD2068F
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 18:10:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="kqHmv2jx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389345AbgGTSKA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jul 2020 14:10:00 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:32438 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730156AbgGTSJv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Jul 2020 14:09:51 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06KHtqII024225;
        Mon, 20 Jul 2020 11:09:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=zMOCXD5nIujJWkPm8c34O5KooCap04NQCHSwJsO48dQ=;
 b=kqHmv2jx6h8NsZAlyZG39ZG9DpJ1mZUQt+oLY/UZjf6Y/KA+lSNuL2x+DZf0BcfyMbed
 HnxDJUi7x5PWijRxSlUyf4+SoFCYXel6viHo7KMYav1FWAeDH66loPKAQdUGuUrfsrLl
 Ox1TUPp0MDabkFFG5IMXARM2Fex4wOS6PwFUZjbMnliChuMmZ0Natcx1XDp4dFanxNMA
 CkwIgVTVHno9zReqye+qsB/O25G09kxEyFeE3ysh2LqbbCVRzK/xBHxR5zqbtmgP/ect
 C0ohwAnrneJdXMO/7k1UG2j+d9/gYFJVZfjrrm+LmG3oUFn459ygpzfRapdok5MBfaaG PQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 32c0kkf907-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 11:09:46 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 20 Jul
 2020 11:09:43 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 20 Jul 2020 11:09:43 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id 7DB733F7040;
        Mon, 20 Jul 2020 11:09:39 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Alexander Lobakin <alobakin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "Ariel Elior" <aelior@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Andrew Lunn <andrew@lunn.ch>,
        <GR-everest-linux-l2@marvell.com>,
        <QLogic-Storage-Upstream@marvell.com>, <netdev@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 net-next 12/16] qed: remove unused qed_hw_info::port_mode and QED_PORT_MODE
Date:   Mon, 20 Jul 2020 21:08:11 +0300
Message-ID: <20200720180815.107-13-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200720180815.107-1-alobakin@marvell.com>
References: <20200720180815.107-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-20_09:2020-07-20,2020-07-20 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Struct field qed_hw_info::port_mode isn't used anywhere in the code, so
can be safely removed to prevent possible dead code addition.
Also remove the enumeration QED_PORT_MODE orphaned after this deletion.

Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed.h     | 15 ---------------
 drivers/net/ethernet/qlogic/qed/qed_dev.c | 21 ---------------------
 2 files changed, 36 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed.h b/drivers/net/ethernet/qlogic/qed/qed.h
index e2d7a4bbab53..47da4f7d3be2 100644
--- a/drivers/net/ethernet/qlogic/qed/qed.h
+++ b/drivers/net/ethernet/qlogic/qed/qed.h
@@ -245,20 +245,6 @@ enum QED_FEATURE {
 	QED_MAX_FEATURES,
 };
 
-enum QED_PORT_MODE {
-	QED_PORT_MODE_DE_2X40G,
-	QED_PORT_MODE_DE_2X50G,
-	QED_PORT_MODE_DE_1X100G,
-	QED_PORT_MODE_DE_4X10G_F,
-	QED_PORT_MODE_DE_4X10G_E,
-	QED_PORT_MODE_DE_4X20G,
-	QED_PORT_MODE_DE_1X40G,
-	QED_PORT_MODE_DE_2X25G,
-	QED_PORT_MODE_DE_1X25G,
-	QED_PORT_MODE_DE_4X25G,
-	QED_PORT_MODE_DE_2X10G,
-};
-
 enum qed_dev_cap {
 	QED_DEV_CAP_ETH,
 	QED_DEV_CAP_FCOE,
@@ -337,7 +323,6 @@ struct qed_hw_info {
 
 	struct qed_igu_info		*p_igu_info;
 
-	u32				port_mode;
 	u32				hw_mode;
 	unsigned long			device_capabilities;
 	u16				mtu;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index d929556247a5..eaf37822fed7 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -3994,37 +3994,16 @@ static int qed_hw_get_nvm_info(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 	switch ((core_cfg & NVM_CFG1_GLOB_NETWORK_PORT_MODE_MASK) >>
 		NVM_CFG1_GLOB_NETWORK_PORT_MODE_OFFSET) {
 	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_BB_2X40G:
-		p_hwfn->hw_info.port_mode = QED_PORT_MODE_DE_2X40G;
-		break;
 	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_2X50G:
-		p_hwfn->hw_info.port_mode = QED_PORT_MODE_DE_2X50G;
-		break;
 	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_BB_1X100G:
-		p_hwfn->hw_info.port_mode = QED_PORT_MODE_DE_1X100G;
-		break;
 	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_4X10G_F:
-		p_hwfn->hw_info.port_mode = QED_PORT_MODE_DE_4X10G_F;
-		break;
 	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_BB_4X10G_E:
-		p_hwfn->hw_info.port_mode = QED_PORT_MODE_DE_4X10G_E;
-		break;
 	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_BB_4X20G:
-		p_hwfn->hw_info.port_mode = QED_PORT_MODE_DE_4X20G;
-		break;
 	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_1X40G:
-		p_hwfn->hw_info.port_mode = QED_PORT_MODE_DE_1X40G;
-		break;
 	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_2X25G:
-		p_hwfn->hw_info.port_mode = QED_PORT_MODE_DE_2X25G;
-		break;
 	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_2X10G:
-		p_hwfn->hw_info.port_mode = QED_PORT_MODE_DE_2X10G;
-		break;
 	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_1X25G:
-		p_hwfn->hw_info.port_mode = QED_PORT_MODE_DE_1X25G;
-		break;
 	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_4X25G:
-		p_hwfn->hw_info.port_mode = QED_PORT_MODE_DE_4X25G;
 		break;
 	default:
 		DP_NOTICE(p_hwfn, "Unknown port mode in 0x%08x\n", core_cfg);
-- 
2.25.1

