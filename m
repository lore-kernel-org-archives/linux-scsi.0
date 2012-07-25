From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH v2] scsi: virtio-scsi: Fix address translation failure
 of HighMem pages used by sg list
Date: Wed, 25 Jul 2012 15:47:03 +0300
Message-ID: <500FEAC7.2050803@panasas.com>
References: <1343218390-24310-1-git-send-email-senwang@linux.vnet.ibm.com> <500FE7C9.3000703@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <500FE7C9.3000703@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Wang Sen <senwang@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, JBottomley@parallels.com, stefanha@linux.vnet.ibm.com, mc@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/25/2012 03:34 PM, Paolo Bonzini wrote:

> Il 25/07/2012 14:13, Wang Sen ha scritto:
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
> 
> Please include an URL or (better) summarize the reason why sg_set_page
> is not correct in the commit message.  For example, replace this
> paragraph with the following:
> 
> "To fix this, we can simply copy the original scatterlist entries into
> virtio-scsi's; we need to copy the entries entirely, including the flag
> bits, so using sg_set_page is not correct".
> 

> Please send v3 with this change and I'll add my Acked-by.
> 


NACK-by: Boaz Harrosh


Apart from the HighMem pages problem, where in previous sg_set_buf()
code was the marker copied? It was not because it is not needed because
the allocation of sg took care of that. For example in 64bit the is no
bugs, right?

If there was a destination sg_list termination bug, it should be fixed
as a separate patch from this "HighMem pages problem". But I bet if
you inspect the code carefully there isn't such a bug.

Cheers
Boaz

> Paolo
> 
>>
>> I have tested the patch on my workstation. QEMU would not crash any more.
>>
>> Signed-off-by: Wang Sen <senwang@linux.vnet.ibm.com>
>> ---
>>  drivers/scsi/virtio_scsi.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
>> index 1b38431..6661610 100644
>> --- a/drivers/scsi/virtio_scsi.c
>> +++ b/drivers/scsi/virtio_scsi.c
>> @@ -198,7 +198,7 @@ static void virtscsi_map_sgl(struct scatterlist *sg, unsigned int *p_idx,
>>  	int i;
>>  
>>  	for_each_sg(table->sgl, sg_elem, table->nents, i)
>> -		sg_set_buf(&sg[idx++], sg_virt(sg_elem), sg_elem->length);
>> +		sg[idx++] = *sg_elem;
>>  
>>  	*p_idx = idx;
>>  }
>>
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
