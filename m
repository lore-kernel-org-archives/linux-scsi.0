From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH 3/6] be2iscsi: Fix MCCQ posting for Mbx-Cmd after driver initialization is complete
Date: Thu, 27 Mar 2014 12:39:27 -0400
Message-ID: <1395938371-2149-3-git-send-email-Jayamohan.Kallickal@emulex.com>
References: <1395938371-2149-1-git-send-email-Jayamohan.Kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:52935 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101AbaC0Qjp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Mar 2014 12:39:45 -0400
Received: by mail-pd0-f172.google.com with SMTP id p10so3585091pdj.31
        for <linux-scsi@vger.kernel.org>; Thu, 27 Mar 2014 09:39:44 -0700 (PDT)
In-Reply-To: <1395938371-2149-1-git-send-email-Jayamohan.Kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <Jayamohan.Kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

 Even before probe for function was completed, iSCSI Daemon had initiated login
 to target while OS was coming up. The targets which had node.startup=automatic,
 login process was initiated.Since function specific initialization was still in
 progress this lead to kernel panic.
 The reson was MCCQ was not yet created and login Mbx_Cmd was sent on MCCQ.
 wrb_from_mccq() failed with kernel-panic access.

 In the fix checking in alloc_mcc_tag() if driver initialization is complete or not.
 Based on the result driver continues or return with an Error.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <Jayamohan.Kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_cmds.c | 8 ++++++++
 drivers/scsi/be2iscsi/be_main.c | 2 ++
 drivers/scsi/be2iscsi/be_main.h | 1 +
 3 files changed, 11 insertions(+)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index 1432ed5..4cabf5f 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -118,6 +118,14 @@ unsigned int alloc_mcc_tag(struct beiscsi_hba *phba)
 {
 	unsigned int tag = 0;
 
+
+	if (phba->state & BE_ADAPTER_INIT_PHASE) {
+		beiscsi_log(phba, KERN_ERR,
+			    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
+			    "BC_%d : Driver Initialization still in progress\n");
+		return tag;
+	}
+
 	if (phba->ctrl.mcc_tag_available) {
 		tag = phba->ctrl.mcc_tag[phba->ctrl.mcc_alloc_index];
 		phba->ctrl.mcc_tag[phba->ctrl.mcc_alloc_index] = 0;
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 0c9e270..317deee 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -598,6 +598,7 @@ static struct beiscsi_hba *beiscsi_hba_alloc(struct pci_dev *pcidev)
 	phba->pcidev = pci_dev_get(pcidev);
 	pci_set_drvdata(pcidev, phba);
 	phba->interface_handle = 0xFFFFFFFF;
+	phba->state = BE_ADAPTER_INIT_PHASE;
 
 	if (iscsi_host_add(shost, &phba->pcidev->dev))
 		goto free_devices;
@@ -5714,6 +5715,7 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 		goto free_blkenbld;
 	}
 	hwi_enable_intr(phba);
+	phba->state &= ~BE_ADAPTER_INIT_PHASE;
 
 	if (beiscsi_setup_boot_info(phba))
 		/*
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index d5901a7..581ebdb 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -105,6 +105,7 @@
 #define BE_ADAPTER_LINK_DOWN	0x002
 #define BE_ADAPTER_PCI_ERR	0x004
 #define BE_ADAPTER_STATE_SHUTDOWN	0x008
+#define BE_ADAPTER_INIT_PHASE	0x8000
 
 
 #define BEISCSI_CLEAN_UNLOAD	0x01
-- 
1.8.5.3

