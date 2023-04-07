Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2ABCC77B71
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Apr 2023 20:09:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbjDGUJz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Apr 2023 16:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231424AbjDGUJi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Apr 2023 16:09:38 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A8BBC143;
        Fri,  7 Apr 2023 13:09:30 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 337Fwwhn017413;
        Fri, 7 Apr 2023 20:06:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2022-7-12;
 bh=gT8347jA5KdvGQ7I7vMBDYh3M0ax0K8JKbyzwbeexOU=;
 b=jVvJW6Gmkpfd7+4QJbMyb2Hwfm6sIa8gXD1vQ3p0/ZRNHOSW5pAf4uL+F9Ub18I3Nx4H
 1XjtRs1ww2ZWdFS7etMlJO28TJD6lziJbu2kJqZmtwlIc9j/DS/DCTAngTaNxbasS+PV
 xU+80FH5l2uFS50RlsMgOSUnJqsAx6J3ZhL29gXm6N7E9YCIrTzEf9Z1oopNvjLPZz+m
 xQNRS00piXR3pLJfC37MZmXqjxOE8mCG59C4APzD4QEEpDJE3hUgnUxFR017OX8sg3UF
 flcTP4H0qBCoDHHiFl3nkDi0ET5hDegQvC4N7JO1y1xKUFdpFryLKYrTJYYkJ9Q0Rxrl AA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ppcnd5wvj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Apr 2023 20:06:36 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 337ISSWd034268;
        Fri, 7 Apr 2023 20:06:35 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pptjxef97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Apr 2023 20:06:35 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 337K5trM010228;
        Fri, 7 Apr 2023 20:06:34 GMT
Received: from mnchrist-mac.us.oracle.com (dhcp-10-154-128-1.vpn.oracle.com [10.154.128.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3pptjxeeam-16;
        Fri, 07 Apr 2023 20:06:34 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v6 15/18] scsi: target: Allow backends to hook into PR handling
Date:   Fri,  7 Apr 2023 15:05:48 -0500
Message-Id: <20230407200551.12660-16-michael.christie@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230407200551.12660-1-michael.christie@oracle.com>
References: <20230407200551.12660-1-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-07_12,2023-04-06_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 bulkscore=0 mlxscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304070180
X-Proofpoint-GUID: AS1OWTTr3pGQEZeZRMbkZzm468qW7R2S
X-Proofpoint-ORIG-GUID: AS1OWTTr3pGQEZeZRMbkZzm468qW7R2S
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For the cases where you want to export a device to a VM via a single
I_T nexus and want to passthrough the PR handling to the physical/real
device you have to use pscsi or tcmu. Both are good for specific uses
however for the case where you want good performance, and are not using
SCSI devices directly (using DM/MD RAID or multipath devices) then we are
out of luck.

The following patches allow iblock to mimimally hook into the LIO PR code
and then pass the PR handling to the physical device. Note that like with
the tcmu an pscsi cases it's only supported when you export the device via
one I_T nexus.

This patch adds the initial LIO callouts. The next patch will modify
iblock.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_pr.c      | 62 +++++++++++++++++++++++++++-
 include/target/target_core_backend.h |  4 ++
 2 files changed, 65 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 1493b1d01194..e16ef7d676af 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -3538,6 +3538,25 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	return ret;
 }
 
+static sense_reason_t
+target_try_pr_out_pt(struct se_cmd *cmd, u8 sa, u64 res_key, u64 sa_res_key,
+		     u8 type, bool aptpl, bool all_tg_pt, bool spec_i_pt)
+{
+	struct exec_cmd_ops *ops = cmd->protocol_data;
+
+	if (!cmd->se_sess || !cmd->se_lun) {
+		pr_err("SPC-3 PR: se_sess || struct se_lun is NULL!\n");
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+	}
+
+	if (!ops->execute_pr_out) {
+		pr_err("SPC-3 PR: Device has been configured for PR passthrough but it's not supported by the backend.\n");
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	}
+
+	return ops->execute_pr_out(cmd, sa, res_key, sa_res_key, type, aptpl);
+}
+
 /*
  * See spc4r17 section 6.14 Table 170
  */
