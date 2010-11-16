From: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Subject: [PATCH 1/1] pmcraid driver disable msix and other changes
Date: Tue, 16 Nov 2010 13:43:41 -0800 (PST)
Message-ID: <alpine.LNX.1.10.1011161334560.1759@rslab235.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:40008 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756355Ab0KPXmb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Nov 2010 18:42:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com
Cc: anil_ravindranath@pmc-sierra.com


The following are the fixes in this patch:
1. Disable msi-x for now
2. Change device configuration entry size

Signed-off-by: Anil Ravindranath<anil_ravindranath@pmc-sierra.com>

 pmcraid.c |    4 +++-
 pmcraid.h |    6 ++----
 2 files changed, 5 insertions(+), 5 deletions(-)

--- scsi-misc-2.6.orig/drivers/scsi/pmcraid.h	2010-11-04 12:03:46.000000000 -0700
+++ scsi-misc-2.6/drivers/scsi/pmcraid.h	2010-11-04 11:15:06.000000000 -0700
@@ -42,7 +42,7 @@
  */
 #define PMCRAID_DRIVER_NAME		"PMC MaxRAID"
 #define PMCRAID_DEVFILE			"pmcsas"
-#define PMCRAID_DRIVER_VERSION		"2.0.3"
+#define PMCRAID_DRIVER_VERSION		"1.0.3"
 #define PMCRAID_DRIVER_DATE		__DATE__
 
 #define PMCRAID_FW_VERSION_1		0x002
@@ -333,11 +333,9 @@
 	__u8  lun[PMCRAID_LUN_LEN];
 } __attribute__((packed, aligned(4)));
 
-/* extended configuration table sizes are of 64 bytes in size */
-#define PMCRAID_CFGTE_EXT_SIZE	32
+/* extended configuration table sizes are also of 32 bytes in size */
 struct pmcraid_config_table_entry_ext {
 	struct pmcraid_config_table_entry cfgte;
-	__u8  cfgte_ext[PMCRAID_CFGTE_EXT_SIZE];
 };
 
 /* resource types (config_table_entry.resource_type values) */
--- scsi-misc-2.6.orig/drivers/scsi/pmcraid.c	2010-11-04 12:03:38.000000000 -0700
+++ scsi-misc-2.6/drivers/scsi/pmcraid.c	2010-11-04 12:11:21.000000000 -0700
@@ -62,6 +62,7 @@
 static unsigned int pmcraid_debug_log;
 static unsigned int pmcraid_disable_aen;
 static unsigned int pmcraid_log_level = IOASC_LOG_LEVEL_MUST;
+static unsigned int pmcraid_enable_msix;
 
 /*
  * Data structures to support multiple adapters by the LLD.
@@ -4689,7 +4690,8 @@
 	int rc;
 	struct pci_dev *pdev = pinstance->pdev;
 
-	if (pci_find_capability(pdev, PCI_CAP_ID_MSIX)) {
+	if ((pmcraid_enable_msix) &&
+		(pci_find_capability(pdev, PCI_CAP_ID_MSIX))) {
 		int num_hrrq = PMCRAID_NUM_MSIX_VECTORS;
 		struct msix_entry entries[PMCRAID_NUM_MSIX_VECTORS];
 		int i;
