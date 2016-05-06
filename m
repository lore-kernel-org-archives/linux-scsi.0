From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH v3 5/6] scsi_debug: uuid for lu name
Date: Fri,  6 May 2016 00:40:28 -0400
Message-ID: <1462509629-24282-6-git-send-email-dgilbert@interlog.com>
References: <1462509629-24282-1-git-send-email-dgilbert@interlog.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:55638 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343AbcEFEkr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 May 2016 00:40:47 -0400
In-Reply-To: <1462509629-24282-1-git-send-email-dgilbert@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, tomas.winkler@intel.com, emilne@redhat.com, bart.vanassche@sandisk.com

Permit changing of a LU name from a (fake) IEEE registered NAA (5)
to a locally assigned UUID. Using a UUID (RFC 4122) for a SCSI
designation descriptor (e.g. a LU name) was added in spc5r08.pdf
(a draft INCITS standard) on 25 January 2016. Add parameter
uuid_ctl to use a separate UUID for each LU (storage device) name.
Additional option for all LU names to have the same UUID (since
their storage is shared). Previous action of using NAA identifier
for LU name remains the default.

Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 61 +++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 51 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index afbbfaa..efb4549 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -41,6 +41,7 @@
 #include <linux/interrupt.h>
 #include <linux/atomic.h>
 #include <linux/hrtimer.h>
+#include <linux/uuid.h>
 
 #include <net/checksum.h>
 
@@ -137,6 +138,7 @@ static const char *sdebug_version_date = "20160430";
 #define DEF_STRICT 0
 #define DEF_STATISTICS false
 #define DEF_SUBMIT_QUEUES 1
+#define DEF_UUID_CTL 0
 #define JDELAY_OVERRIDDEN -9999
 
 #define SDEBUG_LUN_0_VAL 0
