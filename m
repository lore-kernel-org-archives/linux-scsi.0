From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [0/21] Remove isa_unchecked_dma and some more GFP_DMAs in the mid layer v5
Date: Sun, 16 Nov 2008 00:11:00 +0100 (CET)
Message-ID: <200811161211.212948789@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:44165 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147AbYKOXLB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Nov 2008 18:11:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, axboe@kernel.dk, linux-scsi@vger.kernel.org


[repost of the earlier patch kit, ported to 2.6.28rc4. Was acked
by axboe earlier]
[Can this be considered for .29 please? This is the older origial 
 patchkit which was relatively uncontroversal before the mid layer 
 sense buffer and with blk_*alloc* changes removed.]

v2: various cleanups, use dma_alloc_coherent instead of naked GFP_DMA
    add blk_* allocators to avoid bouncing in SCSI scan
v3: Remove cmnd/sense buffer bouncing in advansys. 
    Replace sense_buffer_mask with a single bit
v4: this is the original patchkit which was relatively uncontroversal
    without any sense buffer changes.
    Just forward ported to a 2.6.26-rc8 tree.
v5: Ported to 2.6.28rc4

Original description:

This patchkit fixes all existing drivers that used isa_unchecked_dma
to not need that anymore.  I have some upcoming infrastructure changes 
for DMA memory management and isa_unchecked_dma was in the way.

Enabling isa_unchecked_dma had several effects:
- All incoming scsi_cmnds were in GFP_DMA memory.
Only one driver relied on that actually (advansys), the others all accessed
the scsi_cmnds only with the CPU.
- scsi hostdata is allocated with GFP_DMA
A lot of drivers relied on that. I converted them all to allocate hostdata
in a separate buffer linked to rom the scsi host structure.
- Enabling block layer bouncing for all data. That's the most important one.
I changed all drivers to do that directly instead of relying on the mid
layer for it.
- sense_buffer is allocated with GFP_DMA. That was also commonly
required and not easy to fix so I created a separate host template
field that enables sense_buffer bouncing.

Also while I was it I removed also a lot of GFP_DMAs in the frontend
drivers which are not needed anymore because the block layer does
the bouncing for all data anyways. Or rather we ask the block layer
now to bounce.

The main problem of the patchkit is that is that I wasn't able
to test the drivers because I don't have any of the hardware. All
changes (except perhaps advansys) were relatively simple and straight
forward so I don't expect many problems though.

If anybody has any of these ISA SCSI adapters and would be willing to test
them with these patches that would be appreciated.
I suspect actually that some of the ISA drivers are actually already
bitrotted independently of these changes. Hopefully they won't make
anything worse though. 

Patches against 2.6.28rc4

Also available as a git tree at

The following changes since commit 9bf1a2445f3c569098b8de7097ca324e65abecc2:
  Linus Torvalds (1):
        Linux 2.6.28-rc5

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc-2.6 scsi-dma

Andi Kleen (21):
      Add the alloc/get_pages_mask calls
      Add blk_q_mask
      Pass gfp to scsi_allocate_command
      Add sense_buffer_isa to host template
      Remove unchecked_isa in BusLogic
      Remove unchecked_isa_dma in advansys.c
      Remove unchecked_isa_dma in gdth
      Remove unchecked_isa_dma in eata.c
      Remove unchecked_isa_dma in aha1542
      Remove unchecked_isa_dma in aha152x/wd7000/sym53c416/u14-34f/NCR53c406a
      Remove GFP_DMA uses in st/osst
      Remove unchecked_isa_dma support for hostdata
      Use blk_q_mask/get_pages_mask in sg driver
      Rely on block layer bouncing for ISA DMA devices scanning
      Don't disable direct_io for unchecked_isa_dma in st.c
      Remove automatic block layer bouncing for unchecked_isa_dma
      Remove GFP_DMA use in sr.c
      Remove unchecked_isa_dma from sysfs
      Switch to a single SCSI command pool
      Finally kill unchecked_isa_dma
      Convert DMA buffers in ch.c to allocate via the block layer

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
 drivers/scsi/sg.c                       |   36 ++------
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
 include/scsi/sg.h                       |    1 -
 31 files changed, 564 insertions(+), 306 deletions(-)

-Andi
