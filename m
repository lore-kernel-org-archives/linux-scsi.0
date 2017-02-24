From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH] target/user: Add daynmic growing data area featuresupport
Date: Fri, 24 Feb 2017 14:29:00 -0800
Message-ID: <21d93bec-a717-5157-8dcf-cc629611572f@redhat.com>
References: <1487323472-20481-1-git-send-email-lixiubo@cmss.chinamobile.com>
 <09891673-0d95-8b66-ddce-0ace7aea43d1@redhat.com>
 <48b49493-4c82-3ed5-126f-2ea18c701242@cmss.chinamobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52732 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751163AbdBXW3C (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Feb 2017 17:29:02 -0500
In-Reply-To: <48b49493-4c82-3ed5-126f-2ea18c701242@cmss.chinamobile.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Xiubo Li <lixiubo@cmss.chinamobile.com>, nab@linux-iscsi.org, mchristi@redhat.com, shli@kernel.org
Cc: hch@lst.de, sheng@yasker.org, namei.unix@gmail.com, bart.vanassche@sandisk.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, Jianfei Hu <hujianfei@cmss.chinamobile.com>

On 02/23/2017 06:07 PM, Xiubo Li wrote:
>> Cool. This is a good approach for an initial patch but this raises
>> concerns about efficiently managing kernel memory usage -- the data area
>> grows but never shrinks, and total possible usage increases per
>> backstore. (What if there are 1000?) Any ideas how we could also improve
>> these aspects of the design? (Global TCMU data area usage limit?)
> Two ways in my mind:
> 
> The first:
> How about by setting a threshold cmd(SHRINK cmd), something likes
> the PAD cmd, to tell the userspace runner try to shrink the memories?

Why should userspace need to know if the kernel is shrinking memory
allocated to the data area? Userspace knows about memory described in
iovecs for in-flight cmds, we shouldn't need its cooperation to free
other allocated parts of the data area.

But, We likely don't want to release memory from the data area anyways
while active, in any case. How about if we set a timer when active
commands go to zero, and then reduce data area to some minimum if no new
cmds come in before timer expires?

> When the runner get the SHRINK cmd, it will try to remmap uio0's ring
> buffer(?). Then the kernel will get chance to shrink the memories....
> 
> The second:
> Try to extern the data area by using /dev/uio1, we could remmap the
> uio1 device when need, so it will be easy to get a chance to shrink the
> memories in uio1.

Userspace should not need to remap the region in order for the kernel to
free and unmap pages from the region.

The only thing we need to watch out for is if blocks are referenced by
in-flight cmds, we can't free them or userspace will segfault. So, if we
wait until there are no in-flight cmds, then it follows that the kernel
can free whatever it wants and userspace will not segfault.

-- Andy
