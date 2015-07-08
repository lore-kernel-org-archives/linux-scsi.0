From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/3] sd: do not try to spin-up disks for ALUA 'transitioning' state
Date: Wed,  8 Jul 2015 09:41:08 +0200
Message-ID: <1436341268-91432-4-git-send-email-hare@suse.de>
References: <1436341268-91432-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58804 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934299AbbGHHlM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jul 2015 03:41:12 -0400
In-Reply-To: <1436341268-91432-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Bart van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

If a disk reports an ALUA 'transitioning' state we should not
try to spin up the device.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/sd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 7c0bdaa..180a6e8 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1801,6 +1801,8 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 		if (sense_valid && sshdr.sense_key == NOT_READY) {
 			if (sshdr.asc == 4 && sshdr.ascq == 3)
 				break;	/* manual intervention required */
+			if (sshdr.asc == 4 && sshdr.ascq == 0xa)
+				break;  /* transitioning */
 			if (sshdr.asc == 4 && sshdr.ascq == 0xb)
 				break;	/* standby */
 			if (sshdr.asc == 4 && sshdr.ascq == 0xc)
-- 
1.8.5.2

