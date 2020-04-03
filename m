Return-Path: <SRS0=YASp=5T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D338C43331
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Apr 2020 08:40:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6ADA42073B
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Apr 2020 08:40:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="HHK8xJUA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388472AbgDCIk0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Apr 2020 04:40:26 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:38038 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727868AbgDCIkZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Apr 2020 04:40:25 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0338e4dD011176
        for <linux-scsi@vger.kernel.org>; Fri, 3 Apr 2020 01:40:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=qw22gVUZcAE8pTYmel/jJbGVObKcOpjF043SPgWPl8U=;
 b=HHK8xJUAkNBevwonk/OAbC1PB9LH3bzvq4epKG7LNnIWg+ZKHCRBtlHxh5pqYcaz5+TY
 g5ddQCKyDV8bzSEBM1iegrJvt/qVn/jVaDt1W0vt6+JZhPirl4eeWloTLWCmvvJT6OKW
 nMthM3eldDl5bjur5bqXZf7KIGJ/WehDJCzAUO+VmoTIXDVtXGlM+BfPP/aku0ne3Dgc
 YDS7Ma6I0ZYdBDlsS7/PcOw5LF+PtAt8Z9+tPT58aLVCRRAgH73SoM4Lmr8AicJ36pJu
 vtJbt4Oqc8554Wg4CdJwbiYYDmNOpRoV5OUyHpJNK3xvCvJ/AXMed+cSGxvlHp2w2TCY MQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 304855wtxh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 03 Apr 2020 01:40:24 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 3 Apr
 2020 01:40:22 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 3 Apr
 2020 01:40:22 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 3 Apr 2020 01:40:22 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 4E9573F7041;
        Fri,  3 Apr 2020 01:40:22 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0338eMlG030805;
        Fri, 3 Apr 2020 01:40:22 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0338eMIV030804;
        Fri, 3 Apr 2020 01:40:22 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 1/2] qla2xxx: Fix regression warnings
Date:   Fri, 3 Apr 2020 01:40:17 -0700
Message-ID: <20200403084018.30766-2-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200403084018.30766-1-njavali@marvell.com>
References: <20200403084018.30766-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-03_05:2020-04-02,2020-04-03 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

drivers/scsi/qla2xxx/qla_dbg.c:2542:7: warning: The scope of the variable 'pbuf'
can be reduced. [variableScope]
drivers/scsi/qla2xxx/qla_init.c:3615:6: warning: Variable 'rc' is assigned a
value that is never used. [unreadVariable]
drivers/scsi/qla2xxx/qla_isr.c:81:11-29: WARNING: dma_alloc_coherent use in
rsp_els already zeroes out memory, so memset is not needed
drivers/scsi/qla2xxx/qla_mbx.c:4889:15-33: WARNING: dma_alloc_coherent use in
els_cmd_map already zeroes out memory, so memset is not needed

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reported-by: kbuild test robot <lkp@intel.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c  | 2 +-
 drivers/scsi/qla2xxx/qla_init.c | 2 --
 drivers/scsi/qla2xxx/qla_isr.c  | 1 -
 drivers/scsi/qla2xxx/qla_mbx.c  | 2 --
 4 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index f301a8048b2f..0a9e084c1669 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -2539,7 +2539,6 @@ ql_dbg(uint level, scsi_qla_host_t *vha, uint id, const char *fmt, ...)
 {
 	va_list va;
 	struct va_format vaf;
-	char pbuf[64];
 
 	va_start(va, fmt);
 
@@ -2547,6 +2546,7 @@ ql_dbg(uint level, scsi_qla_host_t *vha, uint id, const char *fmt, ...)
 	vaf.va = &va;
 
 	if (!ql_mask_match(level)) {
+		char pbuf[64];
 		if (vha != NULL) {
 			const struct pci_dev *pdev = vha->hw->pdev;
 			/* <module-name> <msg-id>:<host> Message */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 3e9b7a079554..496ead29b51e 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3613,8 +3613,6 @@ qla24xx_detect_sfp(scsi_qla_host_t *vha)
 			ha->lr_distance = LR_DISTANCE_5K;
 	}
 
-	if (!vha->flags.init_done)
-		rc = QLA_SUCCESS;
 out:
 	ql_dbg(ql_dbg_async, vha, 0x507b,
 	    "SFP detect: %s-Range SFP %s (nvr=%x ll=%x lr=%x lrd=%x).\n",
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index a9e8513e1cf1..4d9ec7ee59cc 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -87,7 +87,6 @@ qla24xx_process_abts(struct scsi_qla_host *vha, void *pkt)
 	}
 
 	/* terminate exchange */
-	memset(rsp_els, 0, sizeof(*rsp_els));
 	rsp_els->entry_type = ELS_IOCB_TYPE;
 	rsp_els->entry_count = 1;
 	rsp_els->nport_handle = ~0;
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 7cefe35d61d1..d6c991bd1bde 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4894,8 +4894,6 @@ qla25xx_set_els_cmds_supported(scsi_qla_host_t *vha)
 		return QLA_MEMORY_ALLOC_FAILED;
 	}
 
-	memset(els_cmd_map, 0, ELS_CMD_MAP_SIZE);
-
 	els_cmd_map[index] |= 1 << bit;
 
 	mcp->mb[0] = MBC_SET_RNID_PARAMS;
-- 
2.19.0.rc0

