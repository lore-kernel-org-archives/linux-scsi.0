From: Joe Perches <joe@perches.com>
Subject: [PATCH 1/2] qla2xxx: Rewrite logging functions to use %pV
Date: Sat, 30 Jul 2011 16:05:11 -0700
Message-ID: <f404820a01953db2c3608f90c40b8567646f079a.1312067036.git.joe@perches.com>
References: <cover.1312067036.git.joe@perches.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:4385 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199Ab1G3XFT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 30 Jul 2011 19:05:19 -0400
In-Reply-To: <cover.1312067036.git.joe@perches.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-driver@qlogic.com
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Use less stack to emit logging messages.

Return early when logging level too low.
Use normal kernel coding style for function braces.
Add const where appropriate to logging functions.
Remove now unused #define QL_DBG_BUF_LEN.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c |  212 +++++++++++++++++++--------------------
 drivers/scsi/qla2xxx/qla_dbg.h |   10 +-
 2 files changed, 107 insertions(+), 115 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 2155071..95ec457 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -1664,34 +1664,31 @@ qla81xx_fw_dump_failed:
  * msg:   The message to be displayed.
  */
 void
-ql_dbg(uint32_t level, scsi_qla_host_t *vha, int32_t id, char *msg, ...) {
+ql_dbg(uint32_t level, scsi_qla_host_t *vha, int32_t id, const char *fmt, ...)
+{
+	va_list va;
+	struct va_format vaf;
 
-	char pbuf[QL_DBG_BUF_LEN];
-	va_list ap;
-	uint32_t len;
-	struct pci_dev *pdev = NULL;
+	if ((level & ql2xextended_error_logging) != level)
+		return;
 
-	memset(pbuf, 0, QL_DBG_BUF_LEN);
+	va_start(va, fmt);
 
-	va_start(ap, msg);
+	vaf.fmt = fmt;
+	vaf.va = &va;
 
-	if ((level & ql2xextended_error_logging) == level) {
-		if (vha != NULL) {
-			pdev = vha->hw->pdev;
-			/* <module-name> <pci-name> <msg-id>:<host> Message */
-			sprintf(pbuf, "%s [%s]-%04x:%ld: ", QL_MSGHDR,
-			    dev_name(&(pdev->dev)), id + ql_dbg_offset,
-			    vha->host_no);
-		} else
-			sprintf(pbuf, "%s [%s]-%04x: : ", QL_MSGHDR,
-			    "0000:00:00.0", id + ql_dbg_offset);
-
-		len = strlen(pbuf);
-		vsprintf(pbuf+len, msg, ap);
-		pr_warning("%s", pbuf);
+	if (vha != NULL) {
+		const struct pci_dev *pdev = vha->hw->pdev;
+		/* <module-name> <pci-name> <msg-id>:<host> Message */
+		pr_warn("%s [%s]-%04x:%ld: %pV",
+			QL_MSGHDR, dev_name(&(pdev->dev)), id + ql_dbg_offset,
+			vha->host_no, &vaf);
+	} else {
+		pr_warn("%s [%s]-%04x: : %pV",
+			QL_MSGHDR, "0000:00:00.0", id + ql_dbg_offset, &vaf);
 	}
 
-	va_end(ap);
+	va_end(va);
 
 }
 
@@ -1710,31 +1707,27 @@ ql_dbg(uint32_t level, scsi_qla_host_t *vha, int32_t id, char *msg, ...) {
  * msg:   The message to be displayed.
  */
 void
-ql_dbg_pci(uint32_t level, struct pci_dev *pdev, int32_t id, char *msg, ...) {
-
-	char pbuf[QL_DBG_BUF_LEN];
-	va_list ap;
-	uint32_t len;
+ql_dbg_pci(uint32_t level, struct pci_dev *pdev, int32_t id,
+	   const char *fmt, ...)
+{
+	va_list va;
+	struct va_format vaf;
 
 	if (pdev == NULL)
 		return;
+	if ((level & ql2xextended_error_logging) != level)
+		return;
 
-	memset(pbuf, 0, QL_DBG_BUF_LEN);
-
-	va_start(ap, msg);
-
-	if ((level & ql2xextended_error_logging) == level) {
-		/* <module-name> <dev-name>:<msg-id> Message */
-		sprintf(pbuf, "%s [%s]-%04x: : ", QL_MSGHDR,
-		    dev_name(&(pdev->dev)), id + ql_dbg_offset);
+	va_start(va, fmt);
 
-		len = strlen(pbuf);
-		vsprintf(pbuf+len, msg, ap);
-		pr_warning("%s", pbuf);
-	}
+	vaf.fmt = fmt;
+	vaf.va = &va;
 
-	va_end(ap);
+	/* <module-name> <dev-name>:<msg-id> Message */
+	pr_warn("%s [%s]-%04x: : %pV",
+		QL_MSGHDR, dev_name(&(pdev->dev)), id + ql_dbg_offset, &vaf);
 
+	va_end(va);
 }
 
 /*
@@ -1751,47 +1744,47 @@ ql_dbg_pci(uint32_t level, struct pci_dev *pdev, int32_t id, char *msg, ...) {
  * msg:   The message to be displayed.
  */
 void
-ql_log(uint32_t level, scsi_qla_host_t *vha, int32_t id, char *msg, ...) {
-
-	char pbuf[QL_DBG_BUF_LEN];
-	va_list ap;
-	uint32_t len;
-	struct pci_dev *pdev = NULL;
-
-	memset(pbuf, 0, QL_DBG_BUF_LEN);
-
-	va_start(ap, msg);
-
-	if (level <= ql_errlev) {
-		if (vha != NULL) {
-			pdev = vha->hw->pdev;
-			/* <module-name> <msg-id>:<host> Message */
-			sprintf(pbuf, "%s [%s]-%04x:%ld: ", QL_MSGHDR,
-			    dev_name(&(pdev->dev)), id, vha->host_no);
-		} else
-			sprintf(pbuf, "%s [%s]-%04x: : ", QL_MSGHDR,
-			    "0000:00:00.0", id);
+ql_log(uint32_t level, scsi_qla_host_t *vha, int32_t id, const char *fmt, ...)
+{
+	va_list va;
+	struct va_format vaf;
+	char pbuf[128];
 
-		len = strlen(pbuf);
-			vsprintf(pbuf+len, msg, ap);
+	if (level > ql_errlev)
+		return;
 
-		switch (level) {
-		case 0: /* FATAL LOG */
-			pr_crit("%s", pbuf);
-			break;
-		case 1:
-			pr_err("%s", pbuf);
-			break;
-		case 2:
-			pr_warn("%s", pbuf);
-			break;
-		default:
-			pr_info("%s", pbuf);
-			break;
-		}
+	if (vha != NULL) {
+		const struct pci_dev *pdev = vha->hw->pdev;
+		/* <module-name> <msg-id>:<host> Message */
+		snprintf(pbuf, sizeof(pbuf), "%s [%s]-%04x:%ld: ",
+			QL_MSGHDR, dev_name(&(pdev->dev)), id, vha->host_no);
+	} else {
+		snprintf(pbuf, sizeof(pbuf), "%s [%s]-%04x: : ",
+			QL_MSGHDR, "0000:00:00.0", id);
+	}
+	pbuf[sizeof(pbuf) - 1] = 0;
+
+	va_start(va, fmt);
+
+	vaf.fmt = fmt;
+	vaf.va = &va;
+
+	switch (level) {
+	case 0: /* FATAL LOG */
+		pr_crit("%s%pV", pbuf, &vaf);
+		break;
+	case 1:
+		pr_err("%s%pV", pbuf, &vaf);
+		break;
+	case 2:
+		pr_warn("%s%pV", pbuf, &vaf);
+		break;
+	default:
+		pr_info("%s%pV", pbuf, &vaf);
+		break;
 	}
 
-	va_end(ap);
+	va_end(va);
 }
 
 /*
@@ -1809,43 +1802,44 @@ ql_log(uint32_t level, scsi_qla_host_t *vha, int32_t id, char *msg, ...) {
  * msg:   The message to be displayed.
  */
 void
-ql_log_pci(uint32_t level, struct pci_dev *pdev, int32_t id, char *msg, ...) {
-
-	char pbuf[QL_DBG_BUF_LEN];
-	va_list ap;
-	uint32_t len;
+ql_log_pci(uint32_t level, struct pci_dev *pdev, int32_t id,
+	   const char *fmt, ...)
+{
+	va_list va;
+	struct va_format vaf;
+	char pbuf[128];
 
 	if (pdev == NULL)
 		return;
+	if (level > ql_errlev)
+		return;
 
-	memset(pbuf, 0, QL_DBG_BUF_LEN);
-
-	va_start(ap, msg);
-
-	if (level <= ql_errlev) {
-		/* <module-name> <dev-name>:<msg-id> Message */
-		sprintf(pbuf, "%s [%s]-%04x: : ", QL_MSGHDR,
-		    dev_name(&(pdev->dev)), id);
-
-		len = strlen(pbuf);
-		vsprintf(pbuf+len, msg, ap);
-		switch (level) {
-		case 0: /* FATAL LOG */
-			pr_crit("%s", pbuf);
-			break;
-		case 1:
-			pr_err("%s", pbuf);
-			break;
-		case 2:
-			pr_warn("%s", pbuf);
-			break;
-		default:
-			pr_info("%s", pbuf);
-			break;
-		}
+	/* <module-name> <dev-name>:<msg-id> Message */
+	snprintf(pbuf, sizeof(pbuf), "%s [%s]-%04x: : ",
+		 QL_MSGHDR, dev_name(&(pdev->dev)), id);
+	pbuf[sizeof(pbuf) - 1] = 0;
+
+	va_start(va, fmt);
+
+	vaf.fmt = fmt;
+	vaf.va = &va;
+
+	switch (level) {
+	case 0: /* FATAL LOG */
+		pr_crit("%s%pV", pbuf, &vaf);
+		break;
+	case 1:
+		pr_err("%s%pV", pbuf, &vaf);
+		break;
+	case 2:
+		pr_warn("%s%pV", pbuf, &vaf);
+		break;
+	default:
+		pr_info("%s%pV", pbuf, &vaf);
+		break;
 	}
 
-	va_end(ap);
+	va_end(va);
 }
 
 void
@@ -1888,7 +1882,7 @@ ql_dump_buffer(uint32_t level, scsi_qla_host_t *vha, int32_t id,
 		ql_dbg(level, vha, id, "----------------------------------"
 		    "----------------------------\n");
 
-		ql_dbg(level, vha, id, "");
+		ql_dbg(level, vha, id, " ");
 		for (cnt = 0; cnt < size;) {
 			c = *b++;
 			printk("%02x", (uint32_t) c);
diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
index 98a377b..0692814 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.h
+++ b/drivers/scsi/qla2xxx/qla_dbg.h
@@ -245,14 +245,14 @@ struct qla2xxx_fw_dump {
 extern int ql_errlev;
 
 void
-ql_dbg(uint32_t, scsi_qla_host_t *vha, int32_t, char *, ...);
+ql_dbg(uint32_t, scsi_qla_host_t *vha, int32_t, const char *fmt, ...);
 void
-ql_dbg_pci(uint32_t, struct pci_dev *pdev, int32_t, char *, ...);
+ql_dbg_pci(uint32_t, struct pci_dev *pdev, int32_t, const char *fmt, ...);
 
 void
-ql_log(uint32_t, scsi_qla_host_t *vha, int32_t, char *, ...);
+ql_log(uint32_t, scsi_qla_host_t *vha, int32_t, const char *fmt, ...);
 void
-ql_log_pci(uint32_t, struct pci_dev *pdev, int32_t, char *, ...);
+ql_log_pci(uint32_t, struct pci_dev *pdev, int32_t, const char *fmt, ...);
 
 /* Debug Levels */
 /* The 0x40000000 is the max value any debug level can have
@@ -275,5 +275,3 @@ ql_log_pci(uint32_t, struct pci_dev *pdev, int32_t, char *, ...);
 #define ql_dbg_misc	0x00010000 /* For dumping everything that is not
 				    * not covered by upper categories
 				    */
-
-#define QL_DBG_BUF_LEN	512
-- 
1.7.6.131.g99019

