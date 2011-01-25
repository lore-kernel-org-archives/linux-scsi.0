From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] [SCSI] scsi_dh_hp_sw: fix deadlock in stpg_endio
Date: Tue, 25 Jan 2011 11:49:04 -0500
Message-ID: <1295974144-22347-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42045 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721Ab1AYQtR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jan 2011 11:49:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>

The use of blk_execute_rq_nowait() implies __blk_put_request() is needed
in stpg_endio() rather than blk_put_request() -- blk_finish_request() is
called with queue lock already held.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index e391664..d0363c8 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -225,7 +225,8 @@ static void start_stop_endio(struct request *req, int error)
 		}
 	}
 done:
-	blk_put_request(req);
+	req->end_io_data = NULL;
+	__blk_put_request(req->q, req);
 	if (h->callback_fn) {
 		h->callback_fn(h->callback_data, err);
 		h->callback_fn = h->callback_data = NULL;
