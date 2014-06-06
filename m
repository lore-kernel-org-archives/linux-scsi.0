From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH 1/1] be2iscsi: remove potential junk pointer free
Date: Fri, 06 Jun 2014 14:22:44 +0200
Message-ID: <5391B294.5020104@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27325 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058AbaFFMWs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Jun 2014 08:22:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, jayamohank@gmail.com, sony.john-n@emulex.com

commit 0e7c60c [SCSI] be2iscsi: fix memory leak in error path
fixed an potential junk pointer free if  mgmt_get_if_info() returned an error

fix it on one more place

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 6045aa7..07934b0 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -1008,10 +1008,8 @@ int mgmt_set_ip(struct beiscsi_hba *phba,
 		BE2_IPV6 : BE2_IPV4 ;
 
 	rc = mgmt_get_if_info(phba, ip_type, &if_info);
-	if (rc) {
-		kfree(if_info);
+	if (rc)
 		return rc;
-	}
 
 	if (boot_proto == ISCSI_BOOTPROTO_DHCP) {
 		if (if_info->dhcp_state) {
-- 
1.8.3.1

