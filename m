From: Pete Wyckoff <pw@osc.edu>
Subject: [PATCH 5/5] iscsi tcp bidi capable
Date: Sat, 22 Dec 2007 15:10:12 -0500
Message-ID: <20071222202001.B1919900CE1@quasar.osc.edu>
References: <20071222201558.GA25063@osc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from quasar.osc.edu ([192.148.249.15]:53855 "EHLO quasar.osc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234AbXLVUcF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Dec 2007 15:32:05 -0500
In-Reply-To: <20071222201558.GA25063@osc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>

Mark iscsi_tcp as being capable of bidirectional transfers.  Perhaps
instead we could remove the check in bsg, as that is the only entry
to SCSI that bothers to check the flag.

Signed-off-by: Pete Wyckoff <pw@osc.edu>
---
 drivers/scsi/iscsi_tcp.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 373639a..ecae470 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -1915,6 +1915,12 @@ static void iscsi_tcp_session_destroy(struct iscsi_cls_session *cls_session)
 	iscsi_session_teardown(cls_session);
 }
 
+static int iscsi_tcp_slave_alloc(struct scsi_device *sdev)
+{
+	set_bit(QUEUE_FLAG_BIDI, &sdev->request_queue->queue_flags);
+	return 0;
+}
+
 static int iscsi_tcp_slave_configure(struct scsi_device *sdev)
 {
 	blk_queue_bounce_limit(sdev->request_queue, BLK_BOUNCE_ANY);
@@ -1936,6 +1942,7 @@ static struct scsi_host_template iscsi_sht = {
 	.eh_host_reset_handler	= iscsi_eh_host_reset,
 	.use_clustering         = DISABLE_CLUSTERING,
 	.use_sg_chaining	= ENABLE_SG_CHAINING,
+	.slave_alloc		= iscsi_tcp_slave_alloc,
 	.slave_configure        = iscsi_tcp_slave_configure,
 	.proc_name		= "iscsi_tcp",
 	.this_id		= -1,
-- 
1.5.3.6

