From: <kgudipat@brocade.com>
Subject: [RFC - PATCH 1/3] SCSI: Implement LUN Masking in SCSI mid-layer.
Date: Fri, 10 Aug 2012 19:35:34 -0700
Message-ID: <1344652534-13995-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:43542 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752447Ab2HKCg2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Aug 2012 22:36:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org, revers@redhat.com, michaelc@cs.wisc.edu, hch@infradead.org
Cc: adapter_linux_open_src_team@brocade.com, amathur@brocade.com, Krishna Gudipati <kgudipat@brocade.com>

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:
	- Added new attributes to scsi_target and scsi_device structures to
	  hold the list of luns to be masked, LUN Masking feature state per LUN
	  and per scsi_target.
	- Introduced a new status flag SCSI_SCAN_MASK_LUN, which is used during
	  SCSI scan to skip adding a LUN, that is not part of the scsi_target
	  LUN mask list and continue scanning rest of the LUNs.
	- Introduced a new structure scsi_mask_lun - which is used to queue the
	  luns to be masked to the scsi_target masked_lun_list.
	- Introduced APIs to add or remove LUNs from SCSI target masked_lun_list
	  that can be used by the LLD.
	- Introduced an API to dynamically enable/disable LUN Masking per target
	- Made changes to the SCSI scan code to support LUN Masking:
	  a) If LUN Masking is enabled on a target, for each newly discovered
	     LUN before calling scsi_add_lun() we iterate through the list of
	     LUNs that are part of masked_lun_list (to be made visible) and
	     invoke scsi_add_lun() only if the LUN is part of the masked_lun_list.
	  b) LUNs that are not part of the masked_lun_list will be deleted using
	     a call to scsi_remove_device().
	  c) If a LUN is not part of masked_lun_list and deleted, the routine
	     scsi_probe_and_add_lun() will return the status to be SCSI_SCAN_MASK_LUN
	  d) The status SCSI_SCAN_MASK_LUN will be interpreted as to skip adding
	     this LUN and still continue with the scsi scan for rest of the LUNs that
	     are part of the REPORT_LUNS response.
	  e) Made changes to support dynamic LUN masking config change, to remove a
	     scsi_device already attached or to add a new scsi_device not part of the
	     initial scan.
	- Made changes to free the populated LUN mask list in scsi_target_destroy().
	- Made changes to avoid freeing the scsi_target structure if there are no
	  devices discovered as part of the scan, since this is the LLD LUN Masking
	  state holder when LUN Masking is enabled from LLD.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/scsi_scan.c   |  251 ++++++++++++++++++++++++++++++++++++++++++--
 include/scsi/scsi.h        |    8 ++
 include/scsi/scsi_device.h |    9 ++
 3 files changed, 259 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index d947ffc..1d600687 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -76,6 +76,7 @@
 #define SCSI_SCAN_NO_RESPONSE		0
 #define SCSI_SCAN_TARGET_PRESENT	1
 #define SCSI_SCAN_LUN_PRESENT		2
+#define SCSI_SCAN_MASK_LUN		3
 
 static const char *scsi_null_device_strs = "nullnullnullnull";
 
