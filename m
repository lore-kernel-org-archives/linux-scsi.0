From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 17/21] lpfc: Re-organize source for easier driver
 attribute management
Date: Wed, 06 Jul 2016 12:36:10 -0700
Message-ID: <577d5daa.odTk6bfekJXlS3LY%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:35103 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755740AbcGFTgQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2016 15:36:16 -0400
Received: by mail-wm0-f41.google.com with SMTP id z126so123514817wme.0
        for <linux-scsi@vger.kernel.org>; Wed, 06 Jul 2016 12:36:15 -0700 (PDT)
Received: from flash ([192.19.245.250])
        by smtp.gmail.com with ESMTPSA id c142sm8088834wme.18.2016.07.06.12.36.12
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Jul 2016 12:36:13 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Re-organize source for easier driver attribute management

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_attr.c |  97 +----------------------------------
 drivers/scsi/lpfc/lpfc_attr.h | 116 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 117 insertions(+), 96 deletions(-)
 create mode 100644 drivers/scsi/lpfc/lpfc_attr.h

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 07d8033..6793df8 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -48,6 +48,7 @@
 #include "lpfc_compat.h"
 #include "lpfc_crtn.h"
 #include "lpfc_vport.h"
+#include "lpfc_attr.h"
 
 #define LPFC_DEF_DEVLOSS_TMO 30
 #define LPFC_MIN_DEVLOSS_TMO 1
@@ -1939,102 +1940,6 @@ lpfc_##attr##_store(struct device *dev, struct device_attribute *attr, \
 }
 
 
