From: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Subject: [PATCH 06/15] be2iscsi: Added return value check for mgmt_get_all_if_id
Date: Tue, 15 Dec 2015 21:24:57 +0530
Message-ID: <1450194906-12925-7-git-send-email-jitendra.bhivare@avagotech.com>
References: <1450194906-12925-1-git-send-email-jitendra.bhivare@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmrelayp1.emulex.com ([138.239.112.140]:63987 "EHLO
	CMRELAYP1.ad.emulex.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754113AbbLOPz0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Dec 2015 10:55:26 -0500
In-Reply-To: <1450194906-12925-1-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jitendra <jitendra.bhivare@avagotech.com>

From: Jitendra <jitendra.bhivare@avagotech.com>

Use of mutex_lock_interruptible can return -EINTR, handle and log
the error.

Signed-off-by: Jitendra <jitendra.bhivare@avagotech.com>
---
 drivers/scsi/be2iscsi/be_iscsi.c |    7 ++++---
 drivers/scsi/be2iscsi/be_mgmt.c  |   10 ++++++----
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
index a41013e..a8a1670 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -1018,8 +1018,9 @@ int mgmt_set_ip(struct beiscsi_hba *phba,
 	uint32_t ip_type;
 	int rc;
 
-	if (mgmt_get_all_if_id(phba))
-		return -EIO;
+	rc = mgmt_get_all_if_id(phba);
+	if (rc)
+		return rc;
 
 	ip_type = (ip_param->param == ISCSI_NET_PARAM_IPV6_ADDR) ?
 		BE2_IPV6 : BE2_IPV4 ;
@@ -1188,8 +1189,9 @@ int mgmt_get_if_info(struct beiscsi_hba *phba, int ip_type,
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
1.7.1

