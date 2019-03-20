From: Colin King <colin.king@canonical.com>
Subject: [PATCH][next] scsi: target: fix unsigned comparision with less than zero
Date: Wed, 20 Mar 2019 16:37:09 +0000
Message-ID: <20190320163709.28767-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently an error return is being assigned to an unsigned
size_t varianle and then checked if the result is less than
zero which will always be false.  Fix this by making ret
ssize_t rather than a size_t.

Fixes: 0322913cab79 ("scsi: target: Add device product id and revision configfs attributes")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/target/target_core_configfs.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 8f3faef235b5..3fe79875b3ac 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1267,7 +1267,8 @@ static ssize_t target_wwn_vendor_id_store(struct config_item *item,
 	/* +2 to allow for a trailing (stripped) '\n' and null-terminator */
 	unsigned char buf[INQUIRY_VENDOR_LEN + 2];
 	char *stripped = NULL;
-	size_t len, ret;
+	size_t len;
+	ssize_t ret;
 
 	len = strlcpy(buf, page, sizeof(buf));
 	if (len < sizeof(buf)) {
@@ -1322,7 +1323,8 @@ static ssize_t target_wwn_product_id_store(struct config_item *item,
 	/* +2 to allow for a trailing (stripped) '\n' and null-terminator */
 	unsigned char buf[INQUIRY_MODEL_LEN + 2];
 	char *stripped = NULL;
-	size_t len, ret;
+	size_t len;
+	ssize_t ret;
 
 	len = strlcpy(buf, page, sizeof(buf));
 	if (len < sizeof(buf)) {
@@ -1377,7 +1379,8 @@ static ssize_t target_wwn_revision_store(struct config_item *item,
 	/* +2 to allow for a trailing (stripped) '\n' and null-terminator */
 	unsigned char buf[INQUIRY_REVISION_LEN + 2];
 	char *stripped = NULL;
-	size_t len, ret;
+	size_t len;
+	ssize_t ret;
 
 	len = strlcpy(buf, page, sizeof(buf));
 	if (len < sizeof(buf)) {
-- 
2.20.1
