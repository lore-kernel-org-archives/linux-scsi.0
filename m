Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1400FC433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 01:19:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5C0A61077
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 01:19:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbhDZBUg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Apr 2021 21:20:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36619 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231403AbhDZBUg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 25 Apr 2021 21:20:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619399995;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0vq31kXoXdJ37A0m+hl8ciNYW3IbDYlul0jI6X5aa5o=;
        b=FSaSdG+cNhyiabrTE9yFSBVIerMl7otinvrW011WVwIhx/g8vVb1/Jfso+1fYxFSGHUm0c
        3GAIpe5Jqp4zDSJto4LYRCm9mW9MNVnjuJhYsYYnZA7XOZkpeFlyltTNYcD+VxYfzFvTNX
        RJtikHSafI5YD6uNosTsBbogGIXShow=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-C_6IIY35NuqtfY0jnz3Pbg-1; Sun, 25 Apr 2021 21:19:51 -0400
X-MC-Unique: C_6IIY35NuqtfY0jnz3Pbg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 46E18343A6;
        Mon, 26 Apr 2021 01:19:49 +0000 (UTC)
Received: from T590 (ovpn-12-48.pek2.redhat.com [10.72.12.48])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 44B4819D7D;
        Mon, 26 Apr 2021 01:19:39 +0000 (UTC)
Date:   Mon, 26 Apr 2021 09:19:45 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Khazhy Kumykov <khazhy@google.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        David Jeffery <djeffery@redhat.com>
Subject: Re: [PATCH 0/8] blk-mq: fix request UAF related with iterating over
 tagset requests
Message-ID: <YIYVMQmAZgKL2qdP@T590>
References: <20210425085753.2617424-1-ming.lei@redhat.com>
 <YIU2BhuYZAAgonN0@T590>
 <5c1ef3ec-dd6a-4992-586b-6e67bcd1a678@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c1ef3ec-dd6a-4992-586b-6e67bcd1a678@acm.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Apr 25, 2021 at 01:53:16PM -0700, Bart Van Assche wrote:
> On 4/25/21 2:27 AM, Ming Lei wrote:
> > On Sun, Apr 25, 2021 at 04:57:45PM +0800, Ming Lei wrote:
> >> Revert 4 patches from Bart which try to fix request UAF issue related
> >> with iterating over tagset wide requests, because:
> 
> Where were you during the four weeks that my patch series was out for
> review? I haven't seen any feedback from you on my patch series.

To be honest, it is just two days ago I have to take a close look
at your patchset because we may have to backport your patches for
addressing one RH report with high priority.

David is in CC list, and Laurence/David is looking the report too.

> 
> >> 1) request UAF caused by normal completion vs. async completion during
> >> iterating can't be covered[1]
> 
> I do not agree with the above. Patches 5/8 and 6/8 from this series can
> be applied without reverting any of my patches.

The thing is that 5 ~ 8 can fix the issue in a simpler way without
adding extra cost in fast path, and the idea is easier to be proved.

BTW, as a downstream kernel developer, I really hope all fix are simple and
easy to backport. More importantly, I do prefer to approaches in patch which
can be proved/verified easily, so further regression can be avoided.

> 
> > 4) synchronize_rcu() is added before shutting down one request queue,
> > which may slow down reboot/poweroff very much on big systems with lots of
> > HBAs in which lots of LUNs are attached.
> 
> The synchronize_rcu() can be removed by using a semaphore
> (<linux/semaphore.h>) instead of an RCU reader lock inside bt_tags_iter().

I am not sure you can, because some iteration is done in atomic context.


Thanks,
Ming

