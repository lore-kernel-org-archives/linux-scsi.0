Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B0FCC4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Dec 2022 04:50:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237327AbiLNEuv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Dec 2022 23:50:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237314AbiLNEu3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Dec 2022 23:50:29 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21FFEEE2F
        for <linux-scsi@vger.kernel.org>; Tue, 13 Dec 2022 20:50:29 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BE3gC9K020064
        for <linux-scsi@vger.kernel.org>; Tue, 13 Dec 2022 20:50:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=T1i6YVbMtxYYQyz0rkJ0IgR9RV0z9ZBsrz5RaCCQs7g=;
 b=W9L2iaqgqT5bBPgSg+Lf8OQi1ZBihU0Ptu4cf3H8+XGeURarTR3RBcezlAztFRztou21
 eY5EFNfeJhmMN/0vr2dcVyHBLCk6GFs3oa4jJkPx6WU09E+LAa1redQs1Y8BQqXsrKTb
 W+MF6BicIYdMSF6+Ps2OxoVd8vA4giqAq8xve3MKUhPjNPcQSJl2PmYKUkx4PmICDiel
 +pipODCn5huvmkTZ4hurL9+aYAdRkfeIYDQfGrxNRH3cc09augFxnZiNBv3NzPsS1ZLn
 wRVlhjDuyHsR8tML6A+uNYiPgHFvZk8TMc6h4LV8o941tbgR+KnqP87H5R/nUIP2G29p sQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3mf6tj078c-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 13 Dec 2022 20:50:28 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 13 Dec
 2022 20:50:25 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Tue, 13 Dec 2022 20:50:25 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 3A7293F707D;
        Tue, 13 Dec 2022 20:50:25 -0800 (PST)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>
Subject: [PATCH 09/10] qla2xxx: Remove increment of interface err cnt
Date:   Tue, 13 Dec 2022 20:50:13 -0800
Message-ID: <20221214045014.19362-10-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20221214045014.19362-1-njavali@marvell.com>
References: <20221214045014.19362-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 1UXUSuZPV_98AWm4by6-y3v8J9eijbNP
X-Proofpoint-GUID: 1UXUSuZPV_98AWm4by6-y3v8J9eijbNP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_02,2022-12-13_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Saurav Kashyap <skashyap@marvell.com>

Residual under-run is not an interface error, hence no need to
increment that count.
Remove increment of the error count for under-run case.

Fixes: dbf1f53cfd23 ("scsi: qla2xxx: Implementation to get and manage host, target stats and initiator port")
Cc: stable@vger.kernel.org
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_isr.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 759bea69de12..cbbd7014da93 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3363,8 +3363,6 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 				       "Dropped frame(s) detected (0x%x of 0x%x bytes).\n",
 				       resid, scsi_bufflen(cp));
 
-				vha->interface_err_cnt++;
-
 				res = DID_ERROR << 16 | lscsi_status;
 				goto check_scsi_status;
 			}
-- 
2.19.0.rc0

