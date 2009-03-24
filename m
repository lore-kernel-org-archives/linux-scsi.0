From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 21/26] qla2xxx: Reduce request queue-size overhead with recent ISPs.
Date: Tue, 24 Mar 2009 09:08:15 -0700
Message-ID: <1237910900-30817-22-git-send-email-andrew.vasquez@qlogic.com>
References: <1237910900-30817-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:29874 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762364AbZCXQIp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Mar 2009 12:08:45 -0400
In-Reply-To: <1237910900-30817-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

The original code to 'resize request-queues' based on iocb-counts
and employed during early ISP23xx testing was too
overly-pessimistic with regards to latencies in the firmware
pulling requests.  Recent ISPs can easily keep up processing a
stream of commands from an abbreviated (effectively, half the
original size) queue.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |    3 +-
 drivers/scsi/qla2xxx/qla_init.c |   67 +++------------------------------------
 2 files changed, 6 insertions(+), 64 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 01b7fc6..1a84dbf 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -176,8 +176,7 @@
 /* ISP request and response entry counts (37-65535) */
 #define REQUEST_ENTRY_CNT_2100		128	/* Number of request entries. */
 #define REQUEST_ENTRY_CNT_2200		2048	/* Number of request entries. */
-#define REQUEST_ENTRY_CNT_2XXX_EXT_MEM	4096	/* Number of request entries. */
-#define REQUEST_ENTRY_CNT_24XX		4096	/* Number of request entries. */
+#define REQUEST_ENTRY_CNT_24XX		2048	/* Number of request entries. */
 #define RESPONSE_ENTRY_CNT_2100		64	/* Number of response entries.*/
 #define RESPONSE_ENTRY_CNT_2300		512	/* Number of response entries.*/
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 997c83b..f90fd37 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -20,7 +20,6 @@
 *  QLogic ISP2x00 Hardware Support Function Prototypes.
 */
 static int qla2x00_isp_firmware(scsi_qla_host_t *);
-static void qla2x00_resize_request_q(scsi_qla_host_t *);
 static int qla2x00_setup_chip(scsi_qla_host_t *);
 static int qla2x00_init_rings(scsi_qla_host_t *);
 static int qla2x00_fw_ready(scsi_qla_host_t *);
@@ -893,62 +892,6 @@ cont_alloc:
 }
 
 /**
- * qla2x00_resize_request_q() - Resize request queue given available ISP memory.
- * @ha: HA context
- *
- * Returns 0 on success.
- */
-static void
-qla2x00_resize_request_q(scsi_qla_host_t *vha)
-{
-	int rval;
-	uint16_t fw_iocb_cnt = 0;
-	uint16_t request_q_length = REQUEST_ENTRY_CNT_2XXX_EXT_MEM;
-	dma_addr_t request_dma;
-	request_t *request_ring;
-	struct qla_hw_data *ha = vha->hw;
-	struct req_que *req = ha->req_q_map[0];
-
-	/* Valid only on recent ISPs. */
-	if (IS_QLA2100(ha) || IS_QLA2200(ha))
-		return;
-
-	/* Retrieve IOCB counts available to the firmware. */
-	rval = qla2x00_get_resource_cnts(vha, NULL, NULL, NULL, &fw_iocb_cnt,
-					&ha->max_npiv_vports);
-	if (rval)
-		return;
-	/* No point in continuing if current settings are sufficient. */
-	if (fw_iocb_cnt < 1024)
-		return;
-	if (req->length >= request_q_length)
-		return;
-
-	/* Attempt to claim larger area for request queue. */
-	request_ring = dma_alloc_coherent(&ha->pdev->dev,
-	    (request_q_length + 1) * sizeof(request_t), &request_dma,
-	    GFP_KERNEL);
-	if (request_ring == NULL)
-		return;
-
-	/* Resize successful, report extensions. */
-	qla_printk(KERN_INFO, ha, "Extended memory detected (%d KB)...\n",
-	    (ha->fw_memory_size + 1) / 1024);
-	qla_printk(KERN_INFO, ha, "Resizing request queue depth "
-	    "(%d -> %d)...\n", req->length, request_q_length);
-
-	/* Clear old allocations. */
-	dma_free_coherent(&ha->pdev->dev,
-	    (req->length + 1) * sizeof(request_t), req->ring,
-	    req->dma);
-
-	/* Begin using larger queue. */
-	req->length = request_q_length;
-	req->ring = request_ring;
-	req->dma = request_dma;
-}
-
-/**
  * qla2x00_setup_chip() - Load and start RISC firmware.
  * @ha: HA context
  *
@@ -1005,11 +948,11 @@ qla2x00_setup_chip(scsi_qla_host_t *vha)
 						ha->max_npiv_vports =
 						    MIN_MULTI_ID_FABRIC - 1;
 				}
-				if (!fw_major_version) {
-					qla2x00_resize_request_q(vha);
-					if (ql2xallocfwdump)
-						qla2x00_alloc_fw_dump(vha);
-				}
+				qla2x00_get_resource_cnts(vha, NULL, NULL,
+				    NULL, NULL, &ha->max_npiv_vports);
+
+				if (!fw_major_version && ql2xallocfwdump)
+					qla2x00_alloc_fw_dump(vha);
 			}
 		} else {
 			DEBUG2(printk(KERN_INFO
-- 
1.6.2.rc0.55.g30aa4f

