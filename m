From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH] iscsi tcp: bidi capable
Date: Tue, 20 Jan 2009 16:02:18 +0200
Message-ID: <4975D96A.6020407@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:3144 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751902AbZATOCW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Jan 2009 09:02:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pete Wyckoff <pw@padd.com>, Mike Christie <michaelc@cs.wisc.edu>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>, open-iscsi@googlegroups.com

From: Pete Wyckoff <pw@padd.com>

Mark iscsi_tcp as being capable of bidirectional transfers.  The
bsg interface checks this bit before attempting any bidirectional
commands.

Signed-off-by: Pete Wyckoff <pw@padd.com>
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/iscsi_tcp.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index af092a8..9e2d4fb 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -806,6 +806,12 @@ static void iscsi_sw_tcp_session_destroy(struct iscsi_cls_session *cls_session)
 	iscsi_host_free(shost);
 }
 
+static int iscsi_tcp_slave_alloc(struct scsi_device *sdev)
+{
+	set_bit(QUEUE_FLAG_BIDI, &sdev->request_queue->queue_flags);
+	return 0;
+}
+
 static int iscsi_sw_tcp_slave_configure(struct scsi_device *sdev)
 {
 	blk_queue_bounce_limit(sdev->request_queue, BLK_BOUNCE_ANY);
@@ -826,6 +832,7 @@ static struct scsi_host_template iscsi_sw_tcp_sht = {
 	.eh_device_reset_handler= iscsi_eh_device_reset,
 	.eh_target_reset_handler= iscsi_eh_target_reset,
 	.use_clustering         = DISABLE_CLUSTERING,
+	.slave_alloc            = iscsi_tcp_slave_alloc,
 	.slave_configure        = iscsi_sw_tcp_slave_configure,
 	.proc_name		= "iscsi_tcp",
 	.this_id		= -1,
-- 
1.6.0.1

