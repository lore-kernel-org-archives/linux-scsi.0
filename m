From: Denis ChengRq <crquan@gmail.com>
Subject: [PATCH 5/5] drivers/scsi/ core: replace __FUNCTION__ with __func__
Date: Fri, 25 Jul 2008 10:48:34 +0800
Message-ID: <1216954114-31949-2-git-send-email-crquan@gmail.com>
References: <1216954114-31949-1-git-send-email-crquan@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.189]:27792 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbYGYCtA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jul 2008 22:49:00 -0400
Received: by ti-out-0910.google.com with SMTP id b6so1613060tic.23
        for <linux-scsi@vger.kernel.org>; Thu, 24 Jul 2008 19:48:59 -0700 (PDT)
In-Reply-To: <1216954114-31949-1-git-send-email-crquan@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org

's/__FUNCTION__/__func__/g' and some other style fixes.

Signed-off-by: Denis ChengRq <crquan@gmail.com>
---
 drivers/scsi/advansys.c           |    2 +-
 drivers/scsi/aha152x.c            |   22 ++++++++++++++++------
 drivers/scsi/arm/fas216.c         |    4 ++--
 drivers/scsi/ibmvscsi/ibmvfc.h    |    4 ++--
 drivers/scsi/ibmvscsi/ibmvstgt.c  |    2 +-
 drivers/scsi/imm.c                |    2 +-
 drivers/scsi/ipr.h                |    6 +++---
 drivers/scsi/libsrp.c             |    2 +-
 drivers/scsi/nsp32.c              |    4 ++--
 drivers/scsi/nsp32_debug.c        |    2 +-
 drivers/scsi/pcmcia/nsp_cs.c      |    4 ++--
 drivers/scsi/pcmcia/nsp_debug.c   |    2 +-
 drivers/scsi/ppa.c                |    2 +-
 drivers/scsi/qla1280.c            |   12 ++++++------
 drivers/scsi/scsi_debug.c         |   12 ++++++------
 drivers/scsi/scsi_devinfo.c       |    6 +++---
 drivers/scsi/scsi_error.c         |   26 +++++++++++++-------------
 drivers/scsi/scsi_lib.c           |    6 +++---
 drivers/scsi/scsi_netlink.c       |    8 ++++----
 drivers/scsi/scsi_proc.c          |    4 ++--
 drivers/scsi/scsi_scan.c          |   12 ++++++------
 drivers/scsi/scsi_tgt_priv.h      |    2 +-
 drivers/scsi/scsi_transport_fc.c  |   12 ++++++------
 drivers/scsi/scsi_transport_sas.c |    4 ++--
 drivers/scsi/tmscsim.c            |   18 +++++++++++++-----
 drivers/scsi/wd7000.c             |   14 ++++++++++----
 drivers/scsi/zalon.c              |    9 +++++----
 27 files changed, 114 insertions(+), 89 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 8591585..218777b 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -2278,7 +2278,7 @@ do { \
 #define ASC_DBG(lvl, format, arg...) {					\
 	if (asc_dbglvl >= (lvl))					\
 		printk(KERN_DEBUG "%s: %s: " format, DRV_NAME,		\
-			__FUNCTION__ , ## arg);				\
+			__func__ , ## arg);				\
 }
 
 #define ASC_DBG_PRT_SCSI_HOST(lvl, s) \
diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index 0899cb6..d6dfab2 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -288,20 +288,30 @@ static LIST_HEAD(aha152x_host_list);
 #define DO_LOCK(flags)	\
 	do { \
 		if(spin_is_locked(&QLOCK)) { \
-			DPRINTK(debug_intr, DEBUG_LEAD "(%s:%d) already locked at %s:%d\n", CMDINFO(CURRENT_SC), __FUNCTION__, __LINE__, QLOCKER, QLOCKERL); \
+			DPRINTK(debug_intr, DEBUG_LEAD \
+					"(%s:%d) already locked at %s:%d\n", \
+					CMDINFO(CURRENT_SC), \
+					__func__, __LINE__, \
+					QLOCKER, QLOCKERL); \
 		} \
-		DPRINTK(debug_locking, DEBUG_LEAD "(%s:%d) locking\n", CMDINFO(CURRENT_SC), __FUNCTION__, __LINE__); \
+		DPRINTK(debug_locking, DEBUG_LEAD "(%s:%d) locking\n", \
+				CMDINFO(CURRENT_SC), __func__, __LINE__); \
 		spin_lock_irqsave(&QLOCK,flags); \
-		DPRINTK(debug_locking, DEBUG_LEAD "(%s:%d) locked\n", CMDINFO(CURRENT_SC), __FUNCTION__, __LINE__); \
-		QLOCKER=__FUNCTION__; \
+		DPRINTK(debug_locking, DEBUG_LEAD "(%s:%d) locked\n", \
+				CMDINFO(CURRENT_SC), __func__, __LINE__); \
+		QLOCKER = __func__; \
 		QLOCKERL=__LINE__; \
 	} while(0)
 
 #define DO_UNLOCK(flags)	\
 	do { \
-		DPRINTK(debug_locking, DEBUG_LEAD "(%s:%d) unlocking (locked at %s:%d)\n", CMDINFO(CURRENT_SC), __FUNCTION__, __LINE__, QLOCKER, QLOCKERL); \
+		DPRINTK(debug_locking, DEBUG_LEAD \
+				"(%s:%d) unlocking (locked at %s:%d)\n", \
+				CMDINFO(CURRENT_SC), __func__, __LINE__, \
+				QLOCKER, QLOCKERL); \
 		spin_unlock_irqrestore(&QLOCK,flags); \
-		DPRINTK(debug_locking, DEBUG_LEAD "(%s:%d) unlocked\n", CMDINFO(CURRENT_SC), __FUNCTION__, __LINE__); \
+		DPRINTK(debug_locking, DEBUG_LEAD "(%s:%d) unlocked\n", \
+				CMDINFO(CURRENT_SC), __func__, __LINE__); \
 		QLOCKER="(not locked)"; \
 		QLOCKERL=0; \
 	} while(0)
diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index a715632..4775426 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -240,7 +240,7 @@ static void __fas216_checkmagic(FAS216_Info *info, const char *func)
 		panic("scsi memory space corrupted in %s", func);
 	}
 }
