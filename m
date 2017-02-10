From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH RFC] target/user: Add double ring buffers support.
Date: Fri, 10 Feb 2017 10:02:40 -0800
Message-ID: <240ae8db-1ede-2710-fb9c-1af3a020286e@redhat.com>
References: <1486709283-15535-1-git-send-email-lixiubo@cmss.chinamobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1486709283-15535-1-git-send-email-lixiubo@cmss.chinamobile.com>
Sender: target-devel-owner@vger.kernel.org
To: lixiubo@cmss.chinamobile.com, mchristi@redhat.com
Cc: nab@linux-iscsi.org, sheng@yasker.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, namei.unix@gmail.com
List-Id: linux-scsi@vger.kernel.org

On 02/09/2017 10:48 PM, lixiubo@cmss.chinamobile.com wrote:
> For now the tcmu is based on UIO framework and only using the
> map0 with fixed ring buffer size. This will work fine mostly,
> but when we are using the 10GBASE NIC, the ring buffer is too
> small to deal with the incoming iscsi cmds.
>
> We can resolve the above issue by increasingt the ring buffer
> size larger, but we don't know the exactly size to all cases.
>
> This patch will add double ring buffers support by adding map1
> support through UIO device.

Hi Xiubo,

Yes I think it's now clear we need more buffer space to avoid 
bottlenecks for high iops. The initial design kept it simple with the 
1MB vmalloc'd space but anticipated greater would be needed. It should 
not be necessary to change userspace or the TCMU ABI to handle growing 
the buffer for fast devices:

1. increase the region mmap()ed by userspace, TCMU_RING_SIZE, from 1MB 
to 1GB or larger
2. Don't vmalloc() the whole thing, instead vmalloc for the cmd ring 
portion, and dynamically alloc pages for the data area as needed and map 
them into the data area.
3. Upgrade the current fixed-size bitmap-based tracking of data area to 
handle the new scheme
4. Implement an algorithm to keep allocated pages mapped into the data 
area for reuse, and maybe a heuristic to keep extreme burstiness from 
over-allocating pages

This should allow TCMU to allocate more data area as needed, not waste 
memory for slower devices, and avoid userspace ABI changes. Could we 
prototype this approach and see if it is workable?

Thanks -- Regards -- Andy
