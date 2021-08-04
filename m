Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C67B8C4338F
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Aug 2021 22:14:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B06F61073
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Aug 2021 22:14:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235066AbhHDWOi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Aug 2021 18:14:38 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:27916 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231249AbhHDWOi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Aug 2021 18:14:38 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 174MB3rK004280;
        Wed, 4 Aug 2021 15:14:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=pfpt0220;
 bh=vUQXKsJrKxhQZ7tL5J7usA+nOKw5Bzy+spqaVaWMLLY=;
 b=hutqmBod2zk4IyzGozV7eMfkbhJqR45ObYqJ4Q5v0jYzIpFRHKZZ6dEqQyqpXQ+VTvM4
 6F8EbCpb1nLh2dOVxlibCCWLnqrQKl4WLn6q6ZA27drZ5ZZk/cjKBEvh0xuMYuKnn4/r
 cTTtMf/TneVCZMXQKehcDLFZ6JD2N1LzqRLq2rvJm+Qlvr4UlOMMnjHjSfukPpkBZPes
 CDmg/G2tyyAScnniyWwWGDp4ez3MyqBJ2sIbbm7UuPJQF4stsSOsMrYkYPdvjL7MWWk6
 kqgS0g43HkCvwkTHbqf6Pxl/sUZDG2ASTjIXLkejpjAkf0SzL4AspiQUlLB14QGCDdKW vQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3a7aub4q2m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 04 Aug 2021 15:14:24 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 4 Aug
 2021 15:14:21 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server id
 15.0.1497.18 via Frontend Transport; Wed, 4 Aug 2021 15:14:20 -0700
From:   Shai Malin <smalin@marvell.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <GR-QLogic-Storage-Upstream@marvell.com>, <smalin@marvell.com>,
        <malin1024@gmail.com>, Manish Rangankar <mrangankar@marvell.com>
Subject: [PATCH v2] scsi: qedi: Add support for fastpath doorvell recovery
Date:   Thu, 5 Aug 2021 01:14:12 +0300
Message-ID: <20210804221412.5048-1-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: nYG5rKEwSP2cXHXqycPMOSRtzGwteJJZ
X-Proofpoint-GUID: nYG5rKEwSP2cXHXqycPMOSRtzGwteJJZ
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-04_07:2021-08-04,2021-08-04 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Driver fastpath employs doorbells to indicate to the device that work
is available. Each doorbell translates to a message sent to the device
over the pci. These messages are queued by the doorbell queue HW block,
and handled by the HW.
If a sufficient amount of CPU cores are sending messages at a sufficient
rate, the queue can overflow, and messages can be dropped. There are
many entities in the driver which can send doorbell messages.
When overflow happens, a fatal HW attention is indicated, and the
Doorbell HW block stops accepting new doorbell messages until recovery
procedure is done.

