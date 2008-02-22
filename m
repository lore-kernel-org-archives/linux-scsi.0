From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: libsas: correctly flush the LU queue on error recovery
Date: Fri, 22 Feb 2008 17:07:52 -0600
Message-ID: <1203721672.6206.81.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:39732 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758070AbYBVXH4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Feb 2008 18:07:56 -0500
Received: from localhost (localhost [127.0.0.1])
	by accolon.hansenpartnership.com (Postfix) with ESMTP id 49C508341
	for <linux-scsi@vger.kernel.org>; Fri, 22 Feb 2008 17:07:55 -0600 (CST)
Received: from accolon.hansenpartnership.com ([127.0.0.1])
	by localhost (redscar.int.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qopuS2YLhGUi for <linux-scsi@vger.kernel.org>;
	Fri, 22 Feb 2008 17:07:54 -0600 (CST)
Received: from [153.66.150.222] (mulgrave-w.int.hansenpartnership.com [153.66.150.222])
	by accolon.hansenpartnership.com (Postfix) with ESMTP id 669778254
	for <linux-scsi@vger.kernel.org>; Fri, 22 Feb 2008 17:07:53 -0600 (CST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

The current sas_scsi_clear_queue_lu() is wrongly checking for commands
which match the pointer to the one passed in.  It should be checking for
commands which are on the same logical unit as the one passed in.  Fix
this by checking target pointer and LUN for equality.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

---

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index b796d99..57ba99f 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -282,7 +282,8 @@ static void sas_scsi_clear_queue_lu(struct list_head *error_q, struct scsi_cmnd
 	struct scsi_cmnd *cmd, *n;
 
 	list_for_each_entry_safe(cmd, n, error_q, eh_entry) {
-		if (cmd == my_cmd)
+		if (cmd->device->sdev_target == my_cmd->device->sdev_target &&
+		    cmd->device->lun == my_cmd->device->lun)
 			sas_eh_finish_cmd(cmd);
 	}
 }


