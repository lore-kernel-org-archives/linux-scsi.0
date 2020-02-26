Return-Path: <SRS0=mj/2=4O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08F1AC4BA2D
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 22:40:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD9AB20658
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 22:40:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="jW1mjFH8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbgBZWkv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Feb 2020 17:40:51 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:4672 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727887AbgBZWkv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Feb 2020 17:40:51 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01QMeN5w006111;
        Wed, 26 Feb 2020 14:40:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=CMo3ILRzhOjT7+PZgklyYcureCVOLGG7oP20P+dZmsk=;
 b=jW1mjFH89QOdbOqrieKy53oQ4TAWoxOt0QKcdUInW6HOhb59gG+NyYPs2zsWrG0AI55r
 S58gKRAJW5hDKaGS7uv0IXWM57BlisHRHTZ6OMuIcu7al7Qrr+MSdjBOs2d+E3FrHXLv
 GJrWTcwX+oI4z6XFpiHFbUvJY1UtRIQ9OQLC3OKXcroUfK1PHHtYhS4yPtiowcVz4v4F
 96gm1mByTG5liH9ItH/xdVQF+T4Xf3D5inSgJ5OBgGI7vmYV3MTu7hZ70CuUT8/UEISN
 mu2xByXQkfjSXXmaicSJNvqw1/iEyOyhtRf2hcBci0AtpwodUgIBJefBbMKHQfED5Wkw aA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2ydchtd6m0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 26 Feb 2020 14:40:48 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 Feb
 2020 14:40:46 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 Feb
 2020 14:40:45 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 26 Feb 2020 14:40:45 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id B9CFE3F703F;
        Wed, 26 Feb 2020 14:40:45 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 01QMejbk024581;
        Wed, 26 Feb 2020 14:40:45 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 01QMejGC024580;
        Wed, 26 Feb 2020 14:40:45 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 07/18] qla2xxx: Use a dedicated interrupt handler for 'handshake-required' ISPs
Date:   Wed, 26 Feb 2020 14:40:11 -0800
Message-ID: <20200226224022.24518-8-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200226224022.24518-1-hmadhani@marvell.com>
References: <20200226224022.24518-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-26_09:2020-02-26,2020-02-26 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrewv@marvell.com>

There's no point checking flags.disable_msix_handshake in the
interrupt handler hot-path.  Instead perform the check during
queue-pair instantiation and use the proper interrupt handler.

Signed-off-by: Andrew Vasquez <andrewv@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_def.h |  1 +
 drivers/scsi/qla2xxx/qla_gbl.h |  2 ++
 drivers/scsi/qla2xxx/qla_isr.c | 31 ++++++++++++++++++++++++-------
 drivers/scsi/qla2xxx/qla_mid.c |  3 ++-
 4 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 17367639953c..1104b7837450 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3250,6 +3250,7 @@ struct isp_operations {
 #define QLA_MSIX_RSP_Q			0x01
 #define QLA_ATIO_VECTOR		0x02
 #define QLA_MSIX_QPAIR_MULTIQ_RSP_Q	0x03
+#define QLA_MSIX_QPAIR_MULTIQ_RSP_Q_HS	0x04
 
 #define QLA_MIDX_DEFAULT	0
 #define QLA_MIDX_RSP_Q		1
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 73b663defee1..33ea79181dd7 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -565,6 +565,8 @@ qla2x00_process_completed_request(struct scsi_qla_host *, struct req_que *,
 	uint32_t);
 extern irqreturn_t
 qla2xxx_msix_rsp_q(int irq, void *dev_id);
+extern irqreturn_t
+qla2xxx_msix_rsp_q_hs(int irq, void *dev_id);
 fc_port_t *qla2x00_find_fcport_by_loopid(scsi_qla_host_t *, uint16_t);
 fc_port_t *qla2x00_find_fcport_by_wwpn(scsi_qla_host_t *, u8 *, u8);
 fc_port_t *qla2x00_find_fcport_by_nportid(scsi_qla_host_t *, port_id_t *, u8);
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 7c0c32d5d6ec..2c6e25f831f3 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3601,6 +3601,25 @@ qla2xxx_msix_rsp_q(int irq, void *dev_id)
 {
 	struct qla_hw_data *ha;
 	struct qla_qpair *qpair;
+
+	qpair = dev_id;
+	if (!qpair) {
+		ql_log(ql_log_info, NULL, 0x505b,
+		    "%s: NULL response queue pointer.\n", __func__);
+		return IRQ_NONE;
+	}
+	ha = qpair->hw;
+
+	queue_work(ha->wq, &qpair->q_work);
+
+	return IRQ_HANDLED;
+}
+
+irqreturn_t
+qla2xxx_msix_rsp_q_hs(int irq, void *dev_id)
+{
+	struct qla_hw_data *ha;
+	struct qla_qpair *qpair;
 	struct device_reg_24xx __iomem *reg;
 	unsigned long flags;
 
@@ -3612,13 +3631,10 @@ qla2xxx_msix_rsp_q(int irq, void *dev_id)
 	}
 	ha = qpair->hw;
 
-	/* Clear the interrupt, if enabled, for this response queue */
-	if (unlikely(!ha->flags.disable_msix_handshake)) {
-		reg = &ha->iobase->isp24;
-		spin_lock_irqsave(&ha->hardware_lock, flags);
-		WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
-		spin_unlock_irqrestore(&ha->hardware_lock, flags);
-	}
+	reg = &ha->iobase->isp24;
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	queue_work(ha->wq, &qpair->q_work);
 
@@ -3637,6 +3653,7 @@ static const struct qla_init_msix_entry msix_entries[] = {
 	{ "rsp_q", qla24xx_msix_rsp_q },
 	{ "atio_q", qla83xx_msix_atio_q },
 	{ "qpair_multiq", qla2xxx_msix_rsp_q },
+	{ "qpair_multiq_hs", qla2xxx_msix_rsp_q_hs },
 };
 
 static const struct qla_init_msix_entry qla82xx_msix_entries[] = {
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index e86c94f78196..d82e92da529a 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -896,7 +896,8 @@ qla25xx_create_rsp_que(struct qla_hw_data *ha, uint16_t options,
 	    rsp->rsp_q_out);
 
 	ret = qla25xx_request_irq(ha, qpair, qpair->msix,
-	    QLA_MSIX_QPAIR_MULTIQ_RSP_Q);
+		ha->flags.disable_msix_handshake ?
+		QLA_MSIX_QPAIR_MULTIQ_RSP_Q : QLA_MSIX_QPAIR_MULTIQ_RSP_Q_HS);
 	if (ret)
 		goto que_failed;
 
-- 
2.12.0

