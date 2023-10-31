Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5E2AC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Oct 2023 02:02:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjJaCCF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Oct 2023 22:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjJaCCE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Oct 2023 22:02:04 -0400
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1874DD;
        Mon, 30 Oct 2023 19:02:01 -0700 (PDT)
Received: from mail.maildlp.com (unknown [172.19.163.235])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4SKD0M5Zjrz4f3mWP;
        Tue, 31 Oct 2023 10:01:55 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
        by mail.maildlp.com (Postfix) with ESMTP id D51831A0173;
        Tue, 31 Oct 2023 10:01:57 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgAnt9YUYEBldjmoEQ--.61295S3;
        Tue, 31 Oct 2023 10:01:57 +0800 (CST)
Subject: Re: [PATCH v4 0/3] Support disabling fair tag sharing
To:     Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "yukuai (C)" <yukuai3@huawei.com>
References: <20231023203643.3209592-1-bvanassche@acm.org>
 <ZTcr3AHr9l4sHRO2@fedora> <5d37f5ed-130a-4e75-b9a7-f77aeb4c7c89@acm.org>
 <ZThwdPaeAFmhp58L@fedora> <faf6f9e4-e1fe-4934-8fdf-84383f51e740@acm.org>
 <ZTmm0kNdN2Eka6V6@fedora> <1e53e562-bec2-4261-a704-88d2a64111d3@acm.org>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <a6575723-4903-d098-6be0-722635db1339@huaweicloud.com>
Date:   Tue, 31 Oct 2023 10:01:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1e53e562-bec2-4261-a704-88d2a64111d3@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgAnt9YUYEBldjmoEQ--.61295S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Kw4rZF43WryrGF4DJrWrKrg_yoW8XrW8pr
        W7WF4DKan5ZanFkw4vy3y7XryrJ3yrG3y7Jryftryj9ws8G3ySyr4jqan09FWYkrs5Aw1q
        v3W8Jw1Dur4qvFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUyKb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
        0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
        x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
        0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0E
        wIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E74
        80Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0
        I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04
        k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY
        1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUrR6zUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

在 2023/10/27 0:29, Bart Van Assche 写道:
> If blk_mq_get_tag() can't allocate a tag, and if multiple threads are
> waiting for a tag, the thread that called blk_mq_get_tag() first is
> granted the first tag that is released. I think this guarantees fairness
> if all requests have a similar latency. There will be some unfairness if
> there are significant differences in latency per logical unit, e.g.
> because all requests sent to one logical unit are small and because all
> requests sent to another logical unit are large. Whether or not this
> matters depends on the use case.

I'm afraid that is not correct, fairness can't be guranteed at all, not
even with just one scsi disk. This is because there are 8 wait queues in
sbitmap, and threads are waiting in roundrobin mode, and each time
wake_batch tags are released, wake_batch threads of one wait queue will
be woke up, regardless that some threads can't grab tag after woken up,
what's worse, thoese thread will be added to the tail of waitqueue
again.

In the case that high io pressure under a slow disk, this behaviour will
cause that io tail latency will be quite bad compared to sq from old
kernel.

AFAIC, disable tag sharing will definitely case some regresion, for
example, one disk will high io pressure, and another disk only issure
one IO at a time, disable tag sharing can improve brandwith of fist
disk, however, for the latter disk, IO latency will definitely be much
worse.

Thanks,
Kuai

> 
> Thanks,
> 
> Bart.
> 
> 
> 
> .
> 

