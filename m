From: "Jiang, Dave" <dave.jiang@intel.com>
Subject: RE: [PATCH v2 RESEND 10/23] isci: Use pci_enable_msix_exact()
 instead of pci_enable_msix()
Date: Mon, 11 Aug 2014 16:55:24 +0000
Message-ID: <112A412BB11A1242B37129D931BCE534694E0716@fmsmsx116.amr.corp.intel.com>
References: <cover.1405533479.git.agordeev@redhat.com>
 <24a4bb34f5a8b5ca964fb063688c24549e8a3b5d.1405533479.git.agordeev@redhat.com>
 <718e4066d6294033a7590659cf0f3c4d@fmsmsx106.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <718e4066d6294033a7590659cf0f3c4d@fmsmsx106.amr.corp.intel.com>
Content-Language: en-US
Sender: linux-pci-owner@vger.kernel.org
To: Alexander Gordeev <agordeev@redhat.com>, "Paszkiewicz, Artur" <artur.paszkiewicz@intel.com>
Cc: "Dorau, Lukasz" <lukasz.dorau@intel.com>, "Patelczyk, Maciej" <maciej.patelczyk@intel.com>, intel-linux-scu <intel-linux-scu@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Alexander Gordeev [mailto:agordeev@redhat.com]
> Sent: Monday, August 11, 2014 12:57 AM
> To: intel-linux-scu; Paszkiewicz, Artur; Jiang, Dave
> Cc: Dorau, Lukasz; Patelczyk, Maciej; intel-linux-scu; linux-
> scsi@vger.kernel.org; linux-pci@vger.kernel.org; Christoph Hellwig
> Subject: Re: [PATCH v2 RESEND 10/23] isci: Use pci_enable_msix_exact()
> instead of pci_enable_msix()
> 
> On Wed, Jul 16, 2014 at 08:05:14PM +0200, Alexander Gordeev wrote:
> > As result of deprecation of MSI-X/MSI enablement functions
> > pci_enable_msix() and pci_enable_msi_block() all drivers using these
> > two interfaces need to be updated to use the new
> > pci_enable_msi_range()  or pci_enable_msi_exact() and
> > pci_enable_msix_range() or pci_enable_msix_exact() interfaces.
> 
> Artur, Dave,
> 
> Could you please review isci patches in this series?
> 
> Thanks!

Sorry. For some reason my spam filter decided to pick this up. 

Acked-by: Dave Jiang <dave.jiang@intel.com>

 
> > Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> > Cc: Lukasz Dorau <lukasz.dorau@intel.com>
> > Cc: Maciej Patelczyk <maciej.patelczyk@intel.com>
> > Cc: Dave Jiang <dave.jiang@intel.com>
> > Cc: intel-linux-scu@intel.com
> > Cc: linux-scsi@vger.kernel.org
> > Cc: linux-pci@vger.kernel.org
> > Acked-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> > ---
> >  drivers/scsi/isci/init.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c index
> > 695b34e..4198e45 100644
> > --- a/drivers/scsi/isci/init.c
> > +++ b/drivers/scsi/isci/init.c
> > @@ -356,7 +356,7 @@ static int isci_setup_interrupts(struct pci_dev
> *pdev)
> >  	for (i = 0; i < num_msix; i++)
> >  		pci_info->msix_entries[i].entry = i;
> >
> > -	err = pci_enable_msix(pdev, pci_info->msix_entries, num_msix);
> > +	err = pci_enable_msix_exact(pdev, pci_info->msix_entries,
> num_msix);
> >  	if (err)
> >  		goto intx;
> >
> > --
> > 1.7.7.6
> >
