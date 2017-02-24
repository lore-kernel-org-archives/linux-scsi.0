From: Xiubo Li <lixiubo@cmss.chinamobile.com>
Subject: Re: [PATCH] target/user: Add daynmic growing data area featuresupport
Date: Fri, 24 Feb 2017 10:07:55 +0800
Message-ID: <48b49493-4c82-3ed5-126f-2ea18c701242@cmss.chinamobile.com>
References: <1487323472-20481-1-git-send-email-lixiubo@cmss.chinamobile.com>
 <09891673-0d95-8b66-ddce-0ace7aea43d1@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <09891673-0d95-8b66-ddce-0ace7aea43d1@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>, nab@linux-iscsi.org, mchristi@redhat.com, shli@kernel.org
Cc: hch@lst.de, sheng@yasker.org, namei.unix@gmail.com, bart.vanassche@sandisk.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, Jianfei Hu <hujianfei@cmss.chinamobile.com>
List-Id: linux-scsi@vger.kernel.org


>> When N is bigger, the ratio will be smaller. If N >= 1, the ratio
>> will be [15/1024, 4/1024), for this the ratio 15 : 1024 will be
>> enough. But maybe some iscsi cmds has no datas, N == 0. So the ratio
>> should be bigger.
>>
>> For now we will increase the data area size to 1G, and the cmd area
>> size to 128M. The tcmu-runner should mmap() about (128M + 1G) when
>> running and the TCMU will dynamically grows the data area from 0 to
>> max 1G size.
> Cool. This is a good approach for an initial patch but this raises
> concerns about efficiently managing kernel memory usage -- the data area
> grows but never shrinks, and total possible usage increases per
> backstore. (What if there are 1000?) Any ideas how we could also improve
> these aspects of the design? (Global TCMU data area usage limit?)
Two ways in my mind:

The first:
How about by setting a threshold cmd(SHRINK cmd), something likes
the PAD cmd, to tell the userspace runner try to shrink the memories?

When the runner get the SHRINK cmd, it will try to remmap uio0's ring
buffer(?). Then the kernel will get chance to shrink the memories....

The second:
Try to extern the data area by using /dev/uio1, we could remmap the
uio1 device when need, so it will be easy to get a chance to shrink the
memories in uio1.

Maybe these are a little ugly, are there other more effective ways ?

Thanks,

BRs
Xiubo


>> The cmd area memory will be allocated through vmalloc(), and the data
>> area's blocks will be allocated individually later when needed.
>>
>>
