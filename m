Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A25F1C47089
	for <linux-scsi@archiver.kernel.org>; Fri, 28 May 2021 00:59:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85E53613BF
	for <linux-scsi@archiver.kernel.org>; Fri, 28 May 2021 00:59:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234427AbhE1BBA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 May 2021 21:01:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44183 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229843AbhE1BBA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 May 2021 21:01:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622163565;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RhAEnGi9O7M6HDq/6rAFcMFXOdmJvtCkr99RM1l/1kg=;
        b=WcBHXm0UoMuQBRmKmzhl5/fQJJEc8hYD/t0YAi55wrFhmimILZGQWAcZtoU7aA5NuSF59a
        GQAlKH0vsAMU4plk4+McBDb95R26KvtjfLQHsfC2V1BtcGMtS6Tup/8tVbDgSE2Pw94pUQ
        cQkJVEUMlDHNu5sSGjLqSYzsj7Acf7Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-tuV92zXNNBKywQBmrsCvQQ-1; Thu, 27 May 2021 20:59:24 -0400
X-MC-Unique: tuV92zXNNBKywQBmrsCvQQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DC31C107ACE4;
        Fri, 28 May 2021 00:59:22 +0000 (UTC)
Received: from T590 (ovpn-12-72.pek2.redhat.com [10.72.12.72])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 72F571037EAB;
        Fri, 28 May 2021 00:59:15 +0000 (UTC)
Date:   Fri, 28 May 2021 08:59:11 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: core: fix failure handling of
 scsi_add_host_with_dma
Message-ID: <YLBAXy998VhqEvLY@T590>
References: <20210526081055.1932084-1-ming.lei@redhat.com>
 <6e5416aa-be0b-1cb5-918f-5eab93e155cb@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e5416aa-be0b-1cb5-918f-5eab93e155cb@huawei.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, May 27, 2021 at 06:50:57PM +0100, John Garry wrote:
> On 26/05/2021 09:10, Ming Lei wrote:
> > When scsi_add_host_with_dma() return failure, the caller will call
> > scsi_host_put(shost) to release everything allocated for this host
> > instance. So we can't free allocated stuff in scsi_add_host_with_dma(),
> > otherwise double free will be caused.
> > 
> > Strictly speaking, these host resources allocation should have been
> > moved to scsi_host_alloc(), but the allocation may need driver's
> > info which can be built between calling scsi_host_alloc() and
> > scsi_add_host(), so just keep the allocations in
> > scsi_add_host_with_dma().
> > 
> 
> Hi Ming,
> 
> I did an experiment by making scsi_add_host_with_dma() fail by hacking the
> code, like:
> 
>                 snprintf(shost->work_q_name, sizeof(shost->work_q_name),
>                          "scsi_wq_%d", shost->host_no);
> #if 0
>              shost->work_q = alloc_workqueue("%s",
>                         WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM |
> WQ_UNBOUND,
>                         1, shost->work_q_name);
> #endif
> 
> I was finding that the shost gendev kobj kref count was 2 at the "fail"
> label - I would expect 1.
> 
> Did you actually ever see the release function - scsi_host_dev_release() -
> being called and causing the double free?

There is one new leak issue in the failure path and the following patch
should address it:

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index ea50856cb203..47b4ba16b017 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -296,6 +296,7 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
         */
  out_del_dev:
        device_del(&shost->shost_dev);
+       put_device(&shost->shost_gendev);
  out_del_gendev:
        device_del(&shost->shost_gendev);
  out_disable_runtime_pm:



Thanks, 
Ming

