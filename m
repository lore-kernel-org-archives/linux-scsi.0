Return-Path: <SRS0=Oq5V=65=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88B82C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 10:32:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 465B4206B6
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 10:32:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="XJpBc154"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728279AbgEOKcN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 May 2020 06:32:13 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:36707 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728194AbgEOKcM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2020 06:32:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1589538732; x=1621074732;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aMO/OMW4oNXYYRxw8Y7V53GSbvTm3yohSCTZE92PqxM=;
  b=XJpBc154eyKOvnVzGiL2Lol+e70clyxJEgV5UmrUUbsQes+DmzQzkbzx
   NpdGs5FfT2R9rmCh772v24C4noNfsTgIdDvtDLJs6At4B3SwausxSKfkk
   KZgiwayWB8z0lsGA6+XG64JKsmFhzJ+0YHoEViP5RlSyVGffrbgdBt8gt
   WNGcbBLtaoeuC3J3Dhc1kED4PBcr4A2S3DjYtOQEfSd6AT909Khhg0kgg
   Kx98KKFxCEEb+EtVY2bTj0cbzpdToXkB0XCxcOgNbAcX3WV97c5+dYTm6
   wyUKouHw39EmxzSWCiJKyMuwI4n0BD8KtC/KyazNyN+inDBEF+jofFZKw
   g==;
IronPort-SDR: pdVs6o3lYY3ogEOryFEUBK8M0MdndT5Uy3g+HQi19O5li+C84fvWEx5q70Z38Ol+yDK0d0KyFm
 gTx+y+smDg3MQ9GlmPjM+6DW6hy7nUQo+GjllkVP3Bdy/MTP9J3RCA4BBahx/7orNgjxQBl3jI
 jYyoZ1FQXOFMgIDNQnXY/ENxBSJ+iIlYeVR1KfIP/N28SBqjnjDsF3ck6RnSEBLdIWmcVCHK0K
 wcfnCHXfPueaLw+XXIh6h8NHIpyrXSVnxCDGElv1bvgu6zpljJq5q7/Ka7u+O4Y1acOcnYtUSF
 j/M=
X-IronPort-AV: E=Sophos;i="5.73,394,1583164800"; 
   d="scan'208";a="139202477"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 15 May 2020 18:32:12 +0800
IronPort-SDR: dpqTSw1AaDDDETNs373MgLhQM859H8wmsaHsPKVaGsFryq0F2MoM8Nw2KdFmSvwMgwF/XBRD3N
 Kobr/XeK6ruhbhet/+7ujEh1SK1M5kNFA=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2020 03:21:49 -0700
IronPort-SDR: c1eEqTIcVF4Xyy00f2W2XpSNx+X8tNhDOj92qX9Q8jVfawDqp87fKMDvKdjkzVqKV1p6J56tjN
 VMfH2Pc+o+cA==
WDCIronportException: Internal
Received: from ile422988.sdcorp.global.sandisk.com ([10.0.231.246])
  by uls-op-cesaip01.wdc.com with ESMTP; 15 May 2020 03:32:07 -0700
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>, alim.akhtar@samsung.com,
        asutoshd@codeaurora.org, Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <avi.shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>, cang@codeaurora.org,
        stanley.chu@mediatek.com,
        MOHAMMED RAFIQ KAMAL BASHA <md.rafiq@samsung.com>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [RFC PATCH 07/13] scsi: scsi_dh: ufshpb: Add ufshpb state machine
Date:   Fri, 15 May 2020 13:30:08 +0300
Message-Id: <1589538614-24048-8-git-send-email-avri.altman@wdc.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1589538614-24048-1-git-send-email-avri.altman@wdc.com>
References: <1589538614-24048-1-git-send-email-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The cache management is mainly derived by 2 types of events: the device
hints on one hand, and read & write operations on the other.  On host
management mode, the host may choose not to follow those hints, but we
will.

