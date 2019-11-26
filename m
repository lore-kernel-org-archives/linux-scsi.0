Return-Path: <SRS0=v3DL=ZS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06220C432C3
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 13:59:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2A4820727
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 13:59:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727664AbfKZN7n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Nov 2019 08:59:43 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2118 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727379AbfKZN7n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Nov 2019 08:59:43 -0500
Received: from lhreml706-cah.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 7CDD867FA302F7D5A771;
        Tue, 26 Nov 2019 13:59:41 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 lhreml706-cah.china.huawei.com (10.201.108.47) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 26 Nov 2019 13:59:41 +0000
Received: from [127.0.0.1] (10.202.226.46) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Tue, 26 Nov
 2019 13:59:40 +0000
Subject: Re: [PATCH 4/8] blk-mq: Facilitate a shared sbitmap per tagset
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Ming Lei <ming.lei@redhat.com>,
        "Bart van Assche" <bvanassche@acm.org>,
        <linux-scsi@vger.kernel.org>, <linux-block@vger.kernel.org>
References: <20191126131009.71726-1-hare@suse.de>
 <20191126131009.71726-5-hare@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <9e3a647e-43ec-5ea7-85e0-8a5cd86422cd@huawei.com>
Date:   Tue, 26 Nov 2019 13:59:39 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191126131009.71726-5-hare@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.46]
X-ClientProxiedBy: lhreml720-chm.china.huawei.com (10.201.108.71) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> +		blk_mq_free_tags(tags);
>   }
>   
>   struct blk_mq_tags *blk_mq_alloc_rq_map(struct blk_mq_tag_set *set,
>   					unsigned int hctx_idx,
>   					unsigned int nr_tags,
> -					unsigned int reserved_tags)
> +					unsigned int reserved_tags,
> +					bool shared_tags)
>   {
>   	struct blk_mq_tags *tags;
>   	int node;
> @@ -2096,8 +2098,9 @@ struct blk_mq_tags *blk_mq_alloc_rq_map(struct blk_mq_tag_set *set,
>   	if (node == NUMA_NO_NODE)
>   		node = set->numa_node;
>   
> -	tags = blk_mq_init_tags(nr_tags, reserved_tags, node,
> -				BLK_MQ_FLAG_TO_ALLOC_POLICY(set->flags));
> +	tags = blk_mq_init_tags(set, nr_tags, reserved_tags, node,
> +				BLK_MQ_FLAG_TO_ALLOC_POLICY(set->flags),
> +				shared_tags);
>   	if (!tags)
>   		return NULL;
>   
> @@ -2105,7 +2108,8 @@ struct blk_mq_tags *blk_mq_alloc_rq_map(struct blk_mq_tag_set *set,
>   				 GFP_NOIO | __GFP_NOWARN | __GFP_NORETRY,
>   				 node);
>   	if (!tags->rqs) {
> -		blk_mq_free_tags(tags);
> +		if (!blk_mq_is_sbitmap_shared(set))
> +			blk_mq_free_tags(tags);

Don't we still need to free the tags memory but not have the 
blk_mq_free_tags()->sbitmap_queue_free() calls in case of shared tags?

>   		return NULL;
>   	}
>   
> @@ -2114,7 +2118,8 @@ struct blk_mq_tags *blk_mq_alloc_rq_map(struct blk_mq_tag_set *set,
>   					node);
>   	if (!tags->static_rqs) {
>   		kfree(tags->rqs);
> -		blk_mq_free_tags(tags);
> +		if (!blk_mq_is_sbitmap_shared(set))
> +			blk_mq_free_tags(tags);
>   		return NULL;
>   	}
