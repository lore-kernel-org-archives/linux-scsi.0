From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 0/5] blk-mq/scsi-mq: support global tags & introduce
 force_blk_mq
Date: Wed, 7 Feb 2018 20:23:02 +0800
Message-ID: <20180207122257.GA16633@ming.t460p>
References: <20180203042112.15239-1-ming.lei@redhat.com>
 <07c1f41e-de7c-5e3d-1a2d-0cd7af7b46df@suse.de>
 <528c93de0aac9010e274847ab1ae0328@mail.gmail.com>
 <20180205101734.GA32558@ming.t460p>
 <4c8162129f2a09dca2d1e7eefd61e272@mail.gmail.com>
 <20180206080452.GA14651@ming.t460p>
 <b0b6dae90e4525f91459d450c01c4204@mail.gmail.com>
 <20180206123148.GA29378@ming.t460p>
 <8cf1036167ec5fb58c1d2f70bbb0b678@mail.gmail.com>
 <4c934478-a9c1-2f66-83f2-982b85c4e6cc@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4c934478-a9c1-2f66-83f2-982b85c4e6cc@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org, Arun Easi <arun.easi@cavium.com>, Omar Sandoval <osandov@fb.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Don Brace <don.brace@microsemi.com>, Peter Rivera <peter.rivera@broadcom.com>, Paolo Bonzini <pbonzini@redhat.com>, Laurence Oberman <loberman@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Feb 07, 2018 at 07:50:21AM +0100, Hannes Reinecke wrote:
> Hi all,
> 
> [ .. ]
> >>
> >> Could you share us your patch for enabling global_tags/MQ on
> > megaraid_sas
> >> so that I can reproduce your test?
> >>
> >>> See below perf top data. "bt_iter" is consuming 4 times more CPU.
> >>
> >> Could you share us what the IOPS/CPU utilization effect is after
> > applying the
> >> patch V2? And your test script?
> > Regarding CPU utilization, I need to test one more time. Currently system
> > is in used.
> > 
> > I run below fio test on total 24 SSDs expander attached.
> > 
> > numactl -N 1 fio jbod.fio --rw=randread --iodepth=64 --bs=4k
> > --ioengine=libaio --rw=randread
> > 
> > Performance dropped from 1.6 M IOPs to 770K IOPs.
> > 
> This is basically what we've seen with earlier iterations.

Hi Hannes,

As I mentioned in another mail[1], Kashyap's patch has a big issue, which
causes only reply queue 0 used.

[1] https://marc.info/?l=linux-scsi&m=151793204014631&w=2

So could you guys run your performance test again after fixing the patch?


Thanks,
Ming
