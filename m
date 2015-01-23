From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 11/17] 3w-9xxx: Remove dead code
Date: Fri, 23 Jan 2015 13:11:55 +0100
Message-ID: <54C23A8B.4040002@sandisk.com>
References: <54C2390A.3000700@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0092.outbound.protection.outlook.com ([157.56.110.92]:54528
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751941AbbAWMMC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jan 2015 07:12:02 -0500
In-Reply-To: <54C2390A.3000700@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Adam Radford <linuxraid@lsi.com>

The SCSI core never sets sc_data_direction to DMA_BIDIRECTIONAL.
Hence remove the code that tests for this value.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Adam Radford <linuxraid@lsi.com>
---
 drivers/scsi/3w-9xxx.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index cd4129f..e83e3b7 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -1854,8 +1854,7 @@ static int twa_scsiop_execute_scsi(TW_Device_Extension *tw_dev, int request_id,
 		if (scsi_sg_count(srb)) {
 			if ((scsi_sg_count(srb) == 1) &&
 			    (scsi_bufflen(srb) < TW_MIN_SGL_LENGTH)) {
-				if (srb->sc_data_direction == DMA_TO_DEVICE ||
-				    srb->sc_data_direction == DMA_BIDIRECTIONAL)
+				if (srb->sc_data_direction == DMA_TO_DEVICE)
 					scsi_sg_copy_to_buffer(srb,
 							       tw_dev->generic_buffer_virt[request_id],
 							       TW_SECTOR_SIZE);
@@ -1927,8 +1926,7 @@ static void twa_scsiop_execute_scsi_complete(TW_Device_Extension *tw_dev, int re
 	struct scsi_cmnd *cmd = tw_dev->srb[request_id];
 
 	if (scsi_bufflen(cmd) < TW_MIN_SGL_LENGTH &&
-	    (cmd->sc_data_direction == DMA_FROM_DEVICE ||
-	     cmd->sc_data_direction == DMA_BIDIRECTIONAL)) {
+	    cmd->sc_data_direction == DMA_FROM_DEVICE) {
 		if (scsi_sg_count(cmd) == 1) {
 			void *buf = tw_dev->generic_buffer_virt[request_id];
 
-- 
2.1.2

