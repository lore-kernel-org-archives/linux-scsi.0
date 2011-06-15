From: Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH] drivers/scsi/ipr.c: reorder error handling code to
 include iounmap
Date: Wed, 15 Jun 2011 10:50:51 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.1106151050430.10106@ask.diku.dk>
References: <1306851409-14963-1-git-send-email-julia@diku.dk>
 <4DF0EC00.9020603@linux.vnet.ibm.com> <4DF787BC.8050701@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4DF787BC.8050701@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: Wayne Boyer <wayneb@linux.vnet.ibm.com>, Brian King <brking@us.ibm.com>, kernel-janitors@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 14 Jun 2011, Brian King wrote:

> On 06/09/2011 10:51 AM, Wayne Boyer wrote:
> > On 05/31/2011 07:16 AM, Julia Lawall wrote:
> >> From: Julia Lawall <julia@diku.dk>
> >>
> >> The out_msi_disable label should be before cleanup_nomem to additionally
> >> benefit from the call to iounmap.
> > 
> > Yes, this is a problem.  I propose the following patch instead.
> 
> By removing the out_msi_disable label, if you fail initialization later
> on and goto cleanup_nomem, you will end up leaving MSI enabled when you exit
> with this patch.

I agree.

julia

> -Brian
> 
> 
> 
> > 
> > ---
> > 
> > In the case where ipr_test_msi returns an error that is not -EOPNOTSUPP, the
> > execution jumps to the out_msi_disable label.  This misses the call to iounmap
> > for ipr_regs which was initialized earlier.
> > 
> > The fix is to do the call to pci_disable_msi when the error case is detected
> > and then goto the cleanup_nomem label if the error is not -EOPNOTSUPP.
> > 
> > Signed-off-by: Wayne Boyer <wayneb@linux.vnet.ibm.com>
> > ---
> > 
> >  drivers/scsi/ipr.c |   10 ++++------
> >  1 file changed, 4 insertions(+), 6 deletions(-)
> > 
> > Index: b/drivers/scsi/ipr.c
> > ===================================================================
> > --- a/drivers/scsi/ipr.c        2011-06-09 08:14:44.927740117 -0700
> > +++ b/drivers/scsi/ipr.c        2011-06-09 08:50:10.105630466 -0700
> > @@ -8763,11 +8763,11 @@ static int __devinit ipr_probe_ioa(struc
> >         /* Enable MSI style interrupts if they are supported. */
> >         if (ioa_cfg->ipr_chip->intr_type == IPR_USE_MSI && !pci_enable_msi(pdev)) {
> >                 rc = ipr_test_msi(ioa_cfg, pdev);
> > -               if (rc == -EOPNOTSUPP)
> > +               if (rc) {
> >                         pci_disable_msi(pdev);
> > -               else if (rc)
> > -                       goto out_msi_disable;
> > -               else
> > +                       if (rc != -EOPNOTSUPP)
> > +                               goto cleanup_nomem;
> > +               } else
> >                         dev_info(&pdev->dev, "MSI enabled with IRQ: %d\n", pdev->irq);
> >         } else if (ipr_debug)
> >                 dev_info(&pdev->dev, "Cannot enable MSI.\n");
> > @@ -8847,8 +8847,6 @@ cleanup_nolog:
> >         ipr_free_mem(ioa_cfg);
> >  cleanup_nomem:
> >         iounmap(ipr_regs);
> > -out_msi_disable:
> > -       pci_disable_msi(pdev);
> >  out_release_regions:
> >         pci_release_regions(pdev);
> >  out_scsi_host_put:
> > 
> > 
> 
> 
> -- 
> Brian King
> Linux on Power Virtualization
> IBM Linux Technology Center
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
