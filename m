From: "Bagalkote, Sreenivas" <sreenib@lsil.com>
Subject: RE: [ANNOUNCE][PATCH 2.6.11 2/3] megaraid_sas: Announcing new mod
	 ule  for LSI Logic's SAS based MegaRAID controllers
Date: Wed, 9 Mar 2005 18:56:02 -0500
Message-ID: <0E3FA95632D6D047BA649F95DAB60E570230CC23@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: 'Arjan van de Ven' <arjan@infradead.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, 'James Bottomley' <James.Bottomley@SteelEye.com>, "'Matt_Domsch@Dell.com'" <Matt_Domsch@Dell.com>, Andrew Morton <akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org

>> >
>> >Even for kernels with a 64bit dma_addr_t you can get 32bit dma 
>> >addresses
>> >only.  As a start check whether the pci_set_dma_mask for 
>the 64bit mask
>> >failed - in that case you can always use 32bit SGLs.
>> >
>> 
>> Please help me understand: If dma_addr_t is 64 bit, I will get 64bit 
>> addresses in scatterlist regardless the outcome of pci_set_dma_mask, 
>> won't I? These addresses may have valid or null high 
>addresses. My idea
>> was to have 32(64) bit SGLs for 32(64) bit dma_addr_t.
>
>if pci_set_dma_mask for the 64bit mask fails the upper 32bit bit of
>dma_addr_t will guaranteed to be zero, so you don't need to take them
>into account for your hardware SGL.
>

Okay. I understood. Thanks. But please consider this also:

Arjan pointed out that by basing my 32/64 SGL decision solely on
#define IS_DMA64 sizeof(dma_addr_t)==8, I can rely on gcc to optimize the
unused portion of the code away. If I take pci_set_dma_mask also into
account, I can't do that, can I?

Thanks,
Sreenivas
