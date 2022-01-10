Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4EABC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Jan 2022 05:03:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238582AbiAJFDI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Jan 2022 00:03:08 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:56922 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235083AbiAJFC7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 Jan 2022 00:02:59 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 209KQlqi023499
        for <linux-scsi@vger.kernel.org>; Sun, 9 Jan 2022 21:02:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=0JkCUCNRfqe4ubl2wSFs2oeT+MEFrQX1BPPLeYWyQ0g=;
 b=LhLwfV1S3zW/oAkSGKW+ldZB/i7ScszMUzl3iLCWVKNmu0bvVrqFLUzEZHFU5JiVzk2p
 zttIu9iD9xAeSndXhQt0RicOhApm+cv26plSlpIMkyn+2yCl09U7ZOoR2jK+oiOCeb1b
 94FjwnxP91p3buisqdUjCti5ZaHbLmrshPm2IrgjkalEcBST/iezzaPgtKY+Kw0N1038
 sxO40//sCwDXR6FLzmuP44/IAdUcLvsbmQStGF8xRzE/MS5ivVc4kEOR9Jr3aybBfEPA
 X8FfJUPdkM7FvWOCXcBsmuOcVmIRC4LcvfaPbRFVGNgAT9BiNAiNEDBhx4o82x4rorEx gg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3dfy8nhjf0-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Sun, 09 Jan 2022 21:02:58 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 9 Jan
 2022 21:02:55 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 9 Jan 2022 21:02:55 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id DD63D3F70A8;
        Sun,  9 Jan 2022 21:02:54 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 20A52sRN004021;
        Sun, 9 Jan 2022 21:02:54 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 20A52sFw004020;
        Sun, 9 Jan 2022 21:02:54 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 07/17] qla2xxx: add retry for exec fw
Date:   Sun, 9 Jan 2022 21:02:08 -0800
Message-ID: <20220110050218.3958-8-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220110050218.3958-1-njavali@marvell.com>
References: <20220110050218.3958-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: VRRWuGPuNJ-g6HfHjmXvBURUl6jCnPEU
X-Proofpoint-ORIG-GUID: VRRWuGPuNJ-g6HfHjmXvBURUl6jCnPEU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-10_01,2022-01-07_01,2021-12-02_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Per FW request, Exec FW can fail due to temp error resulting in driver not
attaching to the adapter. Add retry of this command up to 4 retries.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 38e0f02c75e1..c4bd8a16d78c 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -689,7 +689,7 @@ qla2x00_execute_fw(scsi_qla_host_t *vha, uint32_t risc_addr)
 	mbx_cmd_t *mcp = &mc;
 	u8 semaphore = 0;
 #define EXE_FW_FORCE_SEMAPHORE BIT_7
-	u8 retry = 3;
+	u8 retry = 5;
 
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1025,
 	    "Entered %s.\n", __func__);
@@ -764,6 +764,12 @@ qla2x00_execute_fw(scsi_qla_host_t *vha, uint32_t risc_addr)
 			goto again;
 		}
 
+		if (retry) {
+			retry--;
+			ql_dbg(ql_dbg_async, vha, 0x509d,
+			    "Exe FW retry: mb[0]=%x retry[%d]\n", mcp->mb[0], retry);
+			goto again;
+		}
 		ql_dbg(ql_dbg_mbx, vha, 0x1026,
 		    "Failed=%x mb[0]=%x.\n", rval, mcp->mb[0]);
 		vha->hw_err_cnt++;
-- 
2.23.1

