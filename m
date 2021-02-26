Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D931FC433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 08:38:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D23464EE7
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 08:38:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbhBZIhR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Feb 2021 03:37:17 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:52835 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbhBZIgP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Feb 2021 03:36:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614328574; x=1645864574;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XzEuJ0bjvB4QfBo7WhmbY0snmseA3+UXNSyqutCePg8=;
  b=Gmxf0cKwl3q4XMsgDVWcVgnMWYXghDGMLPxC6ztKfwio/LjK3PSvyLuq
   h5ls2zx/lQkZnbFMOJqebicDkkWh+cKOhNqCtrtNnKnNTq8TnwSZnAleD
   rI7/0HVWIX63gcxjbtb6Pqqg2L4UrTFPpq28Cme8Swe/aDAy3CnfXjpKE
   bkC1ipu+PGQk7s9bkZpblqtMgk4dwXHweR+AvDq6X0xvJ4A2vgln05/4R
   ZeroZK2RDJ2ewxqDP5HftcwiiuUe563Eyvl1akuY2GfuEEStjywgb10vj
   ub6gh/dKcxk4vF9iItqFoGQZ8RmqHJufWQHYeepEjwsZ125ebWP4BAp9T
   A==;
IronPort-SDR: 9ArIrNgnBMUrnr/JcY22SXplFz8nDi5R2t1XTq/neigbXRuKil/O5dMct36wv4aTFaLma0K4/d
 WSpwD3jfa672HeyigeSYQf1RtuU9QK7eX3QUsUv0+UkH63Dx02NO6Wn0CKE4iym5pnp8Wwaqa3
 0v3eZ4dnBRXXFTFsA916uEqmnuBwUKlQOMY+zWX7/TtkmHo/TJNFnXUHw8c1dpBdZf5qaHsYZC
 BRR5T1qZyA8EvGe2nRXtZ+KTIZpGcqd7bvN1higmJ0meQcuPAEJaMDPzr/JvW/oZaP4xKE12GQ
 T64=
X-IronPort-AV: E=Sophos;i="5.81,208,1610380800"; 
   d="scan'208";a="160859719"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 26 Feb 2021 16:35:09 +0800
IronPort-SDR: 331hAUSDZ7jS8/y7jdpssfw83nohfKEMU8jhbdWJlPwvIbJVXMJ1hTcAieQUXyFY6eu9OShW7k
 uxZcyJWkpzYkNH/RI5ORNhDFd69P5QrOGjoz7p2dSjNMiyDrqaNADivLDX3e2J84HfoM14emOs
 K8lbBzW0EpSK8DtfaT+wcB0KKvV+AuEUnY7MBxyPRN5g6bfhzmhzdeMngdaTlV/MDsFQW2uCaR
 cS6xZHgjQMMext3g8zuPLFgSGljY2BUocAE/TOigVbzOLg0RWeBtc6bQoOA3P4hjreZe/zOtlH
 OK6gU+E7fEeZk5LZcpkGq6tT
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2021 00:18:22 -0800
IronPort-SDR: u3qggXPBISht++ka76ehj0azDnjwaC51rtxDICy0fNdeQkJqrjLo9ddLsgaPRMzVAItKt4TsDA
 yBhfidZzp8rlh06tWwuuUq5Tux7J+mBiGLX2ZDYg53WWe9LOb0spCJWmQDwCxoNZ4rlv3YvfCh
 bzzN725JcjIp/rV38CHMwhjcWZIkGV6/ngddPnpfl2GnC0tvGt8LcViJGCZQUQh+9XOb8H7A9X
 cBwZJN2DPovvSB3Z9F9QZmDlvjMcTQaU/KCRR0sirOisr0Zk0fwtR/RgAoNkOni/kgnO+/r4ZK
 GU0=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 26 Feb 2021 00:35:05 -0800
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
Subject: [PATCH v4 9/9] scsi: ufshpb: Make host mode parameters configurable
Date:   Fri, 26 Feb 2021 10:33:00 +0200
Message-Id: <20210226083300.30934-10-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210226083300.30934-1-avri.altman@wdc.com>
References: <20210226083300.30934-1-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We can make use of this commit, to elaborate some more of the host
control mode logic, explaining what role play each and every variable.

