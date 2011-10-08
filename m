From: michaelc@cs.wisc.edu
Subject: [PATCH 4/5] be2iscsi: memset wrb for ring create
Date: Fri,  7 Oct 2011 19:31:11 -0500
Message-ID: <1318033872-5900-5-git-send-email-michaelc@cs.wisc.edu>
References: <1318033872-5900-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18688 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754777Ab1JHA0G (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Oct 2011 20:26:06 -0400
In-Reply-To: <1318033872-5900-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

   This patch fixes a situation when  wrb was not being memset to zero
before being used

Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/be2iscsi/be_cmds.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index 67fd831..cdb1536 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -660,6 +660,7 @@ int beiscsi_cmd_mccq_create(struct beiscsi_hba *phba,
 	spin_lock(&phba->ctrl.mbox_lock);
 	ctrl = &phba->ctrl;
 	wrb = wrb_from_mbox(&ctrl->mbox_mem);
+	memset(wrb, 0, sizeof(*wrb));
 	req = embedded_payload(wrb);
 	ctxt = &req->context;
 
-- 
1.7.6

