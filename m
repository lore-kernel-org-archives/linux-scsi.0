From: James Bottomley <jejb@linux.ibm.com>
Subject: Re: [PATCH] scsi: advansys: use struct_size() in kzalloc()
Date: Fri, 11 Jan 2019 08:41:43 -0800
Message-ID: <1547224903.2793.10.camel@linux.ibm.com>
References: <20190104212209.GA15250@embeddedor>
         <05420a5c-c268-b87d-9d75-f5d18a4b7f7a@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <05420a5c-c268-b87d-9d75-f5d18a4b7f7a@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Matthew Wilcox <willy@infradead.org>, Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2019-01-11 at 16:46 +0100, Hannes Reinecke wrote:
> On 1/4/19 10:22 PM, Gustavo A. R. Silva wrote:
> > One of the more common cases of allocation size calculations is
> > finding the
> > size of a structure that has a zero-sized array at the end, along
> > with memory
> > for some number of elements for that array. For example:
> > 
> > struct foo {
> >      int stuff;
> >      void *entry[];
> > };
> > 
> > instance = kzalloc(sizeof(struct foo) + sizeof(void *) * count,
> > GFP_KERNEL);
> > 
> > Instead of leaving these open-coded and prone to type mistakes, we
> > can now
> > use the new struct_size() helper:
> > 
> > instance = kzalloc(struct_size(instance, entry, count),
> > GFP_KERNEL);
> > 
> > This code was detected with the help of Coccinelle.
> > 
> > Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> > ---
> >   drivers/scsi/advansys.c | 4 ++--
> >   1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
> > index d37584403c33..6c274e6e1c33 100644
> > --- a/drivers/scsi/advansys.c
> > +++ b/drivers/scsi/advansys.c
> > @@ -7576,8 +7576,8 @@ static int asc_build_req(struct asc_board
> > *boardp, struct scsi_cmnd *scp,
> >   			return ASC_ERROR;
> >   		}
> >   
> > -		asc_sg_head = kzalloc(sizeof(asc_scsi_q->sg_head)
> > +
> > -			use_sg * sizeof(struct asc_sg_list),
> > GFP_ATOMIC);
> > +		asc_sg_head = kzalloc(struct_size(asc_sg_head,
> > sg_list, use_sg),
> > +				      GFP_ATOMIC);
> >   		if (!asc_sg_head) {
> >   			scsi_dma_unmap(scp);
> >   			scp->result = HOST_BYTE(DID_SOFT_ERROR);
> > 
> 
> If you want ...

Are we sure there's a benefit to this?  It's obvious that the current
code is correct but no-one's likely to test the new code for quite some
time, so changing the code introduces risk. What's the benefit of
making the change in legacy drivers?  Just because we have a new, shiny
macro doesn't mean we have to force its use everywhere.

I would recommend we have a rational needs test: so run the coccinelle
script over all the drivers to find out where this construct is used,
but only update those that are actually buggy with the new macro.

James
