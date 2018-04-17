From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 3/6] scsi: devinfo: change blist_flag_t to 64bit
Date: Wed, 18 Apr 2018 01:35:08 +0200
Message-ID: <20180417233511.6573-4-mwilck@suse.com>
References: <20180417233511.6573-1-mwilck@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180417233511.6573-1-mwilck@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>, James Bottomley <jejb@linux.vnet.ibm.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Bart Van Assche <bart.vanassche@wdc.com>, Linus Torvalds <torvalds@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Janusz Dziemidowicz <rraptorr@nails.eu.org>, Jens Axboe <axboe@kernel.dk>, Alasdair G Kergon <agk@redhat.com>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Johannes Thumshirn <jthumshirn@suse.com>
List-Id: linux-scsi@vger.kernel.org

Space for SCSI blist flags is gradually running out. Change the
type to __u64. And fix a checkpatch complaint about symbolic
mode flags in scsi_devinfo.c.

Make checkpatch happy by replacing simple_strtoul() with kstrtoull().

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/scsi_devinfo.c | 18 +++++++++++-----
 drivers/scsi/scsi_sysfs.c   |  2 +-
 include/scsi/scsi_device.h  |  2 +-
 include/scsi/scsi_devinfo.h | 50 ++++++++++++++++++++++-----------------------
 4 files changed, 40 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index e5370d7..fc6b755 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -361,8 +361,16 @@ int scsi_dev_info_list_add_keyed(int compatible, char *vendor, char *model,
 	scsi_strcpy_devinfo("model", devinfo->model, sizeof(devinfo->model),
 			    model, compatible);
 
-	if (strflags)
-		flags = (__force blist_flags_t)simple_strtoul(strflags, NULL, 0);
+	if (strflags) {
+		unsigned long long val;
+		int ret = kstrtoull(strflags, 0, &val);
+
+		if (ret != 0) {
+			kfree(devinfo);
+			return ret;
+		}
+		flags = (__force blist_flags_t)val;
+	}
 	devinfo->flags = flags;
 	devinfo->compatible = compatible;
 
@@ -615,7 +623,7 @@ static int devinfo_seq_show(struct seq_file *m, void *v)
 	    devinfo_table->name)
 		seq_printf(m, "[%s]:\n", devinfo_table->name);
 
-	seq_printf(m, "'%.8s' '%.16s' 0x%x\n",
+	seq_printf(m, "'%.8s' '%.16s' 0x%llx\n",
 		   devinfo->vendor, devinfo->model, devinfo->flags);
 	return 0;
 }
@@ -734,9 +742,9 @@ MODULE_PARM_DESC(dev_flags,
 	 " list entries for vendor and model with an integer value of flags"
 	 " to the scsi device info list");
 
-module_param_named(default_dev_flags, scsi_default_dev_flags, int, S_IRUGO|S_IWUSR);
+module_param_named(default_dev_flags, scsi_default_dev_flags, ullong, 0644);
 MODULE_PARM_DESC(default_dev_flags,
-		 "scsi default device flag integer value");
+		 "scsi default device flag uint64_t value");
 
 /**
  * scsi_exit_devinfo - remove /proc/scsi/device_info & the scsi_dev_info_list
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index feacd7a..43c27ce 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -968,7 +968,7 @@ sdev_show_wwid(struct device *dev, struct device_attribute *attr,
 static DEVICE_ATTR(wwid, S_IRUGO, sdev_show_wwid, NULL);
 
 #define BLIST_FLAG_NAME(name)					\
-	[const_ilog2((__force unsigned int)BLIST_##name)] = #name
+	[const_ilog2((__force __u64)BLIST_##name)] = #name
 static const char *const sdev_bflags_name[] = {
 #include "scsi_devinfo_tbl.c"
 };
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 7ae177c..4c36af6 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -15,7 +15,7 @@ struct scsi_cmnd;
 struct scsi_lun;
 struct scsi_sense_hdr;
 
-typedef unsigned int __bitwise blist_flags_t;
+typedef __u64 __bitwise blist_flags_t;
 
 struct scsi_mode_data {
 	__u32	length;
diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
index ea67c32..e206d29 100644
--- a/include/scsi/scsi_devinfo.h
+++ b/include/scsi/scsi_devinfo.h
@@ -6,55 +6,55 @@
  */
 
 /* Only scan LUN 0 */
-#define BLIST_NOLUN		((__force blist_flags_t)(1 << 0))
+#define BLIST_NOLUN		((__force blist_flags_t)(1ULL << 0))
 /* Known to have LUNs, force scanning.
  * DEPRECATED: Use max_luns=N */
-#define BLIST_FORCELUN		((__force blist_flags_t)(1 << 1))
+#define BLIST_FORCELUN		((__force blist_flags_t)(1ULL << 1))
 /* Flag for broken handshaking */
-#define BLIST_BORKEN		((__force blist_flags_t)(1 << 2))
+#define BLIST_BORKEN		((__force blist_flags_t)(1ULL << 2))
 /* unlock by special command */