-#define fas216_checkmagic(info) __fas216_checkmagic((info), __FUNCTION__)
+#define fas216_checkmagic(info) __fas216_checkmagic((info), __func__)
 #else
 #define fas216_checkmagic(info)
 #endif
@@ -2658,7 +2658,7 @@ int fas216_eh_host_reset(struct scsi_cmnd *SCpnt)
 	fas216_checkmagic(info);
 
 	printk("scsi%d.%c: %s: resetting host\n",
-		info->host->host_no, '0' + SCpnt->device->id, __FUNCTION__);
+		info->host->host_no, '0' + SCpnt->device->id, __func__);
 
 	/*
 	 * Reset the SCSI chip.
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index 057f3c0..6ada16d 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -668,8 +668,8 @@ struct ibmvfc_host {
 			dev_err((vhost)->dev, ##__VA_ARGS__); \
 	} while (0)
 
-#define ENTER DBG_CMD(printk(KERN_INFO IBMVFC_NAME": Entering %s\n", __FUNCTION__))
-#define LEAVE DBG_CMD(printk(KERN_INFO IBMVFC_NAME": Leaving %s\n", __FUNCTION__))
+#define ENTER DBG_CMD(printk(KERN_INFO IBMVFC_NAME": Entering %s\n", __func__))
+#define LEAVE DBG_CMD(printk(KERN_INFO IBMVFC_NAME": Leaving %s\n", __func__))
 
 #ifdef CONFIG_SCSI_IBMVFC_TRACE
 #define ibmvfc_create_trace_file(kobj, attr) sysfs_create_bin_file(kobj, attr)
diff --git a/drivers/scsi/ibmvscsi/ibmvstgt.c b/drivers/scsi/ibmvscsi/ibmvstgt.c
index 3b9514c..d6f68f2 100644
--- a/drivers/scsi/ibmvscsi/ibmvstgt.c
+++ b/drivers/scsi/ibmvscsi/ibmvstgt.c
@@ -55,7 +55,7 @@
 /* tmp - will replace with SCSI logging stuff */
 #define eprintk(fmt, args...)					\
 do {								\
-	printk("%s(%d) " fmt, __FUNCTION__, __LINE__, ##args);	\
+	printk("%s(%d) " fmt, __func__, __LINE__, ##args);	\
 } while (0)
 /* #define dprintk eprintk */
 #define dprintk(fmt, args...)
diff --git a/drivers/scsi/imm.c b/drivers/scsi/imm.c
index f97d172..f528d80 100644
--- a/drivers/scsi/imm.c
+++ b/drivers/scsi/imm.c
@@ -163,7 +163,7 @@ static int imm_proc_info(struct Scsi_Host *host, char *buffer, char **start,
 
 #if IMM_DEBUG > 0
 #define imm_fail(x,y) printk("imm: imm_fail(%i) from %s at line %d\n",\
-	   y, __FUNCTION__, __LINE__); imm_fail_func(x,y);
+	   y, __func__, __LINE__); imm_fail_func(x, y);
 static inline void
 imm_fail_func(imm_struct *dev, int error_code)
 #else
diff --git a/drivers/scsi/ipr.h b/drivers/scsi/ipr.h
index d931566..4871dd1 100644
--- a/drivers/scsi/ipr.h
+++ b/drivers/scsi/ipr.h
@@ -1403,10 +1403,10 @@ struct ipr_ucode_image_header {
 }
 
 #define ipr_trace ipr_dbg("%s: %s: Line: %d\n",\
-	__FILE__, __FUNCTION__, __LINE__)
+	__FILE__, __func__, __LINE__)
 
-#define ENTER IPR_DBG_CMD(printk(KERN_INFO IPR_NAME": Entering %s\n", __FUNCTION__))
-#define LEAVE IPR_DBG_CMD(printk(KERN_INFO IPR_NAME": Leaving %s\n", __FUNCTION__))
+#define ENTER IPR_DBG_CMD(printk(KERN_INFO IPR_NAME": Entering %s\n", __func__))
+#define LEAVE IPR_DBG_CMD(printk(KERN_INFO IPR_NAME": Leaving %s\n", __func__))
 
 #define ipr_err_separator \
 ipr_err("----------------------------------------------------------\n")
