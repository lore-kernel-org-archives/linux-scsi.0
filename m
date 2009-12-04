From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 12/15] be2iscsi: The session failure only when Link Goes
 down
Date: Fri, 4 Dec 2009 08:55:53 +0530
Message-ID: <20091204032544.GA6275@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:6966 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754877AbZLDDZi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Dec 2009 22:25:38 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

   This fixes a situation where the sessions were being killed whenever
LinkUP is notified rather than LinkDown

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_cmds.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index d009285..9d80729 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -161,13 +161,13 @@ void beiscsi_async_link_state_process(struct beiscsi_hba *phba,
 		SE_DEBUG(DBG_LVL_1, "Link Down on Physical Port %d \n",
 						evt->physical_port);
 		phba->state |= BE_ADAPTER_LINK_DOWN;
+		iscsi_host_for_each_session(phba->shost,
+					    be2iscsi_fail_session);
 		break;
 	case ASYNC_EVENT_LINK_UP:
 		phba->state = BE_ADAPTER_UP;
 		SE_DEBUG(DBG_LVL_1, "Link UP on Physical Port %d \n",
 						evt->physical_port);
-		iscsi_host_for_each_session(phba->shost,
-					    be2iscsi_fail_session);
 		break;
 	default:
 		SE_DEBUG(DBG_LVL_1, "Unexpected Async Notification %d on"
-- 
1.6.4

