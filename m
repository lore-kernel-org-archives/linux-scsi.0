From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH RFC 0/4] use scatter lists for all block pc
	requests and simplify hw handlers
Date: Tue, 07 Jun 2005 07:20:01 -0500
Message-ID: <1118146802.4998.3.camel@mulgrave>
References: <1117847972.23638.62.camel@mina> <1117901234.5005.9.camel@mulgrave>
	<20050607121020.GA6458@infradead.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050607121020.GA6458@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>, device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@suse.de>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2005-06-07 at 13:10 +0100, Christoph Hellwig wrote:
> shouldn't blk_rq_map_kern handle a 0 buffer and do nothing more than
> blk_get_request?  It's not exactly a criticial fastpath and that would make life
> easier for the callers.

Yes ... and it should probably do bio bouncing as well, since there's
nothing special we have to do on completion to clean it up.

I also think we might need a blk_rq_kern_iovec call that would take a
vector of user I/O's and map it to a multiple bio request.  This would
allow me to strip all of the user mapping out of sg, and also allow the
block layer SG_IO to pick up this API (currently it returns -ENOTSUPP if
you try it).

> > +		if (req->rq_disk) {
> > +			drv = *(struct scsi_driver **)req->rq_disk->private_data;
> > +			if (unlikely(!drv->init_command(cmd))) {
> > +				scsi_release_buffers(cmd);
> > +				scsi_put_command(cmd);
> > +				return BLKPREP_KILL;
> > +			}
> > +		} else {
> > +			memcpy(cmd->cmnd, req->cmd, sizeof(cmd->cmnd));
> > +			if (rq_data_dir(req) == WRITE)
> > +				cmd->sc_data_direction = DMA_TO_DEVICE;
> > +			else if (req->data_len)
> > +				cmd->sc_data_direction = DMA_FROM_DEVICE;
> > +			else
> > +				cmd->sc_data_direction = DMA_NONE;
> > +			
> > +			cmd->transfersize = req->data_len;
> > +			cmd->allowed = 3;
> > +			cmd->timeout_per_command = req->timeout;
> 
> most of this could probably be done in the midlayer always instead of the
> upper drivers.

I don't think so ... this is all struct scsi_cmnd handling.  SCSI needs
to allocate and process its internal command structures.

However, I think we have a case for the number of retries being carried
by the generic request structure.

James
