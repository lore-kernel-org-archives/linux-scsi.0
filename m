From: Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: Re: [PATCH] scsi: ufs: Consider device limitations for dma_mask
Date: Mon, 14 Jan 2019 12:23:55 -0800
Message-ID: <20190114202355.GB9278@minitux>
References: <20190111225402.6133-1-bjorn.andersson@linaro.org>
 <20190114111109.GA18673@infradead.org>
 <20190114173051.GA9278@minitux>
 <20190114173659.GA17788@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190114173659.GA17788@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, Douglas Anderson <dianders@chromium.org>
List-Id: linux-scsi@vger.kernel.org

On Mon 14 Jan 09:36 PST 2019, Christoph Hellwig wrote:

> On Mon, Jan 14, 2019 at 09:30:51AM -0800, Bjorn Andersson wrote:
> > The problem here is that the capability bit states that the controller
> > itself claim to be able to deal with 64-bit addresses, which is probably
> > true. The thing that the struct device represents (the integrated
> > controller, on a bus in this SoC) doesn't.
> > 
> > The device model accurately handles this and carries a dma_mask that's
> > appropriate for the device in this system - the capability is not.
> > 
> > > You either need to introduce a quirk or a way to communicate the
> > > different limit so that it can be set by the core.
> > 
> > The system's limit is already communicated in hba->dev->dma_mask, but
> > the ufshcd driver overwrites this. I expect that this would make sense
> > if the device model claims we can do e.g. 40 bit addressing, but the
> > 64-bit capability is not set in the controller - in which case ufshcd
> > would accurately lower this to 32-bits.
> 
> No, that is absolutely not true.  dev->dma_mask is set by the driver
> to what the driver based on the device specsheet/register claims to
> support.  dev->bus_dma_mask contains any additional limits imposed
> by the bus/system, but that is handled transparently by the dma mapping
> code.

You're right and I see now that my bus_dma_mask is not set properly and
is the cause of the problem.

Thanks for correcting me, I fully agree with your NACK now.

Regards,
Bjorn
