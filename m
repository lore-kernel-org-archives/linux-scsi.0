From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/4] ch: remove debug noise in ch_do_scsi
Date: Sun, 18 Jan 2015 16:11:30 +0100
Message-ID: <1421593891-19984-3-git-send-email-hch@lst.de>
References: <1421593891-19984-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:52043 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbbARPM2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Jan 2015 10:12:28 -0500
In-Reply-To: <1421593891-19984-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <JBottomley@Parallels.com>, linux-scsi@vger.kernel.org

The midlayer logging already prints the cdb details if the logging
level is high enough, no need to duplicate this in the ch driver.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/ch.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 79e462f..0045742 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -194,18 +194,10 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
 
  retry:
 	errno = 0;
-	if (debug) {
-		char logbuf[SCSI_LOG_BUFSIZE];
-
-		__scsi_format_command(logbuf, sizeof(logbuf), cmd, cmd_len);
-		DPRINTK("command: %s", logbuf);
-	}
-
 	result = scsi_execute_req(ch->device, cmd, direction, buffer,
 				  buflength, &sshdr, timeout * HZ,
 				  MAX_RETRIES, NULL);
 
-	DPRINTK("result: 0x%x\n",result);
 	if (driver_byte(result) & DRIVER_SENSE) {
 		if (debug)
 			scsi_print_sense_hdr(ch->device, ch->name, &sshdr);
-- 
1.9.1

