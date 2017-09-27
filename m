From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH] scsi: ILLEGAL REQUEST + ASC==27 => target failure
Date: Wed, 27 Sep 2017 14:44:19 +0200
Message-ID: <20170927124419.23637-1-mwilck@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:46857 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752160AbdI0Moh (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Wed, 27 Sep 2017 08:44:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, Martin Wilck <mwilck@suse.de>

ASC 0x27 is "WRITE PROTECTED". This error code is returned e.g.
by Fujitsu ETERNUS systems under certain conditions for
WRITE SAME 16 commands with UNMAP bit set. It should not be
treated as a path error. In general, it makes sense to assume
that being write protected is a target rather than a path
property.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/scsi_error.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 38942050b265..dab876c65473 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -580,7 +580,8 @@ int scsi_check_sense(struct scsi_cmnd *scmd)
 		if (sshdr.asc == 0x20 || /* Invalid command operation code */
 		    sshdr.asc == 0x21 || /* Logical block address out of range */
 		    sshdr.asc == 0x24 || /* Invalid field in cdb */
-		    sshdr.asc == 0x26) { /* Parameter value invalid */
+		    sshdr.asc == 0x26 || /* Parameter value invalid */
+		    sshdr.asc == 0x27) { /* Write protected */
 			set_host_byte(scmd, DID_TARGET_FAILURE);
 		}
 		return SUCCESS;
-- 
2.14.0
