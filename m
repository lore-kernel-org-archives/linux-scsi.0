From: Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: Re: [PATCH] scsi: ufs: Consider device limitations for dma_mask
Date: Mon, 14 Jan 2019 09:30:51 -0800
Message-ID: <20190114173051.GA9278@minitux>
References: <20190111225402.6133-1-bjorn.andersson@linaro.org>
 <20190114111109.GA18673@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190114111109.GA18673@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, Douglas Anderson <dianders@chromium.org>
List-Id: linux-scsi@vger.kernel.org

On Mon 14 Jan 03:11 PST 2019, Christoph Hellwig wrote:

> On Fri, Jan 11, 2019 at 02:54:02PM -0800, Bjorn Andersson wrote:
> >   */
> >  static int ufshcd_set_dma_mask(struct ufs_hba *hba)
> >  {
> > -	if (hba->capabilities & MASK_64_ADDRESSING_SUPPORT) {
> > -		if (!dma_set_mask_and_coherent(hba->dev, DMA_BIT_MASK(64)))
> > -			return 0;
> > -	}
> > -	return dma_set_mask_and_coherent(hba->dev, DMA_BIT_MASK(32));
> > +	u64 dma_mask = dma_get_mask(hba->dev);
> > +
> > +	if (hba->capabilities & MASK_64_ADDRESSING_SUPPORT)
> > +		dma_mask &= DMA_BIT_MASK(64);
> > +	else
> > +		dma_mask &= DMA_BIT_MASK(32);
> > +
> > +	return dma_set_mask_and_coherent(hba->dev, dma_mask);
> 
> NAK.  ufshcd clearly is in charge of setting the dma mask, so reading
> it back from someone else who might have set it is completely bogus.
> 

The problem here is that the capability bit states that the controller
itself claim to be able to deal with 64-bit addresses, which is probably
true. The thing that the struct device represents (the integrated
controller, on a bus in this SoC) doesn't.

The device model accurately handles this and carries a dma_mask that's
appropriate for the device in this system - the capability is not.

> You either need to introduce a quirk or a way to communicate the
> different limit so that it can be set by the core.

The system's limit is already communicated in hba->dev->dma_mask, but
the ufshcd driver overwrites this. I expect that this would make sense
if the device model claims we can do e.g. 40 bit addressing, but the
64-bit capability is not set in the controller - in which case ufshcd
would accurately lower this to 32-bits.


I'm not sure what to quirk here, but will look into this...

Regards,
Bjorn
