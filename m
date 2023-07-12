Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0537EB64DA
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Jul 2023 09:06:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbjGLJG4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Jul 2023 05:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232999AbjGLJGN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2023 05:06:13 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3992C1BEA
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 02:05:53 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36C7OZ3V029250
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 02:05:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=A2JGrT8l36gtJv3mmaCjg3ksEgRXOOX29lt590bO/Vg=;
 b=SgB5CJWMO/jzclw9kzDO7OhsueOALdqPnxsVyMTIJN04HcfyxGKOhbkcAi24/tuvXCwA
 srxMCOaiV5Tivl1Xu4YmIyLmOUcBzEcFWr6yzygrXIWskkKKK53s258W1lgOjg4KYbDK
 ePXLe2thYe0AHP6q7qPRsXfC7QyHLPdh/MS4R6j7clMGZwNM2eq05jYAYWrIcJLMzVMs
 5hJIclFojgKNET9df7DE6Fo85PoCXJzHo8f+iGfyGOqZ3gCsGr5zNsy6wizsy+G/C4Ep
 CY619typVhOe1nQKyyQSMcMma1pNMzZ//1gZbTIfN8T8wkqpwhA2hr+3S6iaooxeZWVH 8Q== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3rsb7rb0gg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 02:05:52 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Wed, 12 Jul
 2023 02:05:51 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Wed, 12 Jul 2023 02:05:51 -0700
Received: from localhost.marvell.com (unknown [10.30.46.195])
        by maili.marvell.com (Postfix) with ESMTP id 8DBD33F7076;
        Wed, 12 Jul 2023 02:05:49 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH 06/10] qla2xxx: Fix session hang in gnl
Date:   Wed, 12 Jul 2023 14:35:31 +0530
Message-ID: <20230712090535.34894-7-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20230712090535.34894-1-njavali@marvell.com>
References: <20230712090535.34894-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: ZCmF3NmHotGiMnPvABt2W2KgY-3lz7xB
X-Proofpoint-ORIG-GUID: ZCmF3NmHotGiMnPvABt2W2KgY-3lz7xB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-12_06,2023-07-11_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Connection does not resume after a host reset /
chip reset. The cause of the blockage is due to the FCF_ASYNC_ACTIVE
left on. The gnl command was interrupted by the chip reset. On
exiting the command, this flag should be turn off to allow relogin
to reoccur. Clear this flag to prevent blockage.

Cc: stable@vger.kernel.org
Fixes: 17e64648aa47 (“scsi: qla2xxx: Correct fcport flags handling”)
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 725806ca9572..06c4e5215789 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1141,7 +1141,7 @@ int qla24xx_async_gnl(struct scsi_qla_host *vha, fc_port_t *fcport)
 	u16 *mb;
 
 	if (!vha->flags.online || (fcport->flags & FCF_ASYNC_SENT))
-		return rval;
+		goto done;
 
 	ql_dbg(ql_dbg_disc, vha, 0x20d9,
 	    "Async-gnlist WWPN %8phC \n", fcport->port_name);
@@ -1195,8 +1195,9 @@ int qla24xx_async_gnl(struct scsi_qla_host *vha, fc_port_t *fcport)
 done_free_sp:
 	/* ref: INIT */
 	kref_put(&sp->cmd_kref, qla2x00_sp_release);
+	fcport->flags &= ~(FCF_ASYNC_SENT);
 done:
-	fcport->flags &= ~(FCF_ASYNC_ACTIVE | FCF_ASYNC_SENT);
+	fcport->flags &= ~(FCF_ASYNC_ACTIVE);
 	return rval;
 }
 
-- 
2.23.1

