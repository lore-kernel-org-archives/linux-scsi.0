Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04BE7C11F67
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Jun 2021 00:11:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEB0E61D81
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Jun 2021 00:11:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235542AbhF3AOW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Jun 2021 20:14:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51391 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233056AbhF3AOV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Jun 2021 20:14:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625011913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AXmJYeg/VwAYgEkMi4byahnNYl0DGKfOXia88LeeT0U=;
        b=VBuxD51uMY4+ZIzLINluARQb76rdMnVzxk45QQqvCIsheX7I0e/xoYn7W5EN1vWgMx4uVF
        wSmH84/xbDZZ5K1RBXCze0tpd9c6+mvbuSu4LxPJXk9l9U4dUfhqh4Igx47cIam5K9x0p6
        qmKBj5f0ZDyRIghMwJrJyKW2y6Gig+o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-444-ByBfIghAPPGzWEu0wu3exA-1; Tue, 29 Jun 2021 20:11:51 -0400
X-MC-Unique: ByBfIghAPPGzWEu0wu3exA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 45B66100B3AD;
        Wed, 30 Jun 2021 00:11:50 +0000 (UTC)
Received: from T590 (ovpn-12-77.pek2.redhat.com [10.72.12.77])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E414D19D9B;
        Wed, 30 Jun 2021 00:11:42 +0000 (UTC)
Date:   Wed, 30 Jun 2021 08:11:37 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Tyrel Datwyler <tyreld@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/4] scsi: core: fix error handling of scsi_host_alloc
Message-ID: <YNu2uZAqrXuMqAFB@T590>
References: <20210602133029.2864069-1-ming.lei@redhat.com>
 <20210602133029.2864069-2-ming.lei@redhat.com>
 <57f7bb8a-cd21-e553-8f42-f154b9e232f5@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57f7bb8a-cd21-e553-8f42-f154b9e232f5@linux.ibm.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jun 29, 2021 at 12:23:04PM -0700, Tyrel Datwyler wrote:
> On 6/2/21 6:30 AM, Ming Lei wrote:
> > After device is initialized via device_initialize(), or its name is
> > set via dev_set_name(), the device has to be freed via put_device(),
> > otherwise device name will be leaked because it is allocated
> > dynamically in dev_set_name().
> > 
> > Fixes the issue by replacing kfree(shost) via put_device(&shost->shost_gendev)
> > which can help to free dev_name(&shost->shost_dev) when host state is
> > in SHOST_CREATED. Meantime needn't to remove IDA and stop the kthread of
> > shost->ehandler in the error handling code.
> 
> This statement is incorrect for kthread. If error handler thread failed to spawn
> the value of shost->ehandler will be ERR_PTR(-ENOMEM) which will pass the "if
> (shost->ehandler)" check in scsi_host_dev_release() resulting in a
> kthread_stop() call for a non-existant kthread which triggers a bad pointer
> dereference. Here is an example splat:
> 
> scsi host11: error handler thread failed to spawn, error = -4
> Kernel attempted to read user page (10c) - exploit attempt? (uid: 0)
> BUG: Kernel NULL pointer dereference on read at 0x0000010c
> Faulting instruction address: 0xc00000000818e9a8
> Oops: Kernel access of bad area, sig: 11 [#1]
> LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
> Modules linked in: ibmvscsi(+) scsi_transport_srp dm_multipath dm_mirror dm_region
>  hash dm_log dm_mod fuse overlay squashfs loop
> CPU: 12 PID: 274 Comm: systemd-udevd Not tainted 5.13.0-rc7 #1
> NIP:  c00000000818e9a8 LR: c0000000089846e8 CTR: 0000000000007ee8
> REGS: c000000037d12ea0 TRAP: 0300   Not tainted  (5.13.0-rc7)
> MSR:  800000000280b033 &lt;SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE&gt;  CR: 28228228
> XER: 20040001
> CFAR: c0000000089846e4 DAR: 000000000000010c DSISR: 40000000 IRQMASK: 0
> GPR00: c0000000089846e8 c000000037d13140 c000000009cc1100 fffffffffffffffc
> GPR04: 0000000000000001 0000000000000000 0000000000000000 c000000037dc0000
> GPR08: 0000000000000000 c000000037dc0000 0000000000000001 00000000fffff7ff
> GPR12: 0000000000008000 c00000000a049000 c000000037d13d00 000000011134d5a0
> GPR16: 0000000000001740 c0080000190d0000 c0080000190d1740 c000000009129288
> GPR20: c000000037d13bc0 0000000000000001 c000000037d13bc0 c0080000190b7898
> GPR24: c0080000190b7708 0000000000000000 c000000033bb2c48 0000000000000000
> GPR28: c000000046b28280 0000000000000000 000000000000010c fffffffffffffffc
> NIP [c00000000818e9a8] kthread_stop+0x38/0x230
> LR [c0000000089846e8] scsi_host_dev_release+0x98/0x160
> Call Trace:
> [c000000033bb2c48] 0xc000000033bb2c48 (unreliable)
> [c0000000089846e8] scsi_host_dev_release+0x98/0x160
> [c00000000891e960] device_release+0x60/0x100
> [c0000000087e55c4] kobject_release+0x84/0x210
> [c00000000891ec78] put_device+0x28/0x40
> [c000000008984ea4] scsi_host_alloc+0x314/0x430
> [c0080000190b38bc] ibmvscsi_probe+0x54/0xad0 [ibmvscsi]
> [c000000008110104] vio_bus_probe+0xa4/0x4b0
> [c00000000892a860] really_probe+0x140/0x680
> [c00000000892aefc] driver_probe_device+0x15c/0x200
> [c00000000892b63c] device_driver_attach+0xcc/0xe0
> [c00000000892b740] __driver_attach+0xf0/0x200
> [c000000008926f28] bus_for_each_dev+0xa8/0x130
> [c000000008929ce4] driver_attach+0x34/0x50
> [c000000008928fc0] bus_add_driver+0x1b0/0x300
> [c00000000892c798] driver_register+0x98/0x1a0
> [c00000000810eb60] __vio_register_driver+0x80/0xe0
> [c0080000190b4a30] ibmvscsi_module_init+0x9c/0xdc [ibmvscsi]
> [c0000000080121d0] do_one_initcall+0x60/0x2d0
> [c000000008261abc] do_init_module+0x7c/0x320
> [c000000008265700] load_module+0x2350/0x25b0
> [c000000008265cb4] __do_sys_finit_module+0xd4/0x160
> [c000000008031110] system_call_exception+0x150/0x2d0
> [c00000000800d35c] system_call_common+0xec/0x278
> 
> 
> I'm happy to send a fix, but I see two possible approaches.
> 
> 1.) Set shost->ehandler = NULL if kthread_run() fails in scsi_host_alloc()
> 
> or
> 
> 2.) Test that (shost->ehandler && !IS_ERR(shost->ehandler)) before calling
> kthread_stop in scsi_host_dev_release()

Either one looks fine for me, please go ahead to make a patch, and thanks for
the catch!

-- 
Ming

