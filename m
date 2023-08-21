Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC214EE4993
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Aug 2023 13:01:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235173AbjHUNBN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Aug 2023 09:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235176AbjHUNBI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Aug 2023 09:01:08 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C7E0D1
        for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2023 06:01:05 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37L0REcF007595
        for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2023 06:01:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=qwN3KTN74nQUEDjuQHavA4FPivgZ219j08b8q1x1BhE=;
 b=bM5iqR5JBbq5hsCPzM6bf4IsUAwVm2VwFs0+59H/0ovIbi7wmmGMjDExDUm0nqagEBR3
 HyVJyHfa/nNJplqa0JPvJzWuyP1xrEAv7U1uCgQZe3t4jGtFo4PB9omAVnFT5ZAiNiUP
 Ql0ILt/hOq1kE8PEeG4FozkmwEF4uSAsBDnUVQ1s1C824bJEufgva8iaTU1s+vPiPfBr
 By7cWtsusCofGSy/ngmCzFh5UUDl/zLJFxAnKV2pDLFaR+sfTah31HpNVa+F4/ds8ow2
 kvTkb3aYRf4iOy0VEN+ZbWqQ0zbBX6ugaqf6+z5OFP4rQV++4mNNfE4q72IdwyQFtMoJ sw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3sju3qmym9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2023 06:01:03 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Mon, 21 Aug
 2023 06:01:01 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Mon, 21 Aug 2023 06:01:01 -0700
Received: from localhost.marvell.com (unknown [10.30.46.195])
        by maili.marvell.com (Postfix) with ESMTP id B4D143F7081;
        Mon, 21 Aug 2023 06:00:59 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH v3 5/9] qla2xxx: Error code did not return to upper layer
Date:   Mon, 21 Aug 2023 18:30:41 +0530
Message-ID: <20230821130045.34850-6-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20230821130045.34850-1-njavali@marvell.com>
References: <20230821130045.34850-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: JWnP5F8WaPjgpL_uwZaPmZ5Ak1CJtBIR
X-Proofpoint-ORIG-GUID: JWnP5F8WaPjgpL_uwZaPmZ5Ak1CJtBIR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-21_01,2023-08-18_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

TMF was returned with an error code. The error code was not
preserved to be returned to upper layer. Instead, the error code
from the Marker was returned.

Preserve error code from TMF and return it to upper layer.

Cc: stable@vger.kernel.org
Fixes: da7c21b72aa8 ("scsi: qla2xxx: Fix command flush during TMF")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 7faf2109228e..3ab90c159034 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2223,6 +2223,8 @@ __qla2x00_async_tm_cmd(struct tmf_arg *arg)
 			rval = QLA_FUNCTION_FAILED;
 		}
 	}
+	if (tm_iocb->u.tmf.data)
+		rval = tm_iocb->u.tmf.data;
 
 done_free_sp:
 	/* ref: INIT */
-- 
2.23.1

