From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 06/15] be2iscsi: Use of opcode in beiscsi_alloc_pdu
Date: Fri, 4 Dec 2009 08:51:50 +0530
Message-ID: <20091204032140.GA6115@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:6736 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754386AbZLDDVf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Dec 2009 22:21:35 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

   This patch enables use of opcode that is passed in

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index d5ed2c8..fababe4 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3338,7 +3338,7 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 			goto free_hndls;
 	} else {
 		io_task->scsi_cmnd = NULL;
-		if ((task->hdr->opcode & ISCSI_OPCODE_MASK) == ISCSI_OP_LOGIN) {
+		if ((opcode & ISCSI_OPCODE_MASK) == ISCSI_OP_LOGIN) {
 			if (!beiscsi_conn->login_in_progress) {
 				spin_lock(&phba->mgmt_sgl_lock);
 				io_task->psgl_handle = (struct sgl_handle *)
-- 
1.6.4

