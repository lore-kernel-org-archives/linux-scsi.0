From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH] scsi: handle ABORTED_COMMAND on Fujitsu ETERNUS
Date: Mon, 15 Jan 2018 21:18:52 +0100
Message-ID: <20180115201852.15152-1-mwilck@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:44203 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750752AbeAOUTm (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Mon, 15 Jan 2018 15:19:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, James Bottomley <jejb@linux.vnet.ibm.com>, saito.kazuya@jp.fujitsu.com

On Fujitsu ETERNUS systems, sense code ABORTED COMMAND with ASC/Q C1/01
is used to indicate temporary condition where the storage-internal path
to a target is switched from one controller to another. SCSI commands
that return with this error code must be retried unconditionally (i.e. without
the "maybe_retry" logic in scsi_decide_disposition); otherwise dm-multipath
might initiate a failover from a healthy path e.g. for REQ_FAILFAST_DEV
commands.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/scsi_error.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index d042915ce895..598111a741d4 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -518,6 +518,16 @@ int scsi_check_sense(struct scsi_cmnd *scmd)
 		if (sshdr.asc == 0x10) /* DIF */
 			return SUCCESS;
 
+		if (!strncmp(scmd->device->vendor, "FUJITSU", 7) &&
+			   !strncmp(scmd->device->model, "ETERNUS_DXM", 11) &&
+			   (sshdr.asc == 0xc1) && (sshdr.ascq == 0x1)) {
+			/*
+			 * Fujitsu Eternus uses this vendor specific code
+			 * to indicate an internal reconfiguration status
+			 * which can be recovered with a retry.
+			 */
+			return ADD_TO_MLQUEUE;
+		}
 		return NEEDS_RETRY;
 	case NOT_READY:
 	case UNIT_ATTENTION:
-- 
2.15.1
