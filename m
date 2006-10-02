From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 4/8] qla2xxx: Add support for fabric name FC transport attribute.
Date: Mon,  2 Oct 2006 12:00:46 -0700
Message-ID: <11598156513789-git-send-email-andrew.vasquez@qlogic.com>
References: <20061002185947.GF16536@andrew-vasquezs-computer.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:53852 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S964953AbWJBTAy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2006 15:00:54 -0400
In-Reply-To: <20061002185947.GF16536@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |   16 ++++++++++++++++
 drivers/scsi/qla2xxx/qla_def.h  |    1 +
 drivers/scsi/qla2xxx/qla_init.c |    3 ++-
 3 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 4e1e175..d4cf51a 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -865,6 +865,20 @@ qla2x00_set_host_system_hostname(struct 
 	set_bit(REGISTER_FDMI_NEEDED, &ha->dpc_flags);
 }
 
+static void
+qla2x00_get_host_fabric_name(struct Scsi_Host *shost)
+{
+	scsi_qla_host_t *ha = to_qla_host(shost);
+	u64 node_name;
+
+	if (ha->device_flags & SWITCH_FOUND)
+		node_name = wwn_to_u64(ha->fabric_node_name);
+	else
+		node_name = wwn_to_u64(ha->node_name);
+
+	fc_host_fabric_name(shost) = node_name;
+}
+
 struct fc_function_template qla2xxx_transport_functions = {
 
 	.show_host_node_name = 1,
@@ -881,6 +895,8 @@ struct fc_function_template qla2xxx_tran
 	.show_host_symbolic_name = 1,
 	.set_host_system_hostname = qla2x00_set_host_system_hostname,
 	.show_host_system_hostname = 1,
+	.get_host_fabric_name = qla2x00_get_host_fabric_name,
+	.show_host_fabric_name = 1,
 
 	.dd_fcrport_size = sizeof(struct fc_port *),
 	.show_rport_supported_classes = 1,
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 6d677b0..c37a30a 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2362,6 +2362,7 @@ #define BINZERO		"\0\0\0\0\0\0\0\0\0\0\0
 
 	uint8_t		*node_name;
 	uint8_t		*port_name;
+	uint8_t		fabric_node_name[WWN_SIZE];
 	uint32_t    isp_abort_cnt;
 
 	/* Option ROM information. */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 2700964..d5d2627 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2280,7 +2280,7 @@ qla2x00_configure_fabric(scsi_qla_host_t
 		loop_id = NPH_F_PORT;
 	else
 		loop_id = SNS_FL_PORT;
-	rval = qla2x00_get_port_name(ha, loop_id, NULL, 0);
+	rval = qla2x00_get_port_name(ha, loop_id, ha->fabric_node_name, 1);
 	if (rval != QLA_SUCCESS) {
 		DEBUG2(printk("scsi(%ld): MBC_GET_PORT_NAME Failed, No FL "
 		    "Port\n", ha->host_no));
@@ -2288,6 +2288,7 @@ qla2x00_configure_fabric(scsi_qla_host_t
 		ha->device_flags &= ~SWITCH_FOUND;
 		return (QLA_SUCCESS);
 	}
+	ha->device_flags |= SWITCH_FOUND;
 
 	/* Mark devices that need re-synchronization. */
 	rval2 = qla2x00_device_resync(ha);
-- 
1.4.2.3.gf59615

