From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: [PATCH] multipath: Evaluate request result and sense code
Date: Wed, 25 Nov 2009 17:25:41 -0700
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF48723766A@cosmail01.lsi.com>
References: <20091119122503.413AD3A174@ochil.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:33624 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759998AbZKZA1Y convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Nov 2009 19:27:24 -0500
In-Reply-To: <20091119122503.413AD3A174@ochil.suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hannes,
  My .02 cents on this below..

________________________________________
From: linux-scsi-owner@vger.kernel.org [linux-scsi-owner@vger.kernel.org] On Behalf Of Hannes Reinecke [hare@suse.de]
Sent: Thursday, November 19, 2009 6:25 AM
To: James Bottomley
Cc: dm-devel@redhat.com; linux-scsi@vger.kernel.org
Subject: [PATCH] multipath: Evaluate request result and sense code

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
+       char sense[SCSI_SENSE_BUFFERSIZE];
 };

 typedef int (*action_fn) (struct pgpath *pgpath);
@@ -913,6 +915,9 @@ static int multipath_map(struct dm_target *ti, struct request *clone,

        map_context->ptr = mpio;
        clone->cmd_flags |= REQ_FAILFAST_TRANSPORT;
+       /* Always attach a sense buffer */
+       if (!clone->sense)
+               clone->sense = mpio->sense;
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
+       struct scsi_sense_hdr sshdr;
+       int r = DM_ENDIO_REQUEUE;
+
+       if (host_byte(result) != DID_OK)
+               return r;
+
+       if (msg_byte(result) != COMMAND_COMPLETE)
+               return r;
+
+       if (status_byte(result) == RESERVATION_CONFLICT)
+               /* Do not retry here, possible data corruption */
+               return -EIO;
+
+       if (status_byte(result) == CHECK_CONDITION &&
+           !scsi_normalize_sense(sense, sense_len, &sshdr)) {
+
+               switch (sshdr.sense_key) {
+               case MEDIUM_ERROR:
+               case DATA_PROTECT:
+               case BLANK_CHECK:
+               case COPY_ABORTED:
+               case VOLUME_OVERFLOW:
+               case MISCOMPARE:
+                       r = -EIO;
+                       break;
+               }

The above sense key list does not cover all the cases(at least for my case). For example, I have these requirements for my storage.
1. For certain check conditions I should be reporting I/O error immediately without retrying on other paths. You have covered some cases here but we a have bigger list.
2. For few other check condtions I should be calling activate_path instead of failing the path.
So, I am thinking it may be better to handle this with scsi device handlers(may be providing a new scsi_dh interface and fallback to default handling if the device handler does not handle the sense).  I am not sure if this is feasible but something to think about.

+       }
+
+       return r;
+}
+
+/*
  * end_io handling
  */
 static int do_end_io(struct multipath *m, struct request *clone,
@@ -1217,6 +1258,10 @@ static int do_end_io(struct multipath *m, struct request *clone,
        if (error == -EOPNOTSUPP)
                return error;

+       r = eval_scsi_error(clone->errors, clone->sense, clone->sense_len);
+       if (r != DM_ENDIO_REQUEUE)
+               return r;
+
        if (mpio->pgpath)
                fail_path(mpio->pgpath);

@@ -1243,6 +1288,10 @@ static int multipath_end_io(struct dm_target *ti, struct request *clone,
                if (ps->type->end_io)
                        ps->type->end_io(ps, &pgpath->path, mpio->nr_bytes);
        }
+       if (clone->sense == mpio->sense) {
+               clone->sense = NULL;
+               clone->sense_len = 0;
+       }
        mempool_free(mpio, m->mpio_pool);

        return r;
--
1.5.3.2

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html