From: Alex Williamson <alex.williamson@hp.com>
Subject: mpt sets 64bit consistent mask yet requires mapping in same 4GB
	chunk?!?
Date: Fri, 13 Feb 2004 09:12:05 -0700
Sender: linux-ia64-owner@vger.kernel.org
Message-ID: <1076688724.2462.16.camel@patsy.fc.hp.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ia64-owner@vger.kernel.org>
To: Emoore@lsil.com
Cc: linux-scsi@vger.kernel.org, linux-ia64@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Eric,

   I think I found a bug in the version 3.00.02 mpt driver that's
currently in Linus' 2.6 tree (latest linux-2.5).  Here's the code
snippet:

message/fusion/mptbase.c: PrimeIocFifos()
...
    if (sizeof(dma_addr_t) == sizeof(u64)) {
        /* Check: upper 32-bits of the request and reply frame
         * physical addresses must be the same.
         */
        if (((u64)ioc->req_frames_dma >> 32) != ((u64)ioc->reply_frames_dma >> 32)){
            goto out_fail;
    }

req_frames_dma and reply_frames_dma are aligned version of dma addresses
retrieved via two separate pci_alloc_consistent() calls.  The mpt driver
sets a 64bit consistent dma mask.  How is it reasonable to assume two
separate mappings will fall within the same 4GB chunk of memory?  I
recently added support for consistent mapping bypass in the sba_iommu
driver for the ia64 zx1 chipset.  Randomly on bootup, the MPT driver
fails.  Checking the mappings, I get a things like this:

mptbase: Initiating ioc0 bringup
ioc0: 53C1030: Capabilities={Initiator}
sba_alloc_coherent() bypassing, dma_handle: 0x1fffb8000, addr: 0xe0000001fffb8000
sba_alloc_coherent() bypassing, dma_handle: 0x40ffcd8000, addr: 0xe0000040ffcd8000
PrimeIocFifos() req_frames_dma: 0x40ffcd8000, reply_frames_dma: 0x1fffb8000
mptbase: WARNING - ioc0 did not initialize properly! (-3)

These are two perfectly valid consistent mappings as far as the platform
code is concerned.  I think mpt really needs to either set a 32bit
consistent map of do a single allocation when it requires this type of
thing.  Thanks,

	Alex

-- 
Alex Williamson                             HP Linux & Open Source Lab

