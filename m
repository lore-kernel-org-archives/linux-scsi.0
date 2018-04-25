From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 2/5] ide: kill ide_toggle_bounce
Date: Tue, 24 Apr 2018 20:02:56 -0600
Message-ID: <5aaca0d3-417f-57f3-969f-b4c777c3fd48@kernel.dk>
References: <20180424181625.22410-1-hch@lst.de>
 <20180424181625.22410-3-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180424181625.22410-3-hch@lst.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org, linux-block@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 4/24/18 12:16 PM, Christoph Hellwig wrote:
> ide_toggle_bounce did select various strange block bounce limits, including
> not bouncing at all as soon as an iommu is present in the system.  Given
> that the dma_map routines now handle any required bounce buffering except
> for ISA DMA, and the ide code already must handle either ISA DMA or highmem
> at least for iommu equipped systems we can get rid of the block layer
> bounce limit setting entirely.

Pretty sure I was the one to add this code, when highmem page IO was
enabled about two decades ago...

Outside of DMA, the issue was that the PIO code could not handle
highmem. That's not the case anymore, so this should be fine.

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe
