From: michaelc@cs.wisc.edu
Subject: [PATCH 07/13] libiscsi_tcp: update recv tracking for each skb instead of iscsi pdu
Date: Wed, 13 May 2009 17:57:44 -0500
Message-ID: <12422554742374-git-send-email-michaelc@cs.wisc.edu>
References: <12422554702856-git-send-email-michaelc@cs.wisc.edu>
 <12422554711659-git-send-email-michaelc@cs.wisc.edu>
 <12422554711865-git-send-email-michaelc@cs.wisc.edu>
 <1242255472240-git-send-email-michaelc@cs.wisc.edu>
 <12422554724154-git-send-email-michaelc@cs.wisc.edu>
 <12422554733484-git-send-email-michaelc@cs.wisc.edu>
 <12422554731307-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:51841 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762106AbZEMW5z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 May 2009 18:57:55 -0400
In-Reply-To: <12422554731307-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Everytime we read in a pdu libiscsi will update a tracking field.
It uses this to decide when to check if the transport might be bad.
If we have not got data in recv_timeout seconds then we will
send a iscsi ping/nop.

If we are on a slow link then it could take a while to read in all
the data for a data_in. In that case we might send a ping/nop when
we do not need to or we might drop a session thinking it is bad
when the lower layer is making forward progress on it.

This patch has libiscsi_tcp update the recv tracking for each skb
(basically network packet from our point of view) instead of the
entire iscsi pdu+data, so we account for these cases where data is
coming in slowly.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi_tcp.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index db93cd0..b84a1d8 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -863,6 +863,12 @@ int iscsi_tcp_recv_skb(struct iscsi_conn *conn, struct sk_buff *skb,
 	int rc = 0;
 
 	ISCSI_DBG_TCP(conn, "in %d bytes\n", skb->len - offset);
+	/*
+	 * Update for each skb instead of pdu, because over slow networks a
+	 * data_in's data could take a while to read in. We also want to
+	 * account for r2ts.
+	 */
+	conn->last_recv = jiffies;
 
 	if (unlikely(conn->suspend_rx)) {
 		ISCSI_DBG_TCP(conn, "Rx suspended!\n");
-- 
1.5.2.1