When overflow occurs, all doorbells are dropped. Since doorbells are
aggregatives, if more doorbells are sent nothing has to be done.
But if the "last" doorbell is dropped, the doorbelling entity doesn’t know
this happened, and may wait forever for the device to perform the action.
The doorbell recovery mechanism addresses just that - it sends the last
doorbell of every entity.

Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
---
 drivers/scsi/qedi/qedi_fw.c    | 14 ++++----------
 drivers/scsi/qedi/qedi_iscsi.c | 33 ++++++++++++++++++++++++++++++++-
 drivers/scsi/qedi/qedi_iscsi.h |  1 +
 3 files changed, 37 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 71333d3c5c86..e7064f62c833 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -936,17 +936,11 @@ void qedi_fp_process_cqes(struct qedi_work *work)
 
 static void qedi_ring_doorbell(struct qedi_conn *qedi_conn)
 {
-	struct iscsi_db_data dbell = { 0 };
+	qedi_conn->ep->db_data.sq_prod = qedi_conn->ep->fw_sq_prod_idx;
 
-	dbell.agg_flags = 0;
-
-	dbell.params |= DB_DEST_XCM << ISCSI_DB_DATA_DEST_SHIFT;
-	dbell.params |= DB_AGG_CMD_SET << ISCSI_DB_DATA_AGG_CMD_SHIFT;
-	dbell.params |=
-		   DQ_XCM_ISCSI_SQ_PROD_CMD << ISCSI_DB_DATA_AGG_VAL_SEL_SHIFT;
-
-	dbell.sq_prod = qedi_conn->ep->fw_sq_prod_idx;
-	writel(*(u32 *)&dbell, qedi_conn->ep->p_doorbell);
+	/* wmb - Make sure fw idx is coherent */
+	wmb();
+	writel(*(u32 *)&qedi_conn->ep->db_data, qedi_conn->ep->p_doorbell);
 
 	/* Make sure fw write idx is coherent, and include both memory barriers
 	 * as a failsafe as for some architectures the call is the same but on
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 97f83760da88..8ac8aabc1ef6 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -499,8 +499,8 @@ static u16 qedi_calc_mss(u16 pmtu, u8 is_ipv6, u8 tcp_ts_en, u8 vlan_en)
 
 static int qedi_iscsi_offload_conn(struct qedi_endpoint *qedi_ep)
 {
-	struct qedi_ctx *qedi = qedi_ep->qedi;
 	struct qed_iscsi_params_offload *conn_info;
+	struct qedi_ctx *qedi = qedi_ep->qedi;
 	int rval;
 	int i;
 
@@ -577,8 +577,34 @@ static int qedi_iscsi_offload_conn(struct qedi_endpoint *qedi_ep)
 		  "Default cq index [%d], mss [%d]\n",
 		  conn_info->default_cq, conn_info->mss);
 
+	/* Prepare the doorbell parameters */
+	qedi_ep->db_data.agg_flags = 0;
+	qedi_ep->db_data.params = 0;
+	SET_FIELD(qedi_ep->db_data.params, ISCSI_DB_DATA_DEST, DB_DEST_XCM);
+	SET_FIELD(qedi_ep->db_data.params, ISCSI_DB_DATA_AGG_CMD,
+		  DB_AGG_CMD_MAX);
+	SET_FIELD(qedi_ep->db_data.params, ISCSI_DB_DATA_AGG_VAL_SEL,
+		  DQ_XCM_ISCSI_SQ_PROD_CMD);
+	SET_FIELD(qedi_ep->db_data.params, ISCSI_DB_DATA_BYPASS_EN, 1);
+
+	/* Register doorbell with doorbell recovery mechanism */
+	rval = qedi_ops->common->db_recovery_add(qedi->cdev,
+						 qedi_ep->p_doorbell,
+						 &qedi_ep->db_data,
+						 DB_REC_WIDTH_32B,
+						 DB_REC_KERNEL);
+	if (rval) {
+		kfree(conn_info);
+		return rval;
+	}
+
 	rval = qedi_ops->offload_conn(qedi->cdev, qedi_ep->handle, conn_info);
 	if (rval)
+		/* delete doorbell from doorbell recovery mechanism */
+		rval = qedi_ops->common->db_recovery_del(qedi->cdev,
+							 qedi_ep->p_doorbell,
+							 &qedi_ep->db_data);
+
 		QEDI_ERR(&qedi->dbg_ctx, "offload_conn returned %d, ep=%p\n",
 			 rval, qedi_ep);
 
@@ -1109,6 +1135,11 @@ static void qedi_ep_disconnect(struct iscsi_endpoint *ep)
 	    test_bit(QEDI_IN_RECOVERY, &qedi->flags))
 		goto ep_release_conn;
 
+	/* Delete doorbell from doorbell recovery mechanism */
+	ret = qedi_ops->common->db_recovery_del(qedi->cdev,
+					       qedi_ep->p_doorbell,
+					       &qedi_ep->db_data);
+
 	ret = qedi_ops->destroy_conn(qedi->cdev, qedi_ep->handle, abrt_conn);
 	if (ret) {
 		QEDI_WARN(&qedi->dbg_ctx,
diff --git a/drivers/scsi/qedi/qedi_iscsi.h b/drivers/scsi/qedi/qedi_iscsi.h
index 758735209e15..a31c5de74754 100644
--- a/drivers/scsi/qedi/qedi_iscsi.h
+++ b/drivers/scsi/qedi/qedi_iscsi.h
@@ -80,6 +80,7 @@ struct qedi_endpoint {
 	u32 handle;
 	u32 fw_cid;
 	void __iomem *p_doorbell;
+	struct iscsi_db_data db_data;
 
 	/* Send queue management */
 	struct iscsi_wqe *sq;
-- 
2.22.0