-#define BLIST_KEY		((__force blist_flags_t)(1 << 3))
+#define BLIST_KEY		((__force blist_flags_t)(1ULL << 3))
 /* Do not use LUNs in parallel */
-#define BLIST_SINGLELUN		((__force blist_flags_t)(1 << 4))
+#define BLIST_SINGLELUN		((__force blist_flags_t)(1ULL << 4))
 /* Buggy Tagged Command Queuing */
-#define BLIST_NOTQ		((__force blist_flags_t)(1 << 5))
+#define BLIST_NOTQ		((__force blist_flags_t)(1ULL << 5))
 /* Non consecutive LUN numbering */
-#define BLIST_SPARSELUN		((__force blist_flags_t)(1 << 6))
+#define BLIST_SPARSELUN		((__force blist_flags_t)(1ULL << 6))
 /* Avoid LUNS >= 5 */
-#define BLIST_MAX5LUN		((__force blist_flags_t)(1 << 7))
+#define BLIST_MAX5LUN		((__force blist_flags_t)(1ULL << 7))
 /* Treat as (removable) CD-ROM */
-#define BLIST_ISROM		((__force blist_flags_t)(1 << 8))
+#define BLIST_ISROM		((__force blist_flags_t)(1ULL << 8))
 /* LUNs past 7 on a SCSI-2 device */
-#define BLIST_LARGELUN		((__force blist_flags_t)(1 << 9))
+#define BLIST_LARGELUN		((__force blist_flags_t)(1ULL << 9))
 /* override additional length field */
-#define BLIST_INQUIRY_36	((__force blist_flags_t)(1 << 10))
+#define BLIST_INQUIRY_36	((__force blist_flags_t)(1ULL << 10))
 /* do not do automatic start on add */
-#define BLIST_NOSTARTONADD	((__force blist_flags_t)(1 << 12))
+#define BLIST_NOSTARTONADD	((__force blist_flags_t)(1ULL << 12))
 /* try REPORT_LUNS even for SCSI-2 devs (if HBA supports more than 8 LUNs) */
-#define BLIST_REPORTLUN2	((__force blist_flags_t)(1 << 17))
+#define BLIST_REPORTLUN2	((__force blist_flags_t)(1ULL << 17))
 /* don't try REPORT_LUNS scan (SCSI-3 devs) */
-#define BLIST_NOREPORTLUN	((__force blist_flags_t)(1 << 18))
+#define BLIST_NOREPORTLUN	((__force blist_flags_t)(1ULL << 18))
 /* don't use PREVENT-ALLOW commands */
-#define BLIST_NOT_LOCKABLE	((__force blist_flags_t)(1 << 19))
+#define BLIST_NOT_LOCKABLE	((__force blist_flags_t)(1ULL << 19))
 /* device is actually for RAID config */
-#define BLIST_NO_ULD_ATTACH	((__force blist_flags_t)(1 << 20))
+#define BLIST_NO_ULD_ATTACH	((__force blist_flags_t)(1ULL << 20))
 /* select without ATN */
-#define BLIST_SELECT_NO_ATN	((__force blist_flags_t)(1 << 21))
+#define BLIST_SELECT_NO_ATN	((__force blist_flags_t)(1ULL << 21))
 /* retry HARDWARE_ERROR */
-#define BLIST_RETRY_HWERROR	((__force blist_flags_t)(1 << 22))
+#define BLIST_RETRY_HWERROR	((__force blist_flags_t)(1ULL << 22))
 /* maximum 512 sector cdb length */
-#define BLIST_MAX_512		((__force blist_flags_t)(1 << 23))
+#define BLIST_MAX_512		((__force blist_flags_t)(1ULL << 23))
 /* Disable T10 PI (DIF) */
-#define BLIST_NO_DIF		((__force blist_flags_t)(1 << 25))
+#define BLIST_NO_DIF		((__force blist_flags_t)(1ULL << 25))
 /* Ignore SBC-3 VPD pages */
-#define BLIST_SKIP_VPD_PAGES	((__force blist_flags_t)(1 << 26))
+#define BLIST_SKIP_VPD_PAGES	((__force blist_flags_t)(1ULL << 26))
 /* Attempt to read VPD pages */
-#define BLIST_TRY_VPD_PAGES	((__force blist_flags_t)(1 << 28))
+#define BLIST_TRY_VPD_PAGES	((__force blist_flags_t)(1ULL << 28))
 /* don't try to issue RSOC */
-#define BLIST_NO_RSOC		((__force blist_flags_t)(1 << 29))
+#define BLIST_NO_RSOC		((__force blist_flags_t)(1ULL << 29))
 /* maximum 1024 sector cdb length */
-#define BLIST_MAX_1024		((__force blist_flags_t)(1 << 30))
+#define BLIST_MAX_1024		((__force blist_flags_t)(1ULL << 30))
 /* Use UNMAP limit for WRITE SAME */
-#define BLIST_UNMAP_LIMIT_WS	((__force blist_flags_t)(1 << 31))
+#define BLIST_UNMAP_LIMIT_WS	((__force blist_flags_t)(1ULL << 31))
 
 #endif
-- 
2.16.1
