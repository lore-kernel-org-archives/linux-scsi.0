From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] fcoe: Fixup missing initialisation in fcoe_dcb_create()
Date: Tue, 18 Oct 2016 08:39:16 +0200
Message-ID: <1476772756-121774-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41003 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751428AbcJRGjZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Oct 2016 02:39:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Found by 0-day robot.

Fixes: a99ac6e715bc ("scsi: fcoe: set default TC priority")
Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/fcoe/fcoe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index cf4adaa..59150ca 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -2171,11 +2171,11 @@ static void fcoe_dcb_create(struct fcoe_interface *fcoe)
 {
 	int ctlr_prio = TC_PRIO_BESTEFFORT;
 	int fcoe_prio = TC_PRIO_INTERACTIVE;
+	struct fcoe_ctlr *ctlr = fcoe_to_ctlr(fcoe);
 #ifdef CONFIG_DCB
 	int dcbx;
 	u8 fup, up;
 	struct net_device *netdev = fcoe->realdev;
-	struct fcoe_ctlr *ctlr = fcoe_to_ctlr(fcoe);
 	struct dcb_app app = {
 				.priority = 0,
 				.protocol = ETH_P_FCOE
-- 
1.8.5.6

