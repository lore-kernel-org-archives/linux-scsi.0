Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83B96C4724C
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 17:41:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71C0E208C3
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 17:41:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgD3RlY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 13:41:24 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2136 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726318AbgD3RlY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Apr 2020 13:41:24 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id 11E203577ECD3A49A8D9;
        Thu, 30 Apr 2020 18:41:22 +0100 (IST)
Received: from [127.0.0.1] (10.47.0.178) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Thu, 30 Apr
 2020 18:41:20 +0100
Subject: Re: [PATCH RFC v6 08/10] megaraid_sas: switch fusion adapters to MQ
From:   John Garry <john.garry@huawei.com>
To:     Kashyap Desai <kashyap.desai@broadcom.com>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "ming.lei@redhat.com" <ming.lei@redhat.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "hare@suse.de" <hare@suse.de>,
        "don.brace@microsemi.com" <don.brace@microsemi.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        "hch@infradead.org" <hch@infradead.org>,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>,
        "chenxiang (M)" <chenxiang66@hisilicon.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "esc.storagedev@microsemi.com" <esc.storagedev@microsemi.com>,
        Hannes Reinecke <hare@suse.com>
References: <1583409280-158604-1-git-send-email-john.garry@huawei.com>
 <1583409280-158604-9-git-send-email-john.garry@huawei.com>
 <a1f0399e2e85b2244a9ae40e4a2f1089@mail.gmail.com>
 <f839f040-8bf4-cf83-7670-dfc208b77326@huawei.com>
 <7cac3eb9fd79b5b988e25da542305b35@mail.gmail.com>
 <40faaef8-8bfc-639f-747f-cacd4e61464f@huawei.com>
 <7b8c79b0453722023c6c7d53cd24441d@mail.gmail.com>
 <b759a8ed-09ba-bfe8-8916-c05ab9671cbf@huawei.com>
 <260c5decdb38db9f74994988ce7fcaf1@mail.gmail.com>
 <380d3bf2-67ee-a09a-3098-51b24b98f912@huawei.com>
 <e0c5a076-9fe5-4401-fd41-97f457888ad3@huawei.com>
 <d2ae343770a83466b870a33ffae5fa23@mail.gmail.com>
 <8e16d68b-4d71-58f1-ede9-92ffe5d65ba9@huawei.com>
 <f712fd935562dcff73f0f6cf15f9cce7@mail.gmail.com>
 <538dd70d-7edb-c66c-4205-d91f24a907ea@huawei.com>
 <ca799ed3-0b18-2aa5-7d75-6eac5b0e6e7b@huawei.com>
 <29f8062c1fccace73c45252073232917@mail.gmail.com>
 <6bfc5fea-d1ce-7220-0023-af3b34e1fa38@huawei.com>
Message-ID: <eb8bc395-1e62-3a5a-c1f6-5b1d163bf080@huawei.com>
Date:   Thu, 30 Apr 2020 18:40:38 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <6bfc5fea-d1ce-7220-0023-af3b34e1fa38@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.0.178]
X-ClientProxiedBy: lhreml731-chm.china.huawei.com (10.201.108.82) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 29/04/2020 18:55, John Garry wrote:
> 

Hi Kashyap,

> ok, so it's not proper to use active hctx per request queue as "users", 
> but rather that the active request_queue's per host (which is what we 
> effectively have for nr_hw_queues = 1). Just a small comment at the 
> bottom on your change.
> 
> So I already experimented with reducing shost.can_queue significantly on 
> hisi_sas (by a factor of 8, from 4096->512, and I use 12x SAS SSD), and 
> saw:
> 
> RFC + shost.can_queue reduced: ~1.2M IOPS
> With RFC + shost.can_queue unmodified: ~2M IOPS
> Without RFC + shost.can_queue unmodified: ~2M IOPS
> 
> And with the change, below, I still get around 1.2M IOPS. But there may 
> be some sweet spot/zone where this makes a difference, which I'm not 
> visiting.
> 
>>
>> Combination of your patch and below resolves fairness issues. I see some
>> better results using " --cpus_allowed_policy=split", but
>> --cpus_allowed_policy=shared 
> 
> I did not try changing the cpus_allowed_policy policy, and so I would be 
> using default, which I believe is shared.
> 
> is still having some issue and most likely it
>> is to do with fairness. If fairness is not managed properly, there is 
>> high
>> contention in wait/wakeup handling of sbitmap.
> 
> ok, I can investigate.

Could you also try this change:

diff --git a/block/blk-mq-tag.h b/block/blk-mq-tag.h
index 0a57e4f041a9..e959971b1cee 100644
--- a/block/blk-mq-tag.h
+++ b/block/blk-mq-tag.h
@@ -46,11 +46,25 @@ extern void blk_mq_tag_wakeup_all(struct blk_mq_tags 
*tags, bool);
  void blk_mq_queue_tag_busy_iter(struct request_queue *q, busy_iter_fn *fn,
  		void *priv);

+static inline bool blk_mq_is_sbitmap_shared(struct blk_mq_tag_set *tag_set)
+{
+	return tag_set->flags & BLK_MQ_F_TAG_HCTX_SHARED;
+}
+
  static inline struct sbq_wait_state *bt_wait_ptr(struct sbitmap_queue *bt,
  						 struct blk_mq_hw_ctx *hctx)
  {
+	struct request_queue *queue;
+	struct blk_mq_tag_set *set;
+
  	if (!hctx)
  		return &bt->ws[0];
+	queue = hctx->queue;
+	set = queue->tag_set;
+
+	if (blk_mq_is_sbitmap_shared(set))
+		return sbq_wait_ptr(bt, &set->wait_index);
+	
  	return sbq_wait_ptr(bt, &hctx->wait_index);
  }

diff --git a/block/blk-mq.h b/block/blk-mq.h
index 4f12363d56bf..241607806f77 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -158,11 +158,6 @@ struct blk_mq_alloc_data {
  	struct blk_mq_hw_ctx *hctx;
  };

-static inline bool blk_mq_is_sbitmap_shared(struct blk_mq_tag_set *tag_set)
-{
-	return tag_set->flags & BLK_MQ_F_TAG_HCTX_SHARED;
-}
-
  static inline struct blk_mq_tags *blk_mq_tags_from_data(struct 
blk_mq_alloc_data *data)
  {
  	if (data->flags & BLK_MQ_REQ_INTERNAL)

diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 957cb43c5de7..427c7934c29d 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -259,6 +259,8 @@ struct blk_mq_tag_set {

  	struct mutex		tag_list_lock;
  	struct list_head	tag_list;
+
+	atomic_t		wait_index;
  };

  /**


Thanks,
John
