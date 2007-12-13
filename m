From: michaelc@cs.wisc.edu
Subject: [PATCH 05/24] iser patching for AHS support
Date: Thu, 13 Dec 2007 12:43:24 -0600
Message-ID: <11975714333916-git-send-email-michaelc@cs.wisc.edu>
References: <11975714233983-git-send-email-michaelc@cs.wisc.edu>
 <1197571428957-git-send-email-michaelc@cs.wisc.edu>
 <11975714291290-git-send-email-michaelc@cs.wisc.edu>
 <11975714303190-git-send-email-michaelc@cs.wisc.edu>
 <11975714323427-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:54080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762105AbXLMSqf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Dec 2007 13:46:35 -0500
In-Reply-To: <11975714323427-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, Boaz Harrosh <bharrosh@panasas.com>

From: Mike Christie <michaelc@cs.wisc.edu>

from Boaz Harrosh <boazharrosh@gmail.com>

  - The default initialization of hdr_max is the minimum -
    sizeof(struct iscsi_cmd) - Once this patch goes into iser the default
    initialization at libiscsi can be removed.
  - This is not yet full support for AHSs at iser end. But it should be easy.
    Just allocate more space at iser_desc right after iscsi_hdr. Than
    at transmission time use ctask->hdr_len to retrieve the total
    size of all iscsi pdu headers. See previous patch at iscsi_tcp.[ch]

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |    1 +
 drivers/scsi/libiscsi.c                  |    1 -
 2 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 2eadb6d..a2622f4 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -400,6 +400,7 @@ iscsi_iser_session_create(struct iscsi_transport *iscsit,
 		ctask      = session->cmds[i];
 		iser_ctask = ctask->dd_data;
 		ctask->hdr = (struct iscsi_cmd *)&iser_ctask->desc.iscsi_header;
+		ctask->hdr_max = sizeof(iser_ctask->desc.iscsi_header);
 	}
 
 	for (i = 0; i < session->mgmtpool_max; i++) {
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 0d7914f..5936586 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1570,7 +1570,6 @@ iscsi_session_setup(struct iscsi_transport *iscsit,
 		if (cmd_task_size)
 			ctask->dd_data = &ctask[1];
 		ctask->itt = cmd_i;
-		ctask->hdr_max = sizeof(struct iscsi_cmd);
 		INIT_LIST_HEAD(&ctask->running);
 	}
 
-- 
1.5.1.2

