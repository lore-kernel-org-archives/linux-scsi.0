Return-Path: <SRS0=TRkT=B4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF8C5C433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 12:34:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCEA32065D
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 12:34:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="EbyEIWaf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbgHRMez (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Aug 2020 08:34:55 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:57010 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726611AbgHRMey (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Aug 2020 08:34:54 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07ICUB8k028501
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2020 05:34:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=xr2ytCTRKfqBC10S38rLdXzAWJ2q+YECSqQ+ewV8ZRY=;
 b=EbyEIWaf8O+YOTJ2KsQBEQxxye6o/Mnajz3P1Ef2YBgNCjKmSmfzzHH61akI5x24Tri5
 ZZoKGUAHSopXnT3rgPA2NJY0SOa5VQDVbW0FTCr4cla8dHACdPB3pyC+pMRvYeJ8MggK
 RLSyp9LXG6BJcvqLVj8zjamiFBXCaGnp1cKaWt+WzNC0RJOEz24VE2MC9KlmD5+jadTq
 hK/0LB0J4ixIlYYS4UCPvQzwnkqtLyZiWiJ8+IyMuWl0i1nGZgCH5AA+sPoqYxEA+Ma6
 bF3YLkFDvrkee/s8+oS8L/ilUfJIg0kKHwZx+RD2gQinbPlyqcm3MYe50flCTsxqhFgL GA== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 3304fhjene-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2020 05:34:54 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 18 Aug
 2020 05:34:53 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 18 Aug
 2020 05:34:52 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 18 Aug 2020 05:34:52 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 1D3ED3F7043;
        Tue, 18 Aug 2020 05:34:52 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 07ICYpX9020438;
        Tue, 18 Aug 2020 05:34:51 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 07ICYpii020437;
        Tue, 18 Aug 2020 05:34:51 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 06/12] qla2xxx: Fix memory size truncation
Date:   Tue, 18 Aug 2020 05:31:57 -0700
Message-ID: <20200818123203.20361-7-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200818123203.20361-1-njavali@marvell.com>
References: <20200818123203.20361-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_07:2020-08-18,2020-08-18 signatures=0
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

