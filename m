Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4146C3DA6F
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Aug 2023 07:01:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239891AbjHYHAh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Aug 2023 03:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242127AbjHYHA0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Aug 2023 03:00:26 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E939D3
        for <linux-scsi@vger.kernel.org>; Fri, 25 Aug 2023 00:00:24 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37P3cuGb002023
        for <linux-scsi@vger.kernel.org>; Fri, 25 Aug 2023 00:00:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=00Zh6LzAgsKYSSnxrqUVfvsoPdCOKkao6f0dFdN7j0M=;
 b=TrYrYJQt9DayQTF4AB2/CY5E0M5g2Ie+cE7wmpyrAGycSB1t8nI1WgI1B9WsxM4MJAif
 X7G+NMWyUMlCiTwpKmkNBLAIVI6h5RbFCWdpX8SXWFRMZYASiUwZdoGmJ8Lh3rL9KDJc
 fgYmIAgjl1DaCbzRlkMEGtBTgCKxRpoHs2iLsalxjMWxzUkjzOT3BD3rm/33BMXLEOsm
 ZhCLQsDZ0NTpfKFwlZGqZyJdwv/fdHPR0ZatuAGiHNbT4bISDKQFeVOcjjGKfzyIz0s7
 yzHJxK8gWeQNyfQISGsFnRAv09vViVOhxPfKBbRUuPnB3iDHI8TCH0f/KJfEURyoS3fJ Ag== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3spmk28ffk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 25 Aug 2023 00:00:23 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Fri, 25 Aug
 2023 00:00:20 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Fri, 25 Aug 2023 00:00:21 -0700
Received: from localhost.marvell.com (unknown [10.30.46.195])
        by maili.marvell.com (Postfix) with ESMTP id D2F2E3F70C7;
        Fri, 25 Aug 2023 00:00:18 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH v2] qla2xxx: remove unused variables in func qla24xx_build_scsi_type_6_iocbs
Date:   Fri, 25 Aug 2023 12:30:17 +0530
Message-ID: <20230825070017.46066-1-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: oqccqERiZSzegR57rW-rsSfEgtEagIsn
X-Proofpoint-GUID: oqccqERiZSzegR57rW-rsSfEgtEagIsn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-25_04,2023-08-24_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Sparse warning reported,

drivers/scsi/qla2xxx/qla_iocb.c: In function 'qla24xx_build_scsi_type_6_iocbs':
>> drivers/scsi/qla2xxx/qla_iocb.c:594:29: warning: variable 'ha' set but not used [-Wunused-but-set-variable]
     594 |         struct qla_hw_data *ha;
         |                             ^~

Remove unused variables 'vha' and 'ha'.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202308230757.VKMIztAB-lkp@intel.com/
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
v1->v2:
- remove unused variables

 drivers/scsi/qla2xxx/qla_iocb.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 7fbd917f6e1f..4450c0d000cc 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -591,8 +591,6 @@ qla24xx_build_scsi_type_6_iocbs(srb_t *sp, struct cmd_type_6 *cmd_pkt,
 	uint16_t tot_dsds)
 {
 	struct dsd64 *cur_dsd = NULL, *next_dsd;
-	scsi_qla_host_t	*vha;
-	struct qla_hw_data *ha;
 	struct scsi_cmnd *cmd;
 	struct	scatterlist *cur_seg;
 	uint8_t avail_dsds;
@@ -614,9 +612,6 @@ qla24xx_build_scsi_type_6_iocbs(srb_t *sp, struct cmd_type_6 *cmd_pkt,
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

