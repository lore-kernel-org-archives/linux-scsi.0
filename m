From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 09/20] qla2xxx: Check status of qla2x00_get_fw_version() call.
Date: Wed,  3 Jun 2009 09:55:20 -0700
Message-ID: <1244048131-56590-10-git-send-email-andrew.vasquez@qlogic.com>
References: <1244048131-56590-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:4799 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755628AbZFCQzg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jun 2009 12:55:36 -0400
In-Reply-To: <1244048131-56590-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Unlike earlier ISPs, recent ISPs (ISP81xx) can in fact fail this
mailbox command.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h  |    2 +-
 drivers/scsi/qla2xxx/qla_init.c |    7 +++++--
 drivers/scsi/qla2xxx/qla_mbx.c  |    7 +++++--
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index fbf9972..1ef18cc 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -148,7 +148,7 @@ qla2x00_dump_ram(scsi_qla_host_t *, dma_addr_t, uint32_t, uint32_t);
 extern int
 qla2x00_execute_fw(scsi_qla_host_t *, uint32_t);
 
-extern void
+extern int
 qla2x00_get_fw_version(scsi_qla_host_t *, uint16_t *, uint16_t *, uint16_t *,
     uint16_t *, uint32_t *, uint8_t *, uint32_t *, uint8_t *);
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 34e6508..415fbf6 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -929,13 +929,16 @@ qla2x00_setup_chip(scsi_qla_host_t *vha)
 			/* Retrieve firmware information. */
 			if (rval == QLA_SUCCESS) {
 				fw_major_version = ha->fw_major_version;
-				qla2x00_get_fw_version(vha,
+				rval = qla2x00_get_fw_version(vha,
 				    &ha->fw_major_version,
 				    &ha->fw_minor_version,
 				    &ha->fw_subminor_version,
 				    &ha->fw_attributes, &ha->fw_memory_size,
 				    ha->mpi_version, &ha->mpi_capabilities,
 				    ha->phy_version);
+				if (rval != QLA_SUCCESS)
+					goto failed;
+
 				ha->flags.npiv_supported = 0;
 				if (IS_QLA2XXX_MIDTYPE(ha) &&
 					 (ha->fw_attributes & BIT_2)) {
@@ -987,7 +990,7 @@ qla2x00_setup_chip(scsi_qla_host_t *vha)
 			    ha->fw_subminor_version);
 		}
 	}
-
+failed:
 	if (rval) {
 		DEBUG2_3(printk("scsi(%ld): Setup chip **** FAILED ****.\n",
 		    vha->host_no));
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index e0fee48..b32eb69 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -408,7 +408,7 @@ qla2x00_execute_fw(scsi_qla_host_t *vha, uint32_t risc_addr)
  * Context:
  *	Kernel context.
  */
-void
+int
 qla2x00_get_fw_version(scsi_qla_host_t *vha, uint16_t *major, uint16_t *minor,
     uint16_t *subminor, uint16_t *attributes, uint32_t *memory, uint8_t *mpi,
     uint32_t *mpi_caps, uint8_t *phy)
@@ -427,6 +427,8 @@ qla2x00_get_fw_version(scsi_qla_host_t *vha, uint16_t *major, uint16_t *minor,
 	mcp->flags = 0;
 	mcp->tov = MBX_TOV_SECONDS;
 	rval = qla2x00_mailbox_command(vha, mcp);
+	if (rval != QLA_SUCCESS)
+		goto failed;
 
 	/* Return mailbox data. */
 	*major = mcp->mb[1];
@@ -446,7 +448,7 @@ qla2x00_get_fw_version(scsi_qla_host_t *vha, uint16_t *major, uint16_t *minor,
 		phy[1] = mcp->mb[9] >> 8;
 		phy[2] = mcp->mb[9] & 0xff;
 	}
-
+failed:
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
@@ -455,6 +457,7 @@ qla2x00_get_fw_version(scsi_qla_host_t *vha, uint16_t *major, uint16_t *minor,
 		/*EMPTY*/
 		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
 	}
+	return rval;
 }
 
 /*
-- 
1.6.3.1.244.gf9275

