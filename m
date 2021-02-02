Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAB1BC433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 08:33:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A85564DA5
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 08:33:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232731AbhBBIdP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Feb 2021 03:33:15 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:42154 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232556AbhBBIcr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Feb 2021 03:32:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612254765; x=1643790765;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/CXkI06zrTCTDCLIGSit9yI0yNHWnYJP68CgDGiaPi4=;
  b=i8pOVeInKgaI1KRLQ+4OPcE9Ag8bAHdw4jSANsnfks0+WN+KyE+QE8QP
   N4iky6cRqVRXgtjLmEekyWzoNI1d3CtAbLoJjKxndUBhvvYEdY+arn0M/
   ECidODTia8IFtRVItOp/StiX1vyQxdhD8sVh3vF4ePNGIu98gxs66/bla
   5Gffer2br+iW8770VvCyGoYN1Z0gQ/uBTwwkavJAreWNcknl1BPk5CqEW
   tOYyY0Vp0eTKAsK3puKcHThIROMqLzOTQoDgaSCAm7gCMFNoNXjJluLzL
   E+sGCRw6H6IJ8uaOzElacjT2xKaOOY4tGnV8wkjwqqBoSo1dpePO4+8Mo
   Q==;
IronPort-SDR: NvHZjNaseUiBxn5uyVlHNzbiwoPXG28ipj+fYtUW7NQ61v6BjX0ikGlYnSX89zEwF09tjQ14Qb
 xm3Bzjf31y/40LmpHw67f1fwQucdP2W+E3IRJRvc7NI/M3niAC8QIYH8C2FMGUkaNMsmrZit6u
 ujjGVnn7q2BMqkfYyaZ/G9FPmH1aV/lZS/1NqWzaOAZ+lImNwbpWy8jFsADl+eGmwY8pWUEqSv
 5UVhwd1zu02JcJf3rncbLCP1QZ5eWJPo3EBUrXxDlPIMNJutG7A6gNO7G8BA1b6oyDLl6RXCnr
 +TQ=
X-IronPort-AV: E=Sophos;i="5.79,394,1602518400"; 
   d="scan'208";a="160083631"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 02 Feb 2021 16:31:58 +0800
IronPort-SDR: /hzAcCydIV7/Qpni2XANgMV9oo2cesNR66IFmDVo3kkKIrIHgWiiGrM6ICA6FbRYqmoXASuMyl
 wP5zlFKBDFND68oopGzdy5xrm4AjfuEJ4/zWVhlWDcEl2TUkxFPw7QiqyipEaMZqQqzA8vtDa8
 VW6yj25BHN6r85bdkbGhwk3Bg8bFyYOhaIsSsnUzJDyUy5t0nYsGq3czs2xEOJIKSqHq/24daC
 WYf9m5cFERpKzeKeC9tfybk4K/5+VzoJ/IKdLMP5ji587YD4o2rE3zaVXx3XqOc/8dFdsOFcxc
 FbJUH9tG+uJVC83Q74s3EwmR
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 00:16:06 -0800
IronPort-SDR: z1VJcjcPSmCfRBBKoi5UGFY0ZX7IMKOz/Z+pJEBNrd14MWmi8KVp2RomlqeT4fb6ck5+rpqXA6
 WwkBkwsh7CyTA/G7CgrSCC/TRu6MzL2ejYRfq48c0ZQWt3tHQFbebqrwEPxRWSsx7vIDIaJ20t
 bwgEkmKmTXtElo3RRY6gWu3yWEDg6hithYv/bVbmOvmbu8KRHWisiHetv13JQLeR7DcArF1h8W
 /fdJ2RwaHtLmIHUhLxrzBL0CmtASpqL+3/eXfaSU66WYwkYK8KSPr5sN9M4pJUqYQtSj67JLlp
 hqM=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 02 Feb 2021 00:31:54 -0800
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        alim.akhtar@samsung.com, asutoshd@codeaurora.org,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <avi.shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>, cang@codeaurora.org,
        stanley.chu@mediatek.com, Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v2 9/9] scsi: ufshpb: Make host mode parameters configurable
