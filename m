From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] ipr: don't doublefree pages from scatterlist
Date: Mon, 06 Feb 2006 13:49:39 -0800 (PST)
Message-ID: <20060206.134939.130100576.davem@davemloft.net>
References: <43E7613B.5060706@us.ibm.com>
	<Pine.LNX.4.61.0602061621450.3560@goblin.wat.veritas.com>
	<200602062211.29993.ak@suse.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dsl027-180-168.sfo1.dsl.speakeasy.net ([216.27.180.168]:29602
	"EHLO sunset.davemloft.net") by vger.kernel.org with ESMTP
	id S932190AbWBFVtu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Feb 2006 16:49:50 -0500
In-Reply-To: <200602062211.29993.ak@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ak@suse.de
Cc: hugh@veritas.com, brking@us.ibm.com, James.Bottomley@steeleye.com, akpm@osdl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

From: Andi Kleen <ak@suse.de>
Date: Mon, 6 Feb 2006 22:11:29 +0100

> Don't touch the non DMA members in the sg list in dma_map_sg in the IOMMU
> 
> Some drivers (in particular ipr) ran into problems because they
> reused the sg lists after passing them to pci_map_sg(). The merging
> procedure in the K8 GART IOMMU corrupted the state. This patch
> changes it to only touch the dma* entries during merging,
> but not the other fields.  Approach suggested by Dave Miller.
> 
> I did some basic tests with CONFIG_IOMMU_DEBUG (LTP, large dd) 
> and without and it hold up, but needs more testing.
> 
> Signed-off-by: Andi Kleen <ak@suse.de>

Thanks for doing this work Andi.
