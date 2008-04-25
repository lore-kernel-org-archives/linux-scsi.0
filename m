From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 14 of 16] Implement support for DIF in SCSI debug driver
Date: Fri, 25 Apr 2008 19:12:16 -0400
Message-ID: <f32469624774b79b2fb9.1209165136@sermon.lab.mkp.net>
References: <patchbomb.1209165122@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:44321 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760771AbYDYXRa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2008 19:17:30 -0400
In-Reply-To: <patchbomb.1209165122@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

1 file changed, 385 insertions(+), 4 deletions(-)
drivers/scsi/scsi_debug.c |  389 ++++++++++++++++++++++++++++++++++++++++++++-


Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff -r b912d7bb3c47 -r f32469624774 drivers/scsi/scsi_debug.c
--- a/drivers/scsi/scsi_debug.c	Fri Apr 25 17:39:29 2008 -0400
+++ b/drivers/scsi/scsi_debug.c	Fri Apr 25 17:39:29 2008 -0400
@@ -40,6 +40,8 @@
 #include <linux/moduleparam.h>
 #include <linux/scatterlist.h>
 #include <linux/blkdev.h>
+#include <linux/crc-t10dif.h>
+#include <linux/ctype.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -47,8 +49,12 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsicam.h>
 #include <scsi/scsi_eh.h>
+#include <scsi/sd.h>
+#include <scsi/scsi_dif.h>
+#include <scsi/scsi_cmnd.h>
 
 #include <linux/stat.h>
+#include <net/checksum.h>
 
 #include "scsi_logging.h"
 
@@ -94,6 +100,9 @@
 #define DEF_VIRTUAL_GB   0
 #define DEF_FAKE_RW	0
 #define DEF_VPD_USE_HOSTNO 1
+#define DEF_PROTECTION 0
+#define DEF_GUARD 1
+#define DEF_ATO 1
 
 /* bit mask values for scsi_debug_opts */
 #define SCSI_DEBUG_OPT_NOISE   1
@@ -142,6 +151,9 @@
 static int scsi_debug_virtual_gb = DEF_VIRTUAL_GB;
 static int scsi_debug_fake_rw = DEF_FAKE_RW;
 static int scsi_debug_vpd_use_hostno = DEF_VPD_USE_HOSTNO;
+static int scsi_debug_protection = DEF_PROTECTION;
+static int scsi_debug_guard = DEF_GUARD;
+static int scsi_debug_ato = DEF_ATO;
 
 static int scsi_debug_cmnd_count = 0;
 
@@ -207,11 +219,15 @@
 static struct sdebug_queued_cmd queued_arr[SCSI_DEBUG_CANQUEUE];
 
 static unsigned char * fake_storep;	/* ramdisk storage */
+static unsigned char * dif_storep;	/* protection info */
 
 static int num_aborts = 0;
 static int num_dev_resets = 0;
 static int num_bus_resets = 0;
 static int num_host_resets = 0;
+static int dif_writes = 0;
+static int dif_reads = 0;
+static int dif_errors = 0;
 
 static DEFINE_SPINLOCK(queued_arr_lock);
 static DEFINE_RWLOCK(atomic_rw);
@@ -220,6 +236,11 @@
 
 static struct bus_type pseudo_lld_bus;
 
