From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 6/8] bnx2fc: Tx/Rx byte counts reset to 0 when exceeding
 32 bit values
Date: Fri, 21 Dec 2012 19:40:32 -0800
Message-ID: <1356147634-17252-7-git-send-email-bprakash@broadcom.com>
References: <1356147634-17252-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2974 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751769Ab2LVDkn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Dec 2012 22:40:43 -0500
In-Reply-To: <1356147634-17252-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

Since the FW counters are 32-bit, accumulate the stats in the driver.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc.h      |   22 ++++++++++++++++++++++
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |   17 ++++++++++++-----
 2 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index 6c9e717..6bbc0c1 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -156,6 +156,18 @@
 #define BNX2FC_RELOGIN_WAIT_TIME	200
 #define BNX2FC_RELOGIN_WAIT_CNT		10
 
+#define BNX2FC_STATS(hba, stat, cnt)					\
+	do {								\
+		u32 val;						\
+									\
+		val = fw_stats->stat.cnt;				\
+		if (hba->prev_stats.stat.cnt <= val)			\
+			val -= hba->prev_stats.stat.cnt;		\
+		else							\
+			val += (0xfffffff - hba->prev_stats.stat.cnt);	\
+		hba->bfw_stats.cnt += val;				\
+	} while (0);
+
 /* bnx2fc driver uses only one instance of fcoe_percpu_s */
 extern struct fcoe_percpu_s bnx2fc_global;
 
@@ -167,6 +179,14 @@ struct bnx2fc_percpu_s {
 	spinlock_t fp_work_lock;
 };
 
+struct bnx2fc_fw_stats {
+	u64	fc_crc_cnt;
+	u64	fcoe_tx_pkt_cnt;
+	u64	fcoe_rx_pkt_cnt;
+	u64	fcoe_tx_byte_cnt;
+	u64	fcoe_rx_byte_cnt;
+};
+
 struct bnx2fc_hba {
 	struct list_head list;
 	struct cnic_dev *cnic;
@@ -207,6 +227,8 @@ struct bnx2fc_hba {
 	struct bnx2fc_rport **tgt_ofld_list;
 
 	/* statistics */
+	struct bnx2fc_fw_stats bfw_stats;
+	struct fcoe_statistics_params prev_stats;
 	struct fcoe_statistics_params *stats_buffer;
 	dma_addr_t stats_buf_dma;
 	struct completion stat_req_done;
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index e055865..e021e43 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -687,11 +687,16 @@ static struct fc_host_statistics *bnx2fc_get_host_stats(struct Scsi_Host *shost)
 		BNX2FC_HBA_DBG(lport, "FW stat req timed out\n");
 		return bnx2fc_stats;
 	}
-	bnx2fc_stats->invalid_crc_count += fw_stats->rx_stat2.fc_crc_cnt;
-	bnx2fc_stats->tx_frames += fw_stats->tx_stat.fcoe_tx_pkt_cnt;
-	bnx2fc_stats->tx_words += (fw_stats->tx_stat.fcoe_tx_byte_cnt) / 4;
-	bnx2fc_stats->rx_frames += fw_stats->rx_stat0.fcoe_rx_pkt_cnt;
-	bnx2fc_stats->rx_words += (fw_stats->rx_stat0.fcoe_rx_byte_cnt) / 4;
+	BNX2FC_STATS(hba, rx_stat2, fc_crc_cnt);
+	bnx2fc_stats->invalid_crc_count += hba->bfw_stats.fc_crc_cnt;
+	BNX2FC_STATS(hba, tx_stat, fcoe_tx_pkt_cnt);
+	bnx2fc_stats->tx_frames += hba->bfw_stats.fcoe_tx_pkt_cnt;
+	BNX2FC_STATS(hba, tx_stat, fcoe_tx_byte_cnt);
+	bnx2fc_stats->tx_words += ((hba->bfw_stats.fcoe_tx_byte_cnt) / 4);
+	BNX2FC_STATS(hba, rx_stat0, fcoe_rx_pkt_cnt);
+	bnx2fc_stats->rx_frames += hba->bfw_stats.fcoe_rx_pkt_cnt;
+	BNX2FC_STATS(hba, rx_stat0, fcoe_rx_byte_cnt);
+	bnx2fc_stats->rx_words += ((hba->bfw_stats.fcoe_rx_byte_cnt) / 4);
 
 	bnx2fc_stats->dumped_frames = 0;
 	bnx2fc_stats->lip_count = 0;
@@ -700,6 +705,8 @@ static struct fc_host_statistics *bnx2fc_get_host_stats(struct Scsi_Host *shost)
 	bnx2fc_stats->loss_of_signal_count = 0;
 	bnx2fc_stats->prim_seq_protocol_err_count = 0;
 
+	memcpy(&hba->prev_stats, hba->stats_buffer,
+	       sizeof(struct fcoe_statistics_params));
 	return bnx2fc_stats;
 }
 
-- 
1.7.0.6


