Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D0AC3;
	Mon, 27 Nov 2023 18:03:40 -0800 (PST)
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4SfQjL16wRz4f3jqw;
	Tue, 28 Nov 2023 10:03:34 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 020CC1A08A4;
	Tue, 28 Nov 2023 10:03:37 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgDX2xF2SmVlaY6JCA--.5037S3;
	Tue, 28 Nov 2023 10:03:36 +0800 (CST)
Subject: Re: [PATCH v5 2/3] scsi: core: Support disabling fair tag sharing
To: Bart Van Assche <bvanassche@acm.org>, Yu Kuai <yukuai1@huaweicloud.com>,
 Jens Axboe <axboe@kernel.dk>
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
 <5dd7b7f7-bcae-4769-b6c8-ac0da8e69c93@acm.org>
 <1b380cbf-40e9-6ba6-62da-d3aad94809d0@huaweicloud.com>
 <0a522249-2b27-49a9-bf39-8d8c37b120f4@acm.org>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <613332b7-098e-3160-f946-764873b9e71f@huaweicloud.com>
Date: Tue, 28 Nov 2023 10:03:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <0a522249-2b27-49a9-bf39-8d8c37b120f4@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgDX2xF2SmVlaY6JCA--.5037S3
X-Coremail-Antispam: 1UD129KBjvJXoWxJFWkJw4fWryUCF4ftry3CFg_yoW5XF45pF
	s5tFWUtrWUJrn5Gr1jg3W7GFyrAr4UJw1DJr1xW3W5Jr43JrW2qr18Wr1vgFnrJr4kGr17
	JF45XrZrZrn8XrDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9214x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWr
	Zr1UMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYx
	BIdaVFxhVjvjDU0xZFpf9x0JUdHUDUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2023/11/28 7:05, Bart Van Assche 写道:
> On 11/22/23 22:29, Yu Kuai wrote:
>> 在 2023/11/22 3:32, Bart Van Assche 写道:
>>> +static ssize_t queue_fair_sharing_store(struct request_queue *q,
>>> +                    const char *page, size_t count)
>>> +{
>>> +    const unsigned int DFTS_BIT = 
>>> ilog2(BLK_MQ_F_DISABLE_FAIR_TAG_SHARING);
>>> +    struct blk_mq_tag_set *set = q->tag_set;
>>> +    struct blk_mq_hw_ctx *hctx;
>>> +    unsigned long i;
>>> +    int res;
>>> +    bool val;
>>> +
>>> +    res = kstrtobool(page, &val);
>>> +    if (res < 0)
>>> +        return res;
>>> +
>>> +    mutex_lock(&set->tag_list_lock);
>>> +    clear_bit(DFTS_BIT, &set->flags);
>>> +    list_for_each_entry(q, &set->tag_list, tag_set_list) {
>>> +        /* Serialize against blk_mq_realloc_hw_ctxs() */
>>
>> If set/clear bit concurrent with test bit from io path, will there be
>> problem? Why don't freeze these queues?
> 
> If that happens the changes applied through this sysfs attribute may 
> only take
> effect after a short delay (depending on how fast changes are propagated 
> from
> one CPU to another). I don't think that this is an issue?

Because wake_batch is not updated, hence actually wait/wakeup is still
the same before tag sharing is disabled.

I was worried that there might be missing wakeups, why not using
blk_mq_update_tag_set_shared() directly to disable tag sharing? And for
new disks, change blk_mq_add_queue_tag_set() to not set
BLK_MQ_F_TAG_QUEUE_SHARED as well. This way we only need a new flag for
tag_set, that's why I want to add the new sysfs entry for scsi_host,
since there are no entry represent tag_set for now...

>   >> +#define QUEUE_RW_ENTRY_NO_SYSFS_MUTEX(_prefix, _name)       \
>>> +    static struct queue_sysfs_entry _prefix##_entry = { \
>>> +        .attr = { .name = _name, .mode = 0644 },    \
>>> +        .show = _prefix##_show,                     \
>>> +        .store = _prefix##_store,                   \
>>> +        .no_sysfs_mutex = true,                     \
>>> +    };
>>> +
>>
>> This actually change all the queues from the same tagset, can we add
>> this new entry to /sys/class/scsi_host/hostx/xxx ?
> 
> That would make it impossible to disable fair tag sharing for block drivers
> that are not based on the SCSI core. Are you sure that's what you want?

Yes, if there are other drivers that are sharing driver tags, this is
not good, can you give some examples?

Thanks,
Kuai
> 
> Thanks,
> 
> Bart.
> .
> 

