From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V5 00/14] blk-mq-sched: improve sequential I/O
 performance(part 1)
Date: Tue, 10 Oct 2017 09:46:58 +0800
Message-ID: <20171010014653.GA3247@ming.t460p>
References: <20170930102720.30219-1-ming.lei@redhat.com>
 <1e56f7e1-2a2f-26c9-9c74-97e0d22bc98b@huawei.com>
 <20171009150439.GA30189@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171009150439.GA30189@ming.t460p>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, Paolo Valente <paolo.valente@linaro.org>, Oleksandr Natalenko <oleksandr@natalenko.name>, Tom Nguyen <tom81094@gmail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Omar Sandoval <osandov@fb.com>, Linuxarm <linuxarm@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 09, 2017 at 11:04:39PM +0800, Ming Lei wrote:
> Hi John,
> 
> On Mon, Oct 09, 2017 at 01:09:22PM +0100, John Garry wrote:
> > On 30/09/2017 11:27, Ming Lei wrote:
> > > Hi Jens,
> > > 
> > > In Red Hat internal storage test wrt. blk-mq scheduler, we
> > > found that I/O performance is much bad with mq-deadline, especially
> > > about sequential I/O on some multi-queue SCSI devcies(lpfc, qla2xxx,
> > > SRP...)
> > > 
> > > Turns out one big issue causes the performance regression: requests
> > > are still dequeued from sw queue/scheduler queue even when ldd's
> > > queue is busy, so I/O merge becomes quite difficult to make, then
> > > sequential IO degrades a lot.
> > > 
> > > This issue becomes one of mains reasons for reverting default SCSI_MQ
> > > in V4.13.
> > > 
> > > The 1st patch takes direct issue in blk_mq_request_bypass_insert(),
> > > then we can improve dm-mpath's performance in part 2, which will
> > > be posted out soon.
> > > 
> > > The 2nd six patches improve this situation, and brings back
> > > some performance loss.
> > > 
> > > With this change, SCSI-MQ sequential I/O performance is
> > > improved much, Paolo reported that mq-deadline performance
> > > improved much[2] in his dbench test wrt V2. Also performanc
> > > improvement on lpfc/qla2xx was observed with V1.[1]
> > > 
> > > Please consider it for V4.15.
> > > 
> > > [1] http://marc.info/?l=linux-block&m=150151989915776&w=2
> > > [2] https://marc.info/?l=linux-block&m=150217980602843&w=2
> > > 
> > 
> > I tested this series for the SAS controller on HiSilicon hip07 platform as I
> > am interested in enabling MQ for this driver. Driver is
> > ./drivers/scsi/hisi_sas/.
> > 
> > So I found that that performance is improved when enabling default SCSI_MQ
> > with this series vs baseline. However, it is still not as a good as when
> > default SCSI_MQ is disabled.
> > 
> > Here are some figures I got with fio:
> > 4.14-rc2 without default SCSI_MQ
> > read, rw, write IOPS	
> > 952K, 133K/133K, 800K
> > 
> > 4.14-rc2 with default SCSI_MQ
> > read, rw, write IOPS	
> > 311K, 117K/117K, 320K
> > 
> > This series* without default SCSI_MQ
> > read, rw, write IOPS	
> > 975K, 132K/132K, 790K
> > 
> > This series* with default SCSI_MQ
> > read, rw, write IOPS	
> > 770K, 164K/164K, 594K
> 
> Thanks for testing this patchset!
> 
> Looks there is big improvement, but the gap compared with
> block legacy is not small too.
> 
> > 
> > Please note that hisi_sas driver does not enable mq by exposing multiple
> > queues to upper layer (even though it has multiple queues). I have been
> > playing with enabling it, but my performance is always worse...
> > 
> > * I'm using
> > https://github.com/ming1/linux/commits/blk_mq_improve_scsi_mpath_perf_V5.1,
> > as advised by Ming Lei.
> 
> Could you test on the following branch and see if it makes a
> difference?
> 
> 	https://github.com/ming1/linux/commits/blk_mq_improve_scsi_mpath_perf_V6.1_test

Hi John,

Please test the following branch directly:

https://github.com/ming1/linux/tree/blk_mq_improve_scsi_mpath_perf_V6.2_test

And code is simplified and cleaned up much in V6.2, then only two extra
patches(top 2) are needed against V6 which was posted yesterday.

Please test SCSI_MQ with mq-deadline, which should be the default
mq scheduler on your HiSilicon SAS.

-- 
Ming