diff --git a/drivers/scsi/libsrp.c b/drivers/scsi/libsrp.c
index 6d6a76e..15e2d13 100644
--- a/drivers/scsi/libsrp.c
+++ b/drivers/scsi/libsrp.c
@@ -39,7 +39,7 @@ enum srp_task_attributes {
 /* tmp - will replace with SCSI logging stuff */
 #define eprintk(fmt, args...)					\
 do {								\
-	printk("%s(%d) " fmt, __FUNCTION__, __LINE__, ##args);	\
+	printk("%s(%d) " fmt, __func__, __LINE__, ##args);	\
 } while (0)
 /* #define dprintk eprintk */
 #define dprintk(fmt, args...)
diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index 7fed353..fea9cb8 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -299,9 +299,9 @@ static struct scsi_host_template nsp32_template = {
 #else
 # define NSP32_DEBUG_MASK	      0xffffff
 # define nsp32_msg(type, args...) \
-	nsp32_message (__FUNCTION__, __LINE__, (type), args)
+	nsp32_message(__func__, __LINE__, (type), args)
 # define nsp32_dbg(mask, args...) \
-	nsp32_dmessage(__FUNCTION__, __LINE__, (mask), args)
+	nsp32_dmessage(__func__, __LINE__, (mask), args)
 #endif
 
 #define NSP32_DEBUG_QUEUECOMMAND	BIT(0)
diff --git a/drivers/scsi/nsp32_debug.c b/drivers/scsi/nsp32_debug.c
index ef3c59c..2fb3fb5 100644
--- a/drivers/scsi/nsp32_debug.c
+++ b/drivers/scsi/nsp32_debug.c
@@ -88,7 +88,7 @@ static void print_commandk (unsigned char *command)
 	int i,s;
 //	printk(KERN_DEBUG);
 	print_opcodek(command[0]);
-	/*printk(KERN_DEBUG "%s ", __FUNCTION__);*/
+	/*printk(KERN_DEBUG "%s ", __func__);*/
 	if ((command[0] >> 5) == 6 ||
 	    (command[0] >> 5) == 7 ) {
 		s = 12; /* vender specific */
diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index 5082ca3..48e464f 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -107,9 +107,9 @@ static nsp_hw_data nsp_data_base; /* attach <-> detect glue */
 #else
 # define NSP_DEBUG_MASK		0xffffff
 # define nsp_msg(type, args...) \
-	nsp_cs_message (__FUNCTION__, __LINE__, (type), args)
+	nsp_cs_message(__func__, __LINE__, (type), args)
 # define nsp_dbg(mask, args...) \
-	nsp_cs_dmessage(__FUNCTION__, __LINE__, (mask), args)
+	nsp_cs_dmessage(__func__, __LINE__, (mask), args)
 #endif
 
 #define NSP_DEBUG_QUEUECOMMAND		BIT(0)
diff --git a/drivers/scsi/pcmcia/nsp_debug.c b/drivers/scsi/pcmcia/nsp_debug.c
index 2f75fe6..3c6ef64 100644
--- a/drivers/scsi/pcmcia/nsp_debug.c
+++ b/drivers/scsi/pcmcia/nsp_debug.c
@@ -90,7 +90,7 @@ static void print_commandk (unsigned char *command)
 	int i, s;
 	printk(KERN_DEBUG);
 	print_opcodek(command[0]);
-	/*printk(KERN_DEBUG "%s ", __FUNCTION__);*/
+	/*printk(KERN_DEBUG "%s ", __func__);*/
 	if ((command[0] >> 5) == 6 ||
 	    (command[0] >> 5) == 7 ) {
 		s = 12; /* vender specific */
diff --git a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
index f655ae3..a891c63 100644
--- a/drivers/scsi/ppa.c
+++ b/drivers/scsi/ppa.c
@@ -171,7 +171,7 @@ static int device_check(ppa_struct *dev);
 
 #if PPA_DEBUG > 0
 #define ppa_fail(x,y) printk("ppa: ppa_fail(%i) from %s at line %d\n",\
-	   y, __FUNCTION__, __LINE__); ppa_fail_func(x,y);
+	   y, __func__, __LINE__); ppa_fail_func(x, y);
 static inline void ppa_fail_func(ppa_struct *dev, int error_code)
 #else
 static inline void ppa_fail(ppa_struct *dev, int error_code)
diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 3754ab8..37f9ba0 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -1695,7 +1695,7 @@ qla1280_load_firmware_dma(struct scsi_qla_host *ha)
 	risc_code_size = *ql1280_board_tbl[ha->devnum].fwlen;
 
 	dprintk(1, "%s: DMA RISC code (%i) words\n",
-			__FUNCTION__, risc_code_size);
+			__func__, risc_code_size);
 
 	num = 0;
 	while (risc_code_size > 0) {
@@ -1721,7 +1721,7 @@ qla1280_load_firmware_dma(struct scsi_qla_host *ha)
 		mb[7] = pci_dma_hi32(ha->request_dma) & 0xffff;
 		mb[6] = pci_dma_hi32(ha->request_dma) >> 16;
 		dprintk(2, "%s: op=%d  0x%p = 0x%4x,0x%4x,0x%4x,0x%4x\n",
-				__FUNCTION__, mb[0],
+				__func__, mb[0],
 				(void *)(long)ha->request_dma,
 				mb[6], mb[7], mb[2], mb[3]);
 		err = qla1280_mailbox_command(ha, BIT_4 | BIT_3 | BIT_2 |
@@ -1753,10 +1753,10 @@ qla1280_load_firmware_dma(struct scsi_qla_host *ha)
 			if (tbuf[i] != sp[i] && warn++ < 10) {
 				printk(KERN_ERR "%s: FW compare error @ "
 						"byte(0x%x) loop#=%x\n",
-						__FUNCTION__, i, num);
+						__func__, i, num);
 				printk(KERN_ERR "%s: FWbyte=%x  "
 						"FWfromChip=%x\n",
-						__FUNCTION__, sp[i], tbuf[i]);
+						__func__, sp[i], tbuf[i]);
 				/*break; */
 			}
 		}
@@ -1781,7 +1781,7 @@ qla1280_start_firmware(struct scsi_qla_host *ha)
 	int err;
 
 	dprintk(1, "%s: Verifying checksum of loaded RISC code.\n",
-			__FUNCTION__);
+			__func__);
 
 	/* Verify checksum of loaded RISC code. */
 	mb[0] = MBC_VERIFY_CHECKSUM;
@@ -1794,7 +1794,7 @@ qla1280_start_firmware(struct scsi_qla_host *ha)
 	}
 
 	/* Start firmware execution. */
