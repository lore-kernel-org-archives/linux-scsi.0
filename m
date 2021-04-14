Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 820D9C433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Apr 2021 11:13:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65BAB613C7
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Apr 2021 11:13:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343620AbhDNLNh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Apr 2021 07:13:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41684 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233782AbhDNLNb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Apr 2021 07:13:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618398790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lmcd4yNDK6m4LdYbCyC6OJ36F9ut6wI6H2zkBnb0asU=;
        b=B/KjsnK3YrXuOxMblx58CAVg5EQXuN7cZXjJhXCViW/h5VK+4bdxenPNCEM6/KKC2infgT
        cCjlp/zHAQOuhKjgcGxgXECJUHGNZZ9BhEm3o0awzSwRb7PKTMTF7MuWOQucLYE/VNJsN7
        yMUAcYRPDPKOFvJ36MWBGUBF6E5IlN8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-Wutij_eAPdGRiBV3BjV-Eg-1; Wed, 14 Apr 2021 07:13:08 -0400
X-MC-Unique: Wutij_eAPdGRiBV3BjV-Eg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BC9199F92D;
        Wed, 14 Apr 2021 11:13:06 +0000 (UTC)
Received: from T590 (ovpn-12-91.pek2.redhat.com [10.72.12.91])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C4E5A437F;
        Wed, 14 Apr 2021 11:13:02 +0000 (UTC)
Date:   Wed, 14 Apr 2021 19:12:57 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Kashyap Desai <kashyap.desai@broadcom.com>
Cc:     John Garry <john.garry@huawei.com>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [bug report] shared tags causes IO hang and performance drop
Message-ID: <YHbOOfGNHwO4SMS7@T590>
References: <YHaez6iN2HHYxYOh@T590>
 <9a6145a5-e6ac-3d33-b52a-0823bfc3b864@huawei.com>
 <cb326d404c6e0785d03a7dfadc42832c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb326d404c6e0785d03a7dfadc42832c@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Apr 14, 2021 at 04:12:22PM +0530, Kashyap Desai wrote:
> > Hi Ming,
> >
> > >
> > > It is reported inside RH that CPU utilization is increased ~20% when
> > > running simple FIO test inside VM which disk is built on image stored
> > > on XFS/megaraid_sas.
> > >
> > > When I try to investigate by reproducing the issue via scsi_debug, I
> > > found IO hang when running randread IO(8k, direct IO, libaio) on
> > > scsi_debug disk created by the following command:
> > >
> > > 	modprobe scsi_debug host_max_queue=128
> > submit_queues=$NR_CPUS
> > > virtual_gb=256
> > >
> >
> > So I can recreate this hang for using mq-deadline IO sched for scsi debug,
> > in
> > that fio does not exit. I'm using v5.12-rc7.
> 
> I can also recreate this issue using mq-deadline. Using <none>, there is no
> IO hang issue.
> Also if I run script to change scheduler periodically (none, mq-deadline),
> sysfs entry hangs.
> 
> Here is call trace-
> Call Trace:
> [ 1229.879862]  __schedule+0x29d/0x7a0
> [ 1229.879871]  schedule+0x3c/0xa0
> [ 1229.879875]  blk_mq_freeze_queue_wait+0x62/0x90
> [ 1229.879880]  ? finish_wait+0x80/0x80
> [ 1229.879884]  elevator_switch+0x12/0x40
> [ 1229.879888]  elv_iosched_store+0x79/0x120
> [ 1229.879892]  ? kernfs_fop_write_iter+0xc7/0x1b0
> [ 1229.879897]  queue_attr_store+0x42/0x70
> [ 1229.879901]  kernfs_fop_write_iter+0x11f/0x1b0
> [ 1229.879905]  new_sync_write+0x11f/0x1b0
> [ 1229.879912]  vfs_write+0x184/0x250
> [ 1229.879915]  ksys_write+0x59/0xd0
> [ 1229.879917]  do_syscall_64+0x33/0x40
> [ 1229.879922]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> 
> I tried both - 5.12.0-rc1 and 5.11.0-rc2+ and there is a same behavior.
> Let me also check  megaraid_sas and see if anything generic or this is a
> special case of scsi_debug.

As I mentioned, it could be one generic issue wrt. SCHED_RESTART.
shared tags might have to restart all hctx since all share same tags.


Thanks,
Ming

