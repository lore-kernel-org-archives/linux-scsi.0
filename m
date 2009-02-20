From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: [PATCH] qla2xx: annotate structs and function prototypes
Date: Fri, 20 Feb 2009 15:24:18 -0800
Message-ID: <1235172258.10163.3.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:54423 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453AbZBTXYW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Feb 2009 18:24:22 -0500
Received: by wf-out-1314.google.com with SMTP id 28so1416472wfa.4
        for <linux-scsi@vger.kernel.org>; Fri, 20 Feb 2009 15:24:21 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

There should be no functional changes, this is just cleaning up the endian
noise a bit (> 1000 warnings).

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Not quite finished yet, but the patch was getting so large I wanted to
get some feedback before continuing.

 drivers/scsi/qla2xxx/qla_attr.c |    4 +-
 drivers/scsi/qla2xxx/qla_dbg.c  |   31 ++--
 drivers/scsi/qla2xxx/qla_dbg.h  |  332 +++++++++++++++++++-------------------
 drivers/scsi/qla2xxx/qla_def.h  |  102 ++++++------
 drivers/scsi/qla2xxx/qla_fw.h   |  106 ++++++------
 drivers/scsi/qla2xxx/qla_iocb.c |    5 +-
 drivers/scsi/qla2xxx/qla_sup.c  |   15 +-
 7 files changed, 297 insertions(+), 298 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index f4c5722..19a7422 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -116,10 +116,10 @@ qla2x00_sysfs_write_nvram(struct kobject *kobj,
 
 	/* Checksum NVRAM. */
 	if (IS_FWI2_CAPABLE(ha)) {
-		uint32_t *iter;
+		__le32 *iter;
 		uint32_t chksum;
 
-		iter = (uint32_t *)buf;
+		iter = (__le32 *)buf;
 		chksum = 0;
 		for (cnt = 0; cnt < ((count >> 2) - 1); cnt++)
 			chksum += le32_to_cpu(*iter++);
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 2a4e412..c281b3a 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -40,7 +40,7 @@ qla2xxx_copy_queues(struct qla_hw_data *ha, void *ptr)
 }
 
 static int
-qla24xx_dump_ram(struct qla_hw_data *ha, uint32_t addr, uint32_t *ram,
+qla24xx_dump_ram(struct qla_hw_data *ha, uint32_t addr, __be32 *ram,
     uint32_t ram_dwords, void **nxt)
 {
 	int rval;
@@ -114,7 +114,7 @@ qla24xx_dump_ram(struct qla_hw_data *ha, uint32_t addr, uint32_t *ram,
 }
 
 static int
-qla24xx_dump_memory(struct qla_hw_data *ha, uint32_t *code_ram,
+qla24xx_dump_memory(struct qla_hw_data *ha, __be32 *code_ram,
     uint32_t cram_size, void **nxt)
 {
 	int rval;
@@ -129,9 +129,9 @@ qla24xx_dump_memory(struct qla_hw_data *ha, uint32_t *code_ram,
 	    ha->fw_memory_size - 0x100000 + 1, nxt);
 }
 
-static uint32_t *
+static __be32 *
 qla24xx_read_window(struct device_reg_24xx __iomem *reg, uint32_t iobase,
-    uint32_t count, uint32_t *buf)
+    uint32_t count, __be32 *buf)
 {
 	uint32_t __iomem *dmp_reg;
 
@@ -217,7 +217,7 @@ qla24xx_soft_reset(struct qla_hw_data *ha)
 }
 
 static int
-qla2xxx_dump_ram(struct qla_hw_data *ha, uint32_t addr, uint16_t *ram,
+qla2xxx_dump_ram(struct qla_hw_data *ha, uint32_t addr, __be16 *ram,
     uint16_t ram_words, void **nxt)
 {
 	int rval;
@@ -302,7 +302,7 @@ qla2xxx_dump_ram(struct qla_hw_data *ha, uint32_t addr, uint16_t *ram,
 
 static inline void
 qla2xxx_read_window(struct device_reg_2xxx __iomem *reg, uint32_t count,
-    uint16_t *buf)
+    __be16 *buf)
 {
 	uint16_t __iomem *dmp_reg = &reg->u.isp2300.fb_cmd;
 
@@ -321,10 +321,10 @@ qla24xx_copy_eft(struct qla_hw_data *ha, void *ptr)
 }
 
 static inline void *
-qla25xx_copy_fce(struct qla_hw_data *ha, void *ptr, uint32_t **last_chain)
+qla25xx_copy_fce(struct qla_hw_data *ha, void *ptr, __be32 **last_chain)
 {
 	uint32_t cnt;
-	uint32_t *iter_reg;
+	__be32 *iter_reg;
 	struct qla2xxx_fce_chain *fcec = ptr;
 
 	if (!ha->fce)
@@ -348,7 +348,7 @@ qla25xx_copy_fce(struct qla_hw_data *ha, void *ptr, uint32_t **last_chain)
 }
 
 static inline void *
-qla25xx_copy_mq(struct qla_hw_data *ha, void *ptr, uint32_t **last_chain)
+qla25xx_copy_mq(struct qla_hw_data *ha, void *ptr, __be32 **last_chain)
 {
 	uint32_t cnt, que_idx;
 	uint8_t req_cnt, rsp_cnt, que_cnt;
@@ -368,8 +368,7 @@ qla25xx_copy_mq(struct qla_hw_data *ha, void *ptr, uint32_t **last_chain)
 	que_cnt = req_cnt > rsp_cnt ? req_cnt : rsp_cnt;
 	mq->count = htonl(que_cnt);
 	for (cnt = 0; cnt < que_cnt; cnt++) {
-		reg = (struct device_reg_25xxmq *) ((void *)
-			ha->mqiobase + cnt * QLA_QUE_PAGE);
+		reg = ((void __iomem *)ha->mqiobase + cnt * QLA_QUE_PAGE);
 		que_idx = cnt * 4;
 		mq->qregs[que_idx] = htonl(RD_REG_DWORD(&reg->req_q_in));
 		mq->qregs[que_idx+1] = htonl(RD_REG_DWORD(&reg->req_q_out));
@@ -766,7 +765,7 @@ qla24xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 	uint32_t __iomem *dmp_reg;
-	uint32_t	*iter_reg;
+	__be32	*iter_reg;
 	uint16_t __iomem *mbx_reg;
 	unsigned long	flags;
 	struct qla24xx_fw_dump *fw;
@@ -1013,13 +1012,13 @@ qla25xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 	uint32_t __iomem *dmp_reg;
-	uint32_t	*iter_reg;
+	__be32	*iter_reg;
 	uint16_t __iomem *mbx_reg;
 	unsigned long	flags;
 	struct qla25xx_fw_dump *fw;
 	uint32_t	ext_mem_cnt;
 	void		*nxt, *nxt_chain;
-	uint32_t	*last_chain = NULL;
+	__be32	*last_chain = NULL;
 	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
 
 	risc_address = ext_mem_cnt = 0;
@@ -1334,13 +1333,13 @@ qla81xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 	uint32_t __iomem *dmp_reg;
-	uint32_t	*iter_reg;
+	__be32	*iter_reg;
 	uint16_t __iomem *mbx_reg;
 	unsigned long	flags;
 	struct qla81xx_fw_dump *fw;
 	uint32_t	ext_mem_cnt;
 	void		*nxt, *nxt_chain;
-	uint32_t	*last_chain = NULL;
+	__be32	*last_chain = NULL;
 	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
 
 	risc_address = ext_mem_cnt = 0;
diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
index f660dd7..e35c6b4 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.h
+++ b/drivers/scsi/qla2xxx/qla_dbg.h
@@ -137,157 +137,157 @@
  */
 
 struct qla2300_fw_dump {
-	uint16_t hccr;
-	uint16_t pbiu_reg[8];
-	uint16_t risc_host_reg[8];
-	uint16_t mailbox_reg[32];
-	uint16_t resp_dma_reg[32];
-	uint16_t dma_reg[48];
-	uint16_t risc_hdw_reg[16];
-	uint16_t risc_gp0_reg[16];
-	uint16_t risc_gp1_reg[16];
-	uint16_t risc_gp2_reg[16];
-	uint16_t risc_gp3_reg[16];
-	uint16_t risc_gp4_reg[16];
-	uint16_t risc_gp5_reg[16];
-	uint16_t risc_gp6_reg[16];
-	uint16_t risc_gp7_reg[16];
-	uint16_t frame_buf_hdw_reg[64];
-	uint16_t fpm_b0_reg[64];
-	uint16_t fpm_b1_reg[64];
-	uint16_t risc_ram[0xf800];
-	uint16_t stack_ram[0x1000];
-	uint16_t data_ram[1];
+	__be16 hccr;
+	__be16 pbiu_reg[8];
+	__be16 risc_host_reg[8];
+	__be16 mailbox_reg[32];
+	__be16 resp_dma_reg[32];
+	__be16 dma_reg[48];
+	__be16 risc_hdw_reg[16];
+	__be16 risc_gp0_reg[16];
+	__be16 risc_gp1_reg[16];
+	__be16 risc_gp2_reg[16];
+	__be16 risc_gp3_reg[16];
+	__be16 risc_gp4_reg[16];
+	__be16 risc_gp5_reg[16];
+	__be16 risc_gp6_reg[16];
+	__be16 risc_gp7_reg[16];
+	__be16 frame_buf_hdw_reg[64];
+	__be16 fpm_b0_reg[64];
+	__be16 fpm_b1_reg[64];
+	__be16 risc_ram[0xf800];
+	__be16 stack_ram[0x1000];
+	__be16 data_ram[1];
 };
 
 struct qla2100_fw_dump {
-	uint16_t hccr;
-	uint16_t pbiu_reg[8];
-	uint16_t mailbox_reg[32];
-	uint16_t dma_reg[48];
-	uint16_t risc_hdw_reg[16];
-	uint16_t risc_gp0_reg[16];
-	uint16_t risc_gp1_reg[16];
-	uint16_t risc_gp2_reg[16];
-	uint16_t risc_gp3_reg[16];
-	uint16_t risc_gp4_reg[16];
-	uint16_t risc_gp5_reg[16];
-	uint16_t risc_gp6_reg[16];
-	uint16_t risc_gp7_reg[16];
-	uint16_t frame_buf_hdw_reg[16];
-	uint16_t fpm_b0_reg[64];
-	uint16_t fpm_b1_reg[64];
-	uint16_t risc_ram[0xf000];
+	__be16 hccr;
+	__be16 pbiu_reg[8];
+	__be16 mailbox_reg[32];
+	__be16 dma_reg[48];
+	__be16 risc_hdw_reg[16];
+	__be16 risc_gp0_reg[16];
+	__be16 risc_gp1_reg[16];
+	__be16 risc_gp2_reg[16];
+	__be16 risc_gp3_reg[16];
+	__be16 risc_gp4_reg[16];
+	__be16 risc_gp5_reg[16];
+	__be16 risc_gp6_reg[16];
+	__be16 risc_gp7_reg[16];
+	__be16 frame_buf_hdw_reg[16];
+	__be16 fpm_b0_reg[64];
+	__be16 fpm_b1_reg[64];
+	__be16 risc_ram[0xf000];
 };
 
 struct qla24xx_fw_dump {
-	uint32_t host_status;
-	uint32_t host_reg[32];
-	uint32_t shadow_reg[7];
-	uint16_t mailbox_reg[32];
-	uint32_t xseq_gp_reg[128];
-	uint32_t xseq_0_reg[16];
-	uint32_t xseq_1_reg[16];
-	uint32_t rseq_gp_reg[128];
-	uint32_t rseq_0_reg[16];
-	uint32_t rseq_1_reg[16];
-	uint32_t rseq_2_reg[16];
-	uint32_t cmd_dma_reg[16];
-	uint32_t req0_dma_reg[15];
-	uint32_t resp0_dma_reg[15];
-	uint32_t req1_dma_reg[15];
-	uint32_t xmt0_dma_reg[32];
-	uint32_t xmt1_dma_reg[32];
-	uint32_t xmt2_dma_reg[32];
-	uint32_t xmt3_dma_reg[32];
-	uint32_t xmt4_dma_reg[32];
-	uint32_t xmt_data_dma_reg[16];
-	uint32_t rcvt0_data_dma_reg[32];
-	uint32_t rcvt1_data_dma_reg[32];
-	uint32_t risc_gp_reg[128];
-	uint32_t lmc_reg[112];
-	uint32_t fpm_hdw_reg[192];
-	uint32_t fb_hdw_reg[176];
-	uint32_t code_ram[0x2000];
-	uint32_t ext_mem[1];
+	__be32 host_status;
+	__be32 host_reg[32];
+	__be32 shadow_reg[7];
+	__be16 mailbox_reg[32];
+	__be32 xseq_gp_reg[128];
+	__be32 xseq_0_reg[16];
+	__be32 xseq_1_reg[16];
+	__be32 rseq_gp_reg[128];
+	__be32 rseq_0_reg[16];
+	__be32 rseq_1_reg[16];
+	__be32 rseq_2_reg[16];
+	__be32 cmd_dma_reg[16];
+	__be32 req0_dma_reg[15];
+	__be32 resp0_dma_reg[15];
+	__be32 req1_dma_reg[15];
+	__be32 xmt0_dma_reg[32];
+	__be32 xmt1_dma_reg[32];
+	__be32 xmt2_dma_reg[32];
+	__be32 xmt3_dma_reg[32];
+	__be32 xmt4_dma_reg[32];
+	__be32 xmt_data_dma_reg[16];
+	__be32 rcvt0_data_dma_reg[32];
+	__be32 rcvt1_data_dma_reg[32];
+	__be32 risc_gp_reg[128];
+	__be32 lmc_reg[112];
+	__be32 fpm_hdw_reg[192];
+	__be32 fb_hdw_reg[176];
+	__be32 code_ram[0x2000];
+	__be32 ext_mem[1];
 };
 
 struct qla25xx_fw_dump {
-	uint32_t host_status;
-	uint32_t host_risc_reg[32];
-	uint32_t pcie_regs[4];
-	uint32_t host_reg[32];
-	uint32_t shadow_reg[11];
-	uint32_t risc_io_reg;
-	uint16_t mailbox_reg[32];
-	uint32_t xseq_gp_reg[128];
-	uint32_t xseq_0_reg[48];
-	uint32_t xseq_1_reg[16];
-	uint32_t rseq_gp_reg[128];
-	uint32_t rseq_0_reg[32];
-	uint32_t rseq_1_reg[16];
-	uint32_t rseq_2_reg[16];
-	uint32_t aseq_gp_reg[128];
-	uint32_t aseq_0_reg[32];
-	uint32_t aseq_1_reg[16];
-	uint32_t aseq_2_reg[16];
-	uint32_t cmd_dma_reg[16];
-	uint32_t req0_dma_reg[15];
-	uint32_t resp0_dma_reg[15];
-	uint32_t req1_dma_reg[15];
-	uint32_t xmt0_dma_reg[32];
-	uint32_t xmt1_dma_reg[32];
-	uint32_t xmt2_dma_reg[32];
-	uint32_t xmt3_dma_reg[32];
-	uint32_t xmt4_dma_reg[32];
-	uint32_t xmt_data_dma_reg[16];
-	uint32_t rcvt0_data_dma_reg[32];
-	uint32_t rcvt1_data_dma_reg[32];
-	uint32_t risc_gp_reg[128];
-	uint32_t lmc_reg[128];
-	uint32_t fpm_hdw_reg[192];
-	uint32_t fb_hdw_reg[192];
-	uint32_t code_ram[0x2000];
-	uint32_t ext_mem[1];
+	__be32 host_status;
+	__be32 host_risc_reg[32];
+	__be32 pcie_regs[4];
+	__be32 host_reg[32];
+	__be32 shadow_reg[11];
+	__be32 risc_io_reg;
+	__be16 mailbox_reg[32];
+	__be32 xseq_gp_reg[128];
+	__be32 xseq_0_reg[48];
+	__be32 xseq_1_reg[16];
+	__be32 rseq_gp_reg[128];
+	__be32 rseq_0_reg[32];
+	__be32 rseq_1_reg[16];
+	__be32 rseq_2_reg[16];
+	__be32 aseq_gp_reg[128];
+	__be32 aseq_0_reg[32];
+	__be32 aseq_1_reg[16];
+	__be32 aseq_2_reg[16];
+	__be32 cmd_dma_reg[16];
+	__be32 req0_dma_reg[15];
+	__be32 resp0_dma_reg[15];
+	__be32 req1_dma_reg[15];
+	__be32 xmt0_dma_reg[32];
+	__be32 xmt1_dma_reg[32];
+	__be32 xmt2_dma_reg[32];
+	__be32 xmt3_dma_reg[32];
+	__be32 xmt4_dma_reg[32];
+	__be32 xmt_data_dma_reg[16];
+	__be32 rcvt0_data_dma_reg[32];
+	__be32 rcvt1_data_dma_reg[32];
+	__be32 risc_gp_reg[128];
+	__be32 lmc_reg[128];
+	__be32 fpm_hdw_reg[192];
+	__be32 fb_hdw_reg[192];
+	__be32 code_ram[0x2000];
+	__be32 ext_mem[1];
 };
 
 struct qla81xx_fw_dump {
-	uint32_t host_status;
-	uint32_t host_risc_reg[32];
-	uint32_t pcie_regs[4];
-	uint32_t host_reg[32];
-	uint32_t shadow_reg[11];
-	uint32_t risc_io_reg;
-	uint16_t mailbox_reg[32];
-	uint32_t xseq_gp_reg[128];
-	uint32_t xseq_0_reg[48];
-	uint32_t xseq_1_reg[16];
-	uint32_t rseq_gp_reg[128];
-	uint32_t rseq_0_reg[32];
-	uint32_t rseq_1_reg[16];
-	uint32_t rseq_2_reg[16];
-	uint32_t aseq_gp_reg[128];
-	uint32_t aseq_0_reg[32];
-	uint32_t aseq_1_reg[16];
-	uint32_t aseq_2_reg[16];
-	uint32_t cmd_dma_reg[16];
-	uint32_t req0_dma_reg[15];
-	uint32_t resp0_dma_reg[15];
-	uint32_t req1_dma_reg[15];
-	uint32_t xmt0_dma_reg[32];
-	uint32_t xmt1_dma_reg[32];
-	uint32_t xmt2_dma_reg[32];
-	uint32_t xmt3_dma_reg[32];
-	uint32_t xmt4_dma_reg[32];
-	uint32_t xmt_data_dma_reg[16];
-	uint32_t rcvt0_data_dma_reg[32];
-	uint32_t rcvt1_data_dma_reg[32];
-	uint32_t risc_gp_reg[128];
-	uint32_t lmc_reg[128];
-	uint32_t fpm_hdw_reg[224];
-	uint32_t fb_hdw_reg[208];
-	uint32_t code_ram[0x2000];
-	uint32_t ext_mem[1];
+	__be32 host_status;
+	__be32 host_risc_reg[32];
+	__be32 pcie_regs[4];
+	__be32 host_reg[32];
+	__be32 shadow_reg[11];
+	__be32 risc_io_reg;
+	__be16 mailbox_reg[32];
+	__be32 xseq_gp_reg[128];
+	__be32 xseq_0_reg[48];
+	__be32 xseq_1_reg[16];
+	__be32 rseq_gp_reg[128];
+	__be32 rseq_0_reg[32];
+	__be32 rseq_1_reg[16];
+	__be32 rseq_2_reg[16];
+	__be32 aseq_gp_reg[128];
+	__be32 aseq_0_reg[32];
+	__be32 aseq_1_reg[16];
+	__be32 aseq_2_reg[16];
+	__be32 cmd_dma_reg[16];
+	__be32 req0_dma_reg[15];
+	__be32 resp0_dma_reg[15];
+	__be32 req1_dma_reg[15];
+	__be32 xmt0_dma_reg[32];
+	__be32 xmt1_dma_reg[32];
+	__be32 xmt2_dma_reg[32];
+	__be32 xmt3_dma_reg[32];
+	__be32 xmt4_dma_reg[32];
+	__be32 xmt_data_dma_reg[16];
+	__be32 rcvt0_data_dma_reg[32];
+	__be32 rcvt1_data_dma_reg[32];
+	__be32 risc_gp_reg[128];
+	__be32 lmc_reg[128];
+	__be32 fpm_hdw_reg[224];
+	__be32 fb_hdw_reg[208];
+	__be32 code_ram[0x2000];
+	__be32 ext_mem[1];
 };
 
 #define EFT_NUM_BUFFERS		4
@@ -300,21 +300,21 @@ struct qla81xx_fw_dump {
 #define fce_calc_size(b)	((FCE_BYTES_PER_BUFFER) * (b))
 
 struct qla2xxx_fce_chain {
-	uint32_t type;
-	uint32_t chain_size;
+	__be32 type;
+	__be32 chain_size;
 
-	uint32_t size;
-	uint32_t addr_l;
-	uint32_t addr_h;
-	uint32_t eregs[8];
+	__be32 size;
+	__be32 addr_l;
+	__be32 addr_h;
+	__be32 eregs[8];
 };
 
 struct qla2xxx_mq_chain {
-	uint32_t type;
-	uint32_t chain_size;
+	__be32 type;
+	__be32 chain_size;
 
-	uint32_t count;
-	uint32_t qregs[4 * QLA_MQ_SIZE];
+	__be32 count;
+	__be32 qregs[4 * QLA_MQ_SIZE];
 };
 
 #define DUMP_CHAIN_VARIANT	0x80000000
@@ -324,28 +324,28 @@ struct qla2xxx_mq_chain {
 
 struct qla2xxx_fw_dump {
 	uint8_t signature[4];
-	uint32_t version;
+	__be32 version;
 
-	uint32_t fw_major_version;
-	uint32_t fw_minor_version;
-	uint32_t fw_subminor_version;
-	uint32_t fw_attributes;
+	__be32 fw_major_version;
+	__be32 fw_minor_version;
+	__be32 fw_subminor_version;
+	__be32 fw_attributes;
 
-	uint32_t vendor;
-	uint32_t device;
-	uint32_t subsystem_vendor;
-	uint32_t subsystem_device;
+	__be32 vendor;
+	__be32 device;
+	__be32 subsystem_vendor;
+	__be32 subsystem_device;
 
-	uint32_t fixed_size;
-	uint32_t mem_size;
-	uint32_t req_q_size;
-	uint32_t rsp_q_size;
+	__be32 fixed_size;
+	__be32 mem_size;
+	__be32 req_q_size;
+	__be32 rsp_q_size;
 
-	uint32_t eft_size;
-	uint32_t eft_addr_l;
-	uint32_t eft_addr_h;
+	__be32 eft_size;
+	__be32 eft_addr_l;
+	__be32 eft_addr_h;
 
-	uint32_t header_size;
+	__be32 header_size;
 
 	union {
 		struct qla2100_fw_dump isp21;
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index e0c5bb5..bab4762 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -788,9 +788,9 @@ typedef struct {
 	 */
 	uint8_t  firmware_options[2];
 
-	uint16_t frame_payload_size;
+	__le16 frame_payload_size;
 	uint16_t max_iocb_allocation;
-	uint16_t execution_throttle;
+	__le16 execution_throttle;
 	uint8_t  retry_count;
 	uint8_t	 retry_delay;			/* unused */
 	uint8_t	 port_name[WWN_SIZE];		/* Big endian. */
@@ -799,17 +799,17 @@ typedef struct {
 	uint8_t	 login_timeout;
 	uint8_t	 node_name[WWN_SIZE];		/* Big endian. */
 
-	uint16_t request_q_outpointer;
-	uint16_t response_q_inpointer;
-	uint16_t request_q_length;
-	uint16_t response_q_length;
-	uint32_t request_q_address[2];
-	uint32_t response_q_address[2];
+	__le16 request_q_outpointer;
+	__le16 response_q_inpointer;
+	__le16 request_q_length;
+	__le16 response_q_length;
+	__le32 request_q_address[2];
+	__le32 response_q_address[2];
 
-	uint16_t lun_enables;
+	__le16 lun_enables;
 	uint8_t  command_resource_count;
 	uint8_t  immediate_notify_resource_count;
-	uint16_t timeout;
+	__le16 timeout;
 	uint8_t  reserved_2[2];
 
 	/*
@@ -930,9 +930,9 @@ typedef struct {
 	 */
 	uint8_t	 firmware_options[2];
 
-	uint16_t frame_payload_size;
-	uint16_t max_iocb_allocation;
-	uint16_t execution_throttle;
+	__le16 frame_payload_size;
+	__le16 max_iocb_allocation;
+	__le16 execution_throttle;
 	uint8_t	 retry_count;
 	uint8_t	 retry_delay;			/* unused */
 	uint8_t	 port_name[WWN_SIZE];		/* Big endian. */
@@ -1056,7 +1056,7 @@ typedef struct {
 	uint8_t reset_delay;
 	uint8_t port_down_retry_count;
 	uint8_t boot_id_number;
-	uint16_t max_luns_per_target;
+	__le16 max_luns_per_target;
 	uint8_t fcode_boot_port_name[WWN_SIZE];
 	uint8_t alternate_port_name[WWN_SIZE];
 	uint8_t alternate_node_name[WWN_SIZE];
@@ -1145,7 +1145,7 @@ typedef struct {
 } response_t;
 
 typedef union {
-	uint16_t extended;
+	__le16 extended;
 	struct {
 		uint8_t reserved;
 		uint8_t standard;
@@ -1182,7 +1182,7 @@ typedef struct {
 	uint16_t timeout;		/* Command timeout. */
 	uint16_t dseg_count;		/* Data segment count. */
 	uint8_t scsi_cdb[MAX_CMDSZ]; 	/* SCSI command words. */
-	uint32_t byte_count;		/* Total byte count. */
+	__le32 byte_count;		/* Total byte count. */
 	uint32_t dseg_0_address;	/* Data segment 0 address. */
 	uint32_t dseg_0_length;		/* Data segment 0 length. */
 	uint32_t dseg_1_address;	/* Data segment 1 address. */
@@ -1415,23 +1415,23 @@ typedef struct {
 	uint8_t entry_status;		/* Entry Status. */
 	uint32_t handle1;		/* System handle. */
 	target_id_t loop_id;
-	uint16_t status;
-	uint16_t control_flags;		/* Control flags. */
+	__le16 status;
+	__le16 control_flags;		/* Control flags. */
 	uint16_t reserved2;
-	uint16_t timeout;
-	uint16_t cmd_dsd_count;
-	uint16_t total_dsd_count;
+	__le16 timeout;
+	__le16 cmd_dsd_count;
+	__le16 total_dsd_count;
 	uint8_t type;
 	uint8_t r_ctl;
 	uint16_t rx_id;
 	uint16_t reserved3;
 	uint32_t handle2;
-	uint32_t rsp_bytecount;
-	uint32_t req_bytecount;
-	uint32_t dseg_req_address[2];	/* Data segment 0 address. */
-	uint32_t dseg_req_length;	/* Data segment 0 length. */
-	uint32_t dseg_rsp_address[2];	/* Data segment 1 address. */
-	uint32_t dseg_rsp_length;	/* Data segment 1 length. */
+	__le32 rsp_bytecount;
+	__le32 req_bytecount;
+	__le32 dseg_req_address[2];	/* Data segment 0 address. */
+	__le32 dseg_req_length;	/* Data segment 0 length. */
+	__le32 dseg_rsp_address[2];	/* Data segment 1 address. */
+	__le32 dseg_rsp_length;	/* Data segment 1 length. */
 } ms_iocb_entry_t;
 
 
@@ -1686,8 +1686,8 @@ typedef struct fc_port {
 #define FDMI_HBA_MAXIMUM_CT_PAYLOAD_LENGTH	0xb
 
 struct ct_fdmi_hba_attr {
-	uint16_t type;
-	uint16_t len;
+	__be16 type;
+	__be16 len;
 	union {
 		uint8_t node_name[WWN_SIZE];
 		uint8_t manufacturer[32];
@@ -1704,7 +1704,7 @@ struct ct_fdmi_hba_attr {
 };
 
 struct ct_fdmi_hba_attributes {
-	uint32_t count;
+	__be32 count;
 	struct ct_fdmi_hba_attr entry[FDMI_HBA_ATTR_COUNT];
 };
 
@@ -1728,13 +1728,13 @@ struct ct_fdmi_hba_attributes {
 #define FDMI_PORT_SPEED_UNKNOWN		0x8000
 
 struct ct_fdmi_port_attr {
-	uint16_t type;
-	uint16_t len;
+	__be16 type;
+	__be16 len;
 	union {
 		uint8_t fc4_types[32];
-		uint32_t sup_speed;
-		uint32_t cur_speed;
-		uint32_t max_frame_size;
+		__be32 sup_speed;
+		__be32 cur_speed;
+		__be32 max_frame_size;
 		uint8_t os_dev_name[32];
 		uint8_t host_name[32];
 	} a;
@@ -1744,7 +1744,7 @@ struct ct_fdmi_port_attr {
  * Port Attribute Block.
  */
 struct ct_fdmi_port_attributes {
-	uint32_t count;
+	__be32 count;
 	struct ct_fdmi_port_attr entry[FDMI_PORT_ATTR_COUNT];
 };
 
@@ -1784,8 +1784,8 @@ struct ct_cmd_hdr {
 /* CT command request */
 struct ct_sns_req {
 	struct ct_cmd_hdr header;
-	uint16_t command;
-	uint16_t max_rsp_size;
+	__be16 command;
+	__be16 max_rsp_size;
 	uint8_t fragment_id;
 	uint8_t reserved[3];
 
@@ -1835,7 +1835,7 @@ struct ct_sns_req {
 
 		struct {
 			uint8_t hba_identifier[8];
-			uint32_t entry_count;
+			__be32 entry_count;
 			uint8_t port_name[8];
 			struct ct_fdmi_hba_attributes attrs;
 		} rhba;
@@ -1875,7 +1875,7 @@ struct ct_sns_req {
 /* CT command response header */
 struct ct_rsp_hdr {
 	struct ct_cmd_hdr header;
-	uint16_t response;
+	__be16 response;
 	uint16_t residual;
 	uint8_t fragment_id;
 	uint8_t reason_code;
@@ -1938,8 +1938,8 @@ struct ct_sns_rsp {
 		} gfpn_id;
 
 		struct {
-			uint16_t speeds;
-			uint16_t speed;
+			__be16 speeds;
+			__be16 speed;
 		} gpsc;
 	} rsp;
 };
@@ -1981,13 +1981,13 @@ struct ct_sns_pkt {
 struct sns_cmd_pkt {
 	union {
 		struct {
-			uint16_t buffer_length;
+			__le16 buffer_length;
 			uint16_t reserved_1;
-			uint32_t buffer_address[2];
-			uint16_t subcommand_length;
+			__le32 buffer_address[2];
+			__le16 subcommand_length;
 			uint16_t reserved_2;
-			uint16_t subcommand;
-			uint16_t size;
+			__le16 subcommand;
+			__le16 size;
 			uint32_t reserved_3;
 			uint8_t param[36];
 		} cmd;
@@ -2186,9 +2186,9 @@ struct qla_statistics {
 #define QLA_MAX_QUEUES 256
 #define ISP_QUE_REG(ha, id) \
 	((ha->mqenable) ? \
-	((void *)(ha->mqiobase) +\
+	((void __iomem *)(ha->mqiobase) +\
 	(QLA_QUE_PAGE * id)) :\
-	((void *)(ha->iobase)))
+	((void __iomem *)(ha->iobase)))
 #define QLA_REQ_QUE_ID(tag) \
 	((tag < QLA_MAX_QUEUES && tag > 0) ? tag : 0)
 #define QLA_DEFAULT_QUE_QOS 5
@@ -2277,7 +2277,7 @@ struct qla_hw_data {
 
 #define MIN_IOBASE_LEN          0x100
 /* Multi queue data structs */
-	device_reg_t    *mqiobase;
+	device_reg_t __iomem    *mqiobase;
 	uint16_t        msix_count;
 	uint8_t         mqenable;
 	struct req_que **req_q_map;
@@ -2476,7 +2476,7 @@ struct qla_hw_data {
 
 	uint16_t	fw_options[16];         /* slots: 1,2,3,10,11 */
 	uint8_t		fw_seriallink_options[4];
-	uint16_t	fw_seriallink_options24[4];
+	__le16	fw_seriallink_options24[4];
 
 	uint8_t		mpi_version[4];
 	uint32_t	mpi_capabilities;
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index ffff425..b096599 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -272,7 +272,7 @@ struct init_cb_24xx {
 	uint16_t version;
 	uint16_t reserved_1;
 
-	uint16_t frame_payload_size;
+	__le16 frame_payload_size;
 	uint16_t execution_throttle;
 	uint16_t exchange_count;
 
@@ -281,25 +281,25 @@ struct init_cb_24xx {
 	uint8_t port_name[WWN_SIZE];		/* Big endian. */
 	uint8_t node_name[WWN_SIZE];		/* Big endian. */
 
-	uint16_t response_q_inpointer;
-	uint16_t request_q_outpointer;
+	__le16 response_q_inpointer;
+	__le16 request_q_outpointer;
 
 	uint16_t login_retry_count;
 
 	uint16_t prio_request_q_outpointer;
 
-	uint16_t response_q_length;
-	uint16_t request_q_length;
+	__le16 response_q_length;
+	__le16 request_q_length;
 
 	uint16_t link_down_on_nos;		/* Milliseconds. */
 
 	uint16_t prio_request_q_length;
 
-	uint32_t request_q_address[2];
-	uint32_t response_q_address[2];
+	__le32 request_q_address[2];
+	__le32 response_q_address[2];
 	uint32_t prio_request_q_address[2];
 
-	uint16_t msix;
+	__le16 msix;
 	uint8_t reserved_2[6];
 
 	uint16_t atio_q_inpointer;
@@ -349,7 +349,7 @@ struct init_cb_24xx {
 	 * BIT 14 = Enable Target PRLI Control
 	 * BIT 15-31 = Reserved
 	 */
-	uint32_t firmware_options_2;
+	__le32 firmware_options_2;
 
 	/*
 	 * BIT 0  = Reserved
@@ -373,8 +373,8 @@ struct init_cb_24xx {
 	 * BIT 17-31 = Reserved
 	 */
 	uint32_t firmware_options_3;
-	uint16_t qos;
-	uint16_t rid;
+	__le16 qos;
+	__le16 rid;
 	uint8_t  reserved_3[20];
 };
 
@@ -478,7 +478,7 @@ struct sts_entry_24xx {
 
 	uint32_t handle;		/* System handle. */
 
-	uint16_t comp_status;		/* Completion status. */
+	__le16 comp_status;		/* Completion status. */
 	uint16_t ox_id;			/* OX_ID used by the firmware. */
 
 	uint32_t residual_len;		/* FW calc residual transfer length. */
@@ -550,29 +550,29 @@ struct ct_entry_24xx {
 
 	uint32_t handle;		/* System handle. */
 
-	uint16_t comp_status;		/* Completion status. */
+	__le16 comp_status;		/* Completion status. */
 
-	uint16_t nport_handle;		/* N_PORT handle. */
+	__le16 nport_handle;		/* N_PORT handle. */
 
-	uint16_t cmd_dsd_count;
+	__le16 cmd_dsd_count;
 
 	uint8_t vp_index;
 	uint8_t reserved_1;
 
-	uint16_t timeout;		/* Command timeout. */
+	__le16 timeout;		/* Command timeout. */
 	uint16_t reserved_2;
 
-	uint16_t rsp_dsd_count;
+	__le16 rsp_dsd_count;
 
 	uint8_t reserved_3[10];
 
-	uint32_t rsp_byte_count;
-	uint32_t cmd_byte_count;
+	__le32 rsp_byte_count;
+	__le32 cmd_byte_count;
 
-	uint32_t dseg_0_address[2];	/* Data segment 0 address. */
-	uint32_t dseg_0_len;		/* Data segment 0 length. */
-	uint32_t dseg_1_address[2];	/* Data segment 1 address. */
-	uint32_t dseg_1_len;		/* Data segment 1 length. */
+	__le32 dseg_0_address[2];	/* Data segment 0 address. */
+	__le32 dseg_0_len;		/* Data segment 0 length. */
+	__le32 dseg_1_address[2];	/* Data segment 1 address. */
+	__le32 dseg_1_len;		/* Data segment 1 length. */
 };
 
 /*
@@ -652,12 +652,12 @@ struct logio_entry_24xx {
 
 	uint32_t handle;		/* System handle. */
 
-	uint16_t comp_status;		/* Completion status. */
+	__le16 comp_status;		/* Completion status. */
 #define CS_LOGIO_ERROR		0x31	/* Login/Logout IOCB error. */
 
-	uint16_t nport_handle;		/* N_PORT handle. */
+	__le16 nport_handle;		/* N_PORT handle. */
 
-	uint16_t control_flags;		/* Control flags. */
+	__le16 control_flags;		/* Control flags. */
 					/* Modifiers. */
 #define LCF_INCLUDE_SNS		BIT_10	/* Include SNS (FFFFFC) during LOGO. */
 #define LCF_FCP2_OVERRIDE	BIT_9	/* Set/Reset word 3 of PRLI. */
@@ -685,7 +685,7 @@ struct logio_entry_24xx {
 
 	uint8_t rsp_size;		/* Response size in 32bit words. */
 
-	uint32_t io_parameter[11];	/* General I/O parameters. */
+	__le32 io_parameter[11];	/* General I/O parameters. */
 #define LSC_SCODE_NOLINK	0x01
 #define LSC_SCODE_NOIOCB	0x02
 #define LSC_SCODE_NOXCB		0x03
@@ -711,19 +711,19 @@ struct tsk_mgmt_entry {
 	uint8_t handle_count;		/* Handle count. */
 	uint8_t entry_status;		/* Entry Status. */
 
-	uint32_t handle;		/* System handle. */
+	__le32 handle;		/* System handle. */
 
-	uint16_t nport_handle;		/* N_PORT handle. */
+	__le16 nport_handle;		/* N_PORT handle. */
 
 	uint16_t reserved_1;
 
 	uint16_t delay;			/* Activity delay in seconds. */
 
-	uint16_t timeout;		/* Command timeout. */
+	__le16 timeout;		/* Command timeout. */
 
 	struct scsi_lun lun;		/* FCP LUN (BE). */
 
-	uint32_t control_flags;		/* Control Flags. */
+	__le32 control_flags;		/* Control Flags. */
 #define TCF_NOTMCMD_TO_TARGET	BIT_31
 #define TCF_LUN_RESET		BIT_4
 #define TCF_ABORT_TASK_SET	BIT_3
@@ -748,7 +748,7 @@ struct abort_entry_24xx {
 
 	uint32_t handle;		/* System handle. */
 
-	uint16_t nport_handle;		/* N_PORT handle. */
+	__le16 nport_handle;		/* N_PORT handle. */
 					/* or Completion status. */
 
 	uint16_t options;		/* Options. */
@@ -756,7 +756,7 @@ struct abort_entry_24xx {
 
 	uint32_t handle_to_abort;	/* System handle to abort. */
 
-	uint16_t req_que_no;
+	__le16 req_que_no;
 	uint8_t reserved_1[30];
 
 	uint8_t port_id[3];		/* PortID of destination port. */
@@ -1021,8 +1021,8 @@ struct mid_conf_entry_24xx {
 struct mid_init_cb_24xx {
 	struct init_cb_24xx init_cb;
 
-	uint16_t count;
-	uint16_t options;
+	__le16 count;
+	__le16 options;
 
 	struct mid_conf_entry_24xx entries[MAX_MULTI_ID_FABRIC];
 };
@@ -1058,19 +1058,19 @@ struct vp_ctrl_entry_24xx {
 
 	uint16_t vp_idx_failed;
 
-	uint16_t comp_status;		/* Completion status. */
+	__le16 comp_status;		/* Completion status. */
 #define CS_VCE_IOCB_ERROR       0x01    /* Error processing IOCB */
 #define CS_VCE_ACQ_ID_ERROR	0x02	/* Error while acquireing ID. */
 #define CS_VCE_BUSY		0x05	/* Firmware not ready to accept cmd. */
 
-	uint16_t command;
+	__le16 command;
 #define VCE_COMMAND_ENABLE_VPS	0x00	/* Enable VPs. */
 #define VCE_COMMAND_DISABLE_VPS	0x08	/* Disable VPs. */
 #define VCE_COMMAND_DISABLE_VPS_REINIT	0x09 /* Disable VPs and reinit link. */
 #define VCE_COMMAND_DISABLE_VPS_LOGO	0x0a /* Disable VPs and LOGO ports. */
 #define VCE_COMMAND_DISABLE_VPS_LOGO_ALL        0x0b /* Disable VPs and LOGO ports. */
 
-	uint16_t vp_count;
+	__le16 vp_count;
 
 	uint8_t vp_idx_map[16];
 	uint16_t flags;
@@ -1097,7 +1097,7 @@ struct vp_config_entry_24xx {
 #define CS_VF_SET_QOS_OF_VPORTS         BIT_1
 #define CS_VF_SET_HOPS_OF_VPORTS        BIT_2
 
-	uint16_t comp_status;		/* Completion status. */
+	__le16 comp_status;		/* Completion status. */
 #define CS_VCT_STS_ERROR	0x01	/* Specified VPs were not disabled. */
 #define CS_VCT_CNT_ERROR	0x02	/* Invalid VP count. */
 #define CS_VCT_ERROR		0x03	/* Unknown error. */
@@ -1141,7 +1141,7 @@ struct vp_rpt_id_entry_24xx {
 
 	uint16_t vp_count;		/* Format 0 -- | VP setup | VP acq |. */
 					/* Format 1 -- | VP count |. */
-	uint16_t vp_idx;		/* Format 0 -- Reserved. */
+	__le16 vp_idx;		/* Format 0 -- Reserved. */
 					/* Format 1 -- VP status and index. */
 
 	uint8_t port_id[3];
@@ -1188,8 +1188,8 @@ struct qla_fdt_layout {
 	uint16_t checksum;
 	uint8_t unused1[2];
 	uint8_t model[16];
-	uint16_t man_id;
-	uint16_t id;
+	__le16 man_id;
+	__le16 id;
 	uint8_t flags;
 	uint8_t erase_cmd;
 	uint8_t alt_erase_cmd;
@@ -1198,7 +1198,7 @@ struct qla_fdt_layout {
 	uint8_t wrt_sts_reg_cmd;
 	uint8_t unprotect_sec_cmd;
 	uint8_t read_man_id_cmd;
-	uint32_t block_size;
+	__le32 block_size;
 	uint32_t alt_block_size;
 	uint32_t flash_size;
 	uint32_t wrt_enable_data;
@@ -1223,9 +1223,9 @@ struct qla_flt_location {
 };
 
 struct qla_flt_header {
-	uint16_t version;
-	uint16_t length;
-	uint16_t checksum;
+	__le16 version;
+	__le16 length;
+	__le16 checksum;
 	uint16_t unused;
 };
 
@@ -1253,10 +1253,10 @@ struct qla_flt_region {
 
 struct qla_npiv_header {
 	uint8_t sig[2];
-	uint16_t version;
-	uint16_t entries;
+	__le16 version;
+	__le16 entries;
 	uint16_t unused[4];
-	uint16_t checksum;
+	__le16 checksum;
 };
 
 struct qla_npiv_entry {
@@ -1294,7 +1294,7 @@ struct verify_chip_entry_84xx {
 
 	uint32_t handle;
 
-	uint16_t options;
+	__le16 options;
 #define VCO_DONT_UPDATE_FW	BIT_0
 #define VCO_FORCE_UPDATE	BIT_1
 #define VCO_DONT_RESET_UPDATE	BIT_2
@@ -1327,19 +1327,19 @@ struct verify_chip_rsp_84xx {
 
 	uint32_t handle;
 
-	uint16_t comp_status;
+	__le16 comp_status;
 #define CS_VCS_CHIP_FAILURE	0x3
 #define CS_VCS_BAD_EXCHANGE	0x8
 #define CS_VCS_SEQ_COMPLETEi	0x40
 
-	uint16_t failure_code;
+	__le16 failure_code;
 #define VFC_CHECKSUM_ERROR	0x1
 #define VFC_INVALID_LEN		0x2
 #define VFC_ALREADY_IN_PROGRESS	0x8
 
 	uint16_t reserved_1[4];
 
-	uint32_t fw_ver;
+	__le32 fw_ver;
 	uint32_t exchange_address;
 
 	uint32_t reserved_2[6];
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 8df3d04..9c1a2bf 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -164,8 +164,7 @@ void qla2x00_build_scsi_iocbs_32(srb_t *sp, cmd_entry_t *cmd_pkt,
 	cmd = sp->cmd;
 
 	/* Update entry type to indicate Command Type 2 IOCB */
-	*((uint32_t *)(&cmd_pkt->entry_type)) =
-	    cpu_to_le32(COMMAND_TYPE);
+	*((__le32 *)(&cmd_pkt->entry_type)) = cpu_to_le32(COMMAND_TYPE);
 
 	/* No data transfer */
 	if (!scsi_bufflen(cmd) || cmd->sc_data_direction == DMA_NONE) {
@@ -636,7 +635,7 @@ qla24xx_build_scsi_iocbs(srb_t *sp, struct cmd_type_7 *cmd_pkt,
     uint16_t tot_dsds)
 {
 	uint16_t	avail_dsds;
-	uint32_t	*cur_dsd;
+	__le32	*cur_dsd;
 	scsi_qla_host_t	*vha;
 	struct scsi_cmnd *cmd;
 	struct scatterlist *sg;
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index c82c62c..1f4f89c 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -239,7 +239,7 @@ qla2x00_write_nvram_word(struct qla_hw_data *ha, uint32_t addr, uint16_t data)
 
 static int
 qla2x00_write_nvram_word_tmo(struct qla_hw_data *ha, uint32_t addr,
-	uint16_t data, uint32_t tmo)
+	__le16 data, uint32_t tmo)
 {
 	int ret, count;
 	uint16_t word;
@@ -306,7 +306,7 @@ qla2x00_clear_nvram_protection(struct qla_hw_data *ha)
 	int ret, stat;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 	uint32_t word, wait_cnt;
-	uint16_t wprot, wprot_old;
+	__le16 wprot, wprot_old;
 
 	/* Clear NVRAM write protection. */
 	ret = QLA_FUNCTION_FAILED;
@@ -545,7 +545,8 @@ qla2xxx_find_flt_start(scsi_qla_host_t *vha, uint32_t *start)
 	uint32_t pcihdr, pcids;
 	uint32_t *dcode;
 	uint8_t *buf, *bcode, last_image;
-	uint16_t cnt, chksum, *wptr;
+	uint16_t cnt, chksum;
+	__le16 *wptr;
 	struct qla_flt_location *fltl;
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req = ha->req_q_map[0];
@@ -639,7 +640,7 @@ qla2xxx_get_flt_info(scsi_qla_host_t *vha, uint32_t flt_addr)
 		{ FA_NPIV_CONF1_ADDR_24, FA_NPIV_CONF1_ADDR,
 			FA_NPIV_CONF1_ADDR_81 };
 	uint32_t def;
-	uint16_t *wptr;
+	__le16 *wptr;
 	uint16_t cnt, chksum;
 	uint32_t start;
 	struct qla_flt_header *flt;
@@ -648,7 +649,7 @@ qla2xxx_get_flt_info(scsi_qla_host_t *vha, uint32_t flt_addr)
 	struct req_que *req = ha->req_q_map[0];
 
 	ha->flt_region_flt = flt_addr;
-	wptr = (uint16_t *)req->ring;
+	wptr = (__le16 *)req->ring;
 	flt = (struct qla_flt_header *)req->ring;
 	region = (struct qla_flt_region *)&flt[1];
 	ha->isp_ops->read_optrom(vha, (uint8_t *)req->ring,
@@ -740,14 +741,14 @@ qla2xxx_get_fdt_info(scsi_qla_host_t *vha)
 #define FLASH_BLK_SIZE_64K	0x10000
 	const char *loc, *locations[] = { "MID", "FDT" };
 	uint16_t cnt, chksum;
-	uint16_t *wptr;
+	__le16 *wptr;
 	struct qla_fdt_layout *fdt;
 	uint8_t	man_id, flash_id;
 	uint16_t mid, fid;
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req = ha->req_q_map[0];
 
-	wptr = (uint16_t *)req->ring;
+	wptr = (__le16 *)req->ring;
 	fdt = (struct qla_fdt_layout *)req->ring;
 	ha->isp_ops->read_optrom(vha, (uint8_t *)req->ring,
 	    ha->flt_region_fdt << 2, OPTROM_BURST_SIZE);
-- 
1.6.2.rc1.175.g96b8a



