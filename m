From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 4/7] bnx2fc: Fix FCP RSP residual parsing.
Date: Mon, 19 Oct 2015 15:40:38 -0400
Message-ID: <1445283641-7358-5-git-send-email-chad.dupuis@qlogic.com>
References: <1445283641-7358-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:34138 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752883AbbJSUTT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Oct 2015 16:19:19 -0400
In-Reply-To: <1445283641-7358-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 5d6a81b..877a79a 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1759,7 +1759,10 @@ static void bnx2fc_parse_fcp_rsp(struct bnx2fc_cmd *io_req,
 	int fcp_rsp_len = 0;
 
 	io_req->fcp_status = FC_GOOD;
-	io_req->fcp_resid = fcp_rsp->fcp_resid;
+	io_req->fcp_resid = 0;
+	if (rsp_flags & (FCOE_FCP_RSP_FLAGS_FCP_RESID_OVER |
+	    FCOE_FCP_RSP_FLAGS_FCP_RESID_UNDER))
+		io_req->fcp_resid = fcp_rsp->fcp_resid;
 
 	io_req->scsi_comp_flags = rsp_flags;
 	CMD_SCSI_STATUS(sc_cmd) = io_req->cdb_status =
-- 
1.7.7

