From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] libata: rewrite SCSI host scheme to be one per ATA host
Date: Thu, 23 Apr 2009 18:09:00 +0000
Message-ID: <1240510141.3514.22.camel@mulgrave.int.hansenpartnership.com>
References: <20090422090929.GA14928@havoc.gtf.org>
	 <da824cf30904221208l42e41d38g5af52b1b3b5ea9a1@mail.gmail.com>
	 <49F04A66.4080303@garzik.org>
	 <da824cf30904231059v64328d47qa9e535ee194e65e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55221 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754175AbZDWSJB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Apr 2009 14:09:01 -0400
In-Reply-To: <da824cf30904231059v64328d47qa9e535ee194e65e@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@google.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

On Thu, 2009-04-23 at 10:59 -0700, Grant Grundler wrote:
> > As to benefits, the phrase "more natural" means the code naturally aligns
> > with existing object topologies (ata_host becomes analagous to Scsi_Host),
> > which always has a long list of technical benefits.
> >
> > - we get to remove all the ugly hacks currently in place that assume
> > ata_port is _the_ first class object.
> > - we get to remove all the workarounds where SCSI assumes it manipulates all
> > devices on a controller (not true in current libata)
> > - SCSI (soon block) host-wide busy, block etc functionality now works as
> > expected
> > - it makes the libata conversion from SCSI to block layer easier
> > - it makes integration with SAS+SATA devices such as mvsas or ipr easier
> > - the list goes on; that is just off the top of my head, before my morning
> > Mountain Dew
> 
> Your initial list is good. In particular the issue around "SCSI Host-wide busy"
> working as expected. Of all the things listed, this is the only one that *I* can
> clearly identify as a user visible functional change.
> 
> I'm not familiar with the the "workarounds where SCSI assumes it manipulates
> all devices on a controller" issue. The few SATA controllers I've looked at can
> deal with each port independently - e.g.  discovery and phy reset. Anyway, this
> seems to be closely tied with "SCSI Host-wide Busy".
> 
> One reason I was thinking of NOT list above: "wide port" in SAS 2.0 controllers.
> aka "port aggregation". E.g. http://www.pmc-sierra.com/products/details/pm8005/
> 
> To change port aggregation on the fly requires the SCSI host controller to be
> manageable object. This should be a change in transport and not a change
> in devices available....and there are some other problems with implementing
> this but this is the main one I initially see.

This isn't really a correct assessment.  Wide ports are a SAS only
problem.  So sas has phys and ports ... and it's the port (essentially a
virtual object) that communicates in the link diagram.

A wide port has two or more phys in it.  You can see the handling of
this in libsas and the sas transport class today, but it's all handled
in a fashion completely invisible to the SCSI mid layer ... it's an
inessential abstraction, if you will.

James