-	dprintk(1, "%s: start firmware running.\n", __FUNCTION__);
+	dprintk(1, "%s: start firmware running.\n", __func__);
 	mb[0] = MBC_EXECUTE_FIRMWARE;
 	mb[1] = *ql1280_board_tbl[ha->devnum].fwstart;
 	err = qla1280_mailbox_command(ha, BIT_1 | BIT_0, &mb[0]);
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 01d11a0..079f4aa 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1753,7 +1753,7 @@ static struct sdebug_dev_info * devInfoReg(struct scsi_device * sdev)
 		open_devip = sdebug_device_create(sdbg_host, GFP_ATOMIC);
 		if (!open_devip) {
 			printk(KERN_ERR "%s: out of memory at line %d\n",
-				__FUNCTION__, __LINE__);
+				__func__, __LINE__);
 			return NULL;
 		}
 	}
@@ -2656,7 +2656,7 @@ static int sdebug_add_adapter(void)
         sdbg_host = kzalloc(sizeof(*sdbg_host),GFP_KERNEL);
         if (NULL == sdbg_host) {
                 printk(KERN_ERR "%s: out of memory at line %d\n",
-                       __FUNCTION__, __LINE__);
+				__func__, __LINE__);
                 return -ENOMEM;
         }
 
@@ -2667,7 +2667,7 @@ static int sdebug_add_adapter(void)
 		sdbg_devinfo = sdebug_device_create(sdbg_host, GFP_KERNEL);
 		if (!sdbg_devinfo) {
                         printk(KERN_ERR "%s: out of memory at line %d\n",
-                               __FUNCTION__, __LINE__);
+					__func__, __LINE__);
                         error = -ENOMEM;
 			goto clean;
                 }
@@ -2987,7 +2987,7 @@ static int sdebug_driver_probe(struct device * dev)
 
         hpnt = scsi_host_alloc(&sdebug_driver_template, sizeof(sdbg_host));
         if (NULL == hpnt) {
-                printk(KERN_ERR "%s: scsi_register failed\n", __FUNCTION__);
+		printk(KERN_ERR "%s: scsi_register failed\n", __func__);
                 error = -ENODEV;
 		return error;
         }
@@ -3002,7 +3002,7 @@ static int sdebug_driver_probe(struct device * dev)
 
         error = scsi_add_host(hpnt, &sdbg_host->dev);
         if (error) {
-                printk(KERN_ERR "%s: scsi_add_host failed\n", __FUNCTION__);
+		printk(KERN_ERR "%s: scsi_add_host failed\n", __func__);
                 error = -ENODEV;
 		scsi_host_put(hpnt);
         } else
@@ -3021,7 +3021,7 @@ static int sdebug_driver_remove(struct device * dev)
 
 	if (!sdbg_host) {
 		printk(KERN_ERR "%s: Unable to locate host info\n",
-		       __FUNCTION__);
+		       __func__);
 		return -ENODEV;
 	}
 
diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index a235802..4969e4e 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -272,7 +272,7 @@ static void scsi_strcpy_devinfo(char *name, char *to, size_t to_length,
 	}
 	if (from_length > to_length)
 		 printk(KERN_WARNING "%s: %s string '%s' is too long\n",
-			__FUNCTION__, name, from);
+			__func__, name, from);
 }
 
 /**
@@ -298,7 +298,7 @@ static int scsi_dev_info_list_add(int compatible, char *vendor, char *model,
 
 	devinfo = kmalloc(sizeof(*devinfo), GFP_KERNEL);
 	if (!devinfo) {
-		printk(KERN_ERR "%s: no memory\n", __FUNCTION__);
+		printk(KERN_ERR "%s: no memory\n", __func__);
 		return -ENOMEM;
 	}
 
@@ -363,7 +363,7 @@ static int scsi_dev_info_list_add_str(char *dev_list)
 			strflags = strsep(&next, next_check);
 		if (!model || !strflags) {
 			printk(KERN_ERR "%s: bad dev info string '%s' '%s'"
-			       " '%s'\n", __FUNCTION__, vendor, model,
+			       " '%s'\n", __func__, vendor, model,
 			       strflags);
 			res = -EINVAL;
 		} else
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 006a959..61dabc6 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -139,7 +139,7 @@ void scsi_add_timer(struct scsi_cmnd *scmd, int timeout,
 	scmd->eh_timeout.function = (void (*)(unsigned long)) complete;
 
 	SCSI_LOG_ERROR_RECOVERY(5, printk("%s: scmd: %p, time:"
-					  " %d, (%p)\n", __FUNCTION__,
+					  " %d, (%p)\n", __func__,
 					  scmd, timeout, complete));
 
 	add_timer(&scmd->eh_timeout);
@@ -163,7 +163,7 @@ int scsi_delete_timer(struct scsi_cmnd *scmd)
 	rtn = del_timer(&scmd->eh_timeout);
 
 	SCSI_LOG_ERROR_RECOVERY(5, printk("%s: scmd: %p,"
-					 " rtn: %d\n", __FUNCTION__,
+					 " rtn: %d\n", __func__,
 					 scmd, rtn));
 
 	scmd->eh_timeout.data = (unsigned long)NULL;
@@ -233,7 +233,7 @@ int scsi_block_when_processing_errors(struct scsi_device *sdev)
 
 	online = scsi_device_online(sdev);
 
-	SCSI_LOG_ERROR_RECOVERY(5, printk("%s: rtn: %d\n", __FUNCTION__,
+	SCSI_LOG_ERROR_RECOVERY(5, printk(KERN_ERR "%s: rtn: %d\n", __func__,
 					  online));
 
 	return online;
@@ -271,7 +271,7 @@ static inline void scsi_eh_prt_fail_stats(struct Scsi_Host *shost,
 			SCSI_LOG_ERROR_RECOVERY(3,
 				sdev_printk(KERN_INFO, sdev,
 					    "%s: cmds failed: %d, cancel: %d\n",
-					    __FUNCTION__, cmd_failed,
+					    __func__, cmd_failed,
 					    cmd_cancel));
 			cmd_cancel = 0;
 			cmd_failed = 0;
@@ -470,7 +470,7 @@ static void scsi_eh_done(struct scsi_cmnd *scmd)
 
 	SCSI_LOG_ERROR_RECOVERY(3,
 		printk("%s scmd: %p result: %x\n",
-			__FUNCTION__, scmd, scmd->result));
+			__func__, scmd, scmd->result));
 
 	eh_action = scmd->device->host->eh_action;
 	if (eh_action)
@@ -487,7 +487,7 @@ static int scsi_try_host_reset(struct scsi_cmnd *scmd)
 	int rtn;
 
 	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Snd Host RST\n",
-					  __FUNCTION__));
+					  __func__));
 
 	if (!scmd->device->host->hostt->eh_host_reset_handler)
 		return FAILED;
@@ -516,7 +516,7 @@ static int scsi_try_bus_reset(struct scsi_cmnd *scmd)
 	int rtn;
 
 	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Snd Bus RST\n",
-					  __FUNCTION__));
+					  __func__));
 
 	if (!scmd->device->host->hostt->eh_bus_reset_handler)
 		return FAILED;
@@ -766,7 +766,7 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 
 	SCSI_LOG_ERROR_RECOVERY(3,
 		printk("%s: scmd: %p, timeleft: %ld\n",
-			__FUNCTION__, scmd, timeleft));
+			__func__, scmd, timeleft));
 
 	/*
 	 * If there is time left scsi_eh_done got called, and we will
@@ -778,7 +778,7 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 		rtn = scsi_eh_completed_normally(scmd);
 		SCSI_LOG_ERROR_RECOVERY(3,
 			printk("%s: scsi_eh_completed_normally %x\n",
-			       __FUNCTION__, rtn));
+			       __func__, rtn));
 
 		switch (rtn) {
 		case SUCCESS:
@@ -913,7 +913,7 @@ retry_tur:
 	rtn = scsi_send_eh_cmnd(scmd, tur_command, 6, SENSE_TIMEOUT, 0);
 
 	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: scmd %p rtn %x\n",
-		__FUNCTION__, scmd, rtn));
+		__func__, scmd, rtn));
 
 	switch (rtn) {
 	case NEEDS_RETRY:
@@ -1296,7 +1296,7 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 	if (!scsi_device_online(scmd->device)) {
 		SCSI_LOG_ERROR_RECOVERY(5, printk("%s: device offline - report"
 						  " as SUCCESS\n",
-						  __FUNCTION__));
+						  __func__));
 		return SUCCESS;
 	}
 
@@ -1511,7 +1511,7 @@ static void scsi_restart_operations(struct Scsi_Host *shost)
 	 * ioctls to queued block devices.
 	 */
 	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: waking up host to restart\n",
-					  __FUNCTION__));
+					  __func__));
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	if (scsi_host_set_state(shost, SHOST_RUNNING))
@@ -1835,7 +1835,7 @@ scsi_reset_provider(struct scsi_device *dev, int flag)
 	 */
 	SCSI_LOG_ERROR_RECOVERY(3,
 		printk("%s: waking up host to restart after TMF\n",
-		__FUNCTION__));
+		__func__));
 
 	wake_up(&shost->host_wait);
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 88d1b5f..b19e95e 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1367,7 +1367,7 @@ static void scsi_kill_request(struct request *req, struct request_queue *q)
 
 	if (unlikely(cmd == NULL)) {
 		printk(KERN_CRIT "impossible request in %s.\n",
-				 __FUNCTION__);
+				 __func__);
 		BUG();
 	}
 
@@ -1491,7 +1491,7 @@ static void scsi_request_fn(struct request_queue *q)
 			printk(KERN_CRIT "impossible request in %s.\n"
 					 "please mail a stack trace to "
 					 "linux-scsi@vger.kernel.org\n",
-					 __FUNCTION__);
+					 __func__);
 			blk_dump_rq_flags(req, "foo");
 			BUG();
 		}
