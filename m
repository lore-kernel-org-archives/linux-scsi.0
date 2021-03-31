Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19026C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 07:42:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB979619CD
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 07:42:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234232AbhCaHmC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 Mar 2021 03:42:02 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:28275 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234247AbhCaHlf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Mar 2021 03:41:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1617176494; x=1648712494;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=m4MCGdvDSWJMbXIP786fbo35l/6VIK/51peeQuC8zNc=;
  b=lTmWoDqFamWdy7rwqUv1R3WAIcwWwhnB6dUf+EXsf4YBmZBqiZrtePsD
   vhg8Ma7ljsgfJJRGWtU/Bb8R3HcyMA8QmFN+56lCDFiQ67iO8LLkSSh4c
   IsfqWWIQiMKJdzyqTuVhO4yRr9VMaEL8OBQ1NmAomt/YGAodFaNum9BQv
   acKGIOFr3j0z9KMVl6Uk0dtb7WSxLjqcRmfoYFyGG0k6wbl75lEfa9TQH
   gAcwSY1LH6tM8OMU8inCJlbYbLwl+rxT3YnG/oxsxrc/c1YIErjJ7O8al
   9H+cOLiGYOtGSXXtBTRkCNPGwVShDmh4wtLUOM2iUvFBw3IVqVS2cvgkQ
   Q==;
IronPort-SDR: oKdbOeSYjqVqVYlHuY8ZHZ+cYwMF2BP5TyRcq9CT3w3kAPRkRl1T0OAZTVaWpsVKyUs1dsHchg
 mchATr7+WmuC7v28LMmvu6X/fBTuBsKbtqkQdmsHYkpko60upEguPI9Q9LW/0NbdcrHATVIzR4
 xYRqpRIeh/Fwp7czNH0IfIv3IKumw3BYIvvHSqpDkiSJxP56EuaGUdw5cH/AB3+COcrO+0jpsx
 2VB6/pJyBHk+Q0r58+z9316HHdlU3dncXDOj+U9p7LDiud4Fw7CowlVdE9Bgkwh4m8wsXiVQ6f
 Aog=
X-IronPort-AV: E=Sophos;i="5.81,293,1610380800"; 
   d="scan'208";a="163338666"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 31 Mar 2021 15:41:32 +0800
IronPort-SDR: eMNyRS7gveKkvgVTXwMjt7OIVf5/L2tDn/s5dDIaWBn7Rr+kVtZkvr/aIJl5WOxhija+jTJ+6T
 AvqxJryzvFkkoIhM4f1ANMve4ecLubdmD84MEdf25v62cNZkrF0SqkRYrM9HLBx5jVyGQKGDiv
 i0RukjS9cXfWJc5DtWm2FzzdUB719DoeypL9UdtH0nOeOPoWbklvg8Lg1MeUa8Oo/a4yyFI9xe
 w7MAFE53YF0GPkhB/1T7ipKGL5zKKC8a8KMsjKRDbJ7bL0h69QNVoDyS3v08JmiCSNNzd6zjOd
 8elCvCF4lhaTj62/JOZscyn6
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2021 00:23:16 -0700
IronPort-SDR: VT3IuHd4mXnW1KJfkgH8ox6/sSerZIBAPCkQ0I2epUbVxA4HtfLrWAIEh8oROXO/K3ehDJWGPm
 oOGdc/JMuI35jGySk1mJeJlg4Z6JPMQy/JnGZyc9U0bMBIMHF6fKIKti0cy1iXJv15xxOq5PCY
 YyZVdSJ4ImRRSP74h5Z+nMJm2kD7k/DUtaehXnTK+9OrPRjB6j/2FaVRs7m/4c4JrIe/7C3OSU
 zEXGgr6sI1jK447+Tc2uH4Amv7SeYmmHfzbClxoenmUYC6jCMSvoS8e2bE1FBHc9kKjIN2bPzq
 Vp4=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 31 Mar 2021 00:41:28 -0700
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
Subject: [PATCH v7 11/11] scsi: ufshpb: Make host mode parameters configurable
Date:   Wed, 31 Mar 2021 10:39:52 +0300
Message-Id: <20210331073952.102162-12-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210331073952.102162-1-avri.altman@wdc.com>
References: <20210331073952.102162-1-avri.altman@wdc.com>
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
 Documentation/ABI/testing/sysfs-driver-ufs |  84 +++++-
 drivers/scsi/ufs/ufshpb.c                  | 288 +++++++++++++++++++--
 drivers/scsi/ufs/ufshpb.h                  |  20 ++
 3 files changed, 365 insertions(+), 27 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index 419adf450b89..133af2114165 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -1323,14 +1323,76 @@ Description:	This entry shows the maximum HPB data size for using single HPB
 
 		The file is read only.
 
