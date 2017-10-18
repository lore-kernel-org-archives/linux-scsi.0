From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH V8 5/5] libata: Align DMA buffer to
 dma_get_cache_alignment()
Date: Wed, 18 Oct 2017 06:03:53 -0700
Message-ID: <20171018130353.GA1302522@devbig577.frc2.facebook.com>
References: <1508227542-13165-1-git-send-email-chenhc@lemote.com>
 <1508227542-13165-5-git-send-email-chenhc@lemote.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1508227542-13165-5-git-send-email-chenhc@lemote.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Huacai Chen <chenhc@lemote.com>
Cc: Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Fuxin Zhang <zhangfx@lemote.com>, linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>, James Hogan <james.hogan@imgtec.com>, linux-mips@linux-mips.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 17, 2017 at 04:05:42PM +0800, Huacai Chen wrote:
> In non-coherent DMA mode, kernel uses cache flushing operations to
> maintain I/O coherency, so in ata_do_dev_read_id() the DMA buffer
> should be aligned to ARCH_DMA_MINALIGN. Otherwise, If a DMA buffer
> and a kernel structure share a same cache line, and if the kernel
> structure has dirty data, cache_invalidate (no writeback) will cause
> data corruption.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Huacai Chen <chenhc@lemote.com>
> ---
>  drivers/ata/libata-core.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index ee4c1ec..e134955 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -1833,8 +1833,19 @@ static u32 ata_pio_mask_no_iordy(const struct ata_device *adev)
>  unsigned int ata_do_dev_read_id(struct ata_device *dev,
>  					struct ata_taskfile *tf, u16 *id)
>  {
> -	return ata_exec_internal(dev, tf, NULL, DMA_FROM_DEVICE,
> -				     id, sizeof(id[0]) * ATA_ID_WORDS, 0);
> +	u16 *devid;
> +	int res, size = sizeof(u16) * ATA_ID_WORDS;
> +
> +	if (IS_ALIGNED((unsigned long)id, dma_get_cache_alignment(&dev->tdev)))
> +		res = ata_exec_internal(dev, tf, NULL, DMA_FROM_DEVICE, id, size, 0);
> +	else {
> +		devid = kmalloc(size, GFP_KERNEL);
> +		res = ata_exec_internal(dev, tf, NULL, DMA_FROM_DEVICE, devid, size, 0);
> +		memcpy(id, devid, size);
> +		kfree(devid);
> +	}
> +
> +	return res;

Hmm... I think it'd be a lot better to ensure that the buffers are
aligned properly to begin with.  There are only two buffers which are
used for id reading - ata_port->sector_buf and ata_device->id.  Both
are embedded arrays but making them separately allocated aligned
buffers shouldn't be difficult.

Thanks.

-- 
tejun
