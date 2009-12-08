From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [GIT PATCH] SCSI fixes for 2.6.32-rc8
Date: Tue, 08 Dec 2009 12:00:25 -0600
Message-ID: <1260295225.4147.25.camel@mulgrave.site>
References: <1259620194.11762.137.camel@mulgrave.site>
	 <1259687627.11762.307.camel@mulgrave.site>
	 <20091201091832.418d5fca@jbarnes-piketon> <200912012240.48249.rjw@sisk.pl>
	 <20091201141035.2c0165df@jbarnes-piketon>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49647 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965721AbZLHSA2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Dec 2009 13:00:28 -0500
In-Reply-To: <20091201141035.2c0165df@jbarnes-piketon>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-pci@vger.kernel.org

On Tue, 2009-12-01 at 14:10 -0800, Jesse Barnes wrote:
> On Tue, 1 Dec 2009 22:40:48 +0100
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Tuesday 01 December 2009, Jesse Barnes wrote:
> > > On Tue, 01 Dec 2009 12:13:47 -0500
> > > James Bottomley <James.Bottomley@suse.de> wrote:
> > > 
> > > > On Tue, 2009-12-01 at 14:54 -0200, Kleber Sacilotto de Souza
> > > > wrote:
> > > > > Can you please add the patch from "[PATCH] ipr: fix EEH
> > > > > recovery" sent to this list?
> > > > 
> > > > Adding linux-pci because this hack actually tampers with internal
> > > > PCI device state, which looks wrong.
> > > > 
> > > > The thread is here:
> > > > 
> > > > http://marc.info/?l=linux-scsi&m=125918723218627
> > > > 
> > > > and the proposed full patch and explanation below.
> > > > 
> > > > PCI people, is this correct, or is there a better way to do it?
> > > > 
> > > > James
> > > > 
> > > > ---
> > > > 
> > > > Hi,
> > > > 
> > > > After commits c82f63e411f1b58427c103bd95af2863b1c96dd1 (PCI: check
> > > > saved state before restore) and
> > > > 4b77b0a2ba27d64f58f16d8d4d48d8319dda36ff (PCI: Clear saved_state
> > > > after the state has been restored) PCI drivers are prevented from
> > > > restoring the device standard configuration registers twice in a
> > > > row. These changes introduced a regression on ipr EEH recovery.
> > > > 
> > > > The ipr device driver saves the PCI state only during the device
> > > > probe and restores it on ipr_reset_restore_cfg_space() during IOA
> > > > resets. This behavior is causing the EEH recovery to fail after
> > > > the second error detected, since the registers are not being
> > > > restored.
> > > > 
> > > > One possible solution would be saving the registers after
> > > > restoring them. The problem with this approach is that while
> > > > recovering from an EEH error if pci_save_state() results in an
> > > > EEH error, the adapter/slot will be reset, and end up back in
> > > > ipr_reset_restore_cfg_space(), but it won't have a valid saved
> > > > state to restore, so pci_restore_state() will fail.
> > > > 
> > > > The following patch introduces a workaround for this problem,
> > > > hacking around the PCI API by setting pdev->state_saved = true
> > > > before we do the restore. It fixes the EEH regression and
> > > > prevents that we hit another EEH error during EEH recovery.
> > > > 
> > > > 
> > > > Thanks,
> > > > Kleber
> > > > 
> > > > 
> > > > 
> > > > Signed-off-by: Kleber Sacilotto de Souza
> > > > <klebers@linux.vnet.ibm.com> ---
> > > >  drivers/scsi/ipr.c |    1 +
> > > >  1 files changed, 1 insertions(+), 0 deletions(-)
> > > > 
> > > > diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
> > > > index 76d294f..c3ff9a6 100644
> > > > --- a/drivers/scsi/ipr.c
> > > > +++ b/drivers/scsi/ipr.c
> > > > @@ -6516,6 +6516,7 @@ static int
> > > > ipr_reset_restore_cfg_space(struct ipr_cmnd *ipr_cmd)
> > > >         int rc;
> > > >  
> > > >         ENTER;
> > > > +       ioa_cfg->pdev->state_saved = true;
> > > >         rc = pci_restore_state(ioa_cfg->pdev);
> > > >  
> > > >         if (rc != PCIBIOS_SUCCESSFUL) {
> > > 
> > > Rafael may have input here, but it seems like we need a low level
> > > save/restore routine that ignores the flag (which is generally used
> > > for suspend/resume I think?).
> > 
> > There are some other users, but they are only a few.
> > 
> > > Maybe adding low level _pci_save_state/_pci_restore_state that don't
> > > check/set the flags would help?
> > 
> > That might work, but how do we know that the state we're going to
> > restore is actually valid at this particular point?
> > 
> > Perhaps we need a version using a separate storage area?
> 
> Yeah, that would probably be best.  Let the caller allocate the space
> and save/restore it all it wants for special cases like error handling.

OK, so could I have a resolution for this, please, guys?

Do I just apply the patch to fiddle with the internal state which looks
ugly but will fix the bug, or are you going to provide us with the
correct interface to use?

James



