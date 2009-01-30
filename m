From: michaelc@cs.wisc.edu
Subject: [PATCH 1/3] scsi dh alua: fix group id masking
Date: Fri, 30 Jan 2009 17:00:09 -0600
Message-ID: <12333564114078-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:53957 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718AbZA3XAQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jan 2009 18:00:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Ilgu Hong <ilgu.hong@promise.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Ilgu Hong <ilgu.hong@promise.com>


The buf[i] is a byte but we are only asking 4 bits off the
group_id. This patch has us take off a byte.

Signed-off-by: Ilgu Hong <ilgu.hong@promise.com> 
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/device_handler/scsi_dh_alua.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index e356b43..5096b0b 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -247,8 +247,8 @@ static unsigned submit_stpg(struct scsi_device *sdev, struct alua_dh_data *h)
 	/* Prepare the data buffer */
 	memset(h->buff, 0, stpg_len);
 	h->buff[4] = TPGS_STATE_OPTIMIZED & 0x0f;
-	h->buff[6] = (h->group_id >> 8) & 0x0f;
-	h->buff[7] = h->group_id & 0x0f;
+	h->buff[6] = (h->group_id >> 8) & 0xff;
+	h->buff[7] = h->group_id & 0xff;
 
 	rq = get_alua_req(sdev, h->buff, stpg_len, WRITE);
 	if (!rq)
-- 
1.6.0.6

