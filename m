Return-Path: <SRS0=Oq5V=65=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35AAEC433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 10:33:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2F1E2074D
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 10:33:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="PMSiTbfF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728421AbgEOKdK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 May 2020 06:33:10 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:1981 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728048AbgEOKdI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2020 06:33:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1589538789; x=1621074789;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yEbuAv5M8X8pLUL92+fKSBJ2BaGzrpGawGqTshRpYO0=;
  b=PMSiTbfFrLmgO8QrN3rRbt+Oen/G9MLbxS0FOM2RQwkJrKhWTHhvOCjJ
   6c4U377NBrZcalMJPTrGFb/y0pZ2J9J7h5JQclCXdqFTcX5ohri1NdtDF
   jaWetB/kCqNnq9Qela1xWT19cwAErCpDyqZlq0IulorwKz/6kZou7Yz05
   s/3g66vjKD+CWMcaPuYu1809inhKqYBX6SXIQBrfXBeJ+cy9j8aUOuQ3y
   qpfPA+4XdqeGc37Knw0iMZqk3bgu1vkEb8kydzk9Xx4Jo9g416MYQ9xUc
   17jRZEBbpEBltwvKwWZtFHPJZuXaA3SenXQcRQBivb4UvpHAy04zsrwbn
   Q==;
IronPort-SDR: xYDqDGqCN/pgADO1FAr3JMJ5Q2dbqoqP7SAX+ZVG7Qb5LeiZvE3EtqOT2BdOSYpsu+UhyIKzKW
 BvLc7uCexjrFoUgBl2Dj4986ZhKZkIq3wVdqe5tpzae2s+ZnHpi+hn8NoUp1seb4dCT3XK+pvb
 4FsYLt/udwfGpHFS7IdSSFnw7qussOZy2Sw1ibk1F+dxFmrK6Kh2BcoFvJtt2XDKGIenPuQ4Mj
 cYYQeSZbUmCLqOrOsLuZ5EzO4zLIZr8tmAu1bkjsJ6cnA1ER2GZcuuSBQkjCv/zDqdUg5rQgus
 qPQ=
X-IronPort-AV: E=Sophos;i="5.73,394,1583164800"; 
   d="scan'208";a="142113830"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 15 May 2020 18:33:09 +0800
IronPort-SDR: eKPvGyyqr3pjUgjehRmet+7+ePtviISiOUtLj/anJWUOkQSNIdxU9WL3U/4EuWwj1MB6B8DWx2
 rm8xaYz3PQsYgEIkJG2McGiT8Sdpm619E=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2020 03:23:19 -0700
IronPort-SDR: /Ju3ofX1nGwXf62TFWQPD0x7sXrCMfoBeD66PD1aSb2VeANmVBu/wWMzrh8fKMHQGbjsZC57DY
 MDZgJfKqI8Ww==
WDCIronportException: Internal
Received: from ile422988.sdcorp.global.sandisk.com ([10.0.231.246])
  by uls-op-cesaip01.wdc.com with ESMTP; 15 May 2020 03:33:04 -0700
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
Subject: [RFC PATCH 12/13] scsi: dh: ufshpb: Add prep_fn handler
Date:   Fri, 15 May 2020 13:30:13 +0300
Message-Id: <1589538614-24048-13-git-send-email-avri.altman@wdc.com>
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

The 3rd and last functionality of the HPB driver is to construct a
HPB_READ command for each read request whenever possible.  Such HPB_READ
command should include both the logical and physical address (ppa) of
the first block to read.

Still, in order to effectively attach the “correct” ppa we need to
monitor the “dirty” blocks: those are the blocks that a WRITE/UNMAP
commands were send to post a HPB_READ_BUFFER.  For that purpose, we are
maintaining for each subregion, the write counter.

On WRITE/UNMAP, we just increment the write counter.
On READ, if the region/subregion is not active we will try to activate
it.  If the subregion is active, we will check if it is “clean”, and if
it does we will fetch its ppa, and construct HPB_READ command and attach
it to the request structure.

Some pre-arrangement were made to assure that scsi command setup process
will let the HPB_READ CDB pass unharmed.

