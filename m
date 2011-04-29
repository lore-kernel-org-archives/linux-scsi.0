From: michaelc@cs.wisc.edu
Subject: [PATCH 2/3] be2iscsi: fix chip cleanup
Date: Fri, 29 Apr 2011 14:30:07 -0500
Message-ID: <1304105408-2710-3-git-send-email-michaelc@cs.wisc.edu>
References: <1304105408-2710-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755762Ab1D2TaS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Apr 2011 15:30:18 -0400
In-Reply-To: <1304105408-2710-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

This patch fixes a bug where proper queue id's were not passed to
chip for cleanup.

Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/be2iscsi/be_mgmt.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 65a402b..44762cf 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -202,8 +202,8 @@ int mgmt_epfw_cleanup(struct beiscsi_hba *phba, unsigned short chute)
 			   OPCODE_COMMON_ISCSI_CLEANUP, sizeof(*req));
 
 	req->chute = chute;
-	req->hdr_ring_id = 0;
-	req->data_ring_id = 0;
+	req->hdr_ring_id = cpu_to_le16(HWI_GET_DEF_HDRQ_ID(phba));
+	req->data_ring_id = cpu_to_le16(HWI_GET_DEF_BUFQ_ID(phba));
 
 	status =  be_mcc_notify_wait(phba);
 	if (status)
-- 
1.7.2.3

