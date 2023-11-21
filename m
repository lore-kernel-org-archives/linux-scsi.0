Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06FA1193;
	Tue, 21 Nov 2023 11:32:34 -0800 (PST)
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-5aa481d53e5so4009256a12.1;
        Tue, 21 Nov 2023 11:32:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700595153; x=1701199953;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HlK+btcWF9pK+90VQkpJ0Q5fdrA5yRO3HRwLpKJ011E=;
        b=S8SAOdP20tOolCHJ6n6hDcdfd7c/bEEeOK8nz63i4AY76ozhS8QTBj1ak7bxs1Bt3T
         ZK+qFsETkT4/wwL+e/K1Pd+yxI7j12maz0YlLEDs1Jbn5WNhVk/250OdjhMCXJsynmEU
         3ZZleg4DUARKrhzwyO7REXztwmJrYP/9Tb6MySZb8Jg366uJg8RootyPzM8+bClwjf4W
         vlQfD2kR20d8ZKoAV6tFkxhgV7FjDOp7IU9fbV4TkuAbfIwfg05fUo5SMZpxpPXgxOTf
         oPhDr/PRFNiUmXl1OhfOMZQampq2yj/QHbbdKGgQXAaAN0HI+KsVexLxujRyUY/Rk0aE
         PBfg==
X-Gm-Message-State: AOJu0YxVJGMPX8aWvfO61SUP1yul3+DtMzm556Ne89Btq+U84OB3DkvX
	SvcswwWFpYxZCjl5tzDEKZI=
X-Google-Smtp-Source: AGHT+IHDUiaUxNPJMTo3j90LUq5DfbZfQJCfifmk6VoQ758ZxPuS5uaQwg8D6SeHMZVZokkpuTClmg==
X-Received: by 2002:a05:6a20:d396:b0:163:a041:336c with SMTP id iq22-20020a056a20d39600b00163a041336cmr11653950pzb.48.1700595153274;
        Tue, 21 Nov 2023 11:32:33 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:bb61:2ac8:4d61:2b3d? ([2620:0:1000:8411:bb61:2ac8:4d61:2b3d])
        by smtp.gmail.com with ESMTPSA id b5-20020aa78105000000b00693411c6c3csm8279464pfi.39.2023.11.21.11.32.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Nov 2023 11:32:32 -0800 (PST)
Message-ID: <5dd7b7f7-bcae-4769-b6c8-ac0da8e69c93@acm.org>
Date: Tue, 21 Nov 2023 11:32:28 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/3] scsi: core: Support disabling fair tag sharing
Content-Language: en-US
To: Yu Kuai <yukuai1@huaweicloud.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
 Keith Busch <kbusch@kernel.org>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Ed Tsai <ed.tsai@mediatek.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20231114180426.1184601-1-bvanassche@acm.org>
 <20231114180426.1184601-3-bvanassche@acm.org>
 <80dee412-2fda-6a23-0b62-08f87bd7e607@huaweicloud.com>
 <d706f265-f991-45c0-a551-34ecdee55f7c@acm.org>
 <d1e94a08-f28e-ddd9-5bda-7fee28b87f31@huaweicloud.com>
 <ef7de6b5-2ed3-469e-bb01-4eacda62cd6a@acm.org>
 <e5e8e995-c38b-7b23-a0a9-5b2f285164c8@huaweicloud.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <e5e8e995-c38b-7b23-a0a9-5b2f285164c8@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/20/23 17:35, Yu Kuai wrote:
> I'm not sure that change just one queue instead of all queues using the
> same tag_set won't case any regression, for example,
> BLK_MQ_F_TAG_QUEUE_SHARED is not cleared, and other queues are still
> sharing tags fairly while this queue doesn't.
> 
> Perhaps can we add a helper similiar to __blk_mq_update_nr_hw_queues
> to update all queues using the same tag_set?

Hi Kuai,

How about the patch below?

Thanks,

Bart.


diff --git a/Documentation/ABI/stable/sysfs-block b/Documentation/ABI/stable/sysfs-block
index 1fe9a553c37b..7b66eb938882 100644
--- a/Documentation/ABI/stable/sysfs-block
+++ b/Documentation/ABI/stable/sysfs-block
@@ -269,6 +269,19 @@ Description:
  		specific passthrough mechanisms.


+What:		/sys/block/<disk>/queue/fair_sharing
+Date:		November 2023
+Contact:	linux-block@vger.kernel.org
+Description:
+		[RW] If hardware queues are shared across request queues, by
+		default the request tags are distributed evenly across the
+		active request queues. If the total number of tags is low and
+		if the workload differs per request queue this approach may
+		reduce throughput. This sysfs attribute controls whether or not
+		the fair tag sharing algorithm is enabled. 1 means enabled
+		while 0 means disabled.
+
+
  What:		/sys/block/<disk>/queue/fua
  Date:		May 2018
  Contact:	linux-block@vger.kernel.org
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
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 0b2d04766324..0009450dc8cf 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -24,6 +24,7 @@ struct queue_sysfs_entry {
  	struct attribute attr;
  	ssize_t (*show)(struct request_queue *, char *);
  	ssize_t (*store)(struct request_queue *, const char *, size_t);
+	bool no_sysfs_mutex;
  };

  static ssize_t
