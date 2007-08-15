From: Pete Wyckoff <pw@osc.edu>
Subject: [PATCH 2/3] iscsi tcp queue bidi
Date: Wed, 15 Aug 2007 14:16:29 -0500
Message-ID: <20070815191629.GC14977@osc.edu>
References: <20070815191523.GA14977@osc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from marge.padd.com ([66.127.62.138]:58092 "EHLO marge.padd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761800AbXHOT2Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Aug 2007 15:28:25 -0400
Content-Disposition: inline
In-Reply-To: <20070815191523.GA14977@osc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org

Mark queue_flags that bidirectional is acceptable for iscsi_tcp, as
BSG will check to make sure this bit is set.

Signed-off-by: Pete Wyckoff <pw@osc.edu>
---
 drivers/scsi/iscsi_tcp.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 35dd19f..8622930 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -2205,6 +2205,12 @@ static void iscsi_tcp_session_destroy(struct iscsi_cls_session *cls_session)
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
@@ -2224,6 +2230,7 @@ static struct scsi_host_template iscsi_sht = {
 	.eh_abort_handler       = iscsi_eh_abort,
 	.eh_host_reset_handler	= iscsi_eh_host_reset,
 	.use_clustering         = DISABLE_CLUSTERING,
+	.slave_alloc		= iscsi_tcp_slave_alloc,
 	.slave_configure        = iscsi_tcp_slave_configure,
 	.proc_name		= "iscsi_tcp",
 	.this_id		= -1,
-- 
1.5.2.4

