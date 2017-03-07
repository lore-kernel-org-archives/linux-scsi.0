From: jsmart2021@gmail.com
Subject: [PATCH] lpfc: Finalize Kconfig options for nvme
Date: Tue,  7 Mar 2017 11:17:08 -0800
Message-ID: <1488914228-7289-1-git-send-email-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:35738 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755781AbdCGTSH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Mar 2017 14:18:07 -0500
Received: by mail-qk0-f195.google.com with SMTP id o135so3754977qke.2
        for <linux-scsi@vger.kernel.org>; Tue, 07 Mar 2017 11:18:06 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: James Smart <jsmart2021@gmail.com>

Reviewing the result of what was just added for Kconfig, we made
a poor choice. It worked well for full kernel builds, but not so
much for how it would be deployed on a distro.

Here's the final result:
- lpfc will compile in NVME initiator and/or NVME target support
  based on whether the kernel has the corresponding subsystem support.
  Kconfig is not used to drive this specifically for lpfc.
- There is a module parameter, lpfc_enable_fc4_type, that indicates
  whether the ports will do FCP-only or FCP & NVME (NVME-only not yet
  possible due to dependency on fc transport). As FCP & NVME divvys
  up exchange resources, and given NVME will not be often initially,
  the default is changed to FCP only.

-- james

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/Kconfig          | 14 --------------
 drivers/scsi/lpfc/lpfc.h      |  8 ++++++++
 drivers/scsi/lpfc/lpfc_attr.c |  4 ++--
 3 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 4bf55b5..3c52867 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1253,20 +1253,6 @@ config SCSI_LPFC_DEBUG_FS
 	  This makes debugging information from the lpfc driver
 	  available via the debugfs filesystem.
 
-config LPFC_NVME_INITIATOR
-	bool "Emulex LightPulse Fibre Channel NVME Initiator Support"
-	depends on SCSI_LPFC && NVME_FC
-	---help---
-	  This enables NVME Initiator support in the Emulex lpfc driver.
-
-config LPFC_NVME_TARGET
-	bool "Emulex LightPulse Fibre Channel NVME Initiator Support"
-	depends on SCSI_LPFC && NVME_TARGET_FC
-	---help---
-	  This enables NVME Target support in the Emulex lpfc driver.
-	  Target enablement must still be enabled on a per adapter
-	  basis by module parameters.
-
 config SCSI_SIM710
 	tristate "Simple 53c710 SCSI support (Compaq, NCR machines)"
 	depends on (EISA || MCA) && SCSI
diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 257bbdd..ce571ca 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -28,6 +28,14 @@
 #define CONFIG_SCSI_LPFC_DEBUG_FS
 #endif
 
+#if defined(CONFIG_NVME_FC)
+#define CONFIG_LPFC_NVME_INITIATOR
+#endif
+
+#if defined(CONFIG_NVME_TARGET_FC)
+#define CONFIG_LPFC_NVME_TARGET
+#endif
+
 struct lpfc_sli2_slim;
 
 #define ELX_MODEL_NAME_SIZE	80
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index fbd3a56..84aa62f 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -3315,9 +3315,9 @@ LPFC_ATTR_R(nvmet_mrq_post, LPFC_DEF_MRQ_POST,
  * lpfc_enable_fc4_type: Defines what FC4 types are supported.
  * Supported Values:  1 - register just FCP
  *                    3 - register both FCP and NVME
- * Supported values are [1,3]. Default value is 3
+ * Supported values are [1,3]. Default value is 1
  */
-LPFC_ATTR_R(enable_fc4_type, LPFC_ENABLE_BOTH,
+LPFC_ATTR_R(enable_fc4_type, LPFC_ENABLE_FCP,
 	    LPFC_ENABLE_FCP, LPFC_ENABLE_BOTH,
 	    "Define fc4 type to register with fabric.");
 
-- 
2.5.0