The regions and subregions state will be mostly-read accessed by both
READ and WRITE requests, looking if the entry is "clean" and can be
HPB-READ, or mark those entries as "dirty" when applicable. So RCU seems
most suitable to allow those concurrent accesses.  Also, the fundamental
RCU requirement of a "graceful period" does apply in our case as the
device firmware backs us up and will pool the correct physical address
on our occasional misses.

Upon a read request to an inactive subregion, or a write request to an
active subregion, we try to activate/inactivate it respectively.

The read/write workers calls the state machine if the subregion crossed
the {activation/inactivation} threshold, but once it did, any new
request will trigger it.  In the case of e.g. sequential read to that
subregion, can yield a couple of dozens simultaneous read requests.

That's fine, because if the region is active, then the activation
trial will surely succeed, and once the subregion become active - we do
nothing.  Otherwise, we are in the unknown terrain of eviction which can
fail - and that's fine too because we will keep trying.

For writes its even simpler, as the subregion becomes inactive promptly,
and we won't go there anymore.

We are using the raeds and writes counters per subregion to support the
L2P cache various management decisions.  We don't want to reset those
counters so to not loose its historical meaning: an area that is kept
being read or write over and over.

However, not to overflow the counters, and to maintain the correct
relative ratio among all regions we need to normalize those counters.

When one of the region's reads counters reaches a threshold, all
counters are divided by 2, for all regions – active and inactive.  This
goes to the write counters as well.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/device_handler/scsi_dh_ufshpb.c | 365 ++++++++++++++++++++++++++-
 1 file changed, 355 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_ufshpb.c b/drivers/scsi/device_handler/scsi_dh_ufshpb.c
index affc143..04e3d56 100644
--- a/drivers/scsi/device_handler/scsi_dh_ufshpb.c
+++ b/drivers/scsi/device_handler/scsi_dh_ufshpb.c
@@ -15,6 +15,7 @@
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_dh.h>
 #include <scsi/scsi_dh_ufshpb.h>
+#include "../sd.h"
 
 #define UFSHPB_NAME	"ufshpb"
 
@@ -22,10 +23,12 @@
 #define WRITE_BUFFER_TIMEOUT (3 * HZ)
 #define WRITE_BUFFER_RETRIES (3)
 #define UFSHPB_READ_BUFFER (0xf9)
+#define UFSHPB_READ (0xf8)
 #define READ_BUFFER_TIMEOUT (3 * HZ)
 #define READ_BUFFER_RETRIES (3)
 
 #define HPB_ENTRY_SIZE (8)
+#define HPB_ENTRIES_PER_PAGE (PAGE_SIZE / HPB_ENTRY_SIZE)
 
 /* subregion activation threshold - % of subregion size */
 #define ACTIVATION_READS (10)
@@ -39,6 +42,9 @@
 #define READ_TIMEOUT_MSEC (500)
 /* allowed rewinds of the read_timeout for “clean” subregion */
 #define READ_TIMEOUT_EXPIRIES (100)
+/* normalize the counters to keep the regions balanced */
+#define READ_NORMALIZATION (3)
+#define WRITE_NORMALIZATION (READ_NORMALIZATION)
 /* region eviction threshold: 3 x subregions_per_region x MIN_READS */
 #define EVICTION_READS (3 * ACTIVATION_READS)
 
@@ -77,7 +83,6 @@ enum ufshpb_work_locks {
 	LUN_RESET_WORK = BIT(0),
 };
 
