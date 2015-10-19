From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 3/7] bnx2fc: Set ELS transfer length correctly for middle path commands.
Date: Mon, 19 Oct 2015 15:40:37 -0400
Message-ID: <1445283641-7358-4-git-send-email-chad.dupuis@qlogic.com>
References: <1445283641-7358-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:37507 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752771AbbJSUTP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Oct 2015 16:19:15 -0400
In-Reply-To: <1445283641-7358-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/bnx2fc/bnx2fc_els.c |    1 +
 drivers/scsi/bnx2fc/bnx2fc_io.c  |    8 ++++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_els.c b/drivers/scsi/bnx2fc/bnx2fc_els.c
index 49d1e4d..0d0ab2e 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_els.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_els.c
@@ -707,6 +707,7 @@ static int bnx2fc_initiate_els(struct bnx2fc_rport *tgt, unsigned int op,
 	els_req->cb_func = cb_func;
 	cb_arg->io_req = els_req;
 	els_req->cb_arg = cb_arg;
+	els_req->data_xfer_len = data_len;
 
 	mp_req = (struct bnx2fc_mp_req *)&(els_req->mp_req);
 	rc = bnx2fc_init_mp_req(els_req);
diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 520dabe..5d6a81b 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -623,8 +623,12 @@ int bnx2fc_init_mp_req(struct bnx2fc_cmd *io_req)
 	mp_req = (struct bnx2fc_mp_req *)&(io_req->mp_req);
 	memset(mp_req, 0, sizeof(struct bnx2fc_mp_req));
 
-	mp_req->req_len = sizeof(struct fcp_cmnd);
-	io_req->data_xfer_len = mp_req->req_len;
+	if (io_req->cmd_type != BNX2FC_ELS) {
+		mp_req->req_len = sizeof(struct fcp_cmnd);
+		io_req->data_xfer_len = mp_req->req_len;
+	} else
+		mp_req->req_len = io_req->data_xfer_len; 
+
 	mp_req->req_buf = dma_alloc_coherent(&hba->pcidev->dev, CNIC_PAGE_SIZE,
 					     &mp_req->req_buf_dma,
 					     GFP_ATOMIC);
-- 
1.7.7

