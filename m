From: James Bottomley <jejb@linux.ibm.com>
Subject: Re: [PATCH] scsi: mvumi: fix 32 bit shift of a 32 bit unsigned int
Date: Mon, 18 Feb 2019 07:32:05 -0800
Message-ID: <1550503925.2834.3.camel@linux.ibm.com>
References: <1596625925.142066.1550334436646@ox-groupware.bfs.de>
         <20190218093710.GB17104@kadam>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190218093710.GB17104@kadam>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, Walter Harms <wharms@bfs.de>
Cc: Colin King <colin.king@canonical.com>, Jianyun Li <jyli@marvell.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2019-02-18 at 12:37 +0300, Dan Carpenter wrote:
> On Sat, Feb 16, 2019 at 05:27:16PM +0100, Walter Harms wrote:
> > Am 16.02.2019 15:44, schrieb Colin King:
> > > From: Colin Ian King <colin.king@canonical.com>
> > > 
> > > Currently m_sg->baseaddr_h (a 32 bit unsigned int) is being
> > > shifted by a
> > > total of 32 bits; this always produces a 0 result.  Fix this by
> > > casting
> > > it to a dma_addr_t (a 64 bit unsigned int) before performing the
> > > shift.
> > > 
> > > Detected by CoverityScan, CID#147270 ("Operands don't affect
> > > result")
> > > 
> > > Fixes: f0c568a478f0 ("[SCSI] mvumi: Add Marvell UMI driver")
> > > Signed-off-by: Colin Ian King <colin.king@canonical.com>
> > > ---
> > >  drivers/scsi/mvumi.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
> > > index 36f64205ecfa..d3582accfd09 100644
> > > --- a/drivers/scsi/mvumi.c
> > > +++ b/drivers/scsi/mvumi.c
> > > @@ -313,7 +313,7 @@ static void mvumi_delete_internal_cmd(struct
> > > mvumi_hba
> > > *mhba,
> > >  			sgd_getsz(mhba, m_sg, size);
> > >  
> > >  			phy_addr = (dma_addr_t) m_sg->baseaddr_l 
> > > |
> > > -				(dma_addr_t) ((m_sg->baseaddr_h
> > > << 16) << 16);
> > > +				(((dma_addr_t) m_sg->baseaddr_h
> > > << 16) << 16);
> > >  
> > >  			dma_free_coherent(&mhba->pdev->dev,
> > > size, cmd->data_buf,
> > >  								
> > > phy_addr);
> > 
> > i would suggest to try a version with less casts to make it more
> > readable
> > like this untested suggestion:
> > 
> > phy_addr =(m_sg->baseaddr_h << 16)| m_sg->baseaddr_l;
> > phy_addr <<= 16;
> > 
> 
> That would be a behavior change but it also might be a bugfix?  Why
> doesn't the code just do:
> 
> 	phy_addr = ((dma_addr_t)m_sg->baseaddr_h << 32) | m_sg-
> >baseaddr_l;
> 
> (Probably they broke it up into two shifts to silence a GCC warning
> that the shift was wrong because of the missing cast?)

No because dma_addr_t can be 32 bits and the warning would then always
appear on some builds.  The << 16 << 16 makes sure it doesn't.

James
