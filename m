From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] qla2xxx: Don't memset buffer unless debug level is enabled
Date: Wed, 30 Nov 2011 22:03:59 +0000
Message-ID: <1322690639-20756-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: target-devel <target-devel@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Roland Dreier <roland@purestorage.com>, Joern Engel <joern@logfs.org>, James Bottomley <JBottomley@Parallels.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

During recent perf testing with qla_target.c logic, dl_dbg() appeared
as one of the top CPU consumers (~5% CPU) with small block random I/O
even when no debug levels have been enabled.

This patch moves the explict memset() in four qla_dbc.c functions
within code blocks to where we know it will actually be used to save
the extra wasted cycles.

Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>
Cc: Roland Dreier <roland@purestorage.com>
Cc: Joern Engel <joern@logfs.org>
Cc: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/qla2xxx/qla_dbg.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 07372de..cc32ec8 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -1676,11 +1676,11 @@ ql_dbg(uint32_t level, scsi_qla_host_t *vha, int32_t id, char *msg, ...) {
 	uint32_t len;
 	struct pci_dev *pdev = NULL;
 
-	memset(pbuf, 0, QL_DBG_BUF_LEN);
-
 	va_start(ap, msg);
 
 	if ((level & ql2xextended_error_logging) == level) {
+		memset(pbuf, 0, QL_DBG_BUF_LEN);
+		
 		if (vha != NULL) {
 			pdev = vha->hw->pdev;
 			/* <module-name> <pci-name> <msg-id>:<host> Message */
@@ -1724,11 +1724,11 @@ ql_dbg_pci(uint32_t level, struct pci_dev *pdev, int32_t id, char *msg, ...) {
 	if (pdev == NULL)
 		return;
 
-	memset(pbuf, 0, QL_DBG_BUF_LEN);
-
 	va_start(ap, msg);
 
 	if ((level & ql2xextended_error_logging) == level) {
+		memset(pbuf, 0, QL_DBG_BUF_LEN);
+		
 		/* <module-name> <dev-name>:<msg-id> Message */
 		sprintf(pbuf, "%s [%s]-%04x: : ", QL_MSGHDR,
 		    dev_name(&(pdev->dev)), id + ql_dbg_offset);
@@ -1763,11 +1763,11 @@ ql_log(uint32_t level, scsi_qla_host_t *vha, int32_t id, char *msg, ...) {
 	uint32_t len;
 	struct pci_dev *pdev = NULL;
 
-	memset(pbuf, 0, QL_DBG_BUF_LEN);
-
 	va_start(ap, msg);
 
 	if (level <= ql_errlev) {
+		memset(pbuf, 0, QL_DBG_BUF_LEN);
+
 		if (vha != NULL) {
 			pdev = vha->hw->pdev;
 			/* <module-name> <msg-id>:<host> Message */
@@ -1823,11 +1823,11 @@ ql_log_pci(uint32_t level, struct pci_dev *pdev, int32_t id, char *msg, ...) {
 	if (pdev == NULL)
 		return;
 
-	memset(pbuf, 0, QL_DBG_BUF_LEN);
-
 	va_start(ap, msg);
 
 	if (level <= ql_errlev) {
+		memset(pbuf, 0, QL_DBG_BUF_LEN);
+
 		/* <module-name> <dev-name>:<msg-id> Message */
 		sprintf(pbuf, "%s [%s]-%04x: : ", QL_MSGHDR,
 		    dev_name(&(pdev->dev)), id);
-- 
1.7.2.5
