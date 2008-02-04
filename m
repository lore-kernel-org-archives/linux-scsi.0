From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 4/24][RFC] firewire & ieee1394: Simple convert to new scsi_eh_cpy_sense.
Date: Mon,  4 Feb 2008 17:56:46 +0200
Message-ID: <1202140606-4629-1-git-send-email-bharrosh@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:60404 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbYBDQCR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 11:02:17 -0500
In-Reply-To: 47A72A7F.1050301@panasas.com
References: 47A72A7F.1050301@panasas.com
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>J
Cc: Andrew Morton <akpm@linux-foundation.org>

  Abstract away scsi_cmnd->sense_buffer for later removal.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/firewire/fw-sbp2.c |    7 +++++--
 drivers/ieee1394/sbp2.c    |    9 +++++++--
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index 1d9602b..0404650 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -46,6 +46,7 @@
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_eh.h>
 
 #include "fw-transaction.h"
 #include "fw-topology.h"
@@ -1016,8 +1017,9 @@ static struct fw_driver sbp2_driver = {
 };
 
 static unsigned int
-sbp2_status_to_sense_data(u8 *sbp2_status, u8 *sense_data)
+sbp2_status_to_sense_data(u8 *sbp2_status, struct scsi_cmnd *srb)
 {
+	u8 sense_data[16];
 	int sam_status;
 
 	sense_data[0] = 0x70;
@@ -1036,6 +1038,7 @@ sbp2_status_to_sense_data(u8 *sbp2_status, u8 *sense_data)
 	sense_data[13] = sbp2_status[3];
 	sense_data[14] = sbp2_status[12];
 	sense_data[15] = sbp2_status[13];
+	scsi_eh_cpy_sense(srb, sense_data, sizeof(sense_data));
 
 	sam_status = sbp2_status[0] & 0x3f;
 
@@ -1081,7 +1084,7 @@ complete_command_orb(struct sbp2_orb *base_orb, struct sbp2_status *status)
 
 		if (result == DID_OK << 16 && STATUS_GET_LEN(*status) > 1)
 			result = sbp2_status_to_sense_data(STATUS_GET_DATA(*status),
-							   orb->cmd->sense_buffer);
+							   orb->cmd);
 	} else {
 		/*
 		 * If the orb completes with status == NULL, something
diff --git a/drivers/ieee1394/sbp2.c b/drivers/ieee1394/sbp2.c
index 2b889d9..ed54c54 100644
--- a/drivers/ieee1394/sbp2.c
+++ b/drivers/ieee1394/sbp2.c
@@ -89,6 +89,7 @@
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_eh.h>
 
 #include "csr1212.h"
 #include "highlevel.h"
@@ -1672,8 +1673,11 @@ static int sbp2_send_command(struct sbp2_lu *lu, struct scsi_cmnd *SCpnt,
  * Translates SBP-2 status into SCSI sense data for check conditions
  */
 static unsigned int sbp2_status_to_sense_data(unchar *sbp2_status,
-					      unchar *sense_data)
+					      struct scsi_cmnd *SCpnt)
 {
+	u8 sense_data[16];
+
+	memset(sense_data, 0, sizeof(sense_data));
 	/* OK, it's pretty ugly... ;-) */
 	sense_data[0] = 0x70;
 	sense_data[1] = 0x0;
@@ -1691,6 +1695,7 @@ static unsigned int sbp2_status_to_sense_data(unchar *sbp2_status,
 	sense_data[13] = sbp2_status[11];
 	sense_data[14] = sbp2_status[20];
 	sense_data[15] = sbp2_status[21];
+	scsi_eh_cpy_sense(SCpnt, sense_data, sizeof(sense_data));
 
 	return sbp2_status[8] & 0x3f;
 }
@@ -1784,7 +1789,7 @@ static int sbp2_handle_status_write(struct hpsb_host *host, int nodeid,
 
 			if (STATUS_GET_LEN(h) > 1)
 				scsi_status = sbp2_status_to_sense_data(
-					(unchar *)sb, SCpnt->sense_buffer);
+					(unchar *)sb, SCpnt);
 
 			if (STATUS_TEST_DEAD(h))
                                 sbp2_agent_reset(lu, 0);
-- 
1.5.3.3

