From: michaelc@cs.wisc.edu
Subject: [PATCH 4/7] use atomic for session_nr allocations
Date: Wed, 28 Feb 2007 17:32:18 -0600
Message-ID: <1172705544330-git-send-email-michaelc@cs.wisc.edu>
References: <1172705541949-git-send-email-michaelc@cs.wisc.edu> <11727055423762-git-send-email-michaelc@cs.wisc.edu> <11727055433394-git-send-email-michaelc@cs.wisc.edu> <1172705543740-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56844 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225AbXB1Xcg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Feb 2007 18:32:36 -0500
In-Reply-To: <1172705543740-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

qla4xxx and iscsi_tcp or iser could be creating
sessions at the same time, so make session_nr id
allocation atomic.
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_iscsi.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index ce0d14a..ff05c84 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -49,7 +49,7 @@ struct iscsi_internal {
 	struct class_device_attribute *session_attrs[ISCSI_SESSION_ATTRS + 1];
 };
 
-static int iscsi_session_nr;	/* sysfs session id for next new session */
+static atomic_t iscsi_session_nr; /* sysfs session id for next new session */
 
 /*
  * list of registered transports and lock that must
@@ -300,7 +300,7 @@ int iscsi_add_session(struct iscsi_cls_s
 	int err;
 
 	ihost = shost->shost_data;
-	session->sid = iscsi_session_nr++;
+	session->sid = atomic_add_return(1, &iscsi_session_nr);
 	session->target_id = target_id;
 
 	snprintf(session->dev.bus_id, BUS_ID_SIZE, "session%u",
@@ -1419,6 +1419,8 @@ static __init int iscsi_transport_init(v
 	printk(KERN_INFO "Loading iSCSI transport class v%s.\n",
 		ISCSI_TRANSPORT_VERSION);
 
+	atomic_set(&iscsi_session_nr, 0);
+
 	err = class_register(&iscsi_transport_class);
 	if (err)
 		return err;
-- 
1.4.1.1

