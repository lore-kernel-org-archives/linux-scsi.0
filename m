From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: [PATCH] target: Add WRITE_VERIFY_16
Date: Tue, 18 Apr 2017 14:10:05 -0500
Message-ID: <1492542605-98815-1-git-send-email-bryantly@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44241 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753153AbdDRTKM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Apr 2017 15:10:12 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v3IJ8ajL019069
        for <linux-scsi@vger.kernel.org>; Tue, 18 Apr 2017 15:10:11 -0400
Received: from e17.ny.us.ibm.com (e17.ny.us.ibm.com [129.33.205.207])
        by mx0a-001b2d01.pphosted.com with ESMTP id 29wqpujsjt-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 18 Apr 2017 15:10:11 -0400
Received: from localhost
        by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bryantly@linux.vnet.ibm.com>;
        Tue, 18 Apr 2017 15:10:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>

This patch addresses clients who needs write_verify_16 for
large volume groups such as AIX.

Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
---
 drivers/target/target_core_sbc.c | 2 ++
 include/scsi/scsi_proto.h        | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index ee35c90..2060f5a 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -850,6 +850,7 @@ static sense_reason_t sbc_parse_verify(struct se_cmd *cmd, int *sectors,
 		cmd->t_task_lba = transport_lba_32(cdb);
 		break;
 	case VERIFY_16:
+	case WRITE_VERIFY_16:
 		*sectors = transport_get_sectors_16(cdb);
 		cmd->t_task_lba = transport_lba_64(cdb);
 		break;
@@ -962,6 +963,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		cmd->execute_cmd = sbc_execute_rw;
 		break;
 	case WRITE_VERIFY:
+	case WRITE_VERIFY_16:
 		ret = sbc_parse_verify(cmd, &sectors, &size);
 		if (ret)
 			return ret;
diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index 6ba66e0..ce78ec8 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -112,6 +112,7 @@
 #define WRITE_16              0x8a
 #define READ_ATTRIBUTE        0x8c
 #define WRITE_ATTRIBUTE	      0x8d
+#define WRITE_VERIFY_16	      0x8e
 #define VERIFY_16	      0x8f
 #define SYNCHRONIZE_CACHE_16  0x91
 #define WRITE_SAME_16	      0x93
-- 
2.5.4 (Apple Git-61)
