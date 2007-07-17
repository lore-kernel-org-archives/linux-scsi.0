From: Muli Ben-Yehuda <muli@il.ibm.com>
Subject: Re: [PATCH 09/33] x86-64: update iommu/dma mapping functions to sg helpers
Date: Tue, 17 Jul 2007 14:03:13 +0300
Message-ID: <20070717110312.GD18721@rhun.ibm.com>
References: <11845792671245-git-send-email-jens.axboe@oracle.com> <11845792681830-git-send-email-jens.axboe@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:54421 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbXGQLD4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jul 2007 07:03:56 -0400
Content-Disposition: inline
In-Reply-To: <11845792681830-git-send-email-jens.axboe@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, ak@suse.de

On Mon, Jul 16, 2007 at 11:47:23AM +0200, Jens Axboe wrote:

> This prepares x86-64 for sg chaining support.
> 
> Additional improvements/fixups for pci-gart from
> Benny Halevy <bhalevy@panasas.com>
> 
> Cc: ak@suse.de
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> ---
>  arch/x86_64/kernel/pci-calgary.c |   25 ++++++++------
>  arch/x86_64/kernel/pci-gart.c    |   63 ++++++++++++++++++++-----------------
>  arch/x86_64/kernel/pci-nommu.c   |    5 ++-

Calgary and nommu bits are:

Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>

FYI, here's the Calgary diff on top of the outstanding Calgary
changes.

diff -r 8642809f9e33 arch/x86_64/kernel/pci-calgary.c
--- a/arch/x86_64/kernel/pci-calgary.c	Mon Jul 16 09:38:14 2007 +0300
+++ b/arch/x86_64/kernel/pci-calgary.c	Tue Jul 17 13:33:24 2007 +0300
@@ -35,6 +35,7 @@
 #include <linux/pci_ids.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
+#include <linux/scatterlist.h>
 #include <asm/proto.h>
 #include <asm/calgary.h>
 #include <asm/tce.h>
@@ -387,31 +388,32 @@ static void calgary_unmap_sg(struct devi
 	struct scatterlist *sglist, int nelems, int direction)
 {
 	struct iommu_table *tbl = find_iommu_table(dev);
+	struct scatterlist *s;
+	int i;
 
 	if (!translate_phb(to_pci_dev(dev)))
 		return;
 
-	while (nelems--) {
+	for_each_sg(sglist, s, nelems, i) {
 		unsigned int npages;
-		dma_addr_t dma = sglist->dma_address;
-		unsigned int dmalen = sglist->dma_length;
+		dma_addr_t dma = s->dma_address;
+		unsigned int dmalen = s->dma_length;
 
 		if (dmalen == 0)
 			break;
 
 		npages = num_dma_pages(dma, dmalen);
 		iommu_free(tbl, dma, npages);
-		sglist++;
 	}
 }
 
 static int calgary_nontranslate_map_sg(struct device* dev,
 	struct scatterlist *sg, int nelems, int direction)
 {
+	struct scatterlist *s;
 	int i;
 
-	for (i = 0; i < nelems; i++ ) {
-		struct scatterlist *s = &sg[i];
+	for_each_sg(sg, s, nelems, i) {
 		BUG_ON(!s->page);
 		s->dma_address = virt_to_bus(page_address(s->page) +s->offset);
 		s->dma_length = s->length;
@@ -423,6 +425,7 @@ static int calgary_map_sg(struct device 
 	int nelems, int direction)
 {
 	struct iommu_table *tbl = find_iommu_table(dev);
+	struct scatterlist *s;
 	unsigned long vaddr;
 	unsigned int npages;
 	unsigned long entry;
@@ -431,8 +434,7 @@ static int calgary_map_sg(struct device 
 	if (!translate_phb(to_pci_dev(dev)))
 		return calgary_nontranslate_map_sg(dev, sg, nelems, direction);
 
-	for (i = 0; i < nelems; i++ ) {
-		struct scatterlist *s = &sg[i];
+ 	for_each_sg(sg, s, nelems, i) {
 		BUG_ON(!s->page);
 
 		vaddr = (unsigned long)page_address(s->page) + s->offset;
@@ -457,9 +459,9 @@ static int calgary_map_sg(struct device 
 	return nelems;
 error:
 	calgary_unmap_sg(dev, sg, nelems, direction);
-	for (i = 0; i < nelems; i++) {
-		sg[i].dma_address = bad_dma_address;
-		sg[i].dma_length = 0;
+	for_each_sg(sg, s, nelems, i) {
+		s->dma_address = bad_dma_address;
+		s->dma_length = 0;
 	}
 	return 0;
 }
