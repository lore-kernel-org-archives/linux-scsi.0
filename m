From: Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: 2.6.22-rc3-mm1
Date: Thu, 31 May 2007 17:11:07 +0200
Message-ID: <20070531171107.3d665158@gondolin.boeblingen.de.ibm.com>
References: <20070530235823.793f00d9.akpm@linux-foundation.org>
	<20070531140922.2e55aefb@gondolin.boeblingen.de.ibm.com>
	<20070531121557.GQ23968@parisc-linux.org>
	<20070531142048.05edf133@gondolin.boeblingen.de.ibm.com>
	<465EC101.7010105@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757444AbXEaPLY@vger.kernel.org>
In-Reply-To: <465EC101.7010105@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, SCSI development list <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 31 May 2007 08:35:13 -0400,
Jeff Garzik <jeff@garzik.org> wrote:

> Cornelia Huck wrote:
> > On Thu, 31 May 2007 06:15:57 -0600,
> > Matthew Wilcox <matthew@wil.cx> wrote:
> > 
> >> On Thu, May 31, 2007 at 02:09:22PM +0200, Cornelia Huck wrote:
> >>> I split those functions out into a new file. Builds on s390 and i386.
> >> Why not just put #ifdef CONFIG_HAS_DMA / #endif around the pair of
> >> functions?  I don't see the need to add a new Kconfig symbol and a new
> >> file for this.
> > 
> > I prefer a new file over #ifdefs in c files. (New dma-dependent stuff
> > would also have a place where it could go to.)
> > 
> > But I'll do whatever ends up as consensus :)
> 
> 50 lines isn't much need for a new file.

OK, so here's an alternative patch:


scsi: Don't build scsi_dma_{map,unmap} for !HAS_DMA

Use #ifdef CONFIG_HAS_DMA for the two dma-dependent functions.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

---
 drivers/scsi/scsi_lib.c  |    2 ++
 include/scsi/scsi_cmnd.h |    2 ++
 2 files changed, 4 insertions(+)

--- linux-2.6.orig/drivers/scsi/scsi_lib.c
+++ linux-2.6/drivers/scsi/scsi_lib.c
@@ -2291,6 +2291,7 @@ void scsi_kunmap_atomic_sg(void *virt)
 }
 EXPORT_SYMBOL(scsi_kunmap_atomic_sg);
 
+#ifdef CONFIG_HAS_DMA
 /**
  * scsi_dma_map - perform DMA mapping against command's sg lists
  * @cmd:	scsi command
@@ -2328,3 +2329,4 @@ void scsi_dma_unmap(struct scsi_cmnd *cm
 	}
 }
 EXPORT_SYMBOL(scsi_dma_unmap);
+#endif
--- linux-2.6.orig/include/scsi/scsi_cmnd.h
+++ linux-2.6/include/scsi/scsi_cmnd.h
@@ -135,8 +135,10 @@ extern void scsi_kunmap_atomic_sg(void *
 extern struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *, gfp_t);
 extern void scsi_free_sgtable(struct scatterlist *, int);
 
+#ifdef CONFIG_HAS_DMA
 extern int scsi_dma_map(struct scsi_cmnd *cmd);
 extern void scsi_dma_unmap(struct scsi_cmnd *cmd);
+#endif
 
 #define scsi_sg_count(cmd) ((cmd)->use_sg)
 #define scsi_sglist(cmd) ((struct scatterlist *)(cmd)->request_buffer)
