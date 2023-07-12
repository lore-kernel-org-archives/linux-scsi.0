Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5E7EEB64D9
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Jul 2023 13:17:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233441AbjGLNRT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Jul 2023 09:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233297AbjGLNRR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2023 09:17:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FEB019A6
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 06:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689167789;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YdW3jXa75uZifOOTp5ZtJFJJaNTXIh3AfAYdiE+BpGY=;
        b=WnSMxcrcFSYGuzxrFkhQ0b7L0aqtjSCauyDxZUZUD7xR+5mZwdhVCCY3z+r7wShKtPHZrs
        UlWDN5+yeSrPhL1v+ZpzMixsrB1IGls+eLGWZWjTfWoIb9IcA35qTtVbrJuqsYiOu+ZIRb
        YQp28KLXeR+1dnV/d3+KUL8KdpmEJyo=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-288-6xGLn3mlMKuJeIXdR53l4w-1; Wed, 12 Jul 2023 09:16:25 -0400
X-MC-Unique: 6xGLn3mlMKuJeIXdR53l4w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6E9C23C0C491;
        Wed, 12 Jul 2023 13:16:24 +0000 (UTC)
Received: from ovpn-8-25.pek2.redhat.com (ovpn-8-25.pek2.redhat.com [10.72.8.25])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F33FC4087C73;
        Wed, 12 Jul 2023 12:38:00 +0000 (UTC)
Date:   Wed, 12 Jul 2023 21:16:11 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-nvme@lists.infradead.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Wen Xiong <wenxiong@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] blk-mq: add blk_mq_max_nr_hw_queues()
Message-ID: <ZK6nm2koR+TfeMcs@ovpn-8-25.pek2.redhat.com>
References: <20230712125455.1986455-1-ming.lei@redhat.com>
 <20230712125455.1986455-2-ming.lei@redhat.com>
 <20230712130017.GA12417@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230712130017.GA12417@lst.de>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jul 12, 2023 at 03:00:17PM +0200, Christoph Hellwig wrote:
> On Wed, Jul 12, 2023 at 08:54:48PM +0800, Ming Lei wrote:
> > +/* Max nr_hw_queues for each hw queue type */
> > +unsigned int blk_mq_max_nr_hw_queues(void)
> > +{
> > +	if (is_kdump_kernel())
> > +		return 1;
> > +	return nr_cpu_ids;
> 
> Again, these is_kdump_kernel hacks don't make any sense.   The amount
> of maximum available CPU needs to come through a proper API, and we
> need to use it, not add hacks like this.
> 
> The only thing that makes sense here is to find the last CPU
> in cpu_possible_mask, and for kdump kernels to ensure that number
> is 1 or whatever low value they want.

It doesn't matter how many cpus are available, given at least one
cpu is online.

The problem is that blk_mq_alloc_tag_set() forces to set nr_hw_queues
as 1 for kdump kernel, that is why blk_mq_max_nr_hw_queues() has to
return 1 for kdump kernel.

We have to tell driver that blk-mq only supports 1 queue for kdump
kernel.

Or:

Thomas, can we disable managed irq for kdump kernel and switch to
non-managed irq? Then we can avoid driver's change. I'd suggest
this way if it is possible.

Thanks,
Ming

