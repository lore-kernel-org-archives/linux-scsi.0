From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/5] scsi: megaraid_sas - preallocate memory for ioctl processing
Date: Thu, 8 Feb 2007 19:38:27 +0000
Message-ID: <20070208193827.GA2354@infradead.org>
References: <1170800394.10482.41.camel@dumbo> <20070207133020.4c58e271.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:41095 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423280AbXBHTie (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Feb 2007 14:38:34 -0500
Content-Disposition: inline
In-Reply-To: <20070207133020.4c58e271.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sumant Patro <sumantp@lsil.com>, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, neela.kolli@lsi.com, bo.yang@lsi.com, sumant.patro@lsi.com

On Wed, Feb 07, 2007 at 01:30:20PM -0800, Andrew Morton wrote:
> On Tue, 06 Feb 2007 14:19:54 -0800
> Sumant Patro <sumantp@lsil.com> wrote:
> 
> > Preallocate memory for ioctl processing. This is to avoid situations 
> > where ioctl fails for lack of memory (when system under heavy stress).
> > The memory pool will have 8*4K, 4*8K and 1*64K memory chunks
> 
> mutter.
> 
> I suspect all this horror is due to stupidity in the DMA API.
> 
> pci_alloc_consistent() just goes and assumes GFP_ATOMIC, whereas
> the caller (megasas_mgmt_fw_ioctl) would have been perfectly happy
> to use GFP_KERNEL.
> 
> I bet this fixes it:

but it's ugly as hell, why there is a much more trivial fix for it:
simply use dma_alloc_coherent.

