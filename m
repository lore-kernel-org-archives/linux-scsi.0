Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F964C001E0
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Aug 2023 00:10:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbjHJAKc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Aug 2023 20:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbjHJAKa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Aug 2023 20:10:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DC5410C7
        for <linux-scsi@vger.kernel.org>; Wed,  9 Aug 2023 17:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691626183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RhYjGeDQjHaify9fYveKNlg3W8+1+0vVy9IFYKIMw0M=;
        b=TmcJYfCnmq5zm2wFuGcK6rUmvlVg3sl4aFa4zHaQ07CgaJElz1jsrwAHeWA1/uDfmIMaHH
        fGArd4a4vA6Efd7mstjHs7u0Br+8rdqXQOgoElYrgCudRx+zM5HZ/JvFZ1ckxkxLYI4mh1
        ODS/lnFKoMPRb7ik0mlhQQ/hYsuCOAc=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-583-dBjPouXWOO-yZ4G5_5ahoA-1; Wed, 09 Aug 2023 20:09:40 -0400
X-MC-Unique: dBjPouXWOO-yZ4G5_5ahoA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0557D3802BBC;
        Thu, 10 Aug 2023 00:09:40 +0000 (UTC)
Received: from fedora (unknown [10.72.120.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EA7C02026D4B;
        Thu, 10 Aug 2023 00:09:32 +0000 (UTC)
Date:   Thu, 10 Aug 2023 08:09:27 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-nvme@lists.infradead.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Wen Xiong <wenxiong@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>, linuxppc-dev@lists.ozlabs.org,
        Dave Young <dyoung@redhat.com>, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, Baoquan He <bhe@redhat.com>,
        Pingfan Liu <piliu@redhat.com>
Subject: Re: [PATCH V3 01/14] blk-mq: add blk_mq_max_nr_hw_queues()
Message-ID: <ZNQqt1C0pXspGl3d@fedora>
References: <20230808104239.146085-1-ming.lei@redhat.com>
 <20230808104239.146085-2-ming.lei@redhat.com>
 <20230809134401.GA31852@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230809134401.GA31852@lst.de>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Aug 09, 2023 at 03:44:01PM +0200, Christoph Hellwig wrote:
> I'm starting to sound like a broken record, but we can't just do random
> is_kdump checks, and it's not going to get better by resending it again and
> again.  If kdump kernels limit the number of possible CPUs, it needs to
> reflected in cpu_possible_map and we need to use that information.
> 

Can you look at previous kdump/arch guys' comment about kdump usage &
num_possible_cpus?

    https://lore.kernel.org/linux-block/CAF+s44RuqswbosY9kMDx35crviQnxOeuvgNsuE75Bb0Y2Jg2uw@mail.gmail.com/
    https://lore.kernel.org/linux-block/ZKz912KyFQ7q9qwL@MiWiFi-R3L-srv/

The point is that kdump kernels does not limit the number of possible CPUs.

1) some archs support 'nr_cpus=1' for kdump kernel, which is fine, since
num_possible_cpus becomes 1.

2) some archs do not support 'nr_cpus=1', and have to rely on
'max_cpus=1', so num_possible_cpus isn't changed, and kernel just boots
with single online cpu. That causes trouble because blk-mq limits single
queue.

Documentation/admin-guide/kdump/kdump.rst

Thanks, 
Ming

