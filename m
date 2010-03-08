From: Dan Carpenter <error27@gmail.com>
Subject: [patch] iscsi: change & to &&
Date: Mon, 8 Mar 2010 15:21:57 +0300
Message-ID: <20100308122157.GI6469@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:60739 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112Ab0CHMWU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Mar 2010 07:22:20 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, Andrew Morton <akpm@linux-foundation.org>, Stefani Seibold <stefani@seibold.net>, Andi Kleen <ak@linux.intel.com>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

This change is basically a clean up.

datadgst_en is an int which comes from the user.  I didn't see anything
limiting it to 1 and 0 although obviously that's what it's supposed to 
be.  If the user passed in 2 this test would fail.

This same if condition is repeated in another function and it uses && 
there.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index 4ad87fd..3794d29 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -420,7 +420,7 @@ iscsi_tcp_data_recv_prep(struct iscsi_tcp_conn *tcp_conn)
 	struct iscsi_conn *conn = tcp_conn->iscsi_conn;
 	struct hash_desc *rx_hash = NULL;
 
-	if (conn->datadgst_en &
+	if (conn->datadgst_en &&
 	    !(conn->session->tt->caps & CAP_DIGEST_OFFLOAD))
 		rx_hash = tcp_conn->rx_hash;
 
