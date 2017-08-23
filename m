From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 03/31] qla2xxx: Update fw_started flags at qpair creation.
Date: Wed, 23 Aug 2017 15:04:57 -0700
Message-ID: <20170823220525.3115-4-himanshu.madhani@cavium.com>
References: <20170823220525.3115-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0057.outbound.protection.outlook.com ([104.47.32.57]:21536
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750945AbdHWWFd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Aug 2017 18:05:33 -0400
In-Reply-To: <20170823220525.3115-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

Fixes: 4b60c82736d0 ("scsi: qla2xxx: Add fw_started flags to qpair")
Cc: <stable@vger.kernel.org>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 072ad1aa5505..8f83571afc7b 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -7804,6 +7804,7 @@ struct qla_qpair *qla2xxx_create_qpair(struct scsi_qla_host *vha, int qos,
 		ha->queue_pair_map[qpair_id] = qpair;
 		qpair->id = qpair_id;
 		qpair->vp_idx = vp_idx;
+		qpair->fw_started = ha->flags.fw_started;
 		INIT_LIST_HEAD(&qpair->hints_list);
 		qpair->chip_reset = ha->base_qpair->chip_reset;
 		qpair->enable_class_2 = ha->base_qpair->enable_class_2;
-- 
2.12.0
