Return-Path: <SRS0=QZQu=BU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD9BDC433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 22:59:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CB4820734
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 22:59:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbgHJW7f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Aug 2020 18:59:35 -0400
Received: from smtprelay0143.hostedemail.com ([216.40.44.143]:51186 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726634AbgHJW7e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 Aug 2020 18:59:34 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id D04F018029D8A;
        Mon, 10 Aug 2020 22:59:31 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: route45_251456626fde
X-Filterd-Recvd-Size: 19104
Received: from joe-laptop.perches.com (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf03.hostedemail.com (Postfix) with ESMTPA;
        Mon, 10 Aug 2020 22:59:30 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 2/2] scsi: lpfc: Add logging functions to reduce object size
Date:   Mon, 10 Aug 2020 15:59:20 -0700
Message-Id: <9dc4b3349e67a225e26d2d25e261a5b24a3f92b5.1597100152.git.joe@perches.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <cover.1597100152.git.joe@perches.com>
References: <cover.1597100152.git.joe@perches.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make functions from logging macros.

Reduces overall object size ~14% (120KB) (x86-64, defconfig, with LPFC)

$ size -t drivers/scsi/lpfc/built-in.a.old
 888552	   8910	   2900	 900362	  dbd0a	(TOTALS)
$ size -t drivers/scsi/lpfc/built-in.a.new
 766757	   8910	   2900	 778567	  be147	(TOTALS)

Miscellanea:

o Add header #ifdef guards where unused in .h files

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/lpfc/Makefile       |   2 +-
 drivers/scsi/lpfc/lpfc.h         |   5 ++
 drivers/scsi/lpfc/lpfc_attr.h    |   5 ++
 drivers/scsi/lpfc/lpfc_bsg.h     |   6 ++
 drivers/scsi/lpfc/lpfc_compat.h  |   5 ++
 drivers/scsi/lpfc/lpfc_crtn.h    |   5 ++
 drivers/scsi/lpfc/lpfc_disc.h    |   5 ++
 drivers/scsi/lpfc/lpfc_hw.h      |   5 ++
 drivers/scsi/lpfc/lpfc_hw4.h     |   5 ++
 drivers/scsi/lpfc/lpfc_ids.h     |   5 ++
 drivers/scsi/lpfc/lpfc_logmsg.c  | 112 +++++++++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_logmsg.h  |  72 ++++++--------------
 drivers/scsi/lpfc/lpfc_nl.h      |   4 ++
 drivers/scsi/lpfc/lpfc_nvme.h    |   5 ++
 drivers/scsi/lpfc/lpfc_scsi.h    |   4 ++
 drivers/scsi/lpfc/lpfc_sli.h     |   5 ++
 drivers/scsi/lpfc/lpfc_sli4.h    |   5 ++
 drivers/scsi/lpfc/lpfc_version.h |   5 ++
 18 files changed, 207 insertions(+), 53 deletions(-)
 create mode 100644 drivers/scsi/lpfc/lpfc_logmsg.c

diff --git a/drivers/scsi/lpfc/Makefile b/drivers/scsi/lpfc/Makefile
index 092a971d066b..ebe0d3ddee27 100644
--- a/drivers/scsi/lpfc/Makefile
+++ b/drivers/scsi/lpfc/Makefile
@@ -33,4 +33,4 @@ obj-$(CONFIG_SCSI_LPFC) := lpfc.o
 lpfc-objs := lpfc_mem.o lpfc_sli.o lpfc_ct.o lpfc_els.o \
 	lpfc_hbadisc.o	lpfc_init.o lpfc_mbox.o lpfc_nportdisc.o   \
 	lpfc_scsi.o lpfc_attr.o lpfc_vport.o lpfc_debugfs.o lpfc_bsg.o \
-	lpfc_nvme.o lpfc_nvmet.o
+	lpfc_nvme.o lpfc_nvmet.o lpfc_logmsg.o
diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 549adfaa97ce..571f35826947 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -21,6 +21,9 @@
  * included with this package.                                     *
  *******************************************************************/
 
+#ifndef _H_LPFC
+#define _H_LPFC
+
 #include <scsi/scsi_host.h>
 #include <linux/ktime.h>
 #include <linux/workqueue.h>
@@ -1409,3 +1412,5 @@ static const char *routine(enum enum_name table_key)			\
 	}								\
 	return name;							\
 }
