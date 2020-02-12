Return-Path: <SRS0=6k2I=4A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B80E3C3B187
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 21:44:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8889D21734
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 21:44:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="pCy/HSrg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729089AbgBLVor (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Feb 2020 16:44:47 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:18866 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728185AbgBLVor (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Feb 2020 16:44:47 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01CLejnc001672;
        Wed, 12 Feb 2020 13:44:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=jY8lquwpJrL9ZKV1niGQm3YgTnoNUQsdl+mGl2XFjqk=;
 b=pCy/HSrgBJT26VzvUspZVft8JvkaSlkiKWhSv9BPxsn0lwD+7iTcasVUNgG9kX8CMiQP
 BadNERuNf6vNtU8g/fIWKrJ4nsl8LqRI0+lA+pr7+j9rvtbRiq5r6BKz79QrDDIRaQZQ
 2rA17mflyPzGdvFjuMwah6Mx0I4wJmixDpNV6gkYZh8Za9peCtjbnrYyp2DbqqdZjgiT
 9yNzyOWSwhh9fz3CWxT3kf1gjOdMUC/dU+xN31SEahlt95SCr3G0oTi65SdW7O5e31qO
 bIlH4GUSIbCALnD4Ll0GLrxGtVebLvsOEtTmPgZ/rBeM0QCcQ2aSyi/cXevbNTiYukWb 9A== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2y4j5jt4ue-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 12 Feb 2020 13:44:44 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 Feb
 2020 13:44:42 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 12 Feb 2020 13:44:42 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id B84963F703F;
        Wed, 12 Feb 2020 13:44:42 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 01CLigeI025575;
        Wed, 12 Feb 2020 13:44:42 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 01CLigN8025574;
        Wed, 12 Feb 2020 13:44:42 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 02/25] qla2xxx: Move free of fcport out of interrupt context
Date:   Wed, 12 Feb 2020 13:44:13 -0800
Message-ID: <20200212214436.25532-3-hmadhani@marvell.com>
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

This patch moves freeing of fcport out of interrupt
context

Signed-off-by: Joe Carnuccio <joe.carnuccio@cavium.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index d7169e43f5e1..5870d26ab707 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -11,6 +11,14 @@
 #include <linux/delay.h>
 #include <linux/bsg-lib.h>
 
+static void qla2xxx_free_fcport_work(struct work_struct *work)
+{
+	struct fc_port *fcport = container_of(work, typeof(*fcport),
+	    free_work);
+
+	qla2x00_free_fcport(fcport);
+}
+
 /* BSG support for ELS/CT pass through */
 void qla2x00_bsg_job_done(srb_t *sp, int res)
 {
@@ -53,8 +61,10 @@ void qla2x00_bsg_sp_free(srb_t *sp)
 
 	if (sp->type == SRB_CT_CMD ||
 	    sp->type == SRB_FXIOCB_BCMD ||
-	    sp->type == SRB_ELS_CMD_HST)
-		qla2x00_free_fcport(sp->fcport);
+	    sp->type == SRB_ELS_CMD_HST) {
+		INIT_WORK(&sp->fcport->free_work, qla2xxx_free_fcport_work);
+		queue_work(ha->wq, &sp->fcport->free_work);
+	}
 
 	qla2x00_rel_sp(sp);
 }
-- 
2.12.0

