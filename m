Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6B6BC001B0
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Aug 2023 01:19:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231771AbjHJBTZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Aug 2023 21:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbjHJBTY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Aug 2023 21:19:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8BF910DC
        for <linux-scsi@vger.kernel.org>; Wed,  9 Aug 2023 18:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691630316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8RyE1XhIfdOavy1+yd7tZWH6XrA0A0ZMjPep4bJOZxA=;
        b=A3Fsu839pyA4VM4uZIr6VXdbFy9Tg6/G7MicivBy0GbByahVspoYfXZVktHowrb9j405JF
        bRznq8M7/FLjDWq0dUJ9KkKaGmJsj13bCeUtWtR0raHZcU0BspREf8dEQ3jI71UPs/IJmO
        roWoTh640VGD1ngfffCac6YS/jrdVFY=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-251-yJgvA4ilMeOrCYwrgq4MeA-1; Wed, 09 Aug 2023 21:18:33 -0400
X-MC-Unique: yJgvA4ilMeOrCYwrgq4MeA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 448DA1C04182;
        Thu, 10 Aug 2023 01:18:32 +0000 (UTC)
Received: from localhost (unknown [10.72.112.99])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 45ECB2166B25;
        Thu, 10 Aug 2023 01:18:29 +0000 (UTC)
Date:   Thu, 10 Aug 2023 09:18:27 +0800
From:   Baoquan He <bhe@redhat.com>
To:     Ming Lei <ming.lei@redhat.com>, mpe@ellerman.id.au,
        npiggin@gmail.com, christophe.leroy@csgroup.eu
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        linux-nvme@lists.infradead.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Wen Xiong <wenxiong@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>, linuxppc-dev@lists.ozlabs.org,
        Dave Young <dyoung@redhat.com>, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, Pingfan Liu <piliu@redhat.com>
Subject: Re: [PATCH V3 01/14] blk-mq: add blk_mq_max_nr_hw_queues()
Message-ID: <ZNQ64xhCIBU6XM/5@MiWiFi-R3L-srv>
References: <20230808104239.146085-1-ming.lei@redhat.com>
 <20230808104239.146085-2-ming.lei@redhat.com>
 <20230809134401.GA31852@lst.de>
 <ZNQqt1C0pXspGl3d@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZNQqt1C0pXspGl3d@fedora>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 08/10/23 at 08:09am, Ming Lei wrote:
> On Wed, Aug 09, 2023 at 03:44:01PM +0200, Christoph Hellwig wrote:
> > I'm starting to sound like a broken record, but we can't just do random
> > is_kdump checks, and it's not going to get better by resending it again and
> > again.  If kdump kernels limit the number of possible CPUs, it needs to
> > reflected in cpu_possible_map and we need to use that information.
> > 
> 
> Can you look at previous kdump/arch guys' comment about kdump usage &
> num_possible_cpus?
> 
>     https://lore.kernel.org/linux-block/CAF+s44RuqswbosY9kMDx35crviQnxOeuvgNsuE75Bb0Y2Jg2uw@mail.gmail.com/
>     https://lore.kernel.org/linux-block/ZKz912KyFQ7q9qwL@MiWiFi-R3L-srv/
> 
> The point is that kdump kernels does not limit the number of possible CPUs.
> 
> 1) some archs support 'nr_cpus=1' for kdump kernel, which is fine, since
> num_possible_cpus becomes 1.

Yes, "nr_cpus=" is strongly suggested in kdump kernel because "nr_cpus="
limits the possible cpu numbers, while "maxcpuss=" only limits the cpu
number which can be brought up during bootup. We noticed this diference
because a large number of possible cpus will cost more memory in kdump
kernel. e.g percpu initialization, even though kdump kernel have set
"maxcpus=1". 

Currently x86 and arm64 all support "nr_cpus=". Pingfan ever spent much
effort to make patches to add "nr_cpus=" support to ppc64, seems ppc64
dev and maintainers do not care about it. Finally the patches are not
accepted, and the work is not continued.

Now, I am wondering what is the barrier to add "nr_cpus=" to power ach.
Can we reconsider adding 'nr_cpus=' to power arch since real issue
occurred in kdump kernel?

As for this patchset, it can be accpeted so that no failure in kdump
kernel is seen on ARCHes w/o "nr_cpus=" support? My personal opinion.

> 
> 2) some archs do not support 'nr_cpus=1', and have to rely on
> 'max_cpus=1', so num_possible_cpus isn't changed, and kernel just boots
> with single online cpu. That causes trouble because blk-mq limits single
> queue.
> 
> Documentation/admin-guide/kdump/kdump.rst
> 
> Thanks, 
> Ming
> 

