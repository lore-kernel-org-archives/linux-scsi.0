From: Mark Greer <mgreer@animalcreek.com>
Subject: Re: [PATCH V8 1/5] dma-mapping: Rework dma_get_cache_alignment()
Date: Wed, 18 Oct 2017 10:23:36 -0700
Message-ID: <20171018172336.GA29358@animalcreek.com>
References: <1508227542-13165-1-git-send-email-chenhc@lemote.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1508227542-13165-1-git-send-email-chenhc@lemote.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Huacai Chen <chenhc@lemote.com>
Cc: Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Fuxin Zhang <zhangfx@lemote.com>, linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>, James Hogan <james.hogan@imgtec.com>, linux-mips@linux-mips.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, stable@vger.kernel.org, "Michael S . Tsirkin" <mst@mellanox.co.il>, Pawel Osciak <pawel@osciak.com>, Kyungmin Park <kyungmin.park@samsung.com>, Michael Chan <michael.chan@broadcom.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Ivan
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 17, 2017 at 04:05:38PM +0800, Huacai Chen wrote:
> Make dma_get_cache_alignment() to accept a 'dev' argument. As a result,
> it can return different alignments due to different devices' I/O cache
> coherency.
> 
> Currently, ARM/ARM64 and MIPS support coherent & noncoherent devices
> co-exist. This may be extended in the future, so add a new function
> pointer (i.e, get_cache_alignment) in 'struct dma_map_ops' as a generic
> solution.

Hi Huacai.

> diff --git a/drivers/tty/serial/mpsc.c b/drivers/tty/serial/mpsc.c
> index 67ffecc..c708457 100644
> --- a/drivers/tty/serial/mpsc.c
> +++ b/drivers/tty/serial/mpsc.c
> @@ -81,19 +81,19 @@
>   * Number of Tx & Rx descriptors must be powers of 2.
>   */
>  #define	MPSC_RXR_ENTRIES	32
> -#define	MPSC_RXRE_SIZE		dma_get_cache_alignment()
> +#define	MPSC_RXRE_SIZE		dma_get_cache_alignment(dma_dev)

I would much prefer that you add a parameter to the macro to avoid forcing
a non-flexible and non-obvious variable definition wherever it is used.
What I mean is something like:

#define MPSC_RXRE_SIZE(d)		dma_get_cache_alignment(d)

Similarly for all of the other macros and where they're used.

Thanks,

Mark
--
