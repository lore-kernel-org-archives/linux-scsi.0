From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH V5 00/14] blk-mq-sched: improve sequential I/O
 performance(part 1)
Date: Tue, 10 Oct 2017 16:10:54 +0100
Message-ID: <e31eefb6-56ed-d75b-f52e-641beb09d203@huawei.com>
References: <20170930102720.30219-1-ming.lei@redhat.com>
 <1e56f7e1-2a2f-26c9-9c74-97e0d22bc98b@huawei.com>
 <20171009150439.GA30189@ming.t460p> <20171010014653.GA3247@ming.t460p>
 <cb622a02-5187-5ee0-bccd-e867e8e7ee7d@huawei.com>
 <20171010134519.GA20770@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171010134519.GA20770@ming.t460p>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, Paolo Valente <paolo.valente@linaro.org>, Oleksandr Natalenko <oleksandr@natalenko.name>, Tom Nguyen <tom81094@gmail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Omar Sandoval <osandov@fb.com>, Linuxarm <linuxarm@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On 10/10/2017 14:45, Ming Lei wrote:
> Hi John,
>
> All change in V6.2 is blk-mq/scsi-mq only, which shouldn't
> affect non SCSI_MQ, so I suggest you to compare the perf
> between deadline and mq-deadline, like Johannes mentioned.
>
>> >
>> > V6.2 series with default SCSI_MQ
>> > read, rw, write IOPS	
>> > 700K, 130K/128K, 640K
> If possible, could you provide your fio script and log on both
> non SCSI_MQ(deadline) and SCSI_MQ(mq_deadline)? Maybe some clues
> can be figured out.
>
> Also, I just put another patch on V6.2 branch, which may improve
> a bit too. You may try that in your test.
>
> 	https://github.com/ming1/linux/commit/e31e2eec46c9b5ae7cfa181e9b77adad2c6a97ce
>
> -- Ming .

Hi Ming Lei,

OK, I have tested deadline vs mq-deadline for your v6.2 branch and 
4.12-rc2. Unfortunately I don't have time now to test your experimental 
patches.

4.14-rc2 without default SCSI_MQ, deadline scheduler
read, rw, write IOPS	
920K, 115K/115K, 806K

4.14-rc2 with default SCSI_MQ, mq-deadline scheduler
read, rw, write IOPS	
280K, 99K/99K, 300K

V6.2 series without default SCSI_MQ, deadline scheduler
read, rw, write IOPS	
919K, 117K/117K, 806K

V6.2 series with default SCSI_MQ, mq-deadline scheduler
read, rw, write IOPS	
688K, 128K/128K, 630K

I think that the non-mq results look a bit more sensible - that is, 
consistent results.

Here's my script sample:
[global]
rw=rW
direct=1
ioengine=libaio
iodepth=2048
numjobs=1
bs=4k
;size=10240000m
;zero_buffers=1
group_reporting=1
group_reporting=1
;ioscheduler=noop
cpumask=0xff
;cpus_allowed=0-3
;gtod_reduce=1
;iodepth_batch=2
;iodepth_batch_complete=2
runtime=100000000
;thread
loops = 10000

[job1]
filename=/dev/sdb:
[job1]
filename=/dev/sdc:
[job1]
filename=/dev/sdd:
[job1]
filename=/dev/sde:
[job1]
filename=/dev/sdf:
[job1]
filename=/dev/sdg:

John
