From: Colin King <colin.king@canonical.com>
Subject: [PATCH][V2] scsi: qedf: remove memset/memcpy to nfunc and use func instead
Date: Fri, 12 Apr 2019 10:48:29 +0100
Message-ID: <20190412094829.15868-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: QLogic-Storage-Upstream@cavium.com, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently the qedf_dbg_* family of functions can overrun the end
of the source string if it is less than the destination buffer
length because of the use of a fixed sized memcpy. Remove the
memset/memcpy calls to nfunc and just use func instead as it
is always a null terminated string.

Addresses-Coverity: ("Out-of-bounds access")
Fixes: 61d8658b4a43 ("scsi: qedf: Add QLogic FastLinQ offload FCoE driver framework.")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---

V2: replace the V1 strscpy with just using func since this is always
    going to be a NUL terminated string. Thanks to Rasmus Villemoes for
    noticing that.

---
 drivers/scsi/qedf/qedf_dbg.c | 32 ++++++++------------------------
 1 file changed, 8 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_dbg.c b/drivers/scsi/qedf/qedf_dbg.c
index f2397ee9ba69..f7d170bffc82 100644
--- a/drivers/scsi/qedf/qedf_dbg.c
+++ b/drivers/scsi/qedf/qedf_dbg.c
@@ -15,10 +15,6 @@ qedf_dbg_err(struct qedf_dbg_ctx *qedf, const char *func, u32 line,
 {
 	va_list va;
 	struct va_format vaf;
-	char nfunc[32];
-
-	memset(nfunc, 0, sizeof(nfunc));
-	memcpy(nfunc, func, sizeof(nfunc) - 1);
 
 	va_start(va, fmt);
 
@@ -27,9 +23,9 @@ qedf_dbg_err(struct qedf_dbg_ctx *qedf, const char *func, u32 line,
 
 	if (likely(qedf) && likely(qedf->pdev))
 		pr_err("[%s]:[%s:%d]:%d: %pV", dev_name(&(qedf->pdev->dev)),
-			nfunc, line, qedf->host_no, &vaf);
+			func, line, qedf->host_no, &vaf);
 	else
-		pr_err("[0000:00:00.0]:[%s:%d]: %pV", nfunc, line, &vaf);
+		pr_err("[0000:00:00.0]:[%s:%d]: %pV", func, line, &vaf);
 
 	va_end(va);
 }
@@ -40,10 +36,6 @@ qedf_dbg_warn(struct qedf_dbg_ctx *qedf, const char *func, u32 line,
 {
 	va_list va;
 	struct va_format vaf;
-	char nfunc[32];
-
-	memset(nfunc, 0, sizeof(nfunc));
-	memcpy(nfunc, func, sizeof(nfunc) - 1);
 
 	va_start(va, fmt);
 
@@ -55,9 +47,9 @@ qedf_dbg_warn(struct qedf_dbg_ctx *qedf, const char *func, u32 line,
 
 	if (likely(qedf) && likely(qedf->pdev))
 		pr_warn("[%s]:[%s:%d]:%d: %pV", dev_name(&(qedf->pdev->dev)),
-			nfunc, line, qedf->host_no, &vaf);
+			func, line, qedf->host_no, &vaf);
 	else
-		pr_warn("[0000:00:00.0]:[%s:%d]: %pV", nfunc, line, &vaf);
+		pr_warn("[0000:00:00.0]:[%s:%d]: %pV", func, line, &vaf);
 
 ret:
 	va_end(va);
@@ -69,10 +61,6 @@ qedf_dbg_notice(struct qedf_dbg_ctx *qedf, const char *func, u32 line,
 {
 	va_list va;
 	struct va_format vaf;
-	char nfunc[32];
-
-	memset(nfunc, 0, sizeof(nfunc));
-	memcpy(nfunc, func, sizeof(nfunc) - 1);
 
 	va_start(va, fmt);
 
@@ -84,10 +72,10 @@ qedf_dbg_notice(struct qedf_dbg_ctx *qedf, const char *func, u32 line,
 
 	if (likely(qedf) && likely(qedf->pdev))
 		pr_notice("[%s]:[%s:%d]:%d: %pV",
-			  dev_name(&(qedf->pdev->dev)), nfunc, line,
+			  dev_name(&(qedf->pdev->dev)), func, line,
 			  qedf->host_no, &vaf);
 	else
-		pr_notice("[0000:00:00.0]:[%s:%d]: %pV", nfunc, line, &vaf);
+		pr_notice("[0000:00:00.0]:[%s:%d]: %pV", func, line, &vaf);
 
 ret:
 	va_end(va);
@@ -99,10 +87,6 @@ qedf_dbg_info(struct qedf_dbg_ctx *qedf, const char *func, u32 line,
 {
 	va_list va;
 	struct va_format vaf;
-	char nfunc[32];
-
-	memset(nfunc, 0, sizeof(nfunc));
-	memcpy(nfunc, func, sizeof(nfunc) - 1);
 
 	va_start(va, fmt);
 
@@ -114,9 +98,9 @@ qedf_dbg_info(struct qedf_dbg_ctx *qedf, const char *func, u32 line,
 
 	if (likely(qedf) && likely(qedf->pdev))
 		pr_info("[%s]:[%s:%d]:%d: %pV", dev_name(&(qedf->pdev->dev)),
-			nfunc, line, qedf->host_no, &vaf);
+			func, line, qedf->host_no, &vaf);
 	else
-		pr_info("[0000:00:00.0]:[%s:%d]: %pV", nfunc, line, &vaf);
+		pr_info("[0000:00:00.0]:[%s:%d]: %pV", func, line, &vaf);
 
 ret:
 	va_end(va);
-- 
2.20.1
