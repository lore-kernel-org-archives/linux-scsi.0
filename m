Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20652C07E98
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jul 2021 09:32:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00965613B9
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jul 2021 09:32:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbhGEJfZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Jul 2021 05:35:25 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3360 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbhGEJfY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jul 2021 05:35:24 -0400
Received: from fraeml710-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GJKqn18Ydz6H7x1;
        Mon,  5 Jul 2021 17:18:45 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml710-chm.china.huawei.com (10.206.15.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 5 Jul 2021 11:32:45 +0200
Received: from [10.47.92.124] (10.47.92.124) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Mon, 5 Jul 2021
 10:32:45 +0100
Subject: Re: [PATCH V2 3/6] scsi: add flag of .use_managed_irq to 'struct
 Scsi_Host'
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        "Christoph Hellwig" <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <linux-scsi@vger.kernel.org>
CC:     Sagi Grimberg <sagi@grimberg.me>, Daniel Wagner <dwagner@suse.de>,
        "Wen Xiong" <wenxiong@us.ibm.com>, Hannes Reinecke <hare@suse.de>,
        Keith Busch <kbusch@kernel.org>,
        Damien Le Moal <damien.lemoal@wdc.com>
References: <20210702150555.2401722-1-ming.lei@redhat.com>
 <20210702150555.2401722-4-ming.lei@redhat.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <47fc5ed1-29e3-9226-a111-26c271cb6d90@huawei.com>
Date:   Mon, 5 Jul 2021 10:25:38 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20210702150555.2401722-4-ming.lei@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.92.124]
X-ClientProxiedBy: lhreml741-chm.china.huawei.com (10.201.108.191) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 02/07/2021 16:05, Ming Lei wrote:
> blk-mq needs this information of using managed irq for improving
> deactivating hctx, so add such flag to 'struct Scsi_Host', then
> drivers can pass such flag to blk-mq via scsi_mq_setup_tags().
> 
> The rule is that driver has to tell blk-mq if managed irq is used.
> 
> Signed-off-by: Ming Lei<ming.lei@redhat.com>

As was said before, can we have something like this instead of relying 
on the LLDs to do the setting:

--------->8------------

diff --git a/block/blk-mq-pci.c b/block/blk-mq-pci.c
index b595a94c4d16..2037a5b69fe1 100644
--- a/block/blk-mq-pci.c
+++ b/block/blk-mq-pci.c
@@ -37,7 +37,7 @@ int blk_mq_pci_map_queues(struct blk_mq_queue_map 
*qmap, struct pci_dev *pdev,
  		for_each_cpu(cpu, mask)
  			qmap->mq_map[cpu] = qmap->queue_offset + queue;
  	}
-
+	qmap->drain_hwq = 1;
  	return 0;

  fallback:
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 46fe5b45a8b8..7b610e680e08 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3408,7 +3408,8 @@ static int blk_mq_update_queue_map(struct 
blk_mq_tag_set *set)
  		set->map[HCTX_TYPE_DEFAULT].nr_queues = set->nr_hw_queues;

  	if (set->ops->map_queues && !is_kdump_kernel()) {
-		int i;
+		struct blk_mq_queue_map *qmap = &set->map[HCTX_TYPE_DEFAULT];
+		int i, ret;

  		/*
  		 * transport .map_queues is usually done in the following
@@ -3427,7 +3428,12 @@ static int blk_mq_update_queue_map(struct 
blk_mq_tag_set *set)
  		for (i = 0; i < set->nr_maps; i++)
  			blk_mq_clear_mq_map(&set->map[i]);

-		return set->ops->map_queues(set);
+		ret = set->ops->map_queues(set);
+		if (ret)
+			return ret;
+		if (qmap->drain_hwq)
+			set->flags |= BLK_MQ_F_MANAGED_IRQ;
+		return 0;
  	} else {
  		BUG_ON(set->nr_maps > 1);
  		return blk_mq_map_queues(&set->map[HCTX_TYPE_DEFAULT]);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 65ed99b3f2f0..2b2e71ff43e0 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -193,6 +193,7 @@ struct blk_mq_queue_map {
  	unsigned int *mq_map;
  	unsigned int nr_queues;
  	unsigned int queue_offset;
+	bool drain_hwq;
  };




