From: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Subject: [PATCH v3 06/17] be2iscsi: Added return value check for mgmt_get_all_if_id
Date: Wed, 23 Dec 2015 14:04:25 +0530
Message-ID: <1450859676-22025-7-git-send-email-jitendra.bhivare@avagotech.com>
References: <1450859676-22025-1-git-send-email-jitendra.bhivare@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmrelayp1.emulex.com ([138.239.112.140]:55533 "EHLO
	CMRELAYP1.ad.emulex.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S933720AbbLWIey (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Dec 2015 03:34:54 -0500
In-Reply-To: <1450859676-22025-1-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jitendra Bhivare <jitendra.bhivare@avagotech.com>

Use of mutex_lock_interruptible can return -EINTR, handle and log
the error.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/be2iscsi/be_iscsi.c |  7 ++++---
 drivers/scsi/be2iscsi/be_mgmt.c  | 10 ++++++----
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index b7087ba..188d83f 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -367,13 +367,14 @@ beiscsi_set_vlan_tag(struct Scsi_Host *shost,
 		      struct iscsi_iface_param_info *iface_param)
 {
 	struct beiscsi_hba *phba = iscsi_host_priv(shost);
-	int ret = 0;
+	int ret;
 
 	/* Get the Interface Handle */
-	if (mgmt_get_all_if_id(phba)) {
+	ret = mgmt_get_all_if_id(phba);
+	if (ret) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
 			    "BS_%d : Getting Interface Handle Failed\n");
-		return -EIO;
+		return ret;
 	}
 
 	switch (iface_param->param) {
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 7f3f8268..7aa7a3c 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -1025,8 +1025,9 @@ int mgmt_set_ip(struct beiscsi_hba *phba,
 	uint32_t ip_type;
 	int rc;
 
-	if (mgmt_get_all_if_id(phba))
-		return -EIO;
+	rc = mgmt_get_all_if_id(phba);
+	if (rc)
+		return rc;
 
 	ip_type = (ip_param->param == ISCSI_NET_PARAM_IPV6_ADDR) ?
 		BE2_IPV6 : BE2_IPV4 ;
@@ -1195,8 +1196,9 @@ int mgmt_get_if_info(struct beiscsi_hba *phba, int ip_type,
 	uint32_t ioctl_size = sizeof(struct be_cmd_get_if_info_resp);
 	int rc;
 
-	if (mgmt_get_all_if_id(phba))
-		return -EIO;
+	rc = mgmt_get_all_if_id(phba);
+	if (rc)
+		return rc;
 
 	do {
 		rc = mgmt_alloc_cmd_data(phba, &nonemb_cmd,
-- 
1.9.1

