From: Wang Sen <senwang@linux.vnet.ibm.com>
Subject: [PATCH v3] scsi: virtio-scsi: Fix address translation failure of HighMem pages used by sg list
Date: Mon, 30 Jul 2012 14:25:06 +0800
Message-ID: <1343629506-29627-1-git-send-email-senwang@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:48512 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab2G3G0e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jul 2012 02:26:34 -0400
Received: from /spool/local
	by e28smtp03.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <senwang@linux.vnet.ibm.com>;
	Mon, 30 Jul 2012 11:56:31 +0530
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, pbonzini@redhat.com, bharrosh@panasas.com, stefanha@linux.vnet.ibm.com
Cc: mc@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zwanp@cn.ibm.com, xiaoguangrong@linux.vnet.ibm.com, Wang Sen <senwang@linux.vnet.ibm.com>

When using the commands below to write some data to a virtio-scsi LUN of the
QEMU guest(32-bit) with 1G physical memory(qemu -m 1024), the qemu will crash.

        # sudo mkfs.ext4 /dev/sdb  (/dev/sdb is the virtio-scsi LUN.)
        # sudo mount /dev/sdb /mnt
        # dd if=/dev/zero of=/mnt/file bs=1M count=1024

In current implementation, sg_set_buf is called to add buffers to sg list which
is put into the virtqueue eventually. But if there are some HighMem pages in
table->sgl you can not get virtual address by sg_virt. So, sg_virt(sg_elem) may
return NULL value. This will cause QEMU exit when virtqueue_map_sg is called
in QEMU because an invalid GPA is passed by virtqueue.

Two solutions are discussed here:
http://lkml.indiana.edu/hypermail/linux/kernel/1207.3/00675.html

Finally, value assignment approach was adopted because:

Value assignment creates a well-formed scatterlist, because the termination 
marker in source sg_list has been set in blk_rq_map_sg(). The last entry of the
source sg_list is just copied to the the last entry in destination list.  Note 
that, for now, virtio_ring does not care about the form of the scatterlist and 
simply processes the first out_num + in_num consecutive elements of the sg[] 
array.

I have tested the patch on my workstation. QEMU would not crash any more.

Cc: <stable@vger.kernel.org> # 3.4: 4fe74b1: [SCSI] virtio-scsi: SCSI driver
Signed-off-by: Wang Sen <senwang@linux.vnet.ibm.com>
---
 drivers/scsi/virtio_scsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 1b38431..6661610 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -198,7 +198,7 @@ static void virtscsi_map_sgl(struct scatterlist *sg, unsigned int *p_idx,
 	int i;
 
 	for_each_sg(table->sgl, sg_elem, table->nents, i)
-		sg_set_buf(&sg[idx++], sg_virt(sg_elem), sg_elem->length);
+		sg[idx++] = *sg_elem;
 
 	*p_idx = idx;
 }
-- 
1.7.9.5

