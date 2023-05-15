Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE859C7EE22
	for <linux-scsi@archiver.kernel.org>; Mon, 15 May 2023 03:25:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236070AbjEODZ0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 14 May 2023 23:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232128AbjEODZY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 14 May 2023 23:25:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC38E170A
        for <linux-scsi@vger.kernel.org>; Sun, 14 May 2023 20:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684121078;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JO5IEQp9pMx5owR/nMECYcKyPQoURvnd9nl4BtR89K0=;
        b=baB/NUqDpiaMjsjT6Pb7Sjl1HON4kKsnicPxsyYNbJQXN5ES7mvTr4x9WN2ZgHjEth7hhu
        STo2weFldczV0F6Qw0xUNfnT7wEog8h9VwJtKADF+D7swxaXR7/9dVApiy7+F+lchoVAYM
        Y+0EhSGI29/uK7lrQyQ1hm98rKe6G3s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-399-WF2zTZbuPraL-lqidgiv6A-1; Sun, 14 May 2023 23:24:35 -0400
X-MC-Unique: WF2zTZbuPraL-lqidgiv6A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 93C5A85264E;
        Mon, 15 May 2023 03:24:34 +0000 (UTC)
Received: from ovpn-8-26.pek2.redhat.com (ovpn-8-26.pek2.redhat.com [10.72.8.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 36406492B00;
        Mon, 15 May 2023 03:24:28 +0000 (UTC)
Date:   Mon, 15 May 2023 11:24:23 +0800
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
Message-ID: <ZGGl58yNUqZigOj/@ovpn-8-26.pek2.redhat.com>
References: <ZF+zB+bB7iqe0wGd@ovpn-8-17.pek2.redhat.com>
 <e08f3fe4-a14e-c1c7-4344-7fbe0b50d44f@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e08f3fe4-a14e-c1c7-4344-7fbe0b50d44f@huawei.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, May 15, 2023 at 10:55:01AM +0800, haowenchao (C) wrote:
> On 2023/5/13 23:55, Ming Lei wrote:
> > Hello Guys,
> > 
> > scsi_device->iorequest_cnt/iodone_cnt/ioerr_cnt are only inc/dec,
> > and exported to userspace via sysfs in kernel, and not see any kernel
> > consumers, so the exported counters are only for userspace, just be curious
> > which/how applications consume them?
> > 
> 
> These counters are used to checking the disk health status in a certain scenario
> for us.

All the three counters are increased only, and you could use some simple bpf code
to retrieve such info easily. It adds such overhead for everyone, who may not use
this counters at all, maybe 99% of people don't use it.

> 
> > These counters not only adds cost in fast path, but also causes kernel panic,
> > especially the "atomic_inc(&cmd->device->iorequest_cnt)" in
> > scsi_queue_rq(), because cmd->device may be freed after returning
> > from scsi_dispatch_cmd(), which is introduced by:
> > 
> > cfee29ffb45b ("scsi: core: Do not increase scsi_device's iorequest_cnt if dispatch failed")
> > 
> > If there aren't explicit applications which depend on these counters,
> > I'd suggest to kill the three since all are not in stable ABI. Otherwise
> > I think we need to revert cfee29ffb45b.
> > 
> > 
> 
> Sorry for introduce this bug.
> 
> We would check these counters after iodone_cnt equal to iorequest_cnt. So
> cfee29ffb45b is aimed to fix the issue of iorequest_cnt is increased for
> multiple times if scsi_dispatch_cmd() failed.
> 
> Maybe we should revert cfee29ffb45b and fix the original issue with following
> changes:

Yeah, it can be fixed in this way, can you cook one such fix?

Longterm, maybe we can mark these sysfs interface as obsolete and let
existed users switch to ebpf, and finally remove them.

thanks,
Ming

