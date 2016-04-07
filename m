From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH v2 4/5] bnx2fc: Check sc_cmd device and host pointer before returning the command to the mid-layer.
Date: Thu, 7 Apr 2016 09:07:59 -0400
Message-ID: <1460034480-28512-5-git-send-email-chad.dupuis@qlogic.com>
References: <1460034480-28512-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:44602 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752042AbcDGNtX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Apr 2016 09:49:23 -0400
In-Reply-To: <1460034480-28512-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: chad.dupuis@qlogic.com, saurav.kashyap@qlogic.com, linux-scsi@vger.kernel.org

When we are in connection recovery and the internal command timer on a request
pops, either the scsi_cmnd->device or scsi_cmnd->device->host back pointers may
be NULL as the device that the command that the request was submitted on may
have been subsequently reaped due to the connection recovery. This can cause
one or both of the pointers above to be NULL and cause a system crash if we try
to return the command to the midlayer.

Instead, double check the pointers before the return to the midlayer so as to
prevent the crash and let the upper layers finish the session recovery and
rediscover the device.

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index ac8fb2a..25a1e19 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -179,12 +179,24 @@ static void bnx2fc_scsi_done(struct bnx2fc_cmd *io_req, int err_code)
 
 	bnx2fc_unmap_sg_list(io_req);
 	io_req->sc_cmd = NULL;
+
+	/* Sanity checks before returning command to mid-layer */
 	if (!sc_cmd) {
 		printk(KERN_ERR PFX "scsi_done - sc_cmd NULL. "
 				    "IO(0x%x) already cleaned up\n",
 		       io_req->xid);
 		return;
 	}
+	if (!sc_cmd->device) {
+		pr_err(PFX "0x%x: sc_cmd->device is NULL.\n", io_req->xid);
+		return;
+	}
+	if (!sc_cmd->device->host) {
+		pr_err(PFX "0x%x: sc_cmd->device->host is NULL.\n",
+		    io_req->xid);
+		return;
+	}
+
 	sc_cmd->result = err_code << 16;
 
 	BNX2FC_IO_DBG(io_req, "sc=%p, result=0x%x, retries=%d, allowed=%d\n",
-- 
2.0.0.rc0.26.g779792a

