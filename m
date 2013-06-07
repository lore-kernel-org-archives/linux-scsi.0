From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 0/3] [SCSI] megaraid: Remove local (struct pci_dev) pdev's
Date: Fri, 07 Jun 2013 10:23:29 -0600
Message-ID: <20130607162329.11205.95093.stgit@amt.stowe>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: megaraidlinux@lsi.com, JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

While the megaraid device itself may be 64-bit DMA capable, 32-bit address
restricted DMA buffers are apparently required for "internal commands" as
is denoted by a couple of comments - "For all internal commands, the
buffer must be allocated in <4GB address range" - within the driver.

If the device is 64-bit DMA capable then, once it is setup, any subsequent
DMA allocations for "internal commands" would not be properly restricted
due to megaraid_probe_one() having called pci_set_dma_mask() on pdev with
DMA_BIT_MASK(64).  The driver attempts to solve this by using
make_local_pdev() to dynamically create local pci_dev structures which are
then set and used for allocating 32-bit address space restricted DMA
buffers[1] but I don't believe that the implementation works as intended.


Assume that the megaraid device is 64-bit DMA capable.  While probing the
device and attaching the megaraid driver, pci_set_dma_mask() is called
with the "originating pdev" and a DMA_BIT_MASK of 64.  As a result, any
subsequent dynamic DMA related allocations associated with the
"originating pdev" will acquire 64-bit based buffers, which do not meet
the addressing restrictions for internal commands.

  megaraid_probe_one(struct pci_dev *pdev, ...)
      ...
      pci_set_dma_mask(pdev, DMA_BIT_MASK(64));

As mentioned, the driver attempts to solve this by using make_local_pdev()
to dynamically create local pci_dev structures - "local pdev's" - which
are set with a DMA_BIT_MASK of 32.

  make_local_pdev
      alloc_pci_dev
      memcpy
      pci_set_dma_mask
          dma_set_mask
              *dev->dma_mask = mask;

The "local pdev" is then used in allocating a DMA buffer in an attempt to
meet the < 4 GB restriction.

For a 64-bit DMA capable device, the "originating pdev" will have its
'dma_mask' set to 0xffffffffffffffff after the driver attaches.
Subsequently, when an internal command is initiated, make_local_pdev() is
called.  make_local_pdev() uses the PCI's core to allocate a "local pdev"
and then copies the "originating pdev" content into the newly allocated
"local pdev".  As a result of copying the "originating pdev" content into
the "local pdev", pdev->dev.dma_mask will be pointing back to the
"originating pdev's" 'dma_mask' member, not the "local pdev's" as
intended.  Thus, when make_local_pdev() calls pci_set_dma_mask() in an
attempt to set the "local pdev's" DMA mask to 32 it will instead overwrite
the "originating pdev's" DMA mask.  Thus, after any user initiated
commands are issued, all subsequent DMA allocations will be 32-bit
restricted from that point onward regardless of whether they are internal
commands or otherwise.


This patch fixes the issue by removing the setup of DMA_BIT_MASK to 64 in
megaraid_probe_one(), leaving the driver with default 32-bit DMA
capabilities, as it currently ends up in such a state anyway after any
internal commands are initiated.


[1] It seems strange that both mega_buffer/buf_dma_handle and
    make_local_pdev() both exist for internal commands but this has been
    the case for a long time - at least since 2.6.12-rc2.  Perhaps there
    is some coalescing that could be done.
---

Myron Stowe (3):
      [SCSI] megaraid: Remove 64-bit DMA related dead code
      [SCSI] megaraid: Remove local (struct pci_dev) pdev's
      [SCSI] megaraid: Remove 64-bit DMA_BIT_MASK capability


 drivers/scsi/megaraid.c |  152 ++++++++---------------------------------------
 drivers/scsi/megaraid.h |    1 
 2 files changed, 27 insertions(+), 126 deletions(-)

-- 