-What:		/sys/bus/platform/drivers/ufshcd/*/flags/wb_enable
-Date:		March 2021
-Contact:	Daejun Park <daejun7.park@samsung.com>
-Description:	This entry shows the status of HPB.
-
-		== ============================
-		0  HPB is not enabled.
-		1  HPB is enabled
-		== ============================
-
-		The file is read only.
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
+
+What:		/sys/class/scsi_device/*/device/hpb_param_sysfs/inflight_map_req
+Date:		February 2021
+Contact:	Avri Altman <avri.altman@wdc.com>
+Description:	in host control mode the host is the originator of map requests.
+		To not flood the device with map requests, use a simple throttling
+		mechanism that limits the number of inflight map requests.
diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 08066bb6da65..c9fa2d9ccc2c 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -17,7 +17,6 @@
 #include "../sd.h"
 
 #define ACTIVATION_THRESHOLD 8 /* 8 IOs */
-#define EVICTION_THRESHOLD (ACTIVATION_THRESHOLD << 5) /* 256 IOs */
 #define READ_TO_MS 1000
 #define READ_TO_EXPIRIES 100
 #define POLLING_INTERVAL_MS 200
@@ -194,7 +193,7 @@ static void ufshpb_iterate_rgn(struct ufshpb_lu *hpb, int rgn_idx, int srgn_idx,
 		} else {
 			srgn->reads++;
 			rgn->reads++;
-			if (srgn->reads == ACTIVATION_THRESHOLD)
+			if (srgn->reads == hpb->params.activation_thld)
 				activate = true;
 		}
 		spin_unlock(&rgn->rgn_lock);
@@ -742,10 +741,11 @@ static struct ufshpb_req *ufshpb_get_map_req(struct ufshpb_lu *hpb,
 	struct bio *bio;
 
 	if (hpb->is_hcm &&
-	    hpb->num_inflight_map_req >= THROTTLE_MAP_REQ_DEFAULT) {
+	    hpb->num_inflight_map_req >= hpb->params.inflight_map_req) {
 		dev_info(&hpb->sdev_ufs_lu->sdev_dev,
 			 "map_req throttle. inflight %d throttle %d",
-			 hpb->num_inflight_map_req, THROTTLE_MAP_REQ_DEFAULT);
+			 hpb->num_inflight_map_req,
+			 hpb->params.inflight_map_req);
 		return NULL;
 	}
 
@@ -1052,6 +1052,7 @@ static void ufshpb_read_to_handler(struct work_struct *work)
 	struct victim_select_info *lru_info = &hpb->lru_info;
 	struct ufshpb_region *rgn, *next_rgn;
 	unsigned long flags;
+	unsigned int poll;
 	LIST_HEAD(expired_list);
 
 	if (test_and_set_bit(TIMEOUT_WORK_RUNNING, &hpb->work_data_bits))
@@ -1070,7 +1071,7 @@ static void ufshpb_read_to_handler(struct work_struct *work)
 				list_add(&rgn->list_expired_rgn, &expired_list);
 			else
 				rgn->read_timeout = ktime_add_ms(ktime_get(),
-							 READ_TO_MS);
+						hpb->params.read_timeout_ms);
 		}
 	}
 
@@ -1088,8 +1089,9 @@ static void ufshpb_read_to_handler(struct work_struct *work)
 
 	clear_bit(TIMEOUT_WORK_RUNNING, &hpb->work_data_bits);
 
