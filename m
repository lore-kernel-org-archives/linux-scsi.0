Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53129C433E4
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 12:42:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E5F5206E3
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 12:42:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZRTvmXSz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729346AbgGUMm1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 08:42:27 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:33383 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728625AbgGUMmY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Jul 2020 08:42:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595335342;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sxEWR5e+zFYMBJOOuaa+SYdRZddlN9HI1DKBH6wob58=;
        b=ZRTvmXSz7Rh+hPT0fQAvmYiDjwXPM+ti/tOaKzGp6FVMRz3Q8Lekog1wEFY1v5wTpHRbCU
        2OMkIf4g9pOflXTvHshxcY2cM+IbyRmobhCZagQiDqJWzOWJNgtME82sR1DHPhavU4NLrb
        10M9jw4Q3LVcUFTB0Ugkeu9TBwUgooI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263--3BfRSnxPBiIkZC8r_aHkQ-1; Tue, 21 Jul 2020 08:42:20 -0400
X-MC-Unique: -3BfRSnxPBiIkZC8r_aHkQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 35D7780047E;
        Tue, 21 Jul 2020 12:42:16 +0000 (UTC)
Received: from starship (unknown [10.35.206.163])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A1F9870105;
        Tue, 21 Jul 2020 12:42:08 +0000 (UTC)
Message-ID: <435f1c04b58bd2298be3166b7bab458640927118.camel@redhat.com>
Subject: Re: [PATCH 05/10] block: null: use blk_is_valid_logical_block_size
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     Keith Busch <kbusch@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        "open list:BLOCK LAYER" <linux-block@vger.kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@kernel.dk>,
        "open list:NVM EXPRESS DRIVER" <linux-nvme@lists.infradead.org>,
        "open list:SCSI CDROM DRIVER" <linux-scsi@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jason Wang <jasowang@redhat.com>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Ajay Joshi <Ajay.Joshi@wdc.com>,
        Ming Lei <ming.lei@redhat.com>,
        "open list:SONY MEMORYSTICK SUBSYSTEM" <linux-mmc@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Satya Tangirala <satyat@google.com>,
        "open list:NETWORK BLOCK DEVICE (NBD)" <nbd@other.debian.org>,
        Hou Tao <houtao1@huawei.com>, Jens Axboe <axboe@fb.com>,
        "open list:VIRTIO CORE AND NET DRIVERS" 
        <virtualization@lists.linux-foundation.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Alex Dubov <oakad@yahoo.com>
Date:   Tue, 21 Jul 2020 15:42:07 +0300
In-Reply-To: <CY4PR04MB3751882A6BDF7C073D6ECF88E7780@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200721105239.8270-1-mlevitsk@redhat.com>
         <20200721105239.8270-6-mlevitsk@redhat.com>
         <CY4PR04MB3751882A6BDF7C073D6ECF88E7780@CY4PR04MB3751.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2020-07-21 at 11:15 +0000, Damien Le Moal wrote:
> On 2020/07/21 19:54, Maxim Levitsky wrote:
> > This slightly changes the behavier of the driver,
> 
> s/behavier/behavior
Thanks. This is one of the typos I make very consistently.

> 
> > when given invalid block size (non power of two, or below 512 bytes),
> > but shoudn't matter.
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  drivers/block/null_blk_main.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/block/null_blk_main.c b/drivers/block/null_blk_main.c
> > index 87b31f9ca362e..e4df4b903b90b 100644
> > --- a/drivers/block/null_blk_main.c
> > +++ b/drivers/block/null_blk_main.c
> > @@ -1684,8 +1684,8 @@ static int null_init_tag_set(struct nullb *nullb, struct blk_mq_tag_set *set)
> >  
> >  static int null_validate_conf(struct nullb_device *dev)
> >  {
> > -	dev->blocksize = round_down(dev->blocksize, 512);
> > -	dev->blocksize = clamp_t(unsigned int, dev->blocksize, 512, 4096);
> > +	if (!blk_is_valid_logical_block_size(dev->blocksize))
> > +		return -ENODEV;
> >  
> >  	if (dev->queue_mode == NULL_Q_MQ && dev->use_per_node_hctx) {
> >  		if (dev->submit_queues != nr_online_nodes)
> > @@ -1865,7 +1865,7 @@ static int __init null_init(void)
> >  	struct nullb *nullb;
> >  	struct nullb_device *dev;
> >  
> > -	if (g_bs > PAGE_SIZE) {
> > +	if (!blk_is_valid_logical_block_size(g_bs)) {
> >  		pr_warn("invalid block size\n");
> >  		pr_warn("defaults block size to %lu\n", PAGE_SIZE);
> >  		g_bs = PAGE_SIZE;
> 
> Not sure if this change is OK. Shouldn't the if here be kept as is and
> blk_is_valid_logical_block_size() called after it to check values lower than 4K ?

The thing is that this driver supports two ways of creating the block devices.
On module load it creates by default a single block device and it uses g_bs
as its block size, but then it also has configfs based interface that allows
to create more block devices.

The default is taken also from g_bs but then user can change it (
via those NULLB_DEVICE_ATTR wrappers)
I changed the behavior slightly, that now if user supplies bad value,
it will be rejected instead of finding closest valid value.

In addition to that there is very small bug that didn't bother to fix in
this series (but I will in next one). The bug is that when null_validate_conf
fails, it return value is overriden with -ENOMEM, which gives the user a wrong
error message.

Thanks for the review!

Best regards,
	Maxim Levitsky

> 
> 


