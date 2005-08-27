From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 2/16]  qla2xxx: Export class-of-service (COS) information.
Date: Fri, 26 Aug 2005 19:08:10 -0700 (PDT)
Message-ID: <20050827020810.27275.55848.sendpatchset@plap.qlogic.com>
References: <20050827020750.27275.19733.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:35687 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1751600AbVH0CIL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Aug 2005 22:08:11 -0400
In-Reply-To: <20050827020750.27275.19733.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Export class-of-service (COS) information.

Export COS information for the fc_host and fc_remote_port
objects added by the driver.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

 drivers/scsi/qla2xxx/qla_attr.c |    4 ++++
 drivers/scsi/qla2xxx/qla_def.h  |    1 +
 drivers/scsi/qla2xxx/qla_init.c |    7 +++++++
 drivers/scsi/qla2xxx/qla_mbx.c  |   14 ++++++++++++++
 4 files changed, 26 insertions(+), 0 deletions(-)

eae4fae7fed2123a1557f6e1b0a1e4e363388cea
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -304,10 +304,13 @@ struct fc_function_template qla2xxx_tran
 
 	.show_host_node_name = 1,
 	.show_host_port_name = 1,
+	.show_host_supported_classes = 1,
+
 	.get_host_port_id = qla2x00_get_host_port_id,
 	.show_host_port_id = 1,
 
 	.dd_fcrport_size = sizeof(struct fc_port *),
+	.show_rport_supported_classes = 1,
 
 	.get_starget_node_name = qla2x00_get_starget_node_name,
 	.show_starget_node_name = 1,
@@ -329,4 +332,5 @@ qla2x00_init_host_attr(scsi_qla_host_t *
 	    be64_to_cpu(*(uint64_t *)ha->init_cb->node_name);
 	fc_host_port_name(ha->host) =
 	    be64_to_cpu(*(uint64_t *)ha->init_cb->port_name);
+	fc_host_supported_classes(ha->host) = FC_COS_CLASS3;
 }
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1673,6 +1673,7 @@ typedef struct fc_port {
     	uint8_t cur_path;		/* current path id */
 
 	struct fc_rport *rport;
+	u32 supported_classes;
 } fc_port_t;
 
 /*
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1697,6 +1697,7 @@ qla2x00_alloc_fcport(scsi_qla_host_t *ha
 	fcport->iodesc_idx_sent = IODESC_INVALID_INDEX;
 	atomic_set(&fcport->state, FCS_UNCONFIGURED);
 	fcport->flags = FCF_RLC_SUPPORT;
+	fcport->supported_classes = FC_COS_UNSPECIFIED;
 
 	return (fcport);
 }
@@ -2075,6 +2076,7 @@ qla2x00_reg_remote_port(scsi_qla_host_t 
 		return;
 	}
 	rport->dd_data = fcport;
+	rport->supported_classes = fcport->supported_classes;
 
 	rport_ids.roles = FC_RPORT_ROLE_UNKNOWN;
 	if (fcport->port_type == FCT_INITIATOR)
@@ -2794,6 +2796,11 @@ qla2x00_fabric_login(scsi_qla_host_t *ha
 				}
 			}
 
+			if (mb[10] & BIT_0)
+				fcport->supported_classes |= FC_COS_CLASS2;
+			if (mb[10] & BIT_1)
+				fcport->supported_classes |= FC_COS_CLASS3;
+
 			rval = QLA_SUCCESS;
 			break;
 		} else if (mb[0] == MBS_LOOP_ID_USED) {
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -19,6 +19,7 @@
 #include "qla_def.h"
 
 #include <linux/delay.h>
+#include <scsi/scsi_transport_fc.h>
 
 static void
 qla2x00_mbx_sem_timeout(unsigned long data)
@@ -1326,6 +1327,10 @@ qla2x00_get_port_database(scsi_qla_host_
 			fcport->port_type = FCT_INITIATOR;
 		else
 			fcport->port_type = FCT_TARGET;
+
+		/* Passback COS information. */
+		fcport->supported_classes = (pd->options & BIT_4) ?
+		    FC_COS_CLASS2: FC_COS_CLASS3;
 	}
 
 gpd_error_out:
@@ -1661,6 +1666,13 @@ qla24xx_login_fabric(scsi_qla_host_t *ha
 				mb[1] |= BIT_1;
 		} else
 			mb[1] = BIT_0;
+
+		/* Passback COS information. */
+		mb[10] = 0;
+		if (lg->io_parameter[7] || lg->io_parameter[8])
+			mb[10] |= BIT_0;	/* Class 2. */
+		if (lg->io_parameter[9] || lg->io_parameter[10])
+			mb[10] |= BIT_1;	/* Class 3. */
 	}
 
 	dma_pool_free(ha->s_dma_pool, lg, lg_dma);
@@ -1723,6 +1735,8 @@ qla2x00_login_fabric(scsi_qla_host_t *ha
 		mb[2] = mcp->mb[2];
 		mb[6] = mcp->mb[6];
 		mb[7] = mcp->mb[7];
+		/* COS retrieved from Get-Port-Database mailbox command. */
+		mb[10] = 0;
 	}
 
 	if (rval != QLA_SUCCESS) {

-- 
Andrew Vasquez
