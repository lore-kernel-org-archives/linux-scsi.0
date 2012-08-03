From: Oliver Neukum <oliver@neukum.org>
Subject: [PATCH 3/5] sd: deal with removal of medium to be synched
Date: Fri,  3 Aug 2012 14:27:39 +0200
Message-ID: <1343996861-20857-4-git-send-email-oliver@neukum.org>
References: <1343996861-20857-1-git-send-email-oliver@neukum.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out002.kontent.com ([81.88.40.216]:53927 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787Ab2HCM2v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Aug 2012 08:28:51 -0400
In-Reply-To: <1343996861-20857-1-git-send-email-oliver@neukum.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org, hare@suse.de
Cc: Oliver Neukum <oliver@neukum.org>, Oliver Neukum <oneukum@suse.de>

sd_sync_cache() is called for purposes of power management.
Under those circumstances a medium removal is no error.
The data is lost under any circumstances, so the system may as
well sleep.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
---
 drivers/scsi/sd.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a344220..c39a97e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1278,8 +1278,16 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
 
 	if (res) {
 		sd_print_result(sdkp, res);
+
 		if (driver_byte(res) & DRIVER_SENSE)
 			sd_print_sense_hdr(sdkp, &sshdr);
+		/*
+		 * we need to evaluate the error return
+		 * 0x3a is medium not present
+		 * this is no error here
+		 */
+		if ((scsi_sense_valid(&sshdr) && sshdr.asc == 0x3a))
+			return 0;
 	}
 
 	if (res)
-- 
1.7.7

