From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 01/18] qla2xxx: Use less stack to emit logging messages.
Date: Fri, 18 Nov 2011 09:03:05 -0800
Message-ID: <1321635802-16491-2-git-send-email-chad.dupuis@qlogic.com>
References: <1321635802-16491-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-va3.bigfish.com ([216.32.180.10]:7313 "EHLO
	VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758153Ab1KRRQ2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Nov 2011 12:16:28 -0500
In-Reply-To: <1321635802-16491-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Perches <joe@perches.ccom>

Return early when logging level too low.
Use normal kernel codeing style for function braces.
Add const where appropriate to logging functions.
Remove now unused #define QL_DBG_BUF_LEN.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c |  212 +++++++++++++++++++--------------------
 drivers/scsi/qla2xxx/qla_dbg.h |   10 +-
 2 files changed, 107 insertions(+), 115 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index f3cddd5..6db16af 100644
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
1.6.0.2


