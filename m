From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] target: blk_make_request() returns an ERR_PTR()
Date: Mon, 31 Oct 2011 10:03:15 +0300
Message-ID: <20111031070315.GA13640@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:44477 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318Ab1JaHDa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Oct 2011 03:03:30 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org

The check is wrong here because blk_make_request() returns an
ERR_PTR() and it doesn't return NULL.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index b452efe..ed32e1e 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -1092,7 +1092,7 @@ static int pscsi_do_task(struct se_task *task)
 
 		req = blk_make_request(pdv->pdv_sd->request_queue, hbio,
 				       GFP_KERNEL);
-		if (!req) {
+		if (IS_ERR(req)) {
 			pr_err("pSCSI: blk_make_request() failed\n");
 			goto fail;
 		}
