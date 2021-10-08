Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A74CC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 10:15:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24F1161037
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 10:15:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239036AbhJHKRD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Oct 2021 06:17:03 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3945 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbhJHKRC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2021 06:17:02 -0400
Received: from fraeml735-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HQkW92w2xz67yBh;
        Fri,  8 Oct 2021 18:11:49 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml735-chm.china.huawei.com (10.206.15.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 8 Oct 2021 12:15:05 +0200
Received: from [10.47.80.141] (10.47.80.141) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Fri, 8 Oct 2021
 11:15:04 +0100
Subject: Re: [PATCH v5 00/14] blk-mq: Reduce static requests memory footprint
 for shared sbitmap
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Jens Axboe <axboe@kernel.dk>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ming.lei@redhat.com>, <hare@suse.de>, <linux-scsi@vger.kernel.org>
References: <1633429419-228500-1-git-send-email-john.garry@huawei.com>
 <ae33dde8-96e8-2978-5f32-c7e0a6136e8e@kernel.dk>
 <81d9e019-b730-221e-a8c0-f72a8422a2ec@huawei.com>
 <e4e92abbe9d52bcba6b8cc6c91c442cc@mail.gmail.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <8867352d-2107-1f8a-0f1c-ef73450bf256@huawei.com>
Date:   Fri, 8 Oct 2021 11:17:35 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <e4e92abbe9d52bcba6b8cc6c91c442cc@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.80.141]
X-ClientProxiedBy: lhreml744-chm.china.huawei.com (10.201.108.194) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 07/10/2021 21:31, Kashyap Desai wrote:
> Perf top data indicates lock contention in "blk_mq_find_and_get_req" call.
> 
> 1.31%     1.31%  kworker/57:1H-k  [kernel.vmlinux]
>       native_queued_spin_lock_slowpath
>       ret_from_fork
>       kthread
>       worker_thread
>       process_one_work
>       blk_mq_timeout_work
>       blk_mq_queue_tag_busy_iter
>       bt_iter
>       blk_mq_find_and_get_req
>       _raw_spin_lock_irqsave
>       native_queued_spin_lock_slowpath
> 
> 
> Kernel v5.14 Data -
> 
> %Node1 :  8.4 us, 31.2 sy,  0.0 ni, 43.7 id,  0.0 wa,  0.0 hi, 16.8 si,  0.0
> st
>       4.46%  [kernel]       [k] complete_cmd_fusion
>       3.69%  [kernel]       [k] megasas_build_and_issue_cmd_fusion
>       2.97%  [kernel]       [k] blk_mq_find_and_get_req
>       2.81%  [kernel]       [k] megasas_build_ldio_fusion
>       2.62%  [kernel]       [k] syscall_return_via_sysret
>       2.17%  [kernel]       [k] __entry_text_start
>       2.01%  [kernel]       [k] io_submit_one
>       1.87%  [kernel]       [k] scsi_queue_rq
>       1.77%  [kernel]       [k] native_queued_spin_lock_slowpath
>       1.76%  [kernel]       [k] scsi_complete
>       1.66%  [kernel]       [k] llist_reverse_order
>       1.63%  [kernel]       [k] _raw_spin_lock_irqsave
>       1.61%  [kernel]       [k] llist_add_batch
>       1.39%  [kernel]       [k] aio_complete_rw
>       1.37%  [kernel]       [k] read_tsc
>       1.07%  [kernel]       [k] blk_complete_reqs
>       1.07%  [kernel]       [k] native_irq_return_iret
>       1.04%  [kernel]       [k] __x86_indirect_thunk_rax
>       1.03%  fio            [.] __fio_gettime
>       1.00%  [kernel]       [k] flush_smp_call_function_queue
> 
> 
> Test #2: Three VDs (each VD consist of 8 SAS SSDs).
> (numactl -N 1 fio
> 3vd.fio --rw=randread --bs=4k --iodepth=32 --numjobs=8
> --ioscheduler=none/mq-deadline)
> 
> There is a performance regression but it is not due to this patch set.
> Kernel v5.11 gives 2.1M IOPs on mq-deadline but 5.15 (without this patchset)
> gives 1.8M IOPs.
> In this test I did not noticed CPU issue as mentioned in Test-1.
> 
> In general, I noticed host_busy is incorrect once I apply this patchset. It
> should not be more than can_queue, but sysfs host_busy value is very high
> when IOs are running. This issue is only after applying this patchset.
> 
> Is this patch set only change the behavior of <shared_host_tag> enabled
> driver ? Will there be any impact on mpi3mr driver ? I can test that as
> well.

I can see where the high value of host_busy is coming from in this 
series - we incorrectly re-iter the tags by #hw queues times in 
blk_mq_tagset_busy_iter() - d'oh.

Please try the below patch. I have looked at other places where we may 
have similar problems in looping the hw queue count for tagset->tags[], 
and they look ok. But I will double-check. I think that 
blk_mq_queue_tag_busy_iter() should be fine - Ming?

--->8----

 From e6ecaa6d624ebb903fa773ca2a2035300b4c55c5 Mon Sep 17 00:00:00 2001
From: John Garry <john.garry@huawei.com>
Date: Fri, 8 Oct 2021 10:55:11 +0100
Subject: [PATCH] blk-mq: Fix blk_mq_tagset_busy_iter() for shared tags

Since it is now possible for a tagset to share a single set of tags, the
iter function should not re-iter the tags for the count of hw queues in
that case. Rather it should just iter once.

Signed-off-by: John Garry <john.garry@huawei.com>

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 72a2724a4eee..ef888aab81b3 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -378,9 +378,15 @@ void blk_mq_all_tag_iter(struct blk_mq_tags *tags, 
busy_tag_iter_fn *fn,
  void blk_mq_tagset_busy_iter(struct blk_mq_tag_set *tagset,
  		busy_tag_iter_fn *fn, void *priv)
  {
+	int nr_hw_queues;
  	int i;

-	for (i = 0; i < tagset->nr_hw_queues; i++) {
+	if (blk_mq_is_shared_tags(tagset->flags))
+		nr_hw_queues = 1;
+	else
+		nr_hw_queues = tagset->nr_hw_queues;
+
+	for (i = 0; i < nr_hw_queues; i++) {
  		if (tagset->tags && tagset->tags[i])
  			__blk_mq_all_tag_iter(tagset->tags[i], fn, priv,
  					      BT_TAG_ITER_STARTED);

----8<----

Thanks,
john
