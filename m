From: Oliver Neukum <oliver@neukum.org>
Subject: [PATCH 3/4] sd: deal with removal of medium to be synched
Date: Thu,  2 Aug 2012 12:27:06 +0200
Message-ID: <1343903227-17285-4-git-send-email-oliver@neukum.org>
References: <1343903227-17285-1-git-send-email-oliver@neukum.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out003.kontent.com ([81.88.40.217]:36396 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892Ab2HBK2P (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Aug 2012 06:28:15 -0400
In-Reply-To: <1343903227-17285-1-git-send-email-oliver@neukum.org>
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

