Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16D48C07E98
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jul 2021 03:59:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E046961375
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jul 2021 03:59:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbhGEEC0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Jul 2021 00:02:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39370 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229495AbhGEECZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jul 2021 00:02:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625457589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WXgO0oXmvf/9A/1qL8w68Z6/mTqGpM66mMODKwc4Vbo=;
        b=Y/9V0wYz2D2UIwkSGFcyEkae9nfVeIZazhC/ybBGmZ76jxea1C92woiXcSOen/XYnaM1Cp
        C9VS2LKHpIHzhdR/n/vx5Td5FeH4LQY30XVvFNLLIrT6SZKq1e/wUxyi9dhVYn23U6qzGh
        sQcwgICOrDsmIY0YNtWNTGQhN24rcKE=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-436-ntdPBo4RMzWjEfKAgrvhnQ-1; Sun, 04 Jul 2021 23:59:48 -0400
X-MC-Unique: ntdPBo4RMzWjEfKAgrvhnQ-1
Received: by mail-pf1-f200.google.com with SMTP id f9-20020a056a0022c9b029030058c72fafso11105200pfj.1
        for <linux-scsi@vger.kernel.org>; Sun, 04 Jul 2021 20:59:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=WXgO0oXmvf/9A/1qL8w68Z6/mTqGpM66mMODKwc4Vbo=;
        b=EaYR6nJz9csU6/EuYx6IsI7FqQ2ow7R9Vm+N4tAxAXldBUYo+oZFAKNi3++ZEqnvfo
         /cHWavgTAo2HB141cMTTKjsRt7GEvlN36EEckUiqE7ymVrFZu69VvLVq32Ro+za7Vulf
         sl2DbYdNg3+p/3r7T0i6CHirq/1oE4XnX7Mkru4+0hAIWFtI84oVwttJ+pzBoX2x62+Z
         Es0UlBhFQbOQVMR7L51R88XkSNEWjDr5XJYXLiYq7Gp/hX6r7WWUdCMxR7oZzae/dWiA
         p7HYw/CV2pJfP5z997KMBmZyLSQW7H5i5xQyxA2TzjvKOorAlGajYpxdW2rlWbYsPCpk
         BjSw==
X-Gm-Message-State: AOAM532MfO5UGZ0ObYgJnSXGs85gnd4NbeQBZgHu/aiawbEECbMIzdJC
        fjx1pfl54ZsUBXy9J16/CbmZ+nzG/kJ+hQ/uLPOk9f9WG8vvFls7UYjwsjTYLjsOIfkojiiqVkw
        fs1A6SnNmzfzbw7JYTIF1fA==
X-Received: by 2002:a17:90a:af90:: with SMTP id w16mr13185184pjq.129.1625457587010;
        Sun, 04 Jul 2021 20:59:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy7m1tdef3U/fD1ZeJXGh6nhQJM7pMQfOcmUl03cSHKc5dhYUnHwmNe0pBMkiHdPgpxcvo9fQ==
X-Received: by 2002:a17:90a:af90:: with SMTP id w16mr13185164pjq.129.1625457586781;
        Sun, 04 Jul 2021 20:59:46 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k9sm526132pfu.100.2021.07.04.20.59.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Jul 2021 20:59:46 -0700 (PDT)
Subject: Re: [PATCH V2 5/6] virtio: add one field into virtio_device for
 recording if device uses managed irq
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
Cc:     Sagi Grimberg <sagi@grimberg.me>, Daniel Wagner <dwagner@suse.de>,
        Wen Xiong <wenxiong@us.ibm.com>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>,
        Keith Busch <kbusch@kernel.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org
References: <20210702150555.2401722-1-ming.lei@redhat.com>
 <20210702150555.2401722-6-ming.lei@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <fbe8e661-86c7-ef79-1c61-884715b64e87@redhat.com>
Date:   Mon, 5 Jul 2021 11:59:21 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210702150555.2401722-6-ming.lei@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


ÔÚ 2021/7/2 ÏÂÎç11:05, Ming Lei Ð´µÀ:
> blk-mq needs to know if the device uses managed irq, so add one field
> to virtio_device for recording if device uses managed irq.
>
> If the driver use managed irq, this flag has to be set so it can be
> passed to blk-mq.
>
> Cc: "Michael S. Tsirkin"<mst@redhat.com>
> Cc: Jason Wang<jasowang@redhat.com>
> Cc:virtualization@lists.linux-foundation.org
> Signed-off-by: Ming Lei<ming.lei@redhat.com>
> ---
>   drivers/block/virtio_blk.c         | 2 ++
>   drivers/scsi/virtio_scsi.c         | 1 +
>   drivers/virtio/virtio_pci_common.c | 1 +
>   include/linux/virtio.h             | 1 +
>   4 files changed, 5 insertions(+)
>
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index e4bd3b1fc3c2..33b9c80ac475 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -764,6 +764,8 @@ static int virtblk_probe(struct virtio_device *vdev)
>   	vblk->tag_set.queue_depth = queue_depth;
>   	vblk->tag_set.numa_node = NUMA_NO_NODE;
>   	vblk->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
> +	if (vdev->use_managed_irq)
> +		vblk->tag_set.flags |= BLK_MQ_F_MANAGED_IRQ;


I'm not familiar with blk mq.

But the name is kind of confusing, I guess 
"BLK_MQ_F_AFFINITY_MANAGED_IRQ" is better? (Consider we had 
"IRQD_AFFINITY_MANAGED")

This helps me to differ this from the devres (device managed IRQ) at least.

Thanks


