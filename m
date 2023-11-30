Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B6ED4A;
	Thu, 30 Nov 2023 11:31:46 -0800 (PST)
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-3b88f2a37deso840992b6e.0;
        Thu, 30 Nov 2023 11:31:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701372706; x=1701977506;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hx1Xh++ESCAV8y2AlqKHPhWzurlG0Vw7YPn+CtHrVz4=;
        b=uGXz1Hk6X29xSWNjtw+s5LoAu9jOgsxJViMJFaFuSgsTZTn7U/ptfXUbdz9sz/VLOu
         GCswkLTSWwm/JDhKLS12ZFAfsTULsfq5u2W2jlN3pOqxZrLDbafJN0tAK/YlEKKODtOI
         q+JRlXeO4AmOsYnWSFt/tv2GKJJUVRpt0lIQyFx8DQGmZ5X202eKvzFxgmgWyCTedHHb
         cs09Z+ZkyjFE8XVV4UXPMw1VK4chY/iE2gRjjbCpYTRQSuDqTs5i8z0Nqy5EVd+kaDc5
         6F2f3G3idiiaR7NUWD/Qj3RwyAfuqEWYZ8MTryacSlGqe7p9OdpIrQacEkNllGW+v5Vx
         pjXA==
X-Gm-Message-State: AOJu0Yy3E9wqJ/8ZEQxGpkzJExn1MUTeOuv5hxQPLmkMBVY5X3CSJyWH
	7Ph6uqTEORYRr5msE8Vnn88=
X-Google-Smtp-Source: AGHT+IEk8ZrJloXY7RO6vR/KsPx0JaKJiu+Hoi6EsuUEnlGN5cMJSI77hUY8cJjchwBle3f3soN5EA==
X-Received: by 2002:a05:6808:d47:b0:3ae:126b:8c2b with SMTP id w7-20020a0568080d4700b003ae126b8c2bmr672432oik.30.1701372705682;
        Thu, 30 Nov 2023 11:31:45 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:0:1000:8411:8572:6fe3:eaf0:3b9d])
        by smtp.gmail.com with ESMTPSA id m127-20020a632685000000b005c606b44405sm1635365pgm.67.2023.11.30.11.31.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 11:31:45 -0800 (PST)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>,
	Ming Lei <ming.lei@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Yu Kuai <yukuai1@huaweicloud.com>,
	Ed Tsai <ed.tsai@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: [PATCH v6 1/4] block: Make fair tag sharing configurable
Date: Thu, 30 Nov 2023 11:31:28 -0800
Message-ID: <20231130193139.880955-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
In-Reply-To: <20231130193139.880955-1-bvanassche@acm.org>
References: <20231130193139.880955-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The fair sharing algorithm has a negative performance impact for storage
devices for which the full queue depth is required to reach peak
performance, e.g. UFS devices. This is because it takes long after a
request queue became inactive until tags are reassigned to the active
request queue(s). Since making tag sharing fair is not needed if the
request processing latency is similar for all request queues, introduce
a function for configuring fair tag sharing. Increase
BLK_MQ_F_ALLOC_POLICY_START_BIT to prevent that the fair tag sharing
flag overlaps with the tag allocation policy.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Ed Tsai <ed.tsai@mediatek.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-mq-debugfs.c |  1 +
 block/blk-mq.c         | 28 ++++++++++++++++++++++++++++
 block/blk-mq.h         |  3 ++-
 include/linux/blk-mq.h |  6 ++++--
 4 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index 5cbeb9344f2f..f41408103106 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -198,6 +198,7 @@ static const char *const hctx_flag_name[] = {
 	HCTX_FLAG_NAME(NO_SCHED),
 	HCTX_FLAG_NAME(STACKING),
 	HCTX_FLAG_NAME(TAG_HCTX_SHARED),
+	HCTX_FLAG_NAME(DISABLE_FAIR_TAG_SHARING),
 };
 #undef HCTX_FLAG_NAME
 
diff --git a/block/blk-mq.c b/block/blk-mq.c
index b8093155df8d..206295606cec 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4569,6 +4569,34 @@ void blk_mq_free_tag_set(struct blk_mq_tag_set *set)
 }
 EXPORT_SYMBOL(blk_mq_free_tag_set);
 
+/*
+ * Enable or disable fair tag sharing for all request queues associated with
+ * a tag set.
+ */
+void blk_mq_update_fair_sharing(struct blk_mq_tag_set *set, bool enable)
+{
+	const unsigned int DFTS_BIT = ilog2(BLK_MQ_F_DISABLE_FAIR_TAG_SHARING);
+	struct blk_mq_hw_ctx *hctx;
+	struct request_queue *q;
+	unsigned long i;
+
+	/*
+	 * Serialize against blk_mq_update_nr_hw_queues() and
+	 * blk_mq_realloc_hw_ctxs().
+	 */
+	mutex_lock(&set->tag_list_lock);
+	list_for_each_entry(q, &set->tag_list, tag_set_list)
+		blk_mq_freeze_queue(q);
+	assign_bit(DFTS_BIT, &set->flags, !enable);
+	list_for_each_entry(q, &set->tag_list, tag_set_list)
+		queue_for_each_hw_ctx(q, hctx, i)
+			assign_bit(DFTS_BIT, &hctx->flags, !enable);
+	list_for_each_entry(q, &set->tag_list, tag_set_list)
+		blk_mq_unfreeze_queue(q);
+	mutex_unlock(&set->tag_list_lock);
+}
+EXPORT_SYMBOL(blk_mq_update_fair_sharing);
+
 int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
 {
 	struct blk_mq_tag_set *set = q->tag_set;
diff --git a/block/blk-mq.h b/block/blk-mq.h
index f75a9ecfebde..eda6bd0611ea 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -416,7 +416,8 @@ static inline bool hctx_may_queue(struct blk_mq_hw_ctx *hctx,
 {
 	unsigned int depth, users;
 
-	if (!hctx || !(hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED))
+	if (!hctx || !(hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED) ||
+	    (hctx->flags & BLK_MQ_F_DISABLE_FAIR_TAG_SHARING))
 		return true;
 
 	/*
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 1ab3081c82ed..ddda190b5c24 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -503,7 +503,7 @@ struct blk_mq_tag_set {
 	unsigned int		cmd_size;
 	int			numa_node;
 	unsigned int		timeout;
-	unsigned int		flags;
+	unsigned long		flags;
 	void			*driver_data;
 
 	struct blk_mq_tags	**tags;
@@ -662,7 +662,8 @@ enum {
 	 * or shared hwqs instead of 'mq-deadline'.
 	 */
 	BLK_MQ_F_NO_SCHED_BY_DEFAULT	= 1 << 7,
-	BLK_MQ_F_ALLOC_POLICY_START_BIT = 8,
+	BLK_MQ_F_DISABLE_FAIR_TAG_SHARING = 1 << 8,
+	BLK_MQ_F_ALLOC_POLICY_START_BIT = 16,
 	BLK_MQ_F_ALLOC_POLICY_BITS = 1,
 
 	BLK_MQ_S_STOPPED	= 0,
@@ -705,6 +706,7 @@ int blk_mq_alloc_sq_tag_set(struct blk_mq_tag_set *set,
 		const struct blk_mq_ops *ops, unsigned int queue_depth,
 		unsigned int set_flags);
 void blk_mq_free_tag_set(struct blk_mq_tag_set *set);
+void blk_mq_update_fair_sharing(struct blk_mq_tag_set *set, bool enable);
 
 void blk_mq_free_request(struct request *rq);
 int blk_rq_poll(struct request *rq, struct io_comp_batch *iob,
