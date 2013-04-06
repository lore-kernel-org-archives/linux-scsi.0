From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH V2 10/18] be2iscsi: Fix the Port Link Status issue
Date: Fri,  5 Apr 2013 20:38:30 -0700
Message-ID: <1365219519-3457-10-git-send-email-jayamohan.kallickal@emulex.com>
References: <1365219519-3457-1-git-send-email-jayamohan.kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:58946 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1163203Ab3DFDjD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Apr 2013 23:39:03 -0400
Received: by mail-pb0-f42.google.com with SMTP id up7so2312674pbc.15
        for <linux-scsi@vger.kernel.org>; Fri, 05 Apr 2013 20:39:02 -0700 (PDT)
In-Reply-To: <1365219519-3457-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

 Check the Logical Link status also as part of the port link status.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_cmds.c |   26 +++++++++++---------------
 drivers/scsi/be2iscsi/be_cmds.h |    6 +++++-
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index 4f3c93a..efd29ab 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -348,30 +348,26 @@ static void be2iscsi_fail_session(struct iscsi_cls_session *cls_session)
 void beiscsi_async_link_state_process(struct beiscsi_hba *phba,
 		struct be_async_event_link_state *evt)
 {
-	switch (evt->port_link_status) {
-	case ASYNC_EVENT_LINK_DOWN:
+	if ((evt->port_link_status == ASYNC_EVENT_LINK_DOWN) ||
+	    ((evt->port_link_status & ASYNC_EVENT_LOGICAL) &&
+	     (evt->port_fault != BEISCSI_PHY_LINK_FAULT_NONE))) {
+		phba->state = BE_ADAPTER_LINK_DOWN;
+
 		beiscsi_log(phba, KERN_ERR,
 			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_INIT,
-			    "BC_%d : Link Down on Physical Port %d\n",
+			    "BC_%d : Link Down on Port %d\n",
 			    evt->physical_port);
 
-		phba->state |= BE_ADAPTER_LINK_DOWN;
 		iscsi_host_for_each_session(phba->shost,
 					    be2iscsi_fail_session);
-		break;
-	case ASYNC_EVENT_LINK_UP:
+	} else if ((evt->port_link_status & ASYNC_EVENT_LINK_UP) ||
+		    ((evt->port_link_status & ASYNC_EVENT_LOGICAL) &&
+		     (evt->port_fault == BEISCSI_PHY_LINK_FAULT_NONE))) {
 		phba->state = BE_ADAPTER_UP;
+
 		beiscsi_log(phba, KERN_ERR,
 			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_INIT,
-			    "BC_%d : Link UP on Physical Port %d\n",
-			    evt->physical_port);
-		break;
-	default:
-		beiscsi_log(phba, KERN_ERR,
-			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_INIT,
-			    "BC_%d : Unexpected Async Notification %d on"
-			    "Physical Port %d\n",
-			    evt->port_link_status,
+			    "BC_%d : Link UP on Port %d\n",
 			    evt->physical_port);
 	}
 }
diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index 9b64b36..97871cc 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -122,7 +122,8 @@ struct be_async_event_trailer {
 
 enum {
 	ASYNC_EVENT_LINK_DOWN = 0x0,
-	ASYNC_EVENT_LINK_UP = 0x1
+	ASYNC_EVENT_LINK_UP = 0x1,
+	ASYNC_EVENT_LOGICAL = 0x2
 };
 
 /**
@@ -134,6 +135,9 @@ struct be_async_event_link_state {
 	u8 port_link_status;
 	u8 port_duplex;
 	u8 port_speed;
+#define BEISCSI_PHY_LINK_FAULT_NONE	0x00
+#define BEISCSI_PHY_LINK_FAULT_LOCAL	0x01
+#define BEISCSI_PHY_LINK_FAULT_REMOTE	0x02
 	u8 port_fault;
 	u8 rsvd0[7];
 	struct be_async_event_trailer trailer;
-- 
1.7.10.4

