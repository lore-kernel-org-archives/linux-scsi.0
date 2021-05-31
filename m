Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7CD9C47092
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 01:22:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF6636100B
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 01:22:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbhEaBYF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 30 May 2021 21:24:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53235 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229891AbhEaBYE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 30 May 2021 21:24:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622424144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oexqDgsEO/C/755NVBQ6lb8PYWosWSIrZucWIeBcye8=;
        b=TU4MTS2zWO6pwoWqovYrYwmPjTp0/E1jAujE04P/fEn7sTJZTsEWXgy5wFOkXwu7/Ojd9e
        mLEEyR1sW5qJ4XqzpD+xYU3cdQPfxobCIAH0Rqay5/vosoItdrpfOt9rS+HWMUD/Uk+xou
        ts/qZ0N0XH2RHbGnOqHBNyv8kkpXPbA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-iwQEQkzZMrObkzcyzIS14A-1; Sun, 30 May 2021 21:22:23 -0400
X-MC-Unique: iwQEQkzZMrObkzcyzIS14A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 010B06D246;
        Mon, 31 May 2021 01:22:22 +0000 (UTC)
Received: from T590 (ovpn-12-79.pek2.redhat.com [10.72.12.79])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E61A110023AF;
        Mon, 31 May 2021 01:22:15 +0000 (UTC)
Date:   Mon, 31 May 2021 09:22:10 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH V2 1/2] scsi: core: fix failure handling of
 scsi_add_host_with_dma
Message-ID: <YLQ6QsF1Pq5c6S/9@T590>
References: <20210528011838.2122559-1-ming.lei@redhat.com>
 <20210528011838.2122559-2-ming.lei@redhat.com>
 <0e3a05ab-2dba-cafd-2840-70a0559a9140@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e3a05ab-2dba-cafd-2840-70a0559a9140@huawei.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, May 28, 2021 at 09:34:44AM +0100, John Garry wrote:
> On 28/05/2021 02:18, Ming Lei wrote:
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
> > Fixes the problem by relying on host device's release handler to
> > release everything.
> > 
> > Cc: Bart Van Assche <bvanassche@acm.org>
> > Cc: John Garry <john.garry@huawei.com>
> > Cc: Hannes Reinecke <hare@suse.de>
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> 
> It now looks like we have a memory leak:
> 
> unreferenced object 0xffff0410070a4e00 (size 128):
>   comm "swapper/0", pid 1, jiffies 4294894100 (age 90.744s)
>   hex dump (first 32 bytes):
> 68 6f 73 74 30 00 00 00 00 00 00 00 00 00 00 00  host0...........
> 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
> [<(____ptrval____)>] __kmalloc_track_caller+0x25c/0x380
> [<(____ptrval____)>] kvasprintf+0xe8/0x1a4
> [<(____ptrval____)>] kvasprintf_const+0xc8/0x17c
> [<(____ptrval____)>] kobject_set_name_vargs+0x58/0xf4
> [<(____ptrval____)>] dev_set_name+0xa4/0xe0
> [<(____ptrval____)>] scsi_host_alloc+0x45c/0x5d0
> [<(____ptrval____)>] hisi_sas_probe+0x40/0x570
> [<(____ptrval____)>] hisi_sas_v2_probe+0x1c/0x2c
> [<(____ptrval____)>] platform_probe+0x90/0x110
> [<(____ptrval____)>] really_probe+0x148/0x744
> [<(____ptrval____)>] driver_probe_device+0x8c/0xfc
> [<(____ptrval____)>] device_driver_attach+0x11c/0x12c
> [<(____ptrval____)>] __driver_attach+0xc8/0x1a0
> [<(____ptrval____)>] bus_for_each_dev+0xe4/0x154
> [<(____ptrval____)>] driver_attach+0x38/0x50
> [<(____ptrval____)>] bus_add_driver+0x1bc/0x2c4
> unreferenced object 0xffff001056581800 (size 256):
>   comm "swapper/0", pid 1, jiffies 4294894398 (age 89.560s)
>   hex dump (first 32 bytes):
> 00 00 00 00 00 00 00 00 08 18 58 56 10 00 ff ff  ..........XV....
> 08 18 58 56 10 00 ff ff c0 f4 b4 10 00 80 ff ff  ..XV............
>   backtrace:
> [<(____ptrval____)>] kmem_cache_alloc+0x298/0x350
> [<(____ptrval____)>] device_add+0x6d8/0xc4c
> [<(____ptrval____)>] scsi_add_host_with_dma+0x370/0x5dc
> [<(____ptrval____)>] hisi_sas_probe+0x418/0x570
> [<(____ptrval____)>] hisi_sas_v2_probe+0x1c/0x2c
> [<(____ptrval____)>] platform_probe+0x90/0x110
> [<(____ptrval____)>] really_probe+0x148/0x744
> [<(____ptrval____)>] driver_probe_device+0x8c/0xfc
> [<(____ptrval____)>] device_driver_attach+0x11c/0x12c
> [<(____ptrval[  101.941505] random: fast init done
> ____)>] __driver_attach+0xc8/0x1a0
> [<(____ptrval____)>] bus_for_each_dev+0xe4/0x154
> [<(____ptrval____)>] driver_attach+0x38/0x50
> [<(____ptrval____)>] bus_add_driver+0x1bc/0x2c4
> [<(____ptrval____)>] driver_register+0xe4/0x210
> [<(____ptrval____)>] __platform_driver_register+0x48/0x60
> [<(____ptrval____)>] hisi_sas_v2_driver_init+0x20/0x2c
> 
> I think that the release for the shost_dev dev name memory needs fixing.
> 
> In scsi_host_dev_release(), for my experiment, shost state is running, so we
> miss the kfree(dev_name(&shost->shost_dev)), I guess. Not sure on the proper
> fix.

kobject_cleanup() is responsible for freeing dev->kobj.name, so nothing
to do with freeing the device name.

The following delta patch may fix the issue, and we should have
wrap it into the 2nd patch, can you test it and see if the kmemleak
warning is fixed?

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 492b64f349e1..7f7e0b3f6a3c 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -298,6 +298,7 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
        put_device(&shost->shost_gendev);
        device_del(&shost->shost_dev);
  out_del_gendev:
+       put_device(shost->shost_gendev.parent);
        device_del(&shost->shost_gendev);
  out_disable_runtime_pm:
        device_disable_async_suspend(&shost->shost_gendev);



Thanks,
Ming