@@ -2486,7 +2486,7 @@ void *scsi_kmap_atomic_sg(struct scatterlist *sgl, int sg_count,
 	if (unlikely(i == sg_count)) {
 		printk(KERN_ERR "%s: Bytes in sg: %zu, requested offset %zu, "
 			"elements %d\n",
-		       __FUNCTION__, sg_len, *offset, sg_count);
+		       __func__, sg_len, *offset, sg_count);
 		WARN_ON(1);
 		return NULL;
 	}
diff --git a/drivers/scsi/scsi_netlink.c b/drivers/scsi/scsi_netlink.c
index 370c78c..ae7ed9a 100644
--- a/drivers/scsi/scsi_netlink.c
+++ b/drivers/scsi/scsi_netlink.c
@@ -55,7 +55,7 @@ scsi_nl_rcv_msg(struct sk_buff *skb)
 		if ((nlh->nlmsg_len < (sizeof(*nlh) + sizeof(*hdr))) ||
 		    (skb->len < nlh->nlmsg_len)) {
 			printk(KERN_WARNING "%s: discarding partial skb\n",
-				 __FUNCTION__);
+				 __func__);
 			return;
 		}
 
@@ -82,7 +82,7 @@ scsi_nl_rcv_msg(struct sk_buff *skb)
 
 		if (nlh->nlmsg_len < (sizeof(*nlh) + hdr->msglen)) {
 			printk(KERN_WARNING "%s: discarding partial message\n",
-				 __FUNCTION__);
+				 __func__);
 			return;
 		}
 
@@ -139,7 +139,7 @@ scsi_netlink_init(void)
 	error = netlink_register_notifier(&scsi_netlink_notifier);
 	if (error) {
 		printk(KERN_ERR "%s: register of event handler failed - %d\n",
-				__FUNCTION__, error);
+				__func__, error);
 		return;
 	}
 
@@ -148,7 +148,7 @@ scsi_netlink_init(void)
 				THIS_MODULE);
 	if (!scsi_nl_sock) {
 		printk(KERN_ERR "%s: register of recieve handler failed\n",
-				__FUNCTION__);
+				__func__);
 		netlink_unregister_notifier(&scsi_netlink_notifier);
 	}
 
diff --git a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
index e4a0d2f..c6a904a 100644
--- a/drivers/scsi/scsi_proc.c
+++ b/drivers/scsi/scsi_proc.c
@@ -114,7 +114,7 @@ void scsi_proc_hostdir_add(struct scsi_host_template *sht)
 		sht->proc_dir = proc_mkdir(sht->proc_name, proc_scsi);
         	if (!sht->proc_dir)
 			printk(KERN_ERR "%s: proc_mkdir failed for %s\n",
-			       __FUNCTION__, sht->proc_name);
+			       __func__, sht->proc_name);
 		else
 			sht->proc_dir->owner = sht->module;
 	}
@@ -157,7 +157,7 @@ void scsi_proc_host_add(struct Scsi_Host *shost)
 			sht->proc_dir, proc_scsi_read, shost);
 	if (!p) {
 		printk(KERN_ERR "%s: Failed to register host %d in"
-		       "%s\n", __FUNCTION__, shost->host_no,
+		       "%s\n", __func__, shost->host_no,
 		       sht->proc_name);
 		return;
 	} 
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 196fe3a..6015b8f 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -318,7 +318,7 @@ out_device_destroy:
 	put_device(&sdev->sdev_gendev);
 out:
 	if (display_failure_msg)
-		printk(ALLOC_FAILURE_MSG, __FUNCTION__);
+		printk(ALLOC_FAILURE_MSG, __func__);
 	return NULL;
 }
 
@@ -404,7 +404,7 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 
 	starget = kzalloc(size, GFP_KERNEL);
 	if (!starget) {
-		printk(KERN_ERR "%s: allocation failure\n", __FUNCTION__);
+		printk(KERN_ERR "%s: allocation failure\n", __func__);
 		return NULL;
 	}
 	dev = &starget->dev;
@@ -1337,7 +1337,7 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 	lun_data = kmalloc(length, GFP_ATOMIC |
 			   (sdev->host->unchecked_isa_dma ? __GFP_DMA : 0));
 	if (!lun_data) {
-		printk(ALLOC_FAILURE_MSG, __FUNCTION__);
+		printk(ALLOC_FAILURE_MSG, __func__);
 		goto out;
 	}
 
