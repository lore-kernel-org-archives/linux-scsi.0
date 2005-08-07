From: Tejun Heo <htejun@gmail.com>
Subject: Re: [RFC][PATCH] libata ATAPI alignment
Date: Sun, 7 Aug 2005 14:48:50 +0900
Message-ID: <20050807054850.GA13335@htj.dyndns.org>
References: <20050729050654.GA10413@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20050729050654.GA10413@havoc.gtf.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jens Axboe <axboe@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jul 29, 2005 at 01:06:54AM -0400, Jeff Garzik wrote:
> 
> So, one thing that's terribly ugly about SATA ATAPI is that we need to
> pad DMA transfers to the next 32-bit boundary, if the length is not
> evenly divisible by 4.
> 
> Messing with the scatterlist to accomplish this is terribly ugly
> no matter how you slice it.  One way would be to create my own
> scatterlist, via memcpy and then manual labor.  Another way would be
> to special case a pad buffer, appending it onto the end of various
> scatterlist code.
> 
> Complicating matters, we currently must support two methods of data
> buffer submission:  a single kernel virtual address, or a struct
> scatterlist.
> 
> Review is requested by any and all parties, as well as suggestions for
> a prettier approach.
> 
> This is one of the last steps needed to get ATAPI going.
> 

 Hello, Jeff, Jens & Alan.

 I've rewritten the patch to fix some bugs and make it a bit (IMHO)
simpler to use.

 Bug fixes...

 * When copying a sg, original implementation just kmap'ed sg->page
   which can cause trouble as a sg can span more than a page.

 * In ata_sg_clean(), the original implementation accesses last sg by
   indexing w/ (qc->n_elem - 1).  This is incorrect as qc->n_elem
   could have been shrunk by dma_map_sg() in ata_sg_setup().

 * In the original code (before Jeff's patch), sata_sx4 used
   sg[i].legnth to calculate total_len.  This is wrong for the same
   reason as above and Jeff's patch fixes it.  I separated out this
   fix just to clarify.

 Changes...

 * Instead of adding pad sg handling to each fill_sg function,
   ata_for_each_sg() macro is added.  Normal sg entries and
   qc->pad_sgent are setup by sg_setup routines and fill_sg functions
   can just iterate w/ ata_for_each_sg() without caring about padding.

 * hw_max_segments is automatically decremented in slave_config if
   attached device is ATAPI.

 Questions/suggestions...

 * I didn't include AHCI_MAX_SG change as it looked a bit more out of
   place w/ other changes to ahci gone.  Also, I'm curious about how
   meaningful increasing AHCI_MAX_SG is.  We're currently setting
   max_phys_segments to LIBATA_MAX_PRD, which is 128, and AFAIK max hw
   segments higher than phys segments is meaningless (phys segs are
   merged into hw segs and one phys segment cannot be splitted into
   two hw segs).  Am I missing something here?

 * About core routines/callbacks.  Currently, libata-core file
   contains actual libata core routines and all helper functions for
   taskfile controllers.  ata_ prefix is also shared by both function
   categories.  This is a bit confusing, IMO.

   I think ata_port_start should allocate stuff necessary for libata
   core and call ->port_start callback and similary for ata_port_stop,
   and current ata_port_start/stop need to be renamed to something
   like ata_tf_port_start/stop, such that we don't have to allocate
   data structures needed by libata core in specific drivers (ahci in
   this case).

 I've tested both sg and non-sg paths with sg_test_rwbuf.  When
testing sg path, I've commented out sg.c:L1951 (sg_build_indirect:L10)
to prevent it padding transfer size to 512byte boundary.  Read/write
padding in both paths work.

 Two patches will follow this mail.  The first one fixes sata_sx4 as
mentioned above and the second implements atapi align.

 Thanks.

--
tejun