@@ -473,6 +474,55 @@ static ssize_t queue_dax_show(struct request_queue *q, char *page)
  	return queue_var_show(blk_queue_dax(q), page);
  }

+static ssize_t queue_fair_sharing_show(struct request_queue *q, char *page)
+{
+	struct blk_mq_hw_ctx *hctx;
+	unsigned long i;
+	bool fair_sharing = true;
+
+	/* Serialize against blk_mq_realloc_hw_ctxs() */
+	mutex_lock(&q->sysfs_lock);
+	queue_for_each_hw_ctx(q, hctx, i)
+		if (hctx->flags & BLK_MQ_F_DISABLE_FAIR_TAG_SHARING)
+			fair_sharing = false;
+	mutex_unlock(&q->sysfs_lock);
+
+	return sysfs_emit(page, "%u\n", fair_sharing);
+}
+
+static ssize_t queue_fair_sharing_store(struct request_queue *q,
+					const char *page, size_t count)
+{
+	const unsigned int DFTS_BIT = ilog2(BLK_MQ_F_DISABLE_FAIR_TAG_SHARING);
+	struct blk_mq_tag_set *set = q->tag_set;
+	struct blk_mq_hw_ctx *hctx;
+	unsigned long i;
+	int res;
+	bool val;
+
+	res = kstrtobool(page, &val);
+	if (res < 0)
+		return res;
+
+	mutex_lock(&set->tag_list_lock);
+	clear_bit(DFTS_BIT, &set->flags);
+	list_for_each_entry(q, &set->tag_list, tag_set_list) {
+		/* Serialize against blk_mq_realloc_hw_ctxs() */
+		mutex_lock(&q->sysfs_lock);
+		if (val) {
+			queue_for_each_hw_ctx(q, hctx, i)
+				clear_bit(DFTS_BIT, &hctx->flags);
+		} else {
+			queue_for_each_hw_ctx(q, hctx, i)
+				set_bit(DFTS_BIT, &hctx->flags);
+		}
+		mutex_unlock(&q->sysfs_lock);
+	}
+	mutex_unlock(&set->tag_list_lock);
+
+	return count;
+}
+
  #define QUEUE_RO_ENTRY(_prefix, _name)			\
  static struct queue_sysfs_entry _prefix##_entry = {	\
  	.attr	= { .name = _name, .mode = 0444 },	\
@@ -486,6 +536,14 @@ static struct queue_sysfs_entry _prefix##_entry = {	\
  	.store	= _prefix##_store,			\
  };

+#define QUEUE_RW_ENTRY_NO_SYSFS_MUTEX(_prefix, _name)       \
+	static struct queue_sysfs_entry _prefix##_entry = { \
+		.attr = { .name = _name, .mode = 0644 },    \
+		.show = _prefix##_show,                     \
+		.store = _prefix##_store,                   \
+		.no_sysfs_mutex = true,                     \
+	};
+
  QUEUE_RW_ENTRY(queue_requests, "nr_requests");
  QUEUE_RW_ENTRY(queue_ra, "read_ahead_kb");
  QUEUE_RW_ENTRY(queue_max_sectors, "max_sectors_kb");
@@ -542,6 +600,7 @@ QUEUE_RW_ENTRY(queue_nonrot, "rotational");
  QUEUE_RW_ENTRY(queue_iostats, "iostats");
  QUEUE_RW_ENTRY(queue_random, "add_random");
  QUEUE_RW_ENTRY(queue_stable_writes, "stable_writes");
+QUEUE_RW_ENTRY_NO_SYSFS_MUTEX(queue_fair_sharing, "fair_sharing");

  #ifdef CONFIG_BLK_WBT
  static ssize_t queue_var_store64(s64 *var, const char *page)
@@ -666,6 +725,7 @@ static struct attribute *blk_mq_queue_attrs[] = {
  	&elv_iosched_entry.attr,
  	&queue_rq_affinity_entry.attr,
  	&queue_io_timeout_entry.attr,
+	&queue_fair_sharing_entry.attr,
  #ifdef CONFIG_BLK_WBT
  	&queue_wb_lat_entry.attr,
  #endif
@@ -723,6 +783,10 @@ queue_attr_show(struct kobject *kobj, struct attribute *attr, char *page)

  	if (!entry->show)
  		return -EIO;
+
+	if (entry->no_sysfs_mutex)
+		return entry->show(q, page);
+
  	mutex_lock(&q->sysfs_lock);
  	res = entry->show(q, page);
  	mutex_unlock(&q->sysfs_lock);
@@ -741,6 +805,9 @@ queue_attr_store(struct kobject *kobj, struct attribute *attr,
  	if (!entry->store)
  		return -EIO;

+	if (entry->no_sysfs_mutex)
+		return entry->store(q, page, length);
+
  	mutex_lock(&q->sysfs_lock);
  	res = entry->store(q, page, length);
  	mutex_unlock(&q->sysfs_lock);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 1ab3081c82ed..aadb74aa23a3 100644
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

