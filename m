Return-Path: <SRS0=JRJf=AE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB897C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 11:26:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C541820724
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 11:26:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732374AbgFWL0o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Jun 2020 07:26:44 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2357 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732189AbgFWL0o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 Jun 2020 07:26:44 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 037EB93EE60454849E83;
        Tue, 23 Jun 2020 12:26:43 +0100 (IST)
Received: from [127.0.0.1] (10.47.2.88) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Tue, 23 Jun
 2020 12:26:41 +0100
Subject: Re: [PATCH RFC v7 02/12] blk-mq: rename blk_mq_update_tag_set_depth()
From:   John Garry <john.garry@huawei.com>
To:     Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>
CC:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <don.brace@microsemi.com>,
        <kashyap.desai@broadcom.com>, <sumit.saxena@broadcom.com>,
        <bvanassche@acm.org>, <hare@suse.com>, <hch@lst.de>,
        <shivasharan.srikanteshwara@broadcom.com>,
        <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <esc.storagedev@microsemi.com>, <chenxiang66@hisilicon.com>,
        <megaraidlinux.pdl@broadcom.com>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <1591810159-240929-3-git-send-email-john.garry@huawei.com>
 <20200611025759.GA453671@T590>
 <6ef76cdf-2fb3-0ce8-5b5a-0d7af0145901@huawei.com>
Message-ID: <8ef58912-d480-a7e1-f04c-da9bd85ea0ae@huawei.com>
Date:   Tue, 23 Jun 2020 12:25:12 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <6ef76cdf-2fb3-0ce8-5b5a-0d7af0145901@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.2.88]
X-ClientProxiedBy: lhreml730-chm.china.huawei.com (10.201.108.81) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/06/2020 09:26, John Garry wrote:
> On 11/06/2020 03:57, Ming Lei wrote:
>> On Thu, Jun 11, 2020 at 01:29:09AM +0800, John Garry wrote:
>>> From: Hannes Reinecke <hare@suse.de>
>>>
>>> The function does not set the depth, but rather transitions from
>>> shared to non-shared queues and vice versa.
>>> So rename it to blk_mq_update_tag_set_shared() to better reflect
>>> its purpose.
>>
>> It is fine to rename it for me, however:
>>
>> This patch claims to rename blk_mq_update_tag_set_shared(), but also
>> change blk_mq_init_bitmap_tags's signature.
> 
> I was going to update the commit message here, but forgot again...
> 
>>
>> So suggest to split this patch into two or add comment log on changing
>> blk_mq_init_bitmap_tags().
> 
> I think I'll just split into 2x commits.

Hi Hannes,

Do you have any issue with splitting the undocumented changes into 
another patch as so:

-------------------->8---------------------

 From db3f8ec1295efbf53273ffc137d348857cbd411e Mon Sep 17 00:00:00 2001
From: Hannes Reinecke <hare@suse.de>
Date: Tue, 23 Jun 2020 12:07:33 +0100
Subject: [PATCH] blk-mq: Free tags in blk_mq_init_tags() upon error

Since the tags are allocated in blk_mq_init_tags() it's better practice
to free in that same function upon error, rather than a callee which is 
to init the bitmap tags - blk_mq_init_tags().

Signed-off-by: Hannes Reinecke <hare@suse.de>
[jpg: split from an earlier patch with a new commit message, minor mod 
to return NULL directly for error]
Signed-off-by: John Garry <john.garry@huawei.com>

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 1085dc9848f3..b8972014cd90 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -487,24 +487,22 @@ static int bt_alloc(struct sbitmap_queue *bt, 
unsigned int depth,
  				       node);
  }

-static struct blk_mq_tags *blk_mq_init_bitmap_tags(struct blk_mq_tags 
*tags,
-						   int node, int alloc_policy)
+static int blk_mq_init_bitmap_tags(struct blk_mq_tags *tags,
+				   int node, int alloc_policy)
  {
  	unsigned int depth = tags->nr_tags - tags->nr_reserved_tags;
  	bool round_robin = alloc_policy == BLK_TAG_ALLOC_RR;

  	if (bt_alloc(&tags->bitmap_tags, depth, round_robin, node))
-		goto free_tags;
+		return -ENOMEM;
  	if (bt_alloc(&tags->breserved_tags, tags->nr_reserved_tags, round_robin,
  		     node))
  		goto free_bitmap_tags;

-	return tags;
+	return 0;
  free_bitmap_tags:
  	sbitmap_queue_free(&tags->bitmap_tags);
-free_tags:
-	kfree(tags);
-	return NULL;
+	return -ENOMEM;
  }

  struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
@@ -525,7 +523,11 @@ struct blk_mq_tags *blk_mq_init_tags(unsigned int 
total_tags,
  	tags->nr_tags = total_tags;
  	tags->nr_reserved_tags = reserved_tags;

-	return blk_mq_init_bitmap_tags(tags, node, alloc_policy);
+	if (blk_mq_init_bitmap_tags(tags, node, alloc_policy) < 0) {
+		kfree(tags);
+		return NULL;
+	}
+	return tags;
  }

  void blk_mq_free_tags(struct blk_mq_tags *tags)

--------------------8<---------------------

Thanks
