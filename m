From: John Garry <john.garry@huawei.com>
Subject: [PATCH v2 2/5] scsi: libsas: Use pr_fmt(fmt)
Date: Thu, 15 Nov 2018 18:20:29 +0800
Message-ID: <1542277232-135789-3-git-send-email-john.garry@huawei.com>
References: <1542277232-135789-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1542277232-135789-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: hare@suse.com, yanaijie@huawei.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, joe@perches.com, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

In preparation for dropping the libsas printk wrappers, use pr_fmt(fmt)
declaration to add the framework log prefix - "sas".

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/libsas/sas_ata.c      |  2 +-
 drivers/scsi/libsas/sas_internal.h | 13 +++++++++++--
 drivers/scsi/libsas/sas_task.c     |  3 +++
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 4f6cdf5..9f3521f 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -375,7 +375,7 @@ static int sas_ata_printk(const char *level, const struct domain_device *ddev,
 	vaf.fmt = fmt;
 	vaf.va = &args;
 
-	r = printk("%ssas: ata%u: %s: %pV",
+	r = printk("%s" SAS_FMT "ata%u: %s: %pV",
 		   level, ap->print_id, dev_name(dev), &vaf);
 
 	va_end(args);
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 50e12d6..94ebf41 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -32,9 +32,18 @@
 #include <scsi/libsas.h>
 #include <scsi/sas_ata.h>
 
-#define sas_printk(fmt, ...) printk(KERN_NOTICE "sas: " fmt, ## __VA_ARGS__)
+#ifdef pr_fmt
+#undef pr_fmt
+#endif
+
+#define SAS_FMT "sas: "
+
+#define pr_fmt(fmt) SAS_FMT fmt
+
+#define sas_printk(fmt, ...) printk(KERN_NOTICE fmt, ## __VA_ARGS__)
+
+#define SAS_DPRINTK(fmt, ...) printk(KERN_DEBUG fmt, ## __VA_ARGS__)
 
-#define SAS_DPRINTK(fmt, ...) printk(KERN_DEBUG "sas: " fmt, ## __VA_ARGS__)
 
 #define TO_SAS_TASK(_scsi_cmd)  ((void *)(_scsi_cmd)->host_scribble)
 #define ASSIGN_SAS_TASK(_sc, _t) do { (_sc)->host_scribble = (void *) _t; } while (0)
diff --git a/drivers/scsi/libsas/sas_task.c b/drivers/scsi/libsas/sas_task.c
index a78e5bd..d305c8f 100644
--- a/drivers/scsi/libsas/sas_task.c
+++ b/drivers/scsi/libsas/sas_task.c
@@ -1,3 +1,6 @@
+
+#include "sas_internal.h"
+
 #include <linux/kernel.h>
 #include <linux/export.h>
 #include <scsi/sas.h>
-- 
1.9.1
