From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 12/24] bfa: update to support firmware configuation
Date: Thu, 8 Jul 2010 19:53:40 -0700
Message-ID: <1278644020-32003-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:36307 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754220Ab0GICxp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jul 2010 22:53:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: kgudipat@brocade.com, vravindr@brocade.com, rvadivel@brocade.com, amathur@brocade.com, Jing Huang <huangj@brocade.com>

Update related data structures to support firmeare configuration.
Add AEN events related to firmware configuation.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/bfa_ioc.c                      |    6 +-
 drivers/scsi/bfa/bfa_ioc.h                      |    1 +
 drivers/scsi/bfa/bfa_log_module.c               |   86 +++++++++++++++++++++++
 drivers/scsi/bfa/include/aen/bfa_aen_ioc.h      |    8 ++
 drivers/scsi/bfa/include/cs/bfa_debug.h         |    3 +-
 drivers/scsi/bfa/include/defs/bfa_defs_ioc.h    |    7 ++-
 drivers/scsi/bfa/include/defs/bfa_defs_status.h |    3 +
 drivers/scsi/bfa/include/log/bfa_log_linux.h    |    6 +-
 8 files changed, 112 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index 1600f74..c4922fb 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -71,8 +71,6 @@ bfa_boolean_t   bfa_auto_recover = BFA_TRUE;
 /*
  * forward declarations
  */
-static void     bfa_ioc_aen_post(struct bfa_ioc_s *bfa,
-				 enum bfa_ioc_aen_event event);
 static void     bfa_ioc_hw_sem_get(struct bfa_ioc_s *ioc);
 static void     bfa_ioc_hw_sem_get_cancel(struct bfa_ioc_s *ioc);
 static void     bfa_ioc_hwinit(struct bfa_ioc_s *ioc, bfa_boolean_t force);
@@ -1902,7 +1900,7 @@ bfa_ioc_get_fcmode(struct bfa_ioc_s *ioc)
 /**
  * Send AEN notification
  */