-
 /**
  * struct map_ctx - a mapping context
  * @pages - array of pages
@@ -154,6 +159,8 @@ struct ufshpb_region {
  * @last_subregion_size - 0 (actual size) if lun is (not) subregion aligned
  * @max_active_regions - Max allowable active regions at any given time
  * @active_regions - current active regions
+ * @reads_normalization_work - worker to normalize read counters
+ * @writes_normalization_work - worker to normalize write counters
  */
 struct ufshpb_dh_lun {
 	struct list_head list;
@@ -174,6 +181,8 @@ struct ufshpb_dh_lun {
 	struct mutex eviction_lock;
 
 	struct workqueue_struct *wq;
+	struct work_struct reads_normalization_work;
+	struct work_struct writes_normalization_work;
 	unsigned long work_lock;
 };
 
@@ -195,6 +204,201 @@ static unsigned char order;
 static unsigned long region_size;
 static unsigned long subregion_size;
 static unsigned int subregions_per_region;
+/* Lookup constants */
+static unsigned int entries_per_region_shift;
+static unsigned int entries_per_region_mask;
+static unsigned int entries_per_subregion_shift;
+static unsigned int entries_per_subregion_mask;
+
+static inline unsigned int ufshpb_lba_to_region(u64 lba)
+{
+	return lba >> entries_per_region_shift;
+}
+
+static inline unsigned int ufshpb_lba_to_subregion(u64 lba)
+{
+	unsigned int offset = lba & entries_per_region_mask;
+
+	return offset >> entries_per_region_shift;
+}
+
+static inline unsigned int ufshpb_lba_to_entry(u64 lba)
+{
+	unsigned int offset = lba & entries_per_region_mask;
+
+	return offset & entries_per_subregion_mask;
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
+static void __update_read_counters(struct ufshpb_dh_lun *hpb,
+				   struct ufshpb_region *r,
+				   struct ufshpb_subregion *s, u64 nr_blocks)
+{
+	enum ufshpb_state s_state;
+
+	atomic64_add(nr_blocks, &s->reads);
+	atomic64_add(nr_blocks, &r->reads);
+
+	/* normalize read counters if needed */
+	if (atomic64_read(&r->reads) >= READ_NORMALIZATION * entries_per_region)
+		queue_work(hpb->wq, &hpb->reads_normalization_work);
+
+	rcu_read_lock();
+	s_state = s->state;
+	rcu_read_unlock();
+
+	if (s_state != HPB_STATE_ACTIVE) {
+		unsigned int activation_threshold =
+			ACTIVATION_READS * entries_per_subregion / 100;
+
+		if (atomic64_read(&s->reads) > activation_threshold) {
+			set_bit(SUBREGION_EVENT_READ, &s->event);
+			schedule_work(&s->hpb_work);
+		}
+	} else if (atomic64_read(&s->writes) >= SET_AS_DIRTY &&
+		   ufshpb_can_send_read_buffer(s)) {
+		/*
+		 * subregion is active and dirty.  reads keep coming, but the
+		 * device hasn't sent update signal yet.  We better update its
+		 * L2P DB so we can benefit from HPB-READing it
+		 */
+		set_bit(SUBREGION_EVENT_UPDATE, &s->event);
+		schedule_work(&s->hpb_work);
+	}
+}
+
+static void __update_write_counters(struct ufshpb_dh_lun *hpb,
+				    struct ufshpb_region *r,
+				    struct ufshpb_subregion *s, u64 nr_blocks)
+{
+	enum ufshpb_state s_state;
+
+	atomic64_add(nr_blocks, &s->writes);
+	atomic64_add(nr_blocks, &r->writes);
+
+	/* normalize write counters if needed */
+	if (atomic64_read(&r->writes) >= WRITE_NORMALIZATION * entries_per_region)
+		queue_work(hpb->wq, &hpb->writes_normalization_work);
+
+	rcu_read_lock();
+	s_state = s->state;
+	rcu_read_unlock();
+
+	if (s_state == HPB_STATE_ACTIVE) {
+		unsigned int inactivation_threshold =
+			INACTIVATION_WRITES * entries_per_subregion / 100;
+
+		if (atomic64_read(&s->writes) > inactivation_threshold) {
+			if (test_bit(s->region, s->hpb->pinned_map))
+				set_bit(SUBREGION_EVENT_UPDATE, &s->event);
+			else
+				set_bit(SUBREGION_EVENT_DIRTY_THRESHOLD,
+					&s->event);
+			schedule_work(&s->hpb_work);
+		}
+	}
+}
+
+static void __update_rw_counters(struct ufshpb_dh_lun *hpb, u64 start_lba,
+				u64 end_lba, enum req_opf op)
+{
+	struct ufshpb_region *r;
+	struct ufshpb_subregion *s;
+	unsigned int end_region, end_subregion;
+	u64 first_lba, last_lba, nr_blocks;
+	int i, j;
+
+	i = ufshpb_lba_to_region(start_lba);
+	j = ufshpb_lba_to_subregion(start_lba);
+	r = hpb->region_tbl + i;
+	s = r->subregion_tbl + j;
+
+	end_region = ufshpb_lba_to_region(end_lba);
+	end_subregion = ufshpb_lba_to_subregion(end_lba);
+
+	if (i == end_region && j == end_subregion) {
+		first_lba = start_lba;
+		goto last_subregion;
+	}
+
+	first_lba = ((u64)i * subregions_per_region + j)
+		    * entries_per_subregion;
+	last_lba = first_lba + entries_per_subregion;
+	nr_blocks =  last_lba - start_lba;
+
+	if (op == REQ_OP_READ)
+		__update_read_counters(hpb, r, s, nr_blocks);
+	else
+		__update_write_counters(hpb, r, s, nr_blocks);
+
+	nr_blocks = entries_per_subregion;
+	while (last_lba < end_lba) {
+		first_lba += entries_per_subregion;
+		last_lba += entries_per_subregion;
+
+		i = ufshpb_lba_to_region(first_lba);
+		j = ufshpb_lba_to_subregion(first_lba);
+
+		r = hpb->region_tbl + i;
+		s = r->subregion_tbl + j;
+
+		if (op == REQ_OP_READ)
+			__update_read_counters(hpb, r, s, nr_blocks);
+		else
+			__update_write_counters(hpb, r, s, nr_blocks);
+	}
+
+last_subregion:
+	nr_blocks =  end_lba - first_lba;
+	if (op == REQ_OP_READ)
+		__update_read_counters(hpb, r, s, nr_blocks);
+	else
+		__update_write_counters(hpb, r, s, nr_blocks);
+}
+
+/* Call this on read from prep_fn */
+static bool ufshpb_test_block_dirty(struct ufshpb_dh_data *h,
+				    struct request *rq, u64 start_lba,
+				    u32 nr_blocks)
+{
+	struct ufshpb_dh_lun *hpb = h->hpb;
+	u64 end_lba = start_lba + nr_blocks;
+	unsigned int region = ufshpb_lba_to_region(start_lba);
+	unsigned int subregion = ufshpb_lba_to_subregion(start_lba);
+	struct ufshpb_region *r = hpb->region_tbl + region;
+	struct ufshpb_subregion *s = r->subregion_tbl + subregion;
+	enum ufshpb_state s_state;
+
+	__update_rw_counters(hpb, start_lba, end_lba, REQ_OP_READ);
+
+	rcu_read_lock();
+	s_state = s->state;
+	rcu_read_unlock();
+
+	if (s_state != HPB_STATE_ACTIVE)
+		return true;
+
+	return (atomic64_read(&s->writes) >= SET_AS_DIRTY);
+}
+
+/* Call this on write from prep_fn */
+static void ufshpb_set_block_dirty(struct ufshpb_dh_data *h,
+				   struct request *rq, u64 start_lba,
+				   u32 nr_blocks)
+{
+	struct ufshpb_dh_lun *hpb = h->hpb;
+
+	__update_rw_counters(hpb, start_lba, start_lba + nr_blocks,
+			     REQ_OP_WRITE);
+}
 
 static inline void ufshpb_set_write_buf_cmd(unsigned char *cmd,
 					    unsigned int region)
@@ -405,15 +609,6 @@ static int __subregion_activate(struct ufshpb_dh_lun *hpb,
 	return ret;
 }
 
-static inline bool ufshpb_can_send_read_buffer(struct ufshpb_subregion *s)
-{
-	unsigned int activation_threshold = READS_READ_BUFFER_SENT *
-					    entries_per_subregion / 100;
-
-	return atomic64_read(&s->reads) - atomic64_read(&s->reads_last_trial)
-		>= activation_threshold;
-}
-
 static int ufshpb_subregion_activate(struct ufshpb_dh_lun *hpb,
 				      struct ufshpb_region *r,
 				      struct ufshpb_subregion *s, bool init)
@@ -575,6 +770,55 @@ static void ufshpb_subregion_update(struct ufshpb_dh_lun *hpb,
 	s->state = HPB_STATE_ACTIVE;
 }
 
+static void ufshpb_reads_normalization_work_handler(struct work_struct *work)
+{
+	struct ufshpb_dh_lun *hpb = container_of(work, struct ufshpb_dh_lun,
+						 reads_normalization_work);
+	struct ufshpb_region *regions = hpb->region_tbl;
+	int i, j;
+
+	for (i = 0; i < hpb->regions_per_lun; i++) {
+		struct ufshpb_region *r = regions + i;
+		struct ufshpb_subregion *subregions = r->subregion_tbl;
+
+		for (j = 0; j < subregions_per_region; j++) {
+			struct ufshpb_subregion *s = subregions + j;
+			u64 last_trial = atomic64_read(&s->reads_last_trial);
+			u64 curr_reads = atomic64_read(&s->reads);
+
+			atomic64_set(&s->reads, curr_reads >> 1);
+			if (last_trial > curr_reads)
+				atomic64_sub(curr_reads, &s->reads_last_trial);
+			else
+				atomic64_set(&s->reads_last_trial, 0);
+		}
+
+		atomic64_set(&r->reads, atomic64_read(&r->reads) >> 1);
+	}
+}
+
+static void ufshpb_writes_normalization_work_handler(struct work_struct *work)
+{
+	struct ufshpb_dh_lun *hpb = container_of(work, struct ufshpb_dh_lun,
+						 writes_normalization_work);
+	struct ufshpb_region *regions = hpb->region_tbl;
+	int i, j;
+
+	for (i = 0; i < hpb->regions_per_lun; i++) {
+		struct ufshpb_region *r = regions + i;
+		struct ufshpb_subregion *subregions = r->subregion_tbl;
+
+		for (j = 0; j < subregions_per_region; j++) {
+			struct ufshpb_subregion *s = subregions + j;
+			u64 curr_writes = atomic64_read(&s->writes);
+
+			atomic64_set(&s->writes, curr_writes >> 1);
+		}
+
+		atomic64_set(&r->writes, atomic64_read(&r->writes) >> 1);
+	}
+}
+
 /*
  * ufshpb_dispatch - ufshpb state machine
  * make the various decisions based on region/subregion state & events
@@ -631,6 +875,9 @@ static void ufshpb_work_handler(struct work_struct *work)
 	ufshpb_dispatch(s->hpb, s->r, s);
 
 	mutex_unlock(&s->state_lock);
+
+	/* the subregion state might has changed */
+	synchronize_rcu();
 }
 
 static int ufshpb_activate_pinned_regions(struct ufshpb_dh_data *h, bool init)
@@ -679,6 +926,12 @@ static int ufshpb_activate_pinned_regions(struct ufshpb_dh_data *h, bool init)
 		set_bit(start_idx + i, hpb->pinned_map);
 	}
 
