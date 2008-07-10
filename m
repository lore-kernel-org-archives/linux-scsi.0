From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 05/18] qla2xxx: Add LIP count to FC-transport statistics.
Date: Thu, 10 Jul 2008 16:55:50 -0700
Message-ID: <1215734163-40825-5-git-send-email-andrew.vasquez@qlogic.com>
References: <20080710235458.GQ29099@plap4-2.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:45262 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757186AbYGJX4V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jul 2008 19:56:21 -0400
In-Reply-To: <20080710235458.GQ29099@plap4-2.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Harish Zunjarrao <harish.zunjarrao@qlogic.com>

From: Harish Zunjarrao <harish.zunjarrao@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    1 +
 drivers/scsi/qla2xxx/qla_def.h  |    3 ++-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 5538fa9..5d6dd95 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1046,6 +1046,7 @@ qla2x00_get_fc_host_stats(struct Scsi_Host *shost)
 	pfc_host_stat->invalid_tx_word_count = stats->inval_xmit_word_cnt;
 	pfc_host_stat->invalid_crc_count = stats->inval_crc_cnt;
 	if (IS_FWI2_CAPABLE(ha)) {
+		pfc_host_stat->lip_count = stats->lip_cnt;
 		pfc_host_stat->tx_frames = stats->tx_frames;
 		pfc_host_stat->rx_frames = stats->rx_frames;
 		pfc_host_stat->dumped_frames = stats->dumped_frames;
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index fe1eada..2b1bc57 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -864,7 +864,8 @@ struct link_statistics {
 	uint32_t prim_seq_err_cnt;
 	uint32_t inval_xmit_word_cnt;
 	uint32_t inval_crc_cnt;
-	uint32_t unused1[0x1b];
+	uint32_t lip_cnt;
+	uint32_t unused1[0x1a];
 	uint32_t tx_frames;
 	uint32_t rx_frames;
 	uint32_t dumped_frames;
-- 
1.5.6.2.292.ga9a3

