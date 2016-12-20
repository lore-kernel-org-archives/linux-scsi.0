From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 07/10] qla2xxx: Terminate exchange if corrputed.
Date: Mon, 19 Dec 2016 20:33:41 -0800
Message-ID: <1482208424-12358-8-git-send-email-himanshu.madhani@cavium.com>
References: <1482208424-12358-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1482208424-12358-1-git-send-email-himanshu.madhani@cavium.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, bart.vanassche@gmail.com, hch@infradead.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com
List-Id: linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Corrupted ATIO is defined as length of fcp_header & fcp_cmd
payload is less than 0x38. It's the minimum size for a frame to
carry 8..16 bytes SCSI CDB. The exchange will be dropped or
terminated if corrupted.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_def.h    |  3 ++-
 drivers/scsi/qla2xxx/qla_target.c | 22 +++++++++++++++++++---
 drivers/scsi/qla2xxx/qla_target.h | 17 ++++++++++++++++-
 3 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index f7df01b..b14455e 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1556,7 +1556,8 @@ struct link_statistics {
 struct atio {
 	uint8_t		entry_type;		/* Entry type. */
 	uint8_t		entry_count;		/* Entry count. */
-	uint8_t		data[58];
+	uint16_t	attr_n_length;
+	uint8_t		data[56];
 	uint32_t	signature;
 #define ATIO_PROCESSED 0xDEADDEAD		/* Signature */
 };
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 5037b51..7ae179a 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -6451,12 +6451,28 @@ static void qlt_disable_vha(struct scsi_qla_host *vha)
 	if (!vha->flags.online)
 		return;
 
-	while (ha->tgt.atio_ring_ptr->signature != ATIO_PROCESSED) {
+	while ((ha->tgt.atio_ring_ptr->signature != ATIO_PROCESSED) ||
+		   FCPCMD_IS_CORRUPTED(ha->tgt.atio_ring_ptr)) {
 		pkt = (struct atio_from_isp *)ha->tgt.atio_ring_ptr;
 		cnt = pkt->u.raw.entry_count;
 
-		qlt_24xx_atio_pkt_all_vps(vha, (struct atio_from_isp *)pkt,
-		    ha_locked);
+		if (unlikely(FCPCMD_IS_CORRUPTED(ha->tgt.atio_ring_ptr))) {
+			/* This packet is corrupted.  The header + payload
+			 * can not be trusted.  There is no point in passing
+			 * it further up.
+			 */
+			ql_log(ql_log_warn, vha, 0xffff,
+			    "corrupted fcp frame SID[%3phN] OXID[%04x] EXCG[%x] %64phN\n",
+			    pkt->u.isp24.fcp_hdr.s_id,
+			    be16_to_cpu(pkt->u.isp24.fcp_hdr.ox_id),
+			    le32_to_cpu(pkt->u.isp24.exchange_addr), pkt);
+
+			ADJ_CORRUPTED_ATIO(pkt);
+			qlt_send_term_exchange(vha, NULL, pkt, ha_locked, 0);
+		} else {
+			qlt_24xx_atio_pkt_all_vps(vha,
+			    (struct atio_from_isp *)pkt, ha_locked);
+		}
 
 		for (i = 0; i < cnt; i++) {
 			ha->tgt.atio_ring_index++;
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index f26c5f6..15359f0 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -427,13 +427,28 @@ struct atio_from_isp {
 		struct {
 			uint8_t  entry_type;	/* Entry type. */
 			uint8_t  entry_count;	/* Entry count. */
-			uint8_t  data[58];
+			uint16_t attr_n_length;
+#define FCP_CMD_LENTH_MASK 0x0fff
+#define FCP_CMD_LENTH_MIN  0x38
+			uint8_t  data[56];
 			uint32_t signature;
 #define ATIO_PROCESSED 0xDEADDEAD		/* Signature */
 		} raw;
 	} u;
 } __packed;
 
+#define FCPCMD_IS_CORRUPTED(_a)						\
+	((_a->entry_type == ATIO_TYPE7) && 				\
+	 ((le16_to_cpu(_a->attr_n_length) & FCP_CMD_LENTH_MASK) < 	\
+	  FCP_CMD_LENTH_MIN))
+
+/* adjust corrupted atio so we won't trip over the same entry again. */
+#define ADJ_CORRUPTED_ATIO(_a)						\
+{									\
+	_a->u.raw.attr_n_length = cpu_to_le16(FCP_CMD_LENTH_MIN);	\
+	((struct atio_from_isp *)_a)->u.isp24.fcp_cmnd.add_cdb_len = 0;	\
+}
+
 #define CTIO_TYPE7 0x12 /* Continue target I/O entry (for 24xx) */
 
 /*
-- 
1.8.3.1
