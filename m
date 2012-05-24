From: michaelc@cs.wisc.edu
Subject: [PATCH 1/1] be2iscsi: fix dma free size mismatch regression
Date: Wed, 23 May 2012 20:40:54 -0500
Message-ID: <1337823654-8826-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755052Ab2EXBlE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 May 2012 21:41:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This patch should go into 3.5 fixes. The bug was added in the
patches for the 3.5 feature window.

As you can see from the patch I made a mistake. During
development I switched from passing a struct to the size of
the struct, but left the sizeof. This results in us allocating
4 bytes (sizeof(int)) but then calling pci_free_consistent
with the size of the struct.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/be2iscsi/be_mgmt.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 01bb04c..2a09679 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -571,13 +571,12 @@ free_cmd:
 static int mgmt_alloc_cmd_data(struct beiscsi_hba *phba, struct be_dma_mem *cmd,
 			       int iscsi_cmd, int size)
 {
-	cmd->va = pci_alloc_consistent(phba->ctrl.pdev, sizeof(size),
-				       &cmd->dma);
+	cmd->va = pci_alloc_consistent(phba->ctrl.pdev, size, &cmd->dma);
 	if (!cmd->va) {
 		SE_DEBUG(DBG_LVL_1, "Failed to allocate memory for if info\n");
 		return -ENOMEM;
 	}
-	memset(cmd->va, 0, sizeof(size));
+	memset(cmd->va, 0, size);
 	cmd->size = size;
 	be_cmd_hdr_prepare(cmd->va, CMD_SUBSYSTEM_ISCSI, iscsi_cmd, size);
 	return 0;
-- 
1.7.7.6

