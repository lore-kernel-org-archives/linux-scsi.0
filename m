From: Pete Wyckoff <pw@osc.edu>
Subject: [PATCH] iscsi tcp set queue dma alignment to zero
Date: Thu, 1 Mar 2007 17:20:21 -0500
Message-ID: <20070301222021.GB20922@osc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from quasar.osc.edu ([192.148.249.15]:52384 "EHLO quasar.osc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030453AbXCAWUW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Mar 2007 17:20:22 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-scsi@vger.kernel.org

Add a slave_configure function to iSCSI TCP to remove any DMA
alignment restriction.  This permits the use of direct IO from
arbitrary addresses.

Signed-off-by: Pete Wyckoff <pw@osc.edu>
---
 drivers/scsi/iscsi_tcp.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 4376840..f48eedd 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -2132,6 +2132,16 @@ static void iscsi_tcp_session_destroy(struct iscsi_cls_session *cls_session)
 	iscsi_session_teardown(cls_session);
 }
 
+/*
+ * New device attached.  Turn off the DMA alignment restriction on
+ * the request queue.
+ */
+static int iscsi_tcp_slave_configure(struct scsi_device *sdev)
+{
+	blk_queue_dma_alignment(sdev->request_queue, 0);
+	return 0;
+}
+
 static struct scsi_host_template iscsi_sht = {
 	.name			= "iSCSI Initiator over TCP/IP",
 	.queuecommand           = iscsi_queuecommand,
@@ -2142,6 +2152,7 @@ static struct scsi_host_template iscsi_sht = {
 	.eh_abort_handler       = iscsi_eh_abort,
 	.eh_host_reset_handler	= iscsi_eh_host_reset,
 	.use_clustering         = DISABLE_CLUSTERING,
+	.slave_configure        = iscsi_tcp_slave_configure,
 	.proc_name		= "iscsi_tcp",
 	.this_id		= -1,
 };
-- 
1.5.0.2