Date:   Tue,  2 Feb 2021 10:30:07 +0200
Message-Id: <20210202083007.104050-10-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210202083007.104050-1-avri.altman@wdc.com>
References: <20210202083007.104050-1-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We can make use of this commit, to elaborate some more of the host
control mode logic, explaining what role play each and every variable:

 - activation_thld - In host control mode, reads are the major source of
    activation trials.  once this threshold hs met, the region is added
    to the "to-be-activated" list.  Since we reset the read counter upon
    write, this include sending a rb command updating the region ppn as
    well.

- normalization_factor - We think of the regions as "buckets".  Those
    buckets are being filled with reads, and emptied on write.  We use
    entries_per_srgn - the amount of blocks in a subregion as our bucket
    size.  This applies because HPB1.0 only concern a single-block
    reads.  Once the bucket size is crossed, we trigger a normalization
    work - not only to avoid overflow, but mainly because we want to
    keep those counters normalized, as we are using those reads as a
    comparative score, to make various decisions. The normalization is
    dividing (shift right) the read counter by the normalization_factor.
    If during consecutive normalizations an active region has exhaust
    its reads - inactivate it.

- eviction_thld_enter - Region deactivation is often due to the fact
    that eviction took place: a region become active on the expense of
    another. This is happening when the max-active-regions limit has
    crossed. In host mode, eviction is considered an extreme measure.
    We want to verify that the entering region has enough reads, and the
    exiting region has much less reads.  eviction_thld_enter is the min
    reads that a region must have in order to be considered as a
    candidate to evict other region.

- eviction_thld_exit - same as above for the exiting region.  A region
    is consider to be a candidate to be evicted, only if it has less
    reads than eviction_thld_exit.

 - read_timeout_ms - In order not to hang on to “cold” regions, we
    shall inactivate a region that has no READ access for a predefined
    amount of time - read_timeout_ms. If read_timeout_ms has expired,
    and the region is dirty - it is less likely that we can make any
    use of HPB-READing it.  So we inactivate it.  Still, deactivation
    has its overhead, and we may still benefit from HPB-READing this
    region if it is clean - see read_timeout_expiries.

- read_timeout_expiries - if the region read timeout has expired, but
    the region is clean, just re-wind its timer for another spin.  Do
    that as long as it is clean and did not exhaust its
    read_timeout_expiries threshold.

- timeout_polling_interval_ms - the frequency in which the delayed
    worker that checks the read_timeouts is awaken.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufshcd.c |   1 +
 drivers/scsi/ufs/ufshpb.c | 284 +++++++++++++++++++++++++++++++++++---
 drivers/scsi/ufs/ufshpb.h |  22 +++
 3 files changed, 290 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 1b521b366067..8dac66783c46 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8014,6 +8014,7 @@ static const struct attribute_group *ufshcd_driver_groups[] = {
 	&ufs_sysfs_lun_attributes_group,
 #ifdef CONFIG_SCSI_UFS_HPB
 	&ufs_sysfs_hpb_stat_group,
+	&ufs_sysfs_hpb_param_group,
 #endif
 	NULL,
 };
diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index cec6f641a103..69a742acf0ee 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -351,7 +351,7 @@ void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		 */
 		spin_lock_irqsave(&rgn->rgn_lock, flags);
 		rgn->reads++;
