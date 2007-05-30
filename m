From: michaelc@cs.wisc.edu
Subject: [PATCH 15/19] iscsi_tcp: remove DMA alignment restriction
Date: Wed, 30 May 2007 12:57:21 -0500
Message-ID: <11805478623536-git-send-email-michaelc@cs.wisc.edu>
References: <11805478452886-git-send-email-michaelc@cs.wisc.edu> <11805478461587-git-send-email-michaelc@cs.wisc.edu> <11805478472375-git-send-email-michaelc@cs.wisc.edu> <11805478483268-git-send-email-michaelc@cs.wisc.edu> <1180547849438-git-send-email-michaelc@cs.wisc.edu> <11805478511328-git-send-email-michaelc@cs.wisc.edu> <11805478523188-git-send-email-michaelc@cs.wisc.edu> <11805478531743-git-send-email-michaelc@cs.wisc.edu> <11805478543860-git-send-email-michaelc@cs.wisc.edu> <11805478564182-git-send-email-michaelc@cs.wisc.edu> <1180547857548-git-send-email-michaelc@cs.wisc.edu> <118054785852-git-send-email-michaelc@cs.wisc.edu> <11805478592848-git-send-email-michaelc@cs.wisc.edu> <11805478601019-git-send-email-michaelc@cs.wisc.edu> <11805478611832-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754593AbXE3R5u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 May 2007 13:57:50 -0400
In-Reply-To: <11805478611832-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, Pete Wyckoff <pw@osc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Add a slave_configure function to iSCSI TCP to remove any DMA
alignment restriction.  This permits the use of direct IO from
arbitrary addresses.

Signed-off-by: Pete Wyckoff <pw@osc.edu>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 6eaa2e3..4e9f0d9 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -36,6 +36,7 @@ #include <linux/kfifo.h>
 #include <linux/scatterlist.h>
 #include <net/tcp.h>
 #include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_transport_iscsi.h>
@@ -2184,6 +2185,12 @@ static void iscsi_tcp_session_destroy(st
 	iscsi_session_teardown(cls_session);
 }
 
+static int iscsi_tcp_slave_configure(struct scsi_device *sdev)
+{
+	blk_queue_dma_alignment(sdev->request_queue, 0);
+	return 0;
+}
+
 static struct scsi_host_template iscsi_sht = {
 	.name			= "iSCSI Initiator over TCP/IP",
 	.queuecommand           = iscsi_queuecommand,
@@ -2195,6 +2202,7 @@ static struct scsi_host_template iscsi_s
 	.eh_abort_handler       = iscsi_eh_abort,
 	.eh_host_reset_handler	= iscsi_eh_host_reset,
 	.use_clustering         = DISABLE_CLUSTERING,
+	.slave_configure        = iscsi_tcp_slave_configure,
 	.proc_name		= "iscsi_tcp",
 	.this_id		= -1,
 };
-- 
1.4.1.1

