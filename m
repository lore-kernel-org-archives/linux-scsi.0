Return-Path: <SRS0=0Ioj=2H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEA69C43603
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 22:07:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 806F820716
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 22:07:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="IKyox5aM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbfLQWHO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Dec 2019 17:07:14 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:14360 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725940AbfLQWHO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Dec 2019 17:07:14 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBHM5eEm030252;
        Tue, 17 Dec 2019 14:07:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=qHiEdKiaF/U06yG5UZ99yqlB/UBgFuJJW53mG/7V4mI=;
 b=IKyox5aM4eS+GxlbiHim3X4DlVx0TXRUAa3gMQYnUWSsmEv3B6Sdc+tjfod2JZgYV3yb
 mt5UXCqLNu6XliZBYa148IlbqYYMXRxvud/9yeLaObvqBeTIgimDF5e4tG3FjOLMnpMn
 hCOkjoozgFxCEc4lXfZtRHRhjFm6GweKRmEtxHpRCWQj7ptX7vcZvsSr7HWmnhuWKtVf
 xDif7LkFxkRfr6PSAc9y7rBQkl597WQaYB9eL+L8QNBwumwYgm70axBbASMfLtWZOrBH
 BJ2Manaoafb3H8052RIbewTBVs+X2bfsBq6+g3B3qYlGkIr7u4jbnAooiMq0XKNDgXN9 sw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2wxn0wm22u-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 17 Dec 2019 14:07:07 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 17 Dec
 2019 14:06:51 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 17 Dec 2019 14:06:51 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 777993F703F;
        Tue, 17 Dec 2019 14:06:51 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id xBHM6paC028171;
        Tue, 17 Dec 2019 14:06:51 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id xBHM6pDB028170;
        Tue, 17 Dec 2019 14:06:51 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 11/14] qla2xxx: Fix RIDA Format-2
Date:   Tue, 17 Dec 2019 14:06:14 -0800
Message-ID: <20191217220617.28084-12-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20191217220617.28084-1-hmadhani@marvell.com>
References: <20191217220617.28084-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-17_04:2019-12-17,2019-12-17 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

This patch fixes offset for Format-2 data structure
for Report ID Acquisition. This caused driver to
set remote_nport_id to 0x0000 in N2N configuration. In a
scenario where Initiator's WWPN is higher than target's
WWPN, driver will assign 0x00 as target nport-id, which
results into login failure.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_fw.h | 35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 9dc09c117416..df5fff819bd7 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -1354,12 +1354,12 @@ struct vp_rpt_id_entry_24xx {
 	uint8_t port_id[3];
 	uint8_t format;
 	union {
-		struct {
+		struct _f0 {
 			/* format 0 loop */
 			uint8_t vp_idx_map[16];
 			uint8_t reserved_4[32];
 		} f0;
-		struct {
+		struct _f1 {
 			/* format 1 fabric */
 			uint8_t vpstat1_subcode; /* vp_status=1 subcode */
 			uint8_t flags;
@@ -1381,21 +1381,22 @@ struct vp_rpt_id_entry_24xx {
 			uint16_t bbcr;
 			uint8_t reserved_5[6];
 		} f1;
-		struct { /* format 2: N2N direct connect */
-		    uint8_t vpstat1_subcode;
-		    uint8_t flags;
-		    uint16_t rsv6;
-		    uint8_t rsv2[12];
-
-		    uint8_t ls_rjt_vendor;
-		    uint8_t ls_rjt_explanation;
-		    uint8_t ls_rjt_reason;
-		    uint8_t rsv3[5];
-
-		    uint8_t port_name[8];
-		    uint8_t node_name[8];
-		    uint8_t remote_nport_id[4];
-		    uint32_t reserved_5;
+		struct _f2 { /* format 2: N2N direct connect */
+			uint8_t vpstat1_subcode;
+			uint8_t flags;
+			uint16_t fip_flags;
+			uint8_t rsv2[12];
+
+			uint8_t ls_rjt_vendor;
+			uint8_t ls_rjt_explanation;
+			uint8_t ls_rjt_reason;
+			uint8_t rsv3[5];
+
+			uint8_t port_name[8];
+			uint8_t node_name[8];
+			uint16_t bbcr;
+			uint8_t reserved_5[2];
+			uint8_t remote_nport_id[4];
 		} f2;
 	} u;
 };
-- 
2.12.0

