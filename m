From: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] scsi: esas2r: make bin_attr_default_nvram const
Date: Sat, 30 Sep 2017 22:27:35 +0530
Message-ID: <1506790655-13287-1-git-send-email-bhumirks@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: julia.lawall@lip6.fr, linuxdrivers@attotech.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Make this const as it is only passed to the const arguments of the
functions sysfs_remove_bin_file and sysfs_create_bin_file. Make the
declaration const too.

Structure found using Coccinelle and changes done by hand.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/scsi/esas2r/esas2r.h      | 2 +-
 drivers/scsi/esas2r/esas2r_main.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r.h b/drivers/scsi/esas2r/esas2r.h
index 1da6407..f9acf54 100644
--- a/drivers/scsi/esas2r/esas2r.h
+++ b/drivers/scsi/esas2r/esas2r.h
@@ -1421,6 +1421,6 @@ static inline void esas2r_comp_list_drain(struct esas2r_adapter *a,
 extern struct bin_attribute bin_attr_vda;
 extern struct bin_attribute bin_attr_hw;
 extern struct bin_attribute bin_attr_live_nvram;
-extern struct bin_attribute bin_attr_default_nvram;
+extern const struct bin_attribute bin_attr_default_nvram;
 
 #endif /* ESAS2R_H */
diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index 81f226b..9291768 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -224,7 +224,7 @@ static ssize_t write_hw(struct file *file, struct kobject *kobj,
 ESAS2R_RW_BIN_ATTR(hw);
 ESAS2R_RW_BIN_ATTR(live_nvram);
 
-struct bin_attribute bin_attr_default_nvram = {
+const struct bin_attribute bin_attr_default_nvram = {
 	.attr	= { .name = "default_nvram", .mode = S_IRUGO },
 	.size	= 0,
 	.read	= read_default_nvram,
-- 
1.9.1
