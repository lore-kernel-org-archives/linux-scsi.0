From: Tejun Heo <tj@kernel.org>
Subject: [PATCH] scsi: fix use-after-free in scsi_init_io()
Date: Mon, 16 Aug 2010 16:15:01 +0200
Message-ID: <4C6947E5.2080208@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:50621 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753377Ab0HPOR6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Aug 2010 10:17:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, Linux SCSI List <linux-scsi@vger.kernel.org>
Cc: stable@kernel.org

scsi_init_io() dereferences scsi_cmnd after putting it in the error
path leading to oops.  Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: stable@kernel.org
---
 drivers/scsi/scsi_lib.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: block/drivers/scsi/scsi_lib.c
===================================================================
--- block.orig/drivers/scsi/scsi_lib.c
+++ block/drivers/scsi/scsi_lib.c
@@ -968,7 +968,9 @@ static int scsi_init_sgtable(struct requ
  */
 int scsi_init_io(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 {
+	struct request *req = cmd->request;
 	int error = scsi_init_sgtable(cmd->request, &cmd->sdb, gfp_mask);
+
 	if (error)
 		goto err_exit;

@@ -1012,7 +1014,7 @@ int scsi_init_io(struct scsi_cmnd *cmd,
 err_exit:
 	scsi_release_buffers(cmd);
 	scsi_put_command(cmd);
-	cmd->request->special = NULL;
+	req->special = NULL;
 	return error;
 }
 EXPORT_SYMBOL(scsi_init_io);
