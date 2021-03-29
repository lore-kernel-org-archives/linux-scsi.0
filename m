Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 361A0C433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 08:56:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B49B6191D
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 08:56:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235735AbhC2Izt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 04:55:49 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:4692 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235818AbhC2Iz2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Mar 2021 04:55:28 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12T8sf3r008972;
        Mon, 29 Mar 2021 01:55:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=dm36ra6KOa9STbCjvRNztZdUUtcJ3jC1Oiycy1zrlM4=;
 b=KuVXRoX9XfbZ/nr344YiCFwUM7JCqiaxOs4M5kosoBEtpjfsGIeSlFM2uqZFCEuwaL+h
 hQ9L8M3N+6MDwpuBpr9QzrAoBDJ6wA50nwR9TKf66KytOeF0AV1ZIRjoiw6EovhmaKkd
 FRtURI3iHKhNGZN5ipu/pykwx6SWLQwtwzourBHzxZwWVPisROP0OkeJsueAxARLyA5m
 aNc2qr1F/wOAZPaoRA5N+j/TYC54z6gkwkSEcfiNNzlcxS9R9+zRjhDkZA30zeeUZR7K
 OTQhc+5xbXoZttA1B5VwFnxy3vElsA4UsY59YGt1XedU96p55zSofKMPiEbsIe0hmf1W bg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 37k63b8vh4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 01:55:20 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 29 Mar
 2021 01:55:19 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 29 Mar 2021 01:55:19 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id CC0E53F704E;
        Mon, 29 Mar 2021 01:55:18 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 12T8tI8T004451;
        Mon, 29 Mar 2021 01:55:18 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 12T8tIX5004450;
        Mon, 29 Mar 2021 01:55:18 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <loberman@redhat.com>
Subject: [PATCH v2 06/12] qla2xxx: Fix crash in qla2xxx_mqueuecommand
Date:   Mon, 29 Mar 2021 01:52:23 -0700
Message-ID: <20210329085229.4367-7-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210329085229.4367-1-njavali@marvell.com>
References: <20210329085229.4367-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 3ixOuJSqLeHlx7UhHRDyvwokNLeXhb4-
X-Proofpoint-GUID: 3ixOuJSqLeHlx7UhHRDyvwokNLeXhb4-
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-29_04:2021-03-26,2021-03-29 signatures=0
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
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
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

