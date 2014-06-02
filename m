From: scameron@beardog.cce.hp.com
Subject: Re: [PATCH 2 08/24] hpsa: choose number of reply queues more intelligently.
Date: Mon, 2 Jun 2014 10:00:36 -0500
Message-ID: <20140602150036.GI6970@beardog.cce.hp.com>
References: <20140529154739.8180.50710.stgit@beardog.cce.hp.com> <20140529155302.8180.17597.stgit@beardog.cce.hp.com> <20140602092751.GA30545@infradead.org> <20140602145206.GH6970@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140602145206.GH6970@beardog.cce.hp.com>
Sender: linux-pci-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: james.bottomley@parallels.com, webb.scales@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, justin.lindley@hp.com, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com, hch@lst.de, dan.carpenter@oracle.com, linux-pci@vger.kernel.org, scameron@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 02, 2014 at 09:52:06AM -0500, scameron@beardog.cce.hp.com wrote:
> On Mon, Jun 02, 2014 at 02:27:51AM -0700, Christoph Hellwig wrote:
> > On Thu, May 29, 2014 at 10:53:02AM -0500, Stephen M. Cameron wrote:
> > > From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> > > 
> > > No sense having 8 or 16 reply queues if you only have 4 cpus,
> > > and likewise no sense limiting to 8 reply queues if you have
> > > many more cpus.
> > 
> > I've applied this as it looks good as-is, but shouldn't we also
> > cap the number of MSI-X vectors in common code so that we avoid
> > adding this as boilerplate code to lots of drivers?
> 
> Maybe so.  Thinking about CPU hotplug, is num_online_cpus()
> the right cap?  Maybe num_possible_cpus() is better in case
> additional cpus coming online are anticipated?

On second thought, might there be PCI devices which have multiple
MSIX vectors to signal different things?  I know for smart array
the idea has occasionally been floated to have an additional vector
to signal something to the host that is not a command completion,
although we never implemented such a thing.  Had we done so,
we would then need num_online_cpus() + 1 vectors.

So maybe it's not a good idea to put such a limit in the generic
pci code in case some device works in such a way.

-- steve


> 
> > 
> > > 
> > > Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> > > Reviewed-by: Mike Miller <michael.miller@canonical.com>
> > > Reviewed-by: Scott Teel <scott.teel@hp.com>
> > > ---
> > >  drivers/scsi/hpsa.c     |    2 ++
> > >  drivers/scsi/hpsa_cmd.h |    2 +-
> > >  2 files changed, 3 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> > > index b1ecfd8..b903e86 100644
> > > --- a/drivers/scsi/hpsa.c
> > > +++ b/drivers/scsi/hpsa.c
> > > @@ -6157,6 +6157,8 @@ static void hpsa_interrupt_mode(struct ctlr_info *h)
> > >  	if (pci_find_capability(h->pdev, PCI_CAP_ID_MSIX)) {
> > >  		dev_info(&h->pdev->dev, "MSIX\n");
> > >  		h->msix_vector = MAX_REPLY_QUEUES;
> > > +		if (h->msix_vector > num_online_cpus())
> > > +			h->msix_vector = num_online_cpus();
> > >  		err = pci_enable_msix(h->pdev, hpsa_msix_entries,
> > >  				      h->msix_vector);
> > >  		if (err > 0) {
> > > diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
> > > index db89245..104b67b 100644
> > > --- a/drivers/scsi/hpsa_cmd.h
> > > +++ b/drivers/scsi/hpsa_cmd.h
> > > @@ -615,7 +615,7 @@ struct TransTable_struct {
> > >  	u32            RepQCount;
> > >  	u32            RepQCtrAddrLow32;
> > >  	u32            RepQCtrAddrHigh32;
> > > -#define MAX_REPLY_QUEUES 8
> > > +#define MAX_REPLY_QUEUES 64
> > >  	struct vals32  RepQAddr[MAX_REPLY_QUEUES];
> > >  };
> > >  
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > ---end quoted text---
