Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72FD0C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Feb 2021 16:57:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11F3364EAF
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Feb 2021 16:57:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234079AbhBRQ5A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Feb 2021 11:57:00 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:27864 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233453AbhBRNYS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Feb 2021 08:24:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613654657; x=1645190657;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Cg4R6lPvpmjc/V6U/nOVqcAzVVRyIiN6xKAxSzeRWrc=;
  b=RiMF3JvmnvwgG8fRZbXbd/ZwoNDF0C4bkFSEMfQV/8EL6EQwYOKIH+DU
   0jtzcY99ilhdEbZrQZTF87Jgh+9Sd8/fapKSG+i04BEoihmwjfvRxVQhH
   vQf5ieQFFoqhPxQO0UpYfanUys5jp2nKoqLVQyt98uO7d2Tu2gmMDtX28
   LoLarETWCxBdE8B/yvEfmeXlqa5fRy30EVnfJjXjkZ8Sc4m5Ye0jh66fH
   X/4HjlA+Sju4pKaXqpCl+w2bxNy212itwmiaa0OAli2ul6GHWTUFxFju7
   ZAsAtrIJCSBo33ekeoO3wLKjcFS2++egHac5y13DpMvyJtuuWKhusPkLl
   Q==;
IronPort-SDR: sIgLyUjDU6Ak+rGrrkz2+qcG4cMFtNkJiZAyzfjmH0R2MTjAHwr/Ivg2v1L85o8UIpZccy58mb
 tXtnLk4dQWew0qQrEapP/fGskGWmJ7RZx4Tk4RCL/XHWwr1ORgZTkSI5dcfht7VvVZe3ui5hRb
 XtsnnY43G/2M4CoKwCJkvX2VUOUyQpxWItHSmkEXR44DiekNm1bQdjNDXYwHVGhi/bZmS5780I
 Kw8Q3x48m/JXf8Szvc6wPvwx30BqHvIn+SQt/7V6WGeIOHnIFXqU3qXvcO/M4svZ9KAjUT6VGF
 /Mo=
X-IronPort-AV: E=Sophos;i="5.81,187,1610380800"; 
   d="scan'208";a="161433419"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 18 Feb 2021 21:21:48 +0800
IronPort-SDR: xchwWR4HfZvUCyOsewVN2huRALI6dEasuhumnuM5v1fI6z0a6UWawCGNg5YfH7zhn7PooK7m6F
 iTQDK7zaciGxnsdFB9tqlomOpOBRgOP9pKHbn1K40EUrn0e12e9pExiksGsgOsyIwkXRGtURvq
 j3p2+k01I0rZF56idnc+72WQ95U4Mp2qX6/gCQhBZhI+o8fOxbn6oWMJ87FMJs1d2hdWvFG8q3
 rncO2HJGwPOkCkPWalqBBGJVWlyIOPHb1mArXoWjGi5noRoqON02LH1A/BRNAZ5h6xnRG8J40T
 jD3eK7OJ+cLh/4ptnVupXK++
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2021 05:05:14 -0800
IronPort-SDR: PQ0Bx+BNJ3Rt9ocpY6SeS3zyOoqOqIkqbdvPuBqgfEY4hG/hgg+4anIu1cYfzWEniNydtBhdiH
 q/rLWRDe8PTYPUYXQVH/a0C0vqjg2JTsJzl6r91TQM/i+iilHJ7i+FqosBz1g+R3YSAauCA+bG
 w9Jr7HBxtTtUXGqnmi42NUGOwAoP+Yjd5dVGNXkqzdJJgfsR1hjyLLX1x5dYmbm9dZudAOOgMJ
 TO/mYlfd0Dv5gPrr8ChrcWrpymSiIVW8tW1i2I8PMqppjavgk2wl7FlyJkl15K7AE7k+fQJnhp
 HiE=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 18 Feb 2021 05:21:43 -0800
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
Subject: [PATCH v3 9/9] scsi: ufshpb: Make host mode parameters configurable
Date:   Thu, 18 Feb 2021 15:19:32 +0200
Message-Id: <20210218131932.106997-10-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210218131932.106997-1-avri.altman@wdc.com>
References: <20210218131932.106997-1-avri.altman@wdc.com>
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
 Documentation/ABI/testing/sysfs-driver-ufs |  68 ++++++
 drivers/scsi/ufs/ufshpb.c                  | 254 +++++++++++++++++++--
 drivers/scsi/ufs/ufshpb.h                  |  18 ++
 3 files changed, 326 insertions(+), 14 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index 0017eaf89cbe..1d72201c4953 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -1322,3 +1322,71 @@ Description:	This entry shows the maximum HPB data size for using single HPB
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
+>>>>>>> ef6bf08e666d... scsi: ufshpb: Make host mode parameters configurable
diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 2c0f63a828ca..44069974f627 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -17,7 +17,6 @@
 #include "../sd.h"
 
 #define ACTIVATION_THRESHOLD 4 /* 4 IOs */
-#define EVICTION_THRESHOLD (ACTIVATION_THRESHOLD << 6) /* 256 IOs */
 #define READ_TO_MS 1000
 #define READ_TO_EXPIRIES 100
 #define POLLING_INTERVAL_MS 200
