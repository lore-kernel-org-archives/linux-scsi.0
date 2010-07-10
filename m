From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 04/10] qla4xxx: Fix the freeing of the buffer allocated for
	DMA
Date: Sat, 10 Jul 2010 14:49:38 +0530
Message-ID: <20100710091938.GA11495@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 115.113.65.67.static-pune-stdill.vsnl.net.in ([115.113.65.67]:42810
	"HELO sles11sp1b1.site" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1751827Ab0GJJXS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Jul 2010 05:23:18 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@suse.de, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org
Cc: ravi.anand@qlogic.com, vikas.chaudhary@qlogic.com, prasanna.mumbai@qlogic.com

From: Prasanna Mumbai <prasanna.mumbai@qlogic.com>

Fixed the DMA allocated memory freeing which wasn't taken care
in many cases.

Signed-off-by: Prasanna Mumbai <prasanna.mumbai@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_init.c |   38 ++++++++++++++++++++++++--------------
 drivers/scsi/qla4xxx/ql4_mbx.c  |   15 ++++++++-------
 2 files changed, 32 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index d525405..4a332c3 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -444,17 +444,17 @@ static struct ddb_entry* qla4xxx_get_ddb_entry(struct scsi_qla_host *ha,
 	if (fw_ddb_entry == NULL) {
 		DEBUG2(printk("scsi%ld: %s: Unable to allocate dma buffer.\n",
 			      ha->host_no, __func__));
-		return NULL;
+		goto exit_get_ddb_entry_no_free;
 	}
 
 	if (qla4xxx_get_fwddb_entry(ha, fw_ddb_index, fw_ddb_entry,
 				    fw_ddb_entry_dma, NULL, NULL,
 				    &device_state, NULL, NULL, NULL) ==
-	    QLA_ERROR) {
+				    QLA_ERROR) {
 		DEBUG2(printk("scsi%ld: %s: failed get_ddb_entry for "
 			      "fw_ddb_index %d\n", ha->host_no, __func__,
 			      fw_ddb_index));
-		return NULL;
+		goto exit_get_ddb_entry;
 	}
 
 	/* Allocate DDB if not already allocated. */
@@ -472,6 +472,7 @@ static struct ddb_entry* qla4xxx_get_ddb_entry(struct scsi_qla_host *ha,
 		}
 	}
 
+	/* if not found allocate new ddb */
 	if (!found) {
 		DEBUG2(printk("scsi%ld: %s: ddb[%d] not found - allocating "
 			      "new ddb\n", ha->host_no, __func__,
@@ -480,10 +481,11 @@ static struct ddb_entry* qla4xxx_get_ddb_entry(struct scsi_qla_host *ha,
 		ddb_entry = qla4xxx_alloc_ddb(ha, fw_ddb_index);
 	}
 
-	/* if not found allocate new ddb */
+exit_get_ddb_entry:
 	dma_free_coherent(&ha->pdev->dev, sizeof(*fw_ddb_entry), fw_ddb_entry,
 			  fw_ddb_entry_dma);
 
+exit_get_ddb_entry_no_free:
 	return ddb_entry;
 }
 
@@ -511,7 +513,8 @@ static int qla4xxx_update_ddb_entry(struct scsi_qla_host *ha,
 	if (ddb_entry == NULL) {
 		DEBUG2(printk("scsi%ld: %s: ddb_entry is NULL\n", ha->host_no,
 			      __func__));
-		goto exit_update_ddb;
+
+		goto exit_update_ddb_no_free;
 	}
 
 	/* Make sure the dma buffer is valid */
@@ -522,7 +525,7 @@ static int qla4xxx_update_ddb_entry(struct scsi_qla_host *ha,
 		DEBUG2(printk("scsi%ld: %s: Unable to allocate dma buffer.\n",
 			      ha->host_no, __func__));
 
-		goto exit_update_ddb;
+		goto exit_update_ddb_no_free;
 	}
 
 	if (qla4xxx_get_fwddb_entry(ha, fw_ddb_index, fw_ddb_entry,
@@ -530,7 +533,7 @@ static int qla4xxx_update_ddb_entry(struct scsi_qla_host *ha,
 				    &ddb_entry->fw_ddb_device_state, &conn_err,
 				    &ddb_entry->tcp_source_port_num,
 				    &ddb_entry->connection_id) ==
-	    QLA_ERROR) {
+				    QLA_ERROR) {
 		DEBUG2(printk("scsi%ld: %s: failed get_ddb_entry for "
 			      "fw_ddb_index %d\n", ha->host_no, __func__,
 			      fw_ddb_index));
@@ -605,6 +608,7 @@ exit_update_ddb:
 		dma_free_coherent(&ha->pdev->dev, sizeof(*fw_ddb_entry),
 				  fw_ddb_entry, fw_ddb_entry_dma);
 
+exit_update_ddb_no_free:
 	return status;
 }
 
@@ -689,7 +693,7 @@ int qla4_is_relogin_allowed(struct scsi_qla_host *ha, uint32_t conn_err)
  **/
 static int qla4xxx_build_ddb_list(struct scsi_qla_host *ha)
 {
-	int status = QLA_SUCCESS;
+	int status = QLA_ERROR;
 	uint32_t fw_ddb_index = 0;
 	uint32_t next_fw_ddb_index = 0;
 	uint32_t ddb_state;
@@ -705,7 +709,8 @@ static int qla4xxx_build_ddb_list(struct scsi_qla_host *ha)
 	if (fw_ddb_entry == NULL) {
 		DEBUG2(dev_info(&ha->pdev->dev, "%s: DMA alloc failed\n",
 				__func__));
-		return QLA_ERROR;
+
+		goto exit_build_ddb_list_no_free;
 	}
 
 	dev_info(&ha->pdev->dev, "Initializing DDBs ...\n");
@@ -720,7 +725,7 @@ static int qla4xxx_build_ddb_list(struct scsi_qla_host *ha)
 			DEBUG2(printk("scsi%ld: %s: get_ddb_entry, "
 				      "fw_ddb_index %d failed", ha->host_no,
 				      __func__, fw_ddb_index));
-			return QLA_ERROR;
+			goto exit_build_ddb_list;
 		}
 
 		DEBUG2(printk("scsi%ld: %s: Getting DDB[%d] ddbstate=0x%x, "
@@ -750,7 +755,7 @@ static int qla4xxx_build_ddb_list(struct scsi_qla_host *ha)
 						"get_ddb_entry %d failed\n",
 						ha->host_no,
 						__func__, fw_ddb_index));
-					return QLA_ERROR;
+					goto exit_build_ddb_list;
 				}
 			}
 		}
@@ -770,7 +775,7 @@ static int qla4xxx_build_ddb_list(struct scsi_qla_host *ha)
 			DEBUG2(printk("scsi%ld: %s: Unable to allocate memory "
 				      "for device at fw_ddb_index %d\n",
 				      ha->host_no, __func__, fw_ddb_index));
-			return QLA_ERROR;
+			goto exit_build_ddb_list;
 		}
 		/* Fill in the device structure */
 		if (qla4xxx_update_ddb_entry(ha, ddb_entry, fw_ddb_index) ==
@@ -778,11 +783,10 @@ static int qla4xxx_build_ddb_list(struct scsi_qla_host *ha)
 			ha->fw_ddb_index_map[fw_ddb_index] =
 				(struct ddb_entry *)INVALID_ENTRY;
 
-
 			DEBUG2(printk("scsi%ld: %s: update_ddb_entry failed "
 				      "for fw_ddb_index %d.\n",
 				      ha->host_no, __func__, fw_ddb_index));
-			return QLA_ERROR;
+			goto exit_build_ddb_list;
 		}
 
 next_one:
@@ -792,8 +796,14 @@ next_one:
 			break;
 	}
 