@@ -318,6 +319,8 @@ static void scsi_target_destroy(struct scsi_target *starget)
 {
 	struct device *dev = &starget->dev;
 	struct Scsi_Host *shost = dev_to_shost(dev->parent);
+	struct list_head *qe, *qen;
+	struct scsi_mask_lun *mlun;
 	unsigned long flags;
 
 	transport_destroy_device(dev);
@@ -325,6 +328,14 @@ static void scsi_target_destroy(struct scsi_target *starget)
 	if (shost->hostt->target_destroy)
 		shost->hostt->target_destroy(starget);
 	list_del_init(&starget->siblings);
+	if (!list_empty(&starget->masked_lun_list)) {
+		list_for_each_safe(qe, qen, &starget->masked_lun_list) {
+			mlun = (struct scsi_mask_lun *)qe;
+			list_del(&mlun->list_entry);
+			kfree(mlun);
+		}
+		list_del_init(&starget->masked_lun_list);
+	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	put_device(dev);
 }
@@ -411,6 +422,7 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	starget->can_queue = 0;
 	INIT_LIST_HEAD(&starget->siblings);
 	INIT_LIST_HEAD(&starget->devices);
+	INIT_LIST_HEAD(&starget->masked_lun_list);
 	starget->state = STARGET_CREATED;
 	starget->scsi_level = SCSI_2;
 	starget->max_target_blocked = SCSI_DEFAULT_TARGET_BLOCKED;
@@ -499,6 +511,160 @@ void scsi_target_reap(struct scsi_target *starget)
 }
 
 /**
+ * scsi_target_mask_lun() - add a LUN to the lun masking (to be visible) list
+ * when lun masking is enabled on this target.
+ * @shost:	Scsi_Host 
+ * @channel:	target channel number (zero if no channels)
+ * @target_id:	target id number
+ * @lun:	LUN number to be masked (made visible).
+ *
+ * Description:
+ *	LLD will call this API to add a LUN that needs to be masked/made visible
+ *	The LUN info is queued to the starget->masked_lun_list which is used
+ *	during the SCSI scan to either make this LUN visible or skip adding it
+ *	to the sysfs/remove the device.
+ *
+ * Return value:
+ *	Returns 0 on success.
+ */
+int scsi_target_mask_lun(struct Scsi_Host *shost, int channel,
+			 int target_id, unsigned int lun)
+{
+	struct device *parent = &shost->shost_gendev;
+	struct scsi_target *starget;
+	const int size = sizeof(struct scsi_mask_lun);
+	struct scsi_mask_lun *sm_lun, *mlun;
+	unsigned long flags;
+	unsigned int is_duplicate = 0, ret = 0;
+
+	sm_lun = kzalloc(size, GFP_KERNEL);
+	if (!sm_lun) {
+		printk(KERN_ERR "%s: allocation failure\n", __func__);
+		return -ENOMEM;
+	}
+
+	int_to_scsilun(lun, &sm_lun->mask_lun);
+	spin_lock_irqsave(shost->host_lock, flags);
+	starget = __scsi_find_target(parent, channel, target_id);
+	if (!starget) {
+		spin_unlock_irqrestore(shost->host_lock, flags);
+		kfree(sm_lun);
+		return -ENXIO;
+	}
+
+	if (list_empty(&starget->masked_lun_list))
+		list_add_tail(&sm_lun->list_entry, &starget->masked_lun_list);
+	else {
+		/* Check for any duplicate entries */
+		list_for_each_entry(mlun, &starget->masked_lun_list, list_entry) {
+			if (mlun && (scsilun_to_int(&mlun->mask_lun) == lun)) {
+				is_duplicate = 1;
+				ret = -EEXIST;
+				break;
+			}
+		}
+
+		if (!is_duplicate)
+			list_add_tail(&sm_lun->list_entry, &starget->masked_lun_list);
+	}
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL(scsi_target_mask_lun);
+
+/**
+ * scsi_target_unmask_lun() - Removes LUN from lun masking (to be visible) list
+ * when lun masking is enabled on this target.
+ * @shost:      Scsi_Host
+ * @channel:    target channel number (zero if no channels)
+ * @target_id:  target id number
+ * @lun:        LUN number to be masked (made visible).
+ *
+ * Description:
+ *	LLD will call this API to remove a LUN that is already present in the
+ *	LUN masking list to make this device invisible in subsequent scan.
+ *	The LUN info is removed to the starget->masked_lun_list which is used
+ *	during the SCSI scan to either make this LUN visible or skip adding it
+ *	to the sysfs/remove the device.
+ *
+ * Return value:
+ *	Returns 0 on success.
+ */
+int scsi_target_unmask_lun(struct Scsi_Host *shost, int channel,
+			   int target_id, unsigned int lun)
+{
+	struct device *parent = &shost->shost_gendev;
+	struct scsi_target *starget;
+	struct scsi_mask_lun *mlun;
+	unsigned long flags;
+	unsigned int found = 0, ret = 0;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	starget = __scsi_find_target(parent, channel, target_id);
+	if (!starget) {
+		spin_unlock_irqrestore(shost->host_lock, flags);
+		return -ENXIO;
+	}
+
+	if (!list_empty(&starget->masked_lun_list)) {
+		list_for_each_entry(mlun, &starget->masked_lun_list, list_entry) {
+			if (mlun && (scsilun_to_int(&mlun->mask_lun) == lun)) {
+				found = 1;
+				list_del(&mlun->list_entry);
+				break;
+			}
+		}
+	}
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	if (!found)
+		ret = -ENXIO;
+
+	return ret;
+}
+EXPORT_SYMBOL(scsi_target_unmask_lun);
+
+/**
+ * scsi_target_config_lunmask() - API to enable/disable LUN Masking
+ * @shost:      Scsi_Host
+ * @channel:    target channel number (zero if no channels)
+ * @target_id:  target id number
+ * @masking_config:	1 - enable / 0 - disable LUN masking
+ *
+ * Description:
+ *	LLD will call this API to either enable or disable LUN Masking.
+ *
+ * Return value:
+ *      Returns 0 on success.
+ */
+int scsi_target_config_lunmask(struct Scsi_Host *shost, int channel,
+			       int target_id, int masking_config)
+{
+	struct device *parent = &shost->shost_gendev;
+	struct scsi_target *starget;
+	unsigned int rc = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	starget = __scsi_find_target(parent, channel, target_id);
+	if (!starget) {
+		spin_unlock_irqrestore(shost->host_lock, flags);
+		rc= -ENXIO;
+		goto out;
+	}
+
+	if (masking_config)
+		starget->is_lm_enabled = 1;
+	else
+		starget->is_lm_enabled = 0;
+	spin_unlock_irqrestore(shost->host_lock, flags);
+out:
+	return rc;
+}
+EXPORT_SYMBOL(scsi_target_config_lunmask);
+
+/**
  * sanitize_inquiry_string - remove non-graphical chars from an INQUIRY result string
  * @s: INQUIRY result string to sanitize
  * @len: length of the string
@@ -1005,6 +1171,8 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 	unsigned char *result;
 	int bflags, res = SCSI_SCAN_NO_RESPONSE, result_len = 256;
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct scsi_mask_lun *mlun;
+	unsigned long flags;
 
 	/*
 	 * The rescan flag is used as an optimization, the first scan of a
@@ -1012,10 +1180,39 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 	 */
 	sdev = scsi_device_lookup_by_target(starget, lun);
 	if (sdev) {
+		sdev->is_masked = 0;
 		if (rescan || !scsi_device_created(sdev)) {
 			SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO
 				"scsi scan: device exists on %s\n",
 				dev_name(&sdev->sdev_gendev)));
+
+			spin_lock_irqsave(shost->host_lock, flags);
+			if (starget->is_lm_enabled) {
+				if (!list_empty(&starget->masked_lun_list)) {
+					list_for_each_entry(mlun, &starget->masked_lun_list,
+							    list_entry) {
+						if (mlun && (scsilun_to_int(&mlun->mask_lun) == lun)) {
+							sdev->is_masked = 1;
+							break;
+						}
+					}
+				}
+				spin_unlock_irqrestore(shost->host_lock, flags);
+
+				if (!sdev->is_masked) {
+					if (!sdevp)
+						scsi_device_put(sdev);
+
+					if (bflagsp)
+						*bflagsp = scsi_get_device_flags(sdev,
+									sdev->vendor,
+									sdev->model);
+					__scsi_remove_device(sdev);
+					return SCSI_SCAN_MASK_LUN;
+				}
+			} else
+				spin_unlock_irqrestore(shost->host_lock, flags);
+
 			if (sdevp)
 				*sdevp = sdev;
 			else
@@ -1043,6 +1240,25 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 
 	if (bflagsp)
 		*bflagsp = bflags;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	if (starget->is_lm_enabled) {
+		if (!list_empty(&starget->masked_lun_list)) {
+			list_for_each_entry(mlun, &starget->masked_lun_list, list_entry) {
+				if (mlun && (scsilun_to_int(&mlun->mask_lun) == lun)) {
+					sdev->is_masked = 1;
+					break;
+				}
+			}
+		}
+		spin_unlock_irqrestore(shost->host_lock, flags);
+		if (!sdev->is_masked) {
+			res = SCSI_SCAN_MASK_LUN;
+			goto out_free_result;
+		}
+	} else
+		spin_unlock_irqrestore(shost->host_lock, flags);
+
 	/*
 	 * result contains valid SCSI INQUIRY data.
 	 */
@@ -1152,6 +1368,7 @@ static void scsi_sequential_lun_scan(struct scsi_target *starget,
 {
 	unsigned int sparse_lun, lun, max_dev_lun;
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	int res = 0;
 
 	SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: Sequential scan of"
 				    "%s\n", dev_name(&starget->dev)));
@@ -1208,11 +1425,14 @@ static void scsi_sequential_lun_scan(struct scsi_target *starget,
 	 * until we reach the max, or no LUN is found and we are not
 	 * sparse_lun.
 	 */
-	for (lun = 1; lun < max_dev_lun; ++lun)
-		if ((scsi_probe_and_add_lun(starget, lun, NULL, NULL, rescan,
-					    NULL) != SCSI_SCAN_LUN_PRESENT) &&
-		    !sparse_lun)
+	for (lun = 1; lun < max_dev_lun; ++lun) {
+		res = scsi_probe_and_add_lun(starget, lun, NULL, NULL, rescan,
+					    NULL);
+		if (res == SCSI_SCAN_MASK_LUN)
+			continue;
+		else if (res != SCSI_SCAN_LUN_PRESENT && !sparse_lun)
 			return;
+	}
 }
 
 /**
@@ -1474,7 +1694,9 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 
 			res = scsi_probe_and_add_lun(starget,
 				lun, NULL, NULL, rescan, NULL);
-			if (res == SCSI_SCAN_NO_RESPONSE) {
+			if (res == SCSI_SCAN_MASK_LUN)
+				continue;
+			else if (res == SCSI_SCAN_NO_RESPONSE) {
 				/*
 				 * Got some results, but now none, abort.
 				 */
@@ -1567,6 +1789,7 @@ static void __scsi_scan_target(struct device *parent, unsigned int channel,
 	int bflags = 0;
 	int res;
 	struct scsi_target *starget;
+	unsigned long flags;
 
 	if (shost->this_id == id)
 		/*
@@ -1592,7 +1815,8 @@ static void __scsi_scan_target(struct device *parent, unsigned int channel,
 	 * would not configure LUN 0 until all LUNs are scanned.
 	 */
 	res = scsi_probe_and_add_lun(starget, 0, &bflags, NULL, rescan, NULL);
-	if (res == SCSI_SCAN_LUN_PRESENT || res == SCSI_SCAN_TARGET_PRESENT) {
+	if (res == SCSI_SCAN_LUN_PRESENT || res == SCSI_SCAN_TARGET_PRESENT ||
+	    res == SCSI_SCAN_MASK_LUN) {
 		if (scsi_report_lun_scan(starget, bflags, rescan) != 0)
 			/*
 			 * The REPORT LUN did not scan the target,
@@ -1605,9 +1829,18 @@ static void __scsi_scan_target(struct device *parent, unsigned int channel,
  out_reap:
 	scsi_autopm_put_target(starget);
 	/* now determine if the target has any children at all
-	 * and if not, nuke it */
-	scsi_target_reap(starget);
-
+	 * and if not, nuke it
+	 *
+	 * Note: If LUN Masking is enabled don't delete the starget as this is the
+	 * 	 LLD LUN Masking state holder.
+	 */
+	if (!starget->is_lm_enabled)
+		scsi_target_reap(starget);
+	else {
+		spin_lock_irqsave(shost->host_lock, flags);
+		starget->reap_ref--;
+		spin_unlock_irqrestore(shost->host_lock, flags);
+	}
 	put_device(&starget->dev);
 }
 
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index c6f0974..d0f3b8d 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -361,6 +361,14 @@ struct scsi_lun {
 };
 
 /*
+ * Scsi Mask Lun.
+ */
+struct scsi_mask_lun {
+	struct list_head list_entry;
+	struct scsi_lun mask_lun;
+};
+
+/*
  * The Well Known LUNS (SAM-3) in our int representation of a LUN
  */
 #define SCSI_W_LUN_BASE 0xc100
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 7539f52..6c82f6d 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -155,6 +155,7 @@ struct scsi_device {
 	unsigned try_rc_10_first:1;	/* Try READ_CAPACACITY_10 first */
 	unsigned is_visible:1;	/* is the device visible in sysfs */
 	unsigned wce_default_on:1;	/* Cache is ON by default */
+	unsigned is_masked:1;
 
 	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
 	struct list_head event_list;	/* asserted events */
@@ -241,6 +242,8 @@ struct scsi_target {
 	struct scsi_device	*starget_sdev_user;
 	struct list_head	siblings;
 	struct list_head	devices;
+	struct list_head	masked_lun_list;
+	unsigned int		is_lm_enabled;
 	struct device		dev;
 	unsigned int		reap_ref; /* protected by the host lock */
 	unsigned int		channel;
@@ -390,6 +393,12 @@ extern int scsi_execute_req(struct scsi_device *sdev, const unsigned char *cmd,
 			    int data_direction, void *buffer, unsigned bufflen,
 			    struct scsi_sense_hdr *, int timeout, int retries,
 			    int *resid);
+extern int scsi_target_mask_lun(struct Scsi_Host *shost, int channel,
+				int target_id, unsigned int lun);
+extern int scsi_target_unmask_lun(struct Scsi_Host *shost, int channel,
+				  int target_id, unsigned int lun);
+extern int scsi_target_config_lunmask(struct Scsi_Host *shost, int channel,
+				      int target_id, int masking_config);
 
 #ifdef CONFIG_PM_RUNTIME
 extern int scsi_autopm_get_device(struct scsi_device *);
-- 
1.7.3.rc1