-		if (rgn->reads == ACTIVATION_THRSHLD)
+		if (rgn->reads == hpb->params.activation_thld)
 			activate = true;
 		spin_unlock_irqrestore(&rgn->rgn_lock, flags);
 		if (activate ||
@@ -687,6 +687,7 @@ static void ufshpb_read_to_handler(struct work_struct *work)
 	struct victim_select_info *lru_info;
 	struct ufshpb_region *rgn;
 	unsigned long flags;
+	unsigned int poll;
 	LIST_HEAD(expired_list);
 
 	hpb = container_of(dwork, struct ufshpb_lu, ufshpb_read_to_work);
@@ -713,8 +714,9 @@ static void ufshpb_read_to_handler(struct work_struct *work)
 		if (dirty || expired)
 			list_add(&rgn->list_expired_rgn, &expired_list);
 		else
-			rgn->read_timeout = ktime_add_ms(ktime_get(),
-							 READ_TO_MS);
+			rgn->read_timeout =
+				ktime_add_ms(ktime_get(),
+					     hpb->params.read_timeout_ms);
 	}
 
 	spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
@@ -729,8 +731,9 @@ static void ufshpb_read_to_handler(struct work_struct *work)
 
 	clear_bit(TIMEOUT_WORK_PENDING, &hpb->work_data_bits);
 
