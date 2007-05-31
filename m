From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.22-rc3-mm1
Date: Thu, 31 May 2007 15:10:05 -0700
Message-ID: <20070531151005.5c5db8af.akpm@linux-foundation.org>
References: <20070530235823.793f00d9.akpm@linux-foundation.org>
	<20070531140922.2e55aefb@gondolin.boeblingen.de.ibm.com>
	<20070531121557.GQ23968@parisc-linux.org>
	<20070531142048.05edf133@gondolin.boeblingen.de.ibm.com>
	<465EC101.7010105@garzik.org>
	<20070531151338.GA759@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:56277 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753218AbXEaWKY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 May 2007 18:10:24 -0400
In-Reply-To: <20070531151338.GA759@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeff Garzik <jeff@garzik.org>, Cornelia Huck <cornelia.huck@de.ibm.com>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, SCSI development list <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>, Dan Williams <dan.j.williams@intel.com>

On Thu, 31 May 2007 16:13:38 +0100
Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, May 31, 2007 at 08:35:13AM -0400, Jeff Garzik wrote:
> > Cornelia Huck wrote:
> > >On Thu, 31 May 2007 06:15:57 -0600,
> > >Matthew Wilcox <matthew@wil.cx> wrote:
> > >
> > >>On Thu, May 31, 2007 at 02:09:22PM +0200, Cornelia Huck wrote:
> > >>>I split those functions out into a new file. Builds on s390 and i386.
> > >>Why not just put #ifdef CONFIG_HAS_DMA / #endif around the pair of
> > >>functions?  I don't see the need to add a new Kconfig symbol and a new
> > >>file for this.
> > >
> > >I prefer a new file over #ifdefs in c files. (New dma-dependent stuff
> > >would also have a place where it could go to.)
> > >
> > >But I'll do whatever ends up as consensus :)
> > 
> > 50 lines isn't much need for a new file.
> 
> The scsi core shouldn't know anything about dma mappings, so a separate
> file is a good idea just to keep the separation clean.

ok, let's go this way.

Cornelia, afaict your patch has no actual delendency upon Dan's
dma-mapping-prevent-dma-dependent-code-from-linking-on.patch, correct?  If
so, I can merge it via James and then merge Dan's patch once James has
merged.

If there is a dependency then I guess I merge both into a single diff and
merge it all in one hit.

btw, this:

diff -puN include/scsi/scsi_cmnd.h~scsi-dont-build-scsi_dma_mapunmap-for-has_dma include/scsi/scsi_cmnd.h
--- a/include/scsi/scsi_cmnd.h~scsi-dont-build-scsi_dma_mapunmap-for-has_dma
+++ a/include/scsi/scsi_cmnd.h
@@ -135,8 +135,10 @@ extern void scsi_kunmap_atomic_sg(void *
 extern struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *, gfp_t);
 extern void scsi_free_sgtable(struct scatterlist *, int);
 
+#ifdef CONFIG_SCSI_DMA
 extern int scsi_dma_map(struct scsi_cmnd *cmd);
 extern void scsi_dma_unmap(struct scsi_cmnd *cmd);
+#endif
 
 #define scsi_sg_count(cmd) ((cmd)->use_sg)
 #define scsi_sglist(cmd) ((struct scatterlist *)(cmd)->request_buffer)

We don't really need the ifdefs here.  If someone incorrectly calls these
functions then they'll get a link-time failure anyway.  The downside of
removing these ifdefs is that they won't get a compile-time warning, but I
tend to think that this small cost is worth it.
