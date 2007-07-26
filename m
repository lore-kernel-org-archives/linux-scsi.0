From: michaelc@cs.wisc.edu
Subject: [PATCH 3/4] Turn off bounce buffers for iscsi_tcp
Date: Thu, 26 Jul 2007 12:46:47 -0500
Message-ID: <1185472013785-git-send-email-michaelc@cs.wisc.edu>
References: <11854720083011-git-send-email-michaelc@cs.wisc.edu>
 <1185472010604-git-send-email-michaelc@cs.wisc.edu>
 <11854720113567-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36401 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932360AbXGZRrE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jul 2007 13:47:04 -0400
In-Reply-To: <11854720113567-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

It was found by LSI that on setups with large amounts of memory
we were bouncing buffers when we did not need to. If the iscsi tcp
code touches the data buffer (or a helper does),
it will kmap the buffer. iscsi_tcp also does not interact with hardware,
so it does not have any hw dma restrictions. This patch sets the bounce
buffer settings for our device queue so buffers should not be bounced
because of a driver limit.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 93034b4..a21455d 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -2216,6 +2216,7 @@ static void iscsi_tcp_session_destroy(struct iscsi_cls_session *cls_session)
 
 static int iscsi_tcp_slave_configure(struct scsi_device *sdev)
 {
+	blk_queue_bounce_limit(sdev->request_queue, BLK_BOUNCE_ANY);
 	blk_queue_dma_alignment(sdev->request_queue, 0);
 	return 0;
 }
-- 
1.5.1.2