+	poll = hpb->params.timeout_polling_interval_ms;
 	schedule_delayed_work(&hpb->ufshpb_read_to_work,
-			      msecs_to_jiffies(POLLING_INTERVAL_MS));
+			      msecs_to_jiffies(poll));
 }
 
 static void ufshpb_add_lru_info(struct victim_select_info *lru_info,
@@ -740,8 +743,11 @@ static void ufshpb_add_lru_info(struct victim_select_info *lru_info,
 	list_add_tail(&rgn->list_lru_rgn, &lru_info->lh_lru_rgn);
 	atomic_inc(&lru_info->active_cnt);
 	if (rgn->hpb->is_hcm) {
-		rgn->read_timeout = ktime_add_ms(ktime_get(), READ_TO_MS);
-		rgn->read_timeout_expiries = READ_TO_EXPIRIES;
+		rgn->read_timeout =
+			ktime_add_ms(ktime_get(),
+				     rgn->hpb->params.read_timeout_ms);
+		rgn->read_timeout_expiries =
+			rgn->hpb->params.read_timeout_expiries;
 	}
 }
 
@@ -765,7 +771,8 @@ static struct ufshpb_region *ufshpb_victim_lru_info(struct ufshpb_lu *hpb)
 		 * in host control mode, verify that the exiting region
 		 * has less reads
 		 */
-		if (hpb->is_hcm && rgn->reads > (EVICTION_THRSHLD >> 1))
+		if (hpb->is_hcm &&
+		    rgn->reads > hpb->params.eviction_thld_exit)
 			continue;
 
 		victim_rgn = rgn;
@@ -979,7 +986,8 @@ static int ufshpb_add_region(struct ufshpb_lu *hpb, struct ufshpb_region *rgn)
 			 * in host control mode, verify that the entering
 			 * region has enough reads
 			 */
-			if (hpb->is_hcm && rgn->reads < EVICTION_THRSHLD) {
+			if (hpb->is_hcm &&
+			    rgn->reads < hpb->params.eviction_thld_enter) {
 				ret = -EACCES;
 				goto out;
 			}
@@ -1306,8 +1314,10 @@ static void ufshpb_normalization_work_handler(struct work_struct *work)
 {
 	struct ufshpb_lu *hpb;
 	int rgn_idx;
+	u8 factor;
 
 	hpb = container_of(work, struct ufshpb_lu, ufshpb_normalization_work);
+	factor = hpb->params.normalization_factor;
 
 	for (rgn_idx = 0; rgn_idx < hpb->rgns_per_lu; rgn_idx++) {
 		struct ufshpb_region *rgn = hpb->rgn_tbl + rgn_idx;
@@ -1316,7 +1326,7 @@ static void ufshpb_normalization_work_handler(struct work_struct *work)
 			unsigned long flags;
 
 			spin_lock_irqsave(&rgn->rgn_lock, flags);
-			rgn->reads = (rgn->reads >> 1);
+			rgn->reads = (rgn->reads >> factor);
 			spin_unlock_irqrestore(&rgn->rgn_lock, flags);
 		}
 
@@ -1546,6 +1556,238 @@ static void ufshpb_destroy_region_tbl(struct ufshpb_lu *hpb)
 }
 
 /* SYSFS functions */
+#define ufshpb_sysfs_param_show_func(__name)				\
+static ssize_t __name##_show(struct device *dev,			\
+	struct device_attribute *attr, char *buf)			\
+{									\
+	struct scsi_device *sdev = to_scsi_device(dev);			\
+	struct ufshpb_lu *hpb = ufshpb_get_hpb_data(sdev);		\
+	if (!hpb)							\
+		return -ENODEV;						\
+	if (!hpb->is_hcm)						\
+		return -EOPNOTSUPP;					\
+									\
+	return sysfs_emit(buf, "%d\n", hpb->params.__name);		\
+}
+
+
+ufshpb_sysfs_param_show_func(activation_thld);
+static ssize_t
+activation_thld_store(struct device *dev, struct device_attribute *attr,
+		      const char *buf, size_t count)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct ufshpb_lu *hpb = ufshpb_get_hpb_data(sdev);
+	int val;
+
+	if (!hpb)
+		return -ENODEV;
+
+	if (!hpb->is_hcm)
+		return -EOPNOTSUPP;
+
+	if (kstrtouint(buf, 0, &val))
+		return -EINVAL;
+
+	if (val <= 0)
+		return -EINVAL;
+
+	hpb->params.activation_thld = val;
+
+	return count;
+}
+static DEVICE_ATTR_RW(activation_thld);
+
+ufshpb_sysfs_param_show_func(normalization_factor);
+static ssize_t
+normalization_factor_store(struct device *dev, struct device_attribute *attr,
+			   const char *buf, size_t count)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct ufshpb_lu *hpb = ufshpb_get_hpb_data(sdev);
+	int val;
+
+	if (!hpb)
+		return -ENODEV;
+
+	if (!hpb->is_hcm)
+		return -EOPNOTSUPP;
+
+	if (kstrtouint(buf, 0, &val))
+		return -EINVAL;
+
+	if (val <= 0 || val > ilog2(hpb->entries_per_srgn))
+		return -EINVAL;
+
+	hpb->params.normalization_factor = val;
+
+	return count;
+}
+static DEVICE_ATTR_RW(normalization_factor);
+
+ufshpb_sysfs_param_show_func(eviction_thld_enter);
+static ssize_t
+eviction_thld_enter_store(struct device *dev, struct device_attribute *attr,
+			  const char *buf, size_t count)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct ufshpb_lu *hpb = ufshpb_get_hpb_data(sdev);
+	int val;
+
+	if (!hpb)
+		return -ENODEV;
+
+	if (!hpb->is_hcm)
+		return -EOPNOTSUPP;
+
+	if (kstrtouint(buf, 0, &val))
+		return -EINVAL;
+
+	if (val <= hpb->params.eviction_thld_exit)
+		return -EINVAL;
+
+	hpb->params.eviction_thld_enter = val;
+
+	return count;
+}
+static DEVICE_ATTR_RW(eviction_thld_enter);
+
+ufshpb_sysfs_param_show_func(eviction_thld_exit);
+static ssize_t
+eviction_thld_exit_store(struct device *dev, struct device_attribute *attr,
+			 const char *buf, size_t count)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct ufshpb_lu *hpb = ufshpb_get_hpb_data(sdev);
+	int val;
+
+	if (!hpb)
+		return -ENODEV;
+
+	if (!hpb->is_hcm)
+		return -EOPNOTSUPP;
+
+	if (kstrtouint(buf, 0, &val))
+		return -EINVAL;
+
+	if (val <= hpb->params.activation_thld)
+		return -EINVAL;
+
+	hpb->params.eviction_thld_exit = val;
+
+	return count;
+}
+static DEVICE_ATTR_RW(eviction_thld_exit);
+
+ufshpb_sysfs_param_show_func(read_timeout_ms);
+static ssize_t
+read_timeout_ms_store(struct device *dev, struct device_attribute *attr,
+		      const char *buf, size_t count)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct ufshpb_lu *hpb = ufshpb_get_hpb_data(sdev);
+	int val;
+
+	if (!hpb)
+		return -ENODEV;
+
+	if (!hpb->is_hcm)
+		return -EOPNOTSUPP;
+
+	if (kstrtouint(buf, 0, &val))
+		return -EINVAL;
+
+	if (val <= 0)
+		return -EINVAL;
+
+	hpb->params.read_timeout_ms = val;
+
+	return count;
+}
+static DEVICE_ATTR_RW(read_timeout_ms);
+
+ufshpb_sysfs_param_show_func(read_timeout_expiries);
+static ssize_t
+read_timeout_expiries_store(struct device *dev, struct device_attribute *attr,
+			    const char *buf, size_t count)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct ufshpb_lu *hpb = ufshpb_get_hpb_data(sdev);
+	int val;
+
+	if (!hpb)
+		return -ENODEV;
+
+	if (!hpb->is_hcm)
+		return -EOPNOTSUPP;
+
+	if (kstrtouint(buf, 0, &val))
+		return -EINVAL;
+
+	if (val <= 0)
+		return -EINVAL;
+
+	hpb->params.read_timeout_expiries = val;
+
+	return count;
+}
+static DEVICE_ATTR_RW(read_timeout_expiries);
+
+ufshpb_sysfs_param_show_func(timeout_polling_interval_ms);
+static ssize_t
+timeout_polling_interval_ms_store(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t count)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct ufshpb_lu *hpb = ufshpb_get_hpb_data(sdev);
+	int val;
+
+	if (!hpb)
+		return -ENODEV;
+
+	if (!hpb->is_hcm)
+		return -EOPNOTSUPP;
+
+	if (kstrtouint(buf, 0, &val))
+		return -EINVAL;
+
+	if (val <= 0)
+		return -EINVAL;
+
+	hpb->params.timeout_polling_interval_ms = val;
+
+	return count;
+}
+static DEVICE_ATTR_RW(timeout_polling_interval_ms);
+
+static struct attribute *hpb_dev_param_attrs[] = {
+	&dev_attr_activation_thld.attr,
+	&dev_attr_normalization_factor.attr,
+	&dev_attr_eviction_thld_enter.attr,
+	&dev_attr_eviction_thld_exit.attr,
+	&dev_attr_read_timeout_ms.attr,
+	&dev_attr_read_timeout_expiries.attr,
+	&dev_attr_timeout_polling_interval_ms.attr,
+	NULL,
+};
+
+struct attribute_group ufs_sysfs_hpb_param_group = {
+	.name = "hpb_param_sysfs",
+	.attrs = hpb_dev_param_attrs,
+};
+
+static void ufshpb_param_init(struct ufshpb_lu *hpb)
+{
+	hpb->params.activation_thld = ACTIVATION_THRSHLD;
+	hpb->params.normalization_factor = 1;
+	hpb->params.eviction_thld_enter = (ACTIVATION_THRSHLD << 6);
+	hpb->params.eviction_thld_exit = (ACTIVATION_THRSHLD << 5);
+	hpb->params.read_timeout_ms = READ_TO_MS;
+	hpb->params.read_timeout_expiries = READ_TO_EXPIRIES;
+	hpb->params.timeout_polling_interval_ms = POLLING_INTERVAL_MS;
+}
+
 #define ufshpb_sysfs_attr_show_func(__name)				\
 static ssize_t __name##_show(struct device *dev,			\
 	struct device_attribute *attr, char *buf)			\
