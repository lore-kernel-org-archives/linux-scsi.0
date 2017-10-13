From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH V9 0/7] blk-mq-sched: improve sequential I/O performance
Date: Fri, 13 Oct 2017 13:08:46 -0600
Message-ID: <03fc0b94-8463-3f3d-9d75-be3e05d88987@kernel.dk>
References: <20171013180532.29304-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171013180532.29304-1-ming.lei@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, Paolo Valente <paolo.valente@linaro.org>, Oleksandr Natalenko <oleksandr@natalenko.name>, Tom Nguyen <tom81094@gmail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Omar Sandoval <osandov@fb.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On 10/13/2017 12:05 PM, Ming Lei wrote:
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
> 
> [1] http://marc.info/?l=linux-block&m=150151989915776&w=2
> [2] https://marc.info/?l=linux-block&m=150217980602843&w=2

I wanted to run some sanity testing on this series before committing it,
and unfortunately it doesn't even boot for me. Just hangs after loading
the kernel. Maybe an error slipped in for v8/9?

-- 
Jens Axboe
