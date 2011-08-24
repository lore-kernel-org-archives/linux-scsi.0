From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 7/7] scsi_dh_alua: Decrease retry interval
Date: Wed, 24 Aug 2011 10:51:19 +0200
Message-ID: <1314175879-16565-8-git-send-email-hare@suse.de>
References: <1314175879-16565-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58464 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756639Ab1HXIwA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Aug 2011 04:52:00 -0400
In-Reply-To: <1314175879-16565-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

The alua device handler starts the first retry after 10 seconds,
and increases it times 10 for each round.
This leads to an unnecessary delay. This patch modifies it to
start after one second, and increase by a factor of two.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 34c6611..9dce367 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -506,7 +506,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h)
 	int len, k, off, valid_states = 0;
 	unsigned char *ucp;
 	unsigned err;
-	unsigned long expiry, interval = 10;
+	unsigned long expiry, interval = 1;
 
 	expiry = round_jiffies_up(jiffies + ALUA_FAILOVER_TIMEOUT);
  retry:
@@ -567,7 +567,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h)
 	case TPGS_STATE_TRANSITIONING:
 		if (time_before(jiffies, expiry)) {
 			/* State transition, retry */
-			interval *= 10;
+			interval *= 2;
 			msleep(interval);
 			goto retry;
 		}
-- 
1.6.0.2