@@ -1568,7 +1810,7 @@ ufshpb_sysfs_attr_show_func(rb_inactive_cnt);
 ufshpb_sysfs_attr_show_func(map_req_cnt);
 ufshpb_sysfs_attr_show_func(umap_req_cnt);
 
-static struct attribute *hpb_dev_attrs[] = {
+static struct attribute *hpb_dev_stat_attrs[] = {
 	&dev_attr_hit_cnt.attr,
 	&dev_attr_miss_cnt.attr,
 	&dev_attr_rb_noti_cnt.attr,
@@ -1580,8 +1822,8 @@ static struct attribute *hpb_dev_attrs[] = {
 };
 
 struct attribute_group ufs_sysfs_hpb_stat_group = {
-	.name = "hpb_sysfs",
-	.attrs = hpb_dev_attrs,
+	.name = "hpb_stat_sysfs",
+	.attrs = hpb_dev_stat_attrs,
 };
 
 static void ufshpb_stat_init(struct ufshpb_lu *hpb)
@@ -1641,9 +1883,14 @@ static int ufshpb_lu_hpb_init(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 
 	ufshpb_stat_init(hpb);
 
-	if (hpb->is_hcm)
+	if (hpb->is_hcm) {
+		unsigned int poll;
+
+		ufshpb_param_init(hpb);
+		poll = hpb->params.timeout_polling_interval_ms;
 		schedule_delayed_work(&hpb->ufshpb_read_to_work,
-				      msecs_to_jiffies(POLLING_INTERVAL_MS));
+				      msecs_to_jiffies(poll));
+	}
 
 	return 0;
 
@@ -1818,10 +2065,13 @@ void ufshpb_resume(struct ufs_hba *hba)
 			continue;
 		ufshpb_set_state(hpb, HPB_PRESENT);
 		ufshpb_kick_map_work(hpb);
-		if (hpb->is_hcm)
-			schedule_delayed_work(&hpb->ufshpb_read_to_work,
-				msecs_to_jiffies(POLLING_INTERVAL_MS));
+		if (hpb->is_hcm) {
+			unsigned int poll =
+				hpb->params.timeout_polling_interval_ms;
 
+			schedule_delayed_work(&hpb->ufshpb_read_to_work,
+				msecs_to_jiffies(poll));
+		}
 	}
 }
 
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index 207925cf1f44..fafc64943c53 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -160,6 +160,26 @@ struct victim_select_info {
 	atomic_t active_cnt;
 };
 
