From: Pete Wyckoff <pw@osc.edu>
Subject: [PATCH] iscsi: avoid oops when destroying unbound connection
Date: Sun, 29 Oct 2006 20:29:12 -0500
Message-ID: <20061030012912.GA12233@osc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from quasar.osc.edu ([192.148.249.15]:49569 "EHLO quasar.osc.edu")
	by vger.kernel.org with ESMTP id S1030470AbWJ3B3O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Oct 2006 20:29:14 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Initialize the conn->item list head in a connection, used for
associating it with a session, to avoid an oops if list_del happens
before the connection is bound.  The oops is easy enough to
reproduce by calling CREATE_SESSION, CREATE_CONN, then DESTROY_CONN
(but no BIND_CONN) from userspace.

Signed-off-by: Pete Wyckoff <pw@osc.edu>
---
 drivers/scsi/libiscsi.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index c542d0e..66fc239 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1477,6 +1477,7 @@ iscsi_conn_setup(struct iscsi_cls_sessio
 	INIT_LIST_HEAD(&conn->run_list);
 	INIT_LIST_HEAD(&conn->mgmt_run_list);
 	INIT_LIST_HEAD(&conn->xmitqueue);
+	INIT_LIST_HEAD(&conn->item);
 
 	/* initialize general immediate & non-immediate PDU commands queue */
 	conn->immqueue = kfifo_alloc(session->mgmtpool_max * sizeof(void*),
