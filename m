From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH RESEND number 2] libata: eliminate the home grown dma
	padding in favour of that provided by the block layer
Date: Sun, 03 Feb 2008 10:12:36 -0600
Message-ID: <1202055156.3318.58.camel@localhost.localdomain>
References: <1199138168.3110.12.camel@localhost.localdomain>
	 <1200698057.3111.68.camel@localhost.localdomain>
	 <1201894847.3134.59.camel@localhost.localdomain>
	 <47A37AF3.3030503@garzik.org>
	 <1201900175.3134.67.camel@localhost.localdomain> <47A52F23.70506@gmail.com>
	 <1202013174.3187.69.camel@localhost.localdomain>
	 <47A56F2B.4040904@gmail.com>
	 <1202049511.3318.13.camel@localhost.localdomain>
	 <47A5DA5F.3070209@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <47A5DA5F.3070209@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, Jens Axboe <Jens.Axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2008-02-04 at 00:14 +0900, Tejun Heo wrote:
> James Bottomley wrote:
> > I'm reluctant to add another parameter to the request, but this one you
> > can calculate:  you just do it wherever you work out the size of the
> > request.  If data_len is the true data length and total_data_len is the
> > data length plus the drain length, the calculation fragment is
> > 
> > if (blk_pc_request(req))
> > 	data_len = req->data_len;
> > else
> > 	data_len = req->nr_sectors << 9;
> > total_data_len = data_len + req->q->dma_drain_size;
> > 
> > If the request has already been mapped by scsi, then data_len is
> > actually scsi_cmnd->sdb.length
> 
> We either need to add a field or a helper and rq->data_len should
> probably record the size with drain buffer attached and either add
> raw_data_len or blk_rq_raw_data_len().  That size is the length of data
> in sg and should be programmed into the controller etc... For ATAPI the
> raw size is only used to program the chunk size for odd devices.

OK, could you show me an example of where you need it and I'll come up
with the macro ... that should also help us decide whether it needs to
be in block or in libata alone.  Note that aic94xx only wants the true
size (we effectively treat the drain element as non existent), and I
anticipate this being true of most conforming implementations.  It's
only the problem HBAs that need to know how much slack they have for DMA
overruns.

> >> What's needed is updating libata accordingly and testing it.
> > 
> > Actually, I sent the patch to do this a few days ago:
> > 
> > http://marc.info/?l=linux-ide&m=120189565418258
> > 
> > But I've attached it again.
> 
> Thanks a lot.
> 
> >> I'm currently away from all my toys.  I'll implement the ATA part,
> >> test it and submit the patch on Monday.
> > 
> > Great, will look forward to the results.  Like I said, I think the turn
> > on draining in slave configure should be narrowed from all ATAPI devices
> > to all AHCI ATAPI devices if there's no evidence that any other
> > implementation that uses DMA to transfer PIO isn't similarly broken (I
> > know the aic94xx works fine, for instance ...
> 
> What do you mean by aic94xx working fine?  Does the controller
> automatically throw away extra data FISes?

The aic94xx sequencer has a very finely honed sense of DMA transfers.
It's fully automated, and handles both ATA DMA and ATA PIO in the
sequencer engine (so all the driver sees is DMA).

It reports both underrun and overrun conditions.  For DMA underrun
(device transfers less than expected, it just returns what it has and
how much was missing as the residual) for DMA overrun (as in device
tried to take more than it was programmed to send on either read or
write) for PIO it does seem to zero fill or discard and then simply
report task complete with overrun and let libsas sort it out.  I suspect
for DMA it first tries DMAT before taking other actions, but I'd need a
protocol analyser (or the sequencer docs) to be sure.

We handle overruns as error conditions in both SAS and ATA at the
moment, but the point is that the ATAPI device is fully happy and
quiesced when we do this.

James


