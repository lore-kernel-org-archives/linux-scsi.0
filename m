From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] Revert "genirq/affinity: assign vectors to all possible
 CPUs"
Date: Mon, 15 Oct 2018 15:21:42 +0200
Message-ID: <20181015132142.GA389@kroah.com>
References: <f5c57bf7-b8c1-a560-d13a-d74e0f27adbb@molgen.mpg.de>
 <20180811135021.GA2186@kroah.com>
 <20180813033157.GA18254@ming.t460p>
 <89f2b622-3d2a-04ce-a6d1-ffb5d9612763@molgen.mpg.de>
 <cbd7cb64-dbfe-e085-e80b-67dad4084d69@molgen.mpg.de>
 <7c51fe1d-d591-90f2-8fb5-81990f8db0fe@molgen.mpg.de>
 <20181001123508.GA3415@lst.de>
 <f5dde120-2d14-a7e5-8402-401f117b8c38@molgen.mpg.de>
 <3480086a-1a3e-adc2-e127-8e34178da101@molgen.mpg.de>
 <6b7555c7-8796-eae9-6bd2-b698ccf9559d@molgen.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6b7555c7-8796-eae9-6bd2-b698ccf9559d@molgen.mpg.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Menzel <pmenzel+linux-scsi@molgen.mpg.de>
Cc: Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>, stable@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, it+linux-scsi@molgen.mpg.de, Adaptec OEM Raid Solutions <aacraid@microsemi.com>, linux-scsi@vger.kernel.org, Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, Dave Carroll <david.carroll@microsemi.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 15, 2018 at 02:17:11PM +0200, Paul Menzel wrote:
> Dear Greg, dear Linux folks,
> 
> 
> On 10/01/18 17:59, Paul Menzel wrote:
> 
> > On 10/01/18 14:43, Paul Menzel wrote:
> > 
> >> On 10/01/18 14:35, Christoph Hellwig wrote:
> >>> On Mon, Oct 01, 2018 at 02:33:07PM +0200, Paul Menzel wrote:
> >>>> Date: Wed, 29 Aug 2018 17:28:45 +0200
> >>>>
> >>>> This reverts commit ef86f3a72adb8a7931f67335560740a7ad696d1d.
> >>>
> >>> This seems rather odd.  If at all you'd revert the patch adding the
> >>> PCI_IRQ_AFFINITY to aacraid, not core infrastructure.
> >>
> >> Thank you for the suggestion, but that flag was added in 2016
> >> to the aacraid driver.
> >>
> >>> commit 0910d8bbdd99856af1394d3d8830955abdefee4a
> >>> Author: Hannes Reinecke <hare@suse.de>
> >>> Date:   Tue Nov 8 08:11:30 2016 +0100
> >>>
> >>>     scsi: aacraid: switch to pci_alloc_irq_vectors
> >>>     
> >>>     Use pci_alloc_irq_vectors and drop the hand-crafted interrupt affinity
> >>>     routines.
> >>
> >> So what would happen, if `PCI_IRQ_AFFINITY` was removed? Will the
> >> system still work with the same performance?
> >>
> >> As far as I understood, the no regression policy is there for
> >> exactly that reason, and it shouldn’t matter if it’s core
> >> infrastructure or not. As written, I have no idea, and just know
> >> reverting the commit in question fixes the problem here. So I’ll
> >> gladly test other solutions to fix this issue.
> > 
> > Just as another datapoint, with `PCI_IRQ_AFFINITY` removed from
> > `drivers/scsi/aacraid/comminit.c` in Linux 4.14.73, the driver
> > initializes correctly. I have no idea regarding the performance.
> 
> This commit has not been picked up yet. I guess, you are busy, but
> in case there are still objections, it’d be great if the two
> questions below were answered.
> 
> 1.  What bug is fixed in the LTS series by backporting the commit
>     causing the regression?

I can't remember anymore, but unwinding this mess is going to be a pain :(

> 2.  Why does the *no regression* policy *not* apply in this case?

It does, but also we are following the "stick to what mainline does",
and the fact that this is not showing up in mainline seems just to be a
lucky accident at the moment.  My real worry is that suddenly you are
going to have problems there and that this is just the early-warning
system happening...

thanks,

greg k-h