+	/*
+	 * those subregions of the pinned regions changed their state - they
+	 * are active now
+	 */
+	synchronize_rcu();
+
 	return ret;
 }
 
@@ -713,6 +966,9 @@ static void ufshpb_lun_reset_work_handler(struct work_struct *work)
 		__region_reset(hpb, r);
 	}
 
+	/* update rcu post lun reset */
+	synchronize_rcu();
+
 	clear_bit(LUN_RESET_WORK, &hpb->work_lock);
 
 	sdev_printk(KERN_INFO, hpb->sdev, "%s: lun reset [%llu]\n",
@@ -789,6 +1045,10 @@ static int ufshpb_region_tbl_init(struct ufshpb_dh_lun *hpb)
 	hpb->region_tbl = regions;
 	mutex_init(&hpb->eviction_lock);
 	INIT_WORK(&hpb->lun_reset_work, ufshpb_lun_reset_work_handler);
+	INIT_WORK(&hpb->reads_normalization_work,
+		  ufshpb_reads_normalization_work_handler);
+	INIT_WORK(&hpb->writes_normalization_work,
+		  ufshpb_writes_normalization_work_handler);
 
 	return 0;
 
@@ -875,10 +1135,94 @@ static void ufshpb_get_config(const struct ufshpb_config *c)
 	entries_per_subregion = BIT(c->subregion_size - 3);
 	order = get_order(entries_per_subregion * HPB_ENTRY_SIZE);
 
+	entries_per_region_shift = ilog2(entries_per_region) - 1;
+	entries_per_region_mask = entries_per_region - 1;
+	entries_per_subregion_shift = ilog2(entries_per_subregion) - 1;
+	entries_per_subregion_mask = entries_per_subregion - 1;
+
 	INIT_LIST_HEAD(&lh_hpb_lunp);
 	is_configured = true;
 }
 
