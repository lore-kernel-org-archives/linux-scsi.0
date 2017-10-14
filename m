From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V9 0/7] blk-mq-sched: improve sequential I/O performance
Date: Sat, 14 Oct 2017 13:23:27 +0800
Message-ID: <20171014052321.GA21519@ming.t460p>
References: <20171013180532.29304-1-ming.lei@redhat.com>
 <03fc0b94-8463-3f3d-9d75-be3e05d88987@kernel.dk>
 <95fe2831-12a9-3346-5fc7-9259ff988669@kernel.dk>
 <3598a2f6-6305-372c-36a3-7813cbe04a77@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38610 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751678AbdJNFXo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 14 Oct 2017 01:23:44 -0400
Content-Disposition: inline
In-Reply-To: <3598a2f6-6305-372c-36a3-7813cbe04a77@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, Paolo Valente <paolo.valente@linaro.org>, Oleksandr Natalenko <oleksandr@natalenko.name>, Tom Nguyen <tom81094@gmail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Omar Sandoval <osandov@fb.com>, John Garry <john.garry@huawei.com>

On Fri, Oct 13, 2017 at 02:23:07PM -0600, Jens Axboe wrote:
> On 10/13/2017 01:21 PM, Jens Axboe wrote:
> > On 10/13/2017 01:08 PM, Jens Axboe wrote:
> >> On 10/13/2017 12:05 PM, Ming Lei wrote:
> >>> Hi Jens,
> >>>
> >>> In Red Hat internal storage test wrt. blk-mq scheduler, we found that I/O
> >>> performance is much bad with mq-deadline, especially about sequential I/O
> >>> on some multi-queue SCSI devcies(lpfc, qla2xxx, SRP...)
> >>>
> >>> Turns out one big issue causes the performance regression: requests are
> >>> still dequeued from sw queue/scheduler queue even when ldd's queue is
> >>> busy, so I/O merge becomes quite difficult to make, then sequential IO
> >>> performance degrades a lot.
> >>>
> >>> This issue becomes one of mains reasons for reverting default SCSI_MQ
> >>> in V4.13.
> >>>
> >>> This 8 patches improve this situation, and brings back performance loss.
> >>>
> >>> With this change, SCSI-MQ sequential I/O performance is improved much, Paolo
> >>> reported that mq-deadline performance improved much[2] in his dbench test
> >>> wrt V2. Also performance improvement on lpfc/qla2xx was observed with V1.[1]
> >>>
> >>> [1] http://marc.info/?l=linux-block&m=150151989915776&w=2
> >>> [2] https://marc.info/?l=linux-block&m=150217980602843&w=2
> >>
> >> I wanted to run some sanity testing on this series before committing it,
> >> and unfortunately it doesn't even boot for me. Just hangs after loading
> >> the kernel. Maybe an error slipped in for v8/9?
> > 
> > Or it might be something with kyber, my laptop defaults to that. Test
> > box seems to boot (which is SCSI), and nvme loads fine by default,
> > but not with kyber.
> > 
> > I don't have time to look into this more today, but the above might
> > help you figure out what is going on.
> 
> Verified that the laptop boots just fine if I remove the kyber udev
> rule.

I can reproduce this issue with kyber switched to, and will figure out
it soon.

-- 
Ming
