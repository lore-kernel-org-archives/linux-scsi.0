From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] [SCSI] scsi_dh_alua: fix overflow in alua_rtpg port group id check
Date: Tue, 18 Jan 2011 20:11:51 -0500
Message-ID: <1295399511-10894-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752564Ab1ASBL4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jan 2011 20:11:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, Martin George <marting@netapp.com>, Hannes Reinecke <hare@suse.de>

For Target Portal Group IDs occupying the full 2 bytes in the RTPG
response, the following group_id check in alua_rtpg() always fails
because 'ucp' is only a signed char:
   if (h->group_id == (ucp[2] << 8) + ucp[3]) {

Fix this signed char overflow by changing 'ucp' to an unsigned char
pointer (same type used for 'buff' member of alua_dh_data structure).

Reported-by: Martin George <marting@netapp.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 6b72932..536df91 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -545,7 +545,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h)
 {
 	struct scsi_sense_hdr sense_hdr;
 	int len, k, off, valid_states = 0;
-	char *ucp;
+	unsigned char *ucp;
 	unsigned err;
 	unsigned long expiry, interval = 10;
 
-- 
1.7.3.4

