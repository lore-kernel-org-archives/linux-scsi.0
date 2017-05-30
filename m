From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 04/17] qla2xxx: Include Exchange offload/Extended Login into FW dump
Date: Tue, 30 May 2017 10:54:19 -0700
Message-ID: <20170530175432.26984-5-himanshu.madhani@cavium.com>
References: <20170530175432.26984-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0085.outbound.protection.outlook.com ([104.47.38.85]:31328
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751002AbdE3Ryz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 May 2017 13:54:55 -0400
In-Reply-To: <20170530175432.26984-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Add missing memory dump of Exchange Offload and Extended
login into FW dump.

Cc: <stable@vger.kernel.org>
Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c  | 51 +++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_dbg.h  | 12 ++++++++++
 drivers/scsi/qla2xxx/qla_init.c |  7 ++++++
 drivers/scsi/qla2xxx/qla_os.c   |  3 ---
 4 files changed, 70 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 88748a6ab73f..108499837e5d 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -498,6 +498,52 @@ qla25xx_copy_fce(struct qla_hw_data *ha, void *ptr, uint32_t **last_chain)
 }
 
 static inline void *
+qla25xx_copy_exlogin(struct qla_hw_data *ha, void *ptr, uint32_t **last_chain)
+{
+	struct qla2xxx_offld_chain *c = ptr;
+
+	if (!ha->exlogin_buf)
+		return ptr;
+
+	*last_chain = &c->type;
+
+	c->type = htonl(DUMP_CHAIN_EXLOGIN);
+	c->chain_size = htonl(sizeof(struct qla2xxx_offld_chain) +
+	    ha->exlogin_size);
+	c->size = htonl(ha->exlogin_size);
+	c->addr_l = htonl(LSD(ha->exlogin_buf_dma));
+	c->addr_h = htonl(MSD(ha->exlogin_buf_dma));
+
+	ptr += sizeof(struct qla2xxx_offld_chain);
+	memcpy(ptr, ha->exlogin_buf, ha->exlogin_size);
+
+	return (char *)ptr + ntohl(c->size);
+}
+
+static inline void *
+qla81xx_copy_exchoffld(struct qla_hw_data *ha, void *ptr, uint32_t **last_chain)
+{
+	struct qla2xxx_offld_chain *c = ptr;
+
+	if (!ha->exchoffld_buf)
+		return ptr;
+
+	*last_chain = &c->type;
+
+	c->type = htonl(DUMP_CHAIN_EXCHG);
+	c->chain_size = htonl(sizeof(struct qla2xxx_offld_chain) +
+	    ha->exchoffld_size);
+	c->size = htonl(ha->exchoffld_size);
+	c->addr_l = htonl(LSD(ha->exchoffld_buf_dma));
+	c->addr_h = htonl(MSD(ha->exchoffld_buf_dma));
+
+	ptr += sizeof(struct qla2xxx_offld_chain);
+	memcpy(ptr, ha->exchoffld_buf, ha->exchoffld_size);
+
+	return (char *)ptr + ntohl(c->size);
+}
+
+static inline void *
 qla2xxx_copy_atioqueues(struct qla_hw_data *ha, void *ptr,
 	uint32_t **last_chain)
 {
@@ -1606,6 +1652,7 @@ qla25xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	nxt_chain = qla25xx_copy_fce(ha, nxt_chain, &last_chain);
 	nxt_chain = qla25xx_copy_mqueues(ha, nxt_chain, &last_chain);
 	nxt_chain = qla2xxx_copy_atioqueues(ha, nxt_chain, &last_chain);
+	nxt_chain = qla25xx_copy_exlogin(ha, nxt_chain, &last_chain);
 	if (last_chain) {
 		ha->fw_dump->version |= htonl(DUMP_CHAIN_VARIANT);
 		*last_chain |= htonl(DUMP_CHAIN_LAST);
@@ -1932,6 +1979,8 @@ qla81xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	nxt_chain = qla25xx_copy_fce(ha, nxt_chain, &last_chain);
 	nxt_chain = qla25xx_copy_mqueues(ha, nxt_chain, &last_chain);
 	nxt_chain = qla2xxx_copy_atioqueues(ha, nxt_chain, &last_chain);
+	nxt_chain = qla25xx_copy_exlogin(ha, nxt_chain, &last_chain);
+	nxt_chain = qla81xx_copy_exchoffld(ha, nxt_chain, &last_chain);
 	if (last_chain) {
 		ha->fw_dump->version |= htonl(DUMP_CHAIN_VARIANT);
 		*last_chain |= htonl(DUMP_CHAIN_LAST);
@@ -2443,6 +2492,8 @@ qla83xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	nxt_chain = qla25xx_copy_fce(ha, nxt_chain, &last_chain);
 	nxt_chain = qla25xx_copy_mqueues(ha, nxt_chain, &last_chain);
 	nxt_chain = qla2xxx_copy_atioqueues(ha, nxt_chain, &last_chain);
+	nxt_chain = qla25xx_copy_exlogin(ha, nxt_chain, &last_chain);
+	nxt_chain = qla81xx_copy_exchoffld(ha, nxt_chain, &last_chain);
 	if (last_chain) {
 		ha->fw_dump->version |= htonl(DUMP_CHAIN_VARIANT);
 		*last_chain |= htonl(DUMP_CHAIN_LAST);
diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
index c6bffe929fe7..c4b1bb76cf48 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.h
+++ b/drivers/scsi/qla2xxx/qla_dbg.h
@@ -232,6 +232,16 @@ struct qla2xxx_fce_chain {
 	uint32_t eregs[8];
 };
 
+/* used by exchange off load and extended login offload */
+struct qla2xxx_offld_chain {
+	uint32_t type;
+	uint32_t chain_size;
+
+	uint32_t size;
+	uint32_t addr_l;
+	uint32_t addr_h;
+};
+
 struct qla2xxx_mq_chain {
 	uint32_t type;
 	uint32_t chain_size;
@@ -258,6 +268,8 @@ struct qla2xxx_mqueue_chain {
 #define DUMP_CHAIN_FCE		0x7FFFFAF0
 #define DUMP_CHAIN_MQ		0x7FFFFAF1
 #define DUMP_CHAIN_QUEUE	0x7FFFFAF2
+#define DUMP_CHAIN_EXLOGIN	0x7FFFFAF3
+#define DUMP_CHAIN_EXCHG	0x7FFFFAF4
 #define DUMP_CHAIN_LAST		0x80000000
 
 struct qla2xxx_fw_dump {
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index e4876f4220e4..2d23885083b0 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2524,6 +2524,13 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 	ha->chain_offset = dump_size;
 	dump_size += mq_size + fce_size;
 
+	if (ha->exchoffld_buf)
+		dump_size += sizeof(struct qla2xxx_offld_chain) +
+			ha->exchoffld_size;
+	if (ha->exlogin_buf)
+		dump_size += sizeof(struct qla2xxx_offld_chain) +
+			ha->exlogin_size;
+
 allocate:
 	ha->fw_dump = vmalloc(dump_size);
 	if (!ha->fw_dump) {
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index c8282a1ab6dc..e437122bd534 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4048,9 +4048,6 @@ qla2x00_set_exchoffld_buffer(scsi_qla_host_t *vha)
 	if (!ql2xexchoffld)
 		return QLA_SUCCESS;
 
-	ql_log(ql_log_info, vha, 0xd014,
-	    "Exchange offload count: %d.\n", ql2xexlogins);
-
 	max_cnt = 0;
 	rval = qla_get_exchoffld_status(vha, &size, &max_cnt);
 	if (rval != QLA_SUCCESS) {
-- 
2.12.0
