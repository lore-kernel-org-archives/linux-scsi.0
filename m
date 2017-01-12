From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [LSF/MM TOPIC][LSF/MM ATTEND] NAPI polling for block drivers
Date: Thu, 12 Jan 2017 13:44:05 +0200
Message-ID: <879a91ba-eff7-682d-12a9-5d83f26e7e09@grimberg.me>
References: <20170111134312.GH6286@linux-x5ow.site>
 <cc00cc1f-17d7-105e-ef2c-61791b7cc676@kernel.dk>
 <d60d4499-6ed8-0a69-edbf-db205a6dba6a@kernel.dk>
 <8b47ca34-d2ff-26dc-721e-2cb1e18f1efc@grimberg.me>
 <20170112100251.GB3598@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170112100251.GB3598@linux-x5ow.site>
Sender: linux-block-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Keith Busch <keith.busch@intel.com>, linux-nvme@lists.infradead.org, Linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


>> I agree with Jens that we'll need some analysis if we want the
>> discussion to be affective, and I can spend some time this if I
>> can find volunteers with high-end nvme devices (I only have access
>> to client nvme devices.
>
> I have a P3700 but somehow burned the FW. Let me see if I can bring it back to
> live.
>
> I also have converted AHCI to the irq_poll interface and will run some tests.
> I do also have some hpsa devices on which I could run tests once the driver is
> adopted.
>
> But can we come to a common testing methology not to compare apples with
> oranges? Sagi do you still have the fio job file from your last tests laying
> somewhere and if yes could you share it?

Its pretty basic:
--
[global]
group_reporting
cpus_allowed=0
cpus_allowed_policy=split
rw=randrw
bs=4k
numjobs=4
iodepth=32
runtime=60
time_based
loops=1
ioengine=libaio
direct=1
invalidate=1
randrepeat=1
norandommap
exitall

[job]
--

**Note: when I ran multiple threads on more cpus the performance
degradation phenomenon disappeared, but I tested on a VM with
qemu emulation backed by null_blk so I figured I had some other
bottleneck somewhere (that's why I asked for some more testing).

Note that I ran randrw because I was backed with null_blk, testing
with a real nvme device, you should either run randread or write, and
if you do a write, you can't run it multi-threaded (well you can, but
you'll get unpredictable performance...).
