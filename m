From: Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH 3/7] scsi: Drop runtime PM usage count after host is added
Date: Fri, 19 Feb 2016 10:18:04 +0200
Message-ID: <20160219081804.GC1491@lahna.fi.intel.com>
References: <1455785657-22924-1-git-send-email-mika.westerberg@linux.intel.com>
 <1455785657-22924-4-git-send-email-mika.westerberg@linux.intel.com>
 <CAGRGNgUzUDWQ3jDfUuaf8x4G_zsZYe1p2=e_kDR4FkcMp5bUvg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGRGNgUzUDWQ3jDfUuaf8x4G_zsZYe1p2=e_kDR4FkcMp5bUvg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Julian Calaby <julian.calaby@gmail.com>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Feb 19, 2016 at 09:50:50AM +1100, Julian Calaby wrote:
> Hi Mika,
> 
> On Thu, Feb 18, 2016 at 7:54 PM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> > Runtime PM of the SCSI host is already handled by calls to
> > scsi_autopm_get_host() and scsi_autopm_put_host() from appropriate places
> > whenever the host needs to be powered on. This works fine when there is
> > device connected to the host as once it runtime suspends the host will too.
> >
> > However, if there is no device connected the host is never runtime
> > suspended (the usage counter is always 0).
> >
> > Allow runtime suspend of host even if it has no devices connected by
> > calling scsi_autopm_put_host() at the end of scsi_add_host_with_dma(). We
> > temporarily increase runtime PM usage counter first so call to
> > scsi_autopm_put_host() will result idle request to be scheduled for the
> > device.
> >
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > ---
> >  drivers/scsi/hosts.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> > index 82ac1cd818ac..e46bf4d152a0 100644
> > --- a/drivers/scsi/hosts.c
> > +++ b/drivers/scsi/hosts.c
> > @@ -250,6 +250,12 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
> >         if (error)
> >                 goto out_destroy_freelist;
> >
> > +       /*
> > +        * Increase usage count temporarily here so that calling
> > +        * scsi_autopm_put_host() will trigger runtime idle if there is
> > +        * nothing else preventing suspending the device.
> > +        */
> > +       pm_runtime_get_noresume(&shost->shost_gendev);
> >         pm_runtime_set_active(&shost->shost_gendev);
> >         pm_runtime_enable(&shost->shost_gendev);
> >         device_enable_async_suspend(&shost->shost_gendev);
> > @@ -290,6 +296,7 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
> >                 goto out_destroy_host;
> >
> >         scsi_proc_host_add(shost);
> > +       scsi_autopm_put_host(shost);
> 
> Would it be cleaner to export the code that runs when the usage
> counter decrements and call it here?

There actually is no code to run. This just ensures that the device
runtime_idle gets called which allows the parent device to runtime
suspend (as it returns 0). Alternative way would be just to call
pm_request_idle() directly here.
