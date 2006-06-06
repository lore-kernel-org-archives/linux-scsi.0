From: Alexis Bruemmer <alexisb@us.ibm.com>
Subject: [PATCH 4/7] aic94xx: remove sas_common.c
Date: Tue, 06 Jun 2006 16:48:43 -0700
Message-ID: <1149637723.25278.75.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:45540 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751374AbWFFXtA
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Jun 2006 19:49:00 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e35.co.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k56Nn0BZ004576
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jun 2006 19:49:00 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.13.6/NCO/VER7.0) with ESMTP id k56NmuDR081600
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jun 2006 17:48:57 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k56NmxB6017266
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jun 2006 17:48:59 -0600
Received: from alexis.beaverton.ibm.com (alexis.beaverton.ibm.com [9.47.17.62])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k56Nmx97017240
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jun 2006 17:48:59 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Remove the drvers/scsi/sas/sas_common.c file

Signed-off-by: Alexis Bruemmer <alexisb@us.ibm.com>


---
 drivers/scsi/sas/sas_common.c |  115 ------------------------------------------
 drivers/scsi/sas/Makefile     |    1 
 drivers/scsi/sas/sas_init.c   |   25 +++++++++
 3 files changed, 25 insertions(+), 116 deletions(-)

Index: aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_common.c
===================================================================
--- aic94xx-sas-2.6-patched.orig/drivers/scsi/sas/sas_common.c
+++ /dev/null
@@ -1,115 +0,0 @@
-/*
- * Serial Attached SCSI (SAS) class common functions
- *
- * Copyright (C) 2005 Adaptec, Inc.  All rights reserved.
- * Copyright (C) 2005 Luben Tuikov <luben_tuikov@adaptec.com>
- *
- * This file is licensed under GPLv2.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation; either version 2 of the
- * License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
- * USA
- *
- * $Id: //depot/sas-class/sas_common.c#9 $
- */
-
-#include <scsi/sas/sas_class.h>
-#include "sas_internal.h"
-
-int sas_show_class(enum sas_class class, char *buf)
-{
-	static const char *class_str[] = {
-		[SAS] = "SAS",
-		[EXPANDER] = "EXPANDER",
-	};
-	return sprintf(buf, "%s\n", class_str[class]);
-}
-
-int sas_show_proto(enum sas_proto proto, char *page)
-{
-	static const char *proto_str[] = {
-		[SATA_PROTO] = "SATA",
-		[SAS_PROTO_SMP] = "SMP",
-		[SAS_PROTO_STP] = "STP",
-		[SAS_PROTO_SSP] = "SSP",
-	};
-	int  v;
-	char *buf = page;
-
-	for (v = 1; proto != 0 && v <= SAS_PROTO_SSP; v <<= 1) {
-		if (v & proto) {
-			buf += sprintf(buf, "%s", proto_str[v]);
-
-			if (proto & ~((v<<1)-1))
-				buf += sprintf(buf, "|");
-			else
-				buf += sprintf(buf, "\n");
-		}
-	}
-	return buf-page;
-}
-
-int sas_show_linkrate(enum sas_phy_linkrate linkrate, char *page)
-{
-	static const char *phy_linkrate_str[] = {
-		[PHY_LINKRATE_NONE] = "",
-		[PHY_DISABLED] = "disabled",
-		[PHY_RESET_PROBLEM] = "phy reset problem",
-		[PHY_SPINUP_HOLD] = "phy spinup hold",
-		[PHY_PORT_SELECTOR] = "phy port selector",
-		[PHY_LINKRATE_1_5] = "1,5 GB/s",
-		[PHY_LINKRATE_3]  = "3,0 GB/s",
-		[PHY_LINKRATE_6] = "6,0 GB/s",
-	};
-	return sprintf(page, "%s\n", phy_linkrate_str[linkrate]);
-}
-
-int sas_show_oob_mode(enum sas_oob_mode oob_mode, char *buf)
-{
-	switch (oob_mode) {
-	case OOB_NOT_CONNECTED:
-		return sprintf(buf, "%s", "");
-		break;
-	case SATA_OOB_MODE:
-		return sprintf(buf, "%s\n", "SATA");
-		break;
-	case SAS_OOB_MODE:
-		return sprintf(buf, "%s\n", "SAS");
-		break;
-	}
-	return 0;
-}
-
-void sas_hash_addr(u8 *hashed, const u8 *sas_addr)
-{
-	const u32 poly = 0x00DB2777;
-	u32 	r = 0;
-	int 	i;
-
-	for (i = 0; i < 8; i++) {
-		int b;
-		for (b = 7; b >= 0; b--) {
-			r <<= 1;
-			if ((1 << b) & sas_addr[i]) {
-				if (!(r & 0x01000000))
-					r ^= poly;
-			} else if (r & 0x01000000)
-				r ^= poly;
-		}
-	}
-
-	hashed[0] = (r >> 16) & 0xFF;
-	hashed[1] = (r >> 8) & 0xFF ;
-	hashed[2] = r & 0xFF;
-}
Index: aic94xx-sas-2.6-patched/drivers/scsi/sas/Makefile
===================================================================
--- aic94xx-sas-2.6-patched.orig/drivers/scsi/sas/Makefile
+++ aic94xx-sas-2.6-patched/drivers/scsi/sas/Makefile
@@ -32,7 +32,6 @@ clean-files += expander_conf
 
 obj-$(CONFIG_SCSI_SAS_DOMAIN_ATTRS) += scsi_transport_sas_domain.o
 scsi_transport_sas_domain-y +=  sas_init.o     \
-		sas_common.o   \
 		sas_phy.o      \
 		sas_port.o     \
 		sas_event.o    \
Index: aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_init.c
===================================================================
--- aic94xx-sas-2.6-patched.orig/drivers/scsi/sas/sas_init.c
+++ aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_init.c
@@ -40,6 +40,31 @@
 
 kmem_cache_t *sas_task_cache;
 
+/*------------ SAS addr hash -----------*/
+void sas_hash_addr(u8 *hashed, const u8 *sas_addr)
+{
+        const u32 poly = 0x00DB2777;
+        u32     r = 0;
+        int     i;
+
+        for (i = 0; i < 8; i++) {
+                int b;
+                for (b = 7; b >= 0; b--) {
+                        r <<= 1;
+                        if ((1 << b) & sas_addr[i]) {
+                                if (!(r & 0x01000000))
+                                        r ^= poly;
+                        } else if (r & 0x01000000)
+                                r ^= poly;
+                }
+        }
+
+        hashed[0] = (r >> 16) & 0xFF;
+        hashed[1] = (r >> 8) & 0xFF ;
+        hashed[2] = r & 0xFF;
+}
+
+
 /* ---------- HA events ---------- */
 
 void sas_hae_reset(void *data)


