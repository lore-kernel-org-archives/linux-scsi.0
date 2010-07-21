From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 05/19] be2iscsi: Fix for freeing cid
Date: Thu, 22 Jul 2010 04:22:27 +0530
Message-ID: <20100721225216.GA9353@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:24040 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758908Ab0GUWwO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jul 2010 18:52:14 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

   This patch frees up the allocated cid and returns error if allocation
of tag fails.

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_iscsi.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 4f3c2a4..de79b7c 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -509,6 +509,8 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
 		SE_DEBUG(DBG_LVL_1,
 			 "mgmt_open_connection Failed for cid=%d\n",
 			 beiscsi_ep->ep_cid);
+		beiscsi_put_cid(phba, beiscsi_ep->ep_cid);
+		return -EAGAIN;
 	} else {
 		wait_event_interruptible(phba->ctrl.mcc_wait[tag],
 					 phba->ctrl.mcc_numtag[tag]);
-- 
1.6.5.2

