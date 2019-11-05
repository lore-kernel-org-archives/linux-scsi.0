Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AD17C5DF60
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 15:07:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5BCF8214D8
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 15:07:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="ct4Fqbyp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388292AbfKEPHT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 10:07:19 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:7876 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731074AbfKEPHS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2019 10:07:18 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA5ExrDQ009715;
        Tue, 5 Nov 2019 07:07:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=HkEQVM6UAx+xdEBp0q3eMlGl+zosayX2VcY/vslM+g4=;
 b=ct4FqbypkbK8/q3g3/TxIJ1+ys1cg41R4cgxKI2KVQhwxPsc9dsxYqxgf5BdrqgXtgsi
 6DT+60YIxyNQn7JmSWv1XqEVfVhbJt2SBg+AdxDZz538vfHwIjJ8V7Waw8q8HgRdCPqY
 QDBuKRfoKSTE7tRhRmT6HcqsvkwYi815d/BhBb4mS3FQTCGherpYphJQ3PyKYJp3uXXx
 v1uNwAIXRQqcR7HLr9UFfD70CseZdkCEVmBzyCXoVCBsO3aOIJd3c/et6ErNBlklvmXp
 GWDpKOTwqGEMyQqJHQ7+ryV0VUfHW2BNdMkwc9L9d8Aib+wIBr6O3J/6ZZNMAr3/s2dU PA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2w17n93cmx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 05 Nov 2019 07:07:17 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Tue, 5 Nov
 2019 07:07:16 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Tue, 5 Nov 2019 07:07:16 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 7D56C3F703F;
        Tue,  5 Nov 2019 07:07:16 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id xA5F7Gci008159;
        Tue, 5 Nov 2019 07:07:16 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id xA5F7GTU008158;
        Tue, 5 Nov 2019 07:07:16 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 6/8] qla2xxx: Fix memory leak when sending I/O fails
Date:   Tue, 5 Nov 2019 07:06:55 -0800
Message-ID: <20191105150657.8092-7-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20191105150657.8092-1-hmadhani@marvell.com>
References: <20191105150657.8092-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-11-05_05:2019-11-05,2019-11-05 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

On heavy loads, a memory leak of the srb_t structure is observed.
This would make the qla2xxx_srbs cache gobble up memory.

Fixes: 219d27d7147e0 ("scsi: qla2xxx: Fix race conditions in the code for aborting SCSI commands")
Cc: stable@vger.kernel.org # 5.2
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index b59d579834ea..b513008042fb 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -909,6 +909,8 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 qc24_host_busy_free_sp:
 	sp->free(sp);
+	CMD_SP(cmd) = NULL;
+	qla2x00_rel_sp(sp);
 
 qc24_target_busy:
 	return SCSI_MLQUEUE_TARGET_BUSY;
@@ -992,6 +994,8 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd,
 
 qc24_host_busy_free_sp:
 	sp->free(sp);
+	CMD_SP(cmd) = NULL;
+	qla2xxx_rel_qpair_sp(sp->qpair, sp);
 
 qc24_target_busy:
 	return SCSI_MLQUEUE_TARGET_BUSY;
-- 
2.12.0

