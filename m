From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 04/19] be2iscsi: pass the return from beiscsi_open_conn
Date: Thu, 22 Jul 2010 04:18:01 +0530
Message-ID: <20100721224751.GA9289@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:22905 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759032Ab0GUWrp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jul 2010 18:47:45 -0400
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
index cd1b830..4f3c2a4 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -580,9 +580,9 @@ beiscsi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
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

