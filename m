From: Jens Axboe <axboe@fb.com>
Subject: Re: [lkp-robot] [scsi, block] 0dba1314d4:
 WARNING:at_fs/sysfs/dir.c:#sysfs_warn_dup
Date: Mon, 6 Feb 2017 21:09:48 -0700
Message-ID: <01c338e2-2a30-610d-b7fa-00cb3ce2cf86@fb.com>
References: <20170204070936.GE12121@yexl-desktop>
 <CAPcyv4j0syAsinM-KbeefKysJhM9zt6kvrX=0c2HrtPV_tRAHQ@mail.gmail.com>
 <CAPcyv4gBQDuj65KRmFvP2q4Qt3d3xycM8L_TypAzYkvhmUSh6A@mail.gmail.com>
 <20170205091314.GA3042@lst.de>
 <CAPcyv4gE0+3pZQV=V75wxddFVhWeAz1abfJ=q8D1Zi+8Oi17rA@mail.gmail.com>
 <1486426467.2474.122.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1486426467.2474.122.camel@HansenPartnership.com>
Sender: linux-block-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Dan Williams <dan.j.williams@intel.com>, Christoph Hellwig <hch@lst.de>
Cc: kernel test robot <xiaolong.ye@intel.com>, Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jan Kara <jack@suse.cz>, Omar Sandoval <osandov@osandov.com>, Omar Sandoval <osandov@fb.com>, LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, LKP <lkp@01.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 02/06/2017 05:14 PM, James Bottomley wrote:
> On Sun, 2017-02-05 at 21:13 -0800, Dan Williams wrote:
>> On Sun, Feb 5, 2017 at 1:13 AM, Christoph Hellwig <hch@lst.de> wrote:
>>> Dan,
>>>
>>> can you please quote your emails?  I can't find any content 
>>> inbetween all these quotes.
>>
>> Sorry, I'm using gmail, but I'll switch to attaching the logs.
>>
>> So with help from Xiaolong I was able to reproduce this, and it does
>> not appear to be a regression. We simply change the failure output of
>> an existing bug. Attached is a log of the same test on v4.10-rc7 
>> (i.e. without the recent block/scsi fixes), and it shows sda being
>> registered twice.
>>
>> "[    6.647077] kobject (d5078ca4): tried to init an initialized
>> object, something is seriously wrong."
>>
>> The change that "scsi, block: fix duplicate bdi name registration
>> crashes" makes is to properly try to register sdb since the sda devt
>> is still alive. However that's not a fix because we've managed to 
>> call blk_register_queue() twice on the same queue.
> 
> OK, time to involve others: linux-scsi and linux-block cc'd and I've
> inserted the log below.
> 
> James
> 
> ---
> 
> [    5.969672] scsi host0: scsi_debug: version 1.86 [20160430]
> [    5.969672]   dev_size_mb=8, opts=0x0, submit_queues=1, statistics=0
> [    5.971895] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       0186 PQ: 0 ANSI: 7
> [    6.006983] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.39 MB/8.00 MiB)
> [    6.026965] sd 0:0:0:0: [sda] Write Protect is off
> [    6.027870] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
> [    6.066962] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
> [    6.486962] sd 0:0:0:0: [sda] Attached SCSI disk
> [    6.488377] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> [    6.489455] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [    6.526982] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.39 MB/8.00 MiB)
> [    6.546964] sd 0:0:0:0: [sda] Write Protect is off
> [    6.547873] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
> [    6.586963] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
> [    6.647077] kobject (d5078ca4): tried to init an initialized object, something is seriously wrong.

So sda is probed twice, and hilarity ensues when we try to register it
twice.  I can't reproduce this, using scsi_debug and with scsi_async
enabled.

This is running linux-next? What's your .config?

-- 
Jens Axboe
