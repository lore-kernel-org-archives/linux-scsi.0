From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH V10 0/8] blk-mq-sched: improve sequential I/O performance
Date: Sat, 14 Oct 2017 09:39:21 -0600
Message-ID: <1c643ef1-26d8-3fa4-2b65-7e299e6a5ceb@kernel.dk>
References: <20171014092232.13943-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f52.google.com ([74.125.83.52]:56326 "EHLO
        mail-pg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753846AbdJNPj1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Oct 2017 11:39:27 -0400
Received: by mail-pg0-f52.google.com with SMTP id m18so3482982pgd.13
        for <linux-scsi@vger.kernel.org>; Sat, 14 Oct 2017 08:39:26 -0700 (PDT)
In-Reply-To: <20171014092232.13943-1-ming.lei@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, Paolo Valente <paolo.valente@linaro.org>, Oleksandr Natalenko <oleksandr@natalenko.name>, Tom Nguyen <tom81094@gmail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Omar Sandoval <osandov@fb.com>, John Garry <john.garry@huawei.com>

On 10/14/2017 03:22 AM, Ming Lei wrote:
> Hi Jens,
> 
> In Red Hat internal storage test wrt. blk-mq scheduler, we found that I/O
> performance is much bad with mq-deadline, especially about sequential I/O
> on some multi-queue SCSI devcies(lpfc, qla2xxx, SRP...)
> 
> Turns out one big issue causes the performance regression: requests are
> still dequeued from sw queue/scheduler queue even when ldd's queue is
> busy, so I/O merge becomes quite difficult to make, then sequential IO
> performance degrades a lot.
> 
> This issue becomes one of mains reasons for reverting default SCSI_MQ
> in V4.13.
> 
> This 8 patches improve this situation, and brings back performance loss.
> 
> With this change, SCSI-MQ sequential I/O performance is improved much, Paolo
> reported that mq-deadline performance improved much[2] in his dbench test
> wrt V2. Also performance improvement on lpfc/qla2xx was observed with V1.[1]

Looks good to me, and the kyber fix looks obviously correct to me. I have
applied this series for 4.15. Thanks Ming.

-- 
Jens Axboe
