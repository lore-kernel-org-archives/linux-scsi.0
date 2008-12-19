From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PATCH] SCSI bug fixes for 2.6.28-rc9
Date: Fri, 19 Dec 2008 10:26:06 -0500
Message-ID: <1229700366.3393.83.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:48746 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751150AbYLSPZ7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Dec 2008 10:25:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

These should hopefully address the major bugzilla issues in SCSI.  They
fix several oopses, including the remaining block timer related ones.
The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

Brian King (1):
      ibmvstgt: move crq_queue_create to the end of initialization

Hillier, Gernot (1):
      aacraid: disable Dell Percraid quirk on Adaptec 2200S and 2120S

James Bottomley (2):
      mpt fusion: clear list of outstanding commands on host reset
      scsi_lib: only call scsi_unprep_request() under queue lock

Mike Christie (1):
      libiscsi REGRESSION: fix passthrough support with older iscsi tools

The diffstat:

 drivers/message/fusion/mptscsih.c |    3 +++
 drivers/scsi/aacraid/linit.c      |    4 ++--
 drivers/scsi/ibmvscsi/ibmvstgt.c  |   16 +++++++++-------
 drivers/scsi/libiscsi.c           |   11 +++++------
 drivers/scsi/scsi_lib.c           |    2 +-
 5 files changed, 20 insertions(+), 16 deletions(-)

and the full diff is below.

James

---

diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index d62fd4f..ee09041 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -2008,6 +2008,9 @@ mptscsih_host_reset(struct scsi_cmnd *SCpnt)
 		return FAILED;
 	}
 
+	/* make sure we have no outstanding commands at this stage */
+	mptscsih_flush_running_cmds(hd);
+
 	ioc = hd->ioc;
 	printk(MYIOC_s_INFO_FMT "attempting host reset! (sc=%p)\n",
 	    ioc->name, SCpnt);
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 162cd92..94acbee 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -175,8 +175,8 @@ static struct aac_driver_ident aac_drivers[] = {
 	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* PERC 3/Di (Boxster/PERC3DiB) */
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "catapult        ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* catapult */
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "tomcat          ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* tomcat */
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2120S   ", 1, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* Adaptec 2120S (Crusader) */
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2200S   ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* Adaptec 2200S (Vulcan) */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2120S   ", 1, AAC_QUIRK_31BIT | AAC_QUIRK_34SG },		      /* Adaptec 2120S (Crusader) */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2200S   ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG },		      /* Adaptec 2200S (Vulcan) */
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2200S   ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* Adaptec 2200S (Vulcan-2m) */
 	{ aac_rx_init, "aacraid",  "Legend  ", "Legend S220     ", 1, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* Legend S220 (Legend Crusader) */
 	{ aac_rx_init, "aacraid",  "Legend  ", "Legend S230     ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* Legend S230 (Legend Vulcan) */
diff --git a/drivers/scsi/ibmvscsi/ibmvstgt.c b/drivers/scsi/ibmvscsi/ibmvstgt.c
index 2a5b29d..e2dd6a4 100644
--- a/drivers/scsi/ibmvscsi/ibmvstgt.c
+++ b/drivers/scsi/ibmvscsi/ibmvstgt.c
@@ -864,21 +864,23 @@ static int ibmvstgt_probe(struct vio_dev *dev, const struct vio_device_id *id)
 
 	INIT_WORK(&vport->crq_work, handle_crq);
 
-	err = crq_queue_create(&vport->crq_queue, target);
+	err = scsi_add_host(shost, target->dev);
 	if (err)
 		goto free_srp_target;
 
-	err = scsi_add_host(shost, target->dev);
+	err = scsi_tgt_alloc_queue(shost);
 	if (err)
-		goto destroy_queue;
+		goto remove_host;
 
-	err = scsi_tgt_alloc_queue(shost);
+	err = crq_queue_create(&vport->crq_queue, target);
 	if (err)
-		goto destroy_queue;
+		goto free_queue;
 
 	return 0;
-destroy_queue:
-	crq_queue_destroy(target);
+free_queue:
+	scsi_tgt_free_queue(shost);
+remove_host:
+	scsi_remove_host(shost);
 free_srp_target:
 	srp_target_free(target);
 put_host:
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 801c7cf..3fdee73 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -489,12 +489,6 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		if (!__kfifo_get(session->cmdpool.queue,
 				 (void*)&task, sizeof(void*)))
 			return NULL;
-
-		if ((hdr->opcode == (ISCSI_OP_NOOP_OUT | ISCSI_OP_IMMEDIATE)) &&
-		     hdr->ttt == RESERVED_ITT) {
-			conn->ping_task = task;
-			conn->last_ping = jiffies;
-		}
 	}
 	/*
 	 * released in complete pdu for task we expect a response for, and
@@ -703,6 +697,11 @@ static void iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
 	task = __iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)&hdr, NULL, 0);
 	if (!task)
 		iscsi_conn_printk(KERN_ERR, conn, "Could not send nopout\n");
+	else if (!rhdr) {
+		/* only track our nops */
+		conn->ping_task = task;
+		conn->last_ping = jiffies;
+	}
 }
 
 static int iscsi_handle_reject(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index fa45a1a..148d3af 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -648,8 +648,8 @@ static void scsi_requeue_command(struct request_queue *q, struct scsi_cmnd *cmd)
 	struct request *req = cmd->request;
 	unsigned long flags;
 
-	scsi_unprep_request(req);
 	spin_lock_irqsave(q->queue_lock, flags);
+	scsi_unprep_request(req);
 	blk_requeue_request(q, req);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 


