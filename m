From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [0/21] Remove SCSI unchecked_isa_dma try 3
Date: Thu,  2 Oct 2008 09:58:38 +0200 (CEST)
Message-ID: <20081002958.641114646@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:57070 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbYJBH6l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2008 03:58:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, axboe@kernel.dk


This reposts the patchkit to remove unchecked_isa_dma which was already
discussed some time ago. Instead it replaces it with interfaces
that declare the mask. Right now those interfaces map back to GFP_DMA
eventually, but it is a preparation for using the DMA mask allocator
eventually.

The previous time there were some disagreement on where to handle
the sense buffer bouncing which was done in low level drivers 
in Boaz' version of the patchkit. I went back to the original
code which keeps sense buffer bouncing in the mid layer, which
should be non controversal.

I also removed blk_kmalloc and went back to the blk_q_mask() interfaces.

I believe there were no other controversies, so this should be ready
for merging now.

Other main changes was to forward port it to 2.6.27rc8 and doing some 
retesting.

The changes are also available for pulling from

  git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc-2.6 scsi-dma

Andi Kleen (21):
      SCSI-ISA-DMA: Add the alloc/get_pages_mask calls
      SCSI-ISA-DMA: Add blk_q_mask
      SCSI-ISA-DMA: Pass gfp to scsi_allocate_command
      SCSI-ISA-DMA: Add sense_buffer_isa to host template
      SCSI-ISA-DMA: Remove unchecked_isa in BusLogic
      SCSI-ISA-DMA: Remove unchecked_isa_dma in advansys.c
      SCSI-ISA-DMA: Remove unchecked_isa_dma in gdth
      SCSI-ISA-DMA: Remove unchecked_isa_dma in eata.c
      SCSI-ISA-DMA: Remove unchecked_isa_dma in aha1542
      SCSI-ISA-DMA: Remove unchecked_isa_dma in aha152x/wd7000/sym53c416/u14-34f/NCR53c406a
      SCSI-ISA-DMA: Remove GFP_DMA uses in st/osst
      SCSI-ISA-DMA: Remove unchecked_isa_dma support for hostdata
      SCSI-ISA-DMA: Use blk_q_mask/get_pages_mask in sg driver
      SCSI-ISA-DMA: Rely on block layer bouncing for ISA DMA devices scanning
      SCSI-ISA-DMA: Don't disable direct_io for unchecked_isa_dma in st.c
      SCSI-ISA-DMA: Remove automatic block layer bouncing for unchecked_isa_dma
      SCSI-ISA-DMA: Remove GFP_DMA use in sr.c
      SCSI-ISA-DMA: Remove unchecked_isa_dma from sysfs
      SCSI-ISA-DMA: Switch to a single SCSI command pool
      SCSI-ISA-DMA: Finally kill unchecked_isa_dma
      SCSI-ISA-DMA: Convert DMA buffers in ch.c to allocate via the block layer

 Documentation/scsi/scsi_mid_low_api.txt |    4 +-
 drivers/scsi/BusLogic.c                 |   77 +++++++++++----
 drivers/scsi/NCR53c406a.c               |    8 ++-
 drivers/scsi/advansys.c                 |  162 ++++++++++++++++++++-----------
 drivers/scsi/aha152x.c                  |   29 +++++-
 drivers/scsi/aha1542.c                  |   40 ++++++--
 drivers/scsi/ch.c                       |   16 ++-
 drivers/scsi/eata.c                     |   54 ++++++++---
 drivers/scsi/gdth.c                     |   81 ++++++++++++----
 drivers/scsi/hosts.c                    |    5 +-
 drivers/scsi/osst.c                     |   24 ++---
 drivers/scsi/osst.h                     |    2 -
 drivers/scsi/scsi.c                     |   93 +++++++++++-------
 drivers/scsi/scsi_lib.c                 |    2 -
 drivers/scsi/scsi_scan.c                |    6 +-
 drivers/scsi/scsi_sysfs.c               |    2 -
 drivers/scsi/sg.c                       |   48 +++-------
 drivers/scsi/sr.c                       |    2 +-
 drivers/scsi/sr_ioctl.c                 |   13 +--
 drivers/scsi/sr_vendor.c                |    4 +-
 drivers/scsi/st.c                       |   37 +++----
 drivers/scsi/st.h                       |    2 -
 drivers/scsi/sym53c416.c                |    9 ++-
 drivers/scsi/u14-34f.c                  |   54 ++++++++---
 drivers/scsi/ultrastor.c                |   13 ++-
 drivers/scsi/wd7000.c                   |   48 ++++++---
 include/linux/blkdev.h                  |    5 +
 include/linux/gfp.h                     |   22 ++++-
 include/scsi/scsi_cmnd.h                |    5 +-
 include/scsi/scsi_host.h                |   14 ++-
 30 files changed, 569 insertions(+), 312 deletions(-)



