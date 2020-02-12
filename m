Return-Path: <SRS0=6k2I=4A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CD19C352A4
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 21:46:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F22E4206DB
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 21:46:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="RToMCx7P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728185AbgBLVqp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Feb 2020 16:46:45 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:64818 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727564AbgBLVqp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Feb 2020 16:46:45 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01CLeuJq001683;
        Wed, 12 Feb 2020 13:45:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=PFbXBW3ssNfdeTApurVvYV1ChkjUDaukOPGds+9dHI8=;
 b=RToMCx7PWGahGPFKqnmUSODAvbF1yZQ70+TVQZmBMJChXFu2/cNe0i2q5JZJAJK8Rvgi
 qPcED4SC5tdTUlXgMrc6BYNL5G5fj8LI0kTqmY7pPOCoFuPgyVOs1U344n21ZPF9RSLq
 0DO02CnXeYqxV6nBz7CT3L9IaxnUXo2nQivyKSAlkgj9mqi02MugZ0hxnCE2S5GUJHIt
 DFgtE/Phqw0sWrL3Wz1FAfARB2yKXmKJqTXlPcqvmIfc/SLYlvfUk9aoztd/Cj8PZvuM
 8GzXOFnsQipqnZbelUL5gtsNj2KFbk+wDOdQ8H7zieSaZA+QhAcSMFr4+D86QBniMT8/ 7w== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2y4j5jt51b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 12 Feb 2020 13:45:36 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 Feb
 2020 13:45:34 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 12 Feb 2020 13:45:34 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 9BF453F7040;
        Wed, 12 Feb 2020 13:45:34 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 01CLjYMp025652;
        Wed, 12 Feb 2020 13:45:34 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 01CLjYN4025651;
        Wed, 12 Feb 2020 13:45:34 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 19/25] qla2xxx: Print portname for logging in qla24xx_logio_entry()
Date:   Wed, 12 Feb 2020 13:44:30 -0800
Message-ID: <20200212214436.25532-20-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200212214436.25532-1-hmadhani@marvell.com>
References: <20200212214436.25532-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-12_10:2020-02-12,2020-02-12 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@cavium.com>

Add port name in the messages file to help debugging of
Login/Logout IOCBs

Signed-off-by: Joe Carnuccio <joe.carnuccio@cavium.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_isr.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 1089db774bd1..d03dd16ce1ea 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1899,11 +1899,9 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
 	}
 
 	if (le16_to_cpu(logio->comp_status) == CS_COMPLETE) {
-		ql_dbg(ql_dbg_async, fcport->vha, 0x5036,
-		    "Async-%s complete - %8phC hdl=%x portid=%02x%02x%02x "
-		    "iop0=%x.\n", type, fcport->port_name, sp->handle,
-		    fcport->d_id.b.domain,
-		    fcport->d_id.b.area, fcport->d_id.b.al_pa,
+		ql_dbg(ql_dbg_async, sp->vha, 0x5036,
+		    "Async-%s complete: handle=%x pid=%06x wwpn=%8phC iop0=%x\n",
+		    type, sp->handle, fcport->d_id.b24, fcport->port_name,
 		    le32_to_cpu(logio->io_parameter[0]));
 
 		vha->hw->exch_starvation = 0;
@@ -1982,11 +1980,9 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
 		break;
 	}
 
-	ql_dbg(ql_dbg_async, fcport->vha, 0x5037,
-	    "Async-%s failed - %8phC hdl=%x portid=%02x%02x%02x comp=%x "
-	    "iop0=%x iop1=%x.\n", type, fcport->port_name,
-		sp->handle, fcport->d_id.b.domain,
-	    fcport->d_id.b.area, fcport->d_id.b.al_pa,
+	ql_dbg(ql_dbg_async, sp->vha, 0x5037,
+	    "Async-%s failed: handle=%x pid=%06x wwpn=%8phC comp_status=%x iop0=%x iop1=%x\n",
+	    type, sp->handle, fcport->d_id.b24, fcport->port_name,
 	    le16_to_cpu(logio->comp_status),
 	    le32_to_cpu(logio->io_parameter[0]),
 	    le32_to_cpu(logio->io_parameter[1]));
-- 
2.12.0

