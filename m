From: Xiubo Li <lixiubo@cmss.chinamobile.com>
Subject: Re: [PATCH] target/user: Add daynmic growing data area featuresupport
Date: Tue, 28 Feb 2017 09:22:05 +0800
Message-ID: <983dc030-0352-05d8-9fc7-a6cdf2c59f8d@cmss.chinamobile.com>
References: <1487323472-20481-1-git-send-email-lixiubo@cmss.chinamobile.com>
 <09891673-0d95-8b66-ddce-0ace7aea43d1@redhat.com>
 <58B4BCA5.2060002@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <58B4BCA5.2060002@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Mike Christie <mchristi@redhat.com>, Andy Grover <agrover@redhat.com>, nab@linux-iscsi.org, shli@kernel.org
Cc: hch@lst.de, sheng@yasker.org, namei.unix@gmail.com, bart.vanassche@sandisk.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, Jianfei Hu <hujianfei@cmss.chinamobile.com>, Venky Shankar <vshankar@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Hi Mike

Thanks verrry much for your work and test cases.


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
> throughput goes from about 80 to 500 MB/s.
Looks nice.

> Write throughput is pretty
> low at around 150 MB/s.
What's the original write throughput without this patch? Is it also
around 80 MB/s ?

> I did not hit the fully allocated size. I did not drive a lot of IO though.
Yes, if the cmd area won't hit the fully allocated size, the data area is
also very hard to hit the fully allocated size.

And for the 64MB cmd area size is a little larger for 1GB data area.

Next, I will down it to smaller as needed.

Thanks,

BRs
Xiubo
