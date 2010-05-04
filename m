From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 5/9] scsi: Add a scsi_unprep_fn
Date: Mon,  3 May 2010 20:37:04 -0700
Message-ID: <1272944228-30511-6-git-send-email-andmike@linux.vnet.ibm.com>
References: <1272944228-30511-1-git-send-email-andmike@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:47343 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695Ab0EDDhq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 May 2010 23:37:46 -0400
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by e1.ny.us.ibm.com (8.14.3/8.13.1) with ESMTP id o443WU3a004768
	for <linux-scsi@vger.kernel.org>; Mon, 3 May 2010 23:32:30 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o443bj8N2019500
	for <linux-scsi@vger.kernel.org>; Mon, 3 May 2010 23:37:45 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o443bimX019005
	for <linux-scsi@vger.kernel.org>; Mon, 3 May 2010 23:37:45 -0400
In-Reply-To: <1272944228-30511-1-git-send-email-andmike@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jens Axobe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@suse.de>, dm-devel@redhat.com

Add scsi_unprep_fn and set this function as the unprep_rq_fn for the scsi
queue. This will allow SCSI resources to be released if the block layer
unpreps a request.

Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: James Bottomley <James.Bottomley@suse.de>
---
 drivers/scsi/scsi_lib.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 1646fe7..1685d35 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -91,6 +91,17 @@ static void scsi_unprep_request(struct request *req)
 	scsi_put_command(cmd);
 }
 
+static void scsi_unprep_fn(struct request_queue *q, struct request *req)
+{
+	struct scsi_cmnd *cmd = req->special;
+
+	if (cmd) {
+		scsi_release_buffers(cmd);
+		scsi_unprep_request(req);
+	}
+}
+
+
 /**
  * __scsi_queue_insert - private queue insertion
  * @cmd: The SCSI command being requeued
@@ -1664,6 +1675,7 @@ struct request_queue *scsi_alloc_queue(struct scsi_device *sdev)
 		return NULL;
 
 	blk_queue_prep_rq(q, scsi_prep_fn);
+	blk_queue_unprep_rq(q, scsi_unprep_fn);
 	blk_queue_softirq_done(q, scsi_softirq_done);
 	blk_queue_rq_timed_out(q, scsi_times_out);
 	blk_queue_lld_busy(q, scsi_lld_busy);
-- 
1.6.6.1

