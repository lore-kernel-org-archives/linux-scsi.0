From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 05/31] qla2xxx: Fix WWPN/WWNN in debug message
Date: Wed, 23 Aug 2017 15:04:59 -0700
Message-ID: <20170823220525.3115-6-himanshu.madhani@cavium.com>
References: <20170823220525.3115-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0043.outbound.protection.outlook.com ([104.47.33.43]:59232
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751112AbdHWWFh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Aug 2017 18:05:37 -0400
In-Reply-To: <20170823220525.3115-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Darren Trap <darren.trap@cavium.com>

Signed-off-by: Darren Trap <darren.trap@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_nvme.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 5692ae128655..1f59e7a74c7b 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -60,8 +60,8 @@ int qla_nvme_register_remote(struct scsi_qla_host *vha, struct fc_port *fcport)
 	rport->req.port_id = fcport->d_id.b24;
 
 	ql_log(ql_log_info, vha, 0x2102,
-	    "%s: traddr=pn-0x%016llx:nn-0x%016llx PortID:%06x\n",
-	    __func__, rport->req.port_name, rport->req.node_name,
+	    "%s: traddr=nn-0x%016llx:pn-0x%016llx PortID:%06x\n",
+	    __func__, rport->req.node_name, rport->req.port_name,
 	    rport->req.port_id);
 
 	ret = nvme_fc_register_remoteport(vha->nvme_local_port, &rport->req,
@@ -723,8 +723,8 @@ void qla_nvme_register_hba(struct scsi_qla_host *vha)
 	pinfo.port_id = vha->d_id.b24;
 
 	ql_log(ql_log_info, vha, 0xffff,
-	    "register_localport: host-traddr=pn-0x%llx:nn-0x%llx on portID:%x\n",
-	    pinfo.port_name, pinfo.node_name, pinfo.port_id);
+	    "register_localport: host-traddr=nn-0x%llx:pn-0x%llx on portID:%x\n",
+	    pinfo.node_name, pinfo.port_name, pinfo.port_id);
 	qla_nvme_fc_transport.dma_boundary = vha->host->dma_boundary;
 
 	ret = nvme_fc_register_localport(&pinfo, tmpl,
-- 
2.12.0
