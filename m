From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [2/8]  qla2xxx: Dynamic resize of request-q
Date: Mon, 6 Sep 2004 21:27:03 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040907042703.GA29578@praka.san.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-02-qfe0.socal.rr.com ([66.75.162.134]:43692 "EHLO
	ms-smtp-02-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S267558AbUIGE2v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Sep 2004 00:28:51 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

ChangeSet
  1.1872 04/09/06 07:34:57 andrew.vasquez@qlogic.com +2 -0
  Dynamically resize request-queue during initialization based
  on the amount of memory available to the ISP.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

 drivers/scsi/qla2xxx/qla_def.h  |    1 
 drivers/scsi/qla2xxx/qla_init.c |   79 ++++++++++++++++++++++++++++++++--------
 2 files changed, 66 insertions(+), 14 deletions(-)

diff -Nru a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
--- a/drivers/scsi/qla2xxx/qla_def.h	2004-09-06 12:07:03 -07:00
+++ b/drivers/scsi/qla2xxx/qla_def.h	2004-09-06 12:07:03 -07:00
@@ -232,6 +232,7 @@
 /* ISP request and response entry counts (37-65535) */
 #define REQUEST_ENTRY_CNT_2100		128	/* Number of request entries. */
 #define REQUEST_ENTRY_CNT_2200		2048	/* Number of request entries. */
+#define REQUEST_ENTRY_CNT_2XXX_EXT_MEM	4096	/* Number of request entries. */
 #define RESPONSE_ENTRY_CNT_2100		64	/* Number of response entries.*/
 #define RESPONSE_ENTRY_CNT_2300		512	/* Number of response entries.*/
 
diff -Nru a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c	2004-09-06 12:07:03 -07:00
+++ b/drivers/scsi/qla2xxx/qla_init.c	2004-09-06 12:07:03 -07:00
@@ -37,6 +37,7 @@
 static int qla2x00_isp_firmware(scsi_qla_host_t *);
 static void qla2x00_reset_chip(scsi_qla_host_t *);
 static int qla2x00_chip_diag(scsi_qla_host_t *);
+static void qla2x00_resize_request_q(scsi_qla_host_t *);
 static int qla2x00_setup_chip(scsi_qla_host_t *);
 static void qla2x00_init_response_q_entries(scsi_qla_host_t *);
 static int qla2x00_init_rings(scsi_qla_host_t *);
@@ -660,6 +661,58 @@
 }
 
 /**
+ * qla2x00_resize_request_q() - Resize request queue given available ISP memory.
+ * @ha: HA context
+ *
+ * Returns 0 on success.
+ */
+static void
+qla2x00_resize_request_q(scsi_qla_host_t *ha)
+{
+	int rval;
+	uint16_t fw_iocb_cnt = 0;
+	uint16_t request_q_length = REQUEST_ENTRY_CNT_2XXX_EXT_MEM;
+	dma_addr_t request_dma;
+	request_t *request_ring;
+
+	/* Valid only on recent ISPs. */
+	if (IS_QLA2100(ha) || IS_QLA2200(ha))
+		return;
+
+	/* Retrieve IOCB counts available to the firmware. */
+	rval = qla2x00_get_resource_cnts(ha, NULL, NULL, NULL, &fw_iocb_cnt);
+	if (rval)
+		return;
+	/* No point in continuing if current settings are sufficient. */
+	if (fw_iocb_cnt < 1024)
+		return;
+	if (ha->request_q_length >= request_q_length)
+		return;
+
+	/* Attempt to claim larger area for request queue. */
+	request_ring = pci_alloc_consistent(ha->pdev,
+	    (request_q_length + 1) * sizeof(request_t), &request_dma);
+	if (request_ring == NULL)
+		return;
+
+	/* Resize successful, report extensions. */
+	qla_printk(KERN_INFO, ha, "Extended memory detected (%d KB)...\n",
+	    (ha->fw_memory_size + 1) / 1024);
+	qla_printk(KERN_INFO, ha, "Resizing request queue depth "
+	    "(%d -> %d)...\n", ha->request_q_length, request_q_length);
+
+	/* Clear old allocations. */
+	pci_free_consistent(ha->pdev,
+	    (ha->request_q_length + 1) * sizeof(request_t), ha->request_ring,
+	    ha->request_dma);
+
+	/* Begin using larger queue. */
+	ha->request_q_length = request_q_length;
+	ha->request_ring = request_ring;
+	ha->request_dma = request_dma;
+}
+
+/**
  * qla2x00_setup_chip() - Load and start RISC firmware.
  * @ha: HA context
  *
@@ -756,9 +809,9 @@
 				    &ha->fw_minor_version,
 				    &ha->fw_subminor_version,
 				    &ha->fw_attributes, &ha->fw_memory_size);
+				qla2x00_resize_request_q(ha);
 			}
-		}
-		else {
+		} else {
 			DEBUG2(printk(KERN_INFO
 			    "scsi(%ld): ISP Firmware failed checksum.\n",
 			    ha->host_no));
@@ -878,6 +931,16 @@
 	ha->response_ring_ptr = ha->response_ring;
 	ha->rsp_ring_index    = 0;
 
+	/* Setup ring parameters in initialization control block. */
+	ha->init_cb->request_q_outpointer = __constant_cpu_to_le16(0);
+	ha->init_cb->response_q_inpointer = __constant_cpu_to_le16(0);
+	ha->init_cb->request_q_length = cpu_to_le16(ha->request_q_length);
+	ha->init_cb->response_q_length = cpu_to_le16(ha->response_q_length);
+	ha->init_cb->request_q_address[0] = cpu_to_le32(LSD(ha->request_dma));
+	ha->init_cb->request_q_address[1] = cpu_to_le32(MSD(ha->request_dma));
+	ha->init_cb->response_q_address[0] = cpu_to_le32(LSD(ha->response_dma));
+	ha->init_cb->response_q_address[1] = cpu_to_le32(MSD(ha->response_dma));
+
 	/* Initialize response queue entries */
 	qla2x00_init_response_q_entries(ha);
 
@@ -1424,18 +1487,6 @@
 
 		ha->binding_type = BIND_BY_PORT_NAME;
 	}
-
-	/*
-	 * Setup ring parameters in initialization control block
-	 */
-	icb->request_q_outpointer = __constant_cpu_to_le16(0);
-	icb->response_q_inpointer = __constant_cpu_to_le16(0);
-	icb->request_q_length = cpu_to_le16(ha->request_q_length);
-	icb->response_q_length = cpu_to_le16(ha->response_q_length);
-	icb->request_q_address[0] = cpu_to_le32(LSD(ha->request_dma));
-	icb->request_q_address[1] = cpu_to_le32(MSD(ha->request_dma));
-	icb->response_q_address[0] = cpu_to_le32(LSD(ha->response_dma));
-	icb->response_q_address[1] = cpu_to_le32(MSD(ha->response_dma));
 
 	icb->lun_enables = __constant_cpu_to_le16(0);
 	icb->command_resource_count = 0;
