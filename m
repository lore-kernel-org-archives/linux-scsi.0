Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A8EEC07548
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Nov 2023 07:24:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234630AbjKOHYn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Nov 2023 02:24:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjKOHYm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Nov 2023 02:24:42 -0500
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA3D68E;
        Tue, 14 Nov 2023 23:24:38 -0800 (PST)
Received: from mail.maildlp.com (unknown [172.19.163.216])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4SVZRj2N7lz4f3jY4;
        Wed, 15 Nov 2023 15:24:33 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
        by mail.maildlp.com (Postfix) with ESMTP id B589B1A0181;
        Wed, 15 Nov 2023 15:24:34 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP1 (Coremail) with SMTP id cCh0CgBXWhAxclRl3TDlAw--.642S3;
        Wed, 15 Nov 2023 15:24:34 +0800 (CST)
Subject: Re: [PATCH v5 2/3] scsi: core: Support disabling fair tag sharing
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Keith Busch <kbusch@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Yu Kuai <yukuai1@huaweicloud.com>,
        Ed Tsai <ed.tsai@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        "yukuai (C)" <yukuai3@huawei.com>
References: <20231114180426.1184601-1-bvanassche@acm.org>
 <20231114180426.1184601-3-bvanassche@acm.org>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <80dee412-2fda-6a23-0b62-08f87bd7e607@huaweicloud.com>
Date:   Wed, 15 Nov 2023 15:24:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20231114180426.1184601-3-bvanassche@acm.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: cCh0CgBXWhAxclRl3TDlAw--.642S3
X-Coremail-Antispam: 1UD129KBjvJXoWxCr4UJrWDCF17Cw1Duw1kuFg_yoW5ArW8pF
        Z3tw12kw48Jw409anFgF15uFyFga9rGryjga47Wa4rua98tayvgws8Ca45XFWfWrZ7GwnF
        qF4qqry5CF1xJ37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9214x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
        0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
        kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
        67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
        CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWr
        Zr1UMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYx
        BIdaVFxhVjvjDU0xZFpf9x0JUZa9-UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

ÔÚ 2023/11/15 2:04, Bart Van Assche Ð´µÀ:
> Allow SCSI drivers to disable the block layer fair tag sharing algorithm.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Keith Busch <kbusch@kernel.org>
> Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Cc: Yu Kuai <yukuai1@huaweicloud.com>
> Cc: Ed Tsai <ed.tsai@mediatek.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/hosts.c     | 1 +
>   drivers/scsi/scsi_lib.c  | 2 ++
>   include/scsi/scsi_host.h | 6 ++++++
>   3 files changed, 9 insertions(+)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index d7f51b84f3c7..872f87001374 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -442,6 +442,7 @@ struct Scsi_Host *scsi_host_alloc(const struct scsi_host_template *sht, int priv
>   	shost->no_write_same = sht->no_write_same;
>   	shost->host_tagset = sht->host_tagset;
>   	shost->queuecommand_may_block = sht->queuecommand_may_block;
> +	shost->disable_fair_tag_sharing = sht->disable_fair_tag_sharing;

Can we also consider to disable fair tag sharing by default for the
driver that total driver tags is less than a threshold?

Thanks,
Kuai

>   
>   	if (shost_eh_deadline == -1 || !sht->eh_host_reset_handler)
>   		shost->eh_deadline = -1;
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index cf3864f72093..291fbfacf542 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1984,6 +1984,8 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
>   		BLK_ALLOC_POLICY_TO_MQ_FLAG(shost->hostt->tag_alloc_policy);
>   	if (shost->queuecommand_may_block)
>   		tag_set->flags |= BLK_MQ_F_BLOCKING;
> +	if (shost->disable_fair_tag_sharing)
> +		tag_set->flags |= BLK_MQ_F_DISABLE_FAIR_TAG_SHARING;
>   	tag_set->driver_data = shost;
>   	if (shost->host_tagset)
>   		tag_set->flags |= BLK_MQ_F_TAG_HCTX_SHARED;
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 3b907fc2ef08..04238ae9e22c 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -464,6 +464,9 @@ struct scsi_host_template {
>   	/* The queuecommand callback may block. See also BLK_MQ_F_BLOCKING. */
>   	unsigned queuecommand_may_block:1;
>   
> +	/* See also BLK_MQ_F_DISABLE_FAIR_TAG_SHARING. */
> +	unsigned disable_fair_tag_sharing:1;
> +
>   	/*
>   	 * Countdown for host blocking with no commands outstanding.
>   	 */
> @@ -662,6 +665,9 @@ struct Scsi_Host {
>   	/* The queuecommand callback may block. See also BLK_MQ_F_BLOCKING. */
>   	unsigned queuecommand_may_block:1;
>   
> +	/* See also BLK_MQ_F_DISABLE_FAIR_TAG_SHARING. */
> +	unsigned disable_fair_tag_sharing:1;
> +
>   	/* Host responded with short (<36 bytes) INQUIRY result */
>   	unsigned short_inquiry:1;
>   
> 
> 
> .
> 

