From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH] target/user: Add daynmic growing data area feature
 support
Date: Mon, 27 Feb 2017 17:56:21 -0600
Message-ID: <58B4BCA5.2060002@redhat.com>
References: <1487323472-20481-1-git-send-email-lixiubo@cmss.chinamobile.com>
 <09891673-0d95-8b66-ddce-0ace7aea43d1@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50330 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751478AbdB0X7m (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 27 Feb 2017 18:59:42 -0500
In-Reply-To: <09891673-0d95-8b66-ddce-0ace7aea43d1@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>, lixiubo@cmss.chinamobile.com, nab@linux-iscsi.org, shli@kernel.org
Cc: hch@lst.de, sheng@yasker.org, namei.unix@gmail.com, bart.vanassche@sandisk.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, Jianfei Hu <hujianfei@cmss.chinamobile.com>, Venky Shankar <vshankar@redhat.com>

On 02/22/2017 02:32 PM, Andy Grover wrote:
> On 02/17/2017 01:24 AM, lixiubo@cmss.chinamobile.com wrote:
>> > From: Xiubo Li <lixiubo@cmss.chinamobile.com>
>> > 
>> > Currently for the TCMU, the ring buffer size is fixed to 64K cmd
>> > area + 1M data area, and this will be bottlenecks for high iops.
> Hi Xiubo, thanks for your work.
> 
> daynmic -> dynamic
> 
> Have you benchmarked this patch and determined what kind of iops
> improvement it allows? Do you see the data area reaching its
> fully-allocated size?
> 

I tested this patch with Venky's tcmu-runner rbd aio patches, with one
10 gig iscsi session, and for pretty basic fio direct io (64 -256K
read/writes with a queue depth of 64 numjobs between 1 and 4) tests read
throughput goes from about 80 to 500 MB/s. Write throughput is pretty
low at around 150 MB/s.

I did not hit the fully allocated size. I did not drive a lot of IO though.
