From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 2/2] aic94xx: Use sas_request_addr() to provide SAS addr if
	the adapter lacks one
Date: Mon, 8 Oct 2007 17:43:36 -0700
Message-ID: <20071009004335.GD16003@tree.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:46771 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857AbXJIAnA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Oct 2007 20:43:00 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Alexis Bruemmer <alexisb@us.ibm.com>

If the aic94xx chip doesn't have a SAS address in the chip's flash memory,
make libsas get one for us.  Also clean out some old code that had been
used to do this in the past.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/aic94xx/aic94xx.h      |   16 ----------------
 drivers/scsi/aic94xx/aic94xx_hwi.c  |   21 ++++++++++-----------
 drivers/scsi/aic94xx/aic94xx_init.c |    2 --
 3 files changed, 10 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx.h b/drivers/scsi/aic94xx/aic94xx.h
index 32f513b..aee235f 100644
--- a/drivers/scsi/aic94xx/aic94xx.h
+++ b/drivers/scsi/aic94xx/aic94xx.h
@@ -58,7 +58,6 @@
 
 extern struct kmem_cache *asd_dma_token_cache;
 extern struct kmem_cache *asd_ascb_cache;
-extern char sas_addr_str[2*SAS_ADDR_SIZE + 1];
 
 static inline void asd_stringify_sas_addr(char *p, const u8 *sas_addr)
 {
@@ -68,21 +67,6 @@ static inline void asd_stringify_sas_addr(char *p, const u8 *sas_addr)
 	*p = '\0';
 }
 
-static inline void asd_destringify_sas_addr(u8 *sas_addr, const char *p)
-{
-	int i;
-	for (i = 0; i < SAS_ADDR_SIZE; i++) {
-		u8 h, l;
-		if (!*p)
-			break;
-		h = isdigit(*p) ? *p-'0' : *p-'A'+10;
-		p++;
-		l = isdigit(*p) ? *p-'0' : *p-'A'+10;
-		p++;
-		sas_addr[i] = (h<<4) | l;
-	}
-}
-
 struct asd_ha_struct;
 struct asd_ascb;
 
diff --git a/drivers/scsi/aic94xx/aic94xx_hwi.c b/drivers/scsi/aic94xx/aic94xx_hwi.c
index 0cd7eed..1dc5400 100644
--- a/drivers/scsi/aic94xx/aic94xx_hwi.c
+++ b/drivers/scsi/aic94xx/aic94xx_hwi.c
@@ -27,6 +27,7 @@
 #include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/module.h>
+#include <linux/firmware.h>
 
 #include "aic94xx.h"
 #include "aic94xx_reg.h"
@@ -38,16 +39,14 @@ u32 MBAR0_SWB_SIZE;
 
 /* ---------- Initialization ---------- */
 
-static void asd_get_user_sas_addr(struct asd_ha_struct *asd_ha)
+static int asd_get_user_sas_addr(struct asd_ha_struct *asd_ha)
 {
-	extern char sas_addr_str[];
-	/* If the user has specified a WWN it overrides other settings
-	 */
-	if (sas_addr_str[0] != '\0')
-		asd_destringify_sas_addr(asd_ha->hw_prof.sas_addr,
-					 sas_addr_str);
-	else if (asd_ha->hw_prof.sas_addr[0] != 0)
-		asd_stringify_sas_addr(sas_addr_str, asd_ha->hw_prof.sas_addr);
+	/* adapter came with a sas address */
+	if (asd_ha->hw_prof.sas_addr[0])
+		return 0;
+
+	return sas_request_addr(asd_ha->sas_ha.core.shost,
+				asd_ha->hw_prof.sas_addr);
 }
 
 static void asd_propagate_sas_addr(struct asd_ha_struct *asd_ha)
@@ -657,8 +657,7 @@ int asd_init_hw(struct asd_ha_struct *asd_ha)
 
 	asd_init_ctxmem(asd_ha);
 
-	asd_get_user_sas_addr(asd_ha);
-	if (!asd_ha->hw_prof.sas_addr[0]) {
+	if (asd_get_user_sas_addr(asd_ha)) {
 		asd_printk("No SAS Address provided for %s\n",
 			   pci_name(asd_ha->pcidev));
 		err = -ENODEV;
diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index b70d6e7..5c99f27 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -54,8 +54,6 @@ MODULE_PARM_DESC(collector, "\n"
 	"\tThe aic94xx SAS LLDD supports both modes.\n"
 	"\tDefault: 0 (Direct Mode).\n");
 
-char sas_addr_str[2*SAS_ADDR_SIZE + 1] = "";
-
 static struct scsi_transport_template *aic94xx_transport_template;
 static int asd_scan_finished(struct Scsi_Host *, unsigned long);
 static void asd_scan_start(struct Scsi_Host *);