-#define LPFC_ATTR(name, defval, minval, maxval, desc) \
-static uint lpfc_##name = defval;\
-module_param(lpfc_##name, uint, S_IRUGO);\
-MODULE_PARM_DESC(lpfc_##name, desc);\
-lpfc_param_init(name, defval, minval, maxval)
-
-#define LPFC_ATTR_R(name, defval, minval, maxval, desc) \
-static uint lpfc_##name = defval;\
-module_param(lpfc_##name, uint, S_IRUGO);\
-MODULE_PARM_DESC(lpfc_##name, desc);\
-lpfc_param_show(name)\
-lpfc_param_init(name, defval, minval, maxval)\
-static DEVICE_ATTR(lpfc_##name, S_IRUGO , lpfc_##name##_show, NULL)
-
-#define LPFC_ATTR_RW(name, defval, minval, maxval, desc) \
-static uint lpfc_##name = defval;\
-module_param(lpfc_##name, uint, S_IRUGO);\
-MODULE_PARM_DESC(lpfc_##name, desc);\
-lpfc_param_show(name)\
-lpfc_param_init(name, defval, minval, maxval)\
-lpfc_param_set(name, defval, minval, maxval)\
-lpfc_param_store(name)\
-static DEVICE_ATTR(lpfc_##name, S_IRUGO | S_IWUSR,\
-		   lpfc_##name##_show, lpfc_##name##_store)
-
-#define LPFC_ATTR_HEX_R(name, defval, minval, maxval, desc) \
-static uint lpfc_##name = defval;\
-module_param(lpfc_##name, uint, S_IRUGO);\
-MODULE_PARM_DESC(lpfc_##name, desc);\
-lpfc_param_hex_show(name)\
-lpfc_param_init(name, defval, minval, maxval)\
-static DEVICE_ATTR(lpfc_##name, S_IRUGO , lpfc_##name##_show, NULL)
-
-#define LPFC_ATTR_HEX_RW(name, defval, minval, maxval, desc) \
-static uint lpfc_##name = defval;\
-module_param(lpfc_##name, uint, S_IRUGO);\
-MODULE_PARM_DESC(lpfc_##name, desc);\
-lpfc_param_hex_show(name)\
-lpfc_param_init(name, defval, minval, maxval)\
-lpfc_param_set(name, defval, minval, maxval)\
-lpfc_param_store(name)\
-static DEVICE_ATTR(lpfc_##name, S_IRUGO | S_IWUSR,\
-		   lpfc_##name##_show, lpfc_##name##_store)
-
-#define LPFC_VPORT_ATTR(name, defval, minval, maxval, desc) \
-static uint lpfc_##name = defval;\
-module_param(lpfc_##name, uint, S_IRUGO);\
-MODULE_PARM_DESC(lpfc_##name, desc);\
-lpfc_vport_param_init(name, defval, minval, maxval)
-
-#define LPFC_VPORT_ATTR_R(name, defval, minval, maxval, desc) \
-static uint lpfc_##name = defval;\
-module_param(lpfc_##name, uint, S_IRUGO);\
-MODULE_PARM_DESC(lpfc_##name, desc);\
-lpfc_vport_param_show(name)\
-lpfc_vport_param_init(name, defval, minval, maxval)\
-static DEVICE_ATTR(lpfc_##name, S_IRUGO , lpfc_##name##_show, NULL)
-
-#define LPFC_VPORT_ULL_ATTR_R(name, defval, minval, maxval, desc) \
-static uint64_t lpfc_##name = defval;\
-module_param(lpfc_##name, ullong, S_IRUGO);\
-MODULE_PARM_DESC(lpfc_##name, desc);\
-lpfc_vport_param_show(name)\
-lpfc_vport_param_init(name, defval, minval, maxval)\
-static DEVICE_ATTR(lpfc_##name, S_IRUGO , lpfc_##name##_show, NULL)
-
-#define LPFC_VPORT_ATTR_RW(name, defval, minval, maxval, desc) \
-static uint lpfc_##name = defval;\
-module_param(lpfc_##name, uint, S_IRUGO);\
-MODULE_PARM_DESC(lpfc_##name, desc);\
-lpfc_vport_param_show(name)\
-lpfc_vport_param_init(name, defval, minval, maxval)\
-lpfc_vport_param_set(name, defval, minval, maxval)\
-lpfc_vport_param_store(name)\
-static DEVICE_ATTR(lpfc_##name, S_IRUGO | S_IWUSR,\
-		   lpfc_##name##_show, lpfc_##name##_store)
-
-#define LPFC_VPORT_ATTR_HEX_R(name, defval, minval, maxval, desc) \
-static uint lpfc_##name = defval;\
-module_param(lpfc_##name, uint, S_IRUGO);\
-MODULE_PARM_DESC(lpfc_##name, desc);\
-lpfc_vport_param_hex_show(name)\
-lpfc_vport_param_init(name, defval, minval, maxval)\
-static DEVICE_ATTR(lpfc_##name, S_IRUGO , lpfc_##name##_show, NULL)
-
-#define LPFC_VPORT_ATTR_HEX_RW(name, defval, minval, maxval, desc) \
-static uint lpfc_##name = defval;\
-module_param(lpfc_##name, uint, S_IRUGO);\
-MODULE_PARM_DESC(lpfc_##name, desc);\
-lpfc_vport_param_hex_show(name)\
-lpfc_vport_param_init(name, defval, minval, maxval)\
-lpfc_vport_param_set(name, defval, minval, maxval)\
-lpfc_vport_param_store(name)\
-static DEVICE_ATTR(lpfc_##name, S_IRUGO | S_IWUSR,\
-		   lpfc_##name##_show, lpfc_##name##_store)
-
 static DEVICE_ATTR(bg_info, S_IRUGO, lpfc_bg_info_show, NULL);
 static DEVICE_ATTR(bg_guard_err, S_IRUGO, lpfc_bg_guard_err_show, NULL);
 static DEVICE_ATTR(bg_apptag_err, S_IRUGO, lpfc_bg_apptag_err_show, NULL);
diff --git a/drivers/scsi/lpfc/lpfc_attr.h b/drivers/scsi/lpfc/lpfc_attr.h
new file mode 100644
index 0000000..b2bd28e
--- /dev/null
+++ b/drivers/scsi/lpfc/lpfc_attr.h
@@ -0,0 +1,116 @@
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
+#define LPFC_ATTR(name, defval, minval, maxval, desc) \
+static uint lpfc_##name = defval;\
+module_param(lpfc_##name, uint, S_IRUGO);\
+MODULE_PARM_DESC(lpfc_##name, desc);\
+lpfc_param_init(name, defval, minval, maxval)
+
+#define LPFC_ATTR_R(name, defval, minval, maxval, desc) \
+static uint lpfc_##name = defval;\
+module_param(lpfc_##name, uint, S_IRUGO);\
+MODULE_PARM_DESC(lpfc_##name, desc);\
+lpfc_param_show(name)\
+lpfc_param_init(name, defval, minval, maxval)\
+static DEVICE_ATTR(lpfc_##name, S_IRUGO, lpfc_##name##_show, NULL)
+
+#define LPFC_ATTR_RW(name, defval, minval, maxval, desc) \
+static uint lpfc_##name = defval;\
+module_param(lpfc_##name, uint, S_IRUGO);\
+MODULE_PARM_DESC(lpfc_##name, desc);\
+lpfc_param_show(name)\
+lpfc_param_init(name, defval, minval, maxval)\
+lpfc_param_set(name, defval, minval, maxval)\
+lpfc_param_store(name)\
+static DEVICE_ATTR(lpfc_##name, S_IRUGO | S_IWUSR,\
+		   lpfc_##name##_show, lpfc_##name##_store)
+
+#define LPFC_ATTR_HEX_R(name, defval, minval, maxval, desc) \
+static uint lpfc_##name = defval;\
+module_param(lpfc_##name, uint, S_IRUGO);\
+MODULE_PARM_DESC(lpfc_##name, desc);\
+lpfc_param_hex_show(name)\
+lpfc_param_init(name, defval, minval, maxval)\
+static DEVICE_ATTR(lpfc_##name, S_IRUGO, lpfc_##name##_show, NULL)
+
+#define LPFC_ATTR_HEX_RW(name, defval, minval, maxval, desc) \
+static uint lpfc_##name = defval;\
+module_param(lpfc_##name, uint, S_IRUGO);\
+MODULE_PARM_DESC(lpfc_##name, desc);\
+lpfc_param_hex_show(name)\
+lpfc_param_init(name, defval, minval, maxval)\
+lpfc_param_set(name, defval, minval, maxval)\
+lpfc_param_store(name)\
+static DEVICE_ATTR(lpfc_##name, S_IRUGO | S_IWUSR,\
+		   lpfc_##name##_show, lpfc_##name##_store)
+
+#define LPFC_VPORT_ATTR(name, defval, minval, maxval, desc) \
+static uint lpfc_##name = defval;\
+module_param(lpfc_##name, uint, S_IRUGO);\
+MODULE_PARM_DESC(lpfc_##name, desc);\
+lpfc_vport_param_init(name, defval, minval, maxval)
+
+#define LPFC_VPORT_ATTR_R(name, defval, minval, maxval, desc) \
+static uint lpfc_##name = defval;\
+module_param(lpfc_##name, uint, S_IRUGO);\
+MODULE_PARM_DESC(lpfc_##name, desc);\
+lpfc_vport_param_show(name)\
+lpfc_vport_param_init(name, defval, minval, maxval)\
+static DEVICE_ATTR(lpfc_##name, S_IRUGO, lpfc_##name##_show, NULL)
+
+#define LPFC_VPORT_ULL_ATTR_R(name, defval, minval, maxval, desc) \
+static uint64_t lpfc_##name = defval;\
+module_param(lpfc_##name, ullong, S_IRUGO);\
+MODULE_PARM_DESC(lpfc_##name, desc);\
+lpfc_vport_param_show(name)\
+lpfc_vport_param_init(name, defval, minval, maxval)\
+static DEVICE_ATTR(lpfc_##name, S_IRUGO, lpfc_##name##_show, NULL)
+
+#define LPFC_VPORT_ATTR_RW(name, defval, minval, maxval, desc) \
+static uint lpfc_##name = defval;\
+module_param(lpfc_##name, uint, S_IRUGO);\
+MODULE_PARM_DESC(lpfc_##name, desc);\
+lpfc_vport_param_show(name)\
+lpfc_vport_param_init(name, defval, minval, maxval)\
+lpfc_vport_param_set(name, defval, minval, maxval)\
+lpfc_vport_param_store(name)\
+static DEVICE_ATTR(lpfc_##name, S_IRUGO | S_IWUSR,\
+		   lpfc_##name##_show, lpfc_##name##_store)
+
+#define LPFC_VPORT_ATTR_HEX_R(name, defval, minval, maxval, desc) \
+static uint lpfc_##name = defval;\
+module_param(lpfc_##name, uint, S_IRUGO);\
+MODULE_PARM_DESC(lpfc_##name, desc);\
+lpfc_vport_param_hex_show(name)\
+lpfc_vport_param_init(name, defval, minval, maxval)\
+static DEVICE_ATTR(lpfc_##name, S_IRUGO, lpfc_##name##_show, NULL)
+
+#define LPFC_VPORT_ATTR_HEX_RW(name, defval, minval, maxval, desc) \
+static uint lpfc_##name = defval;\
+module_param(lpfc_##name, uint, S_IRUGO);\
+MODULE_PARM_DESC(lpfc_##name, desc);\
+lpfc_vport_param_hex_show(name)\
+lpfc_vport_param_init(name, defval, minval, maxval)\
+lpfc_vport_param_set(name, defval, minval, maxval)\
+lpfc_vport_param_store(name)\
+static DEVICE_ATTR(lpfc_##name, S_IRUGO | S_IWUSR,\
+		   lpfc_##name##_show, lpfc_##name##_store)
-- 
2.5.0

