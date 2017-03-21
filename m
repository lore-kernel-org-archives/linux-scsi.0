From: Alexander Eichner <Alexander.Eichner@oracle.com>
Subject: [PATCH] BusLogic: Prevent write reordering when writing outgoing mailboxes
Date: Tue, 21 Mar 2017 11:44:28 +0100
Message-ID: <20170321104428.27582-1-Alexander.Eichner@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51607 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755005AbdCUKqQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Mar 2017 06:46:16 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v2LAia70004087
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Tue, 21 Mar 2017 10:44:36 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v2LAiZfv031178
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Tue, 21 Mar 2017 10:44:36 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v2LAiZGH010184
        for <linux-scsi@vger.kernel.org>; Tue, 21 Mar 2017 10:44:35 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Alexander Eichner <Alexander.Eichner@oracle.com>

From: Alexander Eichner <Alexander.Eichner@oracle.com>

Make sure the compiler doesn't reorder the writes to the outgoing
mailbox because the correct order does matter. Otherwise the
controller might see a stale CCB handle under rare circumstances
if the action code is written first and the controller happens to
read the mailbox between the action code and CCB handle write.
This causes trouble later on as the completion handler will get
confused because the request was not active.

This is very difficult to trigger but happened in some virtualized
environments with a high I/O load.

Signed-off-by: Alexander Eichner <Alexander.Eichner@oracle.com>
---
 drivers/scsi/BusLogic.c | 1 +
 drivers/scsi/BusLogic.h | 6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index c7be7bb37209..20cc34fa5754 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -2981,6 +2981,7 @@ static bool blogic_write_outbox(struct blogic_adapter *adapter,
 		   by the Host Adapter.
 		 */
 		next_outbox->ccb = ccb->dma_handle;
+		wmb();
 		next_outbox->action = action;
 		blogic_execmbox(adapter);
 		if (++next_outbox > adapter->last_outbox)
diff --git a/drivers/scsi/BusLogic.h b/drivers/scsi/BusLogic.h
index b53ec2f1e8cd..16f372f3e9c2 100644
--- a/drivers/scsi/BusLogic.h
+++ b/drivers/scsi/BusLogic.h
@@ -869,9 +869,9 @@ struct blogic_ccb {
 */
 
 struct blogic_outbox {
-	u32 ccb;			/* Bytes 0-3 */
-	u32:24;				/* Bytes 4-6 */
-	enum blogic_action action;	/* Byte 7 */
+	volatile u32 ccb;					/* Bytes 0-3 */
+	u32:24;								/* Bytes 4-6 */
+	volatile enum blogic_action action;	/* Byte 7 */
 };
 
 /*
-- 
2.12.0
