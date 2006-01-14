From: andrew.vasquez@qlogic.com
Subject: [PATCH 10/15] qla2xxx: Collapse load RISC RAM implementations.
Date: Fri, 13 Jan 2006 17:05:37 -0800
Message-ID: <11372007322657-git-send-email-andrew.vasquez@qlogic.com>
References: <11372006833162-git-send-email-andrew.vasquez@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:14629 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S1945936AbWANBFi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 20:05:38 -0500
In-Reply-To: <11372006833162-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: andrew.vasquez@qlogic.com

Simplify essentially duplicate load RISC RAM implementation
in qla2x00_load_ram_ext() and qla2x00_load_ram().

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 drivers/scsi/qla2xxx/qla_gbl.h  |    5 --
 drivers/scsi/qla2xxx/qla_init.c |    8 ++-
 drivers/scsi/qla2xxx/qla_mbx.c  |  103 ++++-----------------------------------
 3 files changed, 15 insertions(+), 101 deletions(-)

1f15b948303d24cf972b1f8cc06cffaeadb80e9f
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index bec81ad..7872c11 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -96,10 +96,7 @@ int __qla2x00_marker(scsi_qla_host_t *, 
  * Global Function Prototypes in qla_mbx.c source file.
  */
 extern int
-qla2x00_load_ram(scsi_qla_host_t *, dma_addr_t, uint16_t, uint16_t);
-
-extern int
-qla2x00_load_ram_ext(scsi_qla_host_t *, dma_addr_t, uint32_t, uint32_t);
+qla2x00_load_ram(scsi_qla_host_t *, dma_addr_t, uint32_t, uint32_t);
 
 extern int
 qla2x00_execute_fw(scsi_qla_host_t *, uint32_t);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 49e8315..b4fbef5 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3672,8 +3672,8 @@ qla24xx_load_risc_flash(scsi_qla_host_t 
 			for (i = 0; i < dlen; i++)
 				dcode[i] = swab32(dcode[i]);
 
-			rval = qla2x00_load_ram_ext(ha, ha->request_dma,
-			    risc_addr, dlen);
+			rval = qla2x00_load_ram(ha, ha->request_dma, risc_addr,
+			    dlen);
 			if (rval) {
 				DEBUG(printk("scsi(%ld):[ERROR] Failed to load "
 				    "segment %d of firmware\n", ha->host_no,
@@ -3873,8 +3873,8 @@ qla24xx_load_risc(scsi_qla_host_t *ha, u
 			for (i = 0; i < dlen; i++)
 				dcode[i] = swab32(fwcode[i]);
 
-			rval = qla2x00_load_ram_ext(ha, ha->request_dma,
-			    risc_addr, dlen);
+			rval = qla2x00_load_ram(ha, ha->request_dma, risc_addr,
+			    dlen);
 			if (rval) {
 				DEBUG(printk("scsi(%ld):[ERROR] Failed to load "
 				    "segment %d of firmware\n", ha->host_no,
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 3de8fee..3099b37 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -327,113 +327,30 @@ qla2x00_mailbox_command(scsi_qla_host_t 
 	return rval;
 }
 
-/*
- * qla2x00_load_ram
- *	Load adapter RAM using DMA.
- *
- * Input:
- *	ha = adapter block pointer.
- *
- * Returns:
- *	qla2x00 local function return status code.
- *
- * Context:
- *	Kernel context.
- */
 int
-qla2x00_load_ram(scsi_qla_host_t *ha, dma_addr_t req_dma, uint16_t risc_addr,
-    uint16_t risc_code_size)
+qla2x00_load_ram(scsi_qla_host_t *ha, dma_addr_t req_dma, uint32_t risc_addr,
+    uint32_t risc_code_size)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
-	uint32_t	req_len;
-	dma_addr_t	nml_dma;
-	uint32_t	nml_len;
-	uint32_t	normalized;
-
-	DEBUG11(printk("qla2x00_load_ram(%ld): entered.\n",
-	    ha->host_no);)
 
-	req_len = risc_code_size;
-	nml_dma = 0;
-	nml_len = 0;
-
-	normalized = qla2x00_normalize_dma_addr(&req_dma, &req_len, &nml_dma,
-	    &nml_len);
-
-	/* Load first segment */
-	mcp->mb[0] = MBC_LOAD_RISC_RAM;
-	mcp->mb[1] = risc_addr;
-	mcp->mb[2] = MSW(req_dma);
-	mcp->mb[3] = LSW(req_dma);
-	mcp->mb[4] = (uint16_t)req_len;
-	mcp->mb[6] = MSW(MSD(req_dma));
-	mcp->mb[7] = LSW(MSD(req_dma));
-	mcp->out_mb = MBX_7|MBX_6|MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
-	mcp->in_mb = MBX_0;
-	mcp->tov = 30;
-	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
-
-	/* Load second segment - if necessary */
-	if (normalized && (rval == QLA_SUCCESS)) {
-		mcp->mb[0] = MBC_LOAD_RISC_RAM;
-		mcp->mb[1] = risc_addr + (uint16_t)req_len;
-		mcp->mb[2] = MSW(nml_dma);
-		mcp->mb[3] = LSW(nml_dma);
-		mcp->mb[4] = (uint16_t)nml_len;
-		mcp->mb[6] = MSW(MSD(nml_dma));
-		mcp->mb[7] = LSW(MSD(nml_dma));
-		mcp->out_mb = MBX_7|MBX_6|MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
-		mcp->in_mb = MBX_0;
-		mcp->tov = 30;
-		mcp->flags = 0;
-		rval = qla2x00_mailbox_command(ha, mcp);
-	}
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
 
-	if (rval == QLA_SUCCESS) {
-		/* Empty */
-		DEBUG11(printk("qla2x00_load_ram(%ld): done.\n", ha->host_no);)
+	if (MSW(risc_addr) || IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+		mcp->mb[0] = MBC_LOAD_RISC_RAM_EXTENDED;
+		mcp->mb[8] = MSW(risc_addr);
+		mcp->out_mb = MBX_8|MBX_0;
 	} else {
-		/* Empty */
-		DEBUG2_3_11(printk("qla2x00_load_ram(%ld): failed. rval=%x "
-		    "mb[0]=%x.\n", ha->host_no, rval, mcp->mb[0]);)
+		mcp->mb[0] = MBC_LOAD_RISC_RAM;
+		mcp->out_mb = MBX_0;
 	}
-	return rval;
-}
-
-/*
- * qla2x00_load_ram_ext
- *	Load adapter extended RAM using DMA.
- *
- * Input:
- *	ha = adapter block pointer.
- *
- * Returns:
- *	qla2x00 local function return status code.
- *
- * Context:
- *	Kernel context.
- */
-int
-qla2x00_load_ram_ext(scsi_qla_host_t *ha, dma_addr_t req_dma,
-    uint32_t risc_addr, uint32_t risc_code_size)
-{
-	int rval;
-	mbx_cmd_t mc;
-	mbx_cmd_t *mcp = &mc;
-
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
-
-	mcp->mb[0] = MBC_LOAD_RISC_RAM_EXTENDED;
 	mcp->mb[1] = LSW(risc_addr);
 	mcp->mb[2] = MSW(req_dma);
 	mcp->mb[3] = LSW(req_dma);
 	mcp->mb[6] = MSW(MSD(req_dma));
 	mcp->mb[7] = LSW(MSD(req_dma));
-	mcp->mb[8] = MSW(risc_addr);
-	mcp->out_mb = MBX_8|MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
+	mcp->out_mb |= MBX_7|MBX_6|MBX_3|MBX_2|MBX_1;
 	if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
 		mcp->mb[4] = MSW(risc_code_size);
 		mcp->mb[5] = LSW(risc_code_size);
-- 
1.1.1-g4c34


