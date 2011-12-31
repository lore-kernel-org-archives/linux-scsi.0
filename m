From: Xi Wang <xi.wang@gmail.com>
Subject: [PATCH] iscsi_tcp: bound max_r2t in iscsi_sw_tcp_conn_set_param()
Date: Sat, 31 Dec 2011 17:01:07 -0500
Message-ID: <1325368867-13696-1-git-send-email-xi.wang@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:45893 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab1LaWC7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 31 Dec 2011 17:02:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, Xi Wang <xi.wang@gmail.com>, stable@vger.kernel.org

A large max_r2t could lead to integer overflow in subsequent call to
iscsi_tcp_r2tpool_alloc(), allocating a smaller buffer than expected
and leading to out-of-bounds write.

Signed-off-by: Xi Wang <xi.wang@gmail.com>
Cc: stable@vger.kernel.org
---
 drivers/scsi/iscsi_tcp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 7c34d8e..9a1bf21 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -687,7 +687,7 @@ static int iscsi_sw_tcp_conn_set_param(struct iscsi_cls_conn *cls_conn,
 	struct iscsi_session *session = conn->session;
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
-	int value;
+	int value = 0;
 
 	switch(param) {
 	case ISCSI_PARAM_HDRDGST_EN:
@@ -700,7 +700,7 @@ static int iscsi_sw_tcp_conn_set_param(struct iscsi_cls_conn *cls_conn,
 		break;
 	case ISCSI_PARAM_MAX_R2T:
 		sscanf(buf, "%d", &value);
-		if (value <= 0 || !is_power_of_2(value))
+		if (value <= 0 || value > 65536 || !is_power_of_2(value))
 			return -EINVAL;
 		if (session->max_r2t == value)
 			break;
-- 
1.7.5.4

