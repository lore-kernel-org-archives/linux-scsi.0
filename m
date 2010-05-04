From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH] Retry commands with UNIT_ATTENTION sense codes
Date: Tue, 04 May 2010 16:48:53 +0200
Message-ID: <20100504144853.D94C72A205@ochil.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:41749 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753022Ab0EDOsz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 May 2010 10:48:55 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.221.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id 4E034457F0
	for <linux-scsi@vger.kernel.org>; Tue,  4 May 2010 16:48:54 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org


We have to enable retries for UNIT_ATTENTION sense codes, as a
command might've been injected from the block layer (eg barrier
requests). And for those no error recovers takes place, so we
need to make sure that the SCSI midlayer corrects any transient
errors.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_error.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index d45c69c..663a1ad 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -290,19 +290,13 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 			return NEEDS_RETRY;
 		}
 		/*
-		 * if the device is in the process of becoming ready, we 
-		 * should retry.
-		 */
-		if ((sshdr.asc == 0x04) && (sshdr.ascq == 0x01))
-			return NEEDS_RETRY;
-		/*
 		 * if the device is not started, we need to wake
 		 * the error handler to start the motor
 		 */
 		if (scmd->device->allow_restart &&
 		    (sshdr.asc == 0x04) && (sshdr.ascq == 0x02))
 			return FAILED;
-		return SUCCESS;
+		return NEEDS_RETRY;
 
 		/* these three are not supported */
 	case COPY_ABORTED:
-- 
1.6.0.2

