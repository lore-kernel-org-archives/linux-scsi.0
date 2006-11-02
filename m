From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: unchecked_isa_dma and BusLogic SCSI controller
Date: Wed, 1 Nov 2006 17:33:58 -0800
Message-ID: <20061101173358.7b027d13.randy.dunlap@oracle.com>
References: <20061101235330.GA30843@srv.junsun.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:43674 "EHLO
	agminet01.oracle.com") by vger.kernel.org with ESMTP
	id S1751477AbWKBBiT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Nov 2006 20:38:19 -0500
In-Reply-To: <20061101235330.GA30843@srv.junsun.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jun Sun <jsun@junsun.net>
Cc: linux-scsi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>

On Wed, 1 Nov 2006 15:53:30 -0800 Jun Sun wrote:

> 
> Can someone enlighten me on what "unchecked_isa_dma" means in the
> struct scsi_host_template?

It's documented in Documentation/scsi/scsi_mid_low_api.txt:

    unchecked_isa_dma - 1=>only use bottom 16 MB of ram (ISA DMA addressing
                   restriction), 0=>can use full 32 bit (or better) DMA
                   address space

> Specifically why Bus_Logic_template has
> it set to 1?

maybe ask on linux-scsi@vger.kernel.org (cc-ed)

> I am trying to reserve a block of memory (>16MB) starting from 0 and hide
> it from kernel.  As a result, the DMA zone becomes 0 in size.
> 
> Because Bus_Logic_template has unchecked_isa_dma set to 1, the driver
> will attempt to allocate a block of memory from DMA zone and thus
> causes OOMs during its initialization.
> 
> It is hard for me to see why BusLogic controller would only do DMA
> in low 16MB.  Is there a fix for this?

Does anyone know that controller hardware and its limitations?

If the driver can't handle highmem addresses, you could just change
it so that
(a) it does not set unchecked_isa_dma
(b) it sets .slave_alloc in the host template and then does
like the <slave_alloc> function in ppa.c or imm.c:
call blk_queue_bounce_limit() to set an address for which bounce
buffers (from highmem to lowmem) will be used.
[I don't guarantee that to work for BusLogic.]

> BTW, I also tried to increase MAX_DMA_ADDRESS to cover the whole memory
> area.  While the OOMs are gone during BusLogic driver initialization, 
> kernel fails to find labelled root partition or fail to open
> the initial console.  It appears the disk (or the scsi) is not working
> properly after increasing MAX_DMA_ADDRESS.
> 
> My platform is vmplayer.  Pretty cool for devel.
> 
> Cheers.
> 
> Jun

---
~Randy
