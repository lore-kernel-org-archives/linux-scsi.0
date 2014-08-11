From: Alexander Gordeev <agordeev@redhat.com>
Subject: Re: [PATCH v2 RESEND 08/23] hpsa: Fallback to MSI rather than to
 INTx if MSI-X failed
Date: Mon, 11 Aug 2014 09:53:20 +0200
Message-ID: <20140811075320.GE16504@dhcp-27-160.brq.redhat.com>
References: <cover.1405533479.git.agordeev@redhat.com>
 <3ca64c251518a2db8810534b4e63ec696bcfeefd.1405533479.git.agordeev@redhat.com>
 <20140726081647.GE21129@agordeev.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140726081647.GE21129@agordeev.usersys.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>, iss_storagedev@hp.com, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Jul 26, 2014 at 09:16:47AM +0100, Alexander Gordeev wrote:
> On Wed, Jul 16, 2014 at 08:05:12PM +0200, Alexander Gordeev wrote:
> > Currently the driver falls back to INTx mode when MSI-X
> > initialization failed. This is a suboptimal behaviour
> > for chips that also support MSI. This update changes that
> > behaviour and falls back to MSI mode in case MSI-X mode
> > initialization failed.
> 
> Hi Stephen,
> 
> Could you please reveiew hpsa patches in this series?

Stephen?

> Thanks!
> 
> > Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> > Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
> > Cc: iss_storagedev@hp.com
> > Cc: linux-scsi@vger.kernel.org
> > Cc: linux-pci@vger.kernel.org
> > ---
> >  drivers/scsi/hpsa.c |    1 -
> >  1 files changed, 0 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> > index 31184b3..648dec2 100644
> > --- a/drivers/scsi/hpsa.c
> > +++ b/drivers/scsi/hpsa.c
> > @@ -6177,7 +6177,6 @@ static void hpsa_interrupt_mode(struct ctlr_info *h)
> >  			dev_warn(&h->pdev->dev, "MSI-X init failed %d\n",
> >  			       err);
> >  			h->msix_vector = 0;
> > -			goto default_int_mode;
> >  		}
> >  	}
> >  	if (pci_find_capability(h->pdev, PCI_CAP_ID_MSI)) {
> > -- 
> > 1.7.7.6
> > 
> 
> -- 
> Regards,
> Alexander Gordeev
> agordeev@redhat.com