+/**
+ * ufshpb_params - parameters for host control logic
+ * @activation_thld - min reads [IOs] to activate/update a region
+ * @normalization_factor - shift right the region's reads
+ * @eviction_thld_enter - min reads [IOs] for the entering region in eviction
+ * @eviction_thld_exit - max reads [IOs] for the exiting region in eviction
+ * @read_timeout_ms - timeout [ms] from the last read IO to the region
+ * @read_timeout_expiries - amount of allowable timeout expireis
+ * @timeout_polling_interval_ms - frequency in which timeouts are checked
+ */
+struct ufshpb_params {
+	unsigned int activation_thld;
+	unsigned int normalization_factor;
+	unsigned int eviction_thld_enter;
+	unsigned int eviction_thld_exit;
+	unsigned int read_timeout_ms;
+	unsigned int read_timeout_expiries;
+	unsigned int timeout_polling_interval_ms;
+};
+
 struct ufshpb_stats {
 	u64 hit_cnt;
 	u64 miss_cnt;
@@ -212,6 +232,7 @@ struct ufshpb_lu {
 	bool is_hcm;
 
 	struct ufshpb_stats stats;
+	struct ufshpb_params params;
 
 	struct kmem_cache *map_req_cache;
 	struct kmem_cache *m_page_cache;
@@ -251,6 +272,7 @@ bool ufshpb_is_allowed(struct ufs_hba *hba);
 void ufshpb_get_geo_info(struct ufs_hba *hba, u8 *geo_buf);
 void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf);
 extern struct attribute_group ufs_sysfs_hpb_stat_group;
+extern struct attribute_group ufs_sysfs_hpb_param_group;
 #endif
 
 #endif /* End of Header */
-- 
2.25.1