+static inline sector_t dif_offset(sector_t sector)
+{
+	return sector << 3;
+}
+
 static struct device_driver sdebug_driverfs_driver = {
 	.name 		= sdebug_proc_name,
 	.bus		= &pseudo_lld_bus,
@@ -227,6 +248,10 @@
 
 static const int check_condition_result =
 		(DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
+
+static const int illegal_condition_result =
+	((DRIVER_SENSE|SUGGEST_DIE) << 24) | (DID_ABORT << 16 ) 
+	| SAM_STAT_CHECK_CONDITION;
 
 static unsigned char ctrl_m_pg[] = {0xa, 10, 2, 0, 0, 0, 0, 0,
 				    0, 0, 0x2, 0x4b};
@@ -720,7 +745,11 @@
 		} else if (0x86 == cmd[2]) { /* extended inquiry */
 			arr[1] = cmd[2];	/*sanity */
 			arr[3] = 0x3c;	/* number of following entries */
-			arr[4] = 0x0;   /* no protection stuff */
+			if (scsi_debug_protection)
+				arr[4] = 0x5;   /* SPT: Type 1 Protection,
+						 * GRD_CHK:1, REF_CHK:1 */
+			else
+				arr[4] = 0x0;   /* no protection stuff */
 			arr[5] = 0x7;   /* head of q, ordered + simple q's */
 		} else if (0x87 == cmd[2]) { /* mode page policy */
 			arr[1] = cmd[2];	/*sanity */
@@ -758,6 +787,7 @@
 	arr[2] = scsi_debug_scsi_level;
 	arr[3] = 2;    /* response_data_format==2 */
 	arr[4] = SDEBUG_LONG_INQ_SZ - 5;
+	arr[5] = scsi_debug_protection ? 1 : 0; /* PROTECT bit */
 	if (0 == scsi_debug_vpd_use_hostno)
 		arr[5] = 0x10; /* claim: implicit TGPS */
 	arr[6] = 0x10; /* claim: MultiP */
@@ -906,6 +936,11 @@
 	arr[9] = (SECT_SIZE_PER(target) >> 16) & 0xff;
 	arr[10] = (SECT_SIZE_PER(target) >> 8) & 0xff;
 	arr[11] = SECT_SIZE_PER(target) & 0xff;
+	
+	if (scsi_debug_protection) {
+		arr[12] = (scsi_debug_protection - 1) << 1; /* P_TYPE */
+		arr[12] |= 1; /* PROT_EN */
+	}
 	return fill_from_dev_buffer(scp, arr,
 				    min(alloc_len, SDEBUG_READCAP16_ARR_SZ));
 }
@@ -1057,6 +1092,10 @@
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
@@ -1527,6 +1566,75 @@
 	return ret;
 }
 
+#ifdef CONFIG_SCSI_PROTECTION
+static int prot_verify_read(struct scsi_cmnd * SCpnt, sector_t start_sec,
+			    unsigned int sectors)
+{
+	unsigned int i, resid;
+	struct scatterlist *psgl;
+	struct scsi_dif_tuple *sdt;
+	sector_t sector;
+	void *paddr;
+
+	sdt = (struct scsi_dif_tuple *)(dif_storep + dif_offset(start_sec));
+
+	for (i=0 ; i<sectors ; i++) {
+		u16 csum;
+
+		if (sdt[i].app_tag == 0xffff)
+			continue;
+
+		sector = start_sec + i;
+
+		switch (scsi_debug_guard) {
+		case 1:
+			csum = ip_compute_csum(fake_storep + (sector * SECT_SIZE),
+					       SECT_SIZE);
+			break;
+		case 0:
+			csum = cpu_to_be16(crc_t10dif(fake_storep + (sector * SECT_SIZE),
+						      SECT_SIZE));
+			break;
+		default:
+			BUG();
+		}
+
+		if (sdt[i].guard_tag != csum) {
+			printk(KERN_ERR "%s: GUARD check failed on sector %lu " \
+			       "rcvd 0x%04x, data 0x%04x\n", __func__, sector, 
+			       be16_to_cpu(sdt[i].guard_tag), be16_to_cpu(csum));
+			dif_errors++;
+			return 0x01;
+		}
+
+		if (be32_to_cpu(sdt[i].ref_tag) != (sector & 0xffffffff)) {
+			printk(KERN_ERR "%s: REF check failed on sector %lu\n",
+			       __func__, sector);
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
+		resid -= len;
+		kunmap_atomic(sg_page(psgl), KM_IRQ0);
+	}
+
+	dif_reads++;
+
+	return 0;
+}
+#endif
+
 static int resp_read(struct scsi_cmnd *SCpnt, unsigned long long lba,
 		     unsigned int num, struct sdebug_dev_info *devip)
 {
@@ -1554,11 +1662,152 @@
 		}
 		return check_condition_result;
 	}
+
+	/* T10 DIF */
+#ifdef CONFIG_SCSI_PROTECTION
+	if (scsi_debug_protection && scsi_prot_sg_count(SCpnt)) {
+		int prot_ret;
+
+		if ((prot_ret = prot_verify_read(SCpnt, lba, num))) {
+			mk_sense_buffer(devip, ABORTED_COMMAND, 0x10, prot_ret);
+			return illegal_condition_result;
+		}
+	}
+#endif
+
 	read_lock_irqsave(&atomic_rw, iflags);
 	ret = do_device_access(SCpnt, devip, lba, num, 0);
 	read_unlock_irqrestore(&atomic_rw, iflags);
 	return ret;
 }
