Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3E13C6FA8F
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Aug 2023 15:17:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240412AbjHXPRD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Aug 2023 11:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241661AbjHXPQd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Aug 2023 11:16:33 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E807419B0
        for <linux-scsi@vger.kernel.org>; Thu, 24 Aug 2023 08:16:31 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37O8RwvL006802
        for <linux-scsi@vger.kernel.org>; Thu, 24 Aug 2023 08:16:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=EPvJI/4JeXcdSvG+BmjCE53lJ/hwwbWSGNhOzs5B82w=;
 b=RXgucHhkNdPDW0m9tPOW37urD1n97AXq+gkIcXOJDjgUKRa+vzkk69C5McyIbXW/xX7V
 3xCvdTC2EXfsoklDzLMhLNUaFc3ql0D2TVbRAvD38rZN/Oj+8DbEIA3hMSdbGLQ7xLEm
 t1KSZeXMBqGwPS7f6SNwlThtzSNJPUbuID8KEOVV3H3fIzUS1coLO1k8xAhVI93+3tbm
 x6Oqh0mzaYqkC2rnCq8zdkipOUWrjjGxvqpvW+JdhZX2Tt5WCpDwD63HKEj/lg0jf21T
 +C6H4/ZxmOhHTstWjJryA7Er9TIn954OCSQH77XCg3tNw5sXhHtCLL82ufXgkCTP6SKo 6g== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3snrmcubtw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 24 Aug 2023 08:16:31 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Thu, 24 Aug
 2023 08:16:29 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Thu, 24 Aug 2023 08:16:29 -0700
Received: from localhost.marvell.com (unknown [10.30.46.195])
        by maili.marvell.com (Postfix) with ESMTP id C4CED3F707D;
        Thu, 24 Aug 2023 08:16:27 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH] qla2xxx: fix sparse warning in func qla24xx_build_scsi_type_6_iocbs
Date:   Thu, 24 Aug 2023 20:46:26 +0530
Message-ID: <20230824151626.35334-1-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: tyVLWjIMrExmqF1IRYZRMr4X116RzLvL
X-Proofpoint-ORIG-GUID: tyVLWjIMrExmqF1IRYZRMr4X116RzLvL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-24_12,2023-08-24_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Sparse warning reported,

drivers/scsi/qla2xxx/qla_iocb.c: In function 'qla24xx_build_scsi_type_6_iocbs':
>> drivers/scsi/qla2xxx/qla_iocb.c:594:29: warning: variable 'ha' set but not used [-Wunused-but-set-variable]
     594 |         struct qla_hw_data *ha;
         |                             ^~

Define variable 'ha' before exiting the routine.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202308230757.VKMIztAB-lkp@intel.com/
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 7fbd917f6e1f..0eb8df5ee73c 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -591,8 +591,8 @@ qla24xx_build_scsi_type_6_iocbs(srb_t *sp, struct cmd_type_6 *cmd_pkt,
 	uint16_t tot_dsds)
 {
 	struct dsd64 *cur_dsd = NULL, *next_dsd;
-	scsi_qla_host_t	*vha;
-	struct qla_hw_data *ha;
+	scsi_qla_host_t	*vha = sp->vha;
+	struct qla_hw_data *ha = vha->hw;
 	struct scsi_cmnd *cmd;
 	struct	scatterlist *cur_seg;
 	uint8_t avail_dsds;
@@ -614,9 +614,6 @@ qla24xx_build_scsi_type_6_iocbs(srb_t *sp, struct cmd_type_6 *cmd_pkt,
 		return 0;
 	}
 
-	vha = sp->vha;
-	ha = vha->hw;
-
 	/* Set transfer direction */
 	if (cmd->sc_data_direction == DMA_TO_DEVICE) {
 		cmd_pkt->control_flags = cpu_to_le16(CF_WRITE_DATA);
-- 
2.23.1

