Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB607E8FDC6
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Oct 2023 03:42:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbjJDDmM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Oct 2023 23:42:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbjJDDmM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Oct 2023 23:42:12 -0400
Received: from out-207.mta0.migadu.com (out-207.mta0.migadu.com [IPv6:2001:41d0:1004:224b::cf])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B994DA9
        for <linux-scsi@vger.kernel.org>; Tue,  3 Oct 2023 20:42:08 -0700 (PDT)
Message-ID: <2fcef3c8-808e-8e6a-b23d-9f1b3f98c1f9@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1696390925;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DWTwkkFRGjvuCbu2qw8R41rNgetDuelLeU3tWzW8MFg=;
        b=cndYhDK84SaKAfdlCvLG76VmZBdpiqM00hhfI35SyZCZMC1b/egrGzLOTkINeyNi8yoVOT
        cTzAUW8d3WXR0e21WZfPk0QZtn7IkTsPxMgr1nVwpiYa3yyYZoOIY88gSOecdMEk5VSR5U
        YyjFrqzu0GB5NOhxc2san1QZArJzkEw=
Date:   Wed, 4 Oct 2023 11:41:51 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/1] Revert "RDMA/rxe: Add workqueue support for rxe
 tasks"
To:     Bart Van Assche <bvanassche@acm.org>,
        Bob Pearson <rpearsonhpe@gmail.com>,
        Leon Romanovsky <leon@kernel.org>, zyjzyj2000@gmail.com,
        jgg@ziepe.ca, linux-rdma@vger.kernel.org,
        matsuda-daisuke@fujitsu.com, shinichiro.kawasaki@wdc.com,
        linux-scsi@vger.kernel.org, Zhu Yanjun <yanjun.zhu@intel.com>
References: <20230922163231.2237811-1-yanjun.zhu@intel.com>
 <169572143704.2702191.3921040309512111011.b4-ty@kernel.org>
 <20230926140656.GM1642130@unreal>
 <d3c05064-a88b-4719-a390-6bf9ae01fba5@acm.org>
 <b7b365e3-dd11-bc66-dace-05478766bf41@gmail.com>
 <2d5e02d7-cf84-4170-b1a3-a65316ac84ee@acm.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <2d5e02d7-cf84-4170-b1a3-a65316ac84ee@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

在 2023/9/27 4:24, Bart Van Assche 写道:
> On 9/26/23 11:34, Bob Pearson wrote:
>> I am working to try to reproduce the KASAN warning. Unfortunately,
>> so far I am not able to see it in Ubuntu + Linus' kernel (as you 
>> described) on metal. The config file is different but copies the 
>> CONFIG_KASAN_xxx exactly as yours. With KASAN enabled it hangs on 
>> every iteration of srp/002 but without a KASAN warning. I am now 
>> building an openSuSE VM for qemu and will see if that causes the warning.
> 
> Hi Bob,
> 
> Did you try to understand the report that I shared? My conclusion from
> the report is that when using tasklets rxe_completer() only runs after
> rxe_requester() has finished and also that when using work queues that
> rxe_completer() may run concurrently with rxe_requester(). This patch
> seems to fix all issues that I ran into with the rdma_rxe workqueue
> patch (I have not tried to verify the performance implications of this
> patch):
> 
> diff --git a/drivers/infiniband/sw/rxe/rxe_task.c 
> b/drivers/infiniband/sw/rxe/rxe_task.c
> index 1501120d4f52..6cd5d5a7a316 100644
> --- a/drivers/infiniband/sw/rxe/rxe_task.c
> +++ b/drivers/infiniband/sw/rxe/rxe_task.c
> @@ -10,7 +10,7 @@ static struct workqueue_struct *rxe_wq;
> 
>   int rxe_alloc_wq(void)
>   {
> -       rxe_wq = alloc_workqueue("rxe_wq", WQ_UNBOUND, WQ_MAX_ACTIVE);
> +       rxe_wq = alloc_workqueue("rxe_wq", WQ_UNBOUND, 1);
>          if (!rxe_wq)
>                  return -ENOMEM;

Hi, Bart

With the above commit, I still found a similar problem. But the problem 
occurs very rarely. With the following, to now, the problem does not occur.

diff --git a/drivers/infiniband/sw/rxe/rxe_task.c 
b/drivers/infiniband/sw/rxe/rxe_task.c
index 1501120d4f52..3189c3705295 100644
--- a/drivers/infiniband/sw/rxe/rxe_task.c
+++ b/drivers/infiniband/sw/rxe/rxe_task.c
@@ -10,7 +10,7 @@ static struct workqueue_struct *rxe_wq;

  int rxe_alloc_wq(void)
  {
-       rxe_wq = alloc_workqueue("rxe_wq", WQ_UNBOUND, WQ_MAX_ACTIVE);
+       rxe_wq = alloc_workqueue("rxe_wq", WQ_HIGHPRI | WQ_UNBOUND, 1);
         if (!rxe_wq)
                 return -ENOMEM;


And with the tasklet, this problem also does not occur.

With "alloc_workqueue("rxe_wq", WQ_HIGHPRI | WQ_UNBOUND, 1);", an 
ordered workqueue with high priority is allocated.

To the same number of work item, the ordered workqueue has the same 
runing time with the tasklet. But the tasklet is based on softirq. Its 
overhead on scheduling is less than workqueue. So in theory, tasklet's 
performance should be better than the ordered workqueue.

Best Regards,
Zhu Yanjun

> 
> Thanks,
> 
> Bart.

