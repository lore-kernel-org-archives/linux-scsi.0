From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3] scsi: virtio-scsi: Fix address translation failure
 of HighMem pages used by sg list
Date: Mon, 30 Jul 2012 09:45:33 +0200
Message-ID: <50163B9D.9040409@redhat.com>
References: <1343629506-29627-1-git-send-email-senwang@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1343629506-29627-1-git-send-email-senwang@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wang Sen <senwang@linux.vnet.ibm.com>
Cc: JBottomley@parallels.com, bharrosh@panasas.com, stefanha@linux.vnet.ibm.com, mc@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zwanp@cn.ibm.com, xiaoguangrong@linux.vnet.ibm.com
List-Id: linux-scsi@vger.kernel.org

Il 30/07/2012 08:25, Wang Sen ha scritto:
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
> Two solutions are discussed here:
> http://lkml.indiana.edu/hypermail/linux/kernel/1207.3/00675.html
> 
> Finally, value assignment approach was adopted because:
> 
> Value assignment creates a well-formed scatterlist, because the termination 
> marker in source sg_list has been set in blk_rq_map_sg(). The last entry of the
> source sg_list is just copied to the the last entry in destination list.  Note 
> that, for now, virtio_ring does not care about the form of the scatterlist and 
> simply processes the first out_num + in_num consecutive elements of the sg[] 
> array.
> 
> I have tested the patch on my workstation. QEMU would not crash any more.
> 
> Cc: <stable@vger.kernel.org> # 3.4: 4fe74b1: [SCSI] virtio-scsi: SCSI driver
> Signed-off-by: Wang Sen <senwang@linux.vnet.ibm.com>

Acked-by: Paolo Bonzini <pbonzini@redhat.com>
