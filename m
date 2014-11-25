From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/2] fc: FCP_PTA_SIMPLE is 0
Date: Tue, 25 Nov 2014 15:50:09 +0100
Message-ID: <1416927010-6036-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:54188 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbaKYOuS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Nov 2014 09:50:18 -0500
Received: from [83.175.99.196] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XtHRZ-0001WL-HA
	for linux-scsi@vger.kernel.org; Tue, 25 Nov 2014 14:50:17 +0000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Not need to have an if/else to either assign FCP_PTA_SIMPLE or 0
to a variable.

Btw, it seems we really should factor generating a fcp cmnd from
a scsi_cmnd into a common helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c   | 6 +-----
 drivers/scsi/csiostor/csio_scsi.c | 5 +----
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 4b56858..9ecca85 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1737,11 +1737,7 @@ void bnx2fc_build_fcp_cmnd(struct bnx2fc_cmd *io_req,
 	fcp_cmnd->fc_pri_ta = 0;
 	fcp_cmnd->fc_tm_flags = io_req->mp_req.tm_flags;
 	fcp_cmnd->fc_flags = io_req->io_req_flags;
-
-	if (sc_cmd->flags & SCMD_TAGGED)
-		fcp_cmnd->fc_pri_ta = FCP_PTA_SIMPLE;
-	else
-		fcp_cmnd->fc_pri_ta = 0;
+	fcp_cmnd->fc_pri_ta = FCP_PTA_SIMPLE;
 }
 
 static void bnx2fc_parse_fcp_rsp(struct bnx2fc_cmd *io_req,
diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index 4d0b6ce..6bd36c3 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -172,10 +172,7 @@ csio_scsi_fcp_cmnd(struct csio_ioreq *req, void *addr)
 		fcp_cmnd->fc_cmdref = 0;
 
 		memcpy(fcp_cmnd->fc_cdb, scmnd->cmnd, 16);
-		if (scmnd->flags & SCMD_TAGGED)
-			fcp_cmnd->fc_pri_ta = FCP_PTA_SIMPLE;
-		else
-			fcp_cmnd->fc_pri_ta = 0;
+		fcp_cmnd->fc_pri_ta = FCP_PTA_SIMPLE;
 		fcp_cmnd->fc_dl = cpu_to_be32(scsi_bufflen(scmnd));
 
 		if (req->nsge)
-- 
1.9.1

