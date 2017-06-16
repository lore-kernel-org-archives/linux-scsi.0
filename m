From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 5/6] qla2xxx: Use FC-NMVe FC4 type for FDMI registration
Date: Fri, 16 Jun 2017 15:47:43 -0700
Message-ID: <20170616224744.3681-6-himanshu.madhani@cavium.com>
References: <20170616224744.3681-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0087.outbound.protection.outlook.com ([104.47.38.87]:17905
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752094AbdFPWsK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 16 Jun 2017 18:48:10 -0400
In-Reply-To: <20170616224744.3681-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org, giridhar.malaval@cavium.com, darren.trapp@cavium.com

From: Duane Grigsby <duane.grigsby@cavium.com>

Signed-off-by: Duane Grigsby <duane.grigsby@cavium.com>
Signed-off-by: Darren Trapp <darren.trapp@cavium.com>
Signed-off-by: Anil Gurumurthy <anil.gurumurhty@cavium.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_gs.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index c91478529b51..b323a7c71eda 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -2166,6 +2166,13 @@ qla2x00_fdmiv2_rpa(scsi_qla_host_t *vha)
 	    eiter->a.fc4_types[2],
 	    eiter->a.fc4_types[1]);
 
+	if (vha->flags.nvme_enabled) {
+		eiter->a.fc4_types[6] = 1;	/* NVMe type 28h */
+		ql_dbg(ql_dbg_disc, vha, 0x211f,
+		    "NVME FC4 Type = %02x 0x0 0x0 0x0 0x0 0x0.\n",
+		    eiter->a.fc4_types[6]);
+	}
+
 	/* Supported speed. */
 	eiter = entries + size;
 	eiter->type = cpu_to_be16(FDMI_PORT_SUPPORT_SPEED);
@@ -2363,6 +2370,15 @@ qla2x00_fdmiv2_rpa(scsi_qla_host_t *vha)
 	    "Port Active FC4 Type = %02x %02x.\n",
 	    eiter->a.port_fc4_type[2], eiter->a.port_fc4_type[1]);
 
+	if (vha->flags.nvme_enabled) {
+		eiter->a.port_fc4_type[4] = 0;
+		eiter->a.port_fc4_type[5] = 0;
+		eiter->a.port_fc4_type[6] = 1;	/* NVMe type 28h */
+		ql_dbg(ql_dbg_disc, vha, 0x2120,
+		    "NVME Port Active FC4 Type = %02x 0x0 0x0 0x0 0x0 0x0.\n",
+		    eiter->a.port_fc4_type[6]);
+	}
+
 	/* Port State */
 	eiter = entries + size;
 	eiter->type = cpu_to_be16(FDMI_PORT_STATE);
-- 
2.12.0
