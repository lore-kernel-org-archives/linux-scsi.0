Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0C0DC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 01:47:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D49A61629
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 01:47:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbhEKBs5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 May 2021 21:48:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43759 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230218AbhEKBs4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 May 2021 21:48:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620697670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qE7Cs7117lYWLJD4CigwEwHnctBSgoDI1H0pJNx0a/k=;
        b=fjPRraSWQHwMo0nIZbdsoAN/Wk1A5DyQSNYl71mGuhiUwZOeRiMOCnNHGaNxkghSzQTq2e
        yXBDyi+Ng/l/wq38PsQPwyM63XZj4IQNwMqlEIgBX4PcfEEZbbM4304il7jq0goF83rigs
        mekB0HL22Y7LKCAuzzXIkAhpW+lkC7A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-573-9Aj2Zn0wPkmWVUNN3vdpVg-1; Mon, 10 May 2021 21:47:49 -0400
X-MC-Unique: 9Aj2Zn0wPkmWVUNN3vdpVg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 548BD801AE3;
        Tue, 11 May 2021 01:47:47 +0000 (UTC)
Received: from T590 (ovpn-12-106.pek2.redhat.com [10.72.12.106])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 393F360C17;
        Tue, 11 May 2021 01:47:38 +0000 (UTC)
Date:   Tue, 11 May 2021 09:47:34 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     John Garry <john.garry@huawei.com>, axboe@kernel.dk,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, kashyap.desai@broadcom.com,
        chenxiang66@hisilicon.com, yama@redhat.com
Subject: Re: [PATCH] blk-mq: Use request queue-wide tags for tagset-wide
 sbitmap
Message-ID: <YJniNq6LYqiLFIlP@T590>
References: <1620037333-2495-1-git-send-email-john.garry@huawei.com>
 <YJnVasOcaVU+4+Au@T590>
 <0faa2ad6-4ae9-02b2-2f34-cf58f1e23c5b@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0faa2ad6-4ae9-02b2-2f34-cf58f1e23c5b@interlog.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, May 10, 2021 at 09:35:01PM -0400, Douglas Gilbert wrote:
> On 2021-05-10 8:52 p.m., Ming Lei wrote:
> > On Mon, May 03, 2021 at 06:22:13PM +0800, John Garry wrote:
> > > The tags used for an IO scheduler are currently per hctx.
> > > 
> > > As such, when q->nr_hw_queues grows, so does the request queue total IO
> > > scheduler tag depth.
> > > 
> > > This may cause problems for SCSI MQ HBAs whose total driver depth is
> > > fixed.
> > > 
> > > Ming and Yanhui report higher CPU usage and lower throughput in scenarios
> > > where the fixed total driver tag depth is appreciably lower than the total
> > > scheduler tag depth:
> > > https://lore.kernel.org/linux-block/440dfcfc-1a2c-bd98-1161-cec4d78c6dfc@huawei.com/T/#mc0d6d4f95275a2743d1c8c3e4dc9ff6c9aa3a76b
> > > 
> > 
> > No difference any more wrt. fio running on scsi_debug with this patch in
> > Yanhui's test machine:
> > 
> > 	modprobe scsi_debug host_max_queue=128 submit_queues=32 virtual_gb=256 delay=1
> > vs.
> > 	modprobe scsi_debug max_queue=128 submit_queues=1 virtual_gb=256 delay=1
> > 
> > Without this patch, the latter's result is 30% higher than the former's.
> > 
> > note: scsi_debug's queue depth needs to be updated to 128 for avoiding io hang,
> > which is another scsi issue.
> 
> "scsi_debug: Fix cmd_per_lun, set to max_queue" made it into lk 5.13.0-rc1 as
> commit fc09acb7de31badb2ea9e85d21e071be1a5736e4 . Is this the issue you are
> referring to, or is there a separate issue in the wider scsi stack?

OK, that is it, then it isn't necessary to update scsi_debug's queue
depth for the test.


Thanks,
Ming

