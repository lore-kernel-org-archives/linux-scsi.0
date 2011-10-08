From: michaelc@cs.wisc.edu
Subject: [PATCH 3/5] be2iscsi: Fix for case where task->sc was cleanedup earlier
Date: Fri,  7 Oct 2011 19:31:10 -0500
Message-ID: <1318033872-5900-4-git-send-email-michaelc@cs.wisc.edu>
References: <1318033872-5900-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754777Ab1JHAZ6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Oct 2011 20:25:58 -0400
In-Reply-To: <1318033872-5900-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

  This patch fixes a bug where the task->sc was cleaned up earlier on a different
thread, possibly abort, and the completion comes later.

This was causing a crash which has been reported in multiple places

Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/be2iscsi/be_main.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index e166d54..7b0a8ab 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -1123,7 +1123,12 @@ be_complete_io(struct beiscsi_conn *beiscsi_conn,
 						& SOL_STS_MASK) >> 8);
 	flags = ((psol->dw[offsetof(struct amap_sol_cqe, i_flags) / 32]
 					& SOL_FLAGS_MASK) >> 24) | 0x80;
+	if (!task->sc) {
+		if (io_task->scsi_cmnd)
+			scsi_dma_unmap(io_task->scsi_cmnd);
 
+		return;
+	}
 	task->sc->result = (DID_OK << 16) | status;
 	if (rsp != ISCSI_STATUS_CMD_COMPLETED) {
 		task->sc->result = DID_ERROR << 16;
-- 
1.7.6

