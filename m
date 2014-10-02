From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 5/5] scsi: Remove scmd->tag
Date: Thu,  2 Oct 2014 12:43:13 +0200
Message-ID: <1412246593-107001-6-git-send-email-hare@suse.de>
References: <1412246593-107001-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59422 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752385AbaJBKnQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Oct 2014 06:43:16 -0400
In-Reply-To: <1412246593-107001-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <jbottomley@parallels.com>, Sagi Grimberg <sagig@dev.mellanox.co.il>, Webb Scales <webbnh@hp.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

struct scsi_cmnd has a 'tag' field, which was supposed to be
used to support SCSI-II tagged command queueing.
In the end tagged command queueing support moved into the
block layer, with the tag number available in the request.
So the 'tag' field lost its original meaning and can be
removed.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/NCR5380.c        | 5 ++---
 drivers/scsi/fnic/fnic_scsi.c | 1 -
 drivers/scsi/scsi_lib.c       | 4 ----
 include/scsi/scsi_cmnd.h      | 2 --
 4 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index a0c8c5d..cb68089 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -1527,7 +1527,6 @@ part2:
 	tmp[0] = IDENTIFY(((instance->irq == SCSI_IRQ_NONE) ? 0 : 1), cmd->device->lun);
 
 	len = 1;
-	cmd->tag = 0;
 
 	/* Send message(s) */
 	data = tmp;
@@ -2563,7 +2562,7 @@ static void NCR5380_reselect(struct Scsi_Host *instance) {
 		do_abort(instance);
 	} else {
 		hostdata->connected = tmp;
-		dprintk(NDEBUG_RESELECTION, "scsi%d : nexus established, target = %d, lun = %llu, tag = %d\n", instance->host_no, tmp->device->id, tmp->device->lun, tmp->tag);
+		dprintk(NDEBUG_RESELECTION, "scsi%d : nexus established, target = %d, lun = %llu, tag = %d\n", instance->host_no, tmp->device->id, tmp->device->lun, tmp->request->tag);
 	}
 }
 
@@ -2748,7 +2747,7 @@ static int NCR5380_abort(Scsi_Cmnd * cmd) {
 		if (cmd == tmp) {
 			dprintk(NDEBUG_ABORT, "scsi%d : aborting disconnected command.\n", instance->host_no);
 
-			if (NCR5380_select(instance, cmd, (int) cmd->tag))
+			if (NCR5380_select(instance, cmd, cmd->request->tag))
 				return FAILED;
 			dprintk(NDEBUG_ABORT, "scsi%d : nexus reestablished.\n", instance->host_no);
 
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 961bdf5..e54ace9 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -2137,7 +2137,6 @@ fnic_scsi_host_start_tag(struct fnic *fnic, struct scsi_cmnd *sc)
 
 	bqt->tag_index[tag] = sc->request;
 	sc->request->tag = tag;
-	sc->tag = tag;
 	if (!sc->request->special)
 		sc->request->special = sc;
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b9a8ddd..a7d4d93 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1191,8 +1191,6 @@ static struct scsi_cmnd *scsi_get_cmd_from_req(struct scsi_device *sdev,
 		cmd = req->special;
 	}
 
-	/* pull a tag out of the request if we have one */
-	cmd->tag = req->tag;
 	cmd->request = req;
 
 	cmd->cmnd = req->cmd;
@@ -1808,8 +1806,6 @@ static int scsi_mq_prep_fn(struct request *req)
 	cmd->device = sdev;
 	cmd->sense_buffer = sense_buf;
 
-	cmd->tag = req->tag;
-
 	cmd->cmnd = req->cmd;
 	cmd->prot_op = SCSI_PROT_NORMAL;
 
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 73f3490..45c9eb0 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -130,8 +130,6 @@ struct scsi_cmnd {
 					 * to be at an address < 16Mb). */
 
 	int result;		/* Status code from lower level driver */
-
-	unsigned char tag;	/* SCSI-II queued command tag */
 };
 
 /*
-- 
1.8.5.2

