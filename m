From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 3/7] be2iscsi: Fix for a possible sleep while holding lock
 V2
Date: Sat, 20 Feb 2010 08:03:24 +0530
Message-ID: <20100220023314.GA13632@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:53470 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755511Ab0BTCdX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Feb 2010 21:33:23 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

           This patch fixes a situation where we could call udelay
while holding spin_lock

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_cmds.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index 6709857..cda6642 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -32,18 +32,11 @@ void be_mcc_notify(struct beiscsi_hba *phba)
 unsigned int alloc_mcc_tag(struct beiscsi_hba *phba)
 {
 	unsigned int tag = 0;
-	unsigned int num = 0;
 
-mcc_tag_rdy:
 	if (phba->ctrl.mcc_tag_available) {
 		tag = phba->ctrl.mcc_tag[phba->ctrl.mcc_alloc_index];
 		phba->ctrl.mcc_tag[phba->ctrl.mcc_alloc_index] = 0;
 		phba->ctrl.mcc_numtag[tag] = 0;
-	} else {
-		udelay(100);
-		num++;
-		if (num < mcc_timeout)
-			goto mcc_tag_rdy;
 	}
 	if (tag) {
 		phba->ctrl.mcc_tag_available--;
-- 
1.6.4

