From: Ching Huang <ching2048@areca.com.tw>
Subject: Re: [PATCH 2/3] scsi: arcmsr: Fix suspend/resume of
 ACB_ADAPTER_TYPE_B part 2
Date: Thu, 17 Jan 2019 16:47:07 +0800
Message-ID: <1547714827.5079.19.camel@Centos6.3-64>
References: <1547696703.4339.21.camel@Centos6.3-64>
         <20190117070227.GM4504@kadam>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190117070227.GM4504@kadam>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hch@infradead.org, colin.king@canonical.com
List-Id: linux-scsi@vger.kernel.org

On Thu, 2019-01-17 at 10:59 +0300, Dan Carpenter wrote:
> On Thu, Jan 17, 2019 at 11:45:03AM +0800, Ching Huang wrote:
> > >From Ching Huang <ching2048@areca.com.tw>
> > 
> > Fix suspend/resume of ACB_ADAPTER_TYPE_B part 2.
> > 
> 
> What does this look like from a user perspective?  Does it fail every
> time or does it only fail sometimes?
> 
> What's the bug exactly?
> 
> There is no Fixes tag...
>From user's perspective, hibernate/resume are OK.
But following IO may cause 'isr get an illegal ccb command' in
log/messages sometime.
> 
> > Signed-off-by: Ching Huang <ching2048@areca.com.tw>
> > ---
> > 
> > diff --git a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
> > index a94c513..b98c632 100755
> > --- a/drivers/scsi/arcmsr/arcmsr.h
> > +++ b/drivers/scsi/arcmsr/arcmsr.h
> > @@ -508,9 +508,9 @@ struct MessageUnit_A
> >  struct MessageUnit_B
> >  {
> >  	uint32_t	post_qbuffer[ARCMSR_MAX_HBB_POSTQUEUE];
> > -	uint32_t	done_qbuffer[ARCMSR_MAX_HBB_POSTQUEUE];
> > +	volatile uint32_t	done_qbuffer[ARCMSR_MAX_HBB_POSTQUEUE];
> 
> There is a well known rule of thumb that when someone uses "volatile"
> in the kernel it means there is a locking problem...  Is this __iomem or
> something?
The done_qbuffer was a command completion queue, it was an area written
by IO processor and read by device driver. So, ...
> 
> >  	uint32_t	postq_index;
> > -	uint32_t	doneq_index;
> > +	volatile uint32_t	doneq_index;
> >  	uint32_t	__iomem *drv2iop_doorbell;
> >  	uint32_t	__iomem *drv2iop_doorbell_mask;
> >  	uint32_t	__iomem *iop2drv_doorbell;
> > diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
> > index 5736434..88053b1 100755
> > --- a/drivers/scsi/arcmsr/arcmsr_hba.c
> > +++ b/drivers/scsi/arcmsr/arcmsr_hba.c
> > @@ -1113,7 +1113,11 @@ static int arcmsr_resume(struct pci_dev *pdev)
> >  	switch (acb->adapter_type) {
> >  	case ACB_ADAPTER_TYPE_B: {
> >  		struct MessageUnit_B *reg = acb->pmuB;
> > -		reg->post_qbuffer[0] = 0;
> > +		uint32_t i;
> > +		for (i = 0; i < ARCMSR_MAX_HBB_POSTQUEUE; i++) {
> > +			reg->post_qbuffer[i] = 0;
> > +			reg->done_qbuffer[i] = 0;
> > +		}
> 
> Is this cause by patch 1 changing the zalloc to regular alloc??  If so
> then it should be folded into that patch instead of sent separately.
These fully clear delivery and completion queues are for fixing 
'isr get an illegal ccb command'. It is nothing related to Zalloc or alloc.
> 
> regards,
> dan carpenter
> 
> 
