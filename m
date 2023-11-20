Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24A339F;
	Mon, 20 Nov 2023 15:03:22 -0800 (PST)
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1cf63ca9b1bso9743855ad.3;
        Mon, 20 Nov 2023 15:03:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700521401; x=1701126201;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z2UEv7U1fibB8ztmSv2Lpzw4U6RFbfvK3CU9E2inLvA=;
        b=B3d5NWgbkKil32OGXwabZeH2pNGMlamvHebphrhq1lz9AGqV8lqSY/e6juMm7TYlSK
         6JUCGZ9Qjh/Ykj/96nXmYusoCf5UpwDkTgmUoBeAJv3aCTNy+cz6uEU6tBY+ZCXHXEe+
         mWBux3PjEjyr59xzaQnftTbIZnq4CRpGI7zQZ8sfdmlfWwLoq52Ap44w8WvrbHowzAM9
         KEiOuEfTZg/EA8Caft9BG7KiHO+RqtG/c/KxNRk1xFxXKTLq8KAb9INAnuysHPAD6qtf
         rv2zM9oO6bi/s66RnIH8zGQ7kR32XHO80ka2J5GoVX1rfO4cVJ4r5qZbjkFyWKcjg78w
         mWOA==
X-Gm-Message-State: AOJu0YwWORSl4B6CrRPmZ1RN8S+6iGjlnVPF1eK9Mnlf2G7V4umPY2GR
	1BZpbCvrUD+IDX1HCPEO3yw=
X-Google-Smtp-Source: AGHT+IFcsnhoTXXi1l5jEFe7/aCmqjVk0UlNVYt7D1hvxXXvLyuzKeX5Sj6xkF8ODb4koO5J4vDcWQ==
X-Received: by 2002:a17:902:e74c:b0:1cc:2f70:4865 with SMTP id p12-20020a170902e74c00b001cc2f704865mr2455928plf.26.1700521401404;
        Mon, 20 Nov 2023 15:03:21 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:bb61:2ac8:4d61:2b3d? ([2620:0:1000:8411:bb61:2ac8:4d61:2b3d])
        by smtp.gmail.com with ESMTPSA id i2-20020a17090332c200b001c9bc811d4dsm6562430plr.295.2023.11.20.15.03.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Nov 2023 15:03:20 -0800 (PST)
Message-ID: <ef7de6b5-2ed3-469e-bb01-4eacda62cd6a@acm.org>
Date: Mon, 20 Nov 2023 15:03:19 -0800
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
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <d1e94a08-f28e-ddd9-5bda-7fee28b87f31@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/15/23 17:08, Yu Kuai wrote:
> Hi,
> 
> 在 2023/11/16 2:19, Bart Van Assche 写道:
>> On 11/14/23 23:24, Yu Kuai wrote:
>>> 在 2023/11/15 2:04, Bart Van Assche 写道:
>>>> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
>>>> index d7f51b84f3c7..872f87001374 100644
>>>> --- a/drivers/scsi/hosts.c
>>>> +++ b/drivers/scsi/hosts.c
>>>> @@ -442,6 +442,7 @@ struct Scsi_Host *scsi_host_alloc(const struct scsi_host_template *sht, int priv
>>>>       shost->no_write_same = sht->no_write_same;
>>>>       shost->host_tagset = sht->host_tagset;
>>>>       shost->queuecommand_may_block = sht->queuecommand_may_block;
>>>> +    shost->disable_fair_tag_sharing = sht->disable_fair_tag_sharing;
>>>
>>> Can we also consider to disable fair tag sharing by default for the
>>> driver that total driver tags is less than a threshold?
>> I don't want to do this because such a change could disable fair tag
>> sharing for drivers that support both SSDs and hard disks being associated
>> with a single SCSI host.
> 
> Ok, then is this possible to add a sysfs entry to disable/enable fair
> tag sharing manually?

How about replacing patch 1/3 from this series with the patch below?

Thanks,

Bart.


     block: Make fair tag sharing configurable

     The fair sharing algorithm has a negative performance impact for storage
     devices for which the full queue depth is required to reach peak
     performance, e.g. UFS devices. This is because it takes long after a
     request queue became inactive until tags are reassigned to the active
     request queue(s). Since making tag sharing fair is not needed if the
     request processing latency is similar for all request queues, introduce
     a sysfs attribute for controlling the fair tag sharing algorithm.
     Increase BLK_MQ_F_ALLOC_POLICY_START_BIT to prevent that the fair tag
     sharing flag overlaps with the tag allocation policy.

     Cc: Christoph Hellwig <hch@lst.de>
     Cc: Martin K. Petersen <martin.petersen@oracle.com>
     Cc: Ming Lei <ming.lei@redhat.com>
     Cc: Keith Busch <kbusch@kernel.org>
     Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
     Cc: Yu Kuai <yukuai1@huaweicloud.com>
     Cc: Ed Tsai <ed.tsai@mediatek.com>
     Signed-off-by: Bart Van Assche <bvanassche@acm.org>

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
index 63e481262336..f044bbe57509 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -473,6 +473,43 @@ static ssize_t queue_dax_show(struct request_queue *q, char *page)
  	return queue_var_show(blk_queue_dax(q), page);
  }

