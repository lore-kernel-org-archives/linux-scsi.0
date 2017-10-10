From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V5 00/14] blk-mq-sched: improve sequential I/O
 performance(part 1)
Date: Tue, 10 Oct 2017 21:45:25 +0800
Message-ID: <20171010134519.GA20770@ming.t460p>
References: <20170930102720.30219-1-ming.lei@redhat.com>
 <1e56f7e1-2a2f-26c9-9c74-97e0d22bc98b@huawei.com>
 <20171009150439.GA30189@ming.t460p>
 <20171010014653.GA3247@ming.t460p>
 <cb622a02-5187-5ee0-bccd-e867e8e7ee7d@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cb622a02-5187-5ee0-bccd-e867e8e7ee7d@huawei.com>
Sender: linux-block-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, Paolo Valente <paolo.valente@linaro.org>, Oleksandr Natalenko <oleksandr@natalenko.name>, Tom Nguyen <tom81094@gmail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Omar Sandoval <osandov@fb.com>, Linuxarm <linuxarm@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 10, 2017 at 01:24:52PM +0100, John Garry wrote:
> On 10/10/2017 02:46, Ming Lei wrote:
> > > > > > I tested this series for the SAS controller on HiSilicon hip07 platform as I
> > > > > > am interested in enabling MQ for this driver. Driver is
> > > > > > ./drivers/scsi/hisi_sas/.
> > > > > >
> > > > > > So I found that that performance is improved when enabling default SCSI_MQ
> > > > > > with this series vs baseline. However, it is still not as a good as when
> > > > > > default SCSI_MQ is disabled.
> > > > > >
> > > > > > Here are some figures I got with fio:
> > > > > > 4.14-rc2 without default SCSI_MQ
> > > > > > read, rw, write IOPS	
> > > > > > 952K, 133K/133K, 800K
> > > > > >
> > > > > > 4.14-rc2 with default SCSI_MQ
> > > > > > read, rw, write IOPS	
> > > > > > 311K, 117K/117K, 320K
> > > > > >
> > > > > > This series* without default SCSI_MQ
> > > > > > read, rw, write IOPS	
> > > > > > 975K, 132K/132K, 790K
> > > > > >
> > > > > > This series* with default SCSI_MQ
> > > > > > read, rw, write IOPS	
> > > > > > 770K, 164K/164K, 594K
> > > >
> > > > Thanks for testing this patchset!
> > > >
> > > > Looks there is big improvement, but the gap compared with
> > > > block legacy is not small too.
> > > >
> > > > > >
> > > > > > Please note that hisi_sas driver does not enable mq by exposing multiple
> > > > > > queues to upper layer (even though it has multiple queues). I have been
> > > > > > playing with enabling it, but my performance is always worse...
> > > > > >
> > > > > > * I'm using
> > > > > > https://github.com/ming1/linux/commits/blk_mq_improve_scsi_mpath_perf_V5.1,
> > > > > > as advised by Ming Lei.
> > > >
> > > > Could you test on the following branch and see if it makes a
> > > > difference?
> > > >
> > > > 	https://github.com/ming1/linux/commits/blk_mq_improve_scsi_mpath_perf_V6.1_test
> > Hi John,
> > 
> > Please test the following branch directly:
> > 
> > https://github.com/ming1/linux/tree/blk_mq_improve_scsi_mpath_perf_V6.2_test
> > 
> > And code is simplified and cleaned up much in V6.2, then only two extra
> > patches(top 2) are needed against V6 which was posted yesterday.
> > 
> > Please test SCSI_MQ with mq-deadline, which should be the default
> > mq scheduler on your HiSilicon SAS.
> 
> Hi Ming Lei,
> 
> It's using cfq (for non-mq) and mq-deadline (obviously for mq).
> 
> root@(none)$ pwd
> /sys/devices/platform/HISI0162:01/host0/port-0:0/expander-0:0/port-0:0:7/end_device-0:0:7
> root@(none)$ more ./target0:0:3/0:0:3:0/block/sdd/queue/scheduler
> noop [cfq]
> 
> and
> 
> root@(none)$ more ./target0:0:3/0:0:3:0/block/sdd/queue/scheduler
> [mq-deadline] kyber none
> 
> Unfortunately my setup has changed since yeterday, and the absolute figures
> are not the exact same (I retested 4.14-rc2). However, we still see that
> drop when mq is enabled.
> 
> Here's the results:
> 4.14-rc4 without default SCSI_MQ
> read, rw, write IOPS	
> 860K, 112K/112K, 800K
> 
> 4.14-rc2 without default SCSI_MQ
> read, rw, write IOPS	
> 880K, 113K/113K, 808K
> 
> V6.2 series without default SCSI_MQ
> read, rw, write IOPS	
> 820K, 114/114K, 790K

Hi John,

All change in V6.2 is blk-mq/scsi-mq only, which shouldn't
affect non SCSI_MQ, so I suggest you to compare the perf
between deadline and mq-deadline, like Johannes mentioned.

> 
> V6.2 series with default SCSI_MQ
> read, rw, write IOPS	
> 700K, 130K/128K, 640K

If possible, could you provide your fio script and log on both
non SCSI_MQ(deadline) and SCSI_MQ(mq_deadline)? Maybe some clues
can be figured out.

Also, I just put another patch on V6.2 branch, which may improve
a bit too. You may try that in your test.

	https://github.com/ming1/linux/commit/e31e2eec46c9b5ae7cfa181e9b77adad2c6a97ce

-- 
Ming
