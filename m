Return-Path: <SRS0=GwgI=BR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07847C433DF
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Aug 2020 11:11:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9B7022C9F
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Aug 2020 11:11:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="xmQpPgGj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728219AbgHGLL2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Aug 2020 07:11:28 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:59128 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728159AbgHGLJ1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Aug 2020 07:09:27 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 077ApApJ021074
        for <linux-scsi@vger.kernel.org>; Fri, 7 Aug 2020 04:09:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=PAGFjWAEDaoPA8v8ak+Zqw+nuelGQn3JlK7ZCXhM7Lo=;
 b=xmQpPgGjapsLprHj87aiFA4ZQndV6ZLNJPobuF6VYViAJaIss0PHTYBWlqNwWUHGS05i
 hkFZFG5WfGAdum9/ygdoatJstk4faabrvicJX9LbgH2DXGrXB9Z2brnc8ID6i7fl25wN
 55FKX+GIcwNtDZD5exRaC1pd1VBDLn8nwgog2GRnsnvT9C+EwBqjhFrfhugMg/XSa8vz
 8sZspJdu0KR7ZMb36BrCVJzOzDvxxEGgVyezzRl3wsxTn9hZXvB8F828mINrCf8XW/co
 C6L+To4LH8NZKH0fBzxXYXmsszegjCJuylM9qp4a165qcxDcf/HvtBaHBMLdmNjrNmKi dA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 32n6ch1f1q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 07 Aug 2020 04:09:22 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 7 Aug
 2020 04:09:21 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 7 Aug 2020 04:09:21 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 50A7E3F703F;
        Fri,  7 Aug 2020 04:09:21 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 077B9LbG020037;
        Fri, 7 Aug 2020 04:09:21 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 077B9LAU020036;
        Fri, 7 Aug 2020 04:09:21 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>
Subject: [PATCH 5/7] qedf: Initiate cleanup for ELS commands as well.
Date:   Fri, 7 Aug 2020 04:06:54 -0700
Message-ID: <20200807110656.19965-6-jhasan@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200807110656.19965-1-jhasan@marvell.com>
References: <20200807110656.19965-1-jhasan@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-07_06:2020-08-06,2020-08-07 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Saurav Kashyap <skashyap@marvell.com>

 Initiate cleanup for ELS commands as well.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Javed Hasan <jhasan@marvell.com>
---
 drivers/scsi/qedf/qedf_io.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index 26d11cc..7969f3a 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -1704,8 +1704,10 @@ void qedf_flush_active_ios(struct qedf_rport *fcport, int lun)
 				    io_req, io_req->xid);
 				continue;
 			}
+			qedf_initiate_cleanup(io_req, false);
 			flush_cnt++;
 			qedf_flush_els_req(qedf, io_req);
+
 			/*
 			 * Release the kref and go back to the top of the
 			 * loop.
@@ -2169,6 +2171,10 @@ int qedf_initiate_cleanup(struct qedf_ioreq *io_req,
 		return SUCCESS;
 	}
 
+	if (io_req->cmd_type == QEDF_ELS) {
+		goto process_els;
+	}
+
 	if (!test_bit(QEDF_CMD_OUTSTANDING, &io_req->flags) ||
 	    test_and_set_bit(QEDF_CMD_IN_CLEANUP, &io_req->flags)) {
 		QEDF_ERR(&(qedf->dbg_ctx), "io_req xid=0x%x already in "
@@ -2178,6 +2184,7 @@ int qedf_initiate_cleanup(struct qedf_ioreq *io_req,
 	}
 	set_bit(QEDF_CMD_IN_CLEANUP, &io_req->flags);
 
+process_els:
 	/* Ensure room on SQ */
 	if (!atomic_read(&fcport->free_sqes)) {
 		QEDF_ERR(&(qedf->dbg_ctx), "No SQ entries available\n");
-- 
1.8.3.1

