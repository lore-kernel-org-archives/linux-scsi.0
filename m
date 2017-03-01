From: Satish Kharat <satishkh@cisco.com>
Subject: [PATCH 1/1] fnic: Fix for "Number of Active IOs" in fnicstats becoming negative
Date: Tue, 28 Feb 2017 16:14:56 -0800
Message-ID: <1488327296-8695-1-git-send-email-satishkh@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alln-iport-4.cisco.com ([173.37.142.91]:56683 "EHLO
        alln-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751373AbdCADZB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Feb 2017 22:25:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: satishkh@cisco.com, sebaddel@cisco.com

Fixing the IO stats updation (Active IOs and IO completion) to
fix "Number of Active IOs" becoming negative in the fnistats
output.

Signed-off-by: Satish Kharat <satishkh@cisco.com>
Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
---
 drivers/scsi/fnic/fnic_scsi.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 2544a37..ec820cb 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -1135,11 +1135,6 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fnic *fnic,
 		else
 			CMD_ABTS_STATUS(sc) = hdr_status;
 
-		atomic64_dec(&fnic_stats->io_stats.active_ios);
-		if (atomic64_read(&fnic->io_cmpl_skip))
-			atomic64_dec(&fnic->io_cmpl_skip);
-		else
-			atomic64_inc(&fnic_stats->io_stats.io_completions);
 
 		if (!(CMD_FLAGS(sc) & (FNIC_IO_ABORTED | FNIC_IO_DONE)))
 			atomic64_inc(&misc_stats->no_icmnd_itmf_cmpls);
@@ -1181,6 +1176,11 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fnic *fnic,
 					(((u64)CMD_FLAGS(sc) << 32) |
 					CMD_STATE(sc)));
 				sc->scsi_done(sc);
+				atomic64_dec(&fnic_stats->io_stats.active_ios);
+				if (atomic64_read(&fnic->io_cmpl_skip))
+					atomic64_dec(&fnic->io_cmpl_skip);
+				else
+					atomic64_inc(&fnic_stats->io_stats.io_completions);
 			}
 		}
 
@@ -1970,6 +1970,11 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 	/* Call SCSI completion function to complete the IO */
 		sc->result = (DID_ABORT << 16);
 		sc->scsi_done(sc);
+		atomic64_dec(&fnic_stats->io_stats.active_ios);
+		if (atomic64_read(&fnic->io_cmpl_skip))
+			atomic64_dec(&fnic->io_cmpl_skip);
+		else
+			atomic64_inc(&fnic_stats->io_stats.io_completions);
 	}
 
 fnic_abort_cmd_end:
-- 
2.5.5