+	poll = hpb->params.timeout_polling_interval_ms;
 	schedule_delayed_work(&hpb->ufshpb_read_to_work,
-			      msecs_to_jiffies(POLLING_INTERVAL_MS));
+			      msecs_to_jiffies(poll));
 }
 
 static void ufshpb_add_lru_info(struct victim_select_info *lru_info,
@@ -1099,8 +1101,11 @@ static void ufshpb_add_lru_info(struct victim_select_info *lru_info,
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
 
@@ -1129,7 +1134,8 @@ static struct ufshpb_region *ufshpb_victim_lru_info(struct ufshpb_lu *hpb)
 		 * in host control mode, verify that the exiting region
 		 * has less reads
 		 */
-		if (hpb->is_hcm && rgn->reads > (EVICTION_THRESHOLD >> 1))
+		if (hpb->is_hcm &&
+		    rgn->reads > hpb->params.eviction_thld_exit)
 			continue;
 
 		victim_rgn = rgn;
@@ -1356,7 +1362,8 @@ static int ufshpb_add_region(struct ufshpb_lu *hpb, struct ufshpb_region *rgn)
 			 * in host control mode, verify that the entering
 			 * region has enough reads
 			 */
-			if (hpb->is_hcm && rgn->reads < EVICTION_THRESHOLD) {
+			if (hpb->is_hcm &&
+			    rgn->reads < hpb->params.eviction_thld_enter) {
 				ret = -EACCES;
 				goto out;
 			}
@@ -1697,6 +1704,7 @@ static void ufshpb_normalization_work_handler(struct work_struct *work)
 	struct ufshpb_lu *hpb = container_of(work, struct ufshpb_lu,
 					     ufshpb_normalization_work);
 	int rgn_idx;
+	u8 factor = hpb->params.normalization_factor;
 
 	for (rgn_idx = 0; rgn_idx < hpb->rgns_per_lu; rgn_idx++) {
 		struct ufshpb_region *rgn = hpb->rgn_tbl + rgn_idx;
@@ -1707,7 +1715,7 @@ static void ufshpb_normalization_work_handler(struct work_struct *work)
 		for (srgn_idx = 0; srgn_idx < hpb->srgns_per_rgn; srgn_idx++) {
 			struct ufshpb_subregion *srgn = rgn->srgn_tbl + srgn_idx;
 
-			srgn->reads >>= 1;
+			srgn->reads >>= factor;
 			rgn->reads += srgn->reads;
 		}
 		spin_unlock(&rgn->rgn_lock);
@@ -2031,8 +2039,247 @@ requeue_timeout_ms_store(struct device *dev, struct device_attribute *attr,
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
+	/* read_timeout >> timeout_polling_interval */
+	if (val < hpb->params.timeout_polling_interval_ms * 2)
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
+	/* timeout_polling_interval << read_timeout */
+	if (val <= 0 || val > hpb->params.read_timeout_ms / 2)
+		return -EINVAL;
+
+	hpb->params.timeout_polling_interval_ms = val;
+
+	return count;
+}
+static DEVICE_ATTR_RW(timeout_polling_interval_ms);
+
+ufshpb_sysfs_param_show_func(inflight_map_req);
+static ssize_t inflight_map_req_store(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t count)
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
+	if (val <= 0 || val > hpb->sdev_ufs_lu->queue_depth - 1)
+		return -EINVAL;
+
+	hpb->params.inflight_map_req = val;
+
+	return count;
+}
+static DEVICE_ATTR_RW(inflight_map_req);
+
+static void ufshpb_hcm_param_init(struct ufshpb_lu *hpb)
+{
+	hpb->params.activation_thld = ACTIVATION_THRESHOLD;
+	hpb->params.normalization_factor = 1;
+	hpb->params.eviction_thld_enter = (ACTIVATION_THRESHOLD << 5);
+	hpb->params.eviction_thld_exit = (ACTIVATION_THRESHOLD << 4);
+	hpb->params.read_timeout_ms = READ_TO_MS;
+	hpb->params.read_timeout_expiries = READ_TO_EXPIRIES;
+	hpb->params.timeout_polling_interval_ms = POLLING_INTERVAL_MS;
+	hpb->params.inflight_map_req = THROTTLE_MAP_REQ_DEFAULT;
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
+	&dev_attr_inflight_map_req.attr,
 	NULL,
 };
 
@@ -2116,6 +2363,8 @@ static void ufshpb_stat_init(struct ufshpb_lu *hpb)
 static void ufshpb_param_init(struct ufshpb_lu *hpb)
 {
 	hpb->params.requeue_timeout_ms = HPB_REQUEUE_TIME_MS;
+	if (hpb->is_hcm)
+		ufshpb_hcm_param_init(hpb);
 }
 
 static int ufshpb_lu_hpb_init(struct ufs_hba *hba, struct ufshpb_lu *hpb)
@@ -2170,9 +2419,13 @@ static int ufshpb_lu_hpb_init(struct ufs_hba *hba, struct ufshpb_lu *hpb)
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
 
@@ -2351,10 +2604,13 @@ void ufshpb_resume(struct ufs_hba *hba)
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
index cfa0abac21db..68a5af0ff682 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -185,8 +185,28 @@ struct victim_select_info {
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
+ * @inflight_map_req - number of inflight map requests
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
+	unsigned int inflight_map_req;
 };
 
 struct ufshpb_stats {
-- 
2.25.1