-static void
+void
 bfa_ioc_aen_post(struct bfa_ioc_s *ioc, enum bfa_ioc_aen_event event)
 {
 	union bfa_aen_data_u aen_data;
@@ -2052,7 +2050,7 @@ bfa_ioc_recover(struct bfa_ioc_s *ioc)
 
 #else
 
-static void
+void
 bfa_ioc_aen_post(struct bfa_ioc_s *ioc, enum bfa_ioc_aen_event event)
 {
 }
diff --git a/drivers/scsi/bfa/bfa_ioc.h b/drivers/scsi/bfa/bfa_ioc.h
index 2425c00..cae05b2 100644
--- a/drivers/scsi/bfa/bfa_ioc.h
+++ b/drivers/scsi/bfa/bfa_ioc.h
@@ -297,6 +297,7 @@ void bfa_ioc_fwver_get(struct bfa_ioc_s *ioc,
 			struct bfi_ioc_image_hdr_s *fwhdr);
 bfa_boolean_t bfa_ioc_fwver_cmp(struct bfa_ioc_s *ioc,
 			struct bfi_ioc_image_hdr_s *fwhdr);
+void bfa_ioc_aen_post(struct bfa_ioc_s *ioc, enum bfa_ioc_aen_event event);
 
 /*
  * bfa mfg wwn API functions
diff --git a/drivers/scsi/bfa/bfa_log_module.c b/drivers/scsi/bfa/bfa_log_module.c
index 5c154d3..cf577ef 100644
--- a/drivers/scsi/bfa/bfa_log_module.c
+++ b/drivers/scsi/bfa/bfa_log_module.c
@@ -110,6 +110,27 @@ struct bfa_log_msgdef_s bfa_log_msg_array[] = {
  "Running firmware version is incompatible with the driver version.",
  (0), 0},
 
+{BFA_AEN_IOC_FWCFG_ERROR, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_CRITICAL, "BFA_AEN_IOC_FWCFG_ERROR",
+ "Link initialization failed due to firmware configuration read error:"
+ " WWN = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_AEN_IOC_INVALID_VENDOR, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_ERROR, "BFA_AEN_IOC_INVALID_VENDOR",
+ "Unsupported switch vendor. Link initialization failed: WWN = %s.",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_AEN_IOC_INVALID_NWWN, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_ERROR, "BFA_AEN_IOC_INVALID_NWWN",
+ "Invalid NWWN. Link initialization failed: NWWN = 00:00:00:00:00:00:00:00.",
+ (0), 0},
+
+{BFA_AEN_IOC_INVALID_PWWN, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_ERROR, "BFA_AEN_IOC_INVALID_PWWN",
+ "Invalid PWWN. Link initialization failed: PWWN = 00:00:00:00:00:00:00:00.",
+ (0), 0},
+
 
 
 
@@ -347,6 +368,22 @@ struct bfa_log_msgdef_s bfa_log_msg_array[] = {
  ((BFA_LOG_S << BFA_LOG_ARG0) | (BFA_LOG_D << BFA_LOG_ARG1) |
   (BFA_LOG_D << BFA_LOG_ARG2) | 0), 3},
 
+{BFA_LOG_HAL_DRIVER_ERROR, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "HAL_DRIVER_ERROR",
+ "%s",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_LOG_HAL_DRIVER_CONFIG_ERROR,
+ BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "HAL_DRIVER_CONFIG_ERROR",
+ "%s",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_LOG_HAL_MBOX_ERROR, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "HAL_MBOX_ERROR",
+ "%s",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
 
 
 
@@ -412,6 +449,55 @@ struct bfa_log_msgdef_s bfa_log_msg_array[] = {
  ((BFA_LOG_D << BFA_LOG_ARG0) | (BFA_LOG_P << BFA_LOG_ARG1) |
   (BFA_LOG_X << BFA_LOG_ARG2) | 0), 3},
 
+{BFA_LOG_LINUX_DRIVER_CONFIG_ERROR,
+ BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "LINUX_DRIVER_CONFIG_ERROR",
+ "%s",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_LOG_LINUX_BNA_STATE_MACHINE,
+ BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "LINUX_BNA_STATE_MACHINE",
+ "%s",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_LOG_LINUX_IOC_ERROR, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "LINUX_IOC_ERROR",
+ "%s",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_LOG_LINUX_RESOURCE_ALLOC_ERROR,
+ BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "LINUX_RESOURCE_ALLOC_ERROR",
+ "%s",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_LOG_LINUX_RING_BUFFER_ERROR,
+ BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG, BFA_LOG_INFO,
+ "LINUX_RING_BUFFER_ERROR",
+ "%s",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_LOG_LINUX_DRIVER_ERROR, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_ERROR, "LINUX_DRIVER_ERROR",
+ "%s",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_LOG_LINUX_DRIVER_INFO, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "LINUX_DRIVER_INFO",
+ "%s",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_LOG_LINUX_DRIVER_DIAG, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "LINUX_DRIVER_DIAG",
+ "%s",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
+{BFA_LOG_LINUX_DRIVER_AEN, BFA_LOG_ATTR_NONE | BFA_LOG_ATTR_LOG,
+ BFA_LOG_INFO, "LINUX_DRIVER_AEN",
+ "%s",
+ ((BFA_LOG_S << BFA_LOG_ARG0) | 0), 1},
+
 
 
 
diff --git a/drivers/scsi/bfa/include/aen/bfa_aen_ioc.h b/drivers/scsi/bfa/include/aen/bfa_aen_ioc.h
index 71378b4..4daf96f 100644
--- a/drivers/scsi/bfa/include/aen/bfa_aen_ioc.h
+++ b/drivers/scsi/bfa/include/aen/bfa_aen_ioc.h
@@ -32,6 +32,14 @@
 	BFA_LOG_CREATE_ID(BFA_AEN_CAT_IOC, BFA_IOC_AEN_DISABLE)
 #define BFA_AEN_IOC_FWMISMATCH \
 	BFA_LOG_CREATE_ID(BFA_AEN_CAT_IOC, BFA_IOC_AEN_FWMISMATCH)
+#define BFA_AEN_IOC_FWCFG_ERROR \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_IOC, BFA_IOC_AEN_FWCFG_ERROR)
+#define BFA_AEN_IOC_INVALID_VENDOR      \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_IOC, BFA_IOC_AEN_INVALID_VENDOR)
+#define BFA_AEN_IOC_INVALID_NWWN        \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_IOC, BFA_IOC_AEN_INVALID_NWWN)
+#define BFA_AEN_IOC_INVALID_PWWN        \
+	BFA_LOG_CREATE_ID(BFA_AEN_CAT_IOC, BFA_IOC_AEN_INVALID_PWWN)
 
 #endif
 
diff --git a/drivers/scsi/bfa/include/cs/bfa_debug.h b/drivers/scsi/bfa/include/cs/bfa_debug.h
index 441be86..75a911e 100644
--- a/drivers/scsi/bfa/include/cs/bfa_debug.h
+++ b/drivers/scsi/bfa/include/cs/bfa_debug.h
@@ -28,7 +28,8 @@
 } while (0)
 
 #define bfa_sm_fault(__mod, __event)	do {				\
-	bfa_sm_panic((__mod)->logm, __LINE__, __FILE__, __event);      \
+	bfa_trc(__mod, (((uint32_t)0xDEAD << 16) | __event));		\
+	bfa_sm_panic((__mod)->logm, __LINE__, __FILE__, __event); 	\
 } while (0)
 
 #ifndef BFA_PERF_BUILD
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_ioc.h b/drivers/scsi/bfa/include/defs/bfa_defs_ioc.h
index 8d8e6a9..add0a05 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_ioc.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_ioc.h
@@ -126,7 +126,7 @@ struct bfa_ioc_attr_s {
 	struct bfa_ioc_driver_attr_s 	driver_attr;	/*  driver attr    */
 	struct bfa_ioc_pci_attr_s	pci_attr;
 	u8				port_id;	/*  port number    */
-	u8				rsvd[7];	/*!< 64bit align    */
+	u8				rsvd[7];	/*  64bit align    */
 };
 
 /**
@@ -138,6 +138,11 @@ enum bfa_ioc_aen_event {
 	BFA_IOC_AEN_ENABLE	= 3,	/*  IOC enabled event		*/
 	BFA_IOC_AEN_DISABLE	= 4,	/*  IOC disabled event		*/
 	BFA_IOC_AEN_FWMISMATCH	= 5,	/*  IOC firmware mismatch	*/
