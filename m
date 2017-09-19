From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: aacraid: Add a small delay after IOP reset
Date: Tue, 19 Sep 2017 10:05:36 -0700
Message-ID: <1505840736.2971.12.camel@HansenPartnership.com>
References: <20170919151156.29412-1-gpiccoli@linux.vnet.ibm.com>
         <20170919153712.GA15496@infradead.org>
         <6958d5da-8f9a-ff6b-ccea-16c335b24530@linux.vnet.ibm.com>
         <20170919155222.GA24688@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170919155222.GA24688@infradead.org>
Sender: stable-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>
Cc: aacraid@microsemi.com, linux-scsi@vger.kernel.org, RaghavaAditya.Renukunta@microsemi.com, david.carroll@microsemi.com, brking@linux.vnet.ibm.com, dougmill@linux.vnet.ibm.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2017-09-19 at 08:52 -0700, Christoph Hellwig wrote:
> On Tue, Sep 19, 2017 at 12:49:21PM -0300, Guilherme G. Piccoli wrote:
> > 
> > On 09/19/2017 12:37 PM, Christoph Hellwig wrote:
> > > 
> > > On Tue, Sep 19, 2017 at 12:11:55PM -0300, Guilherme G. Piccoli
> > > wrote:
> > > > 
> > > >  	src_writel(dev, MUnit.IDR, IOP_SRC_RESET_MASK);
> > > > +
> > > > +	msleep(5000);
> > > 
> > > src_writel is a writel, and thus a posted MMIO write.  You'll
> > > need
> > > to have to a read first to make it a reliable timing base.
> > > 
> > 
> > Just for my full understanding - you're saying a readl BEFORE
> > src_writel() or AFTER src_writel() ?
> 
> AFTER.

Actually, the whole problem sounds like a posted write.  Likely the
write that causes the reset doesn't get flushed until the read checking
if the reset has succeeded, which might explain the 100% initial
failure.  Why not throw away that first value if it's a failure and
then do your polled wait and timeout on the reset success.  We should
anyway be waiting some time for a reset to be issued, so even on non-
posted write systems we could see this problem intermittently.

James
