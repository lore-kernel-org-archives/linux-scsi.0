From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [for 4.1 PATCH resend] libsas: fix "sysfs group not found"
 warnings at port teardown time
Date: Mon, 27 Jul 2015 08:17:32 -0700
Message-ID: <1438010252.5441.21.camel@HansenPartnership.com>
References: <20150618032204.29990.87007.stgit@dwillia2-desk3.amr.corp.intel.com>
	 <1437589687.2171.44.camel@HansenPartnership.com>
	 <CAPcyv4hTVCKU+SVAPPrne_EKuGdzuZjhpgpte26FVcCYT6_8wQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50875 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753255AbbG0PRg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Jul 2015 11:17:36 -0400
In-Reply-To: <CAPcyv4hTVCKU+SVAPPrne_EKuGdzuZjhpgpte26FVcCYT6_8wQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Praveen Murali <pmurali@logicube.com>, linux-scsi <linux-scsi@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>

On Wed, 2015-07-22 at 14:08 -0700, Dan Williams wrote:
> On Wed, Jul 22, 2015 at 11:28 AM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> >
> >>  }
> >>
> >>  void sas_device_set_phy(struct domain_device *dev, struct sas_port *port)
> >> diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas_port.c
> >> index d3c5297c6c89..9a25ae3a52a4 100644
> >> --- a/drivers/scsi/libsas/sas_port.c
> >> +++ b/drivers/scsi/libsas/sas_port.c
> >> @@ -219,7 +219,6 @@ void sas_deform_port(struct asd_sas_phy *phy, int gone)
> >>
> >>       if (port->num_phys == 1) {
> >>               sas_unregister_domain_devices(port, gone);
> >> -             sas_port_delete(port->port);
> >>               port->port = NULL;
> >>       } else {
> >>               sas_port_delete_phy(port->port, phy->phy);
> >>
> >
> > This should become
> >
> > if (port->num_phys == 1)
> >         sas_unregister_domain_device(port, gone);
> >
> > sas_port_delete_phy(port->port, phy->phy);
> >
> > So we end up with a port scheduled for destruction with no phys rather
> > than making the last phy association hang around until the DISCE
> > workqueue runs.
> 
> Sounds ok in theory.

It's not really a choice.  The specific problem you've introduced with
this patch is failure to cope with link flutter: a deform and form event
queued sequentially.  In the new scheme you're trying to introduce, the
destruct event gets queued from the deform but behind the form and the
link flutter results in a dead link.  I thought just forcing a zero phy
port would fix this, but it won't, either the destruct has to run in the
context of the deform event or the form has to be queued later than the
destruct.  I think coupled with the changes above, there needs to be

if (port->port) {
	/* dying port, requeue form event */
	resend the PORTE_BYTES_DMAED event
	return
}

inside the unmatched port loop in sas_port_form() if nothing is found as
well to close this.

>   I don't have a libsas environment handy, I worked with Praveen to
> validate the version as submitted if you want to re-work it.

A couple of days ago, this was so urgent as to have to go outside the
usual patch process ... now it's not important enough for you to bother
working on it; which is it?

James


