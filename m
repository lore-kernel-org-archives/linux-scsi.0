From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH V2] PCI/portdrv: do not disable device on reboot/shutdown
Date: Thu, 24 May 2018 13:37:55 +0000
Message-ID: <36b790d3fb4c43349cfa560283c03ab5@microsemi.com>
References: <1527043490-17268-1-git-send-email-okaya@codeaurora.org>
 <20180523213249.GD150632@bhelgaas-glaptop.roam.corp.google.com>
 <61f70fd6-52fd-da07-ce73-303f95132131@codeaurora.org>
 <82656e20-e821-1944-3399-1667ceb27719@codeaurora.org>
 <20180524130727.GA85822@bhelgaas-glaptop.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180524130727.GA85822@bhelgaas-glaptop.roam.corp.google.com>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Bjorn Helgaas <helgaas@kernel.org>, Sinan Kaya <okaya@codeaurora.org>
Cc: "ryan@finnie.org" <ryan@finnie.org>, Kate Stewart <kstewart@linuxfoundation.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Frederick Lawler <fred@fredlawl.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "timur@codeaurora.org" <timur@codeaurora.org>, "Rafael J.
 Wysocki" <rafael.j.wysocki@intel.com>, "esc.storagedev" <esc.storagedev@microsemi.com>, open list <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, Dongdong Liu <liudongdong3@huawei.com>, "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, Thomas Gleixner <tglx@linutronix.de>, Mika Westerberg <mika.westerberg@linux.intel.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Bjorn Helgaas [mailto:helgaas@kernel.org]
> Sent: Thursday, May 24, 2018 8:07 AM
> To: Sinan Kaya <okaya@codeaurora.org>
> Cc: linux-pci@vger.kernel.org; timur@codeaurora.org; ryan@finnie.org; linux-
> arm-msm@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> stable@vger.kernel.org; Bjorn Helgaas <bhelgaas@google.com>; Rafael J.
> Wysocki <rafael.j.wysocki@intel.com>; Greg Kroah-Hartman
> <gregkh@linuxfoundation.org>; Thomas Gleixner <tglx@linutronix.de>; Kate
> Stewart <kstewart@linuxfoundation.org>; Frederick Lawler
> <fred@fredlawl.com>; Dongdong Liu <liudongdong3@huawei.com>; Mika
> Westerberg <mika.westerberg@linux.intel.com>; open list <linux-
> kernel@vger.kernel.org>; Don Brace <don.brace@microsemi.com>;
> esc.storagedev <esc.storagedev@microsemi.com>; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH V2] PCI/portdrv: do not disable device on reboot/shutdown
> 
> EXTERNAL EMAIL
> 
> 
> On Thu, May 24, 2018 at 07:43:05AM -0400, Sinan Kaya wrote:
> > On 5/23/2018 6:57 PM, Sinan Kaya wrote:
> > >> The crash seems to indicate that the hpsa device attempted a DMA after
> > >> we cleared the Root Port's PCI_COMMAND_MASTER, which means
> > >> hpsa_shutdown() didn't stop DMA from the device (it looks like *most*
> > >> shutdown methods don't disable device DMA, so it's in good company).
> > > All drivers are expected to shutdown DMA and interrupts in their shutdown()
> > > routines. They can skip removing threads, data structures etc. but DMA and
> > > interrupt disabling are required. This is the difference between shutdown()
> > > and remove() callbacks.
> >
> > I found this note yesterday to see why we are not disabling the
> > devices in the PCI core itself.
> >
> > pci_device_remove()
> >
> >       /*
> >        * We would love to complain here if pci_dev->is_enabled is set, that
> >        * the driver should have called pci_disable_device(), but the
> >        * unfortunate fact is there are too many odd BIOS and bridge setups
> >        * that don't like drivers doing that all of the time.
> >        * Oh well, we can dream of sane hardware when we sleep, no matter how
> >        * horrible the crap we have to deal with is when we are awake...
> >        */
> >
> > Ryan, can you discard the previous patch and test this one instead?
> > remove() path in hpsa driver seems to call pci_disable_device() via
> >
> > hpsa_remove_one()
> >       hpsa_free_pci_init()
> >
> > but nothing on the shutdown path.
> >
> > diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> > index 4ed3d26..3823f04 100644
> > --- a/drivers/scsi/hpsa.c
> > +++ b/drivers/scsi/hpsa.c
> > @@ -8651,6 +8651,7 @@ static void hpsa_shutdown(struct pci_dev *pdev)
> >         h->access.set_intr_mask(h, HPSA_INTR_OFF);
> >         hpsa_free_irqs(h);                      /* init_one 4 */
> >         hpsa_disable_interrupt_mode(h);         /* pci_init 2 */
> > +       pci_disable_device(h->pdev);
> >  }
> 
> I suspect this will make things "work" (if the device can't attempt
> DMA, no Unsupported Request error will occur).
> 
> But I'm concerned that the reason for the DMA might that hpsa is
> transferring buffers from system memory to the hpsa device, and if we
> arbitrarily terminate those transfers with pci_disable_device(), we
> may leave the hpsa device in an inconsistent state, e.g., with a dirty
> filesystem.
> 
> But we really need guidance from an hpsa expert.  I don't know the
> filesystem/SCSI/hpsa details.
> 
> Bjorn

It's most likely OCSD traffic that will stop when bus mastering is turned off.
So, I'll run some tests on my end before ACKing your patch.

Thanks,
Don Brace
ESC - Smart Storage
Microsemi Corporation