While at it, allow those parameters to be configurable.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 Documentation/ABI/testing/sysfs-driver-ufs |  67 ++++++
 drivers/scsi/ufs/ufshpb.c                  | 253 +++++++++++++++++++--
 drivers/scsi/ufs/ufshpb.h                  |  18 ++
 3 files changed, 324 insertions(+), 14 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index 0017eaf89cbe..d9eca371c507 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -1322,3 +1322,70 @@ Description:	This entry shows the maximum HPB data size for using single HPB
 		===  ========
 
 		The file is read only.
+
+What:		/sys/class/scsi_device/*/device/hpb_param_sysfs/activation_thld
+Date:		February 2021
+Contact:	Avri Altman <avri.altman@wdc.com>
+Description:	In host control mode, reads are the major source of activation
+		trials.  once this threshold hs met, the region is added to the
+		"to-be-activated" list.  Since we reset the read counter upon
+		write, this include sending a rb command updating the region
+		ppn as well.
+
+What:		/sys/class/scsi_device/*/device/hpb_param_sysfs/normalization_factor
+Date:		February 2021
+Contact:	Avri Altman <avri.altman@wdc.com>
+Description:	In host control mode, We think of the regions as "buckets".
+		Those buckets are being filled with reads, and emptied on write.
+		We use entries_per_srgn - the amount of blocks in a subregion as
+		our bucket size.  This applies because HPB1.0 only concern a
+		single-block reads.  Once the bucket size is crossed, we trigger
+		a normalization work - not only to avoid overflow, but mainly
+		because we want to keep those counters normalized, as we are
+		using those reads as a comparative score, to make various decisions.
+		The normalization is dividing (shift right) the read counter by
+		the normalization_factor. If during consecutive normalizations
+		an active region has exhaust its reads - inactivate it.
+
+What:		/sys/class/scsi_device/*/device/hpb_param_sysfs/eviction_thld_enter
+Date:		February 2021
+Contact:	Avri Altman <avri.altman@wdc.com>
+Description:	Region deactivation is often due to the fact that eviction took
+		place: a region become active on the expense of another. This is
+		happening when the max-active-regions limit has crossed.
+		In host mode, eviction is considered an extreme measure. We
+		want to verify that the entering region has enough reads, and
+		the exiting region has much less reads.  eviction_thld_enter is
+		the min reads that a region must have in order to be considered
+		as a candidate to evict other region.
+
+What:		/sys/class/scsi_device/*/device/hpb_param_sysfs/eviction_thld_exit
+Date:		February 2021
+Contact:	Avri Altman <avri.altman@wdc.com>
+Description:	same as above for the exiting region. A region is consider to
+		be a candidate to be evicted, only if it has less reads than
+		eviction_thld_exit.
+
+What:		/sys/class/scsi_device/*/device/hpb_param_sysfs/read_timeout_ms
+Date:		February 2021
+Contact:	Avri Altman <avri.altman@wdc.com>
+Description:	In order not to hang on to “cold” regions, we shall inactivate
+		a region that has no READ access for a predefined amount of
+		time - read_timeout_ms. If read_timeout_ms has expired, and the
+		region is dirty - it is less likely that we can make any use of
+		HPB-READing it.  So we inactivate it.  Still, deactivation has
+		its overhead, and we may still benefit from HPB-READing this
+		region if it is clean - see read_timeout_expiries.
+
+What:		/sys/class/scsi_device/*/device/hpb_param_sysfs/read_timeout_expiries
+Date:		February 2021
+Contact:	Avri Altman <avri.altman@wdc.com>
+Description:	if the region read timeout has expired, but the region is clean,
+		just re-wind its timer for another spin.  Do that as long as it
+		is clean and did not exhaust its read_timeout_expiries threshold.
+
+What:		/sys/class/scsi_device/*/device/hpb_param_sysfs/timeout_polling_interval_ms
+Date:		February 2021
+Contact:	Avri Altman <avri.altman@wdc.com>
+Description:	the frequency in which the delayed worker that checks the
+		read_timeouts is awaken.
diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 86f4720f4f0d..7387c6d0f663 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -17,7 +17,6 @@
 #include "../sd.h"
 
 #define ACTIVATION_THRESHOLD 4 /* 4 IOs */
