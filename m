Return-Path: <SRS0=dnbB=CN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7446CC43461
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Sep 2020 04:54:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4932F206E7
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Sep 2020 04:54:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="RtIVQgWE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726114AbgIDEyU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Sep 2020 00:54:20 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:11726 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725765AbgIDEyT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Sep 2020 00:54:19 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0844ofcL011264
        for <linux-scsi@vger.kernel.org>; Thu, 3 Sep 2020 21:54:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=YFywxh1eiZn3irfzoEHKnw55+Vx7mvTgHVlO46UG3ZY=;
 b=RtIVQgWEPAs7RIbpk+Z+QudogNC4yJ33ZDBOxS5kT0HfSiBk2+sPGEg1+DOpvtNNDBv8
 x6Nx0xYDb0rB3NHc7rAXEYypSzaoGfF1WdL6kE3GcmkJwfjhnwcTpFXzFpgdfIa/gI5W
 sZyaS0aMjEo3FV14y3y4TQtN6ezSEEn7tnl9Zzv00NqvK+KJ0gQjw+Savpj7VzVMt2zc
 4hD4/fnTwUPCeIZOEdJy2B/uqgv2qTZPdMk88eAAGf2k8lCd9XKD5jFgnC9Iq8bvt2h9
 gpyR44i1mXbJ4X4JiIeKKuDhzkntKRRppucu5mgFnRsU0v2xfc89JSakUWJ/6hS91lEH cg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 337mcqrq7u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 03 Sep 2020 21:54:19 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Sep
 2020 21:54:18 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Sep
 2020 21:54:17 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 3 Sep 2020 21:54:17 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 5AE8C3F7051;
        Thu,  3 Sep 2020 21:54:17 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0844sHGs023715;
        Thu, 3 Sep 2020 21:54:17 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0844sHvx023706;
        Thu, 3 Sep 2020 21:54:17 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v3 06/13] qla2xxx: Fix memory size truncation
Date:   Thu, 3 Sep 2020 21:51:21 -0700
Message-ID: <20200904045128.23631-7-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200904045128.23631-1-njavali@marvell.com>
References: <20200904045128.23631-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-04_02:2020-09-03,2020-09-04 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Memory size calculations for Extended Login used in hardware Offload got
truncated. Fix this by changing definition of exlogin_size to use uint32_t.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_def.h | 2 +-
 drivers/scsi/qla2xxx/qla_mbx.c | 7 ++++---
 drivers/scsi/qla2xxx/qla_os.c  | 5 +++--
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 6d6d74e3546c..23438fc8f562 100644
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
index 226f1428d3e5..6ce106096ecc 100644
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
index f10a43ac1ec7..858549e21aea 100644
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

