Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28454C4338F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 10:23:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DFFC6112D
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 10:23:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240050AbhHEKXj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 06:23:39 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:16622 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S240172AbhHEKXe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 06:23:34 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 175ABad7008164
        for <linux-scsi@vger.kernel.org>; Thu, 5 Aug 2021 03:23:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=oZYtUNEanl0Uf0YkNBtDty8IU+t6nyV0RmPG0LBTS0I=;
 b=Mqo51A/59aKHHm5mYozX2k33Dq+o/bl7TW3XvV3temWCZjYAjrTs65h2cDG/oq7ib7dO
 n2xCzPyFuZF17Ku4NmWH0KFxLGtosv5nmo4J1JzA0Y4f7tGkZMdWkdDNJ1oJiIlJjNm7
 tc3hJh760vNbKzHKHHn43ajJeMoMrH19VAsyCdOmfa3q0h5eCYv7A0e1htc1Oqj8JHfI
 uctfjS+TgYMsjXzI/9EsARgf+S4INUN6xDWDW43wgbzSCmmRjJuJwWmDSRxG+iF3xEKs
 Qcj0nUSj3pMpBa7sjCSsONbCdPyX4r9l7PV+HaJ81YidISIIcnuq+cXrNnMieFTy6JzC 7w== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3a8bkb8dv5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 03:23:20 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 5 Aug
 2021 03:23:19 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 5 Aug 2021 03:23:18 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 105753F705D;
        Thu,  5 Aug 2021 03:23:19 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 175ANIGF020270;
        Thu, 5 Aug 2021 03:23:18 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 175ANIIa020269;
        Thu, 5 Aug 2021 03:23:18 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 07/14] qla2xxx: fix port type info
Date:   Thu, 5 Aug 2021 03:19:58 -0700
Message-ID: <20210805102005.20183-8-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210805102005.20183-1-njavali@marvell.com>
References: <20210805102005.20183-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: l3mp766KMbDOyPlshM-vXiR4C59lRvj9
X-Proofpoint-ORIG-GUID: l3mp766KMbDOyPlshM-vXiR4C59lRvj9
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-05_03:2021-08-05,2021-08-05 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Over time, fcport->port_type became flag field. The flags within this field
were not defined properly. This caused external tools to read wrong info.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_def.h | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index c081bf1c7578..60702d066ed9 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2428,11 +2428,9 @@ struct mbx_24xx_entry {
  */
 typedef enum {
 	FCT_UNKNOWN,
-	FCT_RSCN,
-	FCT_SWITCH,
-	FCT_BROADCAST,
-	FCT_INITIATOR,
-	FCT_TARGET,
+	FCT_BROADCAST = 0x01,
+	FCT_INITIATOR = 0x02,
+	FCT_TARGET    = 0x04,
 	FCT_NVME_INITIATOR = 0x10,
 	FCT_NVME_TARGET = 0x20,
 	FCT_NVME_DISCOVERY = 0x40,
-- 
2.19.0.rc0