-#define EVICTION_THRESHOLD (ACTIVATION_THRESHOLD << 6) /* 256 IOs */
 #define READ_TO_MS 1000
 #define READ_TO_EXPIRIES 100
 #define POLLING_INTERVAL_MS 200
@@ -642,7 +641,7 @@ int ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		 */
 		spin_lock_irqsave(&rgn->rgn_lock, flags);
 		rgn->reads++;
-		if (rgn->reads == ACTIVATION_THRESHOLD)
+		if (rgn->reads == hpb->params.activation_thld)
 			activate = true;
 		spin_unlock_irqrestore(&rgn->rgn_lock, flags);
 		if (activate ||
@@ -1035,6 +1034,7 @@ static void ufshpb_read_to_handler(struct work_struct *work)
 	struct victim_select_info *lru_info;
 	struct ufshpb_region *rgn;
 	unsigned long flags;
+	unsigned int poll;
 	LIST_HEAD(expired_list);
 
 	hpb = container_of(dwork, struct ufshpb_lu, ufshpb_read_to_work);
@@ -1056,7 +1056,7 @@ static void ufshpb_read_to_handler(struct work_struct *work)
 				list_add(&rgn->list_expired_rgn, &expired_list);
 			else
 				rgn->read_timeout = ktime_add_ms(ktime_get(),
-							 READ_TO_MS);
+						hpb->params.read_timeout_ms);
 		}
 	}
 
@@ -1074,8 +1074,9 @@ static void ufshpb_read_to_handler(struct work_struct *work)
 
 	clear_bit(TIMEOUT_WORK_PENDING, &hpb->work_data_bits);
 
