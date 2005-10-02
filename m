From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] fix potential panic with proc on module removal
Date: Sun, 02 Oct 2005 12:59:49 -0500
Message-ID: <1128275990.4810.15.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:43481 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751146AbVJBR7x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 2 Oct 2005 13:59:53 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id j92HxpA18777
	for <linux-scsi@vger.kernel.org>; Sun, 2 Oct 2005 13:59:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

There's a problem in our host release in that it calls
scsi_proc_hostdir_rm(). However, if you hold a reference to the host as
you remove the module, the host template (which proc uses) will be freed
and the system will panic when the host device is finally released.

Fix this by moving scsi_proc_hostdir_rm() to where it should be: in
scsi_remove_host().

James

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -176,6 +176,7 @@ void scsi_remove_host(struct Scsi_Host *
 	transport_unregister_device(&shost->shost_gendev);
 	class_device_unregister(&shost->shost_classdev);
 	device_del(&shost->shost_gendev);
+	scsi_proc_hostdir_rm(shost->hostt);
 }
 EXPORT_SYMBOL(scsi_remove_host);
 
@@ -262,7 +263,6 @@ static void scsi_host_dev_release(struct
 	if (shost->work_q)
 		destroy_workqueue(shost->work_q);
 
-	scsi_proc_hostdir_rm(shost->hostt);
 	scsi_destroy_command_freelist(shost);
 	kfree(shost->shost_data);
 


