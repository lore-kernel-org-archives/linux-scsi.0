From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: [PATCH] qla2xxx: fix panic caused by previous patch
Date: Mon, 30 Jul 2007 11:01:07 -0700
Message-ID: <46AE2763.2040608@qlogic.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070601020109090005060107"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:50150 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966229AbXG3SCM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jul 2007 14:02:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------070601020109090005060107
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

As a fix to the issue initiated by the email thread 'qla2xyz broken in current Linus tree',
Following patch should fix the problem.

Thank you,
Seokmann
---
>From d0355c3c61a12ce466c87d8ef953425d2b21725b Mon Sep 17 00:00:00 2001
From: Seokmann Ju <seokmann.ju@qlogic.com>
Date: Mon, 30 Jul 2007 13:12:17 -0400
Subject: [PATCH] qla2xxx: fix panic caused by previous patch

- this patch will fix a panic caused by omitted memory allocation for the nvram.


Signed-off-by: Seokmann Ju <seokmann.ju@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 8bdc5a2..33d5d80 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2154,6 +2154,19 @@ qla2x00_mem_alloc(scsi_qla_host_t *ha)
 			}
 		}
 
+		/* Get memory for cached NVRAM */
+		ha->nvram = kzalloc(MAX_NVRAM_SIZE, GFP_KERNEL);
+		if (ha->nvram == NULL) {
+			/* error */
+			qla_printk(KERN_WARNING, ha,
+			    "Memory Allocation failed - nvram cache\n");
+
+			qla2x00_mem_free(ha);
+			msleep(100);
+
+			continue;
+		}
+
 		/* Done all allocations without any error. */
 		status = 0;
 
@@ -2266,6 +2279,7 @@ qla2x00_mem_free(scsi_qla_host_t *ha)
 	ha->fw_dump_reading = 0;
 
 	vfree(ha->optrom_buffer);
+	kfree(ha->nvram);
 }
 
 /*
-- 
1.5.2

--------------070601020109090005060107
Content-Type: text/plain;
 name="0002-qla2xxx-fix-panic-caused-by-previous-patch.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0002-qla2xxx-fix-panic-caused-by-previous-patch.patch"

>From d0355c3c61a12ce466c87d8ef953425d2b21725b Mon Sep 17 00:00:00 2001
From: Seokmann Ju <seokmann.ju@qlogic.com>
Date: Mon, 30 Jul 2007 13:12:17 -0400
Subject: [PATCH] qla2xxx: fix panic caused by previous patch

- this patch will fix a panic caused by omitted memory allocation for the nvram.


Signed-off-by: Seokmann Ju <seokmann.ju@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 8bdc5a2..33d5d80 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2154,6 +2154,19 @@ qla2x00_mem_alloc(scsi_qla_host_t *ha)
 			}
 		}
 
+		/* Get memory for cached NVRAM */
+		ha->nvram = kzalloc(MAX_NVRAM_SIZE, GFP_KERNEL);
+		if (ha->nvram == NULL) {
+			/* error */
+			qla_printk(KERN_WARNING, ha,
+			    "Memory Allocation failed - nvram cache\n");
+
+			qla2x00_mem_free(ha);
+			msleep(100);
+
+			continue;
+		}
+
 		/* Done all allocations without any error. */
 		status = 0;
 
@@ -2266,6 +2279,7 @@ qla2x00_mem_free(scsi_qla_host_t *ha)
 	ha->fw_dump_reading = 0;
 
 	vfree(ha->optrom_buffer);
+	kfree(ha->nvram);
 }
 
 /*
-- 
1.5.2


--------------070601020109090005060107--
