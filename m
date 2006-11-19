From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] megaraid: build with PROC_FS=n
Date: Sat, 18 Nov 2006 20:32:44 -0800
Message-ID: <20061118203244.abd2dc81.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:34035 "EHLO
	rgminet01.oracle.com") by vger.kernel.org with ESMTP
	id S1756117AbWKSEch (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Nov 2006 23:32:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejb <james.bottomley@steeleye.com>, Neela.Kolli@engenio.com

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix megaraid build error when PROC_FS=n:

drivers/built-in.o: In function `megaraid_probe_one':
megaraid.c:(.text.megaraid_probe_one+0xf68): undefined reference to `mega_create_proc_entry'
make: *** [.tmp_vmlinux1] Error 1

and these warnings:
drivers/scsi/megaraid.h:1004: warning: 'mega_print_inquiry' declared 'static' but never defined
drivers/scsi/megaraid.c:4362: warning: 'mega_adapinq' defined but not used
drivers/scsi/megaraid.c:4397: warning: 'mega_internal_dev_inquiry' defined but not used

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/megaraid.c |    8 ++++++++
 drivers/scsi/megaraid.h |    5 +++--
 2 files changed, 11 insertions(+), 2 deletions(-)

--- linux-2619-rc6g2.orig/drivers/scsi/megaraid.c
+++ linux-2619-rc6g2/drivers/scsi/megaraid.c
@@ -3177,6 +3177,12 @@ proc_rdrv(adapter_t *adapter, char *page
 	return len;
 }
 
+#else
+
+static inline void mega_create_proc_entry(int index,
+					struct proc_dir_entry *parent)
+{}
+
 #endif
 
 
@@ -4342,6 +4348,7 @@ mega_support_cluster(adapter_t *adapter)
 }
 
 
+#ifdef CONFIG_PROC_FS
 /**
  * mega_adapinq()
  * @adapter - pointer to our soft state
@@ -4446,6 +4453,7 @@ mega_internal_dev_inquiry(adapter_t *ada
 
 	return rval;
 }
+#endif
 
 
 /**
--- linux-2619-rc6g2.orig/drivers/scsi/megaraid.h
+++ linux-2619-rc6g2/drivers/scsi/megaraid.h
@@ -1001,7 +1001,9 @@ static int megaraid_reset(Scsi_Cmnd *);
 static int megaraid_abort_and_reset(adapter_t *, Scsi_Cmnd *, int);
 static int megaraid_biosparam(struct scsi_device *, struct block_device *,
 		sector_t, int []);
+#ifdef CONFIG_PROC_FS
 static int mega_print_inquiry(char *, char *);
+#endif
 
 static int mega_build_sglist (adapter_t *adapter, scb_t *scb,
 			      u32 *buffer, u32 *length);
@@ -1039,10 +1041,9 @@ static int proc_rdrv_20(char *, char **,
 static int proc_rdrv_30(char *, char **, off_t, int, int *, void *);
 static int proc_rdrv_40(char *, char **, off_t, int, int *, void *);
 static int proc_rdrv(adapter_t *, char *, int, int);
-#endif
-
 static int mega_adapinq(adapter_t *, dma_addr_t);
 static int mega_internal_dev_inquiry(adapter_t *, u8, u8, dma_addr_t);
+#endif
 
 static int mega_support_ext_cdb(adapter_t *);
 static mega_passthru* mega_prepare_passthru(adapter_t *, scb_t *,


---