@@ -241,6 +243,7 @@ struct sdebug_dev_info {
 	unsigned int channel;
 	unsigned int target;
 	u64 lun;
+	uuid_be lu_name;
 	struct sdebug_host_info *sdbg_host;
 	unsigned long uas_bm[1];
 	atomic_t num_in_q;
@@ -600,6 +603,7 @@ static unsigned int sdebug_unmap_granularity = DEF_UNMAP_GRANULARITY;
 static unsigned int sdebug_unmap_max_blocks = DEF_UNMAP_MAX_BLOCKS;
 static unsigned int sdebug_unmap_max_desc = DEF_UNMAP_MAX_DESC;
 static unsigned int sdebug_write_same_length = DEF_WRITESAME_LENGTH;
+static int sdebug_uuid_ctl = DEF_UUID_CTL;
 static bool sdebug_removable = DEF_REMOVABLE;
 static bool sdebug_clustering;
 static bool sdebug_host_lock = DEF_HOST_LOCK;
@@ -928,8 +932,8 @@ static const u64 naa5_comp_c = 0x5111111000000000ULL;
 /* Device identification VPD page. Returns number of bytes placed in arr */
 static int inquiry_vpd_83(unsigned char *arr, int port_group_id,
 			  int target_dev_id, int dev_id_num,
-			  const char *dev_id_str,
-			  int dev_id_str_len)
+			  const char *dev_id_str, int dev_id_str_len,
+			  const uuid_be *lu_name)
 {
 	int num, port_a;
 	char b[32];
@@ -946,13 +950,25 @@ static int inquiry_vpd_83(unsigned char *arr, int port_group_id,
 	arr[3] = num;
 	num += 4;
 	if (dev_id_num >= 0) {
-		/* NAA-5, Logical unit identifier (binary) */
-		arr[num++] = 0x1;	/* binary (not necessarily sas) */
-		arr[num++] = 0x3;	/* PIV=0, lu, naa */
-		arr[num++] = 0x0;
-		arr[num++] = 0x8;
-		put_unaligned_be64(naa5_comp_b + dev_id_num, arr + num);
-		num += 8;
+		if (sdebug_uuid_ctl) {
+			/* Locally assigned UUID */
+			arr[num++] = 0x1;  /* binary (not necessarily sas) */
+			arr[num++] = 0xa;  /* PIV=0, lu, naa */
+			arr[num++] = 0x0;
+			arr[num++] = 0x12;
+			arr[num++] = 0x10; /* uuid type=1, locally assigned */
+			arr[num++] = 0x0;
+			memcpy(arr + num, lu_name, 16);
+			num += 16;
+		} else {
+			/* NAA-5, Logical unit identifier (binary) */
+			arr[num++] = 0x1;  /* binary (not necessarily sas) */
+			arr[num++] = 0x3;  /* PIV=0, lu, naa */
+			arr[num++] = 0x0;
+			arr[num++] = 0x8;
+			put_unaligned_be64(naa5_comp_b + dev_id_num, arr + num);
+			num += 8;
+		}
 		/* Target relative port number */
 		arr[num++] = 0x61;	/* proto=sas, binary */
 		arr[num++] = 0x94;	/* PIV=1, target port, rel port */
@@ -1293,7 +1309,8 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 			arr[1] = cmd[2];	/*sanity */
 			arr[3] = inquiry_vpd_83(&arr[4], port_group_id,
 						target_dev_id, lu_id_num,
-						lu_id_str, len);
+						lu_id_str, len,
+						&devip->lu_name);
 		} else if (0x84 == cmd[2]) { /* Software interface ident. */
 			arr[1] = cmd[2];	/*sanity */
 			arr[3] = inquiry_vpd_84(&arr[4]);
@@ -3503,6 +3520,9 @@ static void sdebug_q_cmd_wq_complete(struct work_struct *work)
 	sdebug_q_cmd_complete(sd_dp);
 }
 
+static bool got_shared_uuid;
+static uuid_be shared_uuid;
+
 static struct sdebug_dev_info *sdebug_device_create(
 			struct sdebug_host_info *sdbg_host, gfp_t flags)
 {
@@ -3510,6 +3530,17 @@ static struct sdebug_dev_info *sdebug_device_create(
 
 	devip = kzalloc(sizeof(*devip), flags);
 	if (devip) {
+		if (sdebug_uuid_ctl == 1)
+			uuid_be_gen(&devip->lu_name);
+		else if (sdebug_uuid_ctl == 2) {
+			if (got_shared_uuid)
+				devip->lu_name = shared_uuid;
+			else {
+				uuid_be_gen(&shared_uuid);
+				got_shared_uuid = true;
+				devip->lu_name = shared_uuid;
+			}
+		}
 		devip->sdbg_host = sdbg_host;
 		list_add_tail(&devip->dev_list, &sdbg_host->dev_info_list);
 	}
@@ -4101,6 +4132,7 @@ module_param_named(unmap_granularity, sdebug_unmap_granularity, int, S_IRUGO);
 module_param_named(unmap_max_blocks, sdebug_unmap_max_blocks, int, S_IRUGO);
 module_param_named(unmap_max_desc, sdebug_unmap_max_desc, int, S_IRUGO);
 module_param_named(virtual_gb, sdebug_virtual_gb, int, S_IRUGO | S_IWUSR);
+module_param_named(uuid_ctl, sdebug_uuid_ctl, int, S_IRUGO);
 module_param_named(vpd_use_hostno, sdebug_vpd_use_hostno, int,
 		   S_IRUGO | S_IWUSR);
 module_param_named(write_same_length, sdebug_write_same_length, int,
@@ -4150,6 +4182,8 @@ MODULE_PARM_DESC(unmap_alignment, "lowest aligned thin provisioning lba (def=0)"
 MODULE_PARM_DESC(unmap_granularity, "thin provisioning granularity in blocks (def=1)");
 MODULE_PARM_DESC(unmap_max_blocks, "max # of blocks can be unmapped in one cmd (def=0xffffffff)");
 MODULE_PARM_DESC(unmap_max_desc, "max # of ranges that can be unmapped in one cmd (def=256)");
+MODULE_PARM_DESC(uuid_ctl,
+		 "1->use uuid for lu name, 0->don't, 2->all use same (def=0)");
 MODULE_PARM_DESC(virtual_gb, "virtual gigabyte (GiB) size (def=0 -> use dev_size_mb)");
 MODULE_PARM_DESC(vpd_use_hostno, "0 -> dev ids ignore hostno (def=1 -> unique dev ids)");
 MODULE_PARM_DESC(write_same_length, "Maximum blocks per WRITE SAME cmd (def=0xffff)");
@@ -4787,6 +4821,12 @@ static ssize_t strict_store(struct device_driver *ddp, const char *buf,
 }
 static DRIVER_ATTR_RW(strict);
 
+static ssize_t uuid_ctl_show(struct device_driver *ddp, char *buf)
+{
+	return scnprintf(buf, PAGE_SIZE, "%d\n", !!sdebug_uuid_ctl);
+}
+static DRIVER_ATTR_RO(uuid_ctl);
+
 
 /* Note: The following array creates attribute files in the
    /sys/bus/pseudo/drivers/scsi_debug directory. The advantage of these
@@ -4825,6 +4865,7 @@ static struct attribute *sdebug_drv_attrs[] = {
 	&driver_attr_host_lock.attr,
 	&driver_attr_ndelay.attr,
 	&driver_attr_strict.attr,
+	&driver_attr_uuid_ctl.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(sdebug_drv);
-- 
2.7.4

