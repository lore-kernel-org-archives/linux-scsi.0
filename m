From: Matthew Wilcox <matthew@wil.cx>
Subject: sym2 version 2.2.0
Date: Fri, 11 Mar 2005 20:21:57 +0000
Message-ID: <20050311202157.GR21986@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:65185 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261317AbVCKUV7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Mar 2005 15:21:59 -0500
Received: from willy by parcelfarce.linux.theplanet.co.uk with local (Exim 4.33)
	id 1D9qdx-0006UI-QJ
	for linux-scsi@vger.kernel.org; Fri, 11 Mar 2005 20:21:57 +0000
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


The patch is almost 200k, so I shall save you the bandwidth and not
post it here.  As I've mentioned before, I develop it in the PA-RISC
CVS tree which you can view here:
http://cvs.parisc-linux.org/linux-2.6/drivers/scsi/sym53c8xx_2/

You can download the full patch from
http://www.parisc-linux.org/~willy/sym2-2.2.0.diff
and I've sent the whole thing to James as a separate email.

Even just the changelog is pretty lengthy:

Sym2 version 2.2.0:

Docs
 - The sym53c8xx= kernel parameter no longer exists
 - Correct a typo

Bugfixes
 - The driver really isn't capable of dealing with 64-bit bus addresses
   yet, so bail out early
 - Get rid of SYM_SCAN_TARGETS_HILO (which had no effect) and set the
   shost->reverse_ordering flag instead
 - Associate a scsi_device with the target in slave_alloc instead of
   slave_configure

Printk cleanups
 - Use dev_warn/dev_info where possible
 - Delete PRINT_ADDR, PRINT_TARGET and PRINT_LUN
 - Remove sym_print_target() and sym_print_lun()
 - Make sym_print_addr() call dev_info

Memory allocation related
 - Delete non-dma allocators; use kmalloc/kcalloc directly instead
 - Move memory allocation wrappers from sym_glue to sym_malloc
 - Get rid of m_addr_t; use void * or dma_addr_t as appropriate
 - Change m_pool_ident_t from a struct pci_dev * to a struct device *
 - Use dma_alloc_coherent() instead of pci_alloc_consistent()

Negotiation related
 - Move scsi_transport_spi.h include from sym_glue.c to sym_glue.h
 - Store the current transfer contract settings in the starget attributes
 - Delete sym2_get_offset(), sym2_get_period(), sym2_get_width(),
   sym2_get_dt(), sym2_get_iu() and sym2_get_qas() 
 - Use spi_support_wide() (and friends) instead of scsi_device_wide()
 - We don't need tinfo.prev -- we can tell if the contract changed
 - Delete SYM_OPT_ANNOUNCE_TRANSFER_RATE
 - Use spi_display_xfer_agreement()
 - Use sdev->scsi_level instead of the never-set tinfo.curr.scsi_version
 - Instead of checking current xfer settings against our goal, use a
   check_nego flag.
 - Get rid of sym_tinfo and use sym_trans directly.
 - Split the sym_trans options into flags
 - Change width from an u8 into a flag
 - Delete sym_misc.c
 - Remove sym_xpt_async_nego_wide

Linuxisation
 - Use udelay() directly instead of indirecting through UDELAY and sym_udelay
 - Rename some scsi_cmnd pointers from ccb or csio to cmd
 - Use simple_strtoul() instead of a handwritten parser
 - SKIP_SPACES was always being used with 1 as a parameter, and was implicitly
   modifying ptr and len.
 - GET_INT_ARG was doing the same with ptr and len.
 - Use pci_iomap(), pci_iounmap(), ioread8() et al
 - Delete the sym_data_dmamap_*() macros
 - Replace SYM_CONF_IOMAPPED with CONFIG_SCSI_SYM53C8XX_IOMAPPED
 - Delete unused SYM_HAVE_SCCB, SYM_HAVE_M_SVTOB, SYM_HAVE_M_SPOOL

Misc cleanup
 - Move sym_conf.h into sym53c8xx.h
 - Eliminate the unused SYM_SETUP_MAX_LUN, SYM_SCMD_PTR
 - SYM_SETUP_PCI_PARITY and SYM_SETUP_SCSI_PARITY are always defined; simplify
 - Rename sym_pci_chip to sym_chip
 - Write sym_get_hcb() to hide nasty macro abuse
 - sym_lp() doesn't need to take the sym_hcb as an argument
 - sym_get_ccb() works better if you give it the cmd instead of the id/lun
 - We don't use cmd->host_scribble, host->dma_channel, host->n_io_port,
   host->io_port, host->base or host->irq; stop initialising them.
 - sym_tune_dev_queuing() works better if you give it the tcb rather than
   the hcb and target
 - Get rid of sym_driver_name(), just use SYM_DRIVER_NAME directly
 - OUTB/INB/etc macros implicitly use the hcb pointer; pass it explictly instead
 - Map the BARs early instead of mapping and unmapping them as necessary
 - Automatically fall back to ioport accesses if iomem isn't available
 - Get rid of tcb_p, lcb_p and ccb_p typedefs
 - Delete support for big endian chips -- 8xx chips can't be in BE mode
 - Inline sym_slot into sym_device
 - Inline sym_printb_hex() into sym_printl_hex()
 - Don't cast function return values to void
 - Introduce sym_nvram_type()
 - Pass the hcb and starget to sym_check_goals since we already have them
   in the caller
 - Some 0/NULL cleanup
 - Embed the sense buffer in the CCB so it doesn't need to be allocated
   separately

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
