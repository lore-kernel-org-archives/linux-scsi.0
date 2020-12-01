Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBE94C64E7B
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 12:36:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AAC0206F9
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 12:36:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PvTQ2hYi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728676AbgLAMgI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 07:36:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59943 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726619AbgLAMgI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 07:36:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606826081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ygashNSvgOjNlyFvBI6Y6mG7IWxUtdVgm6VePqlDt9k=;
        b=PvTQ2hYi3D6CiTqR3w+vCIU6kVv77MPZ7FxGPujyWzcs8Bv+1LJJptUiBxy9PmwpBbGVHZ
        bRBXAcRtk2Hjm8HLaF7vhCiZPMAQi+95ii/+mwsgfxlFa+aHTSpFKDYFLBx3+Wf7qPivXV
        sUQuXAbxx6qWSUqdtqBeov++iKtYlkA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-385-yDmy_c3vNVeRB7_5jLfTFQ-1; Tue, 01 Dec 2020 07:34:37 -0500
X-MC-Unique: yDmy_c3vNVeRB7_5jLfTFQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1CA1B101DF8F;
        Tue,  1 Dec 2020 12:34:17 +0000 (UTC)
Received: from T590 (ovpn-12-90.pek2.redhat.com [10.72.12.90])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A1105D6AB;
        Tue,  1 Dec 2020 12:34:11 +0000 (UTC)
Date:   Tue, 1 Dec 2020 20:34:07 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     Hannes Reinecke <hare@suse.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Bart Van Assche <bvanassche@acm.org>,
        chenxiang <chenxiang66@hisilicon.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Ewan Milne <emilne@redhat.com>, Long Li <longli@microsoft.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [bug report] Hang on sync after dd
Message-ID: <20201201123407.GA487145@T590>
References: <2847d0e1-ccb1-7be6-2456-274e41ea981b@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2847d0e1-ccb1-7be6-2456-274e41ea981b@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Nov 30, 2020 at 11:22:33AM +0000, John Garry wrote:
> Hi all,
> 
> Some guys internally upgraded to v5.10-rcX and start to see a hang after dd
> + sync for a large file:
> - mount /dev/sda1 (ext4 filesystem) to directory /mnt;
> - run "if=/dev/zero of=test1 bs=1M count=2000" on directory /mnt;
> - run "sync"
> 
> and get:
> 
> [  367.912761] INFO: task jbd2/sdb1-8:3602 blocked for more than 120
> seconds.
> [  367.919618]       Not tainted 5.10.0-rc1-109488-g32ded76956b6 #948
> [  367.925776] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  367.933579] task:jbd2/sdb1-8     state:D stack:    0 pid: 3602
> ppid:     2 flags:0x00000028
> [  367.941901] Call trace:
> [  367.944351] __switch_to+0xb8/0x168
> [  367.947840] __schedule+0x30c/0x670
> [  367.951326] schedule+0x70/0x108
> [  367.954550] io_schedule+0x1c/0xe8
> [  367.957948] bit_wait_io+0x18/0x68
> [  367.961346] __wait_on_bit+0x78/0xf0
> [  367.964919] out_of_line_wait_on_bit+0x8c/0xb0
> [  367.969356] __wait_on_buffer+0x30/0x40
> [  367.973188] jbd2_journal_commit_transaction+0x1370/0x1958
> [  367.978661] kjournald2+0xcc/0x260
> [  367.982061] kthread+0x150/0x158
> [  367.985288] ret_from_fork+0x10/0x34
> [  367.988860] INFO: task sync:3823 blocked for more than 120 seconds.
> [  367.995102]       Not tainted 5.10.0-rc1-109488-g32ded76956b6 #948
> [  368.001265] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  368.009067] task:sync            state:D stack:    0 pid: 3823 ppid:
> 3450 flags:0x00000009
> [  368.017397] Call trace:
> [  368.019841] __switch_to+0xb8/0x168
> [  368.023320] __schedule+0x30c/0x670
> [  368.026804] schedule+0x70/0x108
> [  368.030025] jbd2_log_wait_commit+0xbc/0x158
> [  368.034290] ext4_sync_fs+0x188/0x1c8
> [  368.037947] sync_fs_one_sb+0x30/0x40
> [  368.041606] iterate_supers+0x9c/0x138
> [  368.045350] ksys_sync+0x64/0xc0
> [  368.048569] __arm64_sys_sync+0x10/0x20
> [  368.052398] el0_svc_common.constprop.3+0x68/0x170
> [  368.057177] do_el0_svc+0x24/0x90
> [  368.060482] el0_sync_handler+0x118/0x168
> [  368.064478]  el0_sync+0x158/0x180
> 
> The issue was reported here originally:
> https://lore.kernel.org/linux-ext4/4d18326e-9ca2-d0cb-7cb8-cb56981280da@hisilicon.com/
> 
> But it looks like issue related to recent work for SCSI MQ.
> 
> They can only create with hisi_sas v3 hw. I could not create with megaraid
> sas on the same dev platform or hisi_sas on a similar dev board.
> 
> Reverting "scsi: core: Only re-run queue in scsi_end_request() if device
> queue is busy" seems solve the issue. Also, checking out to patch prior to
> "scsi: hisi_sas: Switch v3 hw to MQ" seems to not have the issue.

If the issue can be reproduced, you may try the following patch:

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 60c7a7d74852..f95bd0e5006e 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -602,6 +602,9 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
 
        __blk_mq_end_request(req, error);
 
+       if (unlikely(req->end_io))
+               smp_mb();
+
        scsi_run_queue_async(sdev);
 
        percpu_ref_put(&q->q_usage_counter);


Thanks, 
Ming