+	BFA_IOC_AEN_FWCFG_ERROR = 6,    /*  IOC firmware config error   */
+	BFA_IOC_AEN_INVALID_VENDOR = 7,
+	BFA_IOC_AEN_INVALID_NWWN = 8,   /*  Zero NWWN                   */
+	BFA_IOC_AEN_INVALID_PWWN = 9    /*  Zero PWWN                   */
+
 };
 
 /**
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_status.h b/drivers/scsi/bfa/include/defs/bfa_defs_status.h
index 7cef900..c8bc60a 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_status.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_status.h
@@ -254,6 +254,9 @@ enum bfa_status {
 						* Teaming mode */
 	BFA_STATUS_PBC = 154, /* Operation not allowed for pre-boot
 			       * configuration */
+	BFA_STATUS_DEVID_MISSING = 155, /* Boot image is not for the adapter(s)
+					 * installed */
+        BFA_STATUS_BAD_FWCFG = 156, /* Bad firmware configuration */
 	BFA_STATUS_MAX_VAL		/*  Unknown error code */
 };
 #define bfa_status_t enum bfa_status
diff --git a/drivers/scsi/bfa/include/log/bfa_log_linux.h b/drivers/scsi/bfa/include/log/bfa_log_linux.h
index bd451db..44bc897 100644
--- a/drivers/scsi/bfa/include/log/bfa_log_linux.h
+++ b/drivers/scsi/bfa/include/log/bfa_log_linux.h
@@ -53,8 +53,10 @@
 	(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 16)
 #define BFA_LOG_LINUX_DRIVER_ERROR \
 	(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 17)
-#define BFA_LOG_LINUX_DRIVER_DIAG \
+#define BFA_LOG_LINUX_DRIVER_INFO \
 	(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 18)
-#define BFA_LOG_LINUX_DRIVER_AEN \
+#define BFA_LOG_LINUX_DRIVER_DIAG \
 	(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 19)
+#define BFA_LOG_LINUX_DRIVER_AEN \
+	(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 20)
 #endif
-- 
1.6.5.2

