From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH RFC 0/4] use scatter lists for all block pc
	requests and simplify hw handlers
Date: Tue, 7 Jun 2005 13:10:20 +0100
Message-ID: <20050607121020.GA6458@infradead.org>
References: <1117847972.23638.62.camel@mina> <1117901234.5005.9.camel@mulgrave>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1117901234.5005.9.camel@mulgrave>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@suse.de>
List-Id: linux-scsi@vger.kernel.org

On Sat, Jun 04, 2005 at 11:07:14AM -0500, James Bottomley wrote:
> +	if (bufflen)
> +		req = blk_rq_map_kern(sreq->sr_device->request_queue,
> +				      sreq->sr_data_direction == DMA_TO_DEVICE,
> +				      buffer, bufflen, __GFP_WAIT);
> +	else
> +		req = blk_get_request(sreq->sr_device->request_queue, READ,
> +				      __GFP_WAIT);

shouldn't blk_rq_map_kern handle a 0 buffer and do nothing more than
blk_get_request?  It's not exactly a criticial fastpath and that would make life
easier for the callers.

> +		if (req->rq_disk) {
> +			drv = *(struct scsi_driver **)req->rq_disk->private_data;
> +			if (unlikely(!drv->init_command(cmd))) {
> +				scsi_release_buffers(cmd);
> +				scsi_put_command(cmd);
> +				return BLKPREP_KILL;
> +			}
> +		} else {
> +			memcpy(cmd->cmnd, req->cmd, sizeof(cmd->cmnd));
> +			if (rq_data_dir(req) == WRITE)
> +				cmd->sc_data_direction = DMA_TO_DEVICE;
> +			else if (req->data_len)
> +				cmd->sc_data_direction = DMA_FROM_DEVICE;
> +			else
> +				cmd->sc_data_direction = DMA_NONE;
> +			
> +			cmd->transfersize = req->data_len;
> +			cmd->allowed = 3;
> +			cmd->timeout_per_command = req->timeout;

most of this could probably be done in the midlayer always instead of the
upper drivers.
