From: michaelc@cs.wisc.edu
Subject: [PATCH 1/1] libiscsi: fix potential buffer overrun in __iscsi_conn_send_pdu
Date: Wed,  3 Sep 2014 00:00:39 -0500
Message-ID: <1409720439-6226-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:48856 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045AbaICFAy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Sep 2014 01:00:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This patches fixes a potential buffer overrun in __iscsi_conn_send_pdu.
This function is used by iscsi drivers and userspace to send iscsi PDUs/
commands. For login commands, we have a set buffer size. For all other
commands we do not support data buffers.

This was reported by Dan Carpenter here:
http://www.spinics.net/lists/linux-scsi/msg66838.html

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

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
 
-- 
1.7.1

