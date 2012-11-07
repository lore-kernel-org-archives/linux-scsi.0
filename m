From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: Re: [PATCH 0/5] virtio-scsi: create a separate workqueue
Date: Wed, 07 Nov 2012 20:40:22 +0800
Message-ID: <509A56B6.2010909@cn.fujitsu.com>
References: <1352283494-31200-1-git-send-email-gaowanlong@cn.fujitsu.com> <CAFO3S42dT_j9pQSNSUrdmkqu_pgxthx0zBy3qjdiuXrbxf5H+g@mail.gmail.com>
Reply-To: gaowanlong@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAFO3S42dT_j9pQSNSUrdmkqu_pgxthx0zBy3qjdiuXrbxf5H+g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Asias He <asias.hejun@gmail.com>
Cc: linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Paolo Bonzini <pbonzini@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, linux-scsi@vger.kernel.org, kvm@vger.kernel.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>
List-Id: linux-scsi@vger.kernel.org

On 11/07/2012 08:23 PM, Asias He wrote:
> On Wed, Nov 7, 2012 at 6:18 PM, Wanlong Gao <gaowanlong@cn.fujitsu.com> wrote:
>> patch 1-3,5 are some cleanups.
>> patch 4: create a separate work queue for virtio-scsi
>> to improve the performance, I tested with tmpfs backed
>> disk, the config file is like below,
>> [global]
>> bsrange=4k-64k
>> ioengine=libaio
>> direct=1
>> iodepth=4
>> loops=10
>> size=64M
>>
>> Before:
>> Disk stats (read/write):
>>   sda: ios=6547/5275, merge=37/39, ticks=3144/2645, in_queue=5780, util=81.62%
>>   sdb: ios=6542/5277, merge=54/59, ticks=3234/3143, in_queue=6364, util=84.50%
>>   sdc: ios=6532/5244, merge=65/62, ticks=3440/3076, in_queue=6505, util=86.83%
> 
> The result is about the disk stat. Can you please post the iops and
> the bw instead?

Sure,

before:
  write: io=589788KB, bw=122211KB/s, iops=3584 , runt=  4826msec
  bw (KB/s)  : min=24208, max=116272, per=57.47%, avg=70236.40, stdev=35496.33  
  WRITE: io=589788KB, aggrb=122210KB/s, minb=122210KB/s, maxb=122210KB/s, mint=4826msec, maxt=4826msec 

after:
  write: io=589788KB, bw=124244KB/s, iops=3530 , runt=  4747msec
  bw (KB/s)  : min=63496, max=117943, per=73.39%, avg=91184.20, stdev=20062.42
  WRITE: io=589788KB, aggrb=124244KB/s, minb=124244KB/s, maxb=124244KB/s, mint=4747msec, maxt=4747msec


Thanks,
Wanlong Gao


> 
>> After:
>> Disk stats (read/write):
>>   sda: ios=6349/5318, merge=77/89, ticks=4820/3169, in_queue=7991, util=90.62%
>>   sdb: ios=6364/5358, merge=39/53, ticks=3810/2816, in_queue=6615, util=84.63%
>>   sdc: ios=6458/5352, merge=74/47, ticks=4425/3048, in_queue=7459, util=88.41%
>>
>>
>> Wanlong Gao (5):
>>   virtio-scsi: remove the useless assignment
>>   virtio-scsi: remove the needless variable gfp_mask
>>   virtio-scsi: use pr_err instead of printk
>>   virtio-scsi: create a separate work queue for virtio-scsi
>>   virtio-scsi: tidy up the goto label in init()
>>
>>
>>
>> Cc: James E.J. Bottomley <JBottomley@parallels.com>
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> Cc: Rusty Russell <rusty@rustcorp.com.au>
>> Cc: linux-scsi@vger.kernel.org
>> Cc: kvm@vger.kernel.org
>>  drivers/scsi/virtio_scsi.c | 43 +++++++++++++++++++++++--------------------
>>  1 file changed, 23 insertions(+), 20 deletions(-)
>>
>> --
>> 1.8.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe kvm" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
