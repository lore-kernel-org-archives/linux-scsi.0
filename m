Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D8D5C04FDF
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Aug 2023 11:41:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234357AbjHALl3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Aug 2023 07:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234330AbjHALl0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Aug 2023 07:41:26 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E86E1723
        for <linux-scsi@vger.kernel.org>; Tue,  1 Aug 2023 04:41:24 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 371AacDQ014807
        for <linux-scsi@vger.kernel.org>; Tue, 1 Aug 2023 04:41:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=gX5GxrVMoUylURH6nFEv0HSpBKQOF73HT/Ngc0utrcI=;
 b=KYV4GWAcA6b3k5hf6y15OKynroGXA1Vr5NcnIDB447N1oSYw90579JupHMvTvUuX5BQN
 Dhfv/6um1cXyA8xl/4HySdESPIwXF9N9e/UaomoAWnKgVxbeyVJ0fOVVnWlpzu2Uvyxs
 ZIJWkbkNVYM9DoH8WU2edSTSvApwAU1NsTC5W8ucT/ns5cdL5DS10/LJOFB9zVfkd986
 8XFucRBDT+Nn23WhVRPaY7OOpTTUfMbtGGTKU46v4L0EXuMHcD6cMKOfEMUZK90xaIAm
 dLuV5CDKloIVx5tE3LDXvaQHJ/1hte9yHrnBzUPgDGVvhsA9b+oF9sdZSf0A33gUvkNG Cg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3s529k8e4c-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 01 Aug 2023 04:41:23 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Tue, 1 Aug
 2023 04:41:21 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Tue, 1 Aug 2023 04:41:21 -0700
Received: from localhost.marvell.com (unknown [10.30.46.195])
        by maili.marvell.com (Postfix) with ESMTP id 2A3045B6929;
        Tue,  1 Aug 2023 04:41:18 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH 08/10] qla2xxx: fix smatch warn for qla_init_iocb_limit
Date:   Tue, 1 Aug 2023 17:10:55 +0530
Message-ID: <20230801114057.27039-9-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20230801114057.27039-1-njavali@marvell.com>
References: <20230801114057.27039-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: a-tP17dZg86z66f8XeycLTrsBbQ_knlX
X-Proofpoint-ORIG-GUID: a-tP17dZg86z66f8XeycLTrsBbQ_knlX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-01_06,2023-08-01_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix indentation for warning reported by smatch,
drivers/scsi/qla2xxx/qla_init.c:4199 qla_init_iocb_limit() warn: inconsistent indenting

Cc: stable@vger.kernel.org
Fixes: efa74a62aaa2 ("scsi: qla2xxx: Adjust IOCB resource on qpair create")
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 3ab90c159034..62087ce51b3f 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4205,7 +4205,7 @@ void qla_init_iocb_limit(scsi_qla_host_t *vha)
 	u8 i;
 	struct qla_hw_data *ha = vha->hw;
 
-	 __qla_adjust_iocb_limit(ha->base_qpair);
+	__qla_adjust_iocb_limit(ha->base_qpair);
 	ha->base_qpair->fwres.iocbs_used = 0;
 	ha->base_qpair->fwres.exch_used  = 0;
 
-- 
2.23.1