+
+#endif
diff --git a/drivers/scsi/lpfc/lpfc_attr.h b/drivers/scsi/lpfc/lpfc_attr.h
index 9659a8fff971..94a7e2231ec6 100644
--- a/drivers/scsi/lpfc/lpfc_attr.h
+++ b/drivers/scsi/lpfc/lpfc_attr.h
@@ -21,6 +21,9 @@
  * included with this package.                                     *
  *******************************************************************/
 
+#ifndef _H_LPFC_ATTR
+#define _H_LPFC_ATTR
+
 #define LPFC_ATTR(name, defval, minval, maxval, desc) \
 static uint lpfc_##name = defval;\
 module_param(lpfc_##name, uint, S_IRUGO);\
@@ -126,3 +129,5 @@ lpfc_vport_param_set(name, defval, minval, maxval)\
 lpfc_vport_param_store(name)\
 static DEVICE_ATTR(lpfc_##name, S_IRUGO | S_IWUSR,\
 		   lpfc_##name##_show, lpfc_##name##_store)
+
+#endif
diff --git a/drivers/scsi/lpfc/lpfc_bsg.h b/drivers/scsi/lpfc/lpfc_bsg.h
index 2dc71243775d..5f64584647db 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.h
+++ b/drivers/scsi/lpfc/lpfc_bsg.h
@@ -19,6 +19,10 @@
  * more details, a copy of which can be found in the file COPYING  *
  * included with this package.                                     *
  *******************************************************************/
+
+#ifndef _H_LPFC_BSG
+#define _H_LPFC_BSG
+
 /* bsg definitions
  * No pointers to user data are allowed, all application buffers and sizes will
  * derived through the bsg interface.
@@ -389,3 +393,5 @@ struct get_trunk_info_req {
 /* driver only */
 #define SLI_CONFIG_NOT_HANDLED		0
 #define SLI_CONFIG_HANDLED		1
+
+#endif
diff --git a/drivers/scsi/lpfc/lpfc_compat.h b/drivers/scsi/lpfc/lpfc_compat.h
index 43cf46a3a71f..d6ccde39269a 100644
--- a/drivers/scsi/lpfc/lpfc_compat.h
+++ b/drivers/scsi/lpfc/lpfc_compat.h
@@ -20,6 +20,9 @@
  * included with this package.                                     *
  *******************************************************************/
 
+#ifndef _H_LPFC_COMPAT
+#define _H_LPFC_COMPAT
+
 /*
  * This file provides macros to aid compilation in the Linux 2.4 kernel
  * over various platform architectures.
@@ -96,3 +99,5 @@ lpfc_memcpy_from_slim( void *dest, void __iomem *src, unsigned int bytes)
 }
 
 #endif	/* __BIG_ENDIAN */
+
+#endif
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 782f6f76f18a..dd8553ecf091 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -20,6 +20,9 @@
  * included with this package.                                     *
  *******************************************************************/
 
+#ifndef _H_LPFC_CRTN
+#define _H_LPFC_CRTN
+
 typedef int (*node_filter)(struct lpfc_nodelist *, void *);
 
 struct fc_rport;
@@ -600,3 +603,5 @@ extern int lpfc_enable_nvmet_cnt;
 extern unsigned long long lpfc_enable_nvmet[];
 extern int lpfc_no_hba_reset_cnt;
 extern unsigned long lpfc_no_hba_reset[];
+
+#endif
diff --git a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
index 482e4a888dae..9d3f49e007fa 100644
--- a/drivers/scsi/lpfc/lpfc_disc.h
+++ b/drivers/scsi/lpfc/lpfc_disc.h
@@ -20,6 +20,9 @@
  * included with this package.                                     *
  *******************************************************************/
 
+#ifndef _H_LPFC_DISC
+#define _H_LPFC_DISC
+
 #define FC_MAX_HOLD_RSCN     32	      /* max number of deferred RSCNs */
 #define FC_MAX_NS_RSP        64512    /* max size NameServer rsp */
 #define FC_MAXLOOP           126      /* max devices supported on a fc loop */
@@ -299,3 +302,5 @@ struct lpfc_node_rrq {
 #define NLP_EVT_DEVICE_RECOVERY   0xc	/* Device existence unknown */
 #define NLP_EVT_MAX_EVENT         0xd
 #define NLP_EVT_NOTHING_PENDING   0xff
+
+#endif
diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index c20034b3101c..c56a9fd0a1eb 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -20,6 +20,9 @@
  * included with this package.                                     *
  *******************************************************************/
 
+#ifndef _H_LPFC_HW
+#define _H_LPFC_HW
+
 #define FDMI_DID        0xfffffaU
 #define NameServer_DID  0xfffffcU
 #define Fabric_Cntl_DID 0xfffffdU
@@ -4265,3 +4268,5 @@ lpfc_error_lost_link(IOCB_t *iocbp)
 #define SETVAR_MLORST 0x103007
 
 #define BPL_ALIGN_SZ 8 /* 8 byte alignment for bpl and mbufs */
+
+#endif
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index c4ba8273a63f..d9e6bf53f520 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -20,6 +20,9 @@
  * included with this package.                                     *
  *******************************************************************/
 
+#ifndef _H_LPFC_HW4
+#define _H_LPFC_HW4
+
 #include <uapi/scsi/fc/fc_els.h>
 
 /* Macros to deal with bit fields. Each bit field must have 3 #defines
@@ -4912,3 +4915,5 @@ struct lpfc_grp_hdr {
 #define LPFC_FW_DUMP	1
 #define LPFC_FW_RESET	2
 #define LPFC_DV_RESET	3
+
+#endif
diff --git a/drivers/scsi/lpfc/lpfc_ids.h b/drivers/scsi/lpfc/lpfc_ids.h
index d48414e295a0..2abb7b098a3d 100644
--- a/drivers/scsi/lpfc/lpfc_ids.h
+++ b/drivers/scsi/lpfc/lpfc_ids.h
@@ -21,6 +21,9 @@
  * included with this package.                                     *
  *******************************************************************/
 
+#ifndef _H_LPFC_IDS
+#define _H_LPFC_IDS
+
 #include <linux/pci.h>
 
 const struct pci_device_id lpfc_id_table[] = {
@@ -124,3 +127,5 @@ const struct pci_device_id lpfc_id_table[] = {
 		PCI_ANY_ID, PCI_ANY_ID, },
 	{ 0 }
 };
+
+#endif
diff --git a/drivers/scsi/lpfc/lpfc_logmsg.c b/drivers/scsi/lpfc/lpfc_logmsg.c
new file mode 100644
index 000000000000..37449fb566c4
--- /dev/null
+++ b/drivers/scsi/lpfc/lpfc_logmsg.c
@@ -0,0 +1,112 @@
+#include <linux/kernel.h>
+#include <linux/wait.h>
+#include <linux/timer.h>
+#include <linux/kref.h>
+#include <linux/pci.h>
+
+#include <scsi/scsi_transport_fc.h>
+
+#include "lpfc_hw4.h"
+#include "lpfc_hw.h"
+#include "lpfc_sli.h"
+#include "lpfc_sli4.h"
+#include "lpfc_nl.h"
+#include "lpfc_disc.h"
+#include "lpfc.h"
+#include "lpfc_logmsg.h"
+
+/* generate message by verbose log setting or severity */
+void lpfc_vlog_msg(struct lpfc_vport *vport,
+		   const char *level, uint32_t mask,
+		   const char *fmt, ...)
+{
+	if ((mask & vport->cfg_log_verbose) || level[1] <= '4') {
+		struct va_format vaf;
+		va_list args;
+
+		va_start(args, fmt);
+		vaf.fmt = fmt;
+		vaf.va = &args;
+
+		dev_printk(level, &vport->phba->pcidev->dev,
+			   "%d:(%d):%pV",
+			   vport->phba->brd_no, vport->vpi, &vaf);
+
+		va_end(args);
+	}
+}
+
+void lpfc_printf_vlog(struct lpfc_vport *vport,
+		      const char *level, uint32_t mask,
+		      const char *fmt, ...)
+{
+	struct va_format vaf;
+	va_list args;
+
+	va_start(args, fmt);
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	if ((mask & vport->cfg_log_verbose) || level[1] <= '3') {
+		if (mask & LOG_TRACE_EVENT)
+			lpfc_dmp_dbg(vport->phba);
+		dev_printk(level, &vport->phba->pcidev->dev,
+			   "%d:(%d):%pV",
+			   vport->phba->brd_no, vport->vpi, &vaf);
+	} else if (!vport->cfg_log_verbose) {
+		lpfc_dbg_print(vport->phba,
+			       "%d:(%d):%pV",
+			       vport->phba->brd_no, vport->vpi, &vaf);
+	}
+
+	va_end(args);
+}
+
+void lpfc_log_msg(struct lpfc_hba *phba,
+		  const char *level, uint32_t mask,
+		  const char *fmt, ...)
+{
+	uint32_t log_verbose = phba->pport ?
+		phba->pport->cfg_log_verbose :
+		phba->cfg_log_verbose;
+
+	if ((mask & log_verbose) || level[1] <= '4') {
+		struct va_format vaf;
+		va_list args;
+
+		va_start(args, fmt);
+		vaf.fmt = fmt;
+		vaf.va = &args;
+
+		dev_printk(level, &phba->pcidev->dev,
+			   "%d:%pV", phba->brd_no, &vaf);
+
+		va_end(args);
+	}
+}
+
+void lpfc_printf_log(struct lpfc_hba *phba,
+		     const char *level, uint32_t mask,
+		     const char *fmt, ...)
+{
+	uint32_t log_verbose = phba->pport ?
+		phba->pport->cfg_log_verbose :
+		phba->cfg_log_verbose;
+	struct va_format vaf;
+	va_list args;
+
+	va_start(args, fmt);
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	if ((mask & log_verbose) || level[1] <= '3') {
+		if (mask & LOG_TRACE_EVENT)
+			lpfc_dmp_dbg(phba);
+		dev_printk(level, &phba->pcidev->dev,
+			   "%d:%pV", phba->brd_no, &vaf);
+	} else if (!phba->cfg_log_verbose) {
+		lpfc_dbg_print(phba, "%d:%pV", phba->brd_no, &vaf);
+	}
+
+	va_end(args);
+}
diff --git a/drivers/scsi/lpfc/lpfc_logmsg.h b/drivers/scsi/lpfc/lpfc_logmsg.h
index c57adcdda258..2ff412cb6702 100644
--- a/drivers/scsi/lpfc/lpfc_logmsg.h
+++ b/drivers/scsi/lpfc/lpfc_logmsg.h
@@ -20,6 +20,9 @@
  * included with this package.                                     *
  *******************************************************************/
 
+#ifndef _H_LPFC_LOGMSG
+#define _H_LPFC_LOGMSG
+
 #define LOG_ELS		0x00000001	/* ELS events */
 #define LOG_DISCOVERY	0x00000002	/* Link discovery events */
 #define LOG_MBOX	0x00000004	/* Mailbox events */
@@ -52,56 +55,21 @@ __printf(2, 3)
 void lpfc_dbg_print(struct lpfc_hba *phba, const char *fmt, ...);
 
 /* generate message by verbose log setting or severity */
-#define lpfc_vlog_msg(vport, level, mask, fmt, ...)			\
-do {									\
-	if (((mask) & (vport)->cfg_log_verbose) || (level[1] <= '4'))	\
-		dev_printk(level, &((vport)->phba->pcidev)->dev,	\
-			   "%d:(%d):" fmt,				\
-			   (vport)->phba->brd_no, vport->vpi,		\
-			   ##__VA_ARGS__);				\
-} while (0)
-
-#define lpfc_log_msg(phba, level, mask, fmt, ...)			\
-do {									\
-	uint32_t log_verbose = (phba)->pport ?				\
-		(phba)->pport->cfg_log_verbose :			\
-		(phba)->cfg_log_verbose;				\
-	if (((mask) & log_verbose) || (level[1] <= '4'))		\
-		dev_printk(level, &((phba)->pcidev)->dev,		\
-			   "%d:" fmt,					\
-			   phba->brd_no, ##__VA_ARGS__);		\
-} while (0)
-
-#define lpfc_printf_vlog(vport, level, mask, fmt, ...)			\
-do {									\
-	if (((mask) & (vport)->cfg_log_verbose) || (level[1] <= '3')) { \
-		if ((mask) & LOG_TRACE_EVENT)				\
-			lpfc_dmp_dbg((vport)->phba);			\
-		dev_printk(level, &((vport)->phba->pcidev)->dev,	\
-			   "%d:(%d):" fmt,				\
-			   (vport)->phba->brd_no, vport->vpi,		\
-			   ##__VA_ARGS__);				\
-	} else if (!(vport)->cfg_log_verbose) {				\
-		lpfc_dbg_print((vport)->phba,				\
-			       "%d:(%d):" fmt,				\
-			       (vport)->phba->brd_no, (vport)->vpi,	\
-			       ##__VA_ARGS__);				\
-	}								\
-} while (0)
+__printf(4, 5)
+void lpfc_vlog_msg(struct lpfc_vport *vport,
+		   const char *level, uint32_t mask,
+		   const char *fmt, ...);
+__printf(4, 5)
+void lpfc_printf_vlog(struct lpfc_vport *vport,
+		      const char *level, uint32_t mask,
+		      const char *fmt, ...);
+__printf(4, 5)
+void lpfc_log_msg(struct lpfc_hba *phba,
+		  const char *level, uint32_t mask,
+		  const char *fmt, ...);
+__printf(4, 5)
+void lpfc_printf_log(struct lpfc_hba *phba,
+		     const char *level, uint32_t mask,
+		     const char *fmt, ...);
 
-#define lpfc_printf_log(phba, level, mask, fmt, ...)			\
-do {									\
-	uint32_t log_verbose = (phba)->pport ?				\
-		(phba)->pport->cfg_log_verbose :			\
-		(phba)->cfg_log_verbose;				\
-	if (((mask) & log_verbose) || (level[1] <= '3')) {		\
-		if ((mask) & LOG_TRACE_EVENT)				\
-			lpfc_dmp_dbg(phba);				\
-		dev_printk(level, &((phba)->pcidev)->dev,		\
-			   "%d:" fmt,					\
-			   phba->brd_no, ##__VA_ARGS__);		\
-	} else if (!(phba)->cfg_log_verbose) {				\
-		lpfc_dbg_print(phba, "%d:" fmt,				\
-			       phba->brd_no, ##__VA_ARGS__);		\
-	}								\
-} while (0)
+#endif
diff --git a/drivers/scsi/lpfc/lpfc_nl.h b/drivers/scsi/lpfc/lpfc_nl.h
index 95d60ab5ebf9..eefbcd032dfe 100644
--- a/drivers/scsi/lpfc/lpfc_nl.h
+++ b/drivers/scsi/lpfc/lpfc_nl.h
@@ -20,6 +20,9 @@
  * included with this package.                                     *
  *******************************************************************/
 
+#ifndef _H_LPFC_NL
+#define _H_LPFC_NL
+
 /* Event definitions for RegisterForEvent */
 #define FC_REG_LINK_EVENT		0x0001	/* link up / down events */
 #define FC_REG_RSCN_EVENT		0x0002	/* RSCN events */
@@ -179,3 +182,4 @@ struct temp_event {
 	uint32_t data;
 };
 
+#endif
diff --git a/drivers/scsi/lpfc/lpfc_nvme.h b/drivers/scsi/lpfc/lpfc_nvme.h
index 4a4c3f780e1f..09696510c3b3 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.h
+++ b/drivers/scsi/lpfc/lpfc_nvme.h
@@ -21,6 +21,9 @@
  * included with this package.                                     *
  ********************************************************************/
 
+#ifndef _H_LPFC_NVME
+#define _H_LPFC_NVME
+
 #include <linux/nvme.h>
 #include <linux/nvme-fc-driver.h>
 #include <linux/nvme-fc.h>
@@ -254,3 +257,5 @@ int __lpfc_nvme_xmt_ls_rsp(struct lpfc_async_xchg_ctx *axchg,
 				struct lpfc_wcqe_complete *wcqe));
 void __lpfc_nvme_xmt_ls_rsp_cmp(struct lpfc_hba *phba,
 		struct lpfc_iocbq *cmdwqe, struct lpfc_wcqe_complete *wcqe);
+
+#endif
diff --git a/drivers/scsi/lpfc/lpfc_scsi.h b/drivers/scsi/lpfc/lpfc_scsi.h
index f76667b7da7b..7115a3fb6acf 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.h
+++ b/drivers/scsi/lpfc/lpfc_scsi.h
@@ -20,6 +20,9 @@
  * included with this package.                                     *
  *******************************************************************/
 
+#ifndef _H_LPFC_SCSI
+#define _H_LPFC_SCSI
+
 #include <asm/byteorder.h>
 
 struct lpfc_hba;
@@ -147,3 +150,4 @@ struct lpfc_scsicmd_bkt {
 /* For sysfs/debugfs tmp string max len */
 #define LPFC_MAX_SCSI_INFO_TMP_LEN	79
 
+#endif
diff --git a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
index 93d976ea8c5d..f24f875e1fe8 100644
--- a/drivers/scsi/lpfc/lpfc_sli.h
+++ b/drivers/scsi/lpfc/lpfc_sli.h
@@ -20,6 +20,9 @@
  * included with this package.                                     *
  *******************************************************************/
 
+#ifndef _H_LPFC_SLI
+#define _H_LPFC_SLI
+
 #if defined(CONFIG_DEBUG_FS) && !defined(CONFIG_SCSI_LPFC_DEBUG_FS)
 #define CONFIG_SCSI_LPFC_DEBUG_FS
 #endif
@@ -449,3 +452,5 @@ struct lpfc_io_buf {
 	uint64_t ts_data_io;
 #endif
 };
+
+#endif
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index a966cdeb52ee..9096b2c941e7 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -20,6 +20,9 @@
  * included with this package.                                     *
  *******************************************************************/
 
+#ifndef _H_LPFC_SLI4
+#define _H_LPFC_SLI4
+
 #include <linux/irq_poll.h>
 #include <linux/cpufreq.h>
 
@@ -1160,3 +1163,5 @@ static inline void *lpfc_sli4_qe(struct lpfc_queue *q, uint16_t idx)
 	return q->q_pgs[idx / q->entry_cnt_per_pg] +
 		(q->entry_size * (idx % q->entry_cnt_per_pg));
 }
+
+#endif
diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index 20adec4387f0..259c4a72db74 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,6 +20,9 @@
  * included with this package.                                     *
  *******************************************************************/
 
+#ifndef _H_LPFC_VERSION
+#define _H_LPFC_VERSION
+
 #define LPFC_DRIVER_VERSION "12.8.0.3"
 #define LPFC_DRIVER_NAME		"lpfc"
 
@@ -35,3 +38,5 @@
 #define LPFC_COPYRIGHT "Copyright (C) 2017-2019 Broadcom. All Rights " \
 		"Reserved. The term \"Broadcom\" refers to Broadcom Inc. " \
 		"and/or its subsidiaries."
+
+#endif
-- 
2.26.0

