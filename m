From: andrew.vasquez@qlogic.com
Subject: [PATCH 1/6] qla2xxx: Add port-speed FC transport attribute.
Date: Tue, 31 Jan 2006 16:04:51 -0800
Message-ID: <11387522913491-git-send-email-andrew.vasquez@qlogic.com>
References: <20060201000146.GA4456@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:23490 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S1751128AbWBAAEw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Jan 2006 19:04:52 -0500
In-Reply-To: <20060201000146.GA4456@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: andrew.vasquez@qlogic.com

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 drivers/scsi/qla2xxx/qla_attr.c |   22 ++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_def.h  |    4 ++++
 drivers/scsi/qla2xxx/qla_isr.c  |    4 ++--
 drivers/scsi/qla2xxx/qla_os.c   |    1 +
 4 files changed, 29 insertions(+), 2 deletions(-)

55ed898e5d42cc3b42e701cffdc78d3a4b12130b
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index b17ee62..e03140f 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -426,6 +426,26 @@ qla2x00_get_host_port_id(struct Scsi_Hos
 }
 
 static void
+qla2x00_get_host_speed(struct Scsi_Host *shost)
+{
+	scsi_qla_host_t *ha = to_qla_host(shost);
+	uint32_t speed = 0;
+
+	switch (ha->link_data_rate) {
+	case LDR_1GB:
+		speed = 1;
+		break;
+	case LDR_2GB:
+		speed = 2;
+		break;
+	case LDR_4GB:
+		speed = 4;
+		break;
+	}
+	fc_host_speed(shost) = speed;
+}
+
+static void
 qla2x00_get_starget_node_name(struct scsi_target *starget)
 {
 	struct Scsi_Host *host = dev_to_shost(starget->dev.parent);
@@ -520,6 +540,8 @@ struct fc_function_template qla2xxx_tran
 
 	.get_host_port_id = qla2x00_get_host_port_id,
 	.show_host_port_id = 1,
+	.get_host_speed = qla2x00_get_host_speed,
+	.show_host_speed = 1,
 
 	.dd_fcrport_size = sizeof(struct fc_port *),
 	.show_rport_supported_classes = 1,
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index bad066e..26af531 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2331,6 +2331,10 @@ typedef struct scsi_qla_host {
 	uint16_t	min_external_loopid;	/* First external loop Id */
 
 	uint16_t	link_data_rate;		/* F/W operating speed */
+#define LDR_1GB		0
+#define LDR_2GB		1
+#define LDR_4GB		3
+#define LDR_UNKNOWN	0xFFFF
 
 	uint8_t		current_topology;
 	uint8_t		prev_topology;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 71a46fc..42aa7a7 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -402,9 +402,9 @@ qla2x00_async_event(scsi_qla_host_t *ha,
 		break;
 
 	case MBA_LOOP_UP:		/* Loop Up Event */
-		ha->link_data_rate = 0;
 		if (IS_QLA2100(ha) || IS_QLA2200(ha)) {
 			link_speed = link_speeds[0];
+			ha->link_data_rate = LDR_1GB;
 		} else {
 			link_speed = link_speeds[LS_UNKNOWN];
 			if (mb[1] < 5)
@@ -436,7 +436,7 @@ qla2x00_async_event(scsi_qla_host_t *ha,
 		}
 
 		ha->flags.management_server_logged_in = 0;
-		ha->link_data_rate = 0;
+		ha->link_data_rate = LDR_UNKNOWN;
 		if (ql2xfdmienable)
 			set_bit(REGISTER_FDMI_NEEDED, &ha->dpc_flags);
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 5866a7c..6e133ed 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1312,6 +1312,7 @@ int qla2x00_probe_one(struct pci_dev *pd
 	ha->ports = MAX_BUSES;
 	ha->init_cb_size = sizeof(init_cb_t);
 	ha->mgmt_svr_loop_id = MANAGEMENT_SERVER;
+	ha->link_data_rate = LDR_UNKNOWN;
 
 	/* Assign ISP specific operations. */
 	ha->isp_ops.pci_config		= qla2100_pci_config;
-- 
1.1.6.g1506


