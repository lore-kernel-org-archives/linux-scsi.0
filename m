From: Eddie Wai <eddie.wai@broadcom.com>
Subject: Re: [PATCH 2/2] bnx2fc: fix memory leak and potential NULL pointer
 dereference.
Date: Fri, 7 Mar 2014 15:27:51 -0800
Message-ID: <1394234871.8102.64.camel@lbirv-waie-lx2.broadcom.com>
References: <1394203066-13515-1-git-send-email-mlombard@redhat.com>
	 <1394203066-13515-3-git-send-email-mlombard@redhat.com>
	 <1394220105.8102.62.camel@lbirv-waie-lx2.broadcom.com>
	 <20140307232141.GA6097@dhcp-27-189.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:51543 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215AbaCGX3w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Mar 2014 18:29:52 -0500
In-Reply-To: <20140307232141.GA6097@dhcp-27-189.brq.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: linux-scsi@vger.kernel.org, jbottomley@parallels.com, m.lombardi85@gmail.com

On Sat, 2014-03-08 at 00:21 +0100, Maurizio Lombardi wrote:
> Hi Eddie,
> 
> On Fri, Mar 07, 2014 at 11:21:45AM -0800, Eddie Wai wrote:
> > Hello Maurizio,
> > 
> > Thanks for looking into this.  The patch looks good, but I would like to
> > extend it with the following allocation failure portion to completely
> > remove the memory leak.  Please incorporate this into your next
> > submission.
> 
> Thanks for the patch you sent,
> 
> maybe it is even better if I modify bnx2fc_allocate_hash_table() in such a way
> that, in case of error, it frees all the memory it has allocated.
> 
> Note that your patch does not free the table if
> "hba->hash_tbl_pbl = dma_alloc_coherent(...)" fails (line 2058).
> 
> It just requires a very little change to your patch, I'll send it tomorrow.
You're right, the hash_tbl_segments[i] entries will also need to be
freed upon the hash_tbl_pbl allocation failure.  Thanks again!
> 
> Regards,
> Maurizio Lombardi
> 
> > 
> > Thanks,
> > Eddie
> > 
> > @@ -2020,7 +2026,7 @@ static int bnx2fc_allocate_hash_table(struct
> > bnx2fc_hba *hba)
> >         dma_segment_array = kzalloc(dma_segment_array_size, GFP_KERNEL);
> >         if (!dma_segment_array) {
> >                 printk(KERN_ERR PFX "hash table pointers (dma) alloc
> > failed\n");
> > -               return -ENOMEM;
> > +               goto free_hash_tbl_seg;
> >         }
> > 
> >         for (i = 0; i < segment_count; ++i) {
> > @@ -2039,7 +2045,7 @@ static int bnx2fc_allocate_hash_table(struct
> > bnx2fc_hba *hba)
> >                                 hba->hash_tbl_segments[i] = NULL;
> >                         }
> >                         kfree(dma_segment_array);
> > -                       return -ENOMEM;
> > +                       goto free_hash_tbl_seg;
> >                 }
> >                 memset(hba->hash_tbl_segments[i], 0,
> >                        BNX2FC_HASH_TBL_CHUNK_SIZE);
> > @@ -2077,6 +2083,11 @@ static int bnx2fc_allocate_hash_table(struct
> > bnx2fc_hba *hba)
> >         }
> >         kfree(dma_segment_array);
> >         return 0;
> > +
> > +free_hash_tbl_seg:
> > +       kfree(hba->hash_tbl_segments);
> > +       hba->hash_tbl_segments = NULL;
> > +       return -ENOMEM;
> >  }
> > 
> > 
> > On Fri, 2014-03-07 at 15:37 +0100, Maurizio Lombardi wrote:
> > > If bnx2fc_allocate_hash_table() for some reasons fails, it is possible that the
> > > hash_tbl_segments or the hash_tbl_pbl pointers are NULL.
> > > In this case bnx2fc_free_hash_table() will panic the system.
> > > 
> > > this patch also fixes a memory leak, the hash_tbl_segments pointer was never
> > > freed.
> > > 
> > > Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> > > ---
> > >  drivers/scsi/bnx2fc/bnx2fc_hwi.c | 34 ++++++++++++++++++++--------------
> > >  1 file changed, 20 insertions(+), 14 deletions(-)
> > > 
> > > diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
> > > index 261af2a..f83bae4 100644
> > > --- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
> > > +++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
> > > @@ -1968,21 +1968,27 @@ static void bnx2fc_free_hash_table(struct bnx2fc_hba *hba)
> > >  	int segment_count;
> > >  	u32 *pbl;
> > >  
> > > -	segment_count = hba->hash_tbl_segment_count;
> > > -
> > > -	pbl = hba->hash_tbl_pbl;
> > > -	for (i = 0; i < segment_count; ++i) {
> > > -		dma_addr_t dma_address;
> > > -
> > > -		dma_address = le32_to_cpu(*pbl);
> > > -		++pbl;
> > > -		dma_address += ((u64)le32_to_cpu(*pbl)) << 32;
> > > -		++pbl;
> > > -		dma_free_coherent(&hba->pcidev->dev,
> > > -				  BNX2FC_HASH_TBL_CHUNK_SIZE,
> > > -				  hba->hash_tbl_segments[i],
> > > -				  dma_address);
> > > +	if (hba->hash_tbl_segments) {
> > > +
> > > +		pbl = hba->hash_tbl_pbl;
> > > +		if (pbl) {
> > > +			segment_count = hba->hash_tbl_segment_count;
> > > +			for (i = 0; i < segment_count; ++i) {
> > > +				dma_addr_t dma_address;
> > > +
> > > +				dma_address = le32_to_cpu(*pbl);
> > > +				++pbl;
> > > +				dma_address += ((u64)le32_to_cpu(*pbl)) << 32;
> > > +				++pbl;
> > > +				dma_free_coherent(&hba->pcidev->dev,
> > > +						  BNX2FC_HASH_TBL_CHUNK_SIZE,
> > > +						  hba->hash_tbl_segments[i],
> > > +						  dma_address);
> > > +			}
> > > +		}
> > >  
> > > +		kfree(hba->hash_tbl_segments);
> > > +		hba->hash_tbl_segments = NULL;
> > >  	}
> > >  
> > >  	if (hba->hash_tbl_pbl) {
> > 
> > 


