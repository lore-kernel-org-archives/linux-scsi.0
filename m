Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58960C433EB
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 11:09:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37A4822BEF
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 11:09:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dBQSG4n6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729517AbgGULJm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 07:09:42 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:47518 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729526AbgGULJl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Jul 2020 07:09:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595329780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1LZAXnntkLhkcLOqby4Ic/aYn82wdCMM/OIUvTatqoM=;
        b=dBQSG4n6EkEEky90BykmxS+77oBoYv+6gneF7KuwR1dPFSLkWT+CS0dhxGbCQ3rhIdFRx0
        Oh6vzxsqw6EJU89DkJ00rO69O4XA+NvICS7y1TaeGkqpdApK1mDrsK3AXpXGvXrmMfKaLR
        Nptq6QtwzDWTxFD7tmhXz4SptNfd2qI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-316-5iDd30yMNTuz4Sd4x5-MNA-1; Tue, 21 Jul 2020 07:09:36 -0400
X-MC-Unique: 5iDd30yMNTuz4Sd4x5-MNA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 673A9100AA23;
        Tue, 21 Jul 2020 11:09:33 +0000 (UTC)
Received: from starship (unknown [10.35.206.163])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BEC5F1755E;
        Tue, 21 Jul 2020 11:09:17 +0000 (UTC)
Message-ID: <cef747910431d81524e455e6380df1c610d1884c.camel@redhat.com>
Subject: Re: [PATCH 01/10] block: introduce blk_is_valid_logical_block_size
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
Date:   Tue, 21 Jul 2020 14:09:16 +0300
In-Reply-To: <CY4PR04MB37512BDEFD7B977FCD32A10AE7780@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200721105239.8270-1-mlevitsk@redhat.com>
         <20200721105239.8270-2-mlevitsk@redhat.com>
         <CY4PR04MB37512BDEFD7B977FCD32A10AE7780@CY4PR04MB3751.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2020-07-21 at 11:05 +0000, Damien Le Moal wrote:
> On 2020/07/21 19:53, Maxim Levitsky wrote:
> > Kernel block layer has never supported logical block
> > sizes less that SECTOR_SIZE nor larger that PAGE_SIZE.
> > 
> > Some drivers have runtime configurable block size,
> > so it makes sense to have common helper for that.
> 
> ...common helper to check the validity of the logical block size set by the driver.
Agree, will fix.
> 
> ("for that" does not refer to a clear action)
> 
> > Signed-off-by: Maxim Levitsky  <mlevitsk@redhat.com>
> > ---
> >  block/blk-settings.c   | 18 ++++++++++++++++++
> >  include/linux/blkdev.h |  1 +
> >  2 files changed, 19 insertions(+)
> > 
> > diff --git a/block/blk-settings.c b/block/blk-settings.c
> > index 9a2c23cd97007..3c4ef0d00c2bc 100644
> > --- a/block/blk-settings.c
> > +++ b/block/blk-settings.c
> > @@ -311,6 +311,21 @@ void blk_queue_max_segment_size(struct request_queue *q, unsigned int max_size)
> >  }
> >  EXPORT_SYMBOL(blk_queue_max_segment_size);
> >  
> > +
> > +/**
> > + * blk_check_logical_block_size - check if logical block size is supported
> > + * by the kernel
> > + * @size:  the logical block size, in bytes
> > + *
> > + * Description:
> > + *   This function checks if the block layers supports given block size
> > + **/
> > +bool blk_is_valid_logical_block_size(unsigned int size)
> > +{
> > +	return size >= SECTOR_SIZE && size <= PAGE_SIZE && !is_power_of_2(size);
Note here a typo, made in last minute change which I didn't test.
It should be without '!'

Best regards,
	Maxim Levitsky

> > +}
> > +EXPORT_SYMBOL(blk_is_valid_logical_block_size);
> > +
> >  /**
> >   * blk_queue_logical_block_size - set logical block size for the queue
> >   * @q:  the request queue for the device
> > @@ -323,6 +338,8 @@ EXPORT_SYMBOL(blk_queue_max_segment_size);
> >   **/
> >  void blk_queue_logical_block_size(struct request_queue *q, unsigned int size)
> >  {
> > +	WARN_ON(!blk_is_valid_logical_block_size(size));
> > +
> >  	q->limits.logical_block_size = size;
> >  
> >  	if (q->limits.physical_block_size < size)
> > @@ -330,6 +347,7 @@ void blk_queue_logical_block_size(struct request_queue *q, unsigned int size)
> >  
> >  	if (q->limits.io_min < q->limits.physical_block_size)
> >  		q->limits.io_min = q->limits.physical_block_size;
> > +
> 
> white line change.
> 
> >  }
> >  EXPORT_SYMBOL(blk_queue_logical_block_size);
> >  
> > diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> > index 57241417ff2f8..2ed3151397e41 100644
> > --- a/include/linux/blkdev.h
> > +++ b/include/linux/blkdev.h
> > @@ -1099,6 +1099,7 @@ extern void blk_queue_max_write_same_sectors(struct request_queue *q,
> >  		unsigned int max_write_same_sectors);
> >  extern void blk_queue_max_write_zeroes_sectors(struct request_queue *q,
> >  		unsigned int max_write_same_sectors);
> > +extern bool blk_is_valid_logical_block_size(unsigned int size);
> >  extern void blk_queue_logical_block_size(struct request_queue *, unsigned int);
> >  extern void blk_queue_max_zone_append_sectors(struct request_queue *q,
> >  		unsigned int max_zone_append_sectors);
> > 
> 
> 