+
+#ifdef CONFIG_SCSI_PROTECTION
+
+void dump_sector(unsigned char *buf, int len)
+{
+	int i, j;
+
+	printk(KERN_ERR ">>> Sector Dump <<<\n");
+
+	for (i=0 ; i<len ; i+=16) {
+		printk(KERN_ERR "%04d: ", i);
+
+		for (j=0 ; j<16 ; j++) {
+			unsigned char c = buf[i+j];
+			if (c >= 0x20 && c < 0x7e)
+				printk(" %c ",buf[i+j]);
+			else
+				printk("%02x ", buf[i+j]);
+		}
+
+		printk("\n");
+	}
+}
+
+static int prot_verify_write(struct scsi_cmnd * SCpnt, sector_t start_sec,
+			     unsigned int sectors)
+{
+	int i, j, ret;
+	struct scsi_dif_tuple *sdt;
+	struct scatterlist *dsgl = scsi_sglist(SCpnt);
+	struct scatterlist *psgl = scsi_prot_sglist(SCpnt);
+	void *daddr, *paddr;
+	sector_t sector = start_sec;
+	int ppage_offset;
+	unsigned short csum;
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
+		for (j=0 ; j<dsgl->length ; j+=SECT_SIZE) {
+
+			/* If we're at the end of the current
+			 * protection page advance to the next one
+			 */
+			if (ppage_offset >= psgl->length) {
+				kunmap_atomic(sg_page(psgl), KM_IRQ1);
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
+				csum = ip_compute_csum(daddr, SECT_SIZE);
+				break;
+			case 0:
+				csum = cpu_to_be16(crc_t10dif(daddr, SECT_SIZE));
+				break;
+			default:
+				BUG();
+				ret = 0;
+				goto out;
+			}
+
+			if (sdt->guard_tag != csum) {
+				printk(KERN_ERR "%s: GUARD check failed on sector %lu " \
+				       "rcvd 0x%04x, calculated 0x%04x\n",
+				       __func__, sector, 
+				       be16_to_cpu(sdt->guard_tag), be16_to_cpu(csum));
+				ret = 0x01;
+				dump_sector(daddr, SECT_SIZE);
+				goto out;
+			}
+
+			if (be32_to_cpu(sdt->ref_tag) != (sector & 0xffffffff)) {
+				printk(KERN_ERR 
+				       "%s: REF check failed on sector %lu\n",
+				       __func__, sector);
+				ret = 0x03;
+				dump_sector(daddr, SECT_SIZE);
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
+			daddr += SECT_SIZE;
+			ppage_offset += sizeof(struct scsi_dif_tuple);
+		}
+
+		kunmap_atomic(sg_page(dsgl), KM_IRQ0);
+	}
+
+	kunmap_atomic(sg_page(psgl), KM_IRQ1);
+
+	dif_writes++;
+
+	return 0;
+
+out:
+	dif_errors++;
+	kunmap_atomic(sg_page(dsgl), KM_IRQ0);
+	kunmap_atomic(sg_page(psgl), KM_IRQ1);
+	return ret;
+}
+#endif
 
 static int resp_write(struct scsi_cmnd *SCpnt, unsigned long long lba,
 		      unsigned int num, struct sdebug_dev_info *devip)
@@ -1569,6 +1818,18 @@
 	ret = check_device_access_params(devip, lba, num);
 	if (ret)
 		return ret;
+
+#ifdef CONFIG_SCSI_PROTECTION
+	/* T10 DIF */
+	if (scsi_debug_protection && scsi_prot_sg_count(SCpnt)) {
+		int prot_ret;
+
+		if ((prot_ret = prot_verify_write(SCpnt, lba, num))) {
+			mk_sense_buffer(devip, ILLEGAL_REQUEST, 0x10, prot_ret);
+			return illegal_condition_result;
+		}
+	}
+#endif
 
 	write_lock_irqsave(&atomic_rw, iflags);
 	ret = do_device_access(SCpnt, devip, lba, num, 1);
