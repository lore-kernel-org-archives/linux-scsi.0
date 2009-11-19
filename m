From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH] multipath: Evaluate request result and sense code
Date: Thu, 19 Nov 2009 13:25:03 +0100
Message-ID: <20091119122503.413AD3A174@ochil.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:50635 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831AbZKSMY5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Nov 2009 07:24:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org


As we now see the result for every command we
can use it to make some more elaborate choices
if we should retry the request on another path.

This solves a potential data corruption when
a request is being terminated with RESERVATION
CONFLICT and queue_if_no_path is active; the
request will be queued until the reservation
status changes and then transmitted.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm-mpath.c |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index dce971d..460e11f 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -19,6 +19,7 @@
 #include <linux/time.h>
 #include <linux/workqueue.h>
 #include <scsi/scsi_dh.h>
+#include <scsi/scsi_eh.h>
 #include <asm/atomic.h>
 
 #define DM_MSG_PREFIX "multipath"
@@ -101,6 +102,7 @@ struct multipath {
 struct dm_mpath_io {
 	struct pgpath *pgpath;
 	size_t nr_bytes;
+	char sense[SCSI_SENSE_BUFFERSIZE];
 };
 
 typedef int (*action_fn) (struct pgpath *pgpath);
@@ -913,6 +915,9 @@ static int multipath_map(struct dm_target *ti, struct request *clone,
 
 	map_context->ptr = mpio;
 	clone->cmd_flags |= REQ_FAILFAST_TRANSPORT;
+	/* Always attach a sense buffer */
+	if (!clone->sense)
+		clone->sense = mpio->sense;
 	r = map_io(m, clone, mpio, 0);
 	if (r < 0 || r == DM_MAPIO_REQUEUE)
 		mempool_free(mpio, m->mpio_pool);
@@ -1192,6 +1197,42 @@ static void activate_path(struct work_struct *work)
 }
 
 /*
+ * Evaluate scsi return code
+ */
+static int eval_scsi_error(int result, char *sense, int sense_len)
+{
+	struct scsi_sense_hdr sshdr;
+	int r = DM_ENDIO_REQUEUE;
+
+	if (host_byte(result) != DID_OK)
+		return r;
+
+	if (msg_byte(result) != COMMAND_COMPLETE)
+		return r;
+
+	if (status_byte(result) == RESERVATION_CONFLICT)
+		/* Do not retry here, possible data corruption */
+		return -EIO;
+
+	if (status_byte(result) == CHECK_CONDITION &&
+	    !scsi_normalize_sense(sense, sense_len, &sshdr)) {
+
+		switch (sshdr.sense_key) {
+		case MEDIUM_ERROR:
+		case DATA_PROTECT:
+		case BLANK_CHECK:
+		case COPY_ABORTED:
+		case VOLUME_OVERFLOW:
+		case MISCOMPARE:
+			r = -EIO;
+			break;
+		}
+	}
+
+	return r;
+}
+
+/*
  * end_io handling
  */
 static int do_end_io(struct multipath *m, struct request *clone,
@@ -1217,6 +1258,10 @@ static int do_end_io(struct multipath *m, struct request *clone,
 	if (error == -EOPNOTSUPP)
 		return error;
 
+	r = eval_scsi_error(clone->errors, clone->sense, clone->sense_len);
+	if (r != DM_ENDIO_REQUEUE)
+		return r;
+
 	if (mpio->pgpath)
 		fail_path(mpio->pgpath);
 
@@ -1243,6 +1288,10 @@ static int multipath_end_io(struct dm_target *ti, struct request *clone,
 		if (ps->type->end_io)
 			ps->type->end_io(ps, &pgpath->path, mpio->nr_bytes);
 	}
+	if (clone->sense == mpio->sense) {
+		clone->sense = NULL;
+		clone->sense_len = 0;
+	}
 	mempool_free(mpio, m->mpio_pool);
 
 	return r;
-- 
1.5.3.2

