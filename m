From: tom.ty89@gmail.com
Subject: [PATCH] libata-scsi: fix read-only bits checking in ata_mselect_*()
Date: Wed, 20 Jul 2016 06:50:14 +0800
Message-ID: <578eaead.0198620a.7cf53.28c1@mx.google.com>
References: <578e979d.d40c620a.f5800.0924@mx.google.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <578e979d.d40c620a.f5800.0924@mx.google.com>
Sender: linux-ide-owner@vger.kernel.org
To: tj@kernel.org, hare@suse.de
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Tom Yan <tom.ty89@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: Tom Yan <tom.ty89@gmail.com>

Commit 7780081c1f04 ("libata-scsi: Set information sense field for
invalid parameter") changed how ata_mselect_*() make sure read-only
bits are not modified. The new implementation introduced a bug that
the read-only bits in the byte that has a changeable bit will not
be checked.

Added the necessary check, with comments explaining the heuristic.

Signed-off-by: Tom Yan <tom.ty89@gmail.com>

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 06afe63..005d186 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3617,8 +3617,18 @@ static int ata_mselect_caching(struct ata_queued_cmd *qc,
 	 */
 	ata_msense_caching(dev->id, mpage, false);
 	for (i = 0; i < CACHE_MPAGE_LEN - 2; i++) {
-		if (i == 0)
-			continue;
+		/* Check the first byte */
+		if (i == 0) {
+			/* except the WCE bit */
+			if (mpage[i + 2] & 0xfb != buf[i] & 0xfb) {
+				continue;
+			} else {
+				*fp = i;
+				return -EINVAL;
+			}
+		}
+
+		/* Check the remaining bytes */
 		if (mpage[i + 2] != buf[i]) {
 			*fp = i;
 			return -EINVAL;
@@ -3672,8 +3682,18 @@ static int ata_mselect_control(struct ata_queued_cmd *qc,
 	 */
 	ata_msense_control(dev, mpage, false);
 	for (i = 0; i < CONTROL_MPAGE_LEN - 2; i++) {
-		if (i == 0)
-			continue;
+		/* Check the first byte */
+		if (i == 0) {
+			/* except the D_SENSE bit */
+			if (mpage[i + 2] & 0xfb != buf[i] & 0xfb) {
+				continue;
+			} else {
+				*fp = i;
+				return -EINVAL;
+			}
+		}
+
+		/* Check the remaining bytes */
 		if (mpage[2 + i] != buf[i]) {
 			*fp = i;
 			return -EINVAL;
-- 
2.9.0

