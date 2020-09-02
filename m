Return-Path: <SRS0=1vUj=CL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BE1DC433E6
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 07:28:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D1D52072A
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 07:28:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="egdrFMNa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgIBH2l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 03:28:41 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:42556 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726183AbgIBH2k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2020 03:28:40 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0827PQdT023726
        for <linux-scsi@vger.kernel.org>; Wed, 2 Sep 2020 00:28:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=qoRt9JOr9tD7ylGycmT52IP5m+l45Ks2NWab+X0v54M=;
 b=egdrFMNameLB2/FB0QWT+RD/ffINeJVc9XHJ/AVplaE9xSPP7DbCc8tvOo0qZnqPStR6
 JPU6hR+FW42UV9rpvg/icKLP0fbiZiA40ERgnz6Fj5kVn7Y2V3OP0vTBB0XqUHilPjMV
 Pt9IS2A3StxusIgooxwrcaZjivXQw1aiBhLZUC1ekXQa4d5XxnKedBZnK7amOJkSTgP8
 kG8fkUBRCFBC33Q3kTLJdh2jdVvpRjzfkkDS2VJQbLWs7fJjrYwD6bWYz7oICmuqazDY
 0IkHcdmdST8KMo/g0+24SQq0z6eBr1nYuMfhyxj/fny+W7S5stGx7o50TONrDX90UK6v ow== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 337phq54cx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 02 Sep 2020 00:28:39 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Sep
 2020 00:28:37 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Sep 2020 00:28:37 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 97F3A3F703F;
        Wed,  2 Sep 2020 00:28:37 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0827SbnF011575;
        Wed, 2 Sep 2020 00:28:37 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0827SbWU011574;
        Wed, 2 Sep 2020 00:28:37 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 06/13] qla2xxx: Fix memory size truncation
Date:   Wed, 2 Sep 2020 00:25:41 -0700
Message-ID: <20200902072548.11491-7-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200902072548.11491-1-njavali@marvell.com>
References: <20200902072548.11491-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-02_03:2020-09-02,2020-09-02 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Memory size calculation for Extended Login use in hardware
offload was truncated when the setting was set with higher
value.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_def.h | 2 +-
 drivers/scsi/qla2xxx/qla_mbx.c | 7 ++++---
 drivers/scsi/qla2xxx/qla_os.c  | 5 +++--
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 074d8753cfc3..ad4a0ba7203c 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -4216,7 +4216,7 @@ struct qla_hw_data {
 	/* Extended Logins  */
 	void		*exlogin_buf;
 	dma_addr_t	exlogin_buf_dma;
-	int		exlogin_size;
+	uint32_t	exlogin_size;
 
 #define ENABLE_EXCHANGE_OFFLD	BIT_2
 
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 989327868dd8..ab7dbbc99c22 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -845,7 +845,7 @@ qla_get_exlogin_status(scsi_qla_host_t *vha, uint16_t *buf_sz,
  * Context:
  *	Kernel context.
  */
-#define CONFIG_XLOGINS_MEM	0x3
+#define CONFIG_XLOGINS_MEM	0x9
 int
 qla_set_exlogin_mem_cfg(scsi_qla_host_t *vha, dma_addr_t phys_addr)
 {
@@ -872,8 +872,9 @@ qla_set_exlogin_mem_cfg(scsi_qla_host_t *vha, dma_addr_t phys_addr)
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(vha, mcp);
 	if (rval != QLA_SUCCESS) {
-		/*EMPTY*/
-		ql_dbg(ql_dbg_mbx, vha, 0x111b, "Failed=%x.\n", rval);
+		ql_dbg(ql_dbg_mbx, vha, 0x111b,
+		       "EXlogin Failed=%x. MB0=%x MB11=%x\n",
+		       rval, mcp->mb[0], mcp->mb[11]);
 	} else {
 		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x118c,
 		    "Done %s.\n", __func__);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 74e6a04850c0..31bfc0c088b7 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4379,11 +4379,12 @@ int
 qla2x00_set_exlogins_buffer(scsi_qla_host_t *vha)
 {
 	int rval;
-	uint16_t	size, max_cnt, temp;
+	uint16_t	size, max_cnt;
+	uint32_t temp;
 	struct qla_hw_data *ha = vha->hw;
 
 	/* Return if we don't need to alloacate any extended logins */
-	if (!ql2xexlogins)
+	if (ql2xexlogins <= MAX_FIBRE_DEVICES_2400)
 		return QLA_SUCCESS;
 
 	if (!IS_EXLOGIN_OFFLD_CAPABLE(ha))
-- 
2.19.0.rc0

