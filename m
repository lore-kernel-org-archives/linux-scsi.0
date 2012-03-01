From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v8 09/13] libsas: enforce eh strategy handlers only in
 eh context
Date: Thu, 01 Mar 2012 08:29:11 -0600
Message-ID: <1330612151.2888.10.camel@dabdike.int.hansenpartnership.com>
References: <20120210084411.25701.94502.stgit@dwillia2-linux.jf.intel.com>
	 <20120210084525.25701.51128.stgit@dwillia2-linux.jf.intel.com>
	 <1330553151.8846.26.camel@dabdike>
	 <CABE8wwuM1Hd9jTh+i63cZ=Fsf=c5Uwa6w0Rk+REsraxwEdZdYg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CABE8wwuM1Hd9jTh+i63cZ=Fsf=c5Uwa6w0Rk+REsraxwEdZdYg@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2012-02-29 at 16:28 -0800, Dan Williams wrote:
> On Wed, Feb 29, 2012 at 2:05 PM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > On Fri, 2012-02-10 at 00:45 -0800, Dan Williams wrote:
> >> The strategy handlers may be called in places that are problematic for
> >> libsas (i.e. sata resets outside of domain revalidation filtering /
> >> libata link recovery), or problematic for userspace (non-blocking ioctl
> >> to sleeping reset functions).  However, these routines are also called
> >> for eh escalations and recovery of scsi_eh_prep_cmnd(), so permit them
> >> as long as we are running in the host's error handler.
> >>
> >> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> >> ---
> >>  drivers/scsi/libsas/sas_scsi_host.c |   15 +++++++++++----
> >>  1 files changed, 11 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
> >> index f0b9b7b..1cabedc 100644
> >> --- a/drivers/scsi/libsas/sas_scsi_host.c
> >> +++ b/drivers/scsi/libsas/sas_scsi_host.c
> >> @@ -463,11 +463,14 @@ EXPORT_SYMBOL_GPL(sas_get_local_phy);
> >>  /* Attempt to send a LUN reset message to a device */
> >>  int sas_eh_device_reset_handler(struct scsi_cmnd *cmd)
> >>  {
> >> -     struct domain_device *dev = cmd_to_domain_dev(cmd);
> >> -     struct sas_internal *i =
> >> -             to_sas_internal(dev->port->ha->core.shost->transportt);
> >> -     struct scsi_lun lun;
> >>       int res;
> >> +     struct scsi_lun lun;
> >> +     struct Scsi_Host *host = cmd->device->host;
> >> +     struct domain_device *dev = cmd_to_domain_dev(cmd);
> >> +     struct sas_internal *i = to_sas_internal(host->transportt);
> >> +
> >> +     if (current != host->ehandler)
> >> +             return FAILED;
> >
> > Doing this will ensure that SG_SCSI_RESET now fails.
> >
> > I don't mind checking for O_NONBLOCK in the sg handler and failing if it
> > is, but disallowing everything looks a trifle drastic.
> >
> 
> The thought process here was following the lead of libata which does
> not specify eh_reset handlers.  We can't permit "unmanaged" (outside
> of eh) resets to hit ata devices otherwise we run the risk of a reset
> turning into a link bounce / hotplug.
> 
> ...and I can't take the same route as I did for the scsi_transport_sas
> initiated reset since these handlers are called from both ioctl and eh
> context, or can I?
> 
> Hmm, what about something like:
> 
>   if (current != host->ehandler) {
>     schedule_reset_to_run_in_eh_context():
>     wait_for_eh();
>   } else
>     do_reset();

I think that would work for me ... as long as the wait doesn't cause
entangled deadlocks (I can't think of any at the moment, but I'll think
a bit more deeply about it).

James


