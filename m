From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [for 4.1 PATCH resend] libsas: fix "sysfs group not found"
 warnings at port teardown time
Date: Mon, 27 Jul 2015 10:11:09 -0700
Message-ID: <1438017069.5441.42.camel@HansenPartnership.com>
References: <20150618032204.29990.87007.stgit@dwillia2-desk3.amr.corp.intel.com>
	 <1437589687.2171.44.camel@HansenPartnership.com>
	 <CAPcyv4hTVCKU+SVAPPrne_EKuGdzuZjhpgpte26FVcCYT6_8wQ@mail.gmail.com>
	 <1438010252.5441.21.camel@HansenPartnership.com>
	 <CAPcyv4irtD_JgXEVkvhNak3s61kJCVzKADJ2s=nOsrT0qtzjXA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <CAPcyv4irtD_JgXEVkvhNak3s61kJCVzKADJ2s=nOsrT0qtzjXA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Praveen Murali <pmurali@logicube.com>, linux-scsi <linux-scsi@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2015-07-27 at 08:48 -0700, Dan Williams wrote:
> On Mon, Jul 27, 2015 at 8:17 AM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > On Wed, 2015-07-22 at 14:08 -0700, Dan Williams wrote:
> >> On Wed, Jul 22, 2015 at 11:28 AM, James Bottomley
> >> <James.Bottomley@hansenpartnership.com> wrote:
> >> >
> >> >>  }
> >> >>
> >> >>  void sas_device_set_phy(struct domain_device *dev, struct sas_port *port)
> >> >> diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas_port.c
> >> >> index d3c5297c6c89..9a25ae3a52a4 100644
> >> >> --- a/drivers/scsi/libsas/sas_port.c
> >> >> +++ b/drivers/scsi/libsas/sas_port.c
> >> >> @@ -219,7 +219,6 @@ void sas_deform_port(struct asd_sas_phy *phy, int gone)
> >> >>
> >> >>       if (port->num_phys == 1) {
> >> >>               sas_unregister_domain_devices(port, gone);
> >> >> -             sas_port_delete(port->port);
> >> >>               port->port = NULL;
> >> >>       } else {
> >> >>               sas_port_delete_phy(port->port, phy->phy);
> >> >>
> >> >
> >> > This should become
> >> >
> >> > if (port->num_phys == 1)
> >> >         sas_unregister_domain_device(port, gone);
> >> >
> >> > sas_port_delete_phy(port->port, phy->phy);
> >> >
> >> > So we end up with a port scheduled for destruction with no phys rather
> >> > than making the last phy association hang around until the DISCE
> >> > workqueue runs.
> >>
> >> Sounds ok in theory.
> >
> > It's not really a choice.  The specific problem you've introduced with
> > this patch is failure to cope with link flutter: a deform and form event
> > queued sequentially.  In the new scheme you're trying to introduce, the
> > destruct event gets queued from the deform but behind the form and the
> > link flutter results in a dead link.  I thought just forcing a zero phy
> > port would fix this, but it won't, either the destruct has to run in the
> > context of the deform event or the form has to be queued later than the
> > destruct.  I think coupled with the changes above, there needs to be
> >
> > if (port->port) {
> >         /* dying port, requeue form event */
> >         resend the PORTE_BYTES_DMAED event
> >         return
> > }
> >
> > inside the unmatched port loop in sas_port_form() if nothing is found as
> > well to close this.
> 
> I think it's too late.  Once the lldd has triggered libsas to start
> tear down I seem to recall the lldd has the expectation that a new
> PORTE_BYTES_DMAED triggers the creation of a new port instance for
> that phy.  Once the flutter reaches libsas the race is already lost
> and the port needs to be torn down, but I would need to take a closer
> look.

I don't understand your reasoning.  The expectation is that
PORTE_BYTES_DMAED leads to port formation.  The proposal detects that
this event precedes DISCE_DESTRUCT for the port and requeues the event,
now after DISC_DESTRUCT, so it gets acted on.  Where is the problem?

James
