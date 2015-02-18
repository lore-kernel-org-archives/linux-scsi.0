From: Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/4] scsi_debug: define pr_fmt() for consistent logging
Date: Thu, 19 Feb 2015 00:31:36 +0200
Message-ID: <1424298699-2581-2-git-send-email-tomas.winkler@intel.com>
References: <1424298699-2581-1-git-send-email-tomas.winkler@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:42097 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752340AbbBRWdQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Feb 2015 17:33:16 -0500
In-Reply-To: <1424298699-2581-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley\"" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>

Use pr_fmt with both module name and __func__
Also drop few bare printk leftovers

The log format should stay pretty much intact

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/scsi/scsi_debug.c | 118 +++++++++++++++++++++-------------------------
 1 file changed, 53 insertions(+), 65 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 8bcf6ad0d765..14e73f27c27f 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -25,6 +25,9 @@
  *        module options to "modprobe scsi_debug num_tgts=2" [20021221]
  */
 
+
+#define pr_fmt(fmt) KBUILD_MODNAME ":%s: " fmt, __func__
+
 #include <linux/module.h>
 
 #include <linux/kernel.h>
@@ -2450,8 +2453,7 @@ static int dif_verify(struct sd_dif_tuple *sdt, const void *data,
 	__be16 csum = dif_compute_csum(data, scsi_debug_sector_size);
 
 	if (sdt->guard_tag != csum) {
-		pr_err("%s: GUARD check failed on sector %lu rcvd 0x%04x, data 0x%04x\n",
-			__func__,
+		pr_err("GUARD check failed on sector %lu rcvd 0x%04x, data 0x%04x\n",
 			(unsigned long)sector,
 			be16_to_cpu(sdt->guard_tag),
 			be16_to_cpu(csum));
@@ -2459,14 +2461,14 @@ static int dif_verify(struct sd_dif_tuple *sdt, const void *data,
 	}
 	if (scsi_debug_dif == SD_DIF_TYPE1_PROTECTION &&
 	    be32_to_cpu(sdt->ref_tag) != (sector & 0xffffffff)) {
-		pr_err("%s: REF check failed on sector %lu\n",
-			__func__, (unsigned long)sector);
+		pr_err("REF check failed on sector %lu\n",
+			(unsigned long)sector);
 		return 0x03;
 	}
 	if (scsi_debug_dif == SD_DIF_TYPE2_PROTECTION &&
 	    be32_to_cpu(sdt->ref_tag) != ei_lba) {
-		pr_err("%s: REF check failed on sector %lu\n",
-			__func__, (unsigned long)sector);
+		pr_err("REF check failed on sector %lu\n",
+			(unsigned long)sector);
 		return 0x03;
 	}
 	return 0;
@@ -3453,7 +3455,7 @@ static void sdebug_q_cmd_complete(unsigned long indx)
 	atomic_inc(&sdebug_completions);
 	qa_indx = indx;
 	if ((qa_indx < 0) || (qa_indx >= SCSI_DEBUG_CANQUEUE)) {
-		pr_err("%s: wild qa_indx=%d\n", __func__, qa_indx);
+		pr_err("wild qa_indx=%d\n", qa_indx);
 		return;
 	}
 	spin_lock_irqsave(&queued_arr_lock, iflags);
@@ -3461,21 +3463,21 @@ static void sdebug_q_cmd_complete(unsigned long indx)
 	scp = sqcp->a_cmnd;
 	if (NULL == scp) {
 		spin_unlock_irqrestore(&queued_arr_lock, iflags);
-		pr_err("%s: scp is NULL\n", __func__);
+		pr_err("scp is NULL\n");
 		return;
 	}
 	devip = (struct sdebug_dev_info *)scp->device->hostdata;
 	if (devip)
 		atomic_dec(&devip->num_in_q);
 	else
-		pr_err("%s: devip=NULL\n", __func__);
+		pr_err("devip=NULL\n");
 	if (atomic_read(&retired_max_queue) > 0)
 		retiring = 1;
 
 	sqcp->a_cmnd = NULL;
 	if (!test_and_clear_bit(qa_indx, queued_in_use_bm)) {
 		spin_unlock_irqrestore(&queued_arr_lock, iflags);
-		pr_err("%s: Unexpected completion\n", __func__);
+		pr_err("Unexpected completion\n");
 		return;
 	}
 
@@ -3485,7 +3487,7 @@ static void sdebug_q_cmd_complete(unsigned long indx)
 		retval = atomic_read(&retired_max_queue);
 		if (qa_indx >= retval) {
 			spin_unlock_irqrestore(&queued_arr_lock, iflags);
-			pr_err("%s: index %d too large\n", __func__, retval);
+			pr_err("index %d too large\n", retval);
 			return;
 		}
 		k = find_last_bit(queued_in_use_bm, retval);
@@ -3513,7 +3515,7 @@ sdebug_q_cmd_hrt_complete(struct hrtimer *timer)
 	atomic_inc(&sdebug_completions);
 	qa_indx = sd_hrtp->qa_indx;
 	if ((qa_indx < 0) || (qa_indx >= SCSI_DEBUG_CANQUEUE)) {
-		pr_err("%s: wild qa_indx=%d\n", __func__, qa_indx);
+		pr_err("wild qa_indx=%d\n", qa_indx);
 		goto the_end;
 	}
 	spin_lock_irqsave(&queued_arr_lock, iflags);
@@ -3521,21 +3523,21 @@ sdebug_q_cmd_hrt_complete(struct hrtimer *timer)
 	scp = sqcp->a_cmnd;
 	if (NULL == scp) {
 		spin_unlock_irqrestore(&queued_arr_lock, iflags);
-		pr_err("%s: scp is NULL\n", __func__);
+		pr_err("scp is NULL\n");
 		goto the_end;
 	}
 	devip = (struct sdebug_dev_info *)scp->device->hostdata;
 	if (devip)
 		atomic_dec(&devip->num_in_q);
 	else
-		pr_err("%s: devip=NULL\n", __func__);
+		pr_err("devip=NULL\n");
 	if (atomic_read(&retired_max_queue) > 0)
 		retiring = 1;
 
 	sqcp->a_cmnd = NULL;
 	if (!test_and_clear_bit(qa_indx, queued_in_use_bm)) {
 		spin_unlock_irqrestore(&queued_arr_lock, iflags);
-		pr_err("%s: Unexpected completion\n", __func__);
+		pr_err("Unexpected completion\n");
 		goto the_end;
 	}
 
@@ -3545,7 +3547,7 @@ sdebug_q_cmd_hrt_complete(struct hrtimer *timer)
 		retval = atomic_read(&retired_max_queue);
 		if (qa_indx >= retval) {
 			spin_unlock_irqrestore(&queued_arr_lock, iflags);
-			pr_err("%s: index %d too large\n", __func__, retval);
+			pr_err("index %d too large\n", retval);
 			goto the_end;
 		}
 		k = find_last_bit(queued_in_use_bm, retval);
@@ -3584,7 +3586,7 @@ static struct sdebug_dev_info * devInfoReg(struct scsi_device * sdev)
 		return devip;
 	sdbg_host = *(struct sdebug_host_info **)shost_priv(sdev->host);
 	if (!sdbg_host) {
-		pr_err("%s: Host info NULL\n", __func__);
+		pr_err("Host info NULL\n");
 		return NULL;
         }
 	list_for_each_entry(devip, &sdbg_host->dev_info_list, dev_list) {
@@ -3600,8 +3602,7 @@ static struct sdebug_dev_info * devInfoReg(struct scsi_device * sdev)
 	if (!open_devip) { /* try and make a new one */
 		open_devip = sdebug_device_create(sdbg_host, GFP_ATOMIC);
 		if (!open_devip) {
-			printk(KERN_ERR "%s: out of memory at line %d\n",
-				__func__, __LINE__);
+			pr_err("out of memory at line %d\n", __LINE__);
 			return NULL;
 		}
 	}
@@ -3619,7 +3620,7 @@ static struct sdebug_dev_info * devInfoReg(struct scsi_device * sdev)
 static int scsi_debug_slave_alloc(struct scsi_device *sdp)
 {
 	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
-		printk(KERN_INFO "scsi_debug: slave_alloc <%u %u %u %llu>\n",
+		pr_info("slave_alloc <%u %u %u %llu>\n",
 		       sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
 	queue_flag_set_unlocked(QUEUE_FLAG_BIDI, sdp->request_queue);
 	return 0;
@@ -3630,7 +3631,7 @@ static int scsi_debug_slave_configure(struct scsi_device *sdp)
 	struct sdebug_dev_info *devip;
 
 	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
-		printk(KERN_INFO "scsi_debug: slave_configure <%u %u %u %llu>\n",
+		pr_info("slave_configure <%u %u %u %llu>\n",
 		       sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
 	if (sdp->host->max_cmd_len != SCSI_DEBUG_MAX_CMD_LEN)
 		sdp->host->max_cmd_len = SCSI_DEBUG_MAX_CMD_LEN;
@@ -3650,7 +3651,7 @@ static void scsi_debug_slave_destroy(struct scsi_device *sdp)
 		(struct sdebug_dev_info *)sdp->hostdata;
 
 	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
-		printk(KERN_INFO "scsi_debug: slave_destroy <%u %u %u %llu>\n",
+		pr_info("slave_destroy <%u %u %u %llu>\n",
 		       sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
 	if (devip) {
 		/* make this slot available for re-use */
@@ -3901,8 +3902,7 @@ static void __init sdebug_build_parts(unsigned char *ramp,
 		return;
 	if (scsi_debug_num_parts > SDEBUG_MAX_PARTS) {
 		scsi_debug_num_parts = SDEBUG_MAX_PARTS;
-		pr_warn("%s: reducing partitions to %d\n", __func__,
-			SDEBUG_MAX_PARTS);
+		pr_warn("reducing partitions to %d\n", SDEBUG_MAX_PARTS);
 	}
 	num_sectors = (int)sdebug_store_sectors;
 	sectors_per_part = (num_sectors - sdebug_sectors_per)
@@ -3949,8 +3949,7 @@ schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 	struct scsi_device *sdp = cmnd->device;
 
 	if (NULL == cmnd || NULL == devip) {
-		pr_warn("%s: called with NULL cmnd or devip pointer\n",
-			__func__);
+		pr_warn("called with NULL cmnd or devip pointer\n");
 		/* no particularly good error to report back */
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
@@ -4387,8 +4386,7 @@ static ssize_t fake_rw_store(struct device_driver *ddp, const char *buf,
 
 				fake_storep = vmalloc(sz);
 				if (NULL == fake_storep) {
-					pr_err("%s: out of memory, 9\n",
-					       __func__);
+					pr_err("out of memory, 9\n");
 					return -ENOMEM;
 				}
 				memset(fake_storep, 0, sz);
@@ -4788,8 +4786,7 @@ static int __init scsi_debug_init(void)
 	atomic_set(&retired_max_queue, 0);
 
 	if (scsi_debug_ndelay >= 1000000000) {
-		pr_warn("%s: ndelay must be less than 1 second, ignored\n",
-			__func__);
+		pr_warn("ndelay must be less than 1 second, ignored\n");
 		scsi_debug_ndelay = 0;
 	} else if (scsi_debug_ndelay > 0)
 		scsi_debug_delay = DELAY_OVERRIDDEN;
@@ -4801,8 +4798,7 @@ static int __init scsi_debug_init(void)
 	case 4096:
 		break;
 	default:
-		pr_err("%s: invalid sector_size %d\n", __func__,
-		       scsi_debug_sector_size);
+		pr_err("invalid sector_size %d\n", scsi_debug_sector_size);
 		return -EINVAL;
 	}
 
@@ -4815,29 +4811,28 @@ static int __init scsi_debug_init(void)
 		break;
 
 	default:
-		pr_err("%s: dif must be 0, 1, 2 or 3\n", __func__);
+		pr_err("dif must be 0, 1, 2 or 3\n");
 		return -EINVAL;
 	}
 
 	if (scsi_debug_guard > 1) {
-		pr_err("%s: guard must be 0 or 1\n", __func__);
+		pr_err("guard must be 0 or 1\n");
 		return -EINVAL;
 	}
 
 	if (scsi_debug_ato > 1) {
-		pr_err("%s: ato must be 0 or 1\n", __func__);
+		pr_err("ato must be 0 or 1\n");
 		return -EINVAL;
 	}
 
 	if (scsi_debug_physblk_exp > 15) {
-		pr_err("%s: invalid physblk_exp %u\n", __func__,
-		       scsi_debug_physblk_exp);
+		pr_err("invalid physblk_exp %u\n", scsi_debug_physblk_exp);
 		return -EINVAL;
 	}
 
 	if (scsi_debug_lowest_aligned > 0x3fff) {
-		pr_err("%s: lowest_aligned too big: %u\n", __func__,
-		       scsi_debug_lowest_aligned);
+		pr_err("lowest_aligned too big: %u\n",
+			scsi_debug_lowest_aligned);
 		return -EINVAL;
 	}
 
@@ -4867,7 +4862,7 @@ static int __init scsi_debug_init(void)
 	if (0 == scsi_debug_fake_rw) {
 		fake_storep = vmalloc(sz);
 		if (NULL == fake_storep) {
-			pr_err("%s: out of memory, 1\n", __func__);
+			pr_err("out of memory, 1\n");
 			return -ENOMEM;
 		}
 		memset(fake_storep, 0, sz);
@@ -4881,11 +4876,10 @@ static int __init scsi_debug_init(void)
 		dif_size = sdebug_store_sectors * sizeof(struct sd_dif_tuple);
 		dif_storep = vmalloc(dif_size);
 
-		pr_err("%s: dif_storep %u bytes @ %p\n", __func__, dif_size,
-			dif_storep);
+		pr_err("dif_storep %u bytes @ %p\n", dif_size, dif_storep);
 
 		if (dif_storep == NULL) {
-			pr_err("%s: out of mem. (DIX)\n", __func__);
+			pr_err("out of mem. (DIX)\n");
 			ret = -ENOMEM;
 			goto free_vm;
 		}
@@ -4907,18 +4901,17 @@ static int __init scsi_debug_init(void)
 		if (scsi_debug_unmap_alignment &&
 		    scsi_debug_unmap_granularity <=
 		    scsi_debug_unmap_alignment) {
-			pr_err("%s: ERR: unmap_granularity <= unmap_alignment\n",
-			       __func__);
+			pr_err("ERR: unmap_granularity <= unmap_alignment\n");
 			return -EINVAL;
 		}
 
 		map_size = lba_to_map_index(sdebug_store_sectors - 1) + 1;
 		map_storep = vmalloc(BITS_TO_LONGS(map_size) * sizeof(long));
 
-		pr_info("%s: %lu provisioning blocks\n", __func__, map_size);
+		pr_info("%lu provisioning blocks\n", map_size);
 
 		if (map_storep == NULL) {
-			pr_err("%s: out of mem. (MAP)\n", __func__);
+			pr_err("out of mem. (MAP)\n");
 			ret = -ENOMEM;
 			goto free_vm;
 		}
@@ -4932,18 +4925,18 @@ static int __init scsi_debug_init(void)
 
 	pseudo_primary = root_device_register("pseudo_0");
 	if (IS_ERR(pseudo_primary)) {
-		pr_warn("%s: root_device_register() error\n", __func__);
+		pr_warn("root_device_register() error\n");
 		ret = PTR_ERR(pseudo_primary);
 		goto free_vm;
 	}
 	ret = bus_register(&pseudo_lld_bus);
 	if (ret < 0) {
-		pr_warn("%s: bus_register error: %d\n", __func__, ret);
+		pr_warn("bus_register error: %d\n", ret);
 		goto dev_unreg;
 	}
 	ret = driver_register(&sdebug_driverfs_driver);
 	if (ret < 0) {
-		pr_warn("%s: driver_register error: %d\n", __func__, ret);
+		pr_warn("driver_register error: %d\n", ret);
 		goto bus_unreg;
 	}
 
@@ -4952,16 +4945,14 @@ static int __init scsi_debug_init(void)
 
         for (k = 0; k < host_to_add; k++) {
                 if (sdebug_add_adapter()) {
-			pr_err("%s: sdebug_add_adapter failed k=%d\n",
-				__func__, k);
+			pr_err("sdebug_add_adapter failed k=%d\n", k);
                         break;
                 }
         }
 
-	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts) {
-		pr_info("%s: built %d host(s)\n", __func__,
-			scsi_debug_add_host);
-	}
+	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
+		pr_info("built %d host(s)\n", scsi_debug_add_host);
+
 	return 0;
 
 bus_unreg:
@@ -5016,8 +5007,7 @@ static int sdebug_add_adapter(void)
 
         sdbg_host = kzalloc(sizeof(*sdbg_host),GFP_KERNEL);
         if (NULL == sdbg_host) {
-                printk(KERN_ERR "%s: out of memory at line %d\n",
-                       __func__, __LINE__);
+		pr_err("out of memory at line %d\n", __LINE__);
                 return -ENOMEM;
         }
 
@@ -5027,8 +5017,7 @@ static int sdebug_add_adapter(void)
         for (k = 0; k < devs_per_host; k++) {
 		sdbg_devinfo = sdebug_device_create(sdbg_host, GFP_KERNEL);
 		if (!sdbg_devinfo) {
-                        printk(KERN_ERR "%s: out of memory at line %d\n",
-                               __func__, __LINE__);
+			pr_err("out of memory at line %d\n", __LINE__);
                         error = -ENOMEM;
 			goto clean;
                 }
@@ -5342,7 +5331,7 @@ static int sdebug_driver_probe(struct device * dev)
 		sdebug_driver_template.use_clustering = ENABLE_CLUSTERING;
 	hpnt = scsi_host_alloc(&sdebug_driver_template, sizeof(sdbg_host));
 	if (NULL == hpnt) {
-		pr_err("%s: scsi_host_alloc failed\n", __func__);
+		pr_err("scsi_host_alloc failed\n");
 		error = -ENODEV;
 		return error;
 	}
@@ -5385,7 +5374,7 @@ static int sdebug_driver_probe(struct device * dev)
 
 	scsi_host_set_prot(hpnt, host_prot);
 
-	printk(KERN_INFO "scsi_debug: host protection%s%s%s%s%s%s%s\n",
+	pr_info("host protection%s%s%s%s%s%s%s\n",
 	       (host_prot & SHOST_DIF_TYPE1_PROTECTION) ? " DIF1" : "",
 	       (host_prot & SHOST_DIF_TYPE2_PROTECTION) ? " DIF2" : "",
 	       (host_prot & SHOST_DIF_TYPE3_PROTECTION) ? " DIF3" : "",
@@ -5413,7 +5402,7 @@ static int sdebug_driver_probe(struct device * dev)
 
         error = scsi_add_host(hpnt, &sdbg_host->dev);
         if (error) {
-                printk(KERN_ERR "%s: scsi_add_host failed\n", __func__);
+		pr_err("scsi_add_host failed\n");
                 error = -ENODEV;
 		scsi_host_put(hpnt);
         } else
@@ -5430,8 +5419,7 @@ static int sdebug_driver_remove(struct device * dev)
 	sdbg_host = to_sdebug_host(dev);
 
 	if (!sdbg_host) {
-		printk(KERN_ERR "%s: Unable to locate host info\n",
-		       __func__);
+		pr_err("Unable to locate host info\n");
 		return -ENODEV;
 	}
 
-- 
1.9.3

