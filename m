From: "Eddie Wai" <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] SCSI: amd_iommu dma_boundary overflow
Date: Tue, 19 Feb 2013 18:30:53 -0800
Message-ID: <1361327453-1838-1-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <open-iscsi+bncBCUIJQ5MUMJBB5PKSCEQKGQEMUQ6KEI-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post?hl=en_US>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/?hl=en_US>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi?hl=en_US>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: James Bottomley <jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, open-iscsi <open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Chan <mchan-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hello,

For a 64-bit DMA capable PCIe storage HBA running under the 64-bit
AMD-VI IOMMU environment, the amd_iommu code was observed to hit an
overflow when it tries to page align the dma_parms->segment_boundary_mask.
This overflow would eventually trigger the BUG_ON in the iommu-helper's
iommu_is_span_boundary is_power_of_2 check.

A little back tracking shows that since the device is 64-bit DMA capable,
the pcidev->dma_mask was correctly set to DMA_BIT_MASK(64).  This dma_mask
was then transferred to the SCSI host's dma_boundary param (by the iSCSI
driver) and was eventually used to populate the q->limits.seg_boundary_mask
(via blk_queue_segment_boundary) and the dma_parms->segment_boundary_mask
(via dma_set_seg_boundary) during the scsi queue allocation.

The code seems correct as it make sense to impose the same hardware
segment boundary limit on both the blk queue and the DMA code.  It would
be an easy alternative to simply prevent the shost->dma_boundary from
being set to DMA_BIT_MASK(64), but it seems more correct to fix the
amd_iommu code itself to detect and handle this max 64-bit mask condition.

Please let me know your comments.

Thanks,
Eddie

Signed-off-by: Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/iommu/amd_iommu.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index d90a421..63185a1 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -1526,11 +1526,14 @@ static unsigned long dma_ops_area_alloc(struct device *dev,
 	unsigned long boundary_size;
 	unsigned long address = -1;
 	unsigned long limit;
+	unsigned long mask;
 
 	next_bit >>= PAGE_SHIFT;
 
-	boundary_size = ALIGN(dma_get_seg_boundary(dev) + 1,
-			PAGE_SIZE) >> PAGE_SHIFT;
+	mask = dma_get_seg_boundary(dev);
+	boundary_size = mask + 1 ?
+			ALIGN(mask + 1, PAGE_SIZE) >> PAGE_SHIFT :
+			1UL << (BITS_PER_LONG - PAGE_SHIFT);
 
 	for (;i < max_index; ++i) {
 		unsigned long offset = dom->aperture[i]->offset >> PAGE_SHIFT;
-- 
1.7.7.4


-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at http://groups.google.com/group/open-iscsi?hl=en.
For more options, visit https://groups.google.com/groups/opt_out.