@@ -2085,6 +2346,9 @@
 module_param_named(virtual_gb, scsi_debug_virtual_gb, int, S_IRUGO | S_IWUSR);
 module_param_named(vpd_use_hostno, scsi_debug_vpd_use_hostno, int,
 		   S_IRUGO | S_IWUSR);
+module_param_named(protection, scsi_debug_protection, int, S_IRUGO | S_IWUSR);
+module_param_named(guard, scsi_debug_guard, int, S_IRUGO | S_IWUSR);
+module_param_named(ato, scsi_debug_ato, int, S_IRUGO | S_IWUSR);
 
 MODULE_AUTHOR("Eric Youngdale + Douglas Gilbert");
 MODULE_DESCRIPTION("SCSI debug adapter driver");
@@ -2106,7 +2370,8 @@
 MODULE_PARM_DESC(scsi_level, "SCSI level to simulate(def=5[SPC-3])");
 MODULE_PARM_DESC(virtual_gb, "virtual gigabyte size (def=0 -> use dev_size_mb)");
 MODULE_PARM_DESC(vpd_use_hostno, "0 -> dev ids ignore hostno (def=1 -> unique dev ids)");
-
+MODULE_PARM_DESC(protection, "enable support for data integrity field (def=0)");
+MODULE_PARM_DESC(guard, "protection checksum: 0=crc, 1=ip (def=1)");
 
 static char sdebug_info[256];
 
@@ -2153,13 +2418,14 @@
 	    "delay=%d, max_luns=%d, scsi_level=%d\n"
 	    "sector_size=%d bytes, cylinders=%d, heads=%d, sectors=%d\n"
 	    "number of aborts=%d, device_reset=%d, bus_resets=%d, "
-	    "host_resets=%d\n",
+	    "host_resets=%d\ndif_reads=%d dif_writes=%d dif_errors=%d\n",
 	    SCSI_DEBUG_VERSION, scsi_debug_version_date, scsi_debug_num_tgts,
 	    scsi_debug_dev_size_mb, scsi_debug_opts, scsi_debug_every_nth,
 	    scsi_debug_cmnd_count, scsi_debug_delay,
 	    scsi_debug_max_luns, scsi_debug_scsi_level,
 	    SECT_SIZE, sdebug_cylinders_per, sdebug_heads, sdebug_sectors_per,
-	    num_aborts, num_dev_resets, num_bus_resets, num_host_resets);
+	    num_aborts, num_dev_resets, num_bus_resets, num_host_resets,
+	    dif_reads, dif_writes, dif_errors);
 	if (pos < offset) {
 		len = 0;
 		begin = pos;
@@ -2434,6 +2700,83 @@
 DRIVER_ATTR(vpd_use_hostno, S_IRUGO | S_IWUSR, sdebug_vpd_use_hostno_show,
 	    sdebug_vpd_use_hostno_store);
 
+static ssize_t sdebug_protection_show(struct device_driver * ddp, char * buf)
+{
+        return scnprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_protection);
+}
+
+static ssize_t sdebug_protection_store(struct device_driver * ddp,
+				       const char * buf, size_t count)
+{
+        int n;
+	
+	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n >= 0)) {
+		switch (n) {
+		case 0: /* Type 0 Protection (None) */
+		case 1: /* Type 1 Protection (GRD, APP, REF) */
+		case 2: /* Type 2 Protection (READ32/WRITE32) */
+		case 3: /* Type 3 Protection (GRD only) */
+			scsi_debug_protection = n;
+			return count;
+		default:
+			break;
+		}
+	}
+	return -EINVAL;
+}
+DRIVER_ATTR(protection, S_IRUGO | S_IWUSR, sdebug_protection_show,
+	    sdebug_protection_store);
+
+static ssize_t sdebug_guard_show(struct device_driver * ddp, char * buf)
+{
+        return scnprintf(buf, PAGE_SIZE, "%u\n", scsi_debug_guard);
+}
+
+static ssize_t sdebug_guard_store(struct device_driver * ddp,
+				  const char * buf, size_t count)
+{
+        int n;
+	
+	if ((count > 0) && (1 == sscanf(buf, "%u", &n)) && (n >= 0)) {
+		switch (n) {
+		case 0: /* T10 DIF CRC */
+		case 1: /* IP checksum */
+			scsi_debug_protection = n;
+			return count;
+		default:
+			break;
+		}
+	}
+	return -EINVAL;
+}
+DRIVER_ATTR(guard, S_IRUGO | S_IWUSR, sdebug_guard_show,
+	    sdebug_guard_store);
+
+static ssize_t sdebug_ato_show(struct device_driver * ddp, char * buf)
+{
+        return scnprintf(buf, PAGE_SIZE, "%u\n", scsi_debug_ato);
+}
+
+static ssize_t sdebug_ato_store(struct device_driver * ddp,
+				const char * buf, size_t count)
+{
+        int n;
+	
+	if ((count > 0) && (1 == sscanf(buf, "%u", &n)) && (n >= 0)) {
+		switch (n) {
+		case 0: scsi_debug_ato = 0;
+			return count;
+		case 1: scsi_debug_ato = 1;
+			return count;
+		default:
+			break;
+		}
+	}
+	return -EINVAL;
+}
+DRIVER_ATTR(ato, S_IRUGO | S_IWUSR, sdebug_ato_show,
+	    sdebug_ato_store);
+
 /* Note: The following function creates attribute files in the
    /sys/bus/pseudo/drivers/scsi_debug directory. The advantage of these
    files (over those found in the /sys/module/scsi_debug/parameters
@@ -2499,6 +2842,8 @@
 	int k;
 	int ret;
 
+	ret = 0;
+
 	if (scsi_debug_dev_size_mb < 1)
 		scsi_debug_dev_size_mb = 1;  /* force minimum 1 MB ramdisk */
 	sz = (unsigned long)scsi_debug_dev_size_mb * 1048576;
