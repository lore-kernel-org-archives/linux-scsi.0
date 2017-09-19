From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: aacraid: Add a small delay after IOP reset
Date: Tue, 19 Sep 2017 08:52:22 -0700
Message-ID: <20170919155222.GA24688@infradead.org>
References: <20170919151156.29412-1-gpiccoli@linux.vnet.ibm.com>
 <20170919153712.GA15496@infradead.org>
 <6958d5da-8f9a-ff6b-ccea-16c335b24530@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6958d5da-8f9a-ff6b-ccea-16c335b24530@linux.vnet.ibm.com>
Sender: stable-owner@vger.kernel.org
To: "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, aacraid@microsemi.com, linux-scsi@vger.kernel.org, RaghavaAditya.Renukunta@microsemi.com, david.carroll@microsemi.com, brking@linux.vnet.ibm.com, dougmill@linux.vnet.ibm.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 19, 2017 at 12:49:21PM -0300, Guilherme G. Piccoli wrote:
> On 09/19/2017 12:37 PM, Christoph Hellwig wrote:
> > On Tue, Sep 19, 2017 at 12:11:55PM -0300, Guilherme G. Piccoli wrote:
> >>  	src_writel(dev, MUnit.IDR, IOP_SRC_RESET_MASK);
> >> +
> >> +	msleep(5000);
> > 
> > src_writel is a writel, and thus a posted MMIO write.  You'll need
> > to have to a read first to make it a reliable timing base.
> > 
> 
> Just for my full understanding - you're saying a readl BEFORE
> src_writel() or AFTER src_writel() ?

AFTER.

> I could add a read to some dummy register, but notice it was a sequence
> of readl's on aac_is_ctrl_up_and_running() that caused the failure of
> reset...

Oh, ouch.  I guess in that case we'll need to do the writel and pray,
but that would need a big comment explaining what's going on there.
