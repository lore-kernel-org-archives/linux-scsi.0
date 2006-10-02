From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 5/8] qla2xxx: Add support for host port state FC transport attribute.
Date: Mon,  2 Oct 2006 12:00:47 -0700
Message-ID: <11598156512789-git-send-email-andrew.vasquez@qlogic.com>
References: <20061002185947.GF16536@andrew-vasquezs-computer.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:53852 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S965068AbWJBTA4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2006 15:00:56 -0400
In-Reply-To: <20061002185947.GF16536@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index d4cf51a..ee75a71 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -879,6 +879,19 @@ qla2x00_get_host_fabric_name(struct Scsi
 	fc_host_fabric_name(shost) = node_name;
 }
 
+static void
+qla2x00_get_host_port_state(struct Scsi_Host *shost)
+{
+	scsi_qla_host_t *ha = to_qla_host(shost);
+
+	if (!ha->flags.online)
+		fc_host_port_state(shost) = FC_PORTSTATE_OFFLINE;
+	else if (atomic_read(&ha->loop_state) == LOOP_TIMEOUT)
+		fc_host_port_state(shost) = FC_PORTSTATE_UNKNOWN;
+	else
+		fc_host_port_state(shost) = FC_PORTSTATE_ONLINE;
+}
+
 struct fc_function_template qla2xxx_transport_functions = {
 
 	.show_host_node_name = 1,
@@ -897,6 +910,8 @@ struct fc_function_template qla2xxx_tran
 	.show_host_system_hostname = 1,
 	.get_host_fabric_name = qla2x00_get_host_fabric_name,
 	.show_host_fabric_name = 1,
+	.get_host_port_state = qla2x00_get_host_port_state,
+	.show_host_port_state = 1,
 
 	.dd_fcrport_size = sizeof(struct fc_port *),
 	.show_rport_supported_classes = 1,
-- 
1.4.2.3.gf59615

