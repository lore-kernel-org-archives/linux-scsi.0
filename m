From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3/5] [SCSI] scsi_dh_alua: fix stpg_endio group state reporting
Date: Wed,  5 Jan 2011 16:00:22 -0500
Message-ID: <1294261224-12599-4-git-send-email-snitzer@redhat.com>
References: <1294261224-12599-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924Ab1AEVBR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Jan 2011 16:01:17 -0500
In-Reply-To: <1294261224-12599-1-git-send-email-snitzer@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, Joseph Gruher <joseph.r.gruher@intel.com>, Ilgu Hong <ilgu.hong@promise.com>, Mike Snitzer <snitzer@redhat.com>

From: Joseph Gruher <joseph.r.gruher@intel.com>

Initialize stpg_endio() 'err' to SCSI_DH_OK and only change it to
SCSI_DH_IO accordingly.  This allows the switching of target group state
to be properly reported when no error has occurred.

Signed-off-by: Joseph Gruher <joseph.r.gruher@intel.com>
Signed-off-by: Ilgu Hong <ilgu.hong@promise.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index ba3c649..9bd2c8a 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -253,13 +253,15 @@ static void stpg_endio(struct request *req, int error)
 {
 	struct alua_dh_data *h = req->end_io_data;
 	struct scsi_sense_hdr sense_hdr;
-	unsigned err = SCSI_DH_IO;
+	unsigned err = SCSI_DH_OK;
 
 	if (error || host_byte(req->errors) != DID_OK ||
-			msg_byte(req->errors) != COMMAND_COMPLETE)
+			msg_byte(req->errors) != COMMAND_COMPLETE) {
+		err = SCSI_DH_IO;
 		goto done;
+	}
 
-	if (err == SCSI_DH_IO && h->senselen > 0) {
+	if (h->senselen > 0) {
 		err = scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
 					   &sense_hdr);
 		if (!err) {
-- 
1.7.3.4

