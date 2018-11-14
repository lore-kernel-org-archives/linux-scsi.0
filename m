From: John Garry <john.garry@huawei.com>
Subject: [PATCH 2/5] scsi: libsas: Use pr_fmt(fmt)
Date: Wed, 14 Nov 2018 21:47:46 +0800
Message-ID: <1542203269-174932-3-git-send-email-john.garry@huawei.com>
References: <1542203269-174932-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1542203269-174932-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: hare@suse.com, yanaijie@huawei.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, joe@perches.com, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

In preparation for dropping the libsas printk wrappers, use pr_fmt(fmt)
declaration to add the framework log prefix - "sas".

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/libsas/sas_internal.h | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 50e12d6..30f4154 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -32,9 +32,16 @@
 #include <scsi/libsas.h>
 #include <scsi/sas_ata.h>
 
-#define sas_printk(fmt, ...) printk(KERN_NOTICE "sas: " fmt, ## __VA_ARGS__)
+#ifdef pr_fmt
+#undef pr_fmt
+#endif
+
+#define pr_fmt(fmt) "sas: " fmt
+
+#define sas_printk(fmt, ...) printk(KERN_NOTICE fmt, ## __VA_ARGS__)
+
+#define SAS_DPRINTK(fmt, ...) printk(KERN_DEBUG fmt, ## __VA_ARGS__)
 
-#define SAS_DPRINTK(fmt, ...) printk(KERN_DEBUG "sas: " fmt, ## __VA_ARGS__)
 
 #define TO_SAS_TASK(_scsi_cmd)  ((void *)(_scsi_cmd)->host_scribble)
 #define ASSIGN_SAS_TASK(_sc, _t) do { (_sc)->host_scribble = (void *) _t; } while (0)
-- 
1.9.1
