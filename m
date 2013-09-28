From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH V2 03/23] be2iscsi: Fix repeated issue of MAC ADDR get IOCTL
Date: Sat, 28 Sep 2013 15:35:40 -0700
Message-ID: <1380407761-2949-3-git-send-email-jayamohan.kallickal@emulex.com>
References: <1380407761-2949-1-git-send-email-jayamohan.kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:47720 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152Ab3I1WgT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Sep 2013 18:36:19 -0400
Received: by mail-pa0-f41.google.com with SMTP id bj1so4254853pad.14
        for <linux-scsi@vger.kernel.org>; Sat, 28 Sep 2013 15:36:19 -0700 (PDT)
In-Reply-To: <1380407761-2949-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

 Storing MAC ADDR of each function in it's priv structure to
 avoid issuing MAC_ADDR get IOCTL. Based on a flag set/unset
 it's decided if MAC_ADDR is stored in priv structure or IOCTL
 needs to be issued.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_iscsi.c |    3 ++-
 drivers/scsi/be2iscsi/be_main.c  |    1 +
 drivers/scsi/be2iscsi/be_main.h  |    1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index ef36be00..2496ea7 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -840,7 +840,7 @@ int beiscsi_get_macaddr(char *buf, struct beiscsi_hba *phba)
 	struct be_cmd_get_nic_conf_resp resp;
 	int rc;
 
-	if (strlen(phba->mac_address))
+	if (phba->mac_addr_set)
 		return sysfs_format_mac(buf, phba->mac_address, ETH_ALEN);
 
 	memset(&resp, 0, sizeof(resp));
@@ -848,6 +848,7 @@ int beiscsi_get_macaddr(char *buf, struct beiscsi_hba *phba)
 	if (rc)
 		return rc;
 
+	phba->mac_addr_set = true;
 	memcpy(phba->mac_address, resp.mac_address, ETH_ALEN);
 	return sysfs_format_mac(buf, phba->mac_address, ETH_ALEN);
 }
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 0abed0a..5ba575f 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -4948,6 +4948,7 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 	beiscsi_hba_attrs_init(phba);
 
 	phba->fw_timeout = false;
+	phba->mac_addr_set = false;
 
 
 	switch (pcidev->device) {
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 3e45257..5165515 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -348,6 +348,7 @@ struct beiscsi_hba {
 	bool ue_detected;
 	struct delayed_work beiscsi_hw_check_task;
 
+	bool mac_addr_set;
 	u8 mac_address[ETH_ALEN];
 	char fw_ver_str[BEISCSI_VER_STRLEN];
 	char wq_name[20];
-- 
1.7.10.4

