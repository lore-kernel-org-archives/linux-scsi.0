From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 1/3] scsi_cmnd: Introduce scsi_transfer_length helper
Date: Tue, 24 Jun 2014 09:27:32 -0700
Message-ID: <20140624162732.GA7837@infradead.org>
References: <1402477799-24610-1-git-send-email-sagig@mellanox.com>
 <1402477799-24610-2-git-send-email-sagig@mellanox.com>
 <53A920B2.9060503@cs.wisc.edu>
 <yq1mwd2h3ju.fsf@sermon.lab.mkp.net>
 <28678EBD-1AE9-48F9-B9E2-E6A61B042BB1@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <28678EBD-1AE9-48F9-B9E2-E6A61B042BB1@cs.wisc.edu>
Sender: target-devel-owner@vger.kernel.org
To: Michael Christie <michaelc@cs.wisc.edu>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, nab@linux-iscsi.org, roland@kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jun 24, 2014 at 11:08:54AM -0500, Michael Christie wrote:
> > static inline unsigned scsi_transfer_length(struct scsi_cmnd *scmd)
> > {
> > -	unsigned int xfer_len = blk_rq_bytes(scmd->request);
> > +	unsigned int xfer_len = scsi_out(scmd)->length;
> > 	unsigned int prot_op = scsi_get_prot_op(scmd);
> > 	unsigned int sector_size = scmd->device->sector_size;
> 
> 
> Do we need to check for the data direction. Something like
> 
> if (scmd->sc_data_direction == DMA_TO_DEVICE)
> 	xfer_len = scsi_out(scmnd)->length;
> else
> 	xfer_len = scsi_in(scmnd)->length;

For non-bidi commands those are the same, but I suspect we'd need
something like that for bidi commands.
