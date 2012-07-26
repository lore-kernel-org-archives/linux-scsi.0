From: Wang Sen <kelvin.xupt@gmail.com>
Subject: Re: [PATCH v2] scsi: virtio-scsi: Fix address translation failure of
 HighMem pages used by sg list
Date: Thu, 26 Jul 2012 17:20:27 +0800
Message-ID: <CAKviJvXXrLFChXaUsP4+OYDnFxuX-8=0o-rqpbj_CiRZQrhoag@mail.gmail.com>
References: <1343218390-24310-1-git-send-email-senwang@linux.vnet.ibm.com>
	<1343218896.5132.135.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1343218896.5132.135.camel@deadeye.wl.decadent.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Wang Sen <senwang@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, JBottomley@parallels.com, pbonzini@redhat.com, stefanha@linux.vnet.ibm.com, mc@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

2012/7/25 Ben Hutchings <ben@decadent.org.uk>:
> On Wed, 2012-07-25 at 20:13 +0800, Wang Sen wrote:
>> When using the commands below to write some data to a virtio-scsi LUN of the
>> QEMU guest(32-bit) with 1G physical memory(qemu -m 1024), the qemu will crash.
>>
>>         # sudo mkfs.ext4 /dev/sdb  (/dev/sdb is the virtio-scsi LUN.)
>>         # sudo mount /dev/sdb /mnt
>>         # dd if=/dev/zero of=/mnt/file bs=1M count=1024
>>
>> In current implementation, sg_set_buf is called to add buffers to sg list which
>> is put into the virtqueue eventually. But if there are some HighMem pages in
>> table->sgl you can not get virtual address by sg_virt. So, sg_virt(sg_elem) may
>> return NULL value. This will cause QEMU exit when virtqueue_map_sg is called
>> in QEMU because an invalid GPA is passed by virtqueue.
>>
>> I take Paolo's solution mentioned in last thread to avoid failure on handling
>> flag bits.
>>
>> I have tested the patch on my workstation. QEMU would not crash any more.
>>
>> Signed-off-by: Wang Sen <senwang@linux.vnet.ibm.com>
> [...]
>
> This is not the correct way to submit a change for stable.  See
> Documentation/stable_kernel_rules.txt.

OK, thanks.

>
> Ben.
>
> --
> Ben Hutchings
> If more than one person is responsible for a bug, no one is at fault.



-- 
------------------------------------------
Wang Sen
Addr: XUPT,Xi'an,Shaanxi,China
Email: kelvin.xupt@gmail.com
------------------------------------------
