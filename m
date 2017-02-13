From: Xiubo Li <lixiubo@cmss.chinamobile.com>
Subject: Re: [PATCH RFC] target/user: Add double ring buffers support.
Date: Mon, 13 Feb 2017 17:50:13 +0800
Message-ID: <a968c308-8e1e-692f-ab0e-1cd9738a64ad@cmss.chinamobile.com>
References: <1486709283-15535-1-git-send-email-lixiubo@cmss.chinamobile.com>
 <240ae8db-1ede-2710-fb9c-1af3a020286e@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmccmta2.chinamobile.com ([221.176.66.80]:19750 "EHLO
        cmccmta2.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751598AbdBMJuX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Feb 2017 04:50:23 -0500
In-Reply-To: <240ae8db-1ede-2710-fb9c-1af3a020286e@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>, mchristi@redhat.com
Cc: nab@linux-iscsi.org, sheng@yasker.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, namei.unix@gmail.com

Hi Andy,

There is one new scheme in my mind:

>
> Yes I think it's now clear we need more buffer space to avoid 
> bottlenecks for high iops. The initial design kept it simple with the 
> 1MB vmalloc'd space but anticipated greater would be needed. It should 
> not be necessary to change userspace or the TCMU ABI to handle growing 
> the buffer for fast devices:
>
> 1. increase the region mmap()ed by userspace, TCMU_RING_SIZE, from 1MB 
> to 1GB or larger
For the cmd area, set the size to fixed 512M, and data area's size to 
fixed 1G, is that okay ?

> 2. Don't vmalloc() the whole thing, instead vmalloc for the cmd ring 
> portion, and dynamically alloc pages for the data area as needed and 
> map them into the data area.
TCMU will just vmalloc() the 512M cmd area, and let the data area memory 
allocate and map later when needed.
The userspace runner will mmap() all the (512M + 1G) when initialising, 
and will return 1.5G virtual address space. The cmd area will be mapped 
to actual physical addresses here, while the data area will be mapped in 
page fault hook when using....


> 3. Upgrade the current fixed-size bitmap-based tracking of data area 
> to handle the new scheme
The Radix tree will be used to keep the block's index(0 ~ 
1G/DATA_BLOCK_SIZE) and physical page mapping relations. Each leaf is 
one data block(the size is DATA_BLOCK_SIZE).

For non-leaf nodes, use the radix tags[0][SLOTs] to indicate wether 
slot[SLOTs]'s branch has free(reused the old one or NULL leafs) block 
leafs or not.
This could speed the search of the free blocks in data area.


> 4. Implement an algorithm to keep allocated pages mapped into the data 
> area for reuse, and maybe a heuristic to keep extreme burstiness from 
> over-allocating pages
>
For leaf nodes:
if one leaf node is exist and its tags[0][SLOTs] = 0 meaning that some 
older cmds have already touched the block leafs and then "freed" it, if 
so, we will reuse it.
if the leaf node is exist and its tag[0][SLOTs] = 1 meaning that this is 
still used.
if the leaf node is non-exist, this is the first time to touch this 
leaf, will allocate memory and then insert it here setting the 
tag[0][SLOTs] to 1.

> This should allow TCMU to allocate more data area as needed, not waste 
> memory for slower devices, and avoid userspace ABI changes. Could we 
> prototype this approach and see if it is workable?
>
For slower devices, it will save memory.
Could also avoid changing the userspace ABI.

Thanks,

BRs
Xiubo



> Thanks -- Regards -- Andy
>
