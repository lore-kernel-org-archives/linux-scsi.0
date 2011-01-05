From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 1/5] [SCSI] scsi_dh_alua: fix submit_stpg return
Date: Wed,  5 Jan 2011 16:00:20 -0500
Message-ID: <1294261224-12599-2-git-send-email-snitzer@redhat.com>
References: <1294261224-12599-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16481 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752815Ab1AEVBM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Jan 2011 16:01:12 -0500
In-Reply-To: <1294261224-12599-1-git-send-email-snitzer@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, Joseph Gruher <joseph.r.gruher@intel.com>, Ilgu Hong <ilgu.hong@promise.com>, Mike Snitzer <snitzer@redhat.com>

From: Joseph Gruher <joseph.r.gruher@intel.com>

submit_stpg() will always return failure so alua_activate() will report
failure via dm-multipath callback function.  Even though the stpg fired
successfuly dm-multipath does not know and always fails to change the
valid path.

By returning SCSI_DH_OK we're now skipping alua_activate()'s call to
activate_complete 'fn'.  But this is fine because stpg_endio() will call
it via h->callback_fn().

Signed-off-by: Joseph Gruher <joseph.r.gruher@intel.com>
Signed-off-by: Ilgu Hong <ilgu.hong@promise.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 6b72932..afb1d05 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -303,7 +303,6 @@ done:
 static unsigned submit_stpg(struct alua_dh_data *h)
 {
 	struct request *rq;
-	int err = SCSI_DH_RES_TEMP_UNAVAIL;
 	int stpg_len = 8;
 	struct scsi_device *sdev = h->sdev;
 
@@ -332,7 +331,7 @@ static unsigned submit_stpg(struct alua_dh_data *h)
 	rq->end_io_data = h;
 
 	blk_execute_rq_nowait(rq->q, NULL, rq, 1, stpg_endio);
-	return err;
+	return SCSI_DH_OK;
 }
 
 /*
-- 
1.7.3.4

