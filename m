From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2] scsi: virtio-scsi: Fix address translation failure
 of HighMem pages used by sg list
Date: Wed, 25 Jul 2012 14:34:17 +0200
Message-ID: <500FE7C9.3000703@redhat.com>
References: <1343218390-24310-1-git-send-email-senwang@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7994 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932917Ab2GYMe3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jul 2012 08:34:29 -0400
In-Reply-To: <1343218390-24310-1-git-send-email-senwang@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wang Sen <senwang@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, JBottomley@parallels.com, stefanha@linux.vnet.ibm.com, mc@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org

Il 25/07/2012 14:13, Wang Sen ha scritto:
> When using the commands below to write some data to a virtio-scsi LUN of the
> QEMU guest(32-bit) with 1G physical memory(qemu -m 1024), the qemu will crash.
> 
>         # sudo mkfs.ext4 /dev/sdb  (/dev/sdb is the virtio-scsi LUN.)
>         # sudo mount /dev/sdb /mnt
>         # dd if=/dev/zero of=/mnt/file bs=1M count=1024
> 
> In current implementation, sg_set_buf is called to add buffers to sg list which
> is put into the virtqueue eventually. But if there are some HighMem pages in
> table->sgl you can not get virtual address by sg_virt. So, sg_virt(sg_elem) may
> return NULL value. This will cause QEMU exit when virtqueue_map_sg is called
> in QEMU because an invalid GPA is passed by virtqueue.
> 
> I take Paolo's solution mentioned in last thread to avoid failure on handling 
> flag bits.

Please include an URL or (better) summarize the reason why sg_set_page
is not correct in the commit message.  For example, replace this
paragraph with the following:

"To fix this, we can simply copy the original scatterlist entries into
virtio-scsi's; we need to copy the entries entirely, including the flag
bits, so using sg_set_page is not correct".

Please send v3 with this change and I'll add my Acked-by.

Paolo

> 
> I have tested the patch on my workstation. QEMU would not crash any more.
> 
> Signed-off-by: Wang Sen <senwang@linux.vnet.ibm.com>
> ---
>  drivers/scsi/virtio_scsi.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index 1b38431..6661610 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -198,7 +198,7 @@ static void virtscsi_map_sgl(struct scatterlist *sg, unsigned int *p_idx,
>  	int i;
>  
>  	for_each_sg(table->sgl, sg_elem, table->nents, i)
> -		sg_set_buf(&sg[idx++], sg_virt(sg_elem), sg_elem->length);
> +		sg[idx++] = *sg_elem;
>  
>  	*p_idx = idx;
>  }
> 


