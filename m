From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 22/22] fcoe: set default TC priority
Date: Wed,  3 Aug 2016 15:13:22 +0200
Message-ID: <1470230002-37737-23-git-send-email-hare@suse.de>
References: <1470230002-37737-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40162 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756040AbcHCNNg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Aug 2016 09:13:36 -0400
In-Reply-To: <1470230002-37737-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, Chad Dupuis <chad.dupuis@qlogic.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

If DCB is not enabled or compiled in we still should be setting
a sane default priority. So put FCoE frames in priority class
'interactive' and FIP frames in priority class 'besteffort'.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/fcoe/fcoe.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index c907661..f8ec94a 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -2168,6 +2168,8 @@ static bool fcoe_match(struct net_device *netdev)
  */
 static void fcoe_dcb_create(struct fcoe_interface *fcoe)
 {
+	int ctrl_prio = TC_PRIO_BESTEFFORT;
+	int fcoe_prio = TC_PRIO_INTERACTIVE;
 #ifdef CONFIG_DCB
 	int dcbx;
 	u8 fup, up;
@@ -2194,10 +2196,13 @@ static void fcoe_dcb_create(struct fcoe_interface *fcoe)
 			fup = dcb_getapp(netdev, &app);
 		}
 
-		fcoe->priority = ffs(up) ? ffs(up) - 1 : 0;
-		ctlr->priority = ffs(fup) ? ffs(fup) - 1 : fcoe->priority;
+		fcoe_prio = ffs(up) ? ffs(up) - 1 : 0;
+		ctlr_prio = ffs(fup) ? ffs(fup) - 1 : fcoe_prio;
+		prio_set = true;
 	}
 #endif
+	fcoe->priority = fcoe_prio;
+	ctlr->priority = ctlr_prio;
 }
 
 enum fcoe_create_link_state {
-- 
1.8.5.6

