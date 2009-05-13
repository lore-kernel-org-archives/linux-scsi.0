From: michaelc@cs.wisc.edu
Subject: [PATCH 05/13] libiscsi: have iscsi_data_in_rsp call iscsi_update_cmdsn
Date: Wed, 13 May 2009 17:57:42 -0500
Message-ID: <12422554733484-git-send-email-michaelc@cs.wisc.edu>
References: <12422554702856-git-send-email-michaelc@cs.wisc.edu>
 <12422554711659-git-send-email-michaelc@cs.wisc.edu>
 <12422554711865-git-send-email-michaelc@cs.wisc.edu>
 <1242255472240-git-send-email-michaelc@cs.wisc.edu>
 <12422554724154-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:51823 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762056AbZEMW5z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 May 2009 18:57:55 -0400
In-Reply-To: <12422554724154-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This has iscsi_data_in_rsp call iscsi_update_cmdsn when a pdu is
completed like is done for other pdu's that are don.

For libiscsi_tcp, this means that it calls iscsi_update_cmdsn when
it is handling the pdu internally to only transfer data, but if there is
status then it does not need to call it since the completion handling
will do it.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c     |    1 +
 drivers/scsi/libiscsi_tcp.c |    8 +++++++-
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index a6e6eef..047543c 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -729,6 +729,7 @@ iscsi_data_in_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 	if (!(rhdr->flags & ISCSI_FLAG_DATA_STATUS))
 		return;
 
+	iscsi_update_cmdsn(conn->session, (struct iscsi_nopin *)hdr);
 	sc->result = (DID_OK << 16) | rhdr->cmd_status;
 	conn->exp_statsn = be32_to_cpu(rhdr->statsn) + 1;
 	if (rhdr->flags & (ISCSI_FLAG_DATA_UNDERFLOW |
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index b579ca9..db93cd0 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -473,7 +473,13 @@ static int iscsi_tcp_data_in(struct iscsi_conn *conn, struct iscsi_task *task)
 	int datasn = be32_to_cpu(rhdr->datasn);
 	unsigned total_in_length = scsi_in(task->sc)->length;
 
-	iscsi_update_cmdsn(conn->session, (struct iscsi_nopin*)rhdr);
+	/*
+	 * lib iscsi will update this in the completion handling if there
+	 * is status.
+	 */
+	if (!(rhdr->flags & ISCSI_FLAG_DATA_STATUS))
+		iscsi_update_cmdsn(conn->session, (struct iscsi_nopin*)rhdr);
+
 	if (tcp_conn->in.datalen == 0)
 		return 0;
 
-- 
1.5.2.1

