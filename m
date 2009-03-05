From: michaelc@cs.wisc.edu
Subject: [PATCH 02/14] iscsi tcp: bidi capable
Date: Thu,  5 Mar 2009 14:45:56 -0600
Message-ID: <12362859702687-git-send-email-michaelc@cs.wisc.edu>
References: <12362859683749-git-send-email-michaelc@cs.wisc.edu>
 <12362859693831-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:52838 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755136AbZCEUqX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Mar 2009 15:46:23 -0500
In-Reply-To: <12362859693831-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Pete Wyckoff <pw@padd.com>, Boaz Harrosh <bharrosh@panasas.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Pete Wyckoff <pw@padd.com>

Mark iscsi_tcp as being capable of bidirectional transfers.  The
bsg interface checks this bit before attempting any bidirectional
commands.

Signed-off-by: Pete Wyckoff <pw@padd.com>
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 23808df..5a08ca4 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -813,6 +813,12 @@ static void iscsi_sw_tcp_session_destroy(struct iscsi_cls_session *cls_session)
 	iscsi_host_free(shost);
 }
 
+static int iscsi_sw_tcp_slave_alloc(struct scsi_device *sdev)
+{
+	set_bit(QUEUE_FLAG_BIDI, &sdev->request_queue->queue_flags);
+	return 0;
+}
+
 static int iscsi_sw_tcp_slave_configure(struct scsi_device *sdev)
 {
 	blk_queue_bounce_limit(sdev->request_queue, BLK_BOUNCE_ANY);
@@ -833,6 +839,7 @@ static struct scsi_host_template iscsi_sw_tcp_sht = {
 	.eh_device_reset_handler= iscsi_eh_device_reset,
 	.eh_target_reset_handler= iscsi_eh_target_reset,
 	.use_clustering         = DISABLE_CLUSTERING,
+	.slave_alloc            = iscsi_sw_tcp_slave_alloc,
 	.slave_configure        = iscsi_sw_tcp_slave_configure,
 	.proc_name		= "iscsi_tcp",
 	.this_id		= -1,
-- 
1.6.0.6

