From: akpm@linux-foundation.org
Subject: [patch 03/30] megaraid: fix warnings when CONFIG_PROC_FS=n
Date: Fri, 16 Feb 2007 01:46:21 -0800
Message-ID: <200702160946.l1G9kL9b026624@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37208 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423530AbXBPJtn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Feb 2007 04:49:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, wharms@bfs.de, adobriyan@gmail.com, bunk@stusta.de

From: walter harms <wharms@bfs.de>

Signed-off-by: walter harms <wharms@bfs.de>
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/megaraid.c |   17 +++++++++++------
 drivers/scsi/megaraid.h |    4 ++--
 2 files changed, 13 insertions(+), 8 deletions(-)

diff -puN drivers/scsi/megaraid.c~megaraid-fix-warnings-when-config_proc_fs=n drivers/scsi/megaraid.c
--- a/drivers/scsi/megaraid.c~megaraid-fix-warnings-when-config_proc_fs=n
+++ a/drivers/scsi/megaraid.c
@@ -3177,7 +3177,10 @@ proc_rdrv(adapter_t *adapter, char *page
 
 	return len;
 }
-
+#else
+static inline void mega_create_proc_entry(int index, struct proc_dir_entry *parent)
+{
+}
 #endif
 
 
@@ -4342,7 +4345,7 @@ mega_support_cluster(adapter_t *adapter)
 	return 0;
 }
 
-
+#ifdef CONFIG_PROC_FS
 /**
  * mega_adapinq()
  * @adapter - pointer to our soft state
@@ -4447,7 +4450,7 @@ mega_internal_dev_inquiry(adapter_t *ada
 
 	return rval;
 }
-
+#endif
 
 /**
  * mega_internal_command()
@@ -4965,7 +4968,6 @@ megaraid_remove_one(struct pci_dev *pdev
 {
 	struct Scsi_Host *host = pci_get_drvdata(pdev);
 	adapter_t *adapter = (adapter_t *)host->hostdata;
-	char	buf[12] = { 0 };
 
 	scsi_remove_host(host);
 
@@ -5011,8 +5013,11 @@ megaraid_remove_one(struct pci_dev *pdev
 		remove_proc_entry("raiddrives-30-39",
 				adapter->controller_proc_dir_entry);
 #endif
-		sprintf(buf, "hba%d", adapter->host->host_no);
-		remove_proc_entry(buf, mega_proc_dir_entry);
+		{
+			char	buf[12] = { 0 };
+			sprintf(buf, "hba%d", adapter->host->host_no);
+			remove_proc_entry(buf, mega_proc_dir_entry);
+		}
 	}
 #endif
 
diff -puN drivers/scsi/megaraid.h~megaraid-fix-warnings-when-config_proc_fs=n drivers/scsi/megaraid.h
--- a/drivers/scsi/megaraid.h~megaraid-fix-warnings-when-config_proc_fs=n
+++ a/drivers/scsi/megaraid.h
@@ -1002,7 +1002,6 @@ static int megaraid_reset(Scsi_Cmnd *);
 static int megaraid_abort_and_reset(adapter_t *, Scsi_Cmnd *, int);
 static int megaraid_biosparam(struct scsi_device *, struct block_device *,
 		sector_t, int []);
-static int mega_print_inquiry(char *, char *);
 
 static int mega_build_sglist (adapter_t *adapter, scb_t *scb,
 			      u32 *buffer, u32 *length);
@@ -1024,6 +1023,7 @@ static int mega_init_scb (adapter_t *);
 static int mega_is_bios_enabled (adapter_t *);
 
 #ifdef CONFIG_PROC_FS
+static int mega_print_inquiry(char *, char *);
 static void mega_create_proc_entry(int, struct proc_dir_entry *);
 static int proc_read_config(char *, char **, off_t, int, int *, void *);
 static int proc_read_stat(char *, char **, off_t, int, int *, void *);
@@ -1040,10 +1040,10 @@ static int proc_rdrv_20(char *, char **,
 static int proc_rdrv_30(char *, char **, off_t, int, int *, void *);
 static int proc_rdrv_40(char *, char **, off_t, int, int *, void *);
 static int proc_rdrv(adapter_t *, char *, int, int);
-#endif
 
 static int mega_adapinq(adapter_t *, dma_addr_t);
 static int mega_internal_dev_inquiry(adapter_t *, u8, u8, dma_addr_t);
+#endif
 
 static int mega_support_ext_cdb(adapter_t *);
 static mega_passthru* mega_prepare_passthru(adapter_t *, scb_t *,
_
