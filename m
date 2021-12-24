Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B102C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Dec 2021 07:08:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351792AbhLXHIF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Dec 2021 02:08:05 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:13356 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351760AbhLXHHx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Dec 2021 02:07:53 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BO2WGK0008452
        for <linux-scsi@vger.kernel.org>; Thu, 23 Dec 2021 23:07:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=vIdNVhrgine0fpPlzYac/fhddLOuCZDLeTy6fab6hAE=;
 b=CGz81BEsw32jcNzRJtqEKQaBPUhUKPjgS1fNUyLFbQEyJBm6+iQLAUsPBQa9LEhKWIT+
 wqKE98y+p2/22f2ybumzeRaJgZNr8gO8wqn/Mx8pw4mlZr77ODYdtMZQG3+1AzqPpFit
 fhp6W6Puw3P/sz3ml2C37+nZh/o75bVUbAQEsciqRWNQ7RnriEmoTNZcqRFwEPxzsLXu
 DLI8yUHAn/AVWiOFCnZMbW5QkyxqPRp8PjkCWRdT2PxR97d9bJYihtnkcJh9tyhpbYEu
 +Ni26A6NFDnACbVWsDGaT3/X5WHlYcJiBNiTRfy6arGLkXe3pNoFCc1CmsDRIfSdnUpk vg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3d4t6kjua2-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 23 Dec 2021 23:07:52 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 23 Dec
 2021 23:07:51 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 23 Dec 2021 23:07:51 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 4EBF23F7089;
        Thu, 23 Dec 2021 23:07:49 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 1BO77nWl017976;
        Thu, 23 Dec 2021 23:07:49 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 1BO77nW3017975;
        Thu, 23 Dec 2021 23:07:49 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 07/16] qla2xxx: add retry for exec fw
Date:   Thu, 23 Dec 2021 23:07:03 -0800
Message-ID: <20211224070712.17905-8-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20211224070712.17905-1-njavali@marvell.com>
References: <20211224070712.17905-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: QOwHB30ZrixVPtp95aYSvlDoo5MHQa6m
X-Proofpoint-ORIG-GUID: QOwHB30ZrixVPtp95aYSvlDoo5MHQa6m
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-24_02,2021-12-24_01,2021-12-02_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Per FW request, Exec FW can fail due to temp error resulting in driver not
attaching to the adapter. Add retry of this command up to 4 retries.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
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

