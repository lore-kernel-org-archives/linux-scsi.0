From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 05/20] be2iscsi: Fix for freeing cid
Date: Mon, 12 Jul 2010 23:21:40 +0530
Message-ID: <20100712175128.GA11459@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:31190 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753701Ab0GLRvg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jul 2010 13:51:36 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

   This patch frees up the allocated cid and returns error if allocation
of tag fails.

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_iscsi.c |   28 +++++++++++++++-------------
 1 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 26db9b7..e1505fa 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -442,6 +442,19 @@ static int beiscsi_get_cid(struct beiscsi_hba *phba)
 }
 
 /**
+ * beiscsi_put_cid - Free the cid
+ * @phba: The phba for which the cid is being freed
+ * @cid: The cid to free
+ */
+static void beiscsi_put_cid(struct beiscsi_hba *phba, unsigned short cid)
+{
+	phba->avlbl_cids++;
+	phba->cid_array[phba->cid_free++] = cid;
+	if (phba->cid_free == phba->params.cxns_per_ctrl)
+		phba->cid_free = 0;
+}
+
+/**
  * beiscsi_open_conn - Ask FW to open a TCP connection
  * @ep:	endpoint to be used
  * @src_addr: The source IP address
@@ -484,6 +497,8 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
 		SE_DEBUG(DBG_LVL_1,
 			 "mgmt_open_connection Failed for cid=%d\n",
 			 beiscsi_ep->ep_cid);
+		beiscsi_put_cid(phba, beiscsi_ep->ep_cid);
+		return -EAGAIN;
 	} else {
 		wait_event_interruptible(phba->ctrl.mcc_wait[tag],
 					 phba->ctrl.mcc_numtag[tag]);
@@ -511,19 +526,6 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
 }
 
 /**
- * beiscsi_put_cid - Free the cid
- * @phba: The phba for which the cid is being freed
- * @cid: The cid to free
- */
-static void beiscsi_put_cid(struct beiscsi_hba *phba, unsigned short cid)
-{
-	phba->avlbl_cids++;
-	phba->cid_array[phba->cid_free++] = cid;
-	if (phba->cid_free == phba->params.cxns_per_ctrl)
-		phba->cid_free = 0;
-}
-
-/**
  * beiscsi_free_ep - free endpoint
  * @ep:	pointer to iscsi endpoint structure
  */
-- 
1.6.5.2

