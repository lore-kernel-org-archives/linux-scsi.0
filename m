From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 04/20] be2iscsi: pass the return from beiscsi_open_conn
Date: Mon, 12 Jul 2010 23:20:51 +0530
Message-ID: <20100712175041.GA11428@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:30948 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756358Ab0GLRur (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jul 2010 13:50:47 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

         This patch passes on  the value returned by
beiscsi_open_conn

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_iscsi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index ca9bd3a..26db9b7 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -576,9 +576,9 @@ beiscsi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 	beiscsi_ep = ep->dd_data;
 	beiscsi_ep->phba = phba;
 	beiscsi_ep->openiscsi_ep = ep;
-	if (beiscsi_open_conn(ep, NULL, dst_addr, non_blocking)) {
+	ret = beiscsi_open_conn(ep, NULL, dst_addr, non_blocking);
+	if (ret) {
 		SE_DEBUG(DBG_LVL_1, "Failed in beiscsi_open_conn\n");
-		ret = -ENOMEM;
 		goto free_ep;
 	}
 
-- 
1.6.5.2

