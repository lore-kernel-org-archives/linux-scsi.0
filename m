From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH] iscsi: Fix some debug printf types
Date: Mon, 12 Jan 2009 17:30:34 +0200
Message-ID: <496B621A.6000300@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:8786 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750952AbZALPal (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jan 2009 10:30:41 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi@googlegroups.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>


A couple of prints at lib/iscsi_tcp had the %Z missing from the
kprint format string. Just to show that debug_prints are not enabled
much.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/iscsi_tcp.c    |    2 +-
 drivers/scsi/libiscsi_tcp.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 23808df..a566aa9 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -415,7 +415,7 @@ iscsi_sw_tcp_send_linear_data_prep(struct iscsi_conn *conn, void *data,
 	struct hash_desc *tx_hash = NULL;
 	unsigned int hdr_spec_len;
 
-	debug_tcp("%s(%p, datalen=%d%s)\n", __func__, tcp_conn, len,
+	debug_tcp("%s(%p, datalen=%Zd%s)\n", __func__, tcp_conn, len,
 		  conn->datadgst_en? ", digest enabled" : "");
 
 	/* Make sure the datalen matches what the caller
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index a745f91..12354c5 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -356,7 +356,7 @@ iscsi_segment_seek_sg(struct iscsi_segment *segment,
 	struct scatterlist *sg;
 	unsigned int i;
 
-	debug_scsi("iscsi_segment_seek_sg offset %u size %llu\n",
+	debug_scsi("iscsi_segment_seek_sg offset %u size %Zu\n",
 		  offset, size);
 	__iscsi_segment_init(segment, size, done, hash);
 	for_each_sg(sg_list, sg, sg_count, i) {
-- 
1.6.0.1

