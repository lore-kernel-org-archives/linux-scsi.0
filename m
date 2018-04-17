From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 2/6] scsi: use const_ilog2 for array indices
Date: Wed, 18 Apr 2018 01:35:07 +0200
Message-ID: <20180417233511.6573-3-mwilck@suse.com>
References: <20180417233511.6573-1-mwilck@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180417233511.6573-1-mwilck@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>, James Bottomley <jejb@linux.vnet.ibm.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Bart Van Assche <bart.vanassche@wdc.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.com>, Jens Axboe <axboe@fb.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Omar Sandoval <osandov@fb.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Ming Lei <ming.lei@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Use the just introduced const_ilog2() macro to avoid sparse
errors.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/scsi_debugfs.c | 2 +-
 drivers/scsi/scsi_sysfs.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_debugfs.c b/drivers/scsi/scsi_debugfs.c
index b784002..c5a8756 100644
--- a/drivers/scsi/scsi_debugfs.c
+++ b/drivers/scsi/scsi_debugfs.c
@@ -4,7 +4,7 @@
 #include <scsi/scsi_dbg.h>
 #include "scsi_debugfs.h"
 
-#define SCSI_CMD_FLAG_NAME(name) [ilog2(SCMD_##name)] = #name
+#define SCSI_CMD_FLAG_NAME(name)[const_ilog2(SCMD_##name)] = #name
 static const char *const scsi_cmd_flags[] = {
 	SCSI_CMD_FLAG_NAME(TAGGED),
 	SCSI_CMD_FLAG_NAME(UNCHECKED_ISA_DMA),
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index e56a4ac..feacd7a 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -968,7 +968,7 @@ sdev_show_wwid(struct device *dev, struct device_attribute *attr,
 static DEVICE_ATTR(wwid, S_IRUGO, sdev_show_wwid, NULL);
 
 #define BLIST_FLAG_NAME(name)					\
-	[ilog2((__force unsigned int)BLIST_##name)] = #name
+	[const_ilog2((__force unsigned int)BLIST_##name)] = #name
 static const char *const sdev_bflags_name[] = {
 #include "scsi_devinfo_tbl.c"
 };
-- 
2.16.1
