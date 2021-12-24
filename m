Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E917C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Dec 2021 07:08:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351802AbhLXHIN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Dec 2021 02:08:13 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:1120 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351765AbhLXHHy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Dec 2021 02:07:54 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BO2WGK2008452
        for <linux-scsi@vger.kernel.org>; Thu, 23 Dec 2021 23:07:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=U+uFJkisdAJdLTcpnULl+vB3zFdFhctLAY5AFFM+HkY=;
 b=H3j4TVtOM1I3QFnSqErvYiOPr/ERJXW/w0g/YVg3fxv1gq+gdtCfIPWoX4eSLT2XyWi8
 /6k4+UWjSheCMKulzxoFqpdQ+/YhpJ/pOZcOqDLgLGWHo6iwLbsjDaf5ufsCPB5ePHUi
 T1jd6kQMN9ojBCTUr9xzO3CZMlO9AmwgSwaztB+7iOHhXPCqhbWoIxnygZ5QKNuiUpTH
 Ed2bQ9W8Ls5OZudfn6dU0ddv1QXCQJt/OiPsgf+D4UAZ51aJJ+Wy1Rcu8/VCZZamRVRW
 I5lllKsPH3aNBRAEAn7qDNTPJoGf7JHoE/VlWSsONQxcnFnit7HsRtob+hl4DFI/UNRe 6A== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3d4t6kjua2-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 23 Dec 2021 23:07:53 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 23 Dec
 2021 23:07:51 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 23 Dec 2021 23:07:51 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id EAA4B3F7076;
        Thu, 23 Dec 2021 23:07:49 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 1BO77np9018000;
        Thu, 23 Dec 2021 23:07:49 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 1BO77ns5017999;
        Thu, 23 Dec 2021 23:07:49 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 13/16] qla2xxx: Fix T10 PI tag escape and IP guard options for 28XX adapters
Date:   Thu, 23 Dec 2021 23:07:09 -0800
Message-ID: <20211224070712.17905-14-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20211224070712.17905-1-njavali@marvell.com>
References: <20211224070712.17905-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: tGprSdk6N39KiWOy6KG5WTqGd-YC_6lW
X-Proofpoint-ORIG-GUID: tGprSdk6N39KiWOy6KG5WTqGd-YC_6lW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-24_02,2021-12-24_01,2021-12-02_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

28XX adapters are capable of detecting both T10 PI tag escape values
as well as IP guard. This was missed due to the adapter type missed
in the corresponding macros. Fix this by adding support for 28xx in
those macros.

Cc: stable@vger.kernel.org
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_def.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index bc0c5df77801..81ca0cba9055 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -4271,8 +4271,10 @@ struct qla_hw_data {
 #define QLA_ABTS_WAIT_ENABLED(_sp) \
 	(QLA_NVME_IOS(_sp) && QLA_ABTS_FW_ENABLED(_sp->fcport->vha->hw))
 
-#define IS_PI_UNINIT_CAPABLE(ha)	(IS_QLA83XX(ha) || IS_QLA27XX(ha))
-#define IS_PI_IPGUARD_CAPABLE(ha)	(IS_QLA83XX(ha) || IS_QLA27XX(ha))
+#define IS_PI_UNINIT_CAPABLE(ha)	(IS_QLA83XX(ha) || IS_QLA27XX(ha) || \
+					 IS_QLA28XX(ha))
+#define IS_PI_IPGUARD_CAPABLE(ha)	(IS_QLA83XX(ha) || IS_QLA27XX(ha) || \
+					 IS_QLA28XX(ha))
 #define IS_PI_DIFB_DIX0_CAPABLE(ha)	(0)
 #define IS_PI_SPLIT_DET_CAPABLE_HBA(ha)	(IS_QLA83XX(ha) || IS_QLA27XX(ha) || \
 					IS_QLA28XX(ha))
-- 
2.23.1

