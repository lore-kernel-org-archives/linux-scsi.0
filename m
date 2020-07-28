Return-Path: <SRS0=RyiH=BH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9ABAC433E5
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jul 2020 14:28:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82C02206D8
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jul 2020 14:28:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P6GuduwG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730377AbgG1O2I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Jul 2020 10:28:08 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:51307 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729410AbgG1O2I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Jul 2020 10:28:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595946486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vk76CkPyZ5T42guo8MQRmFanU+aGvXip0+duA6MP1QY=;
        b=P6GuduwGET+FzVJNQbQDlfz3GoRMmBuVcPfjreT7NQMASuW5yPIn7yThSvZAlOefT+e+b4
        ohXeAcgqHboIxWQxDTuDau5BzLRV9h//Oxi89adpmQxh2LXi0l7cAJfI+0/31v15UZbZVc
        FjaE1eyZhIN8eoNh4UQb3S4yyUYT9Cc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-337-Jz4k5rM7NTirOgcPGnRijg-1; Tue, 28 Jul 2020 10:28:02 -0400
X-MC-Unique: Jz4k5rM7NTirOgcPGnRijg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 80CAEE91C;
        Tue, 28 Jul 2020 14:27:58 +0000 (UTC)
Received: from fedora-32-enviroment (unknown [10.35.206.247])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EA66F10013C4;
        Tue, 28 Jul 2020 14:27:42 +0000 (UTC)
Message-ID: <25011fed186bd8bfd1f25640158fbce60a7ad9ef.camel@redhat.com>
Subject: Re: [PATCH 02/10] block: virtio-blk: check logical block size
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     linux-kernel@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        "open list:BLOCK LAYER" <linux-block@vger.kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@kernel.dk>,
        "open list:NVM EXPRESS DRIVER" <linux-nvme@lists.infradead.org>,
        "open list:SCSI CDROM DRIVER" <linux-scsi@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Jason Wang <jasowang@redhat.com>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Ajay Joshi <ajay.joshi@wdc.com>,
        Ming Lei <ming.lei@redhat.com>,
        "open list:SONY MEMORYSTICK SUBSYSTEM" <linux-mmc@vger.kernel.org>,
        Satya Tangirala <satyat@google.com>,
        "open list:NETWORK BLOCK DEVICE (NBD)" <nbd@other.debian.org>,
        Hou Tao <houtao1@huawei.com>, Jens Axboe <axboe@fb.com>,
        "open list:VIRTIO CORE AND NET DRIVERS" 
        <virtualization@lists.linux-foundation.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Alex Dubov <oakad@yahoo.com>
Date:   Tue, 28 Jul 2020 17:27:41 +0300
In-Reply-To: <f16aba1020019530564f0869a67951282104a5d2.camel@redhat.com>
References: <20200721105239.8270-1-mlevitsk@redhat.com>
         <20200721105239.8270-3-mlevitsk@redhat.com> <20200721151437.GB10620@lst.de>
         <yq1zh7sfedj.fsf@ca-mkp.ca.oracle.com>
         <f16aba1020019530564f0869a67951282104a5d2.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-07-22 at 12:11 +0300, Maxim Levitsky wrote:
> On Tue, 2020-07-21 at 22:55 -0400, Martin K. Petersen wrote:
> > Christoph,
> > 
> > > Hmm, I wonder if we should simply add the check and warning to
> > > blk_queue_logical_block_size and add an error in that case.  Then
> > > drivers only have to check the error return, which might add a lot
> > > less boiler plate code.
> > 
> > Yep, I agree.
> > 
> 
> I also agree that this would be cleaner (I actually tried to implement
> this the way you suggest), but let me explain my reasoning for doing
> it
> this way.
> 
> The problem is that most current users of blk_queue_logical_block_size
> (43 uses in the tree, out of which only 9 use constant block size)
> check
> for the block size relatively early, often store it in some internal
> struct etc, prior to calling blk_queue_logical_block_size thus making
> them only to rely on blk_queue_logical_block_size as the check for 
> block size validity will need non-trivial changes in their code.
> 
> Instead of this adding blk_is_valid_logical_block_size allowed me
> to trivially convert most of the uses.
> 
> For RFC I converted only some drivers that I am more familiar with
> and/or can test but I can remove the driver's own checks in most other
> drivers with low chance of introducing a bug, even if I can't test the
> driver.
> 
> What do you think?
> 
> I can also both make blk_queue_logical_block_size return an error
> value,
> and have blk_is_valid_logical_block_size and use either of these
> checks,
> depending on the driver with eventual goal of un-exporting
> blk_is_valid_logical_block_size.
> 
> Also note that I did add WARN_ON to blk_queue_logical_block_size.

Any update on this?

Best regards,
	Maxim Levitsky

> 
> Best regards,
> 	Maxim Levitsky

