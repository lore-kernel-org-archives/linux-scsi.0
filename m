From: Xiubo Li <lixiubo@cmss.chinamobile.com>
Subject: Re: [PATCH] target/user: Add daynmic growing data area featuresupport
Date: Tue, 28 Feb 2017 17:13:37 +0800
Message-ID: <6e0a06b0-3777-e560-1943-3e0c1e022039@cmss.chinamobile.com>
References: <1487323472-20481-1-git-send-email-lixiubo@cmss.chinamobile.com>
 <09891673-0d95-8b66-ddce-0ace7aea43d1@redhat.com>
 <58B4BCA5.2060002@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <58B4BCA5.2060002@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Christie <mchristi@redhat.com>, Andy Grover <agrover@redhat.com>, nab@linux-iscsi.org, shli@kernel.org
Cc: hch@lst.de, sheng@yasker.org, namei.unix@gmail.com, bart.vanassche@sandisk.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, Jianfei Hu <hujianfei@cmss.chinamobile.com>, Venky Shankar <vshankar@redhat.com>
List-Id: linux-scsi@vger.kernel.org

>> On 02/17/2017 01:24 AM, lixiubo@cmss.chinamobile.com wrote:
>>>> From: Xiubo Li <lixiubo@cmss.chinamobile.com>
>>>>
>>>> Currently for the TCMU, the ring buffer size is fixed to 64K cmd
>>>> area + 1M data area, and this will be bottlenecks for high iops.
>> Hi Xiubo, thanks for your work.
>>
>> daynmic -> dynamic
>>
>> Have you benchmarked this patch and determined what kind of iops
>> improvement it allows? Do you see the data area reaching its
>> fully-allocated size?
>>
> I tested this patch with Venky's tcmu-runner rbd aio patches, with one
> 10 gig iscsi session, and for pretty basic fio direct io (64 -256K
> read/writes with a queue depth of 64 numjobs between 1 and 4) tests read
> throughput goes from about 80 to 500 MB/s. Write throughput is pretty
> low at around 150 MB/s.
>
> I did not hit the fully allocated size. I did not drive a lot of IO though.

How about dealing with memories shrinking in patch series followed?

As the initial patch, we could set the cmd area size to 8MB and the
data area size to 512MB. And this could work fine for most cases
without using too much memories.

On my similar test case by using VMs(low iops case) using fio, -bs=[64K,
128K, 512K, 1M] -size=20G, -iodepth 1 -numjobs=10,  the bw of read
increases from about 5200KB/s to about 6100KB/s, and the bw of write
increases from about 3000KB/s to about 3300KB/s.

While bs < 64K(from the log, the maximum of the data length is 64K),
the smaller of it the two bws will be closer.

But for all my test cases, the allocated size is far away from the full size
too.

Thanks,

BRs
Xiubo
