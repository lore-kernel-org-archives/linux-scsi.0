From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 25/30] fcoe: set default TC priority
Date: Fri, 26 Aug 2016 14:01:48 +0200
Message-ID: <1472212913-39810-26-git-send-email-hare@suse.de>
References: <1472212913-39810-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35220 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752401AbcHZMCN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Aug 2016 08:02:13 -0400
In-Reply-To: <1472212913-39810-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jth@kernel.org>, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, Martin Wilck <martin.wilck@suse.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

If DCB is not enabled or compiled in we still should be setting
a sane default priority. So put FCoE frames in priority class
'interactive' and FIP frames in priority class 'besteffort'.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/fcoe/fcoe.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 9bd41a3..81e7f99 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -2160,6 +2160,8 @@ static bool fcoe_match(struct net_device *netdev)
  */
 static void fcoe_dcb_create(struct fcoe_interface *fcoe)
 {
+	int ctlr_prio = TC_PRIO_BESTEFFORT;
+	int fcoe_prio = TC_PRIO_INTERACTIVE;
 #ifdef CONFIG_DCB
 	int dcbx;
 	u8 fup, up;
@@ -2186,10 +2188,12 @@ static void fcoe_dcb_create(struct fcoe_interface *fcoe)
 			fup = dcb_getapp(netdev, &app);
 		}
 
-		fcoe->priority = ffs(up) ? ffs(up) - 1 : 0;
-		ctlr->priority = ffs(fup) ? ffs(fup) - 1 : fcoe->priority;
+		fcoe_prio = ffs(up) ? ffs(up) - 1 : 0;
+		ctlr_prio = ffs(fup) ? ffs(fup) - 1 : fcoe_prio;
 	}
 #endif
+	fcoe->priority = fcoe_prio;
+	ctlr->priority = ctlr_prio;
 }
 
 enum fcoe_create_link_state {
-- 
1.8.5.6

