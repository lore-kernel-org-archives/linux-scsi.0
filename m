From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V3 10/15] scsi: aha152x: use sg helper to operate
 scatterlist
Date: Mon, 17 Jun 2019 09:14:27 +0800
Message-ID: <20190617011426.GB20122@ming.t460p>
References: <20190614025316.7360-1-ming.lei@redhat.com>
 <20190614025316.7360-11-ming.lei@redhat.com>
 <alpine.LNX.2.21.1906141404270.33@nippy.intranet>
 <20190614081732.GC24393@ming.t460p>
 <alpine.LNX.2.21.1906141931070.65@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.21.1906141931070.65@nippy.intranet>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Michael Schmitz <schmitzmic@gmail.com>, devel@driverdev.osuosl.org, Hannes Reinecke <hare@suse.com>, Benjamin Block <bblock@linux.ibm.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, James Smart <james.smart@broadcom.com>, "Ewan D . Milne" <emilne@redhat.com>, Jim Gill <jgill@vmware.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Brian King <brking@us.ibm.com>, "Juergen E . Fischer" <fischer@norbit.de>, Christoph Hellwig <hch@lst.de>, Dan Carpenter <dan.carpenter@oracle.com>, Bart Van Assche <bvanassche@acm.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jun 14, 2019 at 08:36:38PM +1000, Finn Thain wrote:
> On Fri, 14 Jun 2019, Ming Lei wrote:
> 
> > 
> > Follows the fixed version, could you review again?
> > 
> > From f03484d4bac083c39d70665cfbadb641093b63de Mon Sep 17 00:00:00 2001
> > From: Ming Lei <ming.lei@redhat.com>
> > Date: Wed, 12 Jun 2019 20:37:35 +0800
> > Subject: [PATCH] scsi: aha152x: use sg helper to operate scatterlist
> > 
> > Use the scatterlist iterators and remove direct indexing of the
> > scatterlist array.
> > 
> > This way allows us to pre-allocate one small scatterlist, which can be
> > chained with one runtime allocated scatterlist if the pre-allocated one
> > isn't enough for the whole request.
> > 
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >  drivers/scsi/aha152x.c | 34 ++++++++++++++++++++--------------
> >  1 file changed, 20 insertions(+), 14 deletions(-)
> > 
> > diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
> > index 97872838b983..7faecdefda56 100644
> > --- a/drivers/scsi/aha152x.c
> > +++ b/drivers/scsi/aha152x.c
> > @@ -2033,7 +2033,7 @@ static void datai_run(struct Scsi_Host *shpnt)
> >  				    CURRENT_SC->SCp.buffers_residual > 0) {
> >  					/* advance to next buffer */
> >  					CURRENT_SC->SCp.buffers_residual--;
> > -					CURRENT_SC->SCp.buffer++;
> > +					CURRENT_SC->SCp.buffer = sg_next(CURRENT_SC->SCp.buffer);
> >  					CURRENT_SC->SCp.ptr           = SG_ADDRESS(CURRENT_SC->SCp.buffer);
> >  					CURRENT_SC->SCp.this_residual = CURRENT_SC->SCp.buffer->length;
> >  				}
> > @@ -2139,7 +2139,7 @@ static void datao_run(struct Scsi_Host *shpnt)
> >  		if(CURRENT_SC->SCp.this_residual==0 && CURRENT_SC->SCp.buffers_residual>0) {
> >  			/* advance to next buffer */
> >  			CURRENT_SC->SCp.buffers_residual--;
> > -			CURRENT_SC->SCp.buffer++;
> > +			CURRENT_SC->SCp.buffer = sg_next(CURRENT_SC->SCp.buffer);
> >  			CURRENT_SC->SCp.ptr           = SG_ADDRESS(CURRENT_SC->SCp.buffer);
> >  			CURRENT_SC->SCp.this_residual = CURRENT_SC->SCp.buffer->length;
> >  		}
> > @@ -2158,22 +2158,28 @@ static void datao_run(struct Scsi_Host *shpnt)
> >  static void datao_end(struct Scsi_Host *shpnt)
> >  {
> >  	if(TESTLO(DMASTAT, DFIFOEMP)) {
> > -		int data_count = (DATA_LEN - scsi_get_resid(CURRENT_SC)) -
> > -			GETSTCNT();
> > +		int done = GETSTCNT();
> > +		int data_count = (DATA_LEN - scsi_get_resid(CURRENT_SC)) - done;
> 
> I think that's better than my suggestion.
> 
> > +		struct scatterlist *sg = scsi_sglist(CURRENT_SC);
> > +		int i;
> >  
> >  		CMD_INC_RESID(CURRENT_SC, data_count);
> >  
> > -		data_count -= CURRENT_SC->SCp.ptr -
> > -			SG_ADDRESS(CURRENT_SC->SCp.buffer);
> > -		while(data_count>0) {
> > -			CURRENT_SC->SCp.buffer--;
> > -			CURRENT_SC->SCp.buffers_residual++;
> > -			data_count -= CURRENT_SC->SCp.buffer->length;
> > +		/*
> > +		 * rewind where we have done, and we have to start from
> > +		 * the beginning
> > +		 */
> 
> How about, "Locate the first SG entry not yet sent".

OK.

> 
> We could use sg_nents_for_len() but it returns a count of sg entries not a 
> scatterlist pointer so it's not very helpful here.
> 
> > +		for (i = 0; done > 0 && !sg_is_last(sg); i++, sg = sg_next(sg)) {
> > +			if (done < sg->length)
> > +				break;
> > +			done -= sg->length;
> >  		}
> > -		CURRENT_SC->SCp.ptr = SG_ADDRESS(CURRENT_SC->SCp.buffer) -
> > -			data_count;
> > -		CURRENT_SC->SCp.this_residual = CURRENT_SC->SCp.buffer->length +
> > -			data_count;
> > +
> > +		CURRENT_SC->SCp.buffers_residual = i;
> 
> Contradicting my previous email, that's still not right. I think it would 
> have to be,
> 
> 		CURRENT_SC->SCp.buffers_residual = scsi_sg_count(CURRENT_SC) - i;

Right, my fault.

> 
> But we could remove all references to SCp.buffers_residual, like I did in 
> patch 15/15 for NCR5380.c.
> 
> > +		CURRENT_SC->SCp.buffer = sg;
> > +		CURRENT_SC->SCp.ptr = SG_ADDRESS(CURRENT_SC->SCp.buffer) + done;
> > +		CURRENT_SC->SCp.this_residual = CURRENT_SC->SCp.buffer->length -
> > +			done;
> >  	}
> >  
> >  	SETPORT(SXFRCTL0, CH1|CLRCH1|CLRSTCNT);
> > 
> 
> What do you think of the revised patch below?

Looks fine, I will include it in V4.

Thanks,
Ming