Both regions and subregions can be either active or inactive. We will
monitor the lun’s regions/subregions state using a designated worker,
which will gets scheduled on each event.

The region state is derived from the state of its subregions: it becomes
active once its first subregion becomes active, and inactive with its
last.

The device may send to the host an activation signal for one of its
inactive subregions, provided that the region is active.  For an
inactive region such activation trial can only be a result of a read
request. Next we try to allocate the required pages to that subregion
and update its L2P mapping by sending HPB_READ_BUFFER command.  Upon
successful completion the subregion becoms active.

A Third option in which we update the subregion's L2P cache, is when the
device may send an update signal to the host for an active subregion.
This is because the host is not entirely aware of the device’s
in-house activities (GC, etc.).  We distinguish such notifications to
an active subregion as an “update” event instead of “activate” event to
an inactive subregion, but both derived from the same device’s
activation recommendation.  In that case, the subregion change its state
to inactive, but does not release its pages, nor the region changes its
active count. Upon successful completion of HPB_READ_BUFFER the
subregion returns to be active, otherwise become inactive.

A subregion can become inactive if its writes count (dirty) exceeds a
given threshold. In order not to hang on to “cold” subregions, we shall
inactivate a subregion that has no READ access for a predefined amount
of time.

HPB_READ_BUFFER is used to update the subregion's L2P cache.  Upon
its  successful completion the subregion is considered to be active.

In the allocation length field of the HPB_READ_BUFFER command, we fill
entries_per_subregion x 8bytes, regardless of the actual subregion size.
For LUNs that are not subregion aligned, the actual subregion size of
the last subregion might be smaller. However, as there can be no valid
LBA that exceeds the valid part of that subregion, and which shall not
be accessed, it suffices to maintain a constant allocation length.

One last implementation point is calling scsi_execute with command
anon to SCSI still works for older kernels. This is because this flow
trust its users to fill the CDB unconditionally, and the SCSI command
setup is bypassed altogether.
This will no longer work, as all of this code was removed last year in
commit a1ce35fa4985 ("block: remove dead elevator code").
We will most likely need to change this in our next versions.

Region eviction refer to the act of activating a region on the expense
of inactivating another region.  This can only occur when active regions
count is at its max, and the system might benefit from activating
another region.  This act is a stranger to our basic concept that region
activation is derived from its subregion activation, but entails some
possible overall gain.
On region eviction, the leaving region is deactivated, and the entering
region is becoming active by activating the subregion that cause the
eviction trial.
The region eviction work is triggered by the same conditions of
subregion activation – if a subregion belongs to an inactive region and
while all other subregion activation restrictions applies.
Evicting an active region is an extreme operation, so the threshold for
both entering and exiting region are quite high.  The entering region
reads should cross the EVICTION_READS threshold, and the exiting region
should have less than half of that amount of reads.
We are aware that there can be many contender subregions trying to evict
someone simultaneously.  Thus we are risking by cyclic-eviction:
evicting a region that just entered by evicting another region.
That’s fine, and we don’t want to interfere this process – just let it
play, as “stronger” regions enter, the eviction process is bound to
converge.
last but not least - the entering subrigion should be clean, so we can
benefit HPB_READing it, at least in the short term.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/device_handler/scsi_dh_ufshpb.c | 521 ++++++++++++++++++++++++++-
 1 file changed, 520 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_ufshpb.c b/drivers/scsi/device_handler/scsi_dh_ufshpb.c
index 9b9b338..c94a616 100644
--- a/drivers/scsi/device_handler/scsi_dh_ufshpb.c
+++ b/drivers/scsi/device_handler/scsi_dh_ufshpb.c
@@ -7,6 +7,7 @@
  * Copyright (C) 2020 Western Digital Corporation or its affiliates.
  */
 
+#include <asm/unaligned.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <scsi/scsi.h>
@@ -17,6 +18,13 @@
 
 #define UFSHPB_NAME	"ufshpb"
 
