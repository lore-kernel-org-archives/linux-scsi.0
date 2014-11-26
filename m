From: David Miller <davem@davemloft.net>
Subject: Re: [hch-scsi-queue:drivers-for-3.19 174/180]
 drivers/scsi/wd719x.c:247:2: error: implicit declaration of function
 'dma_cache_sync'
Date: Wed, 26 Nov 2014 15:28:06 -0500 (EST)
Message-ID: <20141126.152806.2107730733530527276.davem@davemloft.net>
References: <20141126102843.GB23189@lst.de>
	<201411261832.48201.linux@rainbow-software.org>
	<20141126191309.GA32112@lst.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:50449 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbaKZU2K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Nov 2014 15:28:10 -0500
In-Reply-To: <20141126191309.GA32112@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@lst.de
Cc: linux@rainbow-software.org, fengguang.wu@intel.com, kbuild-all@01.org, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org, arnd@arndb.de

From: Christoph Hellwig <hch@lst.de>
Date: Wed, 26 Nov 2014 20:13:09 +0100

> On Wed, Nov 26, 2014 at 06:32:48PM +0100, Ondrej Zary wrote:
>> wd819x should probably depend on VIRT_TO_BUS? But that means it will not work 
>> on sparc. Is there a way to make it work? I have a sparc machine but haven't 
>> tested it.
> 
> The explanation from Arnd in the other thread makes more sense -
> dma_cache_sync only is for non-coherent allocations so we should be
> able to remove it entirely.  Can you prepare and test a patch to just remove
> it for me?

Since dma_alloc_noncoherent is simply dma_alloc_coherent on sparc, I can
simply implement dma_cache_sync() as a nop.

I'll do that right now.

I also agree that if wd719x is not using dma_alloc_noncoherent(), it
should not be calling dma_cache_sync().
