From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] Remove 'unhandled error code' messages
Date: Thu, 10 Nov 2011 15:12:07 +0100
Message-ID: <1320934327-8384-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45570 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934700Ab1KJOMS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Nov 2011 09:12:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

scsi_io_completion() tries to take some action based on
the command result and sense code. It also displays
'unhandled error code' or 'unhandled sense code' in case
no special handling was found.
This serves as an additional source of confusion to
the unsuspecting user, as the message in fact means
'everything okay, no special casing required',
and not 'oh gosh, something has happened and the system
couldn't deal with it'.

Plus it doesn't add any value for debugging, as the
actual error and sense code is printed with the next
statement anyway.

So remove these lines.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f85cfa6..1975b3f 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -921,12 +921,10 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 			action = ACTION_FAIL;
 			break;
 		default:
-			description = "Unhandled sense code";
 			action = ACTION_FAIL;
 			break;
 		}
 	} else {
-		description = "Unhandled error code";
 		action = ACTION_FAIL;
 	}
 
