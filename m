From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH] target/user: Add daynmic growing data area featuresupport
Date: Tue, 28 Feb 2017 12:13:22 -0600
Message-ID: <58B5BDC2.3040300@redhat.com>
References: <1487323472-20481-1-git-send-email-lixiubo@cmss.chinamobile.com>
 <09891673-0d95-8b66-ddce-0ace7aea43d1@redhat.com>
 <58B4BCA5.2060002@redhat.com>
 <983dc030-0352-05d8-9fc7-a6cdf2c59f8d@cmss.chinamobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37920 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751666AbdB1SZa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Feb 2017 13:25:30 -0500
In-Reply-To: <983dc030-0352-05d8-9fc7-a6cdf2c59f8d@cmss.chinamobile.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Xiubo Li <lixiubo@cmss.chinamobile.com>, Andy Grover <agrover@redhat.com>, nab@linux-iscsi.org, shli@kernel.org
Cc: hch@lst.de, sheng@yasker.org, namei.unix@gmail.com, bart.vanassche@sandisk.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, Jianfei Hu <hujianfei@cmss.chinamobile.com>, Venky Shankar <vshankar@redhat.com>

On 02/27/2017 07:22 PM, Xiubo Li wrote:
> Hi Mike
> 
> Thanks verrry much for your work and test cases.
> 
> 
>>>>> From: Xiubo Li <lixiubo@cmss.chinamobile.com>
>>>>>
>>>>> Currently for the TCMU, the ring buffer size is fixed to 64K cmd
>>>>> area + 1M data area, and this will be bottlenecks for high iops.
>>> Hi Xiubo, thanks for your work.
>>>
>>> daynmic -> dynamic
>>>
>>> Have you benchmarked this patch and determined what kind of iops
>>> improvement it allows? Do you see the data area reaching its
>>> fully-allocated size?
>>>
>> I tested this patch with Venky's tcmu-runner rbd aio patches, with one
>> 10 gig iscsi session, and for pretty basic fio direct io (64 -256K
>> read/writes with a queue depth of 64 numjobs between 1 and 4) tests read
>> throughput goes from about 80 to 500 MB/s.
> Looks nice.
> 
>> Write throughput is pretty
>> low at around 150 MB/s.
> What's the original write throughput without this patch? Is it also
> around 80 MB/s ?

It is around 20-30 MB/s. Same fio args except using --rw=write.