+static void ufshpb_set_read_cmd(unsigned char *cmd, u32 lba, u64 ppa,
+				unsigned char len)
+{
+	cmd[0] = UFSHPB_READ;
+	cmd[1] = 0;
+	put_unaligned_be32(lba, &cmd[2]);
+	put_unaligned_be64(ppa, &cmd[6]);
+	cmd[14] = len;
+	cmd[9] = 0;
+}
+
+static void ufshpb_prepare_hpb_read_cmd(struct request *rq,
+					struct ufshpb_dh_lun *hpb, u64 lba,
+					u8 len)
+{
+	unsigned int region = ufshpb_lba_to_region(lba);
+	unsigned int subregion = ufshpb_lba_to_subregion(lba);
+	unsigned int entry = ufshpb_lba_to_entry(lba);
+	struct ufshpb_region *r = hpb->region_tbl + region;
+	struct ufshpb_subregion *s = r->subregion_tbl + subregion;
+	unsigned char *buf;
+	unsigned char cmnd[BLK_MAX_CDB] = {};
+	unsigned int page_index, page_offset;
+	u64 ppa;
+
+	page_index = entry / HPB_ENTRIES_PER_PAGE;
+	page_offset = entry % HPB_ENTRIES_PER_PAGE;
+
+	if (page_index > BIT(order)) {
+		/* TODO: is this even possible ??? */
+		sdev_printk(KERN_ERR, hpb->sdev,
+			    "%s: lba out of range [%llu/%u/%u/%u/%u/%u]\n",
+			    UFSHPB_NAME, lba, r->region, s->subregion, entry,
+			    page_index, page_offset);
+		return;
+	}
+
+	if (!s->mctx || !s->mctx->pages) {
+		/* subregion got inactivated */
+		return;
+	}
+
+	buf = s->mctx->pages + page_index * PAGE_SIZE;
+	ppa = (u64)buf[page_offset];
+
+	ufshpb_set_read_cmd(cmnd, (u32)lba, ppa, len);
+
+	memcpy(scsi_req(rq)->cmd, cmnd, sizeof(cmnd));
+
+	rq->cmd_flags = REQ_OP_DRV_IN;
+}
+
+/*
+ * ufshpb_prep_fn - Construct HPB_READ when possible
+ */
+static blk_status_t ufshpb_prep_fn(struct scsi_device *sdev, struct request *rq)
+{
+	struct ufshpb_dh_data *h = sdev->handler_data;
+	struct ufshpb_dh_lun *hpb = h->hpb;
+	u64 lba = sectors_to_logical(sdev, blk_rq_pos(rq));
+	u32 nr_blocks = sectors_to_logical(sdev, blk_rq_sectors(rq));
+
+	if (op_is_write(req_op(rq)) || op_is_discard(req_op(rq))) {
+		ufshpb_set_block_dirty(h, rq, lba, nr_blocks);
+		goto out;
+	}
+
+	if (req_op(rq) != REQ_OP_READ || nr_blocks > 255)
+		goto out;
+
+	if (ufshpb_test_block_dirty(h, rq, lba, nr_blocks))
+		goto out;
+
+	ufshpb_prepare_hpb_read_cmd(rq, hpb, lba, (u8)nr_blocks);
+
+out:
+	return BLK_STS_OK;
+}
+
 /*
  * ufshpb_set_params - obtain response from the device
  * @sdev: scsi device of the hpb lun
@@ -1069,6 +1413,7 @@ static struct scsi_device_handler ufshpb_dh = {
 	.attach		= ufshpb_attach,
 	.detach		= ufshpb_detach,
 	.activate	= ufshpb_activate,
+	.prep_fn	= ufshpb_prep_fn,
 	.set_params     = ufshpb_set_params,
 };
 
-- 
2.7.4