@@ -1649,7 +1649,7 @@ int scsi_scan_host_selected(struct Scsi_Host *shost, unsigned int channel,
 {
 	SCSI_LOG_SCAN_BUS(3, shost_printk (KERN_INFO, shost,
 		"%s: <%u:%u:%u>\n",
-		__FUNCTION__, channel, id, lun));
+		__func__, channel, id, lun));
 
 	if (((channel != SCAN_WILD_CARD) && (channel > shost->max_channel)) ||
 	    ((id != SCAN_WILD_CARD) && (id >= shost->max_id)) ||
@@ -1703,7 +1703,7 @@ static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
 		return NULL;
 
 	if (shost->async_scan) {
-		printk("%s called twice for host %d", __FUNCTION__,
+		printk("%s called twice for host %d", __func__,
 				shost->host_no);
 		dump_stack();
 		return NULL;
@@ -1757,7 +1757,7 @@ static void scsi_finish_async_scan(struct async_scan_data *data)
 	mutex_lock(&shost->scan_mutex);
 
 	if (!shost->async_scan) {
-		printk("%s called twice for host %d", __FUNCTION__,
+		printk("%s called twice for host %d", __func__,
 				shost->host_no);
 		dump_stack();
 		return;
diff --git a/drivers/scsi/scsi_tgt_priv.h b/drivers/scsi/scsi_tgt_priv.h
index cb92888..fe4c621 100644
--- a/drivers/scsi/scsi_tgt_priv.h
+++ b/drivers/scsi/scsi_tgt_priv.h
@@ -6,7 +6,7 @@ struct task_struct;
 /* tmp - will replace with SCSI logging stuff */
 #define eprintk(fmt, args...)					\
 do {								\
-	printk("%s(%d) " fmt, __FUNCTION__, __LINE__, ##args);	\
+	printk("%s(%d) " fmt, __func__, __LINE__, ##args);	\
 } while (0)
 
 #define dprintk(fmt, args...)
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index a272b9a..56823fd 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -571,7 +571,7 @@ send_fail:
 	name = get_fc_host_event_code_name(event_code);
 	printk(KERN_WARNING
 		"%s: Dropped Event : host %d %s data 0x%08x - err %d\n",
-		__FUNCTION__, shost->host_no,
+		__func__, shost->host_no,
 		(name) ? name : "<unknown>", event_data, err);
 	return;
 }
@@ -644,7 +644,7 @@ send_vendor_fail_skb:
 send_vendor_fail:
 	printk(KERN_WARNING
 		"%s: Dropped Event : host %d vendor_unique - err %d\n",
-		__FUNCTION__, shost->host_no, err);
+		__func__, shost->host_no, err);
 	return;
 }
 EXPORT_SYMBOL(fc_host_post_vendor_event);
@@ -2464,7 +2464,7 @@ fc_rport_create(struct Scsi_Host *shost, int channel,
 	size = (sizeof(struct fc_rport) + fci->f->dd_fcrport_size);
 	rport = kzalloc(size, GFP_KERNEL);
 	if (unlikely(!rport)) {
-		printk(KERN_ERR "%s: allocation failure\n", __FUNCTION__);
+		printk(KERN_ERR "%s: allocation failure\n", __func__);
 		return NULL;
 	}
 
@@ -3137,7 +3137,7 @@ fc_vport_create(struct Scsi_Host *shost, int channel, struct device *pdev,
 	size = (sizeof(struct fc_vport) + fci->f->dd_fcvport_size);
 	vport = kzalloc(size, GFP_KERNEL);
 	if (unlikely(!vport)) {
-		printk(KERN_ERR "%s: allocation failure\n", __FUNCTION__);
+		printk(KERN_ERR "%s: allocation failure\n", __func__);
 		return -ENOMEM;
 	}
 
@@ -3201,7 +3201,7 @@ fc_vport_create(struct Scsi_Host *shost, int channel, struct device *pdev,
 			printk(KERN_ERR
 				"%s: Cannot create vport symlinks for "
 				"%s, err=%d\n",
-				__FUNCTION__, dev->bus_id, error);
+				__func__, dev->bus_id, error);
 	}
 	spin_lock_irqsave(shost->host_lock, flags);
 	vport->flags &= ~FC_VPORT_CREATING;
@@ -3314,7 +3314,7 @@ fc_vport_sched_delete(struct work_struct *work)
 	if (stat)
 		dev_printk(KERN_ERR, vport->dev.parent,
 			"%s: %s could not be deleted created via "
-			"shost%d channel %d - error %d\n", __FUNCTION__,
+			"shost%d channel %d - error %d\n", __func__,
 			vport->dev.bus_id, vport->shost->host_no,
 			vport->channel, stat);
 }
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index f4461d3..3666093 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -779,7 +779,7 @@ static void sas_port_create_link(struct sas_port *port,
 	return;
 err:
 	printk(KERN_ERR "%s: Cannot create port links, err=%d\n",
-	       __FUNCTION__, res);
+	       __func__, res);
 }
 
 static void sas_port_delete_link(struct sas_port *port,
@@ -1029,7 +1029,7 @@ void sas_port_mark_backlink(struct sas_port *port)
 	return;
 err:
 	printk(KERN_ERR "%s: Cannot create port backlink, err=%d\n",
-	       __FUNCTION__, res);
+	       __func__, res);
 
 }
 EXPORT_SYMBOL(sas_port_mark_backlink);
diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
index 5b04ddf..646d07e 100644
--- a/drivers/scsi/tmscsim.c
+++ b/drivers/scsi/tmscsim.c
@@ -452,7 +452,10 @@ static int dc390_pci_map (struct dc390_srb* pSRB)
 		/* TODO: error handling */
 		if (pSRB->SGcount != 1)
 			error = 1;
-		DEBUG1(printk("%s(): Mapped sense buffer %p at %x\n", __FUNCTION__, pcmd->sense_buffer, cmdp->saved_dma_handle));
+		DEBUG1(printk(KERN_DEBUG "%s(): Mapped sense buffer %p at %x\n",
+					__func__,
+					pcmd->sense_buffer,
+					cmdp->saved_dma_handle));
 	/* Map SG list */
 	} else if (scsi_sg_count(pcmd)) {
 		int nseg;
@@ -466,7 +469,8 @@ static int dc390_pci_map (struct dc390_srb* pSRB)
 		if (nseg < 0)
 			error = 1;
 		DEBUG1(printk("%s(): Mapped SG %p with %d (%d) elements\n",\
-			      __FUNCTION__, scsi_sglist(pcmd), nseg, scsi_sg_count(pcmd)));
+					__func__, scsi_sglist(pcmd),
+					nseg, scsi_sg_count(pcmd)));
 	/* Map single segment */
 	} else
 		pSRB->SGcount = 0;
