Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3C7EC07E9C
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 09:06:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1A0061CBA
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 09:06:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbhGGJJL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jul 2021 05:09:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231315AbhGGJJJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jul 2021 05:09:09 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD0C2C061574;
        Wed,  7 Jul 2021 02:06:28 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1625648785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ymz7q4weAiGoomeb9VhZNmEV+QoSjk8iMWjGMjXQqs4=;
        b=VMZu/KtOPRzfwx1MNlTbIoFmS5VJXe1QwNKhK6JQ8oKx6HDa0tnjgagoo2HLgY8sLIjsTv
        7x6d9vQqxgojiPyBlT2nq1Xll0E5OfQAuPe0xPUtspDoK7QBhlrnDcAl/qSbPsHLLuCyqY
        t2qCdFprLfhbxAY17nDLOlErl/A4+s0dUqiAPh1xBvLiaBwGfWlWgmDxHOS4tG38t+XxmE
        aUgZ/7OuG+5jLjMw79cqHXf7AGjg5G7ZOnpohDS5v6ugDWJMirddVrX/KJeiQgKTZ03d/y
        7QE+PQO4nsgGqN7Xs2ZiMG1vnLr2JZKPGxHYdRMI7XiRiZdHjQVBVWC236Ck1w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1625648785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ymz7q4weAiGoomeb9VhZNmEV+QoSjk8iMWjGMjXQqs4=;
        b=jvHB3jPeKm2B9+jan+DVSNG6rd7e7Nizu04y+uwarQ60LEcGaCBWkvS3veWGCmuPAs7RfB
        IjJRyPwHAqFbRXCA==
To:     Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
        Daniel Wagner <dwagner@suse.de>,
        Wen Xiong <wenxiong@us.ibm.com>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>,
        Keith Busch <kbusch@kernel.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH V2 5/6] virtio: add one field into virtio_device for recording if device uses managed irq
In-Reply-To: <20210706054203.GC17027@lst.de>
References: <20210702150555.2401722-1-ming.lei@redhat.com> <20210702150555.2401722-6-ming.lei@redhat.com> <20210706054203.GC17027@lst.de>
Date:   Wed, 07 Jul 2021 11:06:25 +0200
Message-ID: <87bl7eqyr2.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jul 06 2021 at 07:42, Christoph Hellwig wrote:
> On Fri, Jul 02, 2021 at 11:05:54PM +0800, Ming Lei wrote:
>> blk-mq needs to know if the device uses managed irq, so add one field
>> to virtio_device for recording if device uses managed irq.
>> 
>> If the driver use managed irq, this flag has to be set so it can be
>> passed to blk-mq.
>
> I don't think all this boilerplate code make a whole lot of sense.
> I think we need to record this information deep down in the irq code by
> setting a flag in struct device only if pci_alloc_irq_vectors_affinity
> atually managed to allocate multiple vectors and the PCI_IRQ_AFFINITY
> flag was set.  Then blk-mq can look at that flag, and also check that
> more than one queue is in used and work based on that.

Ack.
