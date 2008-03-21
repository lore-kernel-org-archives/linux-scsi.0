From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH] hosts.c fixes for "no error" reported after error scenarios
Date: Fri, 21 Mar 2008 17:18:23 -0400
Message-ID: <1206134303.17617.2.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:52929 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762037AbYCUVSL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Mar 2008 17:18:11 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m2LLI7Iq010849
	for <linux-scsi@vger.kernel.org>; Fri, 21 Mar 2008 14:18:09 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch corrects some cases in scsi_add_host() that fail, but the "error"
return code was not reset after a prior use which set it to a non-error value.

Patch cut against scsi-rc-fixes-2.6

-- james s

 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 hosts.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)


diff -upNr a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
--- a/drivers/scsi/hosts.c	2008-03-17 09:15:25.000000000 -0400
+++ b/drivers/scsi/hosts.c	2008-03-21 17:10:31.000000000 -0400
@@ -218,18 +218,24 @@ int scsi_add_host(struct Scsi_Host *shos
 
 	get_device(&shost->shost_gendev);
 
-	if (shost->transportt->host_size &&
-	    (shost->shost_data = kzalloc(shost->transportt->host_size,
-					 GFP_KERNEL)) == NULL)
-		goto out_del_classdev;
+	if (shost->transportt->host_size) {
+		shost->shost_data = kzalloc(shost->transportt->host_size,
+					 GFP_KERNEL);
+		if (shost->shost_data == NULL) {
+			error = -ENOMEM;
+			goto out_del_classdev;
+		}
+	}
 
 	if (shost->transportt->create_work_queue) {
 		snprintf(shost->work_q_name, KOBJ_NAME_LEN, "scsi_wq_%d",
 			shost->host_no);
 		shost->work_q = create_singlethread_workqueue(
 					shost->work_q_name);
-		if (!shost->work_q)
+		if (!shost->work_q) {
+			error = -EINVAL;
 			goto out_free_shost_data;
+		}
 	}
 
 	error = scsi_sysfs_add_host(shost);


