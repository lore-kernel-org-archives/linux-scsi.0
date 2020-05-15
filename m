Return-Path: <SRS0=Oq5V=65=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9769C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 10:31:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B52220758
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 10:31:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="HEuveJzV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728311AbgEOKby (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 May 2020 06:31:54 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:37282 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728292AbgEOKbw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2020 06:31:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1589538714; x=1621074714;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gYbCsiwIUcRoXf0AHDM5Ae+XdP8lFQ5pzsLgw0qyB5o=;
  b=HEuveJzVJgD58qZI4+FH+xIIYjfEgha12R/8cTqouLeM/7M0dwYRuxo5
   h1MjGQOvmPtbRuI5KeQlf+rSKU+WQLavUMbhh73jAvOYakj496UOGTsBB
   7ZmJ1v4cSVZ5X/4QD9R7xgrDFypXury6AVCbOER3Y4vH/wafuw2HPPfC4
   7pMxDJtBvZrnHUr7zIueEo7CBOED4qO1sGXnse52ZYHWDT/qYnB9vV6b+
   OHAjFQ4usi+M275uaSDFs3120gvMZ1q0BfiEZyiWDsCJZehuBLHWmy8rM
   LdtvyDFH/IWI8PCHFMpR8eXjfwG6PYr3RST7WkBzJFZZQnirWN6CW1nnc
   w==;
IronPort-SDR: /qAP+45auqKUenDKPKcBtuutiW6mZ9iFqPThMLCKApBZjxU7snkt62aV11IamL4ArkTLEV6O39
 70Ar4Q+JNHhoVBioAhUl1b8SI4UzHpzXRZvT0EsC+20YkIdcUIfjsGR4rAtRzCeANAs7H7e9db
 LlSBrK2PM78/+nM9s7NXrpvGsvCxWaNG5kxSEIRjooeVBcfKStSvDZAsPAZYaj5vDzefWAmmJh
 msq+oyd/CULAvOFvUg5XvOL7PJWUzA18h6N3jN8LGdL5N3hkzFEuC/fPcGMUQPm/B6fVv58QXO
 3hc=
X-IronPort-AV: E=Sophos;i="5.73,394,1583164800"; 
   d="scan'208";a="240483783"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 15 May 2020 18:31:53 +0800
IronPort-SDR: 5SyCYTjmVTEet/CLQwqjOAq0msSSbBZhiCH79uQV8rh6mhhWt1ILb7br6PbFetZj8zF5VxKIUF
 CtC6DmzJV1In8jmv+kMFhKrrqSOpRLHOs=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2020 03:22:03 -0700
IronPort-SDR: hCxfrRS/gL0YqWpl/1yYGHITMc2gEovA20hGwZ7KDy6UutXgAvRX1HtO3F02X26GpMliO+a3QZ
 8nfB54TcXQGA==
WDCIronportException: Internal
Received: from ile422988.sdcorp.global.sandisk.com ([10.0.231.246])
  by uls-op-cesaip01.wdc.com with ESMTP; 15 May 2020 03:31:47 -0700
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
Subject: [RFC PATCH 06/13] scsi: scsi_dh: ufshpb: Prepare for L2P cache management
Date:   Fri, 15 May 2020 13:30:07 +0300
Message-Id: <1589538614-24048-7-git-send-email-avri.altman@wdc.com>
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

Preparing for L2P cache management, this patch introduces the memory
pool supportive structures and constants.

The logical unit address space is divided into equally-sized slots
called Regions. Each such region is further divided into equally-sized
subregions.  subregions which theirs L2P mapping entries are cached in
host system memory are called active subregions. An active region is a
region which includes at least one active subregion. A HPB Entry
provides the physical block address of a specific LBA. The size of the
Entry is 8 bytes. HPB entries of all LBAs included in a subregion are
transferred with a single HPB_READ_BUFFER command.

Each lun is limited by the number of its active regions.  This, on one
hand, determines the size of the L2P cache, and the nature of its by-lun
management, on the other.  The second critical factor that determines
how the L2P will be managed is the fact that subregion is the atomic
unit that can be activated and updated.

We also want to manage the L2P mapping by using pages, because we want
to utilize the kernel’s bio submission constructs, should we need to
update the L2P database.

