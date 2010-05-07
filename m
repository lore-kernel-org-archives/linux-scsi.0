From: Dan Carpenter <error27@gmail.com>
Subject: [patch] be2iscsi: correct return value in mgmt_invalidate_icds()
Date: Fri, 7 May 2010 10:53:45 +0200
Message-ID: <20100507085345.GB27064@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37427 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758Ab0EGIxu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 May 2010 04:53:50 -0400
Received: by wyg36 with SMTP id 36so624301wyg.19
        for <linux-scsi@vger.kernel.org>; Fri, 07 May 2010 01:53:49 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kallickal <jayamohank@serverengines.com>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org

This function should return 0 on error.  Returning -1 would cause a
crash.

Also there is an extra space before the newline character and a missing
space between the "for" and the "mgmt_invalidate_icds".  I put the string
on one line.  The current version of checkpatch.pl complains that the
line is too long, but it makes grepping easier.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index e641922..350cbea 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -167,10 +167,9 @@ unsigned char mgmt_invalidate_icds(struct beiscsi_hba *phba,
 				&nonemb_cmd.dma);
 	if (nonemb_cmd.va == NULL) {
 		SE_DEBUG(DBG_LVL_1,
-			 "Failed to allocate memory for"
-			 "mgmt_invalidate_icds \n");
+			 "Failed to allocate memory for mgmt_invalidate_icds\n");
 		spin_unlock(&ctrl->mbox_lock);
-		return -1;
+		return 0;
 	}
 	nonemb_cmd.size = sizeof(struct invalidate_commands_params_in);
 	req = nonemb_cmd.va;
