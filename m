From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 07/26] qla2xxx: Pass in optional extended-initialization control block.
Date: Tue, 24 Mar 2009 09:08:01 -0700
Message-ID: <1237910900-30817-8-git-send-email-andrew.vasquez@qlogic.com>
References: <1237910900-30817-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:29874 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762290AbZCXQIa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Mar 2009 12:08:30 -0400
In-Reply-To: <1237910900-30817-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Recent ISPs use this data to configure FCF information.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |    2 ++
 drivers/scsi/qla2xxx/qla_fw.h   |   23 ++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_init.c |    3 +++
 drivers/scsi/qla2xxx/qla_mbx.c  |   16 ++++++++++++----
 drivers/scsi/qla2xxx/qla_os.c   |   17 +++++++++++++++--
 5 files changed, 54 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index c2bc67c..5e7389d 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2440,6 +2440,8 @@ struct qla_hw_data {
 	dma_addr_t	init_cb_dma;
 	init_cb_t	*init_cb;
 	int		init_cb_size;
+	dma_addr_t	ex_init_cb_dma;
+	struct ex_init_cb_81xx *ex_init_cb;
 
 	/* These are used by mailbox operations. */
 	volatile uint16_t mailbox_out[MAILBOX_REGISTER_COUNT];
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index ffff425..05cf838 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -1440,7 +1440,17 @@ struct nvram_81xx {
 	uint16_t reserved_6[24];
 
 	/* Offset 128. */
-	uint16_t reserved_7[64];
+	uint16_t ex_version;
+	uint8_t prio_fcf_matching_flags;
+	uint8_t reserved_6_1[3];
+	uint16_t pri_fcf_vlan_id;
+	uint8_t pri_fcf_fabric_name[8];
+	uint16_t reserved_6_2[7];
+	uint8_t spma_mac_addr[6];
+	uint16_t reserved_6_3[14];
+
+	/* Offset 192. */
+	uint16_t reserved_7[32];
 
 	/*
 	 * BIT 0  = Enable spinup delay
@@ -1664,6 +1674,17 @@ struct mid_init_cb_81xx {
 	struct mid_conf_entry_24xx entries[MAX_MULTI_ID_FABRIC];
 };
 
+struct ex_init_cb_81xx {
+	uint16_t ex_version;
+	uint8_t prio_fcf_matching_flags;
+	uint8_t reserved_1[3];
+	uint16_t pri_fcf_vlan_id;
+	uint8_t pri_fcf_fabric_name[8];
+	uint16_t reserved_2[7];
+	uint8_t spma_mac_addr[6];
+	uint16_t reserved_3[14];
+};
+
 #define FARX_ACCESS_FLASH_CONF_81XX	0x7FFD0000
 #define FARX_ACCESS_FLASH_DATA_81XX	0x7F800000
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index a8a0f13..e793387 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4455,6 +4455,9 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
 		icb->enode_mac[5] = 0x06 + PCI_FUNC(ha->pdev->devfn);
 	}
 
+	/* Use extended-initialization control block. */
+	memcpy(ha->ex_init_cb, &nv->ex_version, sizeof(*ha->ex_init_cb));
+
 	/*
 	 * Setup driver NVRAM options.
 	 */
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 4aab7ac..91e133b 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1043,14 +1043,22 @@ qla2x00_init_firmware(scsi_qla_host_t *vha, uint16_t size)
 	else
 		mcp->mb[0] = MBC_INITIALIZE_FIRMWARE;
 
+	mcp->mb[1] = 0;
 	mcp->mb[2] = MSW(ha->init_cb_dma);
 	mcp->mb[3] = LSW(ha->init_cb_dma);
-	mcp->mb[4] = 0;
-	mcp->mb[5] = 0;
 	mcp->mb[6] = MSW(MSD(ha->init_cb_dma));
 	mcp->mb[7] = LSW(MSD(ha->init_cb_dma));
-	mcp->out_mb = MBX_7|MBX_6|MBX_3|MBX_2|MBX_0;
-	mcp->in_mb = MBX_5|MBX_4|MBX_0;
+	mcp->out_mb = MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
+	if (IS_QLA81XX(ha) && ha->ex_init_cb->ex_version) {
+		mcp->mb[1] = BIT_0;
+		mcp->mb[10] = MSW(ha->ex_init_cb_dma);
+		mcp->mb[11] = LSW(ha->ex_init_cb_dma);
+		mcp->mb[12] = MSW(MSD(ha->ex_init_cb_dma));
+		mcp->mb[13] = LSW(MSD(ha->ex_init_cb_dma));
+		mcp->mb[14] = sizeof(*ha->ex_init_cb);
+		mcp->out_mb |= MBX_14|MBX_13|MBX_12|MBX_11|MBX_10;
+	}
+	mcp->in_mb = MBX_0;
 	mcp->buf_size = size;
 	mcp->flags = MBX_DMA_OUT;
 	mcp->tov = MBX_TOV_SECONDS;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 41ff7d6..dad624e 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2203,9 +2203,19 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 	} else
 		ha->npiv_info = NULL;
 
+	/* Get consistent memory allocated for EX-INIT-CB. */
+	if (IS_QLA81XX(ha)) {
+		ha->ex_init_cb = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL,
+		    &ha->ex_init_cb_dma);
+		if (!ha->ex_init_cb)
+			goto fail_ex_init_cb;
+	}
+
 	INIT_LIST_HEAD(&ha->vp_list);
 	return 1;
 
+fail_ex_init_cb:
+	kfree(ha->npiv_info);
 fail_npiv_info:
 	dma_free_coherent(&ha->pdev->dev, ((*rsp)->length + 1) *
 		sizeof(response_t), (*rsp)->ring, (*rsp)->dma);
@@ -2291,15 +2301,16 @@ qla2x00_mem_free(struct qla_hw_data *ha)
 	if (ha->ms_iocb)
 		dma_pool_free(ha->s_dma_pool, ha->ms_iocb, ha->ms_iocb_dma);
 
+	if (ha->ex_init_cb)
+		dma_pool_free(ha->s_dma_pool, ha->ex_init_cb, ha->ex_init_cb_dma);
+
 	if (ha->s_dma_pool)
 		dma_pool_destroy(ha->s_dma_pool);
 
-
 	if (ha->gid_list)
 		dma_free_coherent(&ha->pdev->dev, GID_LIST_SIZE, ha->gid_list,
 		ha->gid_list_dma);
 
-
 	if (ha->init_cb)
 		dma_free_coherent(&ha->pdev->dev, ha->init_cb_size,
 		ha->init_cb, ha->init_cb_dma);
@@ -2318,6 +2329,8 @@ qla2x00_mem_free(struct qla_hw_data *ha)
 	ha->ms_iocb_dma = 0;
 	ha->init_cb = NULL;
 	ha->init_cb_dma = 0;
+	ha->ex_init_cb = NULL;
+	ha->ex_init_cb_dma = 0;
 
 	ha->s_dma_pool = NULL;
 
-- 
1.6.2.rc0.55.g30aa4f

