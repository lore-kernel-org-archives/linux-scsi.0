From: Palmer Dabbelt <palmer@sifive.com>
Subject: Re: [PATCH 5/5] PCI: remove PCI_DMA_BUS_IS_PHYS
Date: Tue, 24 Apr 2018 11:23:16 -0700 (PDT)
Message-ID: <mhng-1f7fdc5e-bbef-409b-80cb-6a6bbb76eca4@palmer-si-x1c4>
References: <20180424181625.22410-6-hch@lst.de>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180424181625.22410-6-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org, linux-block@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 24 Apr 2018 11:16:25 PDT (-0700), Christoph Hellwig wrote:
> This was used by the ide, scsi and networking code in the past to
> determine if they should bounce payloads.  Now that the dma mapping
> always have to support dma to all physical memory (thanks to swiotlb
> for non-iommu systems) there is no need to this crude hack any more.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
> [...]
> diff --git a/arch/riscv/include/asm/pci.h b/arch/riscv/include/asm/pci.h
> index 0f2fc9ef20fc..b3638c505728 100644
> --- a/arch/riscv/include/asm/pci.h
> +++ b/arch/riscv/include/asm/pci.h
> @@ -26,9 +26,6 @@
>  /* RISC-V shim does not initialize PCI bus */
>  #define pcibios_assign_all_busses() 1
>
> -/* We do not have an IOMMU */
> -#define PCI_DMA_BUS_IS_PHYS 1
> -
>  extern int isa_dma_bridge_buggy;
>
>  #ifdef CONFIG_PCI

Thanks!

Acked-by: Palmer Dabbelt <palmer@sifive.com> (For the RISC-V change)