@@ -3641,6 +3660,12 @@ target_scsi3_emulate_pr_out(struct se_cmd *cmd)
 		return TCM_PARAMETER_LIST_LENGTH_ERROR;
 	}
 
+	if (dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR) {
+		ret = target_try_pr_out_pt(cmd, sa, res_key, sa_res_key, type,
+					   aptpl, all_tg_pt, spec_i_pt);
+		goto done;
+	}
+
 	/*
 	 * (core_scsi3_emulate_pro_* function parameters
 	 * are defined by spc4r17 Table 174:
@@ -3682,6 +3707,7 @@ target_scsi3_emulate_pr_out(struct se_cmd *cmd)
 		return TCM_INVALID_CDB_FIELD;
 	}
 
+done:
 	if (!ret)
 		target_complete_cmd(cmd, SAM_STAT_GOOD);
 	return ret;
@@ -4039,9 +4065,37 @@ core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 	return 0;
 }
 
+static sense_reason_t target_try_pr_in_pt(struct se_cmd *cmd, u8 sa)
+{
+	struct exec_cmd_ops *ops = cmd->protocol_data;
+	unsigned char *buf;
+	sense_reason_t ret;
+
+	if (cmd->data_length < 8) {
+		pr_err("PRIN SA SCSI Data Length: %u too small\n",
+		       cmd->data_length);
+		return TCM_INVALID_CDB_FIELD;
+	}
+
+	if (!ops->execute_pr_in) {
+		pr_err("SPC-3 PR: Device has been configured for PR passthrough but it's not supported by the backend.\n");
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	}
+
+	buf = transport_kmap_data_sg(cmd);
+	if (!buf)
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+
+	ret = ops->execute_pr_in(cmd, sa, buf);
+
+	transport_kunmap_data_sg(cmd);
+	return ret;
+}
+
 sense_reason_t
 target_scsi3_emulate_pr_in(struct se_cmd *cmd)
 {
+	u8 sa = cmd->t_task_cdb[1] & 0x1f;
 	sense_reason_t ret;
 
 	/*
@@ -4060,7 +4114,12 @@ target_scsi3_emulate_pr_in(struct se_cmd *cmd)
 		return TCM_RESERVATION_CONFLICT;
 	}
 
-	switch (cmd->t_task_cdb[1] & 0x1f) {
+	if (cmd->se_dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR) {
+		ret = target_try_pr_in_pt(cmd, sa);
+		goto done;
+	}
+
+	switch (sa) {
 	case PRI_READ_KEYS:
 		ret = core_scsi3_pri_read_keys(cmd);
 		break;
@@ -4079,6 +4138,7 @@ target_scsi3_emulate_pr_in(struct se_cmd *cmd)
 		return TCM_INVALID_CDB_FIELD;
 	}
 
+done:
 	if (!ret)
 		target_complete_cmd(cmd, SAM_STAT_GOOD);
 	return ret;
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index c5df78959532..739df993aa5e 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -69,6 +69,10 @@ struct exec_cmd_ops {
 	sense_reason_t (*execute_write_same)(struct se_cmd *cmd);
 	sense_reason_t (*execute_unmap)(struct se_cmd *cmd,
 				sector_t lba, sector_t nolb);
+	sense_reason_t (*execute_pr_out)(struct se_cmd *cmd, u8 sa, u64 key,
+					 u64 sa_key, u8 type, bool aptpl);
+	sense_reason_t (*execute_pr_in)(struct se_cmd *cmd, u8 sa,
+					unsigned char *param_data);
 };
 
 int	transport_backend_register(const struct target_backend_ops *);
-- 
2.25.1

