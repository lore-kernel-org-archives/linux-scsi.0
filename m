From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi: return TARGET_ERROR when a device has been disconnected
Date: Thu, 16 Aug 2012 08:40:08 +0200
Message-ID: <1345099208-31687-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33220 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754755Ab2HPGkL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Aug 2012 02:40:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>

When we receive a sense code of
NOT READY, LOGICAL UNIT NOT SUPPORTED
the device has been disconnected and any retry on other paths
would be pointless. So return TARGET_ERROR here.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>
---
 drivers/scsi/scsi_error.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index de2337f..0fe639e 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -296,6 +296,10 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 
 		return NEEDS_RETRY;
 	case NOT_READY:
+		if ((sshdr.asc == 0x25) && (sshdr.ascq == 0)) {
+			/* Logical unit not supported */
+			return TARGET_ERROR;
+		}
 	case UNIT_ATTENTION:
 		/*
 		 * if we are expecting a cc/ua because of a bus reset that we
-- 
1.7.4.2

