Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7017EB64DC
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Jul 2023 07:01:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235169AbjGNHBj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Jul 2023 03:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234745AbjGNHBb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2023 03:01:31 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2A8171D
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 00:01:30 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36DL45Wa017668
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 00:01:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=75gWEg06yNB9qLnJarEIuraoOosfxFTAne6gHyqbnfw=;
 b=Uwti3wbX/3452eGLR9rRXiEe58ADD1uO1UiSab7EqqK0E6VKXgIPYk/JiufZuZwm9wrF
 BgSpSX27Mn7Lzj5y7LBgpoTLD0HVP7+Caa+bhKkcWD1TLLSgih0qy2JEUCpT46YqmgN6
 XVsbn633WnYnZHTJ+J+nyR1bP07+QVOFKn4IEtoyRype52pbLyGdD+N9smo7MHY6g3h5
 VBl1ZpO1fp55bqICtRSBHXlXudeSG2iqhyjMYW0Nqhz2utUFGgzrXJNq2T4GmBNW0CbQ
 nJFtQRi4lE2IvGFDIV0ekBdpu3hHaiB3f/UoZeTiCKckB5dhvDjpiIa1T2WwLZNSjOBo AQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3rtrux9mgx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 00:01:30 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Fri, 14 Jul
 2023 00:01:28 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Fri, 14 Jul 2023 00:01:28 -0700
Received: from localhost.marvell.com (unknown [10.30.46.195])
        by maili.marvell.com (Postfix) with ESMTP id BEA183F7064;
        Fri, 14 Jul 2023 00:01:26 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH v2 09/10] qla2xxx: fix inconsistent TMF timeout
Date:   Fri, 14 Jul 2023 12:31:03 +0530
Message-ID: <20230714070104.40052-10-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20230714070104.40052-1-njavali@marvell.com>
References: <20230714070104.40052-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: 3kst7mV03L0XjofmXloDMod8q0H51zvT
X-Proofpoint-ORIG-GUID: 3kst7mV03L0XjofmXloDMod8q0H51zvT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-14_04,2023-07-13_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Different behavior were experienced of session being
torn down vs not, when TMF is timed out. When FW detects
the time out, the session is torn down.  When driver detects
the time out, the session is not torn down.

Allow TMF error to return to upper layer without session
tear down.

Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_isr.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index eb8480a0d7b0..aba39127474a 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2543,7 +2543,6 @@ qla24xx_tm_iocb_entry(scsi_qla_host_t *vha, struct req_que *req, void *tsk)
 	case CS_PORT_BUSY:
 	case CS_INCOMPLETE:
 	case CS_PORT_UNAVAILABLE:
-	case CS_TIMEOUT:
 	case CS_RESET:
 		if (atomic_read(&fcport->state) == FCS_ONLINE) {
 			ql_dbg(ql_dbg_disc, fcport->vha, 0x3021,
-- 
2.23.1

