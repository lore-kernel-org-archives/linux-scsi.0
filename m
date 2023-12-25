Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C9B50253;
	Mon, 25 Dec 2023 12:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4SzHpF2cGLz4f3jrt;
	Mon, 25 Dec 2023 20:51:17 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 510581A0983;
	Mon, 25 Dec 2023 20:51:20 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgBntQvFeollPIpiEg--.43643S3;
	Mon, 25 Dec 2023 20:51:20 +0800 (CST)
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
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <c1658336-f48e-5688-f0c2-f325fd5696c3@huaweicloud.com>
Date: Mon, 25 Dec 2023 20:51:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <8372f2d0-b695-4af4-90e6-e35b86e3b844@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgBntQvFeollPIpiEg--.43643S3
X-Coremail-Antispam: 1UD129KBjvJXoWxJF47JFWDWrW3XF13tw43ZFb_yoW5urWDpF
	Z8Ka18K3yFqr1kWFyUKw47WF1agrs3G347trnaqa4Yvr1UKFs2qr1kXrs8ur40yr4kCr47
	Zr4jqrZ3Ar48Z37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Y14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
	c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4
	AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE
	17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMI
	IF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq
	3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
	nIWIevJa73UjIFyTuYvjfUoOJ5UUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi, Bart!

在 2023/12/04 12:13, Bart Van Assche 写道:
> On 12/1/23 23:21, Yu Kuai wrote:
>> 在 2023/12/01 3:31, Bart Van Assche 写道:
>>> +/*
>>> + * Enable or disable fair tag sharing for all request queues 
>>> associated with
>>> + * a tag set.
>>> + */
>>> +void blk_mq_update_fair_sharing(struct blk_mq_tag_set *set, bool 
>>> enable)
>>> +{
>>> +    const unsigned int DFTS_BIT = 
>>> ilog2(BLK_MQ_F_DISABLE_FAIR_TAG_SHARING);
>>> +    struct blk_mq_hw_ctx *hctx;
>>> +    struct request_queue *q;
>>> +    unsigned long i;
>>> +
>>> +    /*
>>> +     * Serialize against blk_mq_update_nr_hw_queues() and
>>> +     * blk_mq_realloc_hw_ctxs().
>>> +     */
>>> +    mutex_lock(&set->tag_list_lock);
>> I'm a litter confused about this comment, because
>> blk_mq_realloc_hw_ctxs() can be called from
>> blk_mq_update_nr_hw_queues().
>>
>> If you are talking about blk_mq_init_allocated_queue(), it looks like
>> just holding this lock is not enough?
> 
> I added that comment because blk_mq_init_allocated_queue() calls
> blk_mq_realloc_hw_ctxs() before the request queue is added to
> set->tag_list. I will take a closer look at how
> blk_mq_init_allocated_queue() reads set->flags and will make sure
> that these reads are properly serialized against the changes made
> by blk_mq_update_fair_sharing().

Are you still intrested in this patchset? I really want this switch in
our product as well.

If so, how do you think about following changes, a new field in
blk_mq_tag_set will make synchronization much eaiser.

Thanks,
Kuai

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 6ab7f360ff2a..791306dcd656 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3935,6 +3935,34 @@ static void blk_mq_map_swqueue(struct 
request_queue *q)
         }
  }

+static void queue_update_fair_tag_sharing(struct request_queue *q)
+{
+       struct blk_mq_hw_ctx *hctx;
+       unsigned long i;
+
+       queue_for_each_hw_ctx(q, hctx, i) {
+               if (q->tag_set->disable_fair_tag_sharing)
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
+               queue_update_tag_fair_share(q);
+               blk_mq_unfreeze_queue(q);
+       }
+}
+EXPORT_SYMBOL_GPL(blk_mq_update_tag_fair_share);
+
  /*
   * Caller needs to ensure that we're either frozen/quiesced, or that
   * the queue isn't live yet.
@@ -3989,6 +4017,7 @@ static void blk_mq_add_queue_tag_set(struct 
blk_mq_tag_set *set,
  {
         mutex_lock(&set->tag_list_lock);

+       queue_update_fair_tag_sharing(q);
         /*
          * Check to see if we're transitioning to shared (from 1 to 2 
queues).
          */

diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 958ed7e89b30..d76630ac45d8 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -506,6 +506,7 @@ struct blk_mq_tag_set {
         int                     numa_node;
         unsigned int            timeout;
         unsigned int            flags;
+       bool                    disable_fair_tag_sharing;
         void                    *driver_data;

         struct blk_mq_tags      **tags;

> 
> Thanks,
> 
> Bart.
> 
> .
> 

