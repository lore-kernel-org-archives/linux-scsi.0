From: akpm@osdl.org
Subject: [patch 14/36] magaraid: check for firmware version
Date: Tue, 10 Oct 2006 14:41:31 -0700
Message-ID: <200610102141.k9ALfVxF025390@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:41886 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965124AbWJJVmR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Oct 2006 17:42:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, jkrzyszt@tis.icnet.pl, Seokmann.Ju@lsil.com

From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>

The old megaraid driver is apparently borken for firmware newer than 6.61.

megaraid_mbox works OK for Janusz with F/W 6.61.

Check for the F/W version and display a helpful warning if it is too high.  It
should make life easier for those who may face the problem.

Cc: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/megaraid/megaraid_mbox.c |   16 ++++++++++++++++
 drivers/scsi/megaraid/megaraid_mbox.h |    1 +
 2 files changed, 17 insertions(+)

diff -puN drivers/scsi/megaraid/megaraid_mbox.c~megaraid-check-for-firmware-version drivers/scsi/megaraid/megaraid_mbox.c
--- a/drivers/scsi/megaraid/megaraid_mbox.c~megaraid-check-for-firmware-version
+++ a/drivers/scsi/megaraid/megaraid_mbox.c
@@ -25,6 +25,7 @@
  * Dell PERC3/QC			101E	1960	1028	0471
  * Dell PERC3/DC			101E	1960	1028	0493
  * Dell PERC3/SC			101E	1960	1028	0475
+ * Dell CERC ATA100/4ch with F/W<=6.61	101E	1960	1028	0511
  * Dell PERC3/Di			1028	1960	1028	0123
  * Dell PERC4/SC			1000	1960	1028	0520
  * Dell PERC4/DC			1000	1960	1028	0518
@@ -807,6 +808,21 @@ megaraid_init_mbox(adapter_t *adapter)
 		goto out_alloc_cmds;
 	}
 
+	// Compatibility check
+	if (adapter->pdev->vendor == PCI_VENDOR_ID_AMI &&
+			adapter->pdev->device == PCI_DEVICE_ID_AMI_MEGARAID3 &&
+			adapter->pdev->subsystem_vendor == PCI_VENDOR_ID_DELL &&
+			adapter->pdev->subsystem_device == PCI_SUBSYS_ID_CERC_ATA100_4CH &&
+			(adapter->fw_version[0] > '6' ||
+			 (adapter->fw_version[0] == '6' &&
+			  adapter->fw_version[2] > '6') ||
+			 (adapter->fw_version[0] == '6'
+			  && adapter->fw_version[2] == '6'
+			  && adapter->fw_version[3] > '1'))) {
+		con_log(CL_ANN, (KERN_WARNING
+			"megaraid: problems? downgrade F/W to version 6.61\n"));
+	}
+
 	// Do we support extended CDBs
 	adapter->max_cdb_sz = 10;
 	if (megaraid_mbox_extended_cdb(adapter) == 0) {
diff -puN drivers/scsi/megaraid/megaraid_mbox.h~megaraid-check-for-firmware-version drivers/scsi/megaraid/megaraid_mbox.h
--- a/drivers/scsi/megaraid/megaraid_mbox.h~megaraid-check-for-firmware-version
+++ a/drivers/scsi/megaraid/megaraid_mbox.h
@@ -88,6 +88,7 @@
 #define PCI_SUBSYS_ID_PERC3_QC				0x0471
 #define PCI_SUBSYS_ID_PERC3_DC				0x0493
 #define PCI_SUBSYS_ID_PERC3_SC				0x0475
+#define PCI_SUBSYS_ID_CERC_ATA100_4CH			0x0511
 
 
 #define MBOX_MAX_SCSI_CMDS	128	// number of cmds reserved for kernel
_