+#define UFSHPB_WRITE_BUFFER (0xfa)
+#define WRITE_BUFFER_TIMEOUT (3 * HZ)
+#define WRITE_BUFFER_RETRIES (3)
+#define UFSHPB_READ_BUFFER (0xf9)
+#define READ_BUFFER_TIMEOUT (3 * HZ)
+#define READ_BUFFER_RETRIES (3)
+
 #define HPB_ENTRY_SIZE (8)
 
 /* subregion activation threshold - % of subregion size */
@@ -34,6 +42,32 @@
 /* region eviction threshold: 3 x subregions_per_region x MIN_READS */
 #define EVICTION_READS (3 * ACTIVATION_READS)
 
+#define to_subregion() (container_of(work, struct ufshpb_subregion, hpb_work))
+
+enum ufshpb_state {
+	HPB_STATE_INACTIVE,
+	HPB_STATE_ACTIVE,
+};
+
+/**
+ * ufshpb_subregion_events
+ * @SUBREGION_EVENT_ACTIVATE - device signal to a non-active subregion
+ * @SUBREGION_EVENT_UPDATE - device signal to an active subregion
+ * @SUBREGION_EVENT_READ - a new read request to a non-active subregion
+ * @SUBREGION_EVENT_DIRTY_THRESHOLD - a dirty threshold crossed
+ * @SUBREGION_EVENT_TIMER - timer since last read expired
+ */
+enum ufshpb_subregion_events {
+	SUBREGION_EVENT_ACTIVATE,
+	SUBREGION_EVENT_UPDATE,
+	SUBREGION_EVENT_READ,
+	SUBREGION_EVENT_DIRTY_THRESHOLD,
+	SUBREGION_EVENT_TIMER,
+
+	/* keep last */
+	SUBREGION_EVENT_MAX
+};
+
 /**
  * struct map_ctx - a mapping context
  * @pages - array of pages
@@ -55,6 +89,9 @@ struct ufshpb_map_ctx {
  * @read_timeout_expiries - to rewind the read_timer for "clean" subregion
  * @region - region index
  * @subregion - subregion index
+ * @state - one of @ufshpb_state
+ * @event - one of @ufshpb_subregion_events
+ * @hpb_work - worker to implement state machine
  */
 struct ufshpb_subregion {
 	struct ufshpb_map_ctx *mctx;
@@ -66,6 +103,11 @@ struct ufshpb_subregion {
 	atomic_t read_timeout_expiries;
 	unsigned int region;
 	unsigned int subregion;
+
+	unsigned state:1;
+	unsigned long event;
+	struct mutex state_lock;
+	struct work_struct hpb_work;
 };
 
 /**
@@ -76,6 +118,7 @@ struct ufshpb_subregion {
  * @writes - sum over subregions @writes
  * @region - region index
  * @active_subregions - actual active subregions
+ * @evicted - to indicated if this region is currently being evicted
  */
 struct ufshpb_region {
 	struct ufshpb_subregion *subregion_tbl;
@@ -85,6 +128,7 @@ struct ufshpb_region {
 	unsigned int region;
 
 	atomic_t active_subregions;
+	atomic_t evicted;
 };
 
 /**
@@ -93,6 +137,7 @@ struct ufshpb_region {
  * @lh_map_ctx - list head of mapping context
  * @map_list_lock - to protect mapping context list operations
  * @region_tbl - regions/subregions table
+ * @pinned_map - to mark pinned regions
  * @sdev - scsi device for that lun
  * @regions_per_lun
  * @subregions_per_lun - lun size is not guaranteed to be region aligned
@@ -105,6 +150,7 @@ struct ufshpb_dh_lun {
 	struct list_head lh_map_ctx;
 	spinlock_t map_list_lock;
 	struct ufshpb_region *region_tbl;
+	unsigned long *pinned_map;
 	struct scsi_device *sdev;
 
 	unsigned int regions_per_lun;
@@ -113,6 +159,10 @@ struct ufshpb_dh_lun {
 	unsigned int max_active_regions;
 
 	atomic_t active_regions;
+
+	struct mutex eviction_lock;
+
+	struct workqueue_struct *wq;
 };
 
 struct ufshpb_dh_data {
@@ -134,6 +184,440 @@ static unsigned long region_size;
 static unsigned long subregion_size;
 static unsigned int subregions_per_region;
 
+static inline void ufshpb_set_write_buf_cmd(unsigned char *cmd,
+					    unsigned int region)
+{
+	cmd[0] = UFSHPB_WRITE_BUFFER;
+	cmd[1] = 0x01;
+	put_unaligned_be16(region, &cmd[2]);
+}
+
+static int ufshpb_submit_write_buf_cmd(struct scsi_device *sdev,
+				       unsigned int region)
+{
+	unsigned char cmd[10] = {};
+	struct scsi_sense_hdr sshdr = {};
+	u64 flags = REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
+		    REQ_FAILFAST_DRIVER;
+	int timeout = WRITE_BUFFER_TIMEOUT;
+	int cmd_retries = WRITE_BUFFER_RETRIES;
+	int ret = 0;
+
+	ufshpb_set_write_buf_cmd(cmd, region);
+
+	ret = scsi_execute(sdev, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
+			   timeout, cmd_retries, flags, 0, NULL);
+
+	/* HPB spec does not define any error handling */
+	sdev_printk(KERN_INFO, sdev, "%s: WRITE_BUFFER %s result %d\n",
+		    UFSHPB_NAME, ret ? "failed" : "succeeded", ret);
+
+	return ret;
+}
+
+static void ufshpb_region_inactivate(struct ufshpb_dh_lun *hpb,
+				     struct ufshpb_region *r, bool reset)
+{
+	if (!reset)
+		ufshpb_submit_write_buf_cmd(hpb->sdev, r->region);
+
+	atomic_dec(&hpb->active_regions);
+}
+
+static void __subregion_inactivate(struct ufshpb_dh_lun *hpb,
+				   struct ufshpb_region *r,
+				   struct ufshpb_subregion *s)
+{
+	if (!s->mctx)
+		return;
+
+	if (s->mctx->pages) {
+		free_pages((unsigned long)s->mctx->pages, order);
+		s->mctx->pages = NULL;
+	}
+
+	spin_lock(&hpb->map_list_lock);
+	list_add(&s->mctx->list, &hpb->lh_map_ctx);
+	spin_unlock(&hpb->map_list_lock);
+	s->mctx = NULL;
+}
+
+static void ufshpb_subregion_inactivate(struct ufshpb_dh_lun *hpb,
+					struct ufshpb_region *r,
+					struct ufshpb_subregion *s, bool reset)
+{
+	lockdep_assert_held(&s->state_lock);
+
+	if (s->state == HPB_STATE_INACTIVE)
+		return;
+
+	if (test_bit(r->region, hpb->pinned_map))
+		return;
+
+	__subregion_inactivate(hpb, r, s);
+
+	s->state = HPB_STATE_INACTIVE;
+
+	if (atomic_dec_and_test(&r->active_subregions))
+		ufshpb_region_inactivate(hpb, r, reset);
+}
+
+static void ufshpb_set_read_buf_cmd(unsigned char *cmd, unsigned int region,
+				    unsigned int subregion,
+				    unsigned int alloc_len)
+{
+	cmd[0] = UFSHPB_READ_BUFFER;
+	cmd[1] = 0x01;
+	put_unaligned_be16(region, &cmd[2]);
+	put_unaligned_be16(subregion, &cmd[4]);
+
+	cmd[6] = alloc_len >> 16;
+	cmd[7] = (alloc_len >> 8) & 0xff;
+	cmd[8] = alloc_len & 0xff;
+	cmd[9] = 0x00;
+}
+
+static bool ufshpb_read_buf_cmd_need_retry(struct ufshpb_dh_lun *hpb,
+					   struct scsi_device *sdev,
+					   struct scsi_sense_hdr *sshdr,
+					   int result)
+{
+	if (atomic_read(&hpb->active_regions) >= hpb->max_active_regions)
+		return false;
+
+	/* UFS3.1 spec says: "...
+	 * If the device is performing internal maintenance work, for example
+	 * Garbage collection, the device may terminate the HPB READ BUFFER
+	 * command by sending RESPONSE UPIU with CHECK CONDITION status, with
+	 * the SENSE KEY set to ILLEGAL REQUEST, and the additional sense code
+	 * set OPERATION IN PROGRESS. In this case, the host can retry the HPB
+	 * READ BUFFER command..."
+	 */
+	if (scsi_sense_valid(sshdr) &&
+	    status_byte(result) == CHECK_CONDITION &&
+	    sshdr->sense_key == ILLEGAL_REQUEST && sshdr->asc == 0x00
+	    && sshdr->ascq == 0x16)
+		return true;
+
+	return false;
+}
+
+static int ufshpb_submit_read_buf_cmd(struct ufshpb_dh_lun *hpb,
+				      struct ufshpb_subregion *s)
+{
+	struct scsi_device *sdev = hpb->sdev;
+	unsigned char cmd[10] = {};
+	struct scsi_sense_hdr sshdr = {};
+	char *buf = s->mctx->pages;
+	unsigned int alloc_len = entries_per_subregion * HPB_ENTRY_SIZE;
+	int retries = READ_BUFFER_RETRIES;
+	int ret;
+
+	ufshpb_set_read_buf_cmd(cmd, s->region, s->subregion, alloc_len);
+
+	do {
+		u64 flags = REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
+			REQ_FAILFAST_DRIVER;
+		unsigned int buflen = alloc_len;
+
+		memset(&sshdr, 0, sizeof(sshdr));
+		memset(buf, 0, buflen);
+		ret = scsi_execute(sdev, cmd, DMA_FROM_DEVICE, buf, buflen,
+				NULL, &sshdr, READ_BUFFER_TIMEOUT,
+				READ_BUFFER_RETRIES, flags, 0, NULL);
+
+		if (!ret)
+			return ret;
+
+	} while (ufshpb_read_buf_cmd_need_retry(hpb, sdev, &sshdr, ret) &&
+			retries--);
+
+	return ret;
+}
+
+static int ufshpb_subregion_alloc_pages(struct ufshpb_dh_lun *hpb,
+					struct ufshpb_subregion *s)
+{
+	struct ufshpb_map_ctx *mctx;
+
+	spin_lock(&hpb->map_list_lock);
+	mctx = list_first_entry_or_null(&hpb->lh_map_ctx,
+					struct ufshpb_map_ctx, list);
+	if (!mctx) {
+		spin_unlock(&hpb->map_list_lock);
+		return -EINVAL;
+	}
+
+	list_del_init(&mctx->list);
+	spin_unlock(&hpb->map_list_lock);
+
+	s->mctx = mctx;
+	mctx->pages = (char *)__get_free_pages(GFP_KERNEL, order);
+	if (!mctx->pages)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static int __subregion_activate(struct ufshpb_dh_lun *hpb,
+				struct ufshpb_region *r,
+				struct ufshpb_subregion *s, bool alloc_pages)
+{
+	int ret;
+
+	if (alloc_pages) {
+		ret = ufshpb_subregion_alloc_pages(hpb, s);
+		if (ret)
+			goto out;
+	}
+
+	if (!s->mctx || !s->mctx->pages) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = ufshpb_submit_read_buf_cmd(hpb, s);
+	if (ret)
+		goto out;
+
+	atomic64_sub(atomic64_read(&s->writes), &r->writes);
+	atomic64_set(&s->writes, 0);
+
+out:
+	if (ret)
+		__subregion_inactivate(hpb, r, s);
+
+	return ret;
+}
+
+static inline bool ufshpb_can_send_read_buffer(struct ufshpb_subregion *s)
+{
+	unsigned int activation_threshold = READS_READ_BUFFER_SENT *
+					    entries_per_subregion / 100;
+
+	return atomic64_read(&s->reads) - atomic64_read(&s->reads_last_trial)
+		>= activation_threshold;
+}
+
+static int ufshpb_subregion_activate(struct ufshpb_dh_lun *hpb,
+				      struct ufshpb_region *r,
+				      struct ufshpb_subregion *s, bool init)
+{
+	int ret;
+
+	lockdep_assert_held(&s->state_lock);
+
+	if (s->state == HPB_STATE_ACTIVE || atomic_read(&r->evicted))
+		return 0;
+
+	/* do not flood the driver with HPB_READ_BUFFER commands */
+	if (!init && !ufshpb_can_send_read_buffer(s))
+		return 0;
+
+	/* if this is the first subregion to become active */
+	if (atomic_inc_return(&r->active_subregions) == 1) {
+		/* check that max_active_regions is not exceeded */
+		if (atomic_inc_return(&hpb->active_regions) >
+		    hpb->max_active_regions) {
+			atomic_dec(&hpb->active_regions);
+			atomic_dec(&r->active_subregions);
+			return 0;
+		}
+	}
+
+	ret = __subregion_activate(hpb, r, s, true);
+	atomic64_set(&s->reads_last_trial, atomic64_read(&s->reads));
+	if (ret) {
+		if (atomic_dec_and_test(&r->active_subregions))
+			atomic_dec(&hpb->active_regions);
+		return ret;
+	}
+
+	s->state = HPB_STATE_ACTIVE;
+
+	return 0;
+}
+
+static struct ufshpb_region *__find_region_to_evict(struct ufshpb_dh_lun *hpb,
+						    struct ufshpb_region *r)
+{
+	struct ufshpb_region *regions = hpb->region_tbl;
+	struct ufshpb_region *exiting_region = NULL;
+	unsigned int eviction_threshold;
+	unsigned int exit_threshold;
+	unsigned int lowest_reads;
+	int i;
+
+	eviction_threshold = EVICTION_READS * entries_per_region / 100;
+	if (atomic64_read(&r->reads) < eviction_threshold)
+		goto out;
+
+	exit_threshold = eviction_threshold >> 1;
+	lowest_reads = exit_threshold;
+	for (i = 0; i < hpb->regions_per_lun; i++) {
+		struct ufshpb_region *rr = regions + i;
+		unsigned int tmp_reads;
+
+		if (r == rr)
+			continue;
+
+		if (test_bit(rr->region, hpb->pinned_map))
+			continue;
+
+		if (!atomic_read(&rr->active_subregions))
+			continue;
+
+		tmp_reads = atomic64_read(&rr->reads);
+		if (tmp_reads < lowest_reads) {
+			lowest_reads = tmp_reads;
+			exiting_region = rr;
+		}
+	}
+
+out:
+	return exiting_region;
+}
+
+static int __region_evict(struct ufshpb_dh_lun *hpb,
+			  struct ufshpb_region *exiting_region, bool reset)
+{
+	struct ufshpb_subregion *subregions = exiting_region->subregion_tbl;
+	int ret = 0;
+	int j;
+
+	/* mark that region as being evicted */
+	atomic_set(&exiting_region->evicted, 1);
+
+	for (j = 0; j < subregions_per_region; j++) {
+		struct ufshpb_subregion *s = subregions + j;
+
+		if (s->state != HPB_STATE_ACTIVE)
+			continue;
+
+		mutex_lock(&s->state_lock);
+		ufshpb_subregion_inactivate(hpb, exiting_region, s, reset);
+		mutex_unlock(&s->state_lock);
+	}
+
+	atomic_set(&exiting_region->evicted, 0);
+
+	return ret;
+}
+
+static int ufshpb_region_try_evict(struct ufshpb_dh_lun *hpb,
+				   struct ufshpb_region *r,
+				   struct ufshpb_subregion *s)
+{
+	struct ufshpb_region *exiting_region = NULL;
+
+	lockdep_assert_held(&s->state_lock);
+
+	if (s->state == HPB_STATE_ACTIVE ||
+	    atomic64_read(&s->writes) > SET_AS_DIRTY)
+		return -EINVAL;
+
+	exiting_region = __find_region_to_evict(hpb, r);
+	if (!exiting_region)
+		return -EINVAL;
+
+	/*
+	 * before inactivating the exiting region check again - some regions
+	 * may become free, so just activate the entring subregion
+	 */
+	if (atomic_read(&hpb->active_regions) >= hpb->max_active_regions)
+		__region_evict(hpb, exiting_region, false);
+
+	/* activate the entering subregion */
+	ufshpb_subregion_activate(hpb, r, s, false);
+
+	return 0;
+}
+
+static void ufshpb_subregion_update(struct ufshpb_dh_lun *hpb,
+				    struct ufshpb_region *r,
+				    struct ufshpb_subregion *s, bool reset)
+{
+	lockdep_assert_held(&s->state_lock);
+
+	if (s->state != HPB_STATE_ACTIVE)
+		return;
+
+	/* bail out if the region is currently being evicted */
+	if (atomic_read(&r->evicted))
+		return;
+
+	/* do not flood the driver with HPB_READ_BUFFER commands */
+	if (!reset && !ufshpb_can_send_read_buffer(s))
+		return;
+
+	s->state = HPB_STATE_INACTIVE;
+
+	if (__subregion_activate(hpb, r, s, false)) {
+		ufshpb_subregion_inactivate(hpb, r, s, false);
+		return;
+	}
+
+	s->state = HPB_STATE_ACTIVE;
+}
+
+/*
+ * ufshpb_dispatch - ufshpb state machine
+ * make the various decisions based on region/subregion state & events
+ */
+static void ufshpb_dispatch(struct ufshpb_dh_lun *hpb, struct ufshpb_region *r,
+			    struct ufshpb_subregion *s)
+{
+	unsigned long e;
+	int i;
+
+	lockdep_assert_held(&s->state_lock);
+
+	e = find_first_bit(&s->event, SUBREGION_EVENT_MAX);
+
+	switch (e) {
+	case SUBREGION_EVENT_READ:
+		if (atomic_read(&r->active_subregions) < 1 &&
+		    atomic_read(&hpb->active_regions) >=
+		    hpb->max_active_regions) {
+			/* potential eviction may take place */
+			mutex_lock(&hpb->eviction_lock);
+			ufshpb_region_try_evict(hpb, r, s);
+			mutex_unlock(&hpb->eviction_lock);
+			break;
+		}
+		/* fall through */
+	case SUBREGION_EVENT_ACTIVATE:
+		ufshpb_subregion_activate(hpb, r, s, false);
+		break;
+
+	case SUBREGION_EVENT_UPDATE:
+		ufshpb_subregion_update(hpb, r, s, false);
+		break;
+
+	case SUBREGION_EVENT_DIRTY_THRESHOLD:
+	case SUBREGION_EVENT_TIMER:
+		ufshpb_subregion_inactivate(hpb, r, s, false);
+		break;
+
+	default:
+		break;
+	}
+
+	for (i = 0; i < SUBREGION_EVENT_MAX; i++)
+		clear_bit(i, &s->event);
+}
+
+static void ufshpb_work_handler(struct work_struct *work)
+{
+	struct ufshpb_subregion *s = to_subregion();
+
+	mutex_lock(&s->state_lock);
+
+	ufshpb_dispatch(s->hpb, s->r, s);
+
+	mutex_unlock(&s->state_lock);
+}
+
 static int ufshpb_mempool_init(struct ufshpb_dh_lun *hpb)
 {
 	unsigned int max_active_subregions = hpb->max_active_regions *
@@ -192,6 +676,8 @@ static int ufshpb_region_tbl_init(struct ufshpb_dh_lun *hpb)
 			s->r = r;
 			s->region = i;
 			s->subregion = j;
+			INIT_WORK(&s->hpb_work, ufshpb_work_handler);
+			mutex_init(&s->state_lock);
 		}
 
 		r->subregion_tbl = subregions;
@@ -200,6 +686,7 @@ static int ufshpb_region_tbl_init(struct ufshpb_dh_lun *hpb)
 	}
 
 	hpb->region_tbl = regions;
+	mutex_init(&hpb->eviction_lock);
 
 	return 0;
 
@@ -223,6 +710,8 @@ static int ufshpb_lun_configuration(struct scsi_device *sdev,
 	const struct ufshpb_lun_config *lun_conf = h->ufshpb_lun_conf;
 	struct ufshpb_dh_lun *hpb = NULL;
 	int ret;
+	struct workqueue_struct *wq;
+	char wq_name[sizeof("ufshpb_wq_00")] = {};
 
 	if (h->hpb)
 		return -EBUSY;
@@ -236,6 +725,13 @@ static int ufshpb_lun_configuration(struct scsi_device *sdev,
 	hpb->subregions_per_lun = DIV_ROUND_UP(lun_conf->size, subregion_size);
 	hpb->last_subregion_size = lun_conf->size % subregion_size;
 
+	hpb->pinned_map = kcalloc(BITS_TO_LONGS(hpb->regions_per_lun),
+				  sizeof(unsigned long), GFP_KERNEL);
+	if (!hpb->pinned_map) {
+		ret = -ENOMEM;
+		goto out_free;
+	}
+
 	ret = ufshpb_mempool_init(hpb);
 	if (ret)
 		goto out_free;
@@ -244,6 +740,15 @@ static int ufshpb_lun_configuration(struct scsi_device *sdev,
 	if (ret)
 		goto out_free;
 
+	snprintf(wq_name, ARRAY_SIZE(wq_name), "ufshpb_wq_%d", sdev->id);
+	wq = alloc_workqueue(wq_name, WQ_HIGHPRI, WQ_MAX_ACTIVE);
+	if (!wq) {
+		ret = -ENOMEM;
+		goto out_free;
+	}
+
+	hpb->wq = wq;
+
 	INIT_LIST_HEAD(&hpb->list);
 	list_add(&hpb->list, &lh_hpb_lunp);
 
@@ -251,8 +756,10 @@ static int ufshpb_lun_configuration(struct scsi_device *sdev,
 	h->hpb = hpb;
 
 out_free:
-	if (ret)
+	if (ret) {
+		kfree(hpb->pinned_map);
 		kfree(hpb);
+	}
 	return ret;
 }
 
@@ -336,6 +843,14 @@ static void ufshpb_region_tbl_remove(struct ufshpb_dh_lun *hpb)
 
 		for (i = 0 ; i < hpb->regions_per_lun; i++) {
 			struct ufshpb_region *r = regions + i;
+			int j;
+
+			for (j = 0; j < subregions_per_region; j++) {
+				struct ufshpb_subregion *s =
+							r->subregion_tbl + j;
+
+				cancel_work_sync(&s->hpb_work);
+			}
 
 			kfree(r->subregion_tbl);
 		}
@@ -355,6 +870,10 @@ static void ufshpb_detach(struct scsi_device *sdev)
 {
 	struct ufshpb_dh_data *h = sdev->handler_data;
 
+	if (h->hpb && h->hpb->wq) {
+		flush_workqueue(h->hpb->wq);
+		destroy_workqueue(h->hpb->wq);
+	}
 	ufshpb_mempool_remove(h->hpb);
 	ufshpb_region_tbl_remove(h->hpb);
 	kfree(sdev->handler_data);
-- 
2.7.4

