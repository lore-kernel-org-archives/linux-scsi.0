From: Ching Huang <ching2048@areca.com.tw>
Subject: Re: [PATCH 2/3] scsi: arcmsr: Fix suspend/resume of
 ACB_ADAPTER_TYPE_B part 2
Date: Thu, 17 Jan 2019 17:52:28 +0800
Message-ID: <1547718748.5079.34.camel@Centos6.3-64>
References: <1547696703.4339.21.camel@Centos6.3-64>
         <20190117070227.GM4504@kadam> <1547714827.5079.19.camel@Centos6.3-64>
         <20190117091646.GA11828@kadam>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190117091646.GA11828@kadam>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hch@infradead.org, colin.king@canonical.com
List-Id: linux-scsi@vger.kernel.org

On Thu, 2019-01-17 at 12:16 +0300, Dan Carpenter wrote:
> On Thu, Jan 17, 2019 at 04:47:07PM +0800, Ching Huang wrote:
> > On Thu, 2019-01-17 at 10:59 +0300, Dan Carpenter wrote:
> > > On Thu, Jan 17, 2019 at 11:45:03AM +0800, Ching Huang wrote:
> > > > >From Ching Huang <ching2048@areca.com.tw>
> > > > 
> > > > Fix suspend/resume of ACB_ADAPTER_TYPE_B part 2.
> > > > 
> > > 
> > > What does this look like from a user perspective?  Does it fail every
> > > time or does it only fail sometimes?
> > > 
> > > What's the bug exactly?
> > > 
> > > There is no Fixes tag...
> > >From user's perspective, hibernate/resume are OK.
> > But following IO may cause 'isr get an illegal ccb command' in
> > log/messages sometime.
> > > 
> 
> 
> You will need to resend with that information included in the commit
> message.
OK. I will resend this patch later.
> 
> > > > Signed-off-by: Ching Huang <ching2048@areca.com.tw>
> > > > ---
> > > > 
> > > > diff --git a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
> > > > index a94c513..b98c632 100755
> > > > --- a/drivers/scsi/arcmsr/arcmsr.h
> > > > +++ b/drivers/scsi/arcmsr/arcmsr.h
> > > > @@ -508,9 +508,9 @@ struct MessageUnit_A
> > > >  struct MessageUnit_B
> > > >  {
> > > >  	uint32_t	post_qbuffer[ARCMSR_MAX_HBB_POSTQUEUE];
> > > > -	uint32_t	done_qbuffer[ARCMSR_MAX_HBB_POSTQUEUE];
> > > > +	volatile uint32_t	done_qbuffer[ARCMSR_MAX_HBB_POSTQUEUE];
> > > 
> > > There is a well known rule of thumb that when someone uses "volatile"
> > > in the kernel it means there is a locking problem...  Is this __iomem or
> > > something?
> > The done_qbuffer was a command completion queue, it was an area written
> > by IO processor and read by device driver. So, ...
> 
> I'm not totally positive I understand this sentence.  I can find a bunch
> of places which read from this buffer, but I haven't immediately found
> which place writes to it.  Can you give me a function name that I should
> read?
Well, we allocate memory for struct MessageUnit_B in
arcmsr_alloc_ccb_pool(), by assign to acb->dma_coherent_handle2.
Then we tell IO controller its DMA address in arcmsr_iop_confirm().
When a command was completed, controller's firmware program will write a
completion ccb in done_qbuffer through DMA. So, you can't see any driver
funtion write to it.
> 
> > > 
> > > >  	uint32_t	postq_index;
> > > > -	uint32_t	doneq_index;
> > > > +	volatile uint32_t	doneq_index;
> 
> The volatile here is not right.  It's just normal memory.
Right. this volatile is not necessary.
> 
> regards,
> dan carpenter
