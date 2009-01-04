From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi_debug DIF/DIX support
Date: Sun, 04 Jan 2009 03:08:19 -0500
Message-ID: <yq1y6xr4hos.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet14.oracle.com ([148.87.113.126]:53567 "EHLO
	rgminet14.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbZADIJl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Jan 2009 03:09:41 -0500
Received: from rgminet13.oracle.com (rcsinet13.oracle.com [148.87.113.125])
	by rgminet14.oracle.com (Switch-3.3.1/Switch-3.3.1) with ESMTP id n048BiwR001217
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Sun, 4 Jan 2009 08:11:45 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@hansenpartnership.com, Douglas Gilbert <dougg@torque.net>, linux-scsi@vger.kernel.org


This patch adds support for DIX and DIF in scsi_debug.  A separate
buffer is allocated for the protection information.

 - The dix parameter indicates whether the controller supports DIX
   (protection information DMA)

 - The dif parameter indicates whether the simulated storage device
   supports DIF

 - The guard parameter switches between T10 CRC(0) and IP checksum(1)

 - The ato parameter indicates whether the application tag is owned by
   the disk(0) or the OS(1)

 - DIF and DIX errors can be triggered using the scsi_debug_opts mask

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -40,6 +40,9 @@
 #include <linux/moduleparam.h>
 #include <linux/scatterlist.h>
 #include <linux/blkdev.h>
+#include <linux/crc-t10dif.h>
+
+#include <net/checksum.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -48,8 +51,7 @@
 #include <scsi/scsicam.h>
 #include <scsi/scsi_eh.h>
 
-#include <linux/stat.h>
-
+#include "sd.h"
 #include "scsi_logging.h"
 
 #define SCSI_DEBUG_VERSION "1.81"
@@ -95,6 +97,10 @@ static const char * scsi_debug_version_d
 #define DEF_FAKE_RW	0
 #define DEF_VPD_USE_HOSTNO 1
 #define DEF_SECTOR_SIZE 512
+#define DEF_DIX 0
+#define DEF_DIF 0
+#define DEF_GUARD 0
+#define DEF_ATO 1
 
 /* bit mask values for scsi_debug_opts */
 #define SCSI_DEBUG_OPT_NOISE   1
@@ -102,6 +108,8 @@ static const char * scsi_debug_version_d
 #define SCSI_DEBUG_OPT_TIMEOUT   4
 #define SCSI_DEBUG_OPT_RECOVERED_ERR   8
 #define SCSI_DEBUG_OPT_TRANSPORT_ERR   16
+#define SCSI_DEBUG_OPT_DIF_ERR   32
+#define SCSI_DEBUG_OPT_DIX_ERR   64
 /* When "every_nth" > 0 then modulo "every_nth" commands:
  *   - a no response is simulated if SCSI_DEBUG_OPT_TIMEOUT is set
  *   - a RECOVERED_ERROR is simulated on successful read and write
@@ -144,6 +152,10 @@ static int scsi_debug_fake_rw = DEF_FAKE
 static int scsi_debug_fake_rw = DEF_FAKE_RW;
 static int scsi_debug_vpd_use_hostno = DEF_VPD_USE_HOSTNO;
 static int scsi_debug_sector_size = DEF_SECTOR_SIZE;
+static int scsi_debug_dix = DEF_DIX;
+static int scsi_debug_dif = DEF_DIF;
+static int scsi_debug_guard = DEF_GUARD;
+static int scsi_debug_ato = DEF_ATO;
 
 static int scsi_debug_cmnd_count = 0;
 
@@ -204,11 +216,15 @@ static struct sdebug_queued_cmd queued_a
 static struct sdebug_queued_cmd queued_arr[SCSI_DEBUG_CANQUEUE];
 
 static unsigned char * fake_storep;	/* ramdisk storage */
+static unsigned char *dif_storep;	/* protection info */
 
 static int num_aborts = 0;
 static int num_dev_resets = 0;
 static int num_bus_resets = 0;
 static int num_host_resets = 0;
+static int dix_writes;
+static int dix_reads;
+static int dif_errors;
 
 static DEFINE_SPINLOCK(queued_arr_lock);
 static DEFINE_RWLOCK(atomic_rw);
@@ -217,6 +233,11 @@ static char sdebug_proc_name[] = "scsi_d
 
 static struct bus_type pseudo_lld_bus;
 
+static inline sector_t dif_offset(sector_t sector)
+{
+	return sector << 3;
+}
+
 static struct device_driver sdebug_driverfs_driver = {
 	.name 		= sdebug_proc_name,
 	.bus		= &pseudo_lld_bus,
@@ -224,6 +245,9 @@ static struct device_driver sdebug_drive
 
 static const int check_condition_result =
 		(DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
+
+static const int illegal_condition_result =
+	(DRIVER_SENSE << 24) | (DID_ABORT << 16) | SAM_STAT_CHECK_CONDITION;
 
 static unsigned char ctrl_m_pg[] = {0xa, 10, 2, 0, 0, 0, 0, 0,
 				    0, 0, 0x2, 0x4b};
@@ -726,7 +750,12 @@ static int resp_inquiry(struct scsi_cmnd
 		} else if (0x86 == cmd[2]) { /* extended inquiry */
 			arr[1] = cmd[2];	/*sanity */
 			arr[3] = 0x3c;	/* number of following entries */
-			arr[4] = 0x0;   /* no protection stuff */
+			if (scsi_debug_dif == SD_DIF_TYPE3_PROTECTION)
+				arr[4] = 0x4;	/* SPT: GRD_CHK:1 */
+			else if (scsi_debug_dif)
+				arr[4] = 0x5;   /* SPT: GRD_CHK:1, REF_CHK:1 */
+			else
+				arr[4] = 0x0;   /* no protection stuff */
 			arr[5] = 0x7;   /* head of q, ordered + simple q's */
 		} else if (0x87 == cmd[2]) { /* mode page policy */
 			arr[1] = cmd[2];	/*sanity */
@@ -767,6 +796,7 @@ static int resp_inquiry(struct scsi_cmnd
 	arr[2] = scsi_debug_scsi_level;
 	arr[3] = 2;    /* response_data_format==2 */
 	arr[4] = SDEBUG_LONG_INQ_SZ - 5;
+	arr[5] = scsi_debug_dif ? 1 : 0; /* PROTECT bit */
 	if (0 == scsi_debug_vpd_use_hostno)
 		arr[5] = 0x10; /* claim: implicit TGPS */
 	arr[6] = 0x10; /* claim: MultiP */
@@ -915,6 +945,12 @@ static int resp_readcap16(struct scsi_cm
 	arr[9] = (scsi_debug_sector_size >> 16) & 0xff;
 	arr[10] = (scsi_debug_sector_size >> 8) & 0xff;
 	arr[11] = scsi_debug_sector_size & 0xff;
+
+	if (scsi_debug_dif) {
+		arr[12] = (scsi_debug_dif - 1) << 1; /* P_TYPE */
+		arr[12] |= 1; /* PROT_EN */
+	}
+
 	return fill_from_dev_buffer(scp, arr,
 				    min(alloc_len, SDEBUG_READCAP16_ARR_SZ));
 }
@@ -1066,6 +1102,10 @@ static int resp_ctrl_m_pg(unsigned char 
 		ctrl_m_pg[2] |= 0x4;
 	else
 		ctrl_m_pg[2] &= ~0x4;
+
+	if (scsi_debug_ato)
+		ctrl_m_pg[5] |= 0x80; /* ATO=1 */
+
 	memcpy(p, ctrl_m_pg, sizeof(ctrl_m_pg));
 	if (1 == pcontrol)
 		memcpy(p + 2, ch_ctrl_m_pg, sizeof(ch_ctrl_m_pg));
@@ -1536,6 +1576,87 @@ static int do_device_access(struct scsi_
 	return ret;
 }
 
+static int prot_verify_read(struct scsi_cmnd *SCpnt, sector_t start_sec,
+			    unsigned int sectors)
+{
+	unsigned int i, resid;
+	struct scatterlist *psgl;
+	struct sd_dif_tuple *sdt;
+	sector_t sector;
+	sector_t tmp_sec = start_sec;
+	void *paddr;
+
+	start_sec = do_div(tmp_sec, sdebug_store_sectors);
+
+	sdt = (struct sd_dif_tuple *)(dif_storep + dif_offset(start_sec));
+
+	for (i = 0 ; i < sectors ; i++) {
+		u16 csum;
+
+		if (sdt[i].app_tag == 0xffff)
+			continue;
+
+		sector = start_sec + i;
+
+		switch (scsi_debug_guard) {
+		case 1:
+			csum = ip_compute_csum(fake_storep +
+					       sector * scsi_debug_sector_size,
+					       scsi_debug_sector_size);
+			break;
+		case 0:
+			csum = crc_t10dif(fake_storep +
+					  sector * scsi_debug_sector_size,
+					  scsi_debug_sector_size);
+			csum = cpu_to_be16(csum);
+			break;
+		default:
+			BUG();
+		}
+
+		if (sdt[i].guard_tag != csum) {
+			printk(KERN_ERR "%s: GUARD check failed on sector %lu" \
+			       " rcvd 0x%04x, data 0x%04x\n", __func__,
+			       (unsigned long)sector,
+			       be16_to_cpu(sdt[i].guard_tag),
+			       be16_to_cpu(csum));
+			dif_errors++;
+			return 0x01;
+		}
+
+		if (scsi_debug_dif != SD_DIF_TYPE3_PROTECTION &&
+		    be32_to_cpu(sdt[i].ref_tag) != (sector & 0xffffffff)) {
+			printk(KERN_ERR "%s: REF check failed on sector %lu\n",
+			       __func__, (unsigned long)sector);
+			dif_errors++;
+			return 0x03;
+		}
+	}
+
+	resid = sectors * 8; /* Bytes of protection data to copy into sgl */
+	sector = start_sec;
+
+	scsi_for_each_prot_sg(SCpnt, psgl, scsi_prot_sg_count(SCpnt), i) {
+		int len = min(psgl->length, resid);
+
+		paddr = kmap_atomic(sg_page(psgl), KM_IRQ0) + psgl->offset;
+		memcpy(paddr, dif_storep + dif_offset(sector), len);
+
+		sector += len >> 3;
+		if (sector >= sdebug_store_sectors) {
+			/* Force wrap */
+			tmp_sec = sector;
+			sector = do_div(tmp_sec, sdebug_store_sectors);
+		}
+		resid -= len;
+		kunmap_atomic(paddr, KM_IRQ0);
+	}
+
+	dix_reads++;
+
+	return 0;
+}
+
 static int resp_read(struct scsi_cmnd *SCpnt, unsigned long long lba,
 		     unsigned int num, struct sdebug_dev_info *devip)
 {
@@ -1563,9 +1684,159 @@ static int resp_read(struct scsi_cmnd *S
 		}
 		return check_condition_result;
 	}
+
+	/* DIX + T10 DIF */
+	if (scsi_debug_dix && scsi_prot_sg_count(SCpnt)) {
+		int prot_ret = prot_verify_read(SCpnt, lba, num);
+
+		if (prot_ret) {
+			mk_sense_buffer(devip, ABORTED_COMMAND, 0x10, prot_ret);
+			return illegal_condition_result;
+		}
+	}
+
 	read_lock_irqsave(&atomic_rw, iflags);
 	ret = do_device_access(SCpnt, devip, lba, num, 0);
 	read_unlock_irqrestore(&atomic_rw, iflags);
+	return ret;
+}
+
+void dump_sector(unsigned char *buf, int len)
+{
+	int i, j;
+
+	printk(KERN_ERR ">>> Sector Dump <<<\n");
+
+	for (i = 0 ; i < len ; i += 16) {
+		printk(KERN_ERR "%04d: ", i);
+
+		for (j = 0 ; j < 16 ; j++) {
+			unsigned char c = buf[i+j];
+			if (c >= 0x20 && c < 0x7e)
+				printk(" %c ", buf[i+j]);
+			else
+				printk("%02x ", buf[i+j]);
+		}
+
+		printk("\n");
+	}
+}
+
+static int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t start_sec,
+			     unsigned int sectors)
+{
+	int i, j, ret;
+	struct sd_dif_tuple *sdt;
+	struct scatterlist *dsgl = scsi_sglist(SCpnt);
+	struct scatterlist *psgl = scsi_prot_sglist(SCpnt);
+	void *daddr, *paddr;
+	sector_t tmp_sec = start_sec;
+	sector_t sector;
+	int ppage_offset;
+	unsigned short csum;
+
+	sector = do_div(tmp_sec, sdebug_store_sectors);
+
+	if (((SCpnt->cmnd[1] >> 5) & 7) != 1) {
+		printk(KERN_WARNING "scsi_debug: WRPROTECT != 1\n");
+		return 0;
+	}
+
+	BUG_ON(scsi_sg_count(SCpnt) == 0);
+	BUG_ON(scsi_prot_sg_count(SCpnt) == 0);
+
+	paddr = kmap_atomic(sg_page(psgl), KM_IRQ1) + psgl->offset;
+	ppage_offset = 0;
+
+	/* For each data page */
+	scsi_for_each_sg(SCpnt, dsgl, scsi_sg_count(SCpnt), i) {
+		daddr = kmap_atomic(sg_page(dsgl), KM_IRQ0) + dsgl->offset;
+
+		/* For each sector-sized chunk in data page */
+		for (j = 0 ; j < dsgl->length ; j += scsi_debug_sector_size) {
+
+			/* If we're at the end of the current
+			 * protection page advance to the next one
+			 */
+			if (ppage_offset >= psgl->length) {
+				kunmap_atomic(paddr, KM_IRQ1);
+				psgl = sg_next(psgl);
+				BUG_ON(psgl == NULL);
+				paddr = kmap_atomic(sg_page(psgl), KM_IRQ1)
+					+ psgl->offset;
+				ppage_offset = 0;
+			}
+
+			sdt = paddr + ppage_offset;
+
+			switch (scsi_debug_guard) {
+			case 1:
+				csum = ip_compute_csum(daddr,
+						       scsi_debug_sector_size);
+				break;
+			case 0:
+				csum = cpu_to_be16(crc_t10dif(daddr,
+						      scsi_debug_sector_size));
+				break;
+			default:
+				BUG();
+				ret = 0;
+				goto out;
+			}
+
+			if (sdt->guard_tag != csum) {
+				printk(KERN_ERR
+				       "%s: GUARD check failed on sector %lu " \
+				       "rcvd 0x%04x, calculated 0x%04x\n",
+				       __func__, (unsigned long)sector,
+				       be16_to_cpu(sdt->guard_tag),
+				       be16_to_cpu(csum));
+				ret = 0x01;
+				dump_sector(daddr, scsi_debug_sector_size);
+				goto out;
+			}
+
+			if (scsi_debug_dif != SD_DIF_TYPE3_PROTECTION &&
+			    be32_to_cpu(sdt->ref_tag)
+			    != (start_sec & 0xffffffff)) {
+				printk(KERN_ERR
+				       "%s: REF check failed on sector %lu\n",
+				       __func__, (unsigned long)sector);
+				ret = 0x03;
+				dump_sector(daddr, scsi_debug_sector_size);
+				goto out;
+			}
+
+			/* Would be great to copy this in bigger
+			 * chunks.  However, for the sake of
+			 * correctness we need to verify each sector
+			 * before writing it to "stable" storage
+			 */
+			memcpy(dif_storep + dif_offset(sector), sdt, 8);
+
+			sector++;
+
+			if (sector == sdebug_store_sectors)
+				sector = 0;	/* Force wrap */
+
+			start_sec++;
+			daddr += scsi_debug_sector_size;
+			ppage_offset += sizeof(struct sd_dif_tuple);
+		}
+
+		kunmap_atomic(daddr, KM_IRQ0);
+	}
+
+	kunmap_atomic(paddr, KM_IRQ1);
+
+	dix_writes++;
+
+	return 0;
+
+out:
+	dif_errors++;
+	kunmap_atomic(daddr, KM_IRQ0);
+	kunmap_atomic(paddr, KM_IRQ1);
 	return ret;
 }
 
@@ -1578,6 +1849,16 @@ static int resp_write(struct scsi_cmnd *
 	ret = check_device_access_params(devip, lba, num);
 	if (ret)
 		return ret;
+
+	/* DIX + T10 DIF */
+	if (scsi_debug_dix && scsi_prot_sg_count(SCpnt)) {
+		int prot_ret = prot_verify_write(SCpnt, lba, num);
+
+		if (prot_ret) {
+			mk_sense_buffer(devip, ILLEGAL_REQUEST, 0x10, prot_ret);
+			return illegal_condition_result;
+		}
+	}
 
 	write_lock_irqsave(&atomic_rw, iflags);
 	ret = do_device_access(SCpnt, devip, lba, num, 1);
@@ -2095,6 +2376,10 @@ module_param_named(vpd_use_hostno, scsi_
 module_param_named(vpd_use_hostno, scsi_debug_vpd_use_hostno, int,
 		   S_IRUGO | S_IWUSR);
 module_param_named(sector_size, scsi_debug_sector_size, int, S_IRUGO);
+module_param_named(dix, scsi_debug_dix, int, S_IRUGO);
+module_param_named(dif, scsi_debug_dif, int, S_IRUGO);
+module_param_named(guard, scsi_debug_guard, int, S_IRUGO);
+module_param_named(ato, scsi_debug_ato, int, S_IRUGO);
 
 MODULE_AUTHOR("Eric Youngdale + Douglas Gilbert");
 MODULE_DESCRIPTION("SCSI debug adapter driver");
@@ -2117,7 +2402,10 @@ MODULE_PARM_DESC(virtual_gb, "virtual gi
 MODULE_PARM_DESC(virtual_gb, "virtual gigabyte size (def=0 -> use dev_size_mb)");
 MODULE_PARM_DESC(vpd_use_hostno, "0 -> dev ids ignore hostno (def=1 -> unique dev ids)");
 MODULE_PARM_DESC(sector_size, "hardware sector size in bytes (def=512)");
-
+MODULE_PARM_DESC(dix, "data integrity extensions mask (def=0)");
+MODULE_PARM_DESC(dif, "data integrity field type: 0-3 (def=0)");
+MODULE_PARM_DESC(guard, "protection checksum: 0=crc, 1=ip (def=0)");
+MODULE_PARM_DESC(ato, "application tag ownership: 0=disk 1=host (def=1)");
 
 static char sdebug_info[256];
 
@@ -2164,14 +2452,14 @@ static int scsi_debug_proc_info(struct S
 	    "delay=%d, max_luns=%d, scsi_level=%d\n"
 	    "sector_size=%d bytes, cylinders=%d, heads=%d, sectors=%d\n"
 	    "number of aborts=%d, device_reset=%d, bus_resets=%d, "
-	    "host_resets=%d\n",
+	    "host_resets=%d\ndix_reads=%d dix_writes=%d dif_errors=%d\n",
 	    SCSI_DEBUG_VERSION, scsi_debug_version_date, scsi_debug_num_tgts,
 	    scsi_debug_dev_size_mb, scsi_debug_opts, scsi_debug_every_nth,
 	    scsi_debug_cmnd_count, scsi_debug_delay,
 	    scsi_debug_max_luns, scsi_debug_scsi_level,
 	    scsi_debug_sector_size, sdebug_cylinders_per, sdebug_heads,
 	    sdebug_sectors_per, num_aborts, num_dev_resets, num_bus_resets,
-	    num_host_resets);
+	    num_host_resets, dix_reads, dix_writes, dif_errors);
 	if (pos < offset) {
 		len = 0;
 		begin = pos;
@@ -2452,6 +2740,31 @@ static ssize_t sdebug_sector_size_show(s
 }
 DRIVER_ATTR(sector_size, S_IRUGO, sdebug_sector_size_show, NULL);
 
+static ssize_t sdebug_dix_show(struct device_driver *ddp, char *buf)
+{
+	return scnprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_dix);
+}
+DRIVER_ATTR(dix, S_IRUGO, sdebug_dix_show, NULL);
+
+static ssize_t sdebug_dif_show(struct device_driver *ddp, char *buf)
+{
+	return scnprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_dif);
+}
+DRIVER_ATTR(dif, S_IRUGO, sdebug_dif_show, NULL);
+
+static ssize_t sdebug_guard_show(struct device_driver *ddp, char *buf)
+{
+	return scnprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_guard);
+}
+DRIVER_ATTR(guard, S_IRUGO, sdebug_guard_show, NULL);
+
+static ssize_t sdebug_ato_show(struct device_driver *ddp, char *buf)
+{
+	return scnprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_ato);
+}
+DRIVER_ATTR(ato, S_IRUGO, sdebug_ato_show, NULL);
+
+
 /* Note: The following function creates attribute files in the
    /sys/bus/pseudo/drivers/scsi_debug directory. The advantage of these
    files (over those found in the /sys/module/scsi_debug/parameters
@@ -2478,11 +2791,19 @@ static int do_create_driverfs_files(void
 	ret |= driver_create_file(&sdebug_driverfs_driver, &driver_attr_virtual_gb);
 	ret |= driver_create_file(&sdebug_driverfs_driver, &driver_attr_vpd_use_hostno);
 	ret |= driver_create_file(&sdebug_driverfs_driver, &driver_attr_sector_size);
+	ret |= driver_create_file(&sdebug_driverfs_driver, &driver_attr_dix);
+	ret |= driver_create_file(&sdebug_driverfs_driver, &driver_attr_dif);
+	ret |= driver_create_file(&sdebug_driverfs_driver, &driver_attr_guard);
+	ret |= driver_create_file(&sdebug_driverfs_driver, &driver_attr_ato);
 	return ret;
 }
 
 static void do_remove_driverfs_files(void)
 {
+	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_ato);
+	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_guard);
+	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_dif);
+	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_dix);
 	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_sector_size);
 	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_vpd_use_hostno);
 	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_virtual_gb);
@@ -2526,8 +2847,30 @@ static int __init scsi_debug_init(void)
 	case 4096:
 		break;
 	default:
-		printk(KERN_ERR "scsi_debug_init: invalid sector_size %u\n",
+		printk(KERN_ERR "scsi_debug_init: invalid sector_size %d\n",
 		       scsi_debug_sector_size);
+		return -EINVAL;
+	}
+
+	switch (scsi_debug_dif) {
+
+	case SD_DIF_TYPE0_PROTECTION:
+	case SD_DIF_TYPE1_PROTECTION:
+	case SD_DIF_TYPE3_PROTECTION:
+		break;
+
+	default:
+		printk(KERN_ERR "scsi_debug_init: dif must be 0, 1 or 3\n");
+		return -EINVAL;
+	}
+
+	if (scsi_debug_guard > 1) {
+		printk(KERN_ERR "scsi_debug_init: guard must be 0 or 1\n");
+		return -EINVAL;
+	}
+
+	if (scsi_debug_ato > 1) {
+		printk(KERN_ERR "scsi_debug_init: ato must be 0 or 1\n");
 		return -EINVAL;
 	}
 
@@ -2562,6 +2905,24 @@ static int __init scsi_debug_init(void)
 	memset(fake_storep, 0, sz);
 	if (scsi_debug_num_parts > 0)
 		sdebug_build_parts(fake_storep, sz);
+
+	if (scsi_debug_dif) {
+		int dif_size;
+
+		dif_size = sdebug_store_sectors * sizeof(struct sd_dif_tuple);
+		dif_storep = vmalloc(dif_size);
+
+		printk(KERN_ERR "scsi_debug_init: dif_storep %u bytes @ %p\n",
+		       dif_size, dif_storep);
+
+		if (dif_storep == NULL) {
+			printk(KERN_ERR "scsi_debug_init: out of mem. (DIX)\n");
+			ret = -ENOMEM;
+			goto free_vm;
+		}
+
+		memset(dif_storep, 0xff, dif_size);
+	}
 
 	ret = device_register(&pseudo_primary);
 	if (ret < 0) {
@@ -2615,6 +2976,8 @@ dev_unreg:
 dev_unreg:
 	device_unregister(&pseudo_primary);
 free_vm:
+	if (dif_storep)
+		vfree(dif_storep);
 	vfree(fake_storep);
 
 	return ret;
@@ -2631,6 +2994,9 @@ static void __exit scsi_debug_exit(void)
 	driver_unregister(&sdebug_driverfs_driver);
 	bus_unregister(&pseudo_lld_bus);
 	device_unregister(&pseudo_primary);
+
+	if (dif_storep)
+		vfree(dif_storep);
 
 	vfree(fake_storep);
 }
@@ -2732,6 +3098,8 @@ int scsi_debug_queuecommand(struct scsi_
 	struct sdebug_dev_info *devip = NULL;
 	int inj_recovered = 0;
 	int inj_transport = 0;
+	int inj_dif = 0;
+	int inj_dix = 0;
 	int delay_override = 0;
 
 	scsi_set_resid(SCpnt, 0);
@@ -2769,6 +3137,10 @@ int scsi_debug_queuecommand(struct scsi_
 			inj_recovered = 1; /* to reads and writes below */
 		else if (SCSI_DEBUG_OPT_TRANSPORT_ERR & scsi_debug_opts)
 			inj_transport = 1; /* to reads and writes below */
+		else if (SCSI_DEBUG_OPT_DIF_ERR & scsi_debug_opts)
+			inj_dif = 1; /* to reads and writes below */
+		else if (SCSI_DEBUG_OPT_DIX_ERR & scsi_debug_opts)
+			inj_dix = 1; /* to reads and writes below */
 	}
 
 	if (devip->wlun) {
@@ -2870,6 +3242,12 @@ int scsi_debug_queuecommand(struct scsi_
 			mk_sense_buffer(devip, ABORTED_COMMAND,
 					TRANSPORT_PROBLEM, ACK_NAK_TO);
 			errsts = check_condition_result;
+		} else if (inj_dif && (0 == errsts)) {
+			mk_sense_buffer(devip, ABORTED_COMMAND, 0x10, 1);
+			errsts = illegal_condition_result;
+		} else if (inj_dix && (0 == errsts)) {
+			mk_sense_buffer(devip, ILLEGAL_REQUEST, 0x10, 1);
+			errsts = illegal_condition_result;
 		}
 		break;
 	case REPORT_LUNS:	/* mandatory, ignore unit attention */
@@ -2894,6 +3272,12 @@ int scsi_debug_queuecommand(struct scsi_
 			mk_sense_buffer(devip, RECOVERED_ERROR,
 					THRESHOLD_EXCEEDED, 0);
 			errsts = check_condition_result;
+		} else if (inj_dif && (0 == errsts)) {
+			mk_sense_buffer(devip, ABORTED_COMMAND, 0x10, 1);
+			errsts = illegal_condition_result;
+		} else if (inj_dix && (0 == errsts)) {
+			mk_sense_buffer(devip, ILLEGAL_REQUEST, 0x10, 1);
+			errsts = illegal_condition_result;
 		}
 		break;
 	case MODE_SENSE:
@@ -2982,6 +3366,7 @@ static int sdebug_driver_probe(struct de
         int error = 0;
         struct sdebug_host_info *sdbg_host;
         struct Scsi_Host *hpnt;
+	int host_prot;
 
 	sdbg_host = to_sdebug_host(dev);
 
@@ -2999,6 +3384,50 @@ static int sdebug_driver_probe(struct de
 	else
 		hpnt->max_id = scsi_debug_num_tgts;
 	hpnt->max_lun = SAM2_WLUN_REPORT_LUNS;	/* = scsi_debug_max_luns; */
+
+	host_prot = 0;
+
+	switch (scsi_debug_dif) {
+
+	case SD_DIF_TYPE1_PROTECTION:
+		host_prot = SHOST_DIF_TYPE1_PROTECTION;
+		if (scsi_debug_dix)
+			host_prot |= SHOST_DIX_TYPE1_PROTECTION;
+		break;
+
+	case SD_DIF_TYPE2_PROTECTION:
+		host_prot = SHOST_DIF_TYPE2_PROTECTION;
+		if (scsi_debug_dix)
+			host_prot |= SHOST_DIX_TYPE2_PROTECTION;
+		break;
+
+	case SD_DIF_TYPE3_PROTECTION:
+		host_prot = SHOST_DIF_TYPE3_PROTECTION;
+		if (scsi_debug_dix)
+			host_prot |= SHOST_DIX_TYPE3_PROTECTION;
+		break;
+
+	default:
+		if (scsi_debug_dix)
+			host_prot |= SHOST_DIX_TYPE0_PROTECTION;
+		break;
+	}
+
+	scsi_host_set_prot(hpnt, host_prot);
+
+	printk(KERN_INFO "scsi_debug: host protection%s%s%s%s%s%s%s\n",
+	       (host_prot & SHOST_DIF_TYPE1_PROTECTION) ? " DIF1" : "",
+	       (host_prot & SHOST_DIF_TYPE2_PROTECTION) ? " DIF2" : "",
+	       (host_prot & SHOST_DIF_TYPE3_PROTECTION) ? " DIF3" : "",
+	       (host_prot & SHOST_DIX_TYPE0_PROTECTION) ? " DIX0" : "",
+	       (host_prot & SHOST_DIX_TYPE1_PROTECTION) ? " DIX1" : "",
+	       (host_prot & SHOST_DIX_TYPE2_PROTECTION) ? " DIX2" : "",
+	       (host_prot & SHOST_DIX_TYPE3_PROTECTION) ? " DIX3" : "");
+
+	if (scsi_debug_guard == 1)
+		scsi_host_set_guard(hpnt, SHOST_DIX_GUARD_IP);
+	else
+		scsi_host_set_guard(hpnt, SHOST_DIX_GUARD_CRC);
 
         error = scsi_add_host(hpnt, &sdbg_host->dev);
         if (error) {
