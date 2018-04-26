From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH 2/5] ide: kill ide_toggle_bounce
Date: Thu, 26 Apr 2018 09:11:21 -0600
Message-ID: <682db9af-33bc-639d-8930-7a66c30bc644@kernel.dk>
References: <20180424181625.22410-1-hch@lst.de>
	<20180424181625.22410-3-hch@lst.de>
	<5aaca0d3-417f-57f3-969f-b4c777c3fd48@kernel.dk>
	<20180426072033.GA14700@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20180426072033.GA14700-jcswGhMUV9g@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 4/26/18 1:20 AM, Christoph Hellwig wrote:
> On Tue, Apr 24, 2018 at 08:02:56PM -0600, Jens Axboe wrote:
>> On 4/24/18 12:16 PM, Christoph Hellwig wrote:
>>> ide_toggle_bounce did select various strange block bounce limits, including
>>> not bouncing at all as soon as an iommu is present in the system.  Given
>>> that the dma_map routines now handle any required bounce buffering except
>>> for ISA DMA, and the ide code already must handle either ISA DMA or highmem
>>> at least for iommu equipped systems we can get rid of the block layer
>>> bounce limit setting entirely.
>>
>> Pretty sure I was the one to add this code, when highmem page IO was
>> enabled about two decades ago...
>>
>> Outside of DMA, the issue was that the PIO code could not handle
>> highmem. That's not the case anymore, so this should be fine.
> 
> Yes, that is the rationale.  Any chance to you could look over the
> other patches as well?  Except for the networking one for which I'd
> really like to see a review from Dave all the users of the interface
> are block related.

You can add my reviewed-by to 1-3, and 5. Looks good to me.

-- 
Jens Axboe
