From: CaT <cat@zip.com.au>
Subject: Re: [PATCH 4/5] scsi: megaraid_sas - preallocate memory for ioctl processing
Date: Thu, 16 Oct 2008 11:17:22 +1100
Message-ID: <20081016001721.GW19077@zip.com.au>
References: <1170800394.10482.41.camel@dumbo> <20070207133020.4c58e271.akpm@linux-foundation.org> <1170885734.3852.30.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nessie.weebeastie.net ([220.233.7.36]:42015 "EHLO
	bunyip.billabong.weebeastie.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752549AbYJPBHC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Oct 2008 21:07:02 -0400
Content-Disposition: inline
In-Reply-To: <1170885734.3852.30.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Sumant Patro <sumantp@lsil.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, neela.kolli@lsi.com, bo.yang@lsi.com, sumant.patro@lsi.com

With hope that resurrecting a 1.5yr old thread is not a wrong thing to
do...

On Wed, Feb 07, 2007 at 05:02:13PM -0500, James Bottomley wrote:
> On Wed, 2007-02-07 at 13:30 -0800, Andrew Morton wrote:
> > I suspect all this horror is due to stupidity in the DMA API.
> > 
> > pci_alloc_consistent() just goes and assumes GFP_ATOMIC, whereas
> > the caller (megasas_mgmt_fw_ioctl) would have been perfectly happy
> > to use GFP_KERNEL.
> > 
> > I bet this fixes it
> 
> It does, but the DMA API was expanded to cope with this exact case, so
> use dma_alloc_coherent() directly in the megaraid code instead.  The dev
> is just &pci_dev->dev.

I'm wondering if this was meant to lay this issue to rest. The reason
being that I just got this error last night during a period of high disk
and network IO (there was an over-the-network backup happening). dmesg
gives:

MegaCli: page allocation failure. order:0, mode:0x10d4

Call Trace:
 [<ffffffff80232c55>] printk_ratelimit+0x15/0x20
 [<ffffffff8026306f>] __alloc_pages+0x2ff/0x320
 [<ffffffff80212920>] dma_alloc_pages+0x20/0x90
 [<ffffffff80212a29>] dma_alloc_coherent+0x99/0x200
 [<ffffffff8043b859>] megasas_mgmt_ioctl_fw+0x1c9/0x450
 [<ffffffff8043bce8>] megasas_mgmt_ioctl+0x28/0x40
 [<ffffffff8028eff1>] do_ioctl+0x31/0x90
 [<ffffffff8028f0c3>] vfs_ioctl+0x73/0x2d0
 [<ffffffff8028f36a>] sys_ioctl+0x4a/0x80
 [<ffffffff8020bb3e>] system_call+0x7e/0x83

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 128   Cold: hi:   62, btch:  15 usd:  14
CPU    1: Hot: hi:  186, btch:  31 usd: 183   Cold: hi:   62, btch:  15 usd:  59
Active:322989 inactive:1073 dirty:168 writeback:7 unstable:0
 free:3894 slab:171815 mapped:3457 pagetables:4277 bounce:0
DMA free:6788kB min:16kB low:20kB high:24kB active:0kB inactive:0kB present:6148kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 1988 1988 1988
DMA32 free:8788kB min:5692kB low:7112kB high:8536kB active:1291956kB inactive:4292kB present:2035720kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 3*4kB 5*8kB 3*16kB 1*32kB 4*64kB 2*128kB 2*256kB 1*512kB 1*1024kB 0*2048kB 1*4096kB = 6788kB
DMA32: 804*4kB 19*8kB 34*16kB 37*32kB 0*64kB 1*128kB 0*256kB 1*512kB 1*1024kB 1*2048kB 0*4096kB = 8808kB
Swap cache: add 132711, delete 132711, find 496226/496957, race 0+0
Free swap  = 979400kB
Total swap = 979924kB
Free swap:       979400kB
524200 pages of RAM
14486 reserved pages
93705 pages shared
0 pages swap cached
megasas: Failed to alloc kernel SGL buffer for IOCTL
MegaCli[18889]: segfault at 0000000000000000 rip 00000000004ab9b5 rsp 00007fff48802c30 error 4

I was attempting to get the state of the raid array (monitoring for downed
drives, etc) with MegaCLI 2.00.11. This is with kernel 2.6.23.16.

-- 
  "Police noticed some rustling sounds from Linn's bottom area
  and on closer inspection a roll of cash was found protruding
  from Linn's anus, the full amount of cash taken in the robbery."
    - http://www.smh.com.au/news/world/robber-hides-loot-up-his-booty/2008/05/09/1210131248617.html
