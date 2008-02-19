From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 2/2] aic94xx: Use sas_request_addr() to provide SAS WWN if
	the adapter lacks one
Date: Tue, 19 Feb 2008 10:50:49 -0800
Message-ID: <20080219185049.GC5414@tree.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:57245 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004AbYBSSuu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Feb 2008 13:50:50 -0500
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m1JIoZ3x028883
	for <linux-scsi@vger.kernel.org>; Tue, 19 Feb 2008 13:50:35 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1JIooGQ217244
	for <linux-scsi@vger.kernel.org>; Tue, 19 Feb 2008 11:50:50 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1JIonXG005984
	for <linux-scsi@vger.kernel.org>; Tue, 19 Feb 2008 11:50:50 -0700
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Alexis Bruemmer <alexisb@us.ibm.com>

If the aic94xx chip doesn't have a SAS address in the chip's flash memory,
make libsas get one for us.

Resend of 8 Oct 2007 patch, now based off 2.6.25-rc2 + scsi_misc.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/aic94xx/aic94xx.h      |   16 ----------------
 drivers/scsi/aic94xx/aic94xx_hwi.c  |   20 +++++++++-----------
 drivers/scsi/aic94xx/aic94xx_init.c |    2 --
 3 files changed, 9 insertions(+), 29 deletions(-)

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
index 098b5f3..940a207 100644
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
@@ -657,8 +656,7 @@ int asd_init_hw(struct asd_ha_struct *asd_ha)
 
 	asd_init_ctxmem(asd_ha);
 
-	asd_get_user_sas_addr(asd_ha);
-	if (!asd_ha->hw_prof.sas_addr[0]) {
+	if (asd_get_user_sas_addr(asd_ha)) {
 		asd_printk("No SAS Address provided for %s\n",
 			   pci_name(asd_ha->pcidev));
 		err = -ENODEV;
diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index 5d761eb..1824b0b 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -56,8 +56,6 @@ MODULE_PARM_DESC(collector, "\n"
 	"\tThe aic94xx SAS LLDD supports both modes.\n"
 	"\tDefault: 0 (Direct Mode).\n");
 
-char sas_addr_str[2*SAS_ADDR_SIZE + 1] = "";
-
 static struct scsi_transport_template *aic94xx_transport_template;
 static int asd_scan_finished(struct Scsi_Host *, unsigned long);
 static void asd_scan_start(struct Scsi_Host *);