+	status = QLA_SUCCESS;
 	dev_info(&ha->pdev->dev, "DDB list done..\n");
 
+exit_build_ddb_list:
+	dma_free_coherent(&ha->pdev->dev, sizeof(*fw_ddb_entry), fw_ddb_entry,
+		fw_ddb_entry_dma);
+
+exit_build_ddb_list_no_free:
 	return status;
 }
 
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 75496fb..54db6cb 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -317,7 +317,7 @@ int qla4xxx_initialize_fw_cb(struct scsi_qla_host * ha)
 	if (init_fw_cb == NULL) {
 		DEBUG2(printk("scsi%ld: %s: Unable to alloc init_cb\n",
 			      ha->host_no, __func__));
-		return 10;
+		goto exit_init_fw_cb_no_free;
 	}
 	memset(init_fw_cb, 0, sizeof(struct addr_ctrl_blk));
 
@@ -373,7 +373,7 @@ int qla4xxx_initialize_fw_cb(struct scsi_qla_host * ha)
 exit_init_fw_cb:
 	dma_free_coherent(&ha->pdev->dev, sizeof(struct addr_ctrl_blk),
 				init_fw_cb, init_fw_cb_dma);
-
+exit_init_fw_cb_no_free:
 	return status;
 }
 
@@ -394,7 +394,7 @@ int qla4xxx_get_dhcp_ip_address(struct scsi_qla_host * ha)
 	if (init_fw_cb == NULL) {
 		printk("scsi%ld: %s: Unable to alloc init_cb\n", ha->host_no,
 		       __func__);
-		return 10;
+		return QLA_ERROR;
 	}
 
 	/* Get Initialize Firmware Control Block. */
@@ -1019,16 +1019,16 @@ int qla4xxx_send_tgts(struct scsi_qla_host *ha, char *ip, uint16_t port)
 		DEBUG2(printk("scsi%ld: %s: Unable to allocate dma buffer.\n",
 			      ha->host_no, __func__));
 		ret_val = QLA_ERROR;
-		goto qla4xxx_send_tgts_exit;
+		goto exit_send_tgts_no_free;
 	}
 
 	ret_val = qla4xxx_get_default_ddb(ha, fw_ddb_entry_dma);
 	if (ret_val != QLA_SUCCESS)
-		goto qla4xxx_send_tgts_exit;
+		goto exit_send_tgts;
 
 	ret_val = qla4xxx_req_ddb_entry(ha, &ddb_index);
 	if (ret_val != QLA_SUCCESS)
-		goto qla4xxx_send_tgts_exit;
+		goto exit_send_tgts;
 
 	memset(fw_ddb_entry->iscsi_alias, 0,
 	       sizeof(fw_ddb_entry->iscsi_alias));
@@ -1050,9 +1050,10 @@ int qla4xxx_send_tgts(struct scsi_qla_host *ha, char *ip, uint16_t port)
 
 	ret_val = qla4xxx_set_ddb_entry(ha, ddb_index, fw_ddb_entry_dma);
 
-qla4xxx_send_tgts_exit:
+exit_send_tgts:
 	dma_free_coherent(&ha->pdev->dev, sizeof(*fw_ddb_entry),
 			  fw_ddb_entry, fw_ddb_entry_dma);
+exit_send_tgts_no_free:
 	return ret_val;
 }
 
-- 
1.7.0.5

