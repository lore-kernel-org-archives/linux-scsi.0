Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8239C64E7C
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 03:24:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DC08221E9
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 03:24:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbgLBDY3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 22:24:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57210 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728099AbgLBDY3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 22:24:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606879382;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4fHpQHZad1y9TfOzBtGJRwY7lMBrNPOFiTD/rM6hTYw=;
        b=FLT+NezH+JMhvhiwI4/gmDFoSFDCVq01wY813xUQFSNNq5IZ2/hgktgBflZti8AlpViS0A
        Nda7V+qCpD7HtVRPSHnIATcFS77KHZ54nLdS1ppvwuvRF9zuYV9b95bUHjXVm6z5EbezSE
        nFryowF3UiRg6H9Qb0/kRI8CdHsZfr4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-517-RWweTDkpMLiGYY_L2zP6kQ-1; Tue, 01 Dec 2020 22:22:59 -0500
X-MC-Unique: RWweTDkpMLiGYY_L2zP6kQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5DBF81084C81;
        Wed,  2 Dec 2020 03:22:57 +0000 (UTC)
Received: from T590 (ovpn-13-72.pek2.redhat.com [10.72.13.72])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 109FD5C1B4;
        Wed,  2 Dec 2020 03:22:44 +0000 (UTC)
Date:   Wed, 2 Dec 2020 11:22:37 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     "chenxiang (M)" <chenxiang66@hisilicon.com>
Cc:     John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Ewan Milne <emilne@redhat.com>, Long Li <longli@microsoft.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [bug report] Hang on sync after dd
Message-ID: <20201202032237.GC494805@T590>
References: <2847d0e1-ccb1-7be6-2456-274e41ea981b@huawei.com>
 <20201201123407.GA487145@T590>
 <f30358a5-c930-3363-86fc-9e21639d0874@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f30358a5-c930-3363-86fc-9e21639d0874@hisilicon.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Dec 02, 2020 at 09:44:48AM +0800, chenxiang (M) wrote:
> 
> 
> 在 2020/12/1 20:34, Ming Lei 写道:
> > On Mon, Nov 30, 2020 at 11:22:33AM +0000, John Garry wrote:
> > > Hi all,
> > > 
> > > Some guys internally upgraded to v5.10-rcX and start to see a hang after dd
> > > + sync for a large file:
> > > - mount /dev/sda1 (ext4 filesystem) to directory /mnt;
> > > - run "if=/dev/zero of=test1 bs=1M count=2000" on directory /mnt;
> > > - run "sync"
> > > 
> > > and get:
> > > 
> > > [  367.912761] INFO: task jbd2/sdb1-8:3602 blocked for more than 120
> > > seconds.
> > > [  367.919618]       Not tainted 5.10.0-rc1-109488-g32ded76956b6 #948
> > > [  367.925776] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> > > disables this message.
> > > [  367.933579] task:jbd2/sdb1-8     state:D stack:    0 pid: 3602
> > > ppid:     2 flags:0x00000028
> > > [  367.941901] Call trace:
> > > [  367.944351] __switch_to+0xb8/0x168
> > > [  367.947840] __schedule+0x30c/0x670
> > > [  367.951326] schedule+0x70/0x108
> > > [  367.954550] io_schedule+0x1c/0xe8
> > > [  367.957948] bit_wait_io+0x18/0x68
> > > [  367.961346] __wait_on_bit+0x78/0xf0
> > > [  367.964919] out_of_line_wait_on_bit+0x8c/0xb0
> > > [  367.969356] __wait_on_buffer+0x30/0x40
> > > [  367.973188] jbd2_journal_commit_transaction+0x1370/0x1958
> > > [  367.978661] kjournald2+0xcc/0x260
> > > [  367.982061] kthread+0x150/0x158
> > > [  367.985288] ret_from_fork+0x10/0x34
> > > [  367.988860] INFO: task sync:3823 blocked for more than 120 seconds.
> > > [  367.995102]       Not tainted 5.10.0-rc1-109488-g32ded76956b6 #948
> > > [  368.001265] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> > > disables this message.
> > > [  368.009067] task:sync            state:D stack:    0 pid: 3823 ppid:
> > > 3450 flags:0x00000009
> > > [  368.017397] Call trace:
> > > [  368.019841] __switch_to+0xb8/0x168
> > > [  368.023320] __schedule+0x30c/0x670
> > > [  368.026804] schedule+0x70/0x108
> > > [  368.030025] jbd2_log_wait_commit+0xbc/0x158
> > > [  368.034290] ext4_sync_fs+0x188/0x1c8
> > > [  368.037947] sync_fs_one_sb+0x30/0x40
> > > [  368.041606] iterate_supers+0x9c/0x138
> > > [  368.045350] ksys_sync+0x64/0xc0
> > > [  368.048569] __arm64_sys_sync+0x10/0x20
> > > [  368.052398] el0_svc_common.constprop.3+0x68/0x170
> > > [  368.057177] do_el0_svc+0x24/0x90
> > > [  368.060482] el0_sync_handler+0x118/0x168
> > > [  368.064478]  el0_sync+0x158/0x180
> > > 
> > > The issue was reported here originally:
> > > https://lore.kernel.org/linux-ext4/4d18326e-9ca2-d0cb-7cb8-cb56981280da@hisilicon.com/
> > > 
> > > But it looks like issue related to recent work for SCSI MQ.
> > > 
> > > They can only create with hisi_sas v3 hw. I could not create with megaraid
> > > sas on the same dev platform or hisi_sas on a similar dev board.
> > > 
> > > Reverting "scsi: core: Only re-run queue in scsi_end_request() if device
> > > queue is busy" seems solve the issue. Also, checking out to patch prior to
> > > "scsi: hisi_sas: Switch v3 hw to MQ" seems to not have the issue.
> > If the issue can be reproduced, you may try the following patch:
> 
> I tried the change, and the issue is still.
> We find that the number of completed IO is less than dispatched, but from
> sysfs of block device (such as /sys/devices/pci0000:74/0000:74:02.0/host0/port-0:0/end_device-0:0/target0:0:0/0:0:0:0/block/sda/sda1/inflight),
> 
> the number of inflight is 0.

Hello chenxiang,

Can you collect the debugfs log via the following commands after the io
hang is triggered?

1) debugfs log:

        (cd /sys/kernel/debug/block/sda && find . -type f -exec grep -aH . {} \;)

2) scsi sysfs info:

        (cd /sys/block/sda/device && find . -type f -exec grep -aH . {} \;)

Suppose the disk is /dev/sda.


thanks, 
Ming