Each sub-region will be designated by a mapping context, which is as an
array of pages, and arranged those as a linked list. We will also
map all subregions using a regions-subregions table. Derived from the
sequential nature of LBAs, such a structure will allow us to retrieve
its applicable HPB entry in O(1).

The actual page allocation is taking place only upon subregion
activation.

Upon failure to allocate any of the memory pool components – HPB is
disabled for that lun.  This is accomplished by the ->detach() handler.
Another case for disabling HPB for that lun can be upon failing to
allocate its pinned regions.

All those allocations and preparations are done as part of the handler
activation phase.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/device_handler/scsi_dh_ufshpb.c | 314 +++++++++++++++++++++++++++
 1 file changed, 314 insertions(+)

diff --git a/drivers/scsi/device_handler/scsi_dh_ufshpb.c b/drivers/scsi/device_handler/scsi_dh_ufshpb.c
index f26208c..9b9b338 100644
--- a/drivers/scsi/device_handler/scsi_dh_ufshpb.c
+++ b/drivers/scsi/device_handler/scsi_dh_ufshpb.c
@@ -17,11 +17,279 @@
 
 #define UFSHPB_NAME	"ufshpb"
 
+#define HPB_ENTRY_SIZE (8)
+
+/* subregion activation threshold - % of subregion size */
+#define ACTIVATION_READS (10)
+/* write/discard requests in blocks to consider a subregion as dirty */
+#define SET_AS_DIRTY (1)
+/* subregion inactivation threshold - % of subregion size */
+#define INACTIVATION_WRITES (30)
+/* to control the amount of HPB_READ_BUFFER commands */
+#define READS_READ_BUFFER_SENT ACTIVATION_READS
+/* not to hold on to "cold" subregions */
+#define READ_TIMEOUT_MSEC (500)
+/* allowed rewinds of the read_timeout for “clean” subregion */
+#define READ_TIMEOUT_EXPIRIES (100)
+/* region eviction threshold: 3 x subregions_per_region x MIN_READS */
+#define EVICTION_READS (3 * ACTIVATION_READS)
+
+/**
+ * struct map_ctx - a mapping context
+ * @pages - array of pages
+ * @list - to hang on lh_map_ctx
+ */
+struct ufshpb_map_ctx {
+	char *pages;
+	struct list_head list;
+};
+
+/**
+ * struct ufshpb_subregion
+ * @mctx - mapping context
+ * @hpb - lun
+ * @r - region in which included in
+ * @reads - cumulative read request in blocks
+ * @writes - cumulative write/discard requests in blocks
+ * @reads_last_trial - read request blocks since last activation trial
+ * @read_timeout_expiries - to rewind the read_timer for "clean" subregion
+ * @region - region index
+ * @subregion - subregion index
+ */
+struct ufshpb_subregion {
+	struct ufshpb_map_ctx *mctx;
+	struct ufshpb_dh_lun *hpb;
+	struct ufshpb_region *r;
+	atomic64_t reads;
+	atomic64_t writes;
+	atomic64_t reads_last_trial;
+	atomic_t read_timeout_expiries;
+	unsigned int region;
+	unsigned int subregion;
+};
+
+/**
+ * struct ufshpb_region
+ * @subregion_tbl - subregions column
+ * @hpb - lun
+ * @reads - sum over subregions @reads
+ * @writes - sum over subregions @writes
+ * @region - region index
+ * @active_subregions - actual active subregions
+ */
+struct ufshpb_region {
+	struct ufshpb_subregion *subregion_tbl;
+	struct ufshpb_dh_lun *hpb;
+	atomic64_t reads;
+	atomic64_t writes;
+	unsigned int region;
+
+	atomic_t active_subregions;
+};
+
+/**
+ * struct ufshpb_dh_lun - hpb lun
+ * @list - to hang on to the hpb luns list
+ * @lh_map_ctx - list head of mapping context
+ * @map_list_lock - to protect mapping context list operations
+ * @region_tbl - regions/subregions table
+ * @sdev - scsi device for that lun
+ * @regions_per_lun
+ * @subregions_per_lun - lun size is not guaranteed to be region aligned
+ * @last_subregion_size - 0 (actual size) if lun is (not) subregion aligned
+ * @max_active_regions - Max allowable active regions at any given time
+ * @active_regions - current active regions
+ */
+struct ufshpb_dh_lun {
+	struct list_head list;
+	struct list_head lh_map_ctx;
+	spinlock_t map_list_lock;
+	struct ufshpb_region *region_tbl;
+	struct scsi_device *sdev;
+
+	unsigned int regions_per_lun;
+	unsigned int subregions_per_lun;
+	unsigned int last_subregion_size;
+	unsigned int max_active_regions;
+
+	atomic_t active_regions;
+};
+
 struct ufshpb_dh_data {
 	const struct ufshpb_config *ufshpb_conf;
 	const struct ufshpb_lun_config *ufshpb_lun_conf;
+	/* keep those first - ufshpb lld expects it */
+	struct ufshpb_dh_lun *hpb;
 };
 