@@ -658,7 +657,7 @@ int ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		 */
 		spin_lock_irqsave(&rgn->rgn_lock, flags);
 		rgn->reads++;
-		if (rgn->reads == ACTIVATION_THRESHOLD)
+		if (rgn->reads == hpb->params.activation_thld)
 			activate = true;
 		spin_unlock_irqrestore(&rgn->rgn_lock, flags);
 		if (activate ||
@@ -1039,6 +1038,7 @@ static void ufshpb_read_to_handler(struct work_struct *work)
 	struct victim_select_info *lru_info;
 	struct ufshpb_region *rgn;
 	unsigned long flags;
+	unsigned int poll;
 	LIST_HEAD(expired_list);
 
 	hpb = container_of(dwork, struct ufshpb_lu, ufshpb_read_to_work);
@@ -1060,7 +1060,7 @@ static void ufshpb_read_to_handler(struct work_struct *work)
 				list_add(&rgn->list_expired_rgn, &expired_list);
 			else
 				rgn->read_timeout = ktime_add_ms(ktime_get(),
-							 READ_TO_MS);
+						hpb->params.read_timeout_ms);
 		}
 	}
 
@@ -1076,8 +1076,9 @@ static void ufshpb_read_to_handler(struct work_struct *work)
 
 	clear_bit(TIMEOUT_WORK_PENDING, &hpb->work_data_bits);
 
+	poll = hpb->params.timeout_polling_interval_ms;
 	schedule_delayed_work(&hpb->ufshpb_read_to_work,
-			      msecs_to_jiffies(POLLING_INTERVAL_MS));
+			      msecs_to_jiffies(poll));
 }
 
 static void ufshpb_add_lru_info(struct victim_select_info *lru_info,
@@ -1087,8 +1088,11 @@ static void ufshpb_add_lru_info(struct victim_select_info *lru_info,
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
 
@@ -1112,7 +1116,8 @@ static struct ufshpb_region *ufshpb_victim_lru_info(struct ufshpb_lu *hpb)
 		 * in host control mode, verify that the exiting region
 		 * has less reads
 		 */
-		if (hpb->is_hcm && rgn->reads > (EVICTION_THRESHOLD >> 1))
+		if (hpb->is_hcm &&
+		    rgn->reads > hpb->params.eviction_thld_exit)
 			continue;
 
 		victim_rgn = rgn;
@@ -1326,7 +1331,8 @@ static int ufshpb_add_region(struct ufshpb_lu *hpb, struct ufshpb_region *rgn)
 			 * in host control mode, verify that the entering
 			 * region has enough reads
 			 */
-			if (hpb->is_hcm && rgn->reads < EVICTION_THRESHOLD) {
+			if (hpb->is_hcm &&
+			    rgn->reads < hpb->params.eviction_thld_enter) {
 				ret = -EACCES;
 				goto out;
 			}
@@ -1646,8 +1652,10 @@ static void ufshpb_normalization_work_handler(struct work_struct *work)
 {
 	struct ufshpb_lu *hpb;
 	int rgn_idx;
+	u8 factor;
 
 	hpb = container_of(work, struct ufshpb_lu, ufshpb_normalization_work);
+	factor = hpb->params.normalization_factor;
 
 	for (rgn_idx = 0; rgn_idx < hpb->rgns_per_lu; rgn_idx++) {
 		struct ufshpb_region *rgn = hpb->rgn_tbl + rgn_idx;
@@ -1656,7 +1664,7 @@ static void ufshpb_normalization_work_handler(struct work_struct *work)
 			unsigned long flags;
 
 			spin_lock_irqsave(&rgn->rgn_lock, flags);
-			rgn->reads = (rgn->reads >> 1);
+			rgn->reads = (rgn->reads >> factor);
 			spin_unlock_irqrestore(&rgn->rgn_lock, flags);
 		}
 
@@ -1979,8 +1987,217 @@ requeue_timeout_ms_store(struct device *dev, struct device_attribute *attr,
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
+	NULL,
 };
 
 struct attribute_group ufs_sysfs_hpb_param_group = {
@@ -2054,6 +2271,8 @@ static void ufshpb_stat_init(struct ufshpb_lu *hpb)
 static void ufshpb_param_init(struct ufshpb_lu *hpb)
 {
 	hpb->params.requeue_timeout_ms = HPB_REQUEUE_TIME_MS;
+	if (hpb->is_hcm)
+		ufshpb_hcm_param_init(hpb);
 }
 
 static int ufshpb_lu_hpb_init(struct ufs_hba *hba, struct ufshpb_lu *hpb)
@@ -2110,9 +2329,13 @@ static int ufshpb_lu_hpb_init(struct ufs_hba *hba, struct ufshpb_lu *hpb)
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
 
@@ -2292,10 +2515,13 @@ void ufshpb_resume(struct ufs_hba *hba)
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
index 75093271d12b..bfb5eff9a66a 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -178,8 +178,26 @@ struct victim_select_info {
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

