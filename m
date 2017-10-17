From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH V8 5/5] libata: Align DMA buffer to
 dma_get_cache_alignment()
Date: Tue, 17 Oct 2017 12:43:22 +0300
Message-ID: <94f55c1e-7553-0fc8-124e-ac6df5ac10ce@cogentembedded.com>
References: <1508227542-13165-1-git-send-email-chenhc@lemote.com>
 <1508227542-13165-5-git-send-email-chenhc@lemote.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1508227542-13165-5-git-send-email-chenhc@lemote.com>
Content-Language: en-US
Sender: linux-ide-owner@vger.kernel.org
To: Huacai Chen <chenhc@lemote.com>, Christoph Hellwig <hch@lst.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Fuxin Zhang <zhangfx@lemote.com>, linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>, James Hogan <james.hogan@imgtec.com>, linux-mips@linux-mips.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/17/2017 11:05 AM, Huacai Chen wrote:

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
>   drivers/ata/libata-core.c | 15 +++++++++++++--
>   1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index ee4c1ec..e134955 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -1833,8 +1833,19 @@ static u32 ata_pio_mask_no_iordy(const struct ata_device *adev)
>   unsigned int ata_do_dev_read_id(struct ata_device *dev,
>   					struct ata_taskfile *tf, u16 *id)
>   {
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

    This function is called only for the PIO mode commands, so I doubt this is 
necessary...

MBR, Sergei
