From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 03/20] qla2xxx: Replace constant value for IOCTL IOCB abort execution status with a macro for ISPFX00.
Date: Fri, 13 Dec 2013 15:03:43 -0500
Message-ID: <1386965040-20611-4-git-send-email-saurav.kashyap@qlogic.com>
References: <1386965040-20611-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:29507 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753285Ab3LMUhG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Dec 2013 15:37:06 -0500
In-Reply-To: <1386965040-20611-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Armen Baloyan <armen.baloyan@qlogic.com>

Signed-off-by: Armen Baloyan <armen.baloyan@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mr.c |    3 ++-
 drivers/scsi/qla2xxx/qla_mr.h |    3 +++
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 6ca4807..7c7849d 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -2017,7 +2017,8 @@ qlafx00_fx_disc(scsi_qla_host_t *vha, fc_port_t *fcport, uint16_t fx_type)
 		memcpy(vha->hw->gid_list, pinfo, QLAFX00_TGT_NODE_LIST_SIZE);
 	} else if (fx_type == FXDISC_ABORT_IOCTL)
 		fdisc->u.fxiocb.result =
-		    (fdisc->u.fxiocb.result == cpu_to_le32(0x68)) ?
+		    (fdisc->u.fxiocb.result ==
+			cpu_to_le32(QLAFX00_IOCTL_ICOB_ABORT_SUCCESS)) ?
 		    cpu_to_le32(QLA_SUCCESS) : cpu_to_le32(QLA_FUNCTION_FAILED);
 
 	rval = le32_to_cpu(fdisc->u.fxiocb.result);
diff --git a/drivers/scsi/qla2xxx/qla_mr.h b/drivers/scsi/qla2xxx/qla_mr.h
index 6cd7072..5f3ed8b 100644
--- a/drivers/scsi/qla2xxx/qla_mr.h
+++ b/drivers/scsi/qla2xxx/qla_mr.h
@@ -548,4 +548,7 @@ struct mr_data_fx00 {
 /* Max conncurrent IOs that can be queued */
 #define QLAFX00_MAX_CANQUEUE		1024
 
+/* IOCTL IOCB abort success */
+#define QLAFX00_IOCTL_ICOB_ABORT_SUCCESS	0x68
+
 #endif
-- 
1.7.7