+static struct list_head lh_hpb_lunp;
+/* to support device level configuration */
+static bool is_configured;
+
+/* L2P constants */
+static unsigned int entries_per_region;
+static unsigned int entries_per_subregion;
+static unsigned char order;
+static unsigned long region_size;
+static unsigned long subregion_size;
+static unsigned int subregions_per_region;
+
+static int ufshpb_mempool_init(struct ufshpb_dh_lun *hpb)
+{
+	unsigned int max_active_subregions = hpb->max_active_regions *
+		subregions_per_region;
+	int i;
+
+	INIT_LIST_HEAD(&hpb->lh_map_ctx);
+	spin_lock_init(&hpb->map_list_lock);
+
+	for (i = 0 ; i < max_active_subregions; i++) {
+		struct ufshpb_map_ctx *mctx =
+			kzalloc(sizeof(struct ufshpb_map_ctx), GFP_KERNEL);
+
+		if (!mctx) {
+			/*
+			 * mctxs already added in lh_map_ctx will be removed in
+			 * detach
+			 */
+			return -ENOMEM;
+		}
+
+		/* actual page allocation is done upon subregion activation */
+
+		INIT_LIST_HEAD(&mctx->list);
+		list_add(&mctx->list, &hpb->lh_map_ctx);
+	}
+
+	return 0;
+
+}
+
+static int ufshpb_region_tbl_init(struct ufshpb_dh_lun *hpb)
+{
+	struct ufshpb_region *regions;
+	int i, j;
+
+	regions = kcalloc(hpb->regions_per_lun, sizeof(*regions), GFP_KERNEL);
+	if (!regions)
+		return -ENOMEM;
+
+	atomic_set(&hpb->active_regions, 0);
+
+	for (i = 0 ; i < hpb->regions_per_lun; i++) {
+		struct ufshpb_region *r = regions + i;
+		struct ufshpb_subregion *subregions;
+
+		subregions = kcalloc(subregions_per_region, sizeof(*subregions),
+				     GFP_KERNEL);
+		if (!subregions)
+			goto release_mem;
+
+		for (j = 0; j < subregions_per_region; j++) {
+			struct ufshpb_subregion *s = subregions + j;
+
+			s->hpb = hpb;
+			s->r = r;
+			s->region = i;
+			s->subregion = j;
+		}
+
+		r->subregion_tbl = subregions;
+		r->hpb = hpb;
+		r->region = i;
+	}
+
+	hpb->region_tbl = regions;
+
+	return 0;
+
+release_mem:
+	for (i = 0 ; i < hpb->regions_per_lun; i++) {
+		struct ufshpb_region *r = regions + i;
+
+		if (!r->subregion_tbl)
+			break;
+		kfree(r->subregion_tbl);
+	}
+
+	kfree(regions);
+	/* hpb is released in detach */
+	return -ENOMEM;
+}
+
+static int ufshpb_lun_configuration(struct scsi_device *sdev,
+				    struct ufshpb_dh_data *h)
+{
+	const struct ufshpb_lun_config *lun_conf = h->ufshpb_lun_conf;
+	struct ufshpb_dh_lun *hpb = NULL;
+	int ret;
+
+	if (h->hpb)
+		return -EBUSY;
+
+	hpb = kzalloc(sizeof(*hpb), GFP_KERNEL);
+	if (!hpb)
+		return -ENOMEM;
+
+	hpb->max_active_regions = lun_conf->max_active_regions;
+	hpb->regions_per_lun = DIV_ROUND_UP(lun_conf->size, region_size);
+	hpb->subregions_per_lun = DIV_ROUND_UP(lun_conf->size, subregion_size);
+	hpb->last_subregion_size = lun_conf->size % subregion_size;
+
+	ret = ufshpb_mempool_init(hpb);
+	if (ret)
+		goto out_free;
+
+	ret = ufshpb_region_tbl_init(hpb);
+	if (ret)
+		goto out_free;
+
+	INIT_LIST_HEAD(&hpb->list);
+	list_add(&hpb->list, &lh_hpb_lunp);
+
+	hpb->sdev = sdev;
+	h->hpb = hpb;
+
+out_free:
+	if (ret)
+		kfree(hpb);
+	return ret;
+}
+
+static void ufshpb_get_config(const struct ufshpb_config *c)
+{
+	/* get hpb constants */
+	region_size = BIT(c->region_size + 9);
+	subregion_size = BIT(c->subregion_size + 9);
+	subregions_per_region = BIT(c->region_size - c->subregion_size);
+	entries_per_region = BIT(c->region_size - 3);
+	entries_per_subregion = BIT(c->subregion_size - 3);
+	order = get_order(entries_per_subregion * HPB_ENTRY_SIZE);
+
+	INIT_LIST_HEAD(&lh_hpb_lunp);
+	is_configured = true;
+}
+
+static int ufshpb_activate(struct scsi_device *sdev, activate_complete fn,
+			   void *data)
+{
+	int ret;
+	struct ufshpb_dh_data *h = sdev->handler_data;
+
+	/* device level configuration - only at the 1st time */
+	if (!is_configured)
+		ufshpb_get_config(h->ufshpb_conf);
+
+	ret = ufshpb_lun_configuration(sdev, h);
+	if (ret)
+		return ret;
+
+	if (fn)
+		fn(data, ret);
+
+	return 0;
+}
+
 static int ufshpb_attach(struct scsi_device *sdev)
 {
 	struct ufshpb_dh_data *h;
@@ -38,12 +306,57 @@ static int ufshpb_attach(struct scsi_device *sdev)
 	return SCSI_DH_OK;
 }
 
