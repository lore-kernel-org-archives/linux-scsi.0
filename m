From: Maurizio Lombardi <mlombard@redhat.com>
Subject: [PATCH] be2iscsi: set the boot_kset pointer to NULL in case of failure
Date: Fri,  4 Mar 2016 10:41:49 +0100
Message-ID: <1457084509-7368-1-git-send-email-mlombard@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57264 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758951AbcCDJlw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Mar 2016 04:41:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jayamohan.kallickal@avagotech.com
Cc: ketan.mukadam@avagotech.com, sony.john@avagotech.com, linux-scsi@vger.kernel.org

In beiscsi_setup_boot_info(), the boot_kset pointer should be set
to NULL in case of failure otherwise an invalid pointer dereference
may occur later.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/scsi/be2iscsi/be_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index cb9072a..069e5c5 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -4468,6 +4468,7 @@ put_shost:
 	scsi_host_put(phba->shost);
 free_kset:
 	iscsi_boot_destroy_kset(phba->boot_kset);
+	phba->boot_kset = NULL;
 	return -ENOMEM;
 }
 
-- 
Maurizio Lombardi

