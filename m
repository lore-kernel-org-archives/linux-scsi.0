From: Alexander Gordeev <agordeev@redhat.com>
Subject: Re: [PATCH v2 RESEND 13/23] megaraid: Fail resume if MSI-X
 re-initialization failed
Date: Mon, 11 Aug 2014 10:07:16 +0200
Message-ID: <20140811080714.GH16504@dhcp-27-160.brq.redhat.com>
References: <cover.1405533479.git.agordeev@redhat.com>
 <3d2402ebfad625e508bb13257e1560abf92594cd.1405533479.git.agordeev@redhat.com>
 <20140726082408.GG21129@agordeev.usersys.redhat.com>
 <3b7c554551d306e2f58f5e09dc171db2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3b7c554551d306e2f58f5e09dc171db2@mail.gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Kashyap Desai <kashyap.desai@avagotech.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jul 28, 2014 at 11:26:13AM +0530, Kashyap Desai wrote:
> > -----Original Message-----
> > From: Alexander Gordeev [mailto:agordeev@redhat.com]
> > Sent: Saturday, July 26, 2014 1:54 PM
> > To: linux-kernel@vger.kernel.org; Neela Syam Kolli
> > Subject: Re: [PATCH v2 RESEND 13/23] megaraid: Fail resume if MSI-X re-
> > initialization failed
> >
> > On Wed, Jul 16, 2014 at 08:05:17PM +0200, Alexander Gordeev wrote:
> > > Currently the driver fails to analize MSI-X re-enablement status on
> > > resuming and always assumes the success. This update checks the MSI-X
> > > initialization result and fails to resume if MSI-Xs re-enablement
> > > failed.
> >
> > Hi Neela,
> >
> > Could you please review megaraid patches in this series?
> >
> > Thanks!
> Please consider this patch Acked by Me.
> 
> Acked-by: Kashyap Desai <Kashyap.desai@avagotech.com>

Christoph,

I guess, this patch could be picked?

> >
> > > Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> > > ---
> > >  drivers/scsi/megaraid/megaraid_sas_base.c |    8 +++++---
> > >  1 files changed, 5 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
> > > b/drivers/scsi/megaraid/megaraid_sas_base.c
> > > index 112799b..ba06102 100644
> > > --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> > > +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> > > @@ -5134,9 +5134,10 @@ megasas_resume(struct pci_dev *pdev)
> > >  		goto fail_ready_state;
> > >
> > >  	/* Now re-enable MSI-X */
> > > -	if (instance->msix_vectors)
> > > -		pci_enable_msix(instance->pdev, instance->msixentry,
> > > -				instance->msix_vectors);
> > > +	if (instance->msix_vectors &&
> > > +	    pci_enable_msix(instance->pdev, instance->msixentry,
> > > +			    instance->msix_vectors))
> > > +		goto fail_reenable_msix;
> > >
> > >  	switch (instance->pdev->device) {
> > >  	case PCI_DEVICE_ID_LSI_FUSION:
> > > @@ -5245,6 +5246,7 @@ fail_init_mfi:
> > >
> > >  fail_set_dma_mask:
> > >  fail_ready_state:
> > > +fail_reenable_msix:
> > >
> > >  	pci_disable_device(pdev);
> > >
> > > --
> > > 1.7.7.6
> > >
> >
> > --
> > Regards,
> > Alexander Gordeev
> > agordeev@redhat.com