+static ssize_t queue_fair_sharing_show(struct request_queue *q, char *page)
+{
+	struct blk_mq_hw_ctx *hctx;
+	unsigned long i;
+	bool fair_sharing = true;
+
+	/* q->sysfs_lock serializes against blk_mq_realloc_hw_ctxs() */
+	queue_for_each_hw_ctx(q, hctx, i)
+		if (hctx->flags & BLK_MQ_F_DISABLE_FAIR_TAG_SHARING)
+			fair_sharing = false;
+
+	return sysfs_emit(page, "%u\n", fair_sharing);
+}
+
+static ssize_t queue_fair_sharing_store(struct request_queue *q,
+					const char *page, size_t count)
+{
+	struct blk_mq_hw_ctx *hctx;
+	unsigned long i;
+	int res, val;
+
+	res = kstrtoint(page, 0, &val);
+	if (res < 0)
+		return res;
+
+	/* q->sysfs_lock serializes against blk_mq_realloc_hw_ctxs() */
+	if (val) {
+		queue_for_each_hw_ctx(q, hctx, i)
+			hctx->flags &= ~BLK_MQ_F_DISABLE_FAIR_TAG_SHARING;
+	} else {
+		queue_for_each_hw_ctx(q, hctx, i)
+			hctx->flags |= BLK_MQ_F_DISABLE_FAIR_TAG_SHARING;
+	}
+
+	return count;
+}
+
  #define QUEUE_RO_ENTRY(_prefix, _name)			\
  static struct queue_sysfs_entry _prefix##_entry = {	\
  	.attr	= { .name = _name, .mode = 0444 },	\
@@ -542,6 +579,7 @@ QUEUE_RW_ENTRY(queue_nonrot, "rotational");
  QUEUE_RW_ENTRY(queue_iostats, "iostats");
  QUEUE_RW_ENTRY(queue_random, "add_random");
  QUEUE_RW_ENTRY(queue_stable_writes, "stable_writes");
+QUEUE_RW_ENTRY(queue_fair_sharing, "fair_sharing");

  #ifdef CONFIG_BLK_WBT
  static ssize_t queue_var_store64(s64 *var, const char *page)
@@ -664,6 +702,7 @@ static struct attribute *blk_mq_queue_attrs[] = {
  	&elv_iosched_entry.attr,
  	&queue_rq_affinity_entry.attr,
  	&queue_io_timeout_entry.attr,
+	&queue_fair_sharing_entry.attr,
  #ifdef CONFIG_BLK_WBT
  	&queue_wb_lat_entry.attr,
  #endif
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 1ab3081c82ed..fd5a51e8b628 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -662,7 +662,8 @@ enum {
  	 * or shared hwqs instead of 'mq-deadline'.
  	 */
  	BLK_MQ_F_NO_SCHED_BY_DEFAULT	= 1 << 7,
-	BLK_MQ_F_ALLOC_POLICY_START_BIT = 8,
+	BLK_MQ_F_DISABLE_FAIR_TAG_SHARING = 1 << 8,
+	BLK_MQ_F_ALLOC_POLICY_START_BIT = 16,
  	BLK_MQ_F_ALLOC_POLICY_BITS = 1,

  	BLK_MQ_S_STOPPED	= 0,