@@ -483,11 +487,15 @@ static void dc390_pci_unmap (struct dc390_srb* pSRB)
 
 	if (pSRB->SRBFlag) {
 		pci_unmap_sg(pdev, &pSRB->Segmentx, 1, DMA_FROM_DEVICE);
-		DEBUG1(printk("%s(): Unmapped sense buffer at %x\n", __FUNCTION__, cmdp->saved_dma_handle));
+		DEBUG1(printk(KERN_DEBUG "%s(): Unmapped sense buffer at %x\n",
+					__func__, cmdp->saved_dma_handle));
 	} else {
 		scsi_dma_unmap(pcmd);
-		DEBUG1(printk("%s(): Unmapped SG at %p with %d elements\n",
-			      __FUNCTION__, scsi_sglist(pcmd), scsi_sg_count(pcmd)));
+		DEBUG1(printk(KERN_DEBUG "%s(): Unmapped SG"
+					" at %p with %d elements\n",
+					__func__,
+					scsi_sglist(pcmd),
+					scsi_sg_count(pcmd)));
 	}
 }
 
diff --git a/drivers/scsi/wd7000.c b/drivers/scsi/wd7000.c
index c975c01..ac702ca 100644
--- a/drivers/scsi/wd7000.c
+++ b/drivers/scsi/wd7000.c
@@ -148,7 +148,7 @@
  *
  * 2002/10/04 - Alan Cox <alan@redhat.com>
  *
- * Use dev_id for interrupts, kill __FUNCTION__ pasting
+ * Use dev_id for interrupts, kill __func__ pasting
  * Add a lock for the scb pool, clean up all other cli/sti usage stuff
  * Use the adapter lock for the other places we had the cli's
  *
@@ -640,12 +640,15 @@ static int __init wd7000_setup(char *str)
 	(void) get_options(str, ARRAY_SIZE(ints), ints);
 
 	if (wd7000_card_num >= NUM_CONFIGS) {
-		printk(KERN_ERR "%s: Too many \"wd7000=\" configurations in " "command line!\n", __FUNCTION__);
+		printk(KERN_ERR "%s: Too many \"wd7000=\" configurations "
+				"in " "command line!\n", __func__);
 		return 0;
 	}
 
 	if ((ints[0] < 3) || (ints[0] > 5)) {
-		printk(KERN_ERR "%s: Error in command line!  " "Usage: wd7000=<IRQ>,<DMA>,IO>[,<BUS_ON>" "[,<BUS_OFF>]]\n", __FUNCTION__);
+		printk(KERN_ERR "%s: Error in command line!  "
+				"Usage: wd7000=<IRQ>,<DMA>,IO>[,<BUS_ON>"
+				"[,<BUS_OFF>]]\n", __func__);
 	} else {
 		for (i = 0; i < NUM_IRQS; i++)
 			if (ints[1] == wd7000_irq[i])
@@ -1642,7 +1645,10 @@ static int wd7000_biosparam(struct scsi_device *sdev,
 			ip[2] = info[2];
 
 			if (info[0] == 255)
-				printk(KERN_INFO "%s: current partition table is " "using extended translation.\n", __FUNCTION__);
+				printk(KERN_INFO "%s: current partition table"
+						" is using extended"
+						" translation.\n",
+						__func__);
 		}
 	}
 
diff --git a/drivers/scsi/zalon.c b/drivers/scsi/zalon.c
index 4b5f908..9f3f374 100644
--- a/drivers/scsi/zalon.c
+++ b/drivers/scsi/zalon.c
@@ -68,11 +68,12 @@ lasi_scsi_clock(void * hpa, int defaultclock)
 	if (status == PDC_RET_OK) {
 		clock = (int) pdc_result[16];
 	} else {
-		printk(KERN_WARNING "%s: pdc_iodc_read returned %d\n", __FUNCTION__, status);
+		printk(KERN_WARNING "%s: pdc_iodc_read returned %d\n",
+				__func__, status);
 		clock = defaultclock; 
 	}
 
-	printk(KERN_DEBUG "%s: SCSI clock %d\n", __FUNCTION__, clock);
+	printk(KERN_DEBUG "%s: SCSI clock %d\n", __func__, clock);
  	return clock;
 }
 #endif
@@ -108,13 +109,13 @@ zalon_probe(struct parisc_device *dev)
 	*/
 	dev->irq = gsc_alloc_irq(&gsc_irq);
 
-	printk(KERN_INFO "%s: Zalon version %d, IRQ %d\n", __FUNCTION__,
+	printk(KERN_INFO "%s: Zalon version %d, IRQ %d\n", __func__,
 		zalon_vers, dev->irq);
 
 	__raw_writel(gsc_irq.txn_addr | gsc_irq.txn_data, zalon + IO_MODULE_EIM);
 
 	if (zalon_vers == 0)
-		printk(KERN_WARNING "%s: Zalon 1.1 or earlier\n", __FUNCTION__);
+		printk(KERN_WARNING "%s: Zalon 1.1 or earlier\n", __func__);
 
 	memset(&device, 0, sizeof(struct ncr_device));
 
-- 
1.5.6.3

