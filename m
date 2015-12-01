From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>
Subject: [PATCH 08/10] aacraid: Disable device ID wildcard
Date: Tue, 1 Dec 2015 04:39:46 -0800
Message-ID: <1448973589-9216-9-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
References: <1448973589-9216-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:48258 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754354AbbLATeW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2015 14:34:22 -0500
In-Reply-To: <1448973589-9216-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Mahesh.Rajashekhara@pmcs.com, Murthy.Bhat@pmcs.com, Santosh.Akula@pmcs.com, Gana.Sridaran@pmcs.com, aacraid@pmc-sierra.com, Rich.Bono@pmcs.com, RaghavaAditya.Renukunta@pmcs.com

From: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>

Added module parameter that disables device ID wild card binding.

Signed-off-by: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>
---
 drivers/scsi/aacraid/aachba.c  | 5 +++++
 drivers/scsi/aacraid/aacraid.h | 1 +
 drivers/scsi/aacraid/linit.c   | 5 +++++
 3 files changed, 11 insertions(+)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 06cbab8..87f4f21 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -315,6 +315,11 @@ MODULE_PARM_DESC(wwn, "Select a WWN type for the arrays:\n"
 	"\t1 - Array Meta Data Signature (default)\n"
 	"\t2 - Adapter Serial Number");
 
+int aac_disable_device_id_wildcards;
+module_param_named(disable_device_id_wildcards,
+	aac_disable_device_id_wildcards, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(disable_device_id_wildcards,
+	"Disable device ID wildcards");
 
 static inline int aac_valid_context(struct scsi_cmnd *scsicmd,
 		struct fib *fibptr) {
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 594de5f..7708a2c 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -2177,3 +2177,4 @@ extern int aac_commit;
 extern int update_interval;
 extern int check_interval;
 extern int aac_check_reset;
+extern int aac_disable_device_id_wildcards;
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 3a4dbe7..2094842 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1135,6 +1135,11 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	u64 dmamask;
 	extern int aac_sync_mode;
 
+	if (aac_disable_device_id_wildcards &&
+		id->subvendor == PCI_ANY_ID &&
+		id->subdevice == PCI_ANY_ID)
+		return -ENODEV;
+
 	/*
 	 * Only series 7 needs freset.
 	 */
-- 
1.9.1

