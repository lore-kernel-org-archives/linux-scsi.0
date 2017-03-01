From: Xiubo Li <lixiubo@cmss.chinamobile.com>
Subject: Re: [PATCH] target/user: Add daynmic growing data area featuresupport
Date: Wed, 1 Mar 2017 18:53:23 +0800
Message-ID: <770ba3ff-5075-8673-d53b-f6feda0fdc28@cmss.chinamobile.com>
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



>> For now we will increase the data area size to 1G, and the cmd area
>> size to 128M. The tcmu-runner should mmap() about (128M + 1G) when
>> running and the TCMU will dynamically grows the data area from 0 to
>> max 1G size.
> Cool. This is a good approach for an initial patch but this raises
> concerns about efficiently managing kernel memory usage -- the data area
> grows but never shrinks, and total possible usage increases per
> backstore. (What if there are 1000?) Any ideas how we could also improve
> these aspects of the design? (Global TCMU data area usage limit?)

Sorry for misunderstanding about this on my part before.

If we couldn't get a feasible way from mm to deal with the memories
shrinking. Maybe a global TCMU data area usage limit is a good choice:

We can limit the global physical data area size to 2G as default, and export
one sysfs to configure this as needed(such as 10G size with possible 1000
targets).

Then use one global radix tree to manage all the 2G physical pages(will grow
from 0 to 2G). Each ring buffer will search it's own data area bitmaps, and
if the current block is reusing, then we should get the old page, which has
already mapped to the runner process, from the global radix tree, or should
we get one new page(from global radix tree or system MM). After getting the
page, tcmu in kernel will use it my kmap(). Free it with kumapp() and 
insert to
global radix tree.


BRs
Xiubo
