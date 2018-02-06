From: Robin Murphy <robin.murphy-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH/RFC 4/6] mm: Add NO_DMA dummies for DMA pool API
Date: Tue, 6 Feb 2018 12:47:56 +0000
Message-ID: <61f0970a-c0aa-9b6f-74c7-d63be1e477ac@arm.com>
References: <1517912092-15470-1-git-send-email-geert@linux-m68k.org>
	<1517912092-15470-5-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1517912092-15470-5-git-send-email-geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Content-Language: en-GB
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
Cc: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Felipe Balbi <balbi-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "James E . J . Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Martin K . Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi Geert,

On 06/02/18 10:14, Geert Uytterhoeven wrote:
> Add dummies for dma{,m}_pool_{create,destroy,alloc,free}(), to allow
> compile-testing if NO_DMA=y.
> 
> This prevents the following from showing up later:
> 
>      ERROR: "dma_pool_destroy" [drivers/usb/mtu3/mtu3.ko] undefined!
>      ERROR: "dma_pool_free" [drivers/usb/mtu3/mtu3.ko] undefined!
>      ERROR: "dma_pool_alloc" [drivers/usb/mtu3/mtu3.ko] undefined!
>      ERROR: "dma_pool_create" [drivers/usb/mtu3/mtu3.ko] undefined!
>      ERROR: "dma_pool_destroy" [drivers/scsi/hisi_sas/hisi_sas_main.ko] undefined!
>      ERROR: "dma_pool_free" [drivers/scsi/hisi_sas/hisi_sas_main.ko] undefined!
>      ERROR: "dma_pool_alloc" [drivers/scsi/hisi_sas/hisi_sas_main.ko] undefined!
>      ERROR: "dma_pool_create" [drivers/scsi/hisi_sas/hisi_sas_main.ko] undefined!
>      ERROR: "dma_pool_alloc" [drivers/mailbox/bcm-pdc-mailbox.ko] undefined!
>      ERROR: "dma_pool_free" [drivers/mailbox/bcm-pdc-mailbox.ko] undefined!
>      ERROR: "dma_pool_create" [drivers/mailbox/bcm-pdc-mailbox.ko] undefined!
>      ERROR: "dma_pool_destroy" [drivers/mailbox/bcm-pdc-mailbox.ko] undefined!
> 
> Signed-off-by: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
> ---
>   include/linux/dmapool.h | 21 +++++++++++++++++++--
>   1 file changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/dmapool.h b/include/linux/dmapool.h
> index 53ba737505df31c7..adeb5e56c3ad73a8 100644
> --- a/include/linux/dmapool.h
> +++ b/include/linux/dmapool.h
> @@ -16,6 +16,7 @@
>   
>   struct device;
>   
> +#ifdef CONFIG_HAS_DMA
>   struct dma_pool *dma_pool_create(const char *name, struct device *dev,
>   			size_t size, size_t align, size_t allocation);
>   
> @@ -23,6 +24,17 @@ void dma_pool_destroy(struct dma_pool *pool);
>   
>   void *dma_pool_alloc(struct dma_pool *pool, gfp_t mem_flags,
>   		     dma_addr_t *handle);
> +void dma_pool_free(struct dma_pool *pool, void *vaddr, dma_addr_t addr);
> +#else /* !CONFIG_HAS_DMA */
> +static inline struct dma_pool *dma_pool_create(const char *name,
> +	struct device *dev, size_t size, size_t align, size_t allocation)
> +{ return NULL; }
> +static inline void dma_pool_destroy(struct dma_pool *pool) { }
> +static inline void *dma_pool_alloc(struct dma_pool *pool, gfp_t mem_flags,
> +				   dma_addr_t *handle) { return NULL; }
> +static inline void dma_pool_free(struct dma_pool *pool, void *vaddr,
> +				 dma_addr_t addr) { }
> +#endif /* !CONFIG_HAS_DMA */
>   
>   static inline void *dma_pool_zalloc(struct dma_pool *pool, gfp_t mem_flags,
>   				    dma_addr_t *handle)
> @@ -30,14 +42,19 @@ static inline void *dma_pool_zalloc(struct dma_pool *pool, gfp_t mem_flags,
>   	return dma_pool_alloc(pool, mem_flags | __GFP_ZERO, handle);
>   }
>   
> -void dma_pool_free(struct dma_pool *pool, void *vaddr, dma_addr_t addr);
> -
>   /*
>    * Managed DMA pool
>    */
> +#ifdef CONFIG_HAS_DMA
>   struct dma_pool *dmam_pool_create(const char *name, struct device *dev,
>   				  size_t size, size_t align, size_t allocation);
>   void dmam_pool_destroy(struct dma_pool *pool);
> +#else /* !CONFIG_HAS_DMA */
> +static inline struct dma_pool *dmam_pool_create(const char *name,
> +	struct device *dev, size_t size, size_t align, size_t allocation)
> +{ return NULL; }
> +static inline void dmam_pool_destroy(struct dma_pool *pool) { }
> +#endif /* !CONFIG_HAS_DMA */

Nit: It might be tidier to add *all* the stubs down here so that there 
only need be a single #ifdef, then move the dma_pool_zalloc definition 
outside at the end (where we might eventually get rid of it anyway).

Other than that, though, I think I agree with the series in general - 
more COMPILE_TEST is always good from the point of view of weeding out 
drivers using architecture-specific DMA API internals which aren't part 
of the proper generic interface.

Robin.

>   
>   #endif
>   
> 
