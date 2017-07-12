From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] scsi: qedi: Fix return code in qedi_ep_connect()
Date: Wed, 12 Jul 2017 10:31:21 +0300
Message-ID: <20170712073121.yznfz6g5cvlrsvze@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26304 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933181AbdGLHbi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2017 03:31:38 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: QLogic-Storage-Upstream@cavium.com, Manish Rangankar <manish.rangankar@cavium.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

We shouldn't be writing over the "ret" variable.  It means we return
ERR_PTR(0) which is NULL and it results in a NULL dereference in the
caller.

Fixes: ace7f46ba5fd ("scsi: qedi: Add QLogic FastLinQ offload iSCSI driver framework.")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 80edd28b635f..37da9a8b43b1 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -824,7 +824,7 @@ qedi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 	u32 iscsi_cid = QEDI_CID_RESERVED;
 	u16 len = 0;
 	char *buf = NULL;
-	int ret;
+	int ret, tmp;
 
 	if (!shost) {
 		ret = -ENXIO;
@@ -940,10 +940,10 @@ qedi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 
 ep_rel_conn:
 	qedi->ep_tbl[iscsi_cid] = NULL;
-	ret = qedi_ops->release_conn(qedi->cdev, qedi_ep->handle);
-	if (ret)
+	tmp = qedi_ops->release_conn(qedi->cdev, qedi_ep->handle);
+	if (tmp)
 		QEDI_WARN(&qedi->dbg_ctx, "release_conn returned %d\n",
-			  ret);
+			  tmp);
 ep_free_sq:
 	qedi_free_sq(qedi, qedi_ep);
 ep_conn_exit:
