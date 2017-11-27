From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH] scsi_devinfo: cleanly zero-pad devinfo strings
Date: Mon, 27 Nov 2017 23:47:35 +0100
Message-ID: <20171127224735.32139-2-mwilck@suse.com>
References: <20171127224735.32139-1-mwilck@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:57955 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751771AbdK0WsM (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Mon, 27 Nov 2017 17:48:12 -0500
In-Reply-To: <20171127224735.32139-1-mwilck@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, Alan Stern <stern@rowland.harvard.edu>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, Martin Wilck <mwilck@suse.de>

Cleanly fill memory for "vendor" and "model" with 0-bytes for
the "compatible" case rather than adding only a single 0 byte.
This simplifies the devinfo code a a bit, and avoids mistakes
in other places of the code (not in current upstream, but we
had one such mistake in the SUSE kernel).

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/scsi_devinfo.c | 23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index d6db5697472e..6e784a09b21a 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -34,7 +34,6 @@ struct scsi_dev_info_list_table {
 };
 
 
-static const char spaces[] = "                "; /* 16 of them */
 static unsigned scsi_default_dev_flags;
 static LIST_HEAD(scsi_dev_info_list);
 static char scsi_dev_flags[256];
@@ -298,21 +297,13 @@ static void scsi_strcpy_devinfo(char *name, char *to, size_t to_length,
 	size_t from_length;
 
 	from_length = strlen(from);
-	strncpy(to, from, min(to_length, from_length));
-	if (from_length < to_length) {
-		if (compatible) {
-			/*
-			 * NUL terminate the string if it is short.
-			 */
-			to[from_length] = '\0';
-		} else {
-			/*
-			 * space pad the string if it is short.
-			 */
-			strncpy(&to[from_length], spaces,
-				to_length - from_length);
-		}
-	}
+	/* This zero-pads the destination */
+	strncpy(to, from, to_length);
+	if (from_length < to_length && !compatible)
+		/*
+		 * space pad the string if it is short.
+		 */
+		memset(&to[from_length], ' ', to_length - from_length);
 	if (from_length > to_length)
 		 printk(KERN_WARNING "%s: %s string '%s' is too long\n",
 			__func__, name, from);
-- 
2.15.0
