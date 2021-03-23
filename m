Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1D80C433C1
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 04:46:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 921AC61994
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 04:46:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbhCWEqI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Mar 2021 00:46:08 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:49830 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229493AbhCWEpt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 Mar 2021 00:45:49 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12N4jVsO021140
        for <linux-scsi@vger.kernel.org>; Mon, 22 Mar 2021 21:45:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=UW0F/UHqT1J9/Diy+lJ91is4X10e1lZNWqJbTZy0CJQ=;
 b=RsNTZvQ7+lK96YZy+cx9mg0eIwThXzj/5/4uboHspV0I7k9e6rAylbmiQg0b0cMI1tWf
 RhtAvLbRoF8eSK3nSjbKhRQ9XD9y868iq8ng0XF5DOP0227+tbjvlp5dUsoa01hClyrv
 UKiKzCvYzEMdvpckTUZIl46NZ2h8iyKW8D2YXwlFKiYK+8112ZEWbgdyfQoCluPaXp3D
 MSDBPcyegblLquUupeO0+2DXSQ7DiOBzFDYnKAqbQTWMuKv83qmNQSI8yPvAcH2WGYvf
 THClOhZaNDCKdK37VjqEzvb13sgiwTZSjNNLYT09jgNaLz/p/RHGzZe4PN6XCgEQHmk/ Sg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 37dgjnygxd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 22 Mar 2021 21:45:49 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Mar
 2021 21:45:46 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 22 Mar 2021 21:45:46 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id E46AC3F7040;
        Mon, 22 Mar 2021 21:45:46 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 12N4jkpg026741;
        Mon, 22 Mar 2021 21:45:46 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 12N4jkDW026740;
        Mon, 22 Mar 2021 21:45:46 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 06/11] qla2xxx: Fix crash in qla2xxx_mqueuecommand
Date:   Mon, 22 Mar 2021 21:42:52 -0700
Message-ID: <20210323044257.26664-7-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210323044257.26664-1-njavali@marvell.com>
References: <20210323044257.26664-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-23_01:2021-03-22,2021-03-23 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

    RIP: 0010:kmem_cache_free+0xfa/0x1b0
    Call Trace:
       qla2xxx_mqueuecommand+0x2b5/0x2c0 [qla2xxx]
       scsi_queue_rq+0x5e2/0xa40
       __blk_mq_try_issue_directly+0x128/0x1d0
       blk_mq_request_issue_directly+0x4e/0xb0

Fix incorrect call to free srb in qla2xxx_mqueuecommand, as
srb is now allocated by upper layers. This fixes smatch warning of
srb unintended free.

Fixes: af2a0c51b120 ("scsi: qla2xxx: Fix SRB leak on switch command timeout")
Cc: stable@vger.kernel.org # 5.5
Reported-by: Laurence Oberman <loberman@redhat.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 6563d69706ba..6a57399b515f 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1013,8 +1013,6 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd,
 	if (rval != QLA_SUCCESS) {
 		ql_dbg(ql_dbg_io + ql_dbg_verbose, vha, 0x3078,
 		    "Start scsi failed rval=%d for cmd=%p.\n", rval, cmd);
-		if (rval == QLA_INTERFACE_ERROR)
-			goto qc24_free_sp_fail_command;
 		goto qc24_host_busy_free_sp;
 	}
 
@@ -1026,11 +1024,6 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd,
 qc24_target_busy:
 	return SCSI_MLQUEUE_TARGET_BUSY;
 
-qc24_free_sp_fail_command:
-	sp->free(sp);
-	CMD_SP(cmd) = NULL;
-	qla2xxx_rel_qpair_sp(sp->qpair, sp);
-
 qc24_fail_command:
 	cmd->scsi_done(cmd);
 
-- 
2.19.0.rc0

