From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: [ANNOUNCE][PATCH 2.6.11 2/3] megaraid_sas: Announcing new mod ule  for LSI Logic's SAS based MegaRAID controllers
Date: Wed, 9 Mar 2005 22:03:35 +0000
Message-ID: <20050309220335.GA9350@infradead.org>
References: <0E3FA95632D6D047BA649F95DAB60E570230CC1C@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from pentafluge.infradead.org ([213.146.154.40]:6792 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261951AbVCIWDn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Mar 2005 17:03:43 -0500
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E570230CC1C@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bagalkote, Sreenivas" <sreenib@lsil.com>
Cc: 'Arjan van de Ven' <arjan@infradead.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, 'James Bottomley' <James.Bottomley@SteelEye.com>, "'Matt_Domsch@Dell.com'" <Matt_Domsch@Dell.com>, Andrew Morton <akpm@osdl.org>, 'Christoph Hellwig' <hch@infradead.org>

On Wed, Mar 09, 2005 at 09:43:47AM -0500, Bagalkote, Sreenivas wrote:
> During the module load time, I allocate 32 bit or 64 bit SGLs based on
> whether I can receive 64 bit DMA addresses or not. If size of dma_addr_t
> is 4, then I allocate only 32 bit SGLs. During the run time, I prepare 
> 32/64 bit SGLs based on this variable. And since this is compile time
> system-wide property, I kept it as driver global.

Even for kernels with a 64bit dma_addr_t you can get 32bit dma addresses
only.  As a start check whether the pci_set_dma_mask for the 64bit mask
failed - in that case you can always use 32bit SGLs.
