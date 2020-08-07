Return-Path: <SRS0=GwgI=BR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8BA3C433DF
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Aug 2020 11:11:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B8D822C9F
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Aug 2020 11:11:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="TQ58OtKz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728339AbgHGLLg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Aug 2020 07:11:36 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:38384 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728142AbgHGLJ1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Aug 2020 07:09:27 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 077AtEqY025459
        for <linux-scsi@vger.kernel.org>; Fri, 7 Aug 2020 04:08:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=PjZ4TO4Ajc7JWN0nyMl6u12uPAXSb9iXWRPdM0jTG6I=;
 b=TQ58OtKzootZlK9weirgp1LWuVgQvRfup568jGFvCBrgaUA9BEiv/oa9dFNrbDq3UZJQ
 Z1gNXp6ObejHNW8cm/1lNrtt1D2JX52MZu9anqrf/zjHfLrI5+SlCOK0XQj5akDio/gp
 t9MM5P9g9AnCG6zeHyUg4ysOkF0v8RG9IAb/x2T3zwL7p5h7bxAAktCLTE8ec/k6iGAU
 DCDF8+xa4/Fst4RD0BLLfV1KfzBdxkZwCEp+vHlq0GO8foNJ8YShlOZHWps2bGBE4gsc
 B1Sp1jVEV495ygpuNiI0LoRYrCYST6SOegfq8OahzDipuZeK+SKe6o9iNt4ITtF2LlJ8 wQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 32n6ch1f12-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 07 Aug 2020 04:08:59 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 7 Aug
 2020 04:08:58 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 7 Aug
 2020 04:08:57 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 7 Aug 2020 04:08:57 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 3A8443F703F;
        Fri,  7 Aug 2020 04:08:57 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 077B8vJT020033;
        Fri, 7 Aug 2020 04:08:57 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 077B8vIJ020023;
        Fri, 7 Aug 2020 04:08:57 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>
Subject: [PATCH 4/7] qedf: Send cleanup even for RRQ on timeout.
Date:   Fri, 7 Aug 2020 04:06:53 -0700
Message-ID: <20200807110656.19965-5-jhasan@marvell.com>
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

 -Send cleanup even for RRQ on timeout.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Javed Hasan <jhasan@marvell.com>
---
 drivers/scsi/qedf/qedf_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index acd9774..26d11cc 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -85,13 +85,13 @@ static void qedf_cmd_timeout(struct work_struct *work)
 		 */
 		QEDF_ERR(&(qedf->dbg_ctx), "ELS timeout, xid=0x%x.\n",
 			  io_req->xid);
+		qedf_initiate_cleanup(io_req, true);
 		io_req->event = QEDF_IOREQ_EV_ELS_TMO;
 		/* Call callback function to complete command */
 		if (io_req->cb_func && io_req->cb_arg) {
 			io_req->cb_func(io_req->cb_arg);
 			io_req->cb_arg = NULL;
 		}
-		qedf_initiate_cleanup(io_req, true);
 		kref_put(&io_req->refcount, qedf_release_cmd);
 		break;
 	case QEDF_SEQ_CLEANUP:
-- 
1.8.3.1

