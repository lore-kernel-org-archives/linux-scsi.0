From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 6/7] Erroneous TPG ID check in SCSI ALUA Handler
Date: Wed, 24 Aug 2011 10:51:18 +0200
Message-ID: <1314175879-16565-7-git-send-email-hare@suse.de>
References: <1314175879-16565-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58460 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756639Ab1HXIv5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Aug 2011 04:51:57 -0400
In-Reply-To: <1314175879-16565-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Martin George <marting@netapp.com>

For Target Portal Group IDs occupying the full 2 bytes in the
RTPG response, the following group_id check in the alua_rtpg
routine always fails in scsi_dh_alua.c:

if (h->group_id == (ucp[2] << 8) + ucp[3]) {

This causes the ALUA handler to wrongly identify the AAS of
a specified device as well as incorrectly interpreting the
supported AAS of the target as seen by the following entries
in the /var/log/messages:

"alua: port group 3ea state A supports tousna"
"alua: port group 3e9 state A supports tousna"

This is because 'ucp' is wrongly declared in alua_rtpg as
a character pointer instead of an unsigned character pointer.

Signed-off-by: Martin George <marting@netapp.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index f44dbf6..34c6611 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -504,7 +504,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h)
 {
 	struct scsi_sense_hdr sense_hdr;
 	int len, k, off, valid_states = 0;
-	char *ucp;
+	unsigned char *ucp;
 	unsigned err;
 	unsigned long expiry, interval = 10;
 
-- 
1.6.0.2

