From: Wang Sen <senwang@linux.vnet.ibm.com>
Subject: [PATCH] scsi: virtio-scsi: Fix address translation failure of HighMem pages used by sg list
Date: Wed, 25 Jul 2012 16:29:26 +0800
Message-ID: <1343204966-23560-1-git-send-email-senwang@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:47879 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932748Ab2GYI35 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jul 2012 04:29:57 -0400
Received: from /spool/local
	by e28smtp05.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <senwang@linux.vnet.ibm.com>;
	Wed, 25 Jul 2012 13:59:54 +0530
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, pbonzini@redhat.com, stefanha@linux.vnet.ibm.com, mc@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, Wang Sen <senwang@linux.vnet.ibm.com>

When using the commands below to write some data to a virtio-scsi LUN of the 
QEMU guest(32-bit) with 1G physical memory(qemu -m 1024), the qemu will crash.

	# sudo mkfs.ext4 /dev/sdb  (/dev/sdb is the virtio-scsi LUN.)
	# sudo mount /dev/sdb /mnt
	# dd if=/dev/zero of=/mnt/file bs=1M count=1024

In current implementation, sg_set_buf is called to add buffers to sg list which
is put into the virtqueue eventually. But there are some HighMem pages in 
table->sgl can not get virtual address by sg_virt. So, sg_virt(sg_elem) may
return NULL value. This will cause QEMU exit when virtqueue_map_sg is called 
in QEMU because an invalid GPA is passed by virtqueue.

My solution is using sg_set_page instead of sg_set_buf.

I have tested the patch on my workstation. QEMU would not crash any more.

Signed-off-by: Wang Sen <senwang@linux.vnet.ibm.com>
---
 drivers/scsi/virtio_scsi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 1b38431..fc5c88a 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -198,7 +198,8 @@ static void virtscsi_map_sgl(struct scatterlist *sg, unsigned int *p_idx,
 	int i;
 
 	for_each_sg(table->sgl, sg_elem, table->nents, i)
-		sg_set_buf(&sg[idx++], sg_virt(sg_elem), sg_elem->length);
+		sg_set_page(&sg[idx++], sg_page(sg_elem), sg_elem->length,
+			sg_elem->offset);
 
 	*p_idx = idx;
 }
-- 
1.7.9.5

