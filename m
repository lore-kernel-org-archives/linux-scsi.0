From: Rob Evers <revers@redhat.com>
Subject: [PATCH 3/3] alua: backoff alua rtpg retry linearly vs. geometrically
Date: Wed, 16 May 2012 10:15:05 -0400
Message-ID: <1337177705-17114-3-git-send-email-revers@redhat.com>
References: <1337177705-17114-1-git-send-email-revers@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811Ab2EPOPH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 May 2012 10:15:07 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q4GEF67j000348
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Wed, 16 May 2012 10:15:07 -0400
Received: from localhost (dhcp-185-85.bos.redhat.com [10.16.185.85])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q4GEF6bC005623
	for <linux-scsi@vger.kernel.org>; Wed, 16 May 2012 10:15:06 -0400
In-Reply-To: <1337177705-17114-1-git-send-email-revers@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Rob Evers <revers@redhat.com>

Currently the backoff algorithm for when to retry alua rtpg
requests progresses geometrically as so:

2, 4, 8, 16, 32, 64... seconds.

This progression can lead to un-needed delay in retrying
alua rtpg requests when the rtpgs are delayed.  A less
aggressive backoff algorithm that is additive would not
lead to such large jumps when delays start getting long, but
would backoff linearly:

2, 4, 6, 8, 10... seconds.

Signed-off-by: Rob Evers <revers@redhat.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index ca414ae..e0749e9 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -522,7 +522,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h)
 	unsigned char *ucp;
 	unsigned err;
 	bool rtpg_ext_hdr_req = 1;
-	unsigned long expiry, interval = 1000;
+	unsigned long expiry, interval = 0;
 	unsigned int tpg_desc_tbl_off;
 	unsigned char orig_transition_tmo;
 
@@ -624,7 +624,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h)
 	case TPGS_STATE_TRANSITIONING:
 		if (time_before(jiffies, expiry)) {
 			/* State transition, retry */
-			interval *= 2;
+			interval += 2000;
 			msleep(interval);
 			goto retry;
 		}
-- 
1.7.7.2

