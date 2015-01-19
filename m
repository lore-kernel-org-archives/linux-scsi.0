From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] be2iscsi: return correct error code in beiscsi_init_port()
Date: Mon, 19 Jan 2015 17:42:37 +0300
Message-ID: <20150119144237.GD19086@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47436 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbbASOl6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Jan 2015 09:41:58 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

If hba_setup_cid_tbls() fails then this code should return an error code
but instead the current code returns zero (success).

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index f319340..fe59ae6 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -4458,7 +4458,8 @@ static int beiscsi_init_port(struct beiscsi_hba *phba)
 		goto do_cleanup_ctrlr;
 	}
 
-	if (hba_setup_cid_tbls(phba)) {
+	ret = hba_setup_cid_tbls(phba);
+	if (ret < 0) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
 			    "BM_%d : Failed in hba_setup_cid_tbls\n");
 		kfree(phba->io_sgl_hndl_base);