+static void ufshpb_mempool_remove(struct ufshpb_dh_lun *hpb)
+{
+	struct ufshpb_map_ctx *mctx, *next;
+
+	if (!hpb)
+		return;
+
+	spin_lock(&hpb->map_list_lock);
+
+	list_for_each_entry_safe(mctx, next, &hpb->lh_map_ctx, list) {
+		list_del(&mctx->list);
+		kfree(mctx);
+	}
+
+	spin_unlock(&hpb->map_list_lock);
+}
+
+static void ufshpb_region_tbl_remove(struct ufshpb_dh_lun *hpb)
+{
+	struct ufshpb_region *regions;
+
+	if (!hpb)
+		return;
+
+	regions = hpb->region_tbl;
+	if (regions) {
+		int i;
+
+		for (i = 0 ; i < hpb->regions_per_lun; i++) {
+			struct ufshpb_region *r = regions + i;
+
+			kfree(r->subregion_tbl);
+		}
+
+		kfree(regions);
+	}
+
+	list_del(&hpb->list);
+	kfree(hpb);
+}
+
 /*
  * scsi_dh_detach will be called from the ufs driver upon failuire and on
  * remove.
  */
 static void ufshpb_detach(struct scsi_device *sdev)
 {
+	struct ufshpb_dh_data *h = sdev->handler_data;
+
+	ufshpb_mempool_remove(h->hpb);
+	ufshpb_region_tbl_remove(h->hpb);
 	kfree(sdev->handler_data);
 	sdev->handler_data = NULL;
 }
@@ -53,6 +366,7 @@ static struct scsi_device_handler ufshpb_dh = {
 	.module		= THIS_MODULE,
 	.attach		= ufshpb_attach,
 	.detach		= ufshpb_detach,
+	.activate	= ufshpb_activate,
 };
 
 static int __init ufshpb_init(void)
-- 
2.7.4

