Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ACC3814;
	Fri, 12 Jan 2024 01:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4TB3Lw25z4z4f3kj7;
	Fri, 12 Jan 2024 09:08:24 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id D4FC41A038F;
	Fri, 12 Jan 2024 09:08:27 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgAn9g4JkaBlzxdFAg--.52880S3;
	Fri, 12 Jan 2024 09:08:27 +0800 (CST)
Subject: Re: [PATCH v6 1/4] block: Make fair tag sharing configurable
To: Bart Van Assche <bvanassche@acm.org>, Yu Kuai <yukuai1@huaweicloud.com>,
 Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
 Keith Busch <kbusch@kernel.org>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Ed Tsai <ed.tsai@mediatek.com>, Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20231130193139.880955-1-bvanassche@acm.org>
 <20231130193139.880955-2-bvanassche@acm.org>
 <58f50403-fcc9-ec11-f52b-f11ced3d2652@huaweicloud.com>
 <8372f2d0-b695-4af4-90e6-e35b86e3b844@acm.org>
 <c1658336-f48e-5688-f0c2-f325fd5696c3@huaweicloud.com>
 <1d3866af-ffca-4f97-914d-8084aca901ab@acm.org>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <69b17db7-e9c9-df09-1022-ff7a9e5e04dd@huaweicloud.com>
Date: Fri, 12 Jan 2024 09:08:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1d3866af-ffca-4f97-914d-8084aca901ab@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgAn9g4JkaBlzxdFAg--.52880S3
X-Coremail-Antispam: 1UD129KBjvJXoWxAFW8tFyUWF4xCr4xWw18uFg_yoW5tr1xpF
	Z5K3W8K392q3WkZFW8ta17WF1YqrsrWry5Arsaqa4Y9w4UKFZFqFn7JrW5XF4vqr4kArsr
	Zr4DtrWUAr4rurDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9F14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E
	3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcS
	sGvfC2KfnxnUUI43ZEXa7VUbXdbUUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/01/12 3:22, Bart Van Assche 写道:
> On 12/25/23 04:51, Yu Kuai wrote:
>> Are you still intrested in this patchset? I really want this switch in
>> our product as well.
>>
>> If so, how do you think about following changes, a new field in
>> blk_mq_tag_set will make synchronization much eaiser.
> Do you perhaps see the new field as an alternative for the
> BLK_MQ_F_DISABLE_FAIR_TAG_SHARING flag? I'm not sure that would be an
> improvement. hctx_may_queue() is called from the hot path. Using the
> 'flags' field will make it easier for the compiler to optimize that
> function compared to using a new structure member.

Yes, I realized that, handle the new flag in blk_mq_allow_hctx() is
good, how about following chang?

Thanks,
Kuai

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 6ab7f360ff2a..dd7c9e3eca1b 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3706,7 +3706,8 @@ blk_mq_alloc_hctx(struct request_queue *q, struct 
blk_mq_tag_set *set,
         spin_lock_init(&hctx->lock);
         INIT_LIST_HEAD(&hctx->dispatch);
         hctx->queue = q;
-       hctx->flags = set->flags & ~BLK_MQ_F_TAG_QUEUE_SHARED;
+       hctx->flags = set->flags & ~(BLK_MQ_F_TAG_QUEUE_SHARED |
+                                    BLK_MQ_F_DISABLE_FAIR_TAG_SHARING);

         INIT_LIST_HEAD(&hctx->hctx_list);

@@ -3935,6 +3936,37 @@ static void blk_mq_map_swqueue(struct 
request_queue *q)
         }
  }

+static void queue_update_fair_tag_sharing(struct request_queue *q)
+{
+       struct blk_mq_hw_ctx *hctx;
+       unsigned long i;
+       bool disabled = q->tag_set->flags & 
BLK_MQ_F_DISABLE_FAIR_TAG_SHARING;
+
+       lockdep_assert_held(&q->tag_set->tag_list_lock);
+
+       queue_for_each_hw_ctx(q, hctx, i) {
+               if (disabled)
+                       hctx->flags |= BLK_MQ_F_DISABLE_FAIR_TAG_SHARING;
+               else
+                       hctx->flags &= ~BLK_MQ_F_DISABLE_FAIR_TAG_SHARING;
+       }
+
+}
+
+void blk_mq_update_fair_tag_sharing(struct blk_mq_tag_set *set)
+{
+       struct request_queue *q;
+
+       lockdep_assert_held(&set->tag_list_lock);
+
+       list_for_each_entry(q, &set->tag_list, tag_set_list) {
+               blk_mq_freeze_queue(q);
+               queue_update_fair_tag_sharing(q);
+               blk_mq_unfreeze_queue(q);
+       }
+}
+EXPORT_SYMBOL_GPL(blk_mq_update_fair_tag_sharing);
+
  /*
   * Caller needs to ensure that we're either frozen/quiesced, or that
   * the queue isn't live yet.
@@ -3989,6 +4021,7 @@ static void blk_mq_add_queue_tag_set(struct 
blk_mq_tag_set *set,
  {
         mutex_lock(&set->tag_list_lock);

+       queue_update_fair_tag_sharing(q);
         /*
          * Check to see if we're transitioning to shared (from 1 to 2 
queues).
          */
@@ -4767,6 +4800,9 @@ static void __blk_mq_update_nr_hw_queues(struct 
blk_mq_tag_set *set,
                 blk_mq_map_swqueue(q);
         }

+       list_for_each_entry(q, &set->tag_list, tag_set_list)
+               queue_update_fair_tag_sharing(q);
+
  reregister:
         list_for_each_entry(q, &set->tag_list, tag_set_list) {
                 blk_mq_sysfs_register_hctxs(q);
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 1743857e0b01..8b9aac701035 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -393,7 +393,8 @@ static inline bool hctx_may_queue(struct 
blk_mq_hw_ctx *hctx,
  {
         unsigned int depth, users;

-       if (!hctx || !(hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED))
+       if (!hctx || !(hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED) ||
+           (hctx->flags & BLK_MQ_F_DISABLE_FAIR_TAG_SHARING))
                 return true;

         /*

> 
> Thanks,
> 
> Bart.
> .
> 

