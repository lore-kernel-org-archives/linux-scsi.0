From: michaelc@cs.wisc.edu
Subject: [PATCH 10/17] iscsi class: remove unused active variable
Date: Wed, 16 Feb 2011 15:04:34 -0600
Message-ID: <1297890281-9076-11-git-send-email-michaelc@cs.wisc.edu>
References: <1297890281-9076-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754633Ab1BPVEh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Feb 2011 16:04:37 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1GL4bZG027075
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2011 16:04:37 -0500
Received: from meanminna.corp.redhat.com (vpn-11-254.rdu.redhat.com [10.11.11.254])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p1GL4Tsx004636
	for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2011 16:04:37 -0500
In-Reply-To: <1297890281-9076-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>

The active variable on the iscsi_cls_conn is not used
so this patch removes it.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_iscsi.c |    2 --
 include/scsi/scsi_transport_iscsi.h |    1 -
 2 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 4e09b68..a631e58 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -976,7 +976,6 @@ iscsi_create_conn(struct iscsi_cls_session *session, int dd_size, uint32_t cid)
 
 	spin_lock_irqsave(&connlock, flags);
 	list_add(&conn->conn_list, &connlist);
-	conn->active = 1;
 	spin_unlock_irqrestore(&connlock, flags);
 
 	ISCSI_DBG_TRANS_CONN(conn, "Completed conn creation\n");
@@ -1002,7 +1001,6 @@ int iscsi_destroy_conn(struct iscsi_cls_conn *conn)
 	unsigned long flags;
 
 	spin_lock_irqsave(&connlock, flags);
-	conn->active = 0;
 	list_del(&conn->conn_list);
 	spin_unlock_irqrestore(&connlock, flags);
 
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index b9ba349..00e5bf7 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -163,7 +163,6 @@ struct iscsi_cls_conn {
 	struct mutex ep_mutex;
 	struct iscsi_endpoint *ep;
 
-	int active;			/* must be accessed with the connlock */
 	struct device dev;		/* sysfs transport/container device */
 };
 
-- 
1.7.2.3

