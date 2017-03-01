From: Satish Kharat <satishkh@cisco.com>
Subject: [PATCH 1/1] fnic: minor cleanup in fnic_fcpio_itmf_cmpl_handler, removing else case
Date: Tue, 28 Feb 2017 16:14:33 -0800
Message-ID: <1488327273-8641-1-git-send-email-satishkh@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcdn-iport-9.cisco.com ([173.37.86.80]:55605 "EHLO
        rcdn-iport-9.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751778AbdCADaL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Feb 2017 22:30:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: satishkh@cisco.com, sebaddel@cisco.com

Getting rid of else case to make the flow look bit more simpler
logical

Signed-off-by: Satish Kharat <satishkh@cisco.com>
Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
---
 drivers/scsi/fnic/fnic_scsi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 2544a37..df443a9 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -1128,12 +1128,11 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fnic *fnic,
 		}
 
 		CMD_FLAGS(sc) |= FNIC_IO_ABT_TERM_DONE;
+		CMD_ABTS_STATUS(sc) = hdr_status;
 
 		/* If the status is IO not found consider it as success */
 		if (hdr_status == FCPIO_IO_NOT_FOUND)
 			CMD_ABTS_STATUS(sc) = FCPIO_SUCCESS;
-		else
-			CMD_ABTS_STATUS(sc) = hdr_status;
 
 		atomic64_dec(&fnic_stats->io_stats.active_ios);
 		if (atomic64_read(&fnic->io_cmpl_skip))
-- 
2.5.5
