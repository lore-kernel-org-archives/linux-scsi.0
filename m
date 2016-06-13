From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi: disable VPD page check on error
Date: Mon, 13 Jun 2016 14:48:53 +0200
Message-ID: <1465822133-22143-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54413 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422747AbcFMMtC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Jun 2016 08:49:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Paolo Bonzini <pbonzini@redhat.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

If we encounter an error during VPD page scanning we should be
setting the 'skip_vpd_pages' bit to avoid further accesses.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 1deb6ad..0359864 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -796,6 +796,7 @@ retry_pg0:
 	result = scsi_vpd_inquiry(sdev, vpd_buf, 0, vpd_len);
 	if (result < 0) {
 		kfree(vpd_buf);
+		sdev->skip_vpd_pages = 1;
 		return;
 	}
 	if (result > vpd_len) {
@@ -822,6 +823,7 @@ retry_pg80:
 		result = scsi_vpd_inquiry(sdev, vpd_buf, 0x80, vpd_len);
 		if (result < 0) {
 			kfree(vpd_buf);
+			sdev->skip_vpd_pages = 1;
 			return;
 		}
 		if (result > vpd_len) {
@@ -851,6 +853,7 @@ retry_pg83:
 		result = scsi_vpd_inquiry(sdev, vpd_buf, 0x83, vpd_len);
 		if (result < 0) {
 			kfree(vpd_buf);
+			sdev->skip_vpd_pages = 1;
 			return;
 		}
 		if (result > vpd_len) {
-- 
1.8.5.6

