From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 10/21] lpfc: Re-organize source for easier device-id
 management
Date: Wed, 06 Jul 2016 12:36:03 -0700
Message-ID: <577d5da3.VBEk946TGTT57Ek1%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:35038 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755695AbcGFTgJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2016 15:36:09 -0400
Received: by mail-wm0-f52.google.com with SMTP id z126so123511477wme.0
        for <linux-scsi@vger.kernel.org>; Wed, 06 Jul 2016 12:36:08 -0700 (PDT)
Received: from flash ([192.19.245.250])
        by smtp.gmail.com with ESMTPSA id o10sm5158697wjs.38.2016.07.06.12.36.05
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Jul 2016 12:36:06 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Re-organize source for easier device-id management

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_ids.h  | 122 ++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_init.c | 101 +---------------------------------
 2 files changed, 123 insertions(+), 100 deletions(-)
 create mode 100644 drivers/scsi/lpfc/lpfc_ids.h

diff --git a/drivers/scsi/lpfc/lpfc_ids.h b/drivers/scsi/lpfc/lpfc_ids.h
new file mode 100644
index 0000000..5733fea
--- /dev/null
+++ b/drivers/scsi/lpfc/lpfc_ids.h
@@ -0,0 +1,122 @@
+/*******************************************************************
+ * This file is part of the Emulex Linux Device Driver for         *
+ * Fibre Channel Host Bus Adapters.                                *
+ * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
+ * EMULEX and SLI are trademarks of Emulex.                        *
+ * www.emulex.com                                                  *
+ * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
+ *                                                                 *
+ * This program is free software; you can redistribute it and/or   *
+ * modify it under the terms of version 2 of the GNU General       *
+ * Public License as published by the Free Software Foundation.    *
+ * This program is distributed in the hope that it will be useful. *
+ * ALL EXPRESS OR IMPLIED CONDITIONS, REPRESENTATIONS AND          *
+ * WARRANTIES, INCLUDING ANY IMPLIED WARRANTY OF MERCHANTABILITY,  *
+ * FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT, ARE      *
+ * DISCLAIMED, EXCEPT TO THE EXTENT THAT SUCH DISCLAIMERS ARE HELD *
+ * TO BE LEGALLY INVALID.  See the GNU General Public License for  *
+ * more details, a copy of which can be found in the file COPYING  *
+ * included with this package.                                     *
+ *******************************************************************/
+
+#include <linux/pci.h>
+
+const struct pci_device_id lpfc_id_table[] = {
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_VIPER,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_FIREFLY,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_THOR,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_PEGASUS,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_CENTAUR,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_DRAGONFLY,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_SUPERFLY,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_RFLY,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_PFLY,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_NEPTUNE,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_NEPTUNE_SCSP,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_NEPTUNE_DCSP,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_HELIOS,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_HELIOS_SCSP,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_HELIOS_DCSP,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_BMID,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_BSMB,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_ZEPHYR,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_HORNET,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_ZEPHYR_SCSP,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_ZEPHYR_DCSP,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_ZMID,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_ZSMB,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_TFLY,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_LP101,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_LP10000S,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_LP11000S,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_LPE11000S,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_SAT,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_SAT_MID,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_SAT_SMB,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_SAT_DCSP,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_SAT_SCSP,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_SAT_S,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_PROTEUS_VF,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_PROTEUS_PF,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_PROTEUS_S,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_SERVERENGINE, PCI_DEVICE_ID_TIGERSHARK,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_SERVERENGINE, PCI_DEVICE_ID_TOMCAT,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_FALCON,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_BALIUS,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_LANCER_FC,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_LANCER_FCOE,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_LANCER_FC_VF,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_LANCER_FCOE_VF,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_LANCER_G6_FC,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_SKYHAWK,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_SKYHAWK_VF,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{ 0 }
+};
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 8d940ed..6e11574 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -52,6 +52,7 @@
 #include "lpfc_crtn.h"
 #include "lpfc_vport.h"
 #include "lpfc_version.h"
+#include "lpfc_ids.h"
 
 char *_dump_buf_data;
 unsigned long _dump_buf_data_order;
@@ -11385,106 +11386,6 @@ lpfc_fof_queue_destroy(struct lpfc_hba *phba)
 	return 0;
 }
 
-static struct pci_device_id lpfc_id_table[] = {
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_VIPER,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_FIREFLY,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_THOR,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_PEGASUS,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_CENTAUR,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_DRAGONFLY,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_SUPERFLY,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_RFLY,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_PFLY,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_NEPTUNE,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_NEPTUNE_SCSP,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_NEPTUNE_DCSP,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_HELIOS,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_HELIOS_SCSP,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_HELIOS_DCSP,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_BMID,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_BSMB,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_ZEPHYR,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_HORNET,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_ZEPHYR_SCSP,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_ZEPHYR_DCSP,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_ZMID,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_ZSMB,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_TFLY,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_LP101,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_LP10000S,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_LP11000S,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_LPE11000S,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_SAT,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_SAT_MID,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_SAT_SMB,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_SAT_DCSP,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_SAT_SCSP,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_SAT_S,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_PROTEUS_VF,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_PROTEUS_PF,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_PROTEUS_S,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_SERVERENGINE, PCI_DEVICE_ID_TIGERSHARK,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_SERVERENGINE, PCI_DEVICE_ID_TOMCAT,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_FALCON,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_BALIUS,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_LANCER_FC,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_LANCER_FCOE,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_LANCER_FC_VF,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_LANCER_FCOE_VF,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_LANCER_G6_FC,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_SKYHAWK,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_SKYHAWK_VF,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{ 0 }
-};
-
 MODULE_DEVICE_TABLE(pci, lpfc_id_table);
 
 static const struct pci_error_handlers lpfc_err_handler = {
-- 
2.5.0

