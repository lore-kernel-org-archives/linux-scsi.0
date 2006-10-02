From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 3/8] qla2xxx: Add support for system hostname FC transport attribute.
Date: Mon,  2 Oct 2006 12:00:45 -0700
Message-ID: <11598156511495-git-send-email-andrew.vasquez@qlogic.com>
References: <20061002185947.GF16536@andrew-vasquezs-computer.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:53852 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S964947AbWJBTAx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2006 15:00:53 -0400
In-Reply-To: <20061002185947.GF16536@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

The system hostname will be used during a subsequent FDMI registration
with the fabric.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |   10 ++++++++++
 drivers/scsi/qla2xxx/qla_gs.c   |   15 +++++++++++++++
 2 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 4638469..4e1e175 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -857,6 +857,14 @@ qla2x00_get_host_symbolic_name(struct Sc
 	qla2x00_get_sym_node_name(ha, fc_host_symbolic_name(shost));
 }
 
+static void
+qla2x00_set_host_system_hostname(struct Scsi_Host *shost)
+{
+	scsi_qla_host_t *ha = to_qla_host(shost);
+
+	set_bit(REGISTER_FDMI_NEEDED, &ha->dpc_flags);
+}
+
 struct fc_function_template qla2xxx_transport_functions = {
 
 	.show_host_node_name = 1,
@@ -871,6 +879,8 @@ struct fc_function_template qla2xxx_tran
 	.show_host_port_type = 1,
 	.get_host_symbolic_name = qla2x00_get_host_symbolic_name,
 	.show_host_symbolic_name = 1,
+	.set_host_system_hostname = qla2x00_set_host_system_hostname,
+	.show_host_system_hostname = 1,
 
 	.dd_fcrport_size = sizeof(struct fc_port *),
 	.show_rport_supported_classes = 1,
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 225cf72..97fbc62 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1580,6 +1580,21 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *ha)
 	DEBUG13(printk("%s(%ld): OS_DEVICE_NAME=%s.\n", __func__, ha->host_no,
 	    eiter->a.os_dev_name));
 
+	/* Hostname. */
+	if (strlen(fc_host_system_hostname(ha->host))) {
+		eiter = (struct ct_fdmi_port_attr *) (entries + size);
+		eiter->type = __constant_cpu_to_be16(FDMI_PORT_HOST_NAME);
+		snprintf(eiter->a.host_name, sizeof(eiter->a.host_name),
+		    "%s", fc_host_system_hostname(ha->host));
+		alen = strlen(eiter->a.host_name);
+		alen += (alen & 3) ? (4 - (alen & 3)) : 4;
+		eiter->len = cpu_to_be16(4 + alen);
+		size += 4 + alen;
+
+		DEBUG13(printk("%s(%ld): HOSTNAME=%s.\n", __func__,
+		    ha->host_no, eiter->a.host_name));
+	}
+
 	/* Update MS request size. */
 	qla2x00_update_ms_fdmi_iocb(ha, size + 16);
 
-- 
1.4.2.3.gf59615

