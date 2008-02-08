From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PATCH] final SCSI updates for 2.6.24 merge window
Date: Thu, 7 Feb 2008 18:46:06 -0800
Message-ID: <20080207184606.03b28a9c.akpm@linux-foundation.org>
References: <1202432206.3171.53.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45060 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755779AbYBHCpv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Feb 2008 21:45:51 -0500
In-Reply-To: <1202432206.3171.53.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Nick Piggin <nickpiggin@yahoo.com.au>

On Thu, 07 Feb 2008 18:56:46 -0600 James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> Quite a bit of this is fixing things broken previously (the advansys fix
> is still pending resolution, but I'll send it as an -rc fix when we have
> it).  There's the final elimination of all drivers that are esp based
> but don't use the scsi_esp core (that's mostly m68k and alpha).  Plus
> the usual bunch of driver updates and the addition of a new enclosure
> services driver and the corresponding ULD.

Sob.  Can we please merge "Convert SG from nopage to fault"?  It has been
sent three times, the first time was Dec 5 last year and it has thus far
received the lead balloon treatment.  Despite my explicit request for
consideration last time I sent it

If there is no movement here then I have to carry the moderately intrusive
mm-remove-nopage.patch for another N months and we need to watch out for
new ->nopage implementations popping up etc.




From: Nick Piggin <npiggin@suse.de>

Convert SG from nopage to fault.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sg.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff -puN drivers/scsi/sg.c~sg-nopage drivers/scsi/sg.c
--- a/drivers/scsi/sg.c~sg-nopage
+++ a/drivers/scsi/sg.c
@@ -1160,23 +1160,22 @@ sg_fasync(int fd, struct file *filp, int
 	return (retval < 0) ? retval : 0;
 }
 
-static struct page *
-sg_vma_nopage(struct vm_area_struct *vma, unsigned long addr, int *type)
+static int
+sg_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	Sg_fd *sfp;
-	struct page *page = NOPAGE_SIGBUS;
 	unsigned long offset, len, sa;
 	Sg_scatter_hold *rsv_schp;
 	struct scatterlist *sg;
 	int k;
 
 	if ((NULL == vma) || (!(sfp = (Sg_fd *) vma->vm_private_data)))
-		return page;
+		return VM_FAULT_SIGBUS;
 	rsv_schp = &sfp->reserve;
-	offset = addr - vma->vm_start;
+	offset = vmf->pgoff << PAGE_SHIFT;
 	if (offset >= rsv_schp->bufflen)
-		return page;
-	SCSI_LOG_TIMEOUT(3, printk("sg_vma_nopage: offset=%lu, scatg=%d\n",
+		return VM_FAULT_SIGBUS;
+	SCSI_LOG_TIMEOUT(3, printk("sg_vma_fault: offset=%lu, scatg=%d\n",
 				   offset, rsv_schp->k_use_sg));
 	sg = rsv_schp->buffer;
 	sa = vma->vm_start;
@@ -1185,21 +1184,21 @@ sg_vma_nopage(struct vm_area_struct *vma
 		len = vma->vm_end - sa;
 		len = (len < sg->length) ? len : sg->length;
 		if (offset < len) {
+			struct page *page;
 			page = virt_to_page(page_address(sg_page(sg)) + offset);
 			get_page(page);	/* increment page count */
-			break;
+			vmf->page = page;
+			return 0; /* success */
 		}
 		sa += len;
 		offset -= len;
 	}
 
-	if (type)
-		*type = VM_FAULT_MINOR;
-	return page;
+	return VM_FAULT_SIGBUS;
 }
 
 static struct vm_operations_struct sg_mmap_vm_ops = {
-	.nopage = sg_vma_nopage,
+	.fault = sg_vma_fault,
 };
 
 static int
_

