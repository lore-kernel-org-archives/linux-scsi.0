From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 3.17-rc5
Date: Fri, 19 Sep 2014 14:56:47 +0100
Message-ID: <1411135007.3764.24.camel@jarvis.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is a set of three fixes.  One represents a nasty shared tag map
regression (another inverted condition) caused by recent SCSI MQ
patches, one is a longstanding potential buffer overrun in the iscsi
data buffer and the final one is a use after free for the rare
bidirectional commands.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Christoph Hellwig (1):
      fix regression that accidentally disabled block-based tcq

Daniel Gryniewicz (1):
      fix for bidi use after free

Mike Christie (1):
      libiscsi: fix potential buffer overrun in __iscsi_conn_send_pdu

And the diffstat:

 drivers/scsi/libiscsi.c | 10 ++++++++++
 drivers/scsi/scsi_lib.c |  5 +++--
 include/scsi/scsi_tcq.h |  2 +-
 3 files changed, 14 insertions(+), 3 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index ea025e4..191b597 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -717,11 +717,21 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 			return NULL;
 		}
 
+		if (data_size > ISCSI_DEF_MAX_RECV_SEG_LEN) {
+			iscsi_conn_printk(KERN_ERR, conn, "Invalid buffer len of %u for login task. Max len is %u\n", data_size, ISCSI_DEF_MAX_RECV_SEG_LEN);
+			return NULL;
+		}
+
 		task = conn->login_task;
 	} else {
 		if (session->state != ISCSI_STATE_LOGGED_IN)
 			return NULL;
 
+		if (data_size != 0) {
+			iscsi_conn_printk(KERN_ERR, conn, "Can not send data buffer of len %u for op 0x%x\n", data_size, opcode);
+			return NULL;
+		}
+
 		BUG_ON(conn->c_stage == ISCSI_CONN_INITIAL_STAGE);
 		BUG_ON(conn->c_stage == ISCSI_CONN_STOPPED);
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d837dc1..aaea4b9 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -733,12 +733,13 @@ static bool scsi_end_request(struct request *req, int error,
 	} else {
 		unsigned long flags;
 
+		if (bidi_bytes)
+			scsi_release_bidi_buffers(cmd);
+
 		spin_lock_irqsave(q->queue_lock, flags);
 		blk_finish_request(req, error);
 		spin_unlock_irqrestore(q->queue_lock, flags);
 
-		if (bidi_bytes)
-			scsi_release_bidi_buffers(cmd);
 		scsi_release_buffers(cmd);
 		scsi_next_command(cmd);
 	}
diff --git a/include/scsi/scsi_tcq.h b/include/scsi/scsi_tcq.h
index cdcc90b..e645835 100644
--- a/include/scsi/scsi_tcq.h
+++ b/include/scsi/scsi_tcq.h
@@ -68,7 +68,7 @@ static inline void scsi_activate_tcq(struct scsi_device *sdev, int depth)
 		return;
 
 	if (!shost_use_blk_mq(sdev->host) &&
-	    blk_queue_tagged(sdev->request_queue))
+	    !blk_queue_tagged(sdev->request_queue))
 		blk_queue_init_tags(sdev->request_queue, depth,
 				    sdev->host->bqt);
 
