From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/2] stex: stex_direct_copy shouldn't call dma_map_sg
Date: Fri, 22 Feb 2008 23:11:03 +0900
Message-ID: <1203689464-24591-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:43136 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311AbYBVOMD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Feb 2008 09:12:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Ed Lin <ed.lin@promise.com>, James Bottomley <James.Bottomley@SteelEye.com>

stex_direct_copy copies an in-kernel buffer to a sg list in order to
spoof some SCSI commands. stex_direct_copy calls dma_map_sg and then
stex_internal_copy with the value that dma_map_sg returned. It calls
scsi_kmap_atomic_sg to copy data.

scsi_kmap_atomic_sg doesn't see sg->dma_length so if dma_map_sg merges
sg entries, stex_internal_copy gets the smaller number of sg entries
than the acutual number, which means it wrongly think that the data
length in the sg list is shorter than the actual length.

stex_direct_copy shouldn't call dma_map_sg and it doesn't need since
this code path doesn't involve dma transfers. This patch removes
stex_direct_copy and simply calls stex_internal_copy with the actual
number of sg entries.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Ed Lin <ed.lin@promise.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>
---
 drivers/scsi/stex.c |   34 ++++++++++++----------------------
 1 files changed, 12 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 72f6d80..4b6861c 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -461,23 +461,6 @@ static void stex_internal_copy(struct scsi_cmnd *cmd,
 	}
 }
 
-static int stex_direct_copy(struct scsi_cmnd *cmd,
-	const void *src, size_t count)
-{
-	size_t cp_len = count;
-	int n_elem = 0;
-
-	n_elem = scsi_dma_map(cmd);
-	if (n_elem < 0)
-		return 0;
-
-	stex_internal_copy(cmd, src, &cp_len, n_elem, ST_TO_CMD);
-
-	scsi_dma_unmap(cmd);
-
-	return cp_len == count;
-}
-
 static void stex_controller_info(struct st_hba *hba, struct st_ccb *ccb)
 {
 	struct st_frame *p;
@@ -569,8 +552,10 @@ stex_queuecommand(struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd *))
 		unsigned char page;
 		page = cmd->cmnd[2] & 0x3f;
 		if (page == 0x8 || page == 0x3f) {
-			stex_direct_copy(cmd, ms10_caching_page,
-					sizeof(ms10_caching_page));
+			size_t cp_len = sizeof(ms10_caching_page);
+			stex_internal_copy(cmd, ms10_caching_page,
+					   &cp_len, scsi_sg_count(cmd),
+					   ST_TO_CMD);
 			cmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
 			done(cmd);
 		} else
@@ -599,8 +584,10 @@ stex_queuecommand(struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd *))
 		if (id != host->max_id - 1)
 			break;
 		if (lun == 0 && (cmd->cmnd[1] & INQUIRY_EVPD) == 0) {
-			stex_direct_copy(cmd, console_inq_page,
-				sizeof(console_inq_page));
+			size_t cp_len = sizeof(console_inq_page);
+			stex_internal_copy(cmd, console_inq_page,
+					   &cp_len, scsi_sg_count(cmd),
+					   ST_TO_CMD);
 			cmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
 			done(cmd);
 		} else
@@ -609,6 +596,7 @@ stex_queuecommand(struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd *))
 	case PASSTHRU_CMD:
 		if (cmd->cmnd[1] == PASSTHRU_GET_DRVVER) {
 			struct st_drvver ver;
+			size_t cp_len = sizeof(ver);
 			ver.major = ST_VER_MAJOR;
 			ver.minor = ST_VER_MINOR;
 			ver.oem = ST_OEM;
@@ -616,7 +604,9 @@ stex_queuecommand(struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd *))
 			ver.signature[0] = PASSTHRU_SIGNATURE;
 			ver.console_id = host->max_id - 1;
 			ver.host_no = hba->host->host_no;
-			cmd->result = stex_direct_copy(cmd, &ver, sizeof(ver)) ?
+			stex_internal_copy(cmd, &ver, &cp_len,
+					   scsi_sg_count(cmd), ST_TO_CMD);
+			cmd->result = sizeof(ver) == cp_len ?
 				DID_OK << 16 | COMMAND_COMPLETE << 8 :
 				DID_ERROR << 16 | COMMAND_COMPLETE << 8;
 			done(cmd);
-- 
1.5.3.4

