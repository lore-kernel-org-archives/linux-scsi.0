From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi: Increase number of retries for scsi_mode_sense()
Date: Fri, 12 Jun 2015 16:13:21 +0200
Message-ID: <1434118401-100652-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38785 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754640AbbFLONX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Jun 2015 10:13:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Nic Bellinger <nab@daterainc.com>, Ewan Milne <emilne@redhat.com>, Hannes Reinecke <hare@suse.de>

As scsi_mode_sense() is now retrying for any UAs it needs
potentially several retries to clear any UA status.
So increase the number of retries to at least 5.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_transport_sas.c | 2 +-
 drivers/scsi/sr.c                 | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 9a05819..a02ed82 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -1280,7 +1280,7 @@ int sas_read_port_mode_page(struct scsi_device *sdev)
 	if (!buffer)
 		return -ENOMEM;
 
-	res = scsi_mode_sense(sdev, 1, 0x19, buffer, BUF_SIZE, 30*HZ, 3,
+	res = scsi_mode_sense(sdev, 1, 0x19, buffer, BUF_SIZE, 30*HZ, 5,
 			      &mode_data, NULL);
 
 	error = -EINVAL;
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 8bd54a6..9733452 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -858,7 +858,7 @@ static void get_capabilities(struct scsi_cd *cd)
 
 	/* ask for mode page 0x2a */
 	rc = scsi_mode_sense(cd->device, 0, 0x2a, buffer, 128,
-			     SR_TIMEOUT, 3, &data, NULL);
+			     SR_TIMEOUT, 5, &data, NULL);
 
 	if (!scsi_status_is_good(rc)) {
 		/* failed, drive doesn't have capabilities mode page */
-- 
1.8.5.2

