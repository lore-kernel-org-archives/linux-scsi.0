From: michaelc@cs.wisc.edu
Subject: [PATCH 1/4] iscsi_tcp: change & to &&
Date: Fri,  9 Apr 2010 22:07:36 -0500
Message-ID: <1270868859-5147-2-git-send-email-michaelc@cs.wisc.edu>
References: <1270868859-5147-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754903Ab0DJDHu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Apr 2010 23:07:50 -0400
In-Reply-To: <1270868859-5147-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dan Carpenter <error27@gmail.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Dan Carpenter <error27@gmail.com>

This change is basically a clean up.

datadgst_en is an int which comes from the user.  I didn't see anything
limiting it to 1 and 0 although obviously that's what it's supposed to
be.  If the user passed in 2 this test would fail.

This same if condition is repeated in another function and it uses &&
there.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi_tcp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index 5c92620..8eeb39f 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -421,7 +421,7 @@ iscsi_tcp_data_recv_prep(struct iscsi_tcp_conn *tcp_conn)
 	struct iscsi_conn *conn = tcp_conn->iscsi_conn;
 	struct hash_desc *rx_hash = NULL;
 
-	if (conn->datadgst_en &
+	if (conn->datadgst_en &&
 	    !(conn->session->tt->caps & CAP_DIGEST_OFFLOAD))
 		rx_hash = tcp_conn->rx_hash;
 
-- 
1.6.6.1

