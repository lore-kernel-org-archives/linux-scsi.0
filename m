From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] scsi: virtio-scsi: Fix address translation failure of
 HighMem pages used by sg list
Date: Wed, 25 Jul 2012 10:44:14 +0200
Message-ID: <500FB1DE.1000100@redhat.com>
References: <1343204966-23560-1-git-send-email-senwang@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1343204966-23560-1-git-send-email-senwang@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wang Sen <senwang@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, JBottomley@parallels.com, stefanha@linux.vnet.ibm.com, mc@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Il 25/07/2012 10:29, Wang Sen ha scritto:
> When using the commands below to write some data to a virtio-scsi LUN of the 
> QEMU guest(32-bit) with 1G physical memory(qemu -m 1024), the qemu will crash.
> 
> 	# sudo mkfs.ext4 /dev/sdb  (/dev/sdb is the virtio-scsi LUN.)
> 	# sudo mount /dev/sdb /mnt
> 	# dd if=/dev/zero of=/mnt/file bs=1M count=1024
> 
> In current implementation, sg_set_buf is called to add buffers to sg list which
> is put into the virtqueue eventually. But there are some HighMem pages in 
> table->sgl can not get virtual address by sg_virt. So, sg_virt(sg_elem) may
> return NULL value. This will cause QEMU exit when virtqueue_map_sg is called 
> in QEMU because an invalid GPA is passed by virtqueue.

Heh, I was compiling (almost) the same patch as we speak. :)

I've never seen QEMU crash; the VM would more likely just fail to boot
with a panic.  But it's the same bug anyway.

> My solution is using sg_set_page instead of sg_set_buf.
> 
> I have tested the patch on my workstation. QEMU would not crash any more.
> 
> Signed-off-by: Wang Sen <senwang@linux.vnet.ibm.com>
> ---
>  drivers/scsi/virtio_scsi.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index 1b38431..fc5c88a 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -198,7 +198,8 @@ static void virtscsi_map_sgl(struct scatterlist *sg, unsigned int *p_idx,
>  	int i;
>  
>  	for_each_sg(table->sgl, sg_elem, table->nents, i)
> -		sg_set_buf(&sg[idx++], sg_virt(sg_elem), sg_elem->length);
> +		sg_set_page(&sg[idx++], sg_page(sg_elem), sg_elem->length,
> +			sg_elem->offset);

This can simply be

   sg[idx++] = *sg_elem;

Can you repost it with this change, and also add stable@vger.kernel.org
to the Cc?  Thanks very much!

Paolo
