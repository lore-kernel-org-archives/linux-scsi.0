From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi: Retry failfast commands after EH
Date: Mon, 27 Jan 2014 09:29:17 +0100
Message-ID: <1390811357-53189-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56807 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135AbaA0I3U (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Jan 2014 03:29:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Any commands with return status DID_FAILFAST_XXX should be
retried; the port will be in a sane state after EH.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_error.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 78b004d..5141235 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -684,6 +684,9 @@ static int scsi_eh_completed_normally(struct scsi_cmnd *scmd)
 		 */
 		return scsi_check_sense(scmd);
 	}
+	if ((host_byte(scmd->result) == DID_TRANSPORT_DISRUPTED) ||
+	    (host_byte(scmd->result) == DID_TRANSPORT_FAILFAST))
+		return NEEDS_RETRY;
 	if (host_byte(scmd->result) != DID_OK)
 		return FAILED;
 
-- 
1.7.12.4

