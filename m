Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0A4DC77B75
	for <linux-scsi@archiver.kernel.org>; Mon, 15 May 2023 05:01:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238046AbjEOFBT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 May 2023 01:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjEOFBR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 May 2023 01:01:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465D5F5
        for <linux-scsi@vger.kernel.org>; Sun, 14 May 2023 22:00:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684126833;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aHWJIFNYDCYzcoCpIA11eWPn/4tkq2tSzkUhsTyA8ZM=;
        b=KVx9mw83UUHHWpXxJcPPZYWU4U02AOUkCn83EuMnJwQ5yXxE5FxJBAFzptOwhJ59aFElH0
        AGP1JH15sDwvn5wb/6WzAEgY+TXTWM55oJ8NwxgEMNQcqoBMRlbQ5CGt1ceMp9vZ9NVf4B
        iRKoZkQ0gXiN3bEPyql7/m2xqFaBlaM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-441-o0I3xIohOaSykz08RLZVkQ-1; Mon, 15 May 2023 01:00:30 -0400
X-MC-Unique: o0I3xIohOaSykz08RLZVkQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D370F38149A2;
        Mon, 15 May 2023 05:00:29 +0000 (UTC)
Received: from ovpn-8-26.pek2.redhat.com (ovpn-8-26.pek2.redhat.com [10.72.8.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6860B35453;
        Mon, 15 May 2023 05:00:23 +0000 (UTC)
Date:   Mon, 15 May 2023 13:00:17 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     "haowenchao (C)" <haowenchao2@huawei.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        emilne@redhat.com, czhong@redhat.com,
        Wenchao Hao <haowenchao@huawei.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Mike Christie <michael.christie@oracle.com>,
        linfeilong@huawei.com
Subject: Re: SCSI: Consumer of
 scsi_devices->iorequest_cnt/iodone_cnt/ioerr_cnt
Message-ID: <ZGG8YSrgjjsdyoio@ovpn-8-26.pek2.redhat.com>
References: <ZF+zB+bB7iqe0wGd@ovpn-8-17.pek2.redhat.com>
 <e08f3fe4-a14e-c1c7-4344-7fbe0b50d44f@huawei.com>
 <ZGGl58yNUqZigOj/@ovpn-8-26.pek2.redhat.com>
 <8e0f2d31-e6ff-ec4a-3974-450560ad49c5@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e0f2d31-e6ff-ec4a-3974-450560ad49c5@huawei.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, May 15, 2023 at 11:47:31AM +0800, haowenchao (C) wrote:
> On 2023/5/15 11:24, Ming Lei wrote:
> > On Mon, May 15, 2023 at 10:55:01AM +0800, haowenchao (C) wrote:
> > > On 2023/5/13 23:55, Ming Lei wrote:
> > > > Hello Guys,
> > > > 
> > > > scsi_device->iorequest_cnt/iodone_cnt/ioerr_cnt are only inc/dec,
> > > > and exported to userspace via sysfs in kernel, and not see any kernel
> > > > consumers, so the exported counters are only for userspace, just be curious
> > > > which/how applications consume them?
> > > > 
> > > 
> > > These counters are used to checking the disk health status in a certain scenario
> > > for us.
> > 
> > All the three counters are increased only, and you could use some simple bpf code
> > to retrieve such info easily. It adds such overhead for everyone, who may not use
> > this counters at all, maybe 99% of people don't use it.
> > 
> > > 
> > > > These counters not only adds cost in fast path, but also causes kernel panic,
> > > > especially the "atomic_inc(&cmd->device->iorequest_cnt)" in
> > > > scsi_queue_rq(), because cmd->device may be freed after returning
> > > > from scsi_dispatch_cmd(), which is introduced by:
> > > > 
> > > > cfee29ffb45b ("scsi: core: Do not increase scsi_device's iorequest_cnt if dispatch failed")
> > > > 
> > > > If there aren't explicit applications which depend on these counters,
> > > > I'd suggest to kill the three since all are not in stable ABI. Otherwise
> > > > I think we need to revert cfee29ffb45b.
> > > > 
> > > > 
> > > 
> > > Sorry for introduce this bug.
> > > 
> > > We would check these counters after iodone_cnt equal to iorequest_cnt. So
> > > cfee29ffb45b is aimed to fix the issue of iorequest_cnt is increased for
> > > multiple times if scsi_dispatch_cmd() failed.
> > > 
> > > Maybe we should revert cfee29ffb45b and fix the original issue with following
> > > changes:
> > 
> > Yeah, it can be fixed in this way, can you cook one such fix?
> > 
> 
> OK, I would post patches.

Thanks!

> 
> > Longterm, maybe we can mark these sysfs interface as obsolete and let
> > existed users switch to ebpf, and finally remove them.
> > 
> 
> Where can we mark these sysfs interface as obsolete?

It could be one comment on the sysfs interface or extra logging, but not
sure if the latter can work since user expects these sysfs interfaces to
dump counter only.

Thanks,
Ming