@@ -2530,6 +2875,25 @@
 	memset(fake_storep, 0, sz);
 	if (scsi_debug_num_parts > 0)
 		sdebug_build_parts(fake_storep, sz);
+
+#ifdef CONFIG_SCSI_PROTECTION
+	if (scsi_debug_protection) {
+		int dif_size;
+
+		dif_size = sdebug_store_sectors * sizeof(struct scsi_dif_tuple);
+		dif_storep = vmalloc(dif_size);
+
+		printk(KERN_ERR "scsi_debug_init: dif_storep %u bytes @ %p\n", 
+		       dif_size, dif_storep);
+
+		if (dif_storep == NULL) {
+			printk(KERN_ERR "scsi_debug_init: out of mem. (DIF)\n");
+			goto free_vm;
+		}
+
+		memset(dif_storep, 0xff, dif_size);
+	}
+#endif
 
 	ret = device_register(&pseudo_primary);
 	if (ret < 0) {
@@ -2583,6 +2947,8 @@
 dev_unreg:
 	device_unregister(&pseudo_primary);
 free_vm:
+	if (dif_storep)
+		vfree(dif_storep);
 	vfree(fake_storep);
 
 	return ret;
@@ -2600,6 +2966,8 @@
 	bus_unregister(&pseudo_lld_bus);
 	device_unregister(&pseudo_primary);
 
+	if (dif_storep)
+		vfree(dif_storep);
 	vfree(fake_storep);
 }
 
@@ -2968,6 +3336,19 @@
 		hpnt->max_id = scsi_debug_num_tgts;
 	hpnt->max_lun = SAM2_WLUN_REPORT_LUNS;	/* = scsi_debug_max_luns; */
 
+#ifdef CONFIG_SCSI_PROTECTION
+	if (scsi_debug_protection) {
+		scsi_host_set_dif_caps(hpnt, 
+				       SHOST_DIF_TYPE1_PROTECTION
+				       |SHOST_DIF_PROTECTION_DMA);
+
+		if (scsi_debug_guard == 1)
+			scsi_host_set_guard_type(hpnt, SCSI_DIF_GUARD_IP);
+		else
+			scsi_host_set_guard_type(hpnt, SCSI_DIF_GUARD_CRC);
+	}
+#endif
+
         error = scsi_add_host(hpnt, &sdbg_host->dev);
         if (error) {
                 printk(KERN_ERR "%s: scsi_add_host failed\n", __FUNCTION__);


