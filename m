From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH for 3.6 1/3] virtio-scsi: fix copying of sg_list in the presence of of HighMem pages
Date: Wed, 29 Aug 2012 12:39:07 +0200
Message-ID: <1346236748-12554-1-git-send-email-pbonzini@redhat.com>
References: <1346155154-12915-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:65019 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541Ab2H2KjR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Aug 2012 06:39:17 -0400
In-Reply-To: <1346155154-12915-1-git-send-email-pbonzini@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, kvm@vger.kernel.org, jbottomley@parallels.com, Wang Sen <senwang@linux.vnet.ibm.com>, stable@vger.kernel.org

From: Wang Sen <senwang@linux.vnet.ibm.com>

On a 32-bit guest with virtio-scsi devices and more than 1G physical memory,
QEMU may crash or Linux will fail to boot.

This bug happens when building the sg_list that is eventually put in the virtqueue.
Each buffer from the original sg_list is added with sg_set_buf, but this will
not work for HighMem pages in table->sgl.  In that case, the original sg_list
elements do not have a valid virtual address, but sg_set_buf will use sg_virt.

For now, virtio_ring does not care about the form of the scatterlist and
simply processes the first out_num + in_num consecutive elements of the sg[]
array.  However, it is better to create a well-formed scatterlist including
the termination marker.

http://lkml.indiana.edu/hypermail/linux/kernel/1207.3/00675.html discusses
using value assignment vs. sg_set_page to copy the scatterlist.

With sg_set_page, the driver would need to drop the marker manually in case
it was left there by a previous request, and then use sg_mark_end to add the
marker to the last entry.

Value assignment instead will copy the last entry of the source sg_list
to the destination list.  The end marker that were set by blk_rq_map_sg()
is copied too when the last entry of the source sg_list is copied to
the the last entry in destination list.

Cc: Stable kernel <stable@vger.kernel.org> # 3.4: 4fe74b1: [SCSI] virtio-scsi: SCSI driver
Signed-off-by: Wang Sen <senwang@linux.vnet.ibm.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/scsi/virtio_scsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index c7030fb..3e79a2f 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -331,7 +331,7 @@ static void virtscsi_map_sgl(struct scatterlist *sg, unsigned int *p_idx,
 	int i;
 
 	for_each_sg(table->sgl, sg_elem, table->nents, i)
-		sg_set_buf(&sg[idx++], sg_virt(sg_elem), sg_elem->length);
+		sg[idx++] = *sg_elem;
 
 	*p_idx = idx;
 }
-- 
1.7.1