+	poll = hpb->params.timeout_polling_interval_ms;
 	schedule_delayed_work(&hpb->ufshpb_read_to_work,
-			      msecs_to_jiffies(POLLING_INTERVAL_MS));
+			      msecs_to_jiffies(poll));
 }
 
 static void ufshpb_add_lru_info(struct victim_select_info *lru_info,
@@ -1085,8 +1086,11 @@ static void ufshpb_add_lru_info(struct victim_select_info *lru_info,
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
 
@@ -1115,7 +1119,8 @@ static struct ufshpb_region *ufshpb_victim_lru_info(struct ufshpb_lu *hpb)
 		 * in host control mode, verify that the exiting region
 		 * has less reads
 		 */
-		if (hpb->is_hcm && rgn->reads > (EVICTION_THRESHOLD >> 1))
+		if (hpb->is_hcm &&
+		    rgn->reads > hpb->params.eviction_thld_exit)
 			continue;
 
 		victim_rgn = rgn;
@@ -1346,7 +1351,8 @@ static int ufshpb_add_region(struct ufshpb_lu *hpb, struct ufshpb_region *rgn)
 			 * in host control mode, verify that the entering
 			 * region has enough reads
 			 */
-			if (hpb->is_hcm && rgn->reads < EVICTION_THRESHOLD) {
+			if (hpb->is_hcm &&
+			    rgn->reads < hpb->params.eviction_thld_enter) {
 				ret = -EACCES;
 				goto out;
 			}
@@ -1696,8 +1702,10 @@ static void ufshpb_normalization_work_handler(struct work_struct *work)
 {
 	struct ufshpb_lu *hpb;
 	int rgn_idx;
+	u8 factor;
 
 	hpb = container_of(work, struct ufshpb_lu, ufshpb_normalization_work);
+	factor = hpb->params.normalization_factor;
 
 	for (rgn_idx = 0; rgn_idx < hpb->rgns_per_lu; rgn_idx++) {
 		struct ufshpb_region *rgn = hpb->rgn_tbl + rgn_idx;
@@ -1706,7 +1714,7 @@ static void ufshpb_normalization_work_handler(struct work_struct *work)
 			unsigned long flags;
 
 			spin_lock_irqsave(&rgn->rgn_lock, flags);
-			rgn->reads = (rgn->reads >> 1);
+			rgn->reads = (rgn->reads >> factor);
 			spin_unlock_irqrestore(&rgn->rgn_lock, flags);
 		}
 
@@ -2028,8 +2036,216 @@ requeue_timeout_ms_store(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RW(requeue_timeout_ms);
 
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
+static void ufshpb_hcm_param_init(struct ufshpb_lu *hpb)
+{
+	hpb->params.activation_thld = ACTIVATION_THRESHOLD;
+	hpb->params.normalization_factor = 1;
+	hpb->params.eviction_thld_enter = (ACTIVATION_THRESHOLD << 6);
+	hpb->params.eviction_thld_exit = (ACTIVATION_THRESHOLD << 5);
+	hpb->params.read_timeout_ms = READ_TO_MS;
+	hpb->params.read_timeout_expiries = READ_TO_EXPIRIES;
+	hpb->params.timeout_polling_interval_ms = POLLING_INTERVAL_MS;
+}
+
 static struct attribute *hpb_dev_param_attrs[] = {
 	&dev_attr_requeue_timeout_ms.attr,
+	&dev_attr_activation_thld.attr,
+	&dev_attr_normalization_factor.attr,
+	&dev_attr_eviction_thld_enter.attr,
+	&dev_attr_eviction_thld_exit.attr,
+	&dev_attr_read_timeout_ms.attr,
+	&dev_attr_read_timeout_expiries.attr,
+	&dev_attr_timeout_polling_interval_ms.attr,
 	NULL,
 };
 
@@ -2104,6 +2320,8 @@ static void ufshpb_stat_init(struct ufshpb_lu *hpb)
 static void ufshpb_param_init(struct ufshpb_lu *hpb)
 {
 	hpb->params.requeue_timeout_ms = HPB_REQUEUE_TIME_MS;
+	if (hpb->is_hcm)
+		ufshpb_hcm_param_init(hpb);
 }
 
 static int ufshpb_lu_hpb_init(struct ufs_hba *hba, struct ufshpb_lu *hpb)
@@ -2160,9 +2378,13 @@ static int ufshpb_lu_hpb_init(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 	ufshpb_stat_init(hpb);
 	ufshpb_param_init(hpb);
 
-	if (hpb->is_hcm)
+	if (hpb->is_hcm) {
+		unsigned int poll;
+
+		poll = hpb->params.timeout_polling_interval_ms;
 		schedule_delayed_work(&hpb->ufshpb_read_to_work,
-				      msecs_to_jiffies(POLLING_INTERVAL_MS));
+				      msecs_to_jiffies(poll));
+	}
 
 	return 0;
 
@@ -2342,10 +2564,13 @@ void ufshpb_resume(struct ufs_hba *hba)
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
index 8d14f01b0e7b..9703fe9807ad 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -180,8 +180,26 @@ struct victim_select_info {
 	atomic_t active_cnt;
 };
 
+/**
+ * ufshpb_params - ufs hpb parameters
+ * @requeue_timeout_ms - requeue threshold of wb command (0x2)
+ * @activation_thld - min reads [IOs] to activate/update a region
+ * @normalization_factor - shift right the region's reads
+ * @eviction_thld_enter - min reads [IOs] for the entering region in eviction
+ * @eviction_thld_exit - max reads [IOs] for the exiting region in eviction
+ * @read_timeout_ms - timeout [ms] from the last read IO to the region
+ * @read_timeout_expiries - amount of allowable timeout expireis
+ * @timeout_polling_interval_ms - frequency in which timeouts are checked
+ */
 struct ufshpb_params {
 	unsigned int requeue_timeout_ms;
+	unsigned int activation_thld;
+	unsigned int normalization_factor;
+	unsigned int eviction_thld_enter;
+	unsigned int eviction_thld_exit;
+	unsigned int read_timeout_ms;
+	unsigned int read_timeout_expiries;
+	unsigned int timeout_polling_interval_ms;
 };
 
 struct ufshpb_stats {
-- 
2.25.1

