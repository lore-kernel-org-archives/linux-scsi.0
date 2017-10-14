From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V10 0/8] blk-mq-sched: improve sequential I/O performance
Date: Sun, 15 Oct 2017 07:17:46 +0800
Message-ID: <20171014231744.GB17485@ming.t460p>
References: <20171014092232.13943-1-ming.lei@redhat.com>
 <1c643ef1-26d8-3fa4-2b65-7e299e6a5ceb@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1c643ef1-26d8-3fa4-2b65-7e299e6a5ceb@kernel.dk>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, Paolo Valente <paolo.valente@linaro.org>, Oleksandr Natalenko <oleksandr@natalenko.name>, Tom Nguyen <tom81094@gmail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Omar Sandoval <osandov@fb.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, Oct 14, 2017 at 09:39:21AM -0600, Jens Axboe wrote:
> On 10/14/2017 03:22 AM, Ming Lei wrote:
> > Hi Jens,
> > 
> > In Red Hat internal storage test wrt. blk-mq scheduler, we found that I/O
> > performance is much bad with mq-deadline, especially about sequential I/O
> > on some multi-queue SCSI devcies(lpfc, qla2xxx, SRP...)
> > 
> > Turns out one big issue causes the performance regression: requests are
> > still dequeued from sw queue/scheduler queue even when ldd's queue is
> > busy, so I/O merge becomes quite difficult to make, then sequential IO
> > performance degrades a lot.
> > 
> > This issue becomes one of mains reasons for reverting default SCSI_MQ
> > in V4.13.
> > 
> > This 8 patches improve this situation, and brings back performance loss.
> > 
> > With this change, SCSI-MQ sequential I/O performance is improved much, Paolo
> > reported that mq-deadline performance improved much[2] in his dbench test
> > wrt V2. Also performance improvement on lpfc/qla2xx was observed with V1.[1]
> 
> Looks good to me, and the kyber fix looks obviously correct to me. I have
> applied this series for 4.15. Thanks Ming.

That is great, thanks for making this patchset in!

-- 
Ming
