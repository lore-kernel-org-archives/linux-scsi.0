Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EE5FC4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Jan 2022 05:03:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238600AbiAJFDL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Jan 2022 00:03:11 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:11902 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234179AbiAJFC6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 Jan 2022 00:02:58 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 209MWKE1024446
        for <linux-scsi@vger.kernel.org>; Sun, 9 Jan 2022 21:02:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=OvoEqcIkfZsdgNGfz/JF4IQH7aTtT7SB4vYLgboThKk=;
 b=ca1L5zbnjlVq44PzoKBtJBGlRF9bB/7SJe+i7y+R1mSyerrLL/SAn9s0gCMMum9LeOop
 or9z7umtOxwTyHXM7E1vLC1ULtpdCiiQ2rwA9PiOE20RhxbTcapXqjk8Jnmbb5u2ZoIJ
 q75xE5PakeiiimB1zcs0kulfPngiZL/ogR2M6/QcNYXAbq8sHQ64Bog9flByk5EwpVbN
 wX1TvLmF3BtsrudA3a4fBYyhazSJbguTs+T6IDD5TUl673WS5lv9oE4SFr9FfE5cESQ0
 MnXw6kviXG/yeduNkP+27sLfbxKSYJxxbOBBlZIlZukSp6Doko7m41n2kxiWYNrdNhzp kw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3dg7nks0qj-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Sun, 09 Jan 2022 21:02:57 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 9 Jan
 2022 21:02:55 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Sun, 9 Jan 2022 21:02:55 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id C80103F70A6;
        Sun,  9 Jan 2022 21:02:55 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 20A52tCO004057;
        Sun, 9 Jan 2022 21:02:55 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 20A52ttx004056;
        Sun, 9 Jan 2022 21:02:55 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 16/17] qla2xxx: check for firmware dump already collected
Date:   Sun, 9 Jan 2022 21:02:17 -0800
Message-ID: <20220110050218.3958-17-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220110050218.3958-1-njavali@marvell.com>
References: <20220110050218.3958-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: IaZ-_HU-oJMaGGvFQ32ZGDVnqCKTXW-m
X-Proofpoint-ORIG-GUID: IaZ-_HU-oJMaGGvFQ32ZGDVnqCKTXW-m
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-10_01,2022-01-07_01,2021-12-02_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@cavium.com>

While allocating firmware dump, check if dump is already
collected and do not re-allocate the buffer.

Cc: stable@vger.kernel.org
Signed-off-by: Joe Carnuccio <joe.carnuccio@cavium.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
v1->v2:
- update author of patch
- commit this patch as a separate fix

 drivers/scsi/qla2xxx/qla_init.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index acc39a08454c..835ed4179887 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3482,6 +3482,14 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 	struct rsp_que *rsp = ha->rsp_q_map[0];
 	struct qla2xxx_fw_dump *fw_dump;
 
+	if (ha->fw_dump) {
+		ql_dbg(ql_dbg_init, vha, 0x00bd,
+		    "Firmware dump already allocated.\n");
+		return;
+	}
+
+	ha->fw_dumped = 0;
+	ha->fw_dump_cap_flags = 0;
 	dump_size = fixed_size = mem_size = eft_size = fce_size = mq_size = 0;
 	req_q_size = rsp_q_size = 0;
 
-- 
2.23.1

