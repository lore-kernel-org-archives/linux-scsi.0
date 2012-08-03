From: Oliver Neukum <oliver@neukum.org>
Subject: [PATCH 5/5] scsi: more error conditions for power management
Date: Fri,  3 Aug 2012 14:27:41 +0200
Message-ID: <1343996861-20857-6-git-send-email-oliver@neukum.org>
References: <1343996861-20857-1-git-send-email-oliver@neukum.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out002.kontent.com ([81.88.40.216]:53955 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787Ab2HCM2x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Aug 2012 08:28:53 -0400
In-Reply-To: <1343996861-20857-1-git-send-email-oliver@neukum.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org, hare@suse.de
Cc: Oliver Neukum <oliver@neukum.org>, Oliver Neukum <oneukum@suse.de>

BUSY and QUEUE_FULL are retryable errors.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
---
 drivers/scsi/scsi_error.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 195cc75..2f70a07 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2227,6 +2227,12 @@ EXPORT_SYMBOL(scsi_build_sense_buffer);
  **/
 int scsi_translate_errors_to_power_management(int res)
 {
+	switch (status_byte(res)) {
+	case BUSY:
+	case QUEUE_FULL:
+		return -EBUSY;
+	}
+
 	switch (host_byte(res)) {
 	/* ignore errors due to racing a disconnection */
 	case DID_BAD_TARGET:
-- 
1.7.7

